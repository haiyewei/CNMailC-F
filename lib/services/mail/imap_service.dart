import 'package:enough_mail/enough_mail.dart';

/// IMAP 服务类，处理 IMAP 协议相关的邮件操作。
class ImapService {
  final String username;
  final String password;
  final String imapServerHost;
  final int imapServerPort;
  final bool imapIsSecure;

  ImapClient? _client;

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
    _client = ImapClient(isLogEnabled: true); // 调试时可以考虑启用日志: isLogEnabled: true
    try {
      if (_client == null) {
        throw Exception(
          'Mail client is not initialized prior to connectToServer.',
        );
      }
      await _client!.connectToServer(
        imapServerHost,
        imapServerPort,
        isSecure: imapIsSecure,
      );

      if (_client == null) {
        // 此检查理论上不应触发，因为 connectToServer 不应使 _client 为 null
        // 但为了极致安全，可以保留
        _client = null; // 确保状态一致性
        throw Exception('Mail client became null after connectToServer.');
      }
      await _client!.login(username, password);

      // 根据 RFC 2971 发送客户端 ID 信息
      final appClientId = Id(
        name: 'CNMailC', // 程序名称
        version: '0.0.1', // 程序版本号
      );

      if (_client == null) {
        _client = null; // 确保状态一致性
        throw Exception('Mail client became null before sending ID.');
      }
      if (appClientId.name != null && appClientId.name!.isNotEmpty) {
        await _client!.id(clientId: appClientId);
        // print('IMAP ID 命令已发送，参数: ${appClientId.toMap()}'); // Id 类通常有 toMap() 或类似方法用于日志
      } else {
        await _client!.id(clientId: null); // 发送 ID NIL
        // print('IMAP ID 命令已发送 (NIL)');
      }
    } on ImapException catch (_) {
      // print('连接 IMAP 服务器或发送 ID 失败: $e');
      _client = null; // 连接失败时重置客户端
      // throw Exception('Failed to connect to IMAP server or login: ${e.message}');
      rethrow; // 重新抛出异常以便调用者处理
    } catch (_) {
      // print('在 IMAP connect 方法中发生非 ImapException 错误: $e');
      _client = null; // 确保在任何错误情况下都重置客户端
      // 如果是 "Mail client is not initialized" 等我们主动抛出的异常，直接 rethrow
      // 否则，可以考虑包装成一个更通用的错误
      // throw Exception('An unexpected error occurred during IMAP connect: $e');
      rethrow;
    }
  }

  /// 获取邮件列表 (IMAP)。
  /// 注意: 此方法当前创建自己的客户端实例。
  /// 理想情况下，它应该使用共享的 _client 实例（如果已连接）。
  /// 为简单起见，暂时保持原样，但未来可能需要重构。
  Future<List<MimeMessage>> fetchMessages({int count = 10}) async {
    // 理想情况下，这里应该检查 _client 是否已连接并使用它
    // if (_client == null || !_client!.isConnected) {
    //   await connect(); // 或者抛出未连接错误
    // }
    // final clientToUse = _client!; // 假设已连接

    // 当前实现：为保持与原始逻辑一致，暂时仍创建新客户端
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
      // 获取后应注销此临时客户端
      await client.logout();
    } on ImapException {
      // print('获取 IMAP 邮件失败: $e');
      rethrow; // 重新抛出异常以便调用者处理
    }
    return messages;
  }

  /// 断开与 IMAP 服务器的连接。
  Future<void> disconnect() async {
    if (_client != null && (_client!.isLoggedIn || _client!.isConnected)) {
      try {
        // print('IMAP 客户端状态: isLoggedIn=${_client!.isLoggedIn}, isConnected=${_client!.isConnected}');
        if (_client!.isLoggedIn) {
          await _client!.logout();
          // print('IMAP 客户端已注销');
        }
        // enough_mail 的 ImapClient 在 logout 后会自动关闭连接，
        // 但显式调用 close() (如果可用且有意义) 或检查 isConnected 状态是好的做法。
        // 当前版本的 enough_mail ImapClient 没有公共的 close() 方法，
        // 连接在 logout() 后或发生致命错误时由内部管理。
        // 我们将 _client 设置为 null 来表示连接已断开。
      } on ImapException {
        // print('断开 IMAP 连接失败: $e');
        // 即使注销失败，也尝试将客户端置于非活动状态
      } finally {
        _client = null; // 无论成功与否，都将客户端引用置空
        // print('IMAP 客户端引用已置空');
      }
    } else {
      // print('IMAP 客户端未连接或已断开，无需操作。');
      _client = null; // 确保客户端引用已置空
    }
  }
}
