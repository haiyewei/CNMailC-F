import 'package:flutter/material.dart';
import '../database/mail_database.dart';
import '../components/add_mail_card.dart';
import '../services/notify/notify.dart'; // Corrected import

class MailSettingsPage extends StatefulWidget {
  const MailSettingsPage({super.key});

  @override
  State<MailSettingsPage> createState() => _MailSettingsPageState();
}

class _MailSettingsPageState extends State<MailSettingsPage> {
  late AppDatabase _db;
  List<MailAccount> _mailAccounts = [];
  bool _isLoading = true;
  bool _isAddingAccount = false; // State to control AddMailCard visibility

  @override
  void initState() {
    super.initState();
    _db = AppDatabase();
    _loadMailAccounts();
  }

  Future<void> _loadMailAccounts() async {
    setState(() {
      _isLoading = true;
      // _errorLoading = false; // Reset error state - Not strictly needed if only used in catch
    });
    try {
      final accounts = await _db.getAllMailAccounts();
      if (mounted) {
        setState(() {
          _mailAccounts =
              accounts; // accounts is guaranteed to be non-null by its type
          _isLoading = false;
          // 不需要在这里因为列表为空而显示错误
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          // 当捕获到异常时，_mailAccounts 将保持其在 initState 中设置的初始值 []
          // 或在 try 块中被成功设置为 [] (如果 getAllMailAccounts 返回 null 但未抛出错误)。
          // UI 将因此显示 "未添加账户"（如果 _mailAccounts 为空）。
        });
        // 根据用户要求，如果错误是 "Null check operator used on a null value"，
        // 这被视为没有账户的正常情况，不应显示错误通知。
        if (!e.toString().contains(
          "Null check operator used on a null value",
        )) {
          NotifyController().showNotify(
            NotifyData(
              message: '加载邮箱账户失败: $e',
              type: NotifyType.app,
              time: DateTime.now(),
            ),
          );
        }
      }
    }
  }

  Widget _buildMailAccountsList(ColorScheme colorScheme) {
    return Card(
      elevation: 0,
      color: Colors.transparent,
      shadowColor: colorScheme.shadow.withAlpha((255 * 0.2).round()),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(42),
      ), // Consistent card shape
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4.0,
              ), // Consistent title padding
              child: Row(
                children: [
                  Icon(
                    Icons.account_box_outlined,
                    color: colorScheme.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '已添加的邮箱账户',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const Spacer(), // Add Spacer to push the button to the right
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    color: colorScheme.primary,
                    tooltip: '添加邮箱账户',
                    onPressed: () {
                      setState(() {
                        _isAddingAccount = true; // Show AddMailCard
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8.0), // Consistent spacing after title
            if (_mailAccounts.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: Text('未添加账户', style: TextStyle(fontSize: 16.0)),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _mailAccounts.length,
                itemBuilder: (context, index) {
                  final account = _mailAccounts[index];
                  return ListTile(
                    leading: const Icon(Icons.mail_outline),
                    title: Text(account.emailAddress),
                    subtitle: Text(account.alias ?? '无别名'),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(
                  5,
                ), // Consistent padding with settings_page
                child: Column(
                  // Use Column to wrap content like in settings_page
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 8,
                    ), // Consistent spacing with settings_page
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child:
                          _isAddingAccount
                              ? AddMailCard(
                                key: const ValueKey(
                                  'addMailCard',
                                ), // Add key for AnimatedSwitcher
                                onExit: ({bool saved = false}) {
                                  setState(() {
                                    _isAddingAccount = false;
                                  });
                                  if (saved) {
                                    _loadMailAccounts(); // Refresh the list
                                    NotifyController().showNotify(
                                      NotifyData(
                                        message: '账户已成功添加',
                                        type: NotifyType.app,
                                        time: DateTime.now(),
                                      ),
                                    );
                                  }
                                },
                              )
                              : _buildMailAccountsList(colorScheme),
                    ),
                  ],
                ),
              ),
    );
  }
}
