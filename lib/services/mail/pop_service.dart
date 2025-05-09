import 'package:enough_mail/enough_mail.dart';

/// POP3 服务类，处理 POP3 协议相关的邮件操作。
class PopService {
  final String username;
  final String password;
  final String pop3ServerHost;
  final int pop3ServerPort;
  final bool pop3IsSecure;

  /// 构造函数，传入 POP3 服务的配置参数。
  PopService({
    required this.username,
    required this.password,
    required this.pop3ServerHost,
    required this.pop3ServerPort,
    required this.pop3IsSecure,
  });

  /// 连接到 POP3 服务器。
  Future<void> connect() async {
    final client = PopClient(isLogEnabled: false);
    try {
      await client.connectToServer(pop3ServerHost, pop3ServerPort, isSecure: pop3IsSecure);
      await client.login(username, password);
      // print('成功连接到 POP3 服务器');
      // TODO: 实现更多 POP3 连接后的操作
      // await client.quit(); // 根据需要决定何时断开连接
    } on PopException catch (e) {
      // print('连接 POP3 服务器失败: $e');
      rethrow; // 重新抛出异常以便调用者处理
    }
  }

  /// 获取邮件列表 (POP3)。
  Future<List<dynamic>> fetchMessageList() async { // TODO: Check if PopMessageItem is a valid type from enough_mail or replace with a defined type
    final client = PopClient(isLogEnabled: false);
    List<dynamic> messageList = []; // TODO: Check if PopMessageItem is a valid type from enough_mail or replace with a defined type
    try {
      await client.connectToServer(pop3ServerHost, pop3ServerPort, isSecure: pop3IsSecure);
      await client.login(username, password);
      final status = await client.status();
      if (status.numberOfMessages > 0) {
         messageList = (await client.list(status.numberOfMessages));
      }
      // print('成功获取 ${messageList.length} 封 POP3 邮件列表项');
      // await client.quit(); // 根据需要决定何时断开连接
    } on PopException catch (e) {
      // print('获取 POP3 邮件列表失败: $e');
      rethrow; // 重新抛出异常以便调用者处理
    }
    return messageList;
  }

  /// 获取特定邮件 (POP3)。
  Future<MimeMessage?> retrieveMessage(int messageNumber) async {
    final client = PopClient(isLogEnabled: false);
    MimeMessage? message;
    try {
      await client.connectToServer(pop3ServerHost, pop3ServerPort, isSecure: pop3IsSecure);
      await client.login(username, password);
      message = await client.retrieve(messageNumber);
      if (message != null) { // unnecessary_null_comparison - message is already non-nullable
         // print('成功获取 POP3 邮件: $messageNumber');
      } else {
         // print('未找到 POP3 邮件: $messageNumber');
      }
      // await client.quit(); // 根据需要决定何时断开连接
    } on PopException catch (e) {
      // print('获取 POP3 邮件失败: $e');
      rethrow; // 重新抛出异常以便调用者处理
    }
    return message;
  }

  // TODO: 添加其他需要的方法，例如断开连接等
}