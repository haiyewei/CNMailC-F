import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/mail_database.dart';
import '../components/add_mail_card.dart';
import '../services/notify/notify.dart'; // Corrected import
import '../services/mail/mail_service.dart';
import '../services/mail/mail_test.dart';
import '../themes/theme_manager.dart';

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
  final Map<int, bool> _testingAccounts = {};
  final Map<int, String> _testResults = {};

  @override
  void initState() {
    super.initState();
    _db = AppDatabase();
    _loadMailAccounts().then((_) {
      _loadTestResults();
    });
  }

  Future<void> _loadTestResults() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      for (var account in _mailAccounts) {
        String? savedResult = prefs.getString('testResult_${account.id}');
        if (savedResult != null) {
          _testResults[account.id] = savedResult;
        }
      }
    });
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
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isTestingAccount(account) ? Colors.blue : _getTestResultColor(account),
                      ),
                      child: const Icon(Icons.mail_outline, color: Colors.white),
                    ),
                    title: Text(account.emailAddress),
                    subtitle: Text(account.alias ?? '无别名'),
                    trailing: IconButton(
                      icon: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(Icons.network_check),
                          if (_isTestingAccount(account))
                            Positioned.fill(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                              ),
                            ),
                        ],
                      ),
                      onPressed: () {
                        _runMailTest(account);
                      },
                    ),
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
  Future<void> _runMailTest(MailAccount account) async {
    setState(() {
      _testingAccounts[account.id] = true;
      _testResults[account.id] = '测试中...';
    });

    final mailService = MailService();
    mailService.configure(
      userName: account.emailAddress,
      password: account.password,
      imapServerHost: account.serverType == 'IMAP' ? account.domain : '',
      imapServerPort: account.serverType == 'IMAP' ? account.port : 993,
      isImapServerSecure: account.isSsl,
      popServerHost: account.serverType == 'POP' ? account.domain : '',
      popServerPort: account.serverType == 'POP' ? account.port : 995,
      isPopServerSecure: account.isSsl,
      smtpServerHost: account.domain, // 假设 SMTP 服务器与接收服务器相同
      smtpServerPort: account.isSsl ? 465 : 587,
      isSmtpServerSecure: account.isSsl,
      isLogEnabled: false,
    );

        // Run the mail test and update state after it completes
        final testResult = await MailTest(
          mailService: mailService,
          useImap: account.serverType == 'IMAP',
        ).runMailTest();
    
        // Update state with the test result, save it, and show notification
        if (mounted) {
          setState(() {
            _testingAccounts[account.id] = false;
            _testResults[account.id] = testResult;
          });
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('testResult_${account.id}', testResult);
          NotifyController().showNotify(
            NotifyData(
              message: testResult,
              type: NotifyType.app,
              time: DateTime.now(),
            ),
          );
        }
  }

  bool _isTestingAccount(MailAccount account) {
    return _testingAccounts[account.id] ?? false;
  }

  Color _getTestResultColor(MailAccount account) {
    final result = _testResults[account.id];
    if (result == null) return Colors.grey;
    if (result.contains('成功')) return ThemeManager().successColor;
    if (result.contains('失败')) return ThemeManager().warningColor;
    return Colors.blue;
  }
}
