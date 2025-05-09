import 'package:enough_mail/enough_mail.dart';

/// SMTP 服务类，处理 SMTP 协议相关的邮件发送操作。
class SmtpService {
  final String username;
  final String password;
  final String smtpServerHost;
  final int smtpServerPort;
  final bool smtpIsSecure;

  /// 构造函数，传入 SMTP 服务的配置参数。
  SmtpService({
    required this.username,
    required this.password,
    required this.smtpServerHost,
    required this.smtpServerPort,
    required this.smtpIsSecure,
  });

  /// 发送邮件。
  Future<void> sendEmail(MimeMessage message) async {
    final client = SmtpClient('your_client_domain.com', isLogEnabled: true); // TODO: 替换为实际的客户端域名
    try {
      await client.connectToServer(smtpServerHost, smtpServerPort, isSecure: smtpIsSecure);
      await client.ehlo();
      if (client.serverInfo.supportsAuth(AuthMechanism.plain)) {
        await client.authenticate(username, password, AuthMechanism.plain);
      } else if (client.serverInfo.supportsAuth(AuthMechanism.login)) {
        await client.authenticate(username, password, AuthMechanism.login);
      } else {
        throw SmtpException(
          client,
          SmtpResponse(
            ['504 SMTP server does not support PLAIN or LOGIN authentication.']
          )
        );
      }
      await client.sendMessage(message);
      await client.quit();
    } on SmtpException {
      rethrow; // 重新抛出异常以便调用者处理
    }
  }

  // TODO: 添加其他需要的方法，例如断开连接等
}