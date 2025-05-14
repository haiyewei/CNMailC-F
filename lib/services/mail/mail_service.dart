import 'package:enough_mail/enough_mail.dart';

class MailService {
  String userName = '';
  String password = '';
  String imapServerHost = '';
  int imapServerPort = 993;
  bool isImapServerSecure = true;
  String popServerHost = '';
  int popServerPort = 995;
  bool isPopServerSecure = true;
  String smtpServerHost = '';
  int smtpServerPort = 465;
  bool isSmtpServerSecure = true;

  MailService({
    required this.userName,
    required this.password,
    required this.imapServerHost,
    this.imapServerPort = 993,
    this.isImapServerSecure = true,
    required this.popServerHost,
    this.popServerPort = 995,
    this.isPopServerSecure = true,
    required this.smtpServerHost,
    this.smtpServerPort = 465,
    this.isSmtpServerSecure = true,
  });

  /// 自动发现邮件服务配置
  Future<void> discoverSettings(String email) async {
    var config = await Discover.discover(email, isLogEnabled: false);
    if (config != null && config.emailProviders != null && config.emailProviders!.isNotEmpty) {
      for (var provider in config.emailProviders!) {
        if (provider.preferredIncomingServer != null) {
          imapServerHost = provider.preferredIncomingServer!.hostname;
          imapServerPort = provider.preferredIncomingServer!.port;
          isImapServerSecure = provider.preferredIncomingServer!.socketType == SocketType.ssl;
        }
        if (provider.preferredOutgoingServer != null) {
          smtpServerHost = provider.preferredOutgoingServer!.hostname;
          smtpServerPort = provider.preferredOutgoingServer!.port;
          isSmtpServerSecure = provider.preferredOutgoingServer!.socketType == SocketType.ssl;
        }
      }
    }
  }

  /// 使用IMAP协议获取邮件
  Future<List<MimeMessage>> fetchImapMessages({int messageCount = 10}) async {
    final client = ImapClient(isLogEnabled: false);
    List<MimeMessage> messages = [];
    try {
      await client.connectToServer(imapServerHost, imapServerPort, isSecure: isImapServerSecure);
      await client.login(userName, password);
      await client.selectInbox();
      final fetchResult = await client.fetchRecentMessages(messageCount: messageCount, criteria: 'BODY.PEEK[]');
      messages = fetchResult.messages;
      await client.logout();
    } on ImapException catch (e) {
      print('IMAP获取邮件失败: $e');
    }
    return messages;
  }

  /// 使用SMTP协议发送邮件
  Future<bool> sendSmtpMessage({
    required String from,
    required String to,
    required String subject,
    required String plainText,
    String? htmlText,
  }) async {
    final client = SmtpClient('enough.de', isLogEnabled: false);
    try {
      await client.connectToServer(smtpServerHost, smtpServerPort, isSecure: isSmtpServerSecure);
      await client.ehlo();
      if (client.serverInfo.supportsAuth(AuthMechanism.plain)) {
        await client.authenticate(userName, password, AuthMechanism.plain);
      } else if (client.serverInfo.supportsAuth(AuthMechanism.login)) {
        await client.authenticate(userName, password, AuthMechanism.login);
      } else {
        return false;
      }
      final builder = MessageBuilder.prepareMultipartAlternativeMessage(
        plainText: plainText,
        htmlText: htmlText ?? '<p>$plainText</p>',
      )
        ..from = [MailAddress('Sender', from)]
        ..to = [MailAddress('Recipient', to)]
        ..subject = subject;
      final mimeMessage = builder.buildMimeMessage();
      final sendResponse = await client.sendMessage(mimeMessage);
      return sendResponse.isOkStatus;
    } on SmtpException catch (e) {
      print('SMTP发送邮件失败: $e');
      return false;
    }
  }

  /// 使用POP3协议获取邮件
  Future<List<MimeMessage>> fetchPopMessages() async {
    final client = PopClient(isLogEnabled: false);
    List<MimeMessage> messages = [];
    try {
      await client.connectToServer(popServerHost, popServerPort, isSecure: isPopServerSecure);
      await client.login(userName, password);
      final status = await client.status();
      for (int i = 1; i <= status.numberOfMessages; i++) {
        var message = await client.retrieve(i);
        messages.add(message);
      }
      await client.quit();
    } on PopException catch (e) {
      print('POP获取邮件失败: $e');
    }
    return messages;
  }
}