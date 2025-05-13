import 'pop_service.dart';
import 'imap_service.dart';
import 'smtp_service.dart';

/// 邮件服务类，负责管理邮件服务的配置参数并作为接口。
class MailService {
  final String username;
  final String password;
  final String pop3ServerHost;
  final int pop3ServerPort;
  final bool pop3IsSecure;
  final String smtpServerHost;
  final int smtpServerPort;
  final bool smtpIsSecure;
  final String imapServerHost;
  final int imapServerPort;
  final bool imapIsSecure;

  late final PopService _popService;
  late final ImapService _imapService;
  late final SmtpService _smtpService;

  /// 构造函数，传入邮件服务的配置参数。
  MailService({
    required this.username,
    required this.password,
    required this.pop3ServerHost,
    required this.pop3ServerPort,
    required this.pop3IsSecure,
    required this.smtpServerHost,
    required this.smtpServerPort,
    required this.smtpIsSecure,
    required this.imapServerHost,
    required this.imapServerPort,
    required this.imapIsSecure,
  }) {
    _popService = PopService(
      username: username,
      password: password,
      pop3ServerHost: pop3ServerHost,
      pop3ServerPort: pop3ServerPort,
      pop3IsSecure: pop3IsSecure,
    );
    _imapService = ImapService(
      username: username,
      password: password,
      imapServerHost: imapServerHost,
      imapServerPort: imapServerPort,
      imapIsSecure: imapIsSecure,
    );
    _smtpService = SmtpService(
      username: username,
      password: password,
      smtpServerHost: smtpServerHost,
      smtpServerPort: smtpServerPort,
      smtpIsSecure: smtpIsSecure,
    );
  }

  /// 连接到 IMAP 服务器。
  Future<void> connectToImap() async {
    await _imapService.connect();
  }

  /// 连接到 POP3 服务器。
  Future<void> connectToPop3() async {
    await _popService.connect();
  }

  /// 获取 IMAP 服务实例。
  ImapService get imapService => _imapService;

  /// 获取 POP 服务实例。
  PopService get popService => _popService;

  /// 获取 SMTP 服务实例。
  SmtpService get smtpService => _smtpService;

  /// 断开所有活动邮件服务的连接。
  /// 此方法会尝试断开 IMAP, POP3 和 SMTP 服务的连接。
  /// 它会捕获并记录在断开单个服务时可能发生的任何异常，
  /// 但会继续尝试断开其他服务。
  Future<void> disconnectAllServices() async {
    // print('开始断开所有邮件服务...');
    List<Future<void>> disconnectFutures = [];
    List<String> serviceNames = [];

    // 为每个服务添加断开连接的 future
    // IMAP
    // print('准备断开 IMAP 服务...');
    disconnectFutures.add(
      _imapService.disconnect().catchError((e) {
        // print('断开 IMAP 服务失败: $e');
        // 可以在这里记录错误，但允许其他服务继续断开
      }),
    );
    serviceNames.add('IMAP');

    // POP3
    // print('准备断开 POP3 服务...');
    disconnectFutures.add(
      _popService.disconnect().catchError((e) {
        // print('断开 POP3 服务失败: $e');
      }),
    );
    serviceNames.add('POP3');

    // SMTP
    // print('准备断开 SMTP 服务...');
    disconnectFutures.add(
      _smtpService.disconnect().catchError((e) {
        // print('断开 SMTP 服务失败: $e');
      }),
    );
    serviceNames.add('SMTP');

    // 等待所有断开操作完成
    final results = await Future.wait(
      disconnectFutures.asMap().entries.map((entry) async {
        try {
          await entry.value;
          // print('${serviceNames[entry.key]} 服务已成功断开或无需操作。');
          return null; // 表示成功或无需操作
        } catch (e) {
          // print('在等待 ${serviceNames[entry.key]} 服务断开时捕获到未处理的错误: $e');
          return e; // 返回错误对象
        }
      }),
    );

    // 检查是否有错误发生
    bool allDisconnectedSuccessfully = true;
    for (int i = 0; i < results.length; i++) {
      if (results[i] != null) {
        allDisconnectedSuccessfully = false;
        // print('服务 ${serviceNames[i]} 在断开过程中遇到错误: ${results[i]}');
      }
    }

    if (allDisconnectedSuccessfully) {
      // print('所有邮件服务均已成功断开或之前未连接。');
    } else {
      // print('部分邮件服务在断开过程中遇到问题。请检查日志。');
      // 可以考虑抛出一个聚合错误，或者根据需求处理
    }
  }
}
