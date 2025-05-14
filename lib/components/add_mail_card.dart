import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import '../database/mail_database.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

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
  Map<String, dynamic> _mailServices = {};

  @override
  void initState() {
    super.initState();
    _db = AppDatabase();
    _updateHintTexts(); // Initialize hint texts
    _loadMailServices();
    _emailAddressController.addListener(_autoFillMailConfig);
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
    _emailAddressController.removeListener(_autoFillMailConfig);
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
      final alias =
          _aliasController.text.isEmpty ? null : _aliasController.text;
      final password = _passwordController.text;
      final serverTypeString =
          _selectedServerType.first == ServerType.imap ? 'IMAP' : 'POP';
      final domain = _receiverDomainController.text;
      final port =
          int.tryParse(_receiverPortController.text) ??
          (_selectedServerType.first == ServerType.imap
              ? (_isReceiverSsl ? 993 : 143)
              : (_isReceiverSsl ? 995 : 110));
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
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('邮件账户已保存')));
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
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('保存失败: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    _updatePortHints();

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
                  Icon(
                    Icons.add_circle_outline,
                    color: colorScheme.primary,
                    size: 28,
                  ),
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
                    IconButton(
                      // 改为 IconButton 以便更紧凑
                      icon: Icon(
                        Icons.close,
                        color: colorScheme.onSurfaceVariant,
                      ),
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
            const SizedBox(
              height: 16,
            ), // 调整分隔符与主要内容的间距，比EditMailCard小一点，因为表单项本身有间距
            // 原有表单内容
            // Expanded removed to resolve unbounded height issue in SingleChildScrollView
            Form(
              key: _formKey,
              child: ListView(
                shrinkWrap:
                    true, // Allow ListView to size itself to its content
                primary: false, // Prevent conflict with parent ScrollView
                children: <Widget>[
                  TextFormField(
                    controller: _aliasController,
                    decoration: const InputDecoration(
                      labelText: '账户名称',
                      border: InputBorder.none,
                    ),
                  ),
                  TextFormField(
                    controller: _emailAddressController,
                    decoration: const InputDecoration(
                      labelText: '邮箱地址',
                      border: InputBorder.none,
                    ),
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
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: '邮箱密码',
                      border: InputBorder.none,
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入邮箱密码';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '接收服务器类型',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
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
                          _updatePortHintsBasedOnEmail();
                        }
                      });
                    },
                    showSelectedIcon: false,
                    style: SegmentedButton.styleFrom(
                      // 可以根据需要自定义样式
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '接收服务器 (${_selectedServerType.first == ServerType.imap ? "IMAP" : "POP"}) 配置',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  TextFormField(
                    controller: _receiverDomainController,
                    decoration: InputDecoration(
                      labelText: '服务器域名',
                      hintText: _receiverDomainHintText,
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入接收服务器域名';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _receiverPortController,
                    decoration: InputDecoration(
                      labelText: '服务器端口',
                      hintText: _receiverPortHintText,
                      border: InputBorder.none,
                    ),
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
                        _updatePortHintsBasedOnEmail();
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '发送服务器 (SMTP) 配置',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  TextFormField(
                    controller: _smtpDomainController,
                    decoration: const InputDecoration(
                      labelText: '服务器域名',
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      // Simplified: not strictly enforced for saving based on instructions
                      if (value == null || value.isEmpty) {
                        return '请输入SMTP服务器域名';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _smtpPortController,
                    decoration: const InputDecoration(
                      labelText: '服务器端口',
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      // Simplified
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
                        _updatePortHintsBasedOnEmail();
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

  Future<void> _loadMailServices() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/config/mail_services.json',
      );
      final data = jsonDecode(response);
      setState(() {
        _mailServices = data['mail_services'];
      });
    } catch (e) {
      debugPrint('加载邮件服务配置失败: $e');
    }
  }

  void _autoFillMailConfig() {
    final email = _emailAddressController.text;
    if (email.contains('@')) {
      final domain = email.split('@')[1].toLowerCase();
      String serviceName = '';
      if (domain.contains('gmail')) {
        serviceName = 'Gmail';
      } else if (domain.contains('outlook') || domain.contains('hotmail')) {
        serviceName = 'Outlook';
      } else if (domain.contains('qq')) {
        serviceName = 'QQ Mail';
      } else if (domain.contains('163')) {
        serviceName = '163 Mail';
      }

      if (_mailServices.containsKey(serviceName)) {
        final service = _mailServices[serviceName];
        setState(() {
          _receiverDomainController.text =
              service[_selectedServerType.first == ServerType.imap
                  ? 'imap'
                  : 'pop']['domain'];
          _smtpDomainController.text = service['smtp']['domain'];
          _updatePortHints(service);
        });
      } else {
        // 使用标准端口
        setState(() {
          _receiverDomainController.text =
              '${_selectedServerType.first == ServerType.imap ? 'imap' : 'pop'}.$domain';
          _smtpDomainController.text = 'smtp.$domain';
          _updatePortHints();
        });
      }
    }
  }

  void _updatePortHints([Map<String, dynamic>? service]) {
    if (service != null) {
      _receiverPortController.text =
          service[_selectedServerType.first == ServerType.imap
                  ? 'imap'
                  : 'pop'][_isReceiverSsl ? 'port_ssl' : 'port_non_ssl']
              .toString();
      _smtpPortController.text =
          service['smtp'][_isSmtpSsl ? 'port_ssl' : 'port_non_ssl'].toString();
    } else {
      if (_selectedServerType.first == ServerType.imap) {
        _receiverPortController.text = _isReceiverSsl ? '993' : '143';
        _receiverPortHintText =
            "例如：${_isReceiverSsl ? '993 (SSL)' : '143 (非SSL)'}";
      } else {
        _receiverPortController.text = _isReceiverSsl ? '995' : '110';
        _receiverPortHintText =
            "例如：${_isReceiverSsl ? '995 (SSL)' : '110 (非SSL)'}";
      }
      _smtpPortController.text = _isSmtpSsl ? '465' : '587';
    }
  }

  void _updatePortHintsBasedOnEmail() {
    final email = _emailAddressController.text;
    if (email.contains('@')) {
      final domain = email.split('@')[1].toLowerCase();
      String serviceName = '';
      if (domain.contains('gmail')) {
        serviceName = 'Gmail';
      } else if (domain.contains('outlook') || domain.contains('hotmail')) {
        serviceName = 'Outlook';
      } else if (domain.contains('yahoo')) {
        serviceName = 'Yahoo';
      } else if (domain.contains('qq')) {
        serviceName = 'QQ Mail';
      } else if (domain.contains('163')) {
        serviceName = '163 Mail';
      }

      if (_mailServices.containsKey(serviceName)) {
        final service = _mailServices[serviceName];
        _updatePortHints(service);
      } else {
        _updatePortHints();
      }
    } else {
      _updatePortHints();
    }
  }
}
