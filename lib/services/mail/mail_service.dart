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
}
