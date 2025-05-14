import 'package:enough_mail/enough_mail.dart';
import 'package:logging/logging.dart';

class MailService {
  late String userName;
  late String password;
  late String imapServerHost;
  late int imapServerPort;
  late bool isImapServerSecure;
  late String popServerHost;
  late int popServerPort;
  late bool isPopServerSecure;
  late String smtpServerHost;
  late int smtpServerPort;
  late bool isSmtpServerSecure;
  late bool isLogEnabled;

  MailService();

  void configure({
    required String userName,
    required String password,
    required String imapServerHost,
    required int imapServerPort,
    required bool isImapServerSecure,
    required String popServerHost,
    required int popServerPort,
    required bool isPopServerSecure,
    required String smtpServerHost,
    required int smtpServerPort,
    required bool isSmtpServerSecure,
    required bool isLogEnabled,
  }) {
    this.userName = userName;
    this.password = password;
    this.imapServerHost = imapServerHost;
    this.imapServerPort = imapServerPort;
    this.isImapServerSecure = isImapServerSecure;
    this.popServerHost = popServerHost;
    this.popServerPort = popServerPort;
    this.isPopServerSecure = isPopServerSecure;
    this.smtpServerHost = smtpServerHost;
    this.smtpServerPort = smtpServerPort;
    this.isSmtpServerSecure = isSmtpServerSecure;
    this.isLogEnabled = isLogEnabled;
  }

  /// 使用IMAP协议获取邮件
  Future<List<MimeMessage>> fetchImapMessages({int messageCount = 10}) async {
    final client = ImapClient(isLogEnabled: isLogEnabled);
    List<MimeMessage> messages = [];
    try {
      await client.connectToServer(imapServerHost, imapServerPort, isSecure: isImapServerSecure);
      await client.login(userName, password);
      await client.selectInbox();
      final fetchResult = await client.fetchRecentMessages(messageCount: messageCount, criteria: 'BODY.PEEK[]');
      messages = fetchResult.messages;
      await client.logout();
    } on ImapException catch (e) {
      Logger('MailService').severe('IMAP获取邮件失败: $e');
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
    final client = SmtpClient('', isLogEnabled: isLogEnabled);
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
        htmlText: htmlText ?? plainText,
      )
        ..from = [MailAddress('Sender', from)]
        ..to = [MailAddress('Recipient', to)]
        ..subject = subject;
      final mimeMessage = builder.buildMimeMessage();
      final sendResponse = await client.sendMessage(mimeMessage);
      return sendResponse.isOkStatus;
    } on SmtpException catch (e) {
      Logger('MailService').severe('SMTP发送邮件失败: $e');
      return false;
    }
  }

  /// 使用POP3协议获取邮件
  Future<List<MimeMessage>> fetchPopMessages() async {
    final client = PopClient(isLogEnabled: isLogEnabled);
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
      Logger('MailService').severe('POP获取邮件失败: $e');
    }
    return messages;
  }
}