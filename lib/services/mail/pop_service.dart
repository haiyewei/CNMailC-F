import 'package:enough_mail/enough_mail.dart';

/// POP3 服务类，处理 POP3 协议相关的邮件操作。
class PopService {
  final String username;
  final String password;
  final String pop3ServerHost;
  final int pop3ServerPort;
  final bool pop3IsSecure;

  PopClient? _client;

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
    _client = PopClient(isLogEnabled: false);
    try {
      if (_client == null) {
        throw Exception(
          'Mail client is not initialized prior to connectToServer.',
        );
      }
      await _client!.connectToServer(
        pop3ServerHost,
        pop3ServerPort,
        isSecure: pop3IsSecure,
      );

      if (_client == null) {
        // 此检查理论上不应触发
        _client = null; // 确保状态一致性
        throw Exception('Mail client became null after connectToServer.');
      }
      await _client!.login(username, password);
      // print('成功连接到 POP3 服务器');
    } on PopException catch (_) {
      // print('连接 POP3 服务器失败: $e');
      _client = null; // 连接失败时重置客户端
      // throw Exception('Failed to connect to POP3 server or login: ${e.message}');
      rethrow; // 重新抛出异常以便调用者处理
    } catch (_) {
      // print('在 POP3 connect 方法中发生非 PopException 错误: $e');
      _client = null; // 确保在任何错误情况下都重置客户端
      // throw Exception('An unexpected error occurred during POP3 connect: $e');
      rethrow;
    }
  }

  /// 获取邮件列表 (POP3)。
  /// 注意: 此方法当前创建自己的客户端实例。
  /// 理想情况下，它应该使用共享的 _client 实例（如果已连接）。
  Future<List<MessageListing>> fetchMessageList() async {
    // 理想情况下，这里应该检查 _client 是否已连接并使用它
    // if (_client == null || !_client!.isLoggedIn) { // PopClient 可能没有 isConnected，检查 isLoggedIn
    //   await connect(); // 或者抛出未连接错误
    // }
    // final clientToUse = _client!; // 假设已连接

    // 当前实现：为保持与原始逻辑一致，暂时仍创建新客户端
    final client = PopClient(isLogEnabled: false);
    List<MessageListing> messageList = [];
    try {
      await client.connectToServer(
        pop3ServerHost,
        pop3ServerPort,
        isSecure: pop3IsSecure,
      );
      await client.login(username, password);
      final status = await client.status();
      if (status.numberOfMessages > 0) {
        messageList = await client.list(status.numberOfMessages);
      }
      // print('成功获取 ${messageList.length} 封 POP3 邮件列表项');
      await client.quit(); // 获取后应注销并关闭此临时客户端
    } on PopException {
      // print('获取 POP3 邮件列表失败: $e');
      rethrow; // 重新抛出异常以便调用者处理
    }
    return messageList;
  }

  /// 获取特定邮件 (POP3)。
  /// 注意: 此方法当前创建自己的客户端实例。
  /// 理想情况下，它应该使用共享的 _client 实例（如果已连接）。
  Future<MimeMessage?> retrieveMessage(int messageNumber) async {
    // 理想情况下，这里应该检查 _client 是否已连接并使用它
    // if (_client == null || !_client!.isLoggedIn) {
    //   await connect();
    // }
    // final clientToUse = _client!;

    // 当前实现：为保持与原始逻辑一致，暂时仍创建新客户端
    final client = PopClient(isLogEnabled: false);
    MimeMessage? message;
    try {
      await client.connectToServer(
        pop3ServerHost,
        pop3ServerPort,
        isSecure: pop3IsSecure,
      );
      await client.login(username, password);
      message = await client.retrieve(messageNumber);
      // print('成功获取 POP3 邮件: $messageNumber');
      await client.quit(); // 获取后应注销并关闭此临时客户端
    } on PopException {
      // print('获取 POP3 邮件失败: $e');
      rethrow; // 重新抛出异常以便调用者处理
    }
    return message;
  }

  /// 断开与 POP3 服务器的连接。
  Future<void> disconnect() async {
    if (_client != null && _client!.isLoggedIn) {
      // PopClient 主要通过 isLoggedIn 判断状态
      try {
        // print('POP3 客户端状态: isLoggedIn=${_client!.isLoggedIn}');
        await _client!.quit();
        // print('POP3 客户端已发送 QUIT 命令');
        // PopClient 在 quit() 后通常会关闭连接。
      } on PopException {
        // print('断开 POP3 连接失败: $e');
        // 即使 quit 失败，也尝试将客户端置于非活动状态
      } finally {
        _client = null; // 无论成功与否，都将客户端引用置空
        // print('POP3 客户端引用已置空');
      }
    } else {
      // print('POP3 客户端未连接或已断开，无需操作。');
      _client = null; // 确保客户端引用已置空
    }
  }
}
