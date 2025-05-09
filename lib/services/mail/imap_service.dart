import 'package:enough_mail/enough_mail.dart';

/// IMAP 服务类，处理 IMAP 协议相关的邮件操作。
class ImapService {
  final String username;
  final String password;
  final String imapServerHost;
  final int imapServerPort;
  final bool imapIsSecure;

  /// 构造函数，传入 IMAP 服务的配置参数。
  ImapService({
    required this.username,
    required this.password,
    required this.imapServerHost,
    required this.imapServerPort,
    required this.imapIsSecure,
  });

  /// 连接到 IMAP 服务器。
  Future<void> connect() async {
    final client = ImapClient(isLogEnabled: false);
    try {
      await client.connectToServer(imapServerHost, imapServerPort, isSecure: imapIsSecure);
      await client.login(username, password);
      // print('成功连接到 IMAP 服务器');
      // TODO: 实现更多 IMAP 连接后的操作
      // await client.logout(); // 根据需要决定何时断开连接
    } on ImapException catch (e) {
      // print('连接 IMAP 服务器失败: $e');
      rethrow; // 重新抛出异常以便调用者处理
    }
  }

  /// 获取邮件列表 (IMAP)。
  Future<List<MimeMessage>> fetchMessages({int count = 10}) async {
     final client = ImapClient(isLogEnabled: false);
     List<MimeMessage> messages = [];
     try {
       await client.connectToServer(imapServerHost, imapServerPort, isSecure: imapIsSecure);
       await client.login(username, password);
       await client.selectInbox(); // 或者选择其他邮箱
       final fetchResult = await client.fetchRecentMessages(
         messageCount: count,
         criteria: 'BODY.PEEK[]', // 根据需要调整 criteria
       );
       messages = fetchResult.messages;
       // print('成功获取 ${messages.length} 封 IMAP 邮件');
       // await client.logout(); // 根据需要决定何时断开连接
     } on ImapException catch (e) {
       // print('获取 IMAP 邮件失败: $e');
       rethrow; // 重新抛出异常以便调用者处理
     }
     return messages;
  }

  // TODO: 添加其他需要的方法，例如断开连接等
}