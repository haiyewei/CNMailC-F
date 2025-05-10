import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import '../database/mail_database.dart';

class AddMailCard extends StatefulWidget {
  final Function({bool saved})? onExit; // 修改 onExit 以接受参数
  const AddMailCard({super.key, this.onExit});

  @override
  State<AddMailCard> createState() => _AddMailCardState();
}

enum ServerType { imap, pop }

class _AddMailCardState extends State<AddMailCard> {
  final _formKey = GlobalKey<FormState>();

  final _emailAddressController = TextEditingController();
  final _aliasController = TextEditingController();
  final _passwordController = TextEditingController();

  Set<ServerType> _selectedServerType = {ServerType.imap};
  String _receiverDomainHintText = "例如：imap.example.com";
  String _receiverPortHintText = "例如：993 (SSL)";

  // Receiver Server Config
  final _receiverDomainController = TextEditingController();
  final _receiverPortController = TextEditingController();
  bool _isReceiverSsl = true;

  // SMTP Server Config (Simplified: not fully integrated into DB save as per instructions)
  final _smtpDomainController = TextEditingController();
  final _smtpPortController = TextEditingController();
  bool _isSmtpSsl = true;

  late AppDatabase _db;

  @override
  void initState() {
    super.initState();
    _db = AppDatabase();
    _updateHintTexts(); // Initialize hint texts
  }

  void _updateHintTexts() {
    if (_selectedServerType.first == ServerType.imap) {
      _receiverDomainHintText = "例如：imap.example.com";
      _receiverPortHintText = "例如：993 (SSL)";
    } else {
      _receiverDomainHintText = "例如：pop.example.com";
      _receiverPortHintText = "例如：995 (SSL)";
    }
  }

  @override
  void dispose() {
    _emailAddressController.dispose();
    _aliasController.dispose();
    _passwordController.dispose();
    _receiverDomainController.dispose();
    _receiverPortController.dispose();
    _smtpDomainController.dispose();
    _smtpPortController.dispose();
    // _db.close(); // Drift databases are typically managed at a higher level or kept open.
    super.dispose();
  }

  Future<void> _saveMailAccount() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final emailAddress = _emailAddressController.text;
      final alias = _aliasController.text.isEmpty ? null : _aliasController.text;
      final password = _passwordController.text;
      final serverTypeString = _selectedServerType.first == ServerType.imap ? 'IMAP' : 'POP';
      final domain = _receiverDomainController.text;
      final port = int.tryParse(_receiverPortController.text) ?? (_selectedServerType.first == ServerType.imap ? (_isReceiverSsl ? 993 : 143) : (_isReceiverSsl ? 995 : 110));
      final isSsl = _isReceiverSsl;

      // As per simplification, SMTP specific fields from UI are not directly mapped to separate DB columns here.
      // We are using the receiver server's config for the main DB entry.
      final mailAccountCompanion = MailAccountsCompanion(
        emailAddress: drift.Value(emailAddress),
        alias: drift.Value(alias),
        password: drift.Value(password),
        serverType: drift.Value(serverTypeString),
        domain: drift.Value(domain),
        port: drift.Value(port),
        isSsl: drift.Value(isSsl),
      );

      try {
        await _db.insertMailAccount(mailAccountCompanion);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('邮件账户已保存')),
        );
        _formKey.currentState!.reset();
        _emailAddressController.clear();
        _aliasController.clear();
        _passwordController.clear();
        _receiverDomainController.clear();
        _receiverPortController.clear();
        _smtpDomainController.clear();
        _smtpPortController.clear();
        setState(() {
          _selectedServerType = {ServerType.imap};
          _isReceiverSsl = true;
          _isSmtpSsl = true;
        });
        if (widget.onExit != null) {
          widget.onExit!(saved: true); // 传递保存成功状态
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('保存失败: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
      shadowColor: colorScheme.shadow.withAlpha((255 * 0.2).round()),
      surfaceTintColor: colorScheme.surfaceTint,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.all(16.0), // 与 EditMailCard 一致的内边距
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // 标题行
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Icon(Icons.add_circle_outline, color: colorScheme.primary, size: 28),
                  const SizedBox(width: 16),
                  Text(
                    '添加邮箱账户',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  if (widget.onExit != null)
                    IconButton( // 改为 IconButton 以便更紧凑
                      icon: Icon(Icons.close, color: colorScheme.onSurfaceVariant),
                      tooltip: '取消',
                      onPressed: () => widget.onExit!(saved: false), // 传递取消状态
                    ),
                    // ElevatedButton.icon(
                    //   icon: Icon(Icons.close, color: colorScheme.onError),
                    //   label: Text('退出', style: TextStyle(color: colorScheme.onError)),
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: colorScheme.error,
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(20),
                    //     ),
                    //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    //   ),
                    //   onPressed: () => widget.onExit!(saved: false), // 传递取消状态
                    // ),
                ],
              ),
            ),
            const SizedBox(height: 8.0),
            // const Divider(), // Removed Divider
            const SizedBox(height: 16), // 调整分隔符与主要内容的间距，比EditMailCard小一点，因为表单项本身有间距

            // 原有表单内容
            // Expanded removed to resolve unbounded height issue in SingleChildScrollView
            Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true, // Allow ListView to size itself to its content
                primary: false, // Prevent conflict with parent ScrollView
                children: <Widget>[
                  TextFormField(
                controller: _emailAddressController,
                decoration: const InputDecoration(labelText: '邮箱地址', border: InputBorder.none),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入邮箱地址';
                  }
                  if (!value.contains('@')) {
                    return '请输入有效的邮箱地址';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _aliasController,
                decoration: const InputDecoration(labelText: '邮箱别名 (可选)', border: InputBorder.none),
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: '邮箱密码', border: InputBorder.none),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入邮箱密码';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Text('接收服务器类型', style: Theme.of(context).textTheme.titleMedium),
              SegmentedButton<ServerType>(
                segments: const <ButtonSegment<ServerType>>[
                  ButtonSegment<ServerType>(
                    value: ServerType.pop,
                    label: Text('POP'),
                    icon: Icon(Icons.arrow_downward), // 示例图标
                  ),
                  ButtonSegment<ServerType>(
                    value: ServerType.imap,
                    label: Text('IMAP'),
                    icon: Icon(Icons.arrow_upward), // 示例图标
                  ),
                ],
                selected: _selectedServerType,
                onSelectionChanged: (Set<ServerType> newSelection) {
                  setState(() {
                    // SegmentedButton 允许多选，但我们这里只允许单选
                    if (newSelection.isNotEmpty) {
                      _selectedServerType = newSelection;
                      _updateHintTexts(); // Update hint texts on selection change
                    }
                  });
                },
                showSelectedIcon: false,
                style: SegmentedButton.styleFrom(
                  // 可以根据需要自定义样式
                ),
              ),
              const SizedBox(height: 10),
              Text('接收服务器 (${_selectedServerType.first == ServerType.imap ? "IMAP" : "POP"}) 配置', style: Theme.of(context).textTheme.titleSmall),
              TextFormField(
                controller: _receiverDomainController,
                decoration: InputDecoration(labelText: '服务器域名', hintText: _receiverDomainHintText, border: InputBorder.none),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入接收服务器域名';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _receiverPortController,
                decoration: InputDecoration(labelText: '服务器端口', hintText: _receiverPortHintText, border: InputBorder.none),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入接收服务器端口';
                  }
                  if (int.tryParse(value) == null) {
                    return '请输入有效的端口号';
                  }
                  return null;
                },
              ),
              SwitchListTile(
                title: const Text('SSL/TLS'),
                value: _isReceiverSsl,
                onChanged: (bool value) {
                  setState(() {
                    _isReceiverSsl = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              Text('发送服务器 (SMTP) 配置', style: Theme.of(context).textTheme.titleSmall),
               TextFormField(
                controller: _smtpDomainController,
                decoration: const InputDecoration(labelText: '服务器域名', border: InputBorder.none),
                 validator: (value) { // Simplified: not strictly enforced for saving based on instructions
                   if (value == null || value.isEmpty) {
                     return '请输入SMTP服务器域名';
                   }
                   return null;
                 },
              ),
              TextFormField(
                controller: _smtpPortController,
                decoration: const InputDecoration(labelText: '服务器端口', border: InputBorder.none),
                keyboardType: TextInputType.number,
                validator: (value) { // Simplified
                  if (value == null || value.isEmpty) {
                    return '请输入SMTP服务器端口';
                  }
                  if (int.tryParse(value) == null) {
                    return '请输入有效的端口号';
                  }
                  return null;
                },
              ),
              SwitchListTile(
                title: const Text('SSL/TLS'),
                value: _isSmtpSsl,
                onChanged: (bool value) {
                  setState(() {
                    _isSmtpSsl = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveMailAccount,
                child: const Text('保存账户'),
              ),
              const SizedBox(height: 16), // 底部增加一些间距
            ],
          ),
        ),
      ],
        ),
      ),
    );
  }
}