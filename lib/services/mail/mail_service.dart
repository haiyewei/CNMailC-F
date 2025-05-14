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

  Future<List<MimeMessage>> fetchImapMessages({int messageCount = 10}) async {
    final client = ImapClient(isLogEnabled: isLogEnabled);
    List<MimeMessage> messages = [];
    try {
      await client.connectToServer(
        imapServerHost,
        imapServerPort,
        isSecure: isImapServerSecure,
      );

      await client.login(userName, password);
      final idObj = Id(
        name: 'name',
        version: 'version',
        nonStandardFields: {'name': 'CNMailC', 'version': '1.0'},
      );
      await client.id(clientId: idObj);
      await client.selectInbox();
      final fetchResult = await client.fetchRecentMessages(
        messageCount: messageCount,
      );
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
    MimeMessage? mimeMessage,
  }) async {
    final client = SmtpClient('localhost', isLogEnabled: isLogEnabled);
    try {
      await client.connectToServer(
        smtpServerHost,
        smtpServerPort,
        isSecure: isSmtpServerSecure,
      );
      await client.ehlo();
      if (client.serverInfo.supportsAuth(AuthMechanism.plain)) {
        await client.authenticate(userName, password, AuthMechanism.plain);
      } else if (client.serverInfo.supportsAuth(AuthMechanism.login)) {
        await client.authenticate(userName, password, AuthMechanism.login);
      } else {
        return false;
      }
      final MimeMessage messageToSend;
      if (mimeMessage != null) {
        messageToSend = mimeMessage;
      } else {
        final builder = MessageBuilder.prepareMultipartAlternativeMessage(
          plainText: plainText,
          htmlText: htmlText ?? plainText,
        )..subject = subject;
        messageToSend = builder.buildMimeMessage();
      }
      final sendResponse = await client.sendMessage(messageToSend);
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
      await client.connectToServer(
        popServerHost,
        popServerPort,
        isSecure: isPopServerSecure,
      );
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

  /// 使用IMAP协议删除邮件
  Future<bool> deleteMail({
    required MimeMessage message,
    bool expunge = true,
  }) async {
    final client = ImapClient(isLogEnabled: isLogEnabled);
    try {
      Logger('MailService').info('开始IMAP删除邮件操作，邮件UID: ${message.uid}');
      await client.connectToServer(
        imapServerHost,
        imapServerPort,
        isSecure: isImapServerSecure,
      );
      Logger('MailService').info('IMAP服务器连接成功');
      await client.login(userName, password);
      Logger('MailService').info('IMAP登录成功');
      // 直接在登录后发送ID命令，使用键值对形式
      final idObj = Id(
        name: 'name',
        version: 'version',
        nonStandardFields: {'name': 'CNMailC', 'version': '1.0'},
      );
      await client.id(clientId: idObj);
      Logger('MailService').info('IMAP ID命令发送成功');
      await client.selectInbox();
      Logger('MailService').info('IMAP收件箱选择成功');
      final sequence = MessageSequence.fromMessage(message);
      await client.uidStore(sequence, [r'\Deleted']);
      Logger('MailService').info('IMAP邮件标记为删除，UID序列: $sequence');
      if (expunge) {
        final expungeResult = await client.expunge();
        Logger('MailService').info('IMAP邮件永久删除执行，结果: $expungeResult');
        // 尝试多次调用expunge以确保删除
        final expungeResult2 = await client.expunge();
        Logger('MailService').info('IMAP邮件永久删除执行第二次，结果: $expungeResult2');
        // 重新选择收件箱并检查状态
        final mailbox = await client.selectInbox();
        Logger(
          'MailService',
        ).info('IMAP收件箱状态检查，邮件总数: ${mailbox.messagesExists}');
      } else {
        Logger('MailService').info('IMAP邮件未执行永久删除，expunge参数为false');
      }
      await client.logout();
      Logger('MailService').info('IMAP登出成功');
      return true;
    } on ImapException catch (e) {
      Logger('MailService').severe('IMAP删除邮件失败: $e');
      return false;
    }
  }

  /// 使用POP3协议删除邮件
  Future<bool> deletePopMail({required MimeMessage message}) async {
    final client = PopClient(isLogEnabled: isLogEnabled);
    try {
      Logger('MailService').info('开始POP3删除邮件操作，邮件UID: ${message.uid}');
      await client.connectToServer(
        popServerHost,
        popServerPort,
        isSecure: isPopServerSecure,
      );
      Logger('MailService').info('POP3服务器连接成功');
      await client.login(userName, password);
      Logger('MailService').info('POP3登录成功');
      final status = await client.status();
      Logger('MailService').info('POP3状态获取成功，邮件总数: ${status.numberOfMessages}');
      for (int i = 1; i <= status.numberOfMessages; i++) {
        var msg = await client.retrieve(i);
        if (msg.uid == message.uid) {
          await client.delete(i);
          Logger('MailService').info('POP3邮件删除成功，索引: $i，UID: ${message.uid}');
          await client.quit();
          Logger('MailService').info('POP3登出成功');
          return true;
        }
      }
      Logger('MailService').info('POP3未找到匹配的邮件UID: ${message.uid}');
      await client.quit();
      Logger('MailService').info('POP3登出成功');
      return false;
    } on PopException catch (e) {
      Logger('MailService').severe('POP删除邮件失败: $e');
      return false;
    }
  }
}
