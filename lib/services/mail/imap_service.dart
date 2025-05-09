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
    final client = ImapClient(
      isLogEnabled: false,
    ); // 调试时可以考虑启用日志: isLogEnabled: true
    try {
      await client.connectToServer(
        imapServerHost,
        imapServerPort,
        isSecure: imapIsSecure,
      );
      await client.login(username, password);

      // 根据 RFC 2971 发送客户端 ID 信息
      final appClientId = Id(
        name: 'CNMailC', // 程序名称
        version: '0.0.1', // 程序版本号 
      
      );

      if (appClientId.name != null && appClientId.name!.isNotEmpty) {
        await client.id(clientId: appClientId);
        // print('IMAP ID 命令已发送，参数: ${appClientId.toMap()}'); // Id 类通常有 toMap() 或类似方法用于日志
      } else {
        await client.id(clientId: null); // 发送 ID NIL
        // print('IMAP ID 命令已发送 (NIL)');
      }

      // TODO: 实现更多 IMAP 连接和 ID 命令后的操作
      // await client.logout(); // 根据应用程序流程决定何时注销
    } on ImapException {
      // print('连接 IMAP 服务器或发送 ID 失败: $e');
      rethrow; // 重新抛出异常以便调用者处理
    }
  }

  /// 获取邮件列表 (IMAP)。
  Future<List<MimeMessage>> fetchMessages({int count = 10}) async {
    final client = ImapClient(isLogEnabled: false);
    List<MimeMessage> messages = [];
    try {
      await client.connectToServer(
        imapServerHost,
        imapServerPort,
        isSecure: imapIsSecure,
      );
      await client.login(username, password);
      await client.selectInbox(); // 或者选择其他邮箱
      final fetchResult = await client.fetchRecentMessages(
        messageCount: count,
        criteria: 'BODY.PEEK[]', // 根据需要调整 criteria
      );
      messages = fetchResult.messages;
    
    } on ImapException {
      // print('获取 IMAP 邮件失败: $e');
      rethrow; // 重新抛出异常以便调用者处理
    }
    return messages;
  }

  // TODO: 添加其他需要的方法，例如断开连接等
}
