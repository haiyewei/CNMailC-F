import 'package:enough_mail/enough_mail.dart';
import 'package:cnmailc/constants/app_info.dart';

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

  ImapClient? _imapClient;
  PopClient? _popClient;
  SmtpClient? _smtpClient;

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
  });

  // IMAP 服务相关方法和逻辑
  // --------------------------------
  /// 连接到 IMAP 服务器。
  Future<void> connectToImap() async {
    _imapClient = ImapClient(
      isLogEnabled: true,
    ); // 调试时可以考虑启用日志: isLogEnabled: true
    try {
      if (_imapClient == null) {
        throw Exception(
          'Mail client is not initialized prior to connectToServer.',
        );
      }
      await _imapClient!.connectToServer(
        imapServerHost,
        imapServerPort,
        isSecure: imapIsSecure,
      );

      if (_imapClient == null) {
        // 此检查理论上不应触发，因为 connectToServer 不应使 _imapClient 为 null
        // 但为了极致安全，可以保留
        _imapClient = null; // 确保状态一致性
        throw Exception('Mail client became null after connectToServer.');
      }
      await _imapClient!.login(username, password);

      // 根据 RFC 2971 发送客户端 ID 信息
      final appClientId = Id(
        name: AppInfo.appName, // 程序名称
        version: AppInfo.appVersion, // 程序版本号
      );

      if (_imapClient == null) {
        _imapClient = null; // 确保状态一致性
        throw Exception('Mail client became null before sending ID.');
      }
      if (appClientId.name != null && appClientId.name!.isNotEmpty) {
        await _imapClient!.id(clientId: appClientId);
        // print('IMAP ID 命令已发送，参数: ${appClientId.toMap()}'); // Id 类通常有 toMap() 或类似方法用于日志
      } else {
        await _imapClient!.id(clientId: null); // 发送 ID NIL
        // print('IMAP ID 命令已发送 (NIL)');
      }
    } on ImapException catch (_) {
      // print('连接 IMAP 服务器或发送 ID 失败: $e');
      _imapClient = null; // 连接失败时重置客户端
      // throw Exception('Failed to connect to IMAP server or login: ${e.message}');
      rethrow; // 重新抛出异常以便调用者处理
    } catch (_) {
      // print('在 IMAP connect 方法中发生非 ImapException 错误: $e');
      _imapClient = null; // 确保在任何错误情况下都重置客户端
      // 如果是 "Mail client is not initialized" 等我们主动抛出的异常，直接 rethrow
      // 否则，可以考虑包装成一个更通用的错误
      // throw Exception('An unexpected error occurred during IMAP connect: $e');
      rethrow;
    }
  }

  /// 获取邮件列表 (IMAP)。
  /// 注意: 此方法当前创建自己的客户端实例。
  /// 理想情况下，它应该使用共享的 _imapClient 实例（如果已连接）。
  /// 为简单起见，暂时保持原样，但未来可能需要重构。
  Future<List<MimeMessage>> fetchImapMessages({int count = 10}) async {
    // 理想情况下，这里应该检查 _imapClient 是否已连接并使用它
    // if (_imapClient == null || !_imapClient!.isConnected) {
    //   await connectToImap(); // 或者抛出未连接错误
    // }
    // final clientToUse = _imapClient!; // 假设已连接

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
  Future<void> disconnectImap() async {
    if (_imapClient != null &&
        (_imapClient!.isLoggedIn || _imapClient!.isConnected)) {
      try {
        // print('IMAP 客户端状态: isLoggedIn=${_imapClient!.isLoggedIn}, isConnected=${_imapClient!.isConnected}');
        if (_imapClient!.isLoggedIn) {
          await _imapClient!.logout();
          // print('IMAP 客户端已注销');
        }
        // enough_mail 的 ImapClient 在 logout 后会自动关闭连接，
        // 但显式调用 close() (如果可用且有意义) 或检查 isConnected 状态是好的做法。
        // 当前版本的 enough_mail ImapClient 没有公共的 close() 方法，
        // 连接在 logout() 后或发生致命错误时由内部管理。
        // 我们将 _imapClient 设置为 null 来表示连接已断开。
      } on ImapException {
        // print('断开 IMAP 连接失败: $e');
        // 即使注销失败，也尝试将客户端置于非活动状态
      } finally {
        _imapClient = null; // 无论成功与否，都将客户端引用置空
        // print('IMAP 客户端引用已置空');
      }
    } else {
      // print('IMAP 客户端未连接或已断开，无需操作。');
      _imapClient = null; // 确保客户端引用已置空
    }
  }

  // POP3 服务相关方法和逻辑
  // --------------------------------
  /// 连接到 POP3 服务器。
  Future<void> connectToPop3() async {
    _popClient = PopClient(isLogEnabled: false);
    try {
      if (_popClient == null) {
        throw Exception(
          'Mail client is not initialized prior to connectToServer.',
        );
      }
      await _popClient!.connectToServer(
        pop3ServerHost,
        pop3ServerPort,
        isSecure: pop3IsSecure,
      );

      if (_popClient == null) {
        // 此检查理论上不应触发
        _popClient = null; // 确保状态一致性
        throw Exception('Mail client became null after connectToServer.');
      }
      await _popClient!.login(username, password);
      // print('成功连接到 POP3 服务器');
    } on PopException catch (_) {
      // print('连接 POP3 服务器失败: $e');
      _popClient = null; // 连接失败时重置客户端
      // throw Exception('Failed to connect to POP3 server or login: ${e.message}');
      rethrow; // 重新抛出异常以便调用者处理
    } catch (_) {
      // print('在 POP3 connect 方法中发生非 PopException 错误: $e');
      _popClient = null; // 确保在任何错误情况下都重置客户端
      // throw Exception('An unexpected error occurred during POP3 connect: $e');
      rethrow;
    }
  }

  /// 获取邮件列表 (POP3)。
  /// 注意: 此方法当前创建自己的客户端实例。
  /// 理想情况下，它应该使用共享的 _popClient 实例（如果已连接）。
  Future<List<MessageListing>> fetchPop3MessageList() async {
    // 理想情况下，这里应该检查 _popClient 是否已连接并使用它
    // if (_popClient == null || !_popClient!.isLoggedIn) { // PopClient 可能没有 isConnected，检查 isLoggedIn
    //   await connectToPop3(); // 或者抛出未连接错误
    // }
    // final clientToUse = _popClient!; // 假设已连接

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
  /// 理想情况下，它应该使用共享的 _popClient 实例（如果已连接）。
  Future<MimeMessage?> retrievePop3Message(int messageNumber) async {
    // 理想情况下，这里应该检查 _popClient 是否已连接并使用它
    // if (_popClient == null || !_popClient!.isLoggedIn) {
    //   await connectToPop3();
    // }
    // final clientToUse = _popClient!;

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
  Future<void> disconnectPop3() async {
    if (_popClient != null && _popClient!.isLoggedIn) {
      // PopClient 主要通过 isLoggedIn 判断状态
      try {
        // print('POP3 客户端状态: isLoggedIn=${_popClient!.isLoggedIn}');
        await _popClient!.quit();
        // print('POP3 客户端已发送 QUIT 命令');
        // PopClient 在 quit() 后通常会关闭连接。
      } on PopException {
        // print('断开 POP3 连接失败: $e');
        // 即使 quit 失败，也尝试将客户端置于非活动状态
      } finally {
        _popClient = null; // 无论成功与否，都将客户端引用置空
        // print('POP3 客户端引用已置空');
      }
    } else {
      // print('POP3 客户端未连接或已断开，无需操作。');
      _popClient = null; // 确保客户端引用已置空
    }
  }

  // SMTP 服务相关方法和逻辑
  // --------------------------------
  final String clientDomain = 'cnmailc.client'; // 设置默认客户端域名
  bool _isAuthenticated = false; // 新增内部标志跟踪认证状态

  /// 连接并准备发送邮件（如果尚未连接）。
  /// SMTP 通常是无状态的，但在发送前需要连接和认证。
  /// 此方法确保客户端已连接并认证。
  Future<void> _ensureConnectedAndAuthenticated() async {
    if (_smtpClient == null || !_smtpClient!.isConnected || !_isAuthenticated) {
      _smtpClient = SmtpClient(clientDomain, isLogEnabled: true);
      _isAuthenticated = false; // 重置认证状态
      try {
        // 初始连接时使用 SmtpService 的 smtpIsSecure 配置
        await _smtpClient!.connectToServer(
          smtpServerHost,
          smtpServerPort,
          isSecure: smtpIsSecure,
        );
        await _smtpClient!.ehlo();

        // 检查是否需要 STARTTLS：
        // 1. 初始配置不是安全连接 (this.smtpIsSecure == false)
        // 2. 服务器支持 STARTTLS
        // enough_mail 的 SmtpClient.connectToServer 会在 isSecure: true 时尝试 SSL/TLS。
        // 如果 isSecure: false，则为普通连接。
        // SmtpClient.startTls() 用于在普通连接上升级到 TLS。
        // 我们需要确保只在初始连接不是 SSL/TLS 的情况下才尝试 STARTTLS。
        // SmtpClient 内部在 connectToServer 时如果 isSecure 为 true，则已经是安全连接了。
        // 如果 isSecure 为 false，则 client.isConnectionSecure() (假设有这个方法) 会是 false。
        // enough_mail 的 SmtpClient 没有直接暴露 isConnectionSecure 这样的状态。
        // 我们依赖于 this.smtpIsSecure (初始配置) 和 serverInfo.supportsStartTls。
        if (!smtpIsSecure && _smtpClient!.serverInfo.supportsStartTls) {
          // print('SMTP: 初始连接非安全且服务器支持 STARTTLS，尝试升级...');
          await _smtpClient!.startTls();
          // print('SMTP: STARTTLS 完成，重新 EHLO...');
          await _smtpClient!.ehlo(); // 升级后重新 EHLO
        }

        if (_smtpClient!.serverInfo.supportsAuth(AuthMechanism.plain)) {
          await _smtpClient!.authenticate(
            username,
            password,
            AuthMechanism.plain,
          );
          _isAuthenticated = true;
        } else if (_smtpClient!.serverInfo.supportsAuth(AuthMechanism.login)) {
          await _smtpClient!.authenticate(
            username,
            password,
            AuthMechanism.login,
          );
          _isAuthenticated = true;
        } else {
          // 如果都不支持，可以考虑其他机制或抛出更具体的错误
          throw SmtpException(
            _smtpClient!, // 此时 _smtpClient 已被初始化
            SmtpResponse([
              '504 SMTP server does not support PLAIN or LOGIN authentication.',
            ]),
          );
        }
      } on SmtpException {
        _smtpClient = null; // 连接或认证失败时重置客户端
        _isAuthenticated = false;
        rethrow;
      }
    }
  }

  /// 发送邮件。
  Future<void> sendEmail(MimeMessage message) async {
    try {
      await _ensureConnectedAndAuthenticated(); // 确保已连接和认证
      if (_smtpClient == null || !_isAuthenticated) {
        // 检查内部认证标志
        // 如果 _smtpClient 为 null，则 _ensureConnectedAndAuthenticated 中已抛出异常
        // 此处主要防止 _isAuthenticated 为 false 的情况
        throw SmtpException(
          _smtpClient ?? SmtpClient(clientDomain),
          SmtpResponse([
            '503 Client not authenticated or connection failed before send.',
          ]),
        );
      }
      await _smtpClient!.sendMessage(message);
      // SMTP 通常在发送后可以保持连接以发送更多邮件，
      // 或者按需断开。这里我们不在每次发送后都 quit，
      // 而是通过 disconnect 方法来管理断开。
    } on SmtpException {
      // 如果发送失败，可能需要处理连接状态，例如尝试重连或标记为断开
      // 为了简单起见，这里仅重新抛出，具体的重连逻辑可以在调用层处理
      rethrow;
    }
  }

  /// 断开与 SMTP 服务器的连接。
  Future<void> disconnectSmtp() async {
    if (_smtpClient != null && _smtpClient!.isConnected) {
      try {
        // print('SMTP 客户端状态: isConnected=${_smtpClient!.isConnected}');
        await _smtpClient!.quit();
        // print('SMTP 客户端已发送 QUIT 命令');
        // SmtpClient 在 quit() 后通常会关闭连接。
      } on SmtpException {
        // print('断开 SMTP 连接失败: $e');
        // 即使 quit 失败，也尝试将客户端置于非活动状态
      } finally {
        _smtpClient = null; // 无论成功与否，都将客户端引用置空
        // print('SMTP 客户端引用已置空');
      }
    } else {
      // print('SMTP 客户端未连接或已断开，无需操作。');
      _smtpClient = null; // 确保客户端引用已置空
    }
  }

  /// 断开所有活动邮件服务的连接。
  /// 此方法会尝试断开 IMAP, POP3 和 SMTP 服务的连接。
  /// 它会捕获并记录在断开单个服务时可能发生的任何异常，
  /// 但会继续尝试断开其他服务。
  Future<void> disconnectAllServices() async {
    // print('开始断开所有邮件服务...');
    List<Future<void>> disconnectFutures = [];
    List<String> serviceNames = [];

    // 为每个服务添加断开连接的 future
    // IMAP
    // print('准备断开 IMAP 服务...');
    disconnectFutures.add(
      disconnectImap().catchError((e) {
        // print('断开 IMAP 服务失败: $e');
        // 可以在这里记录错误，但允许其他服务继续断开
      }),
    );
    serviceNames.add('IMAP');

    // POP3
    // print('准备断开 POP3 服务...');
    disconnectFutures.add(
      disconnectPop3().catchError((e) {
        // print('断开 POP3 服务失败: $e');
      }),
    );
    serviceNames.add('POP3');

    // SMTP
    // print('准备断开 SMTP 服务...');
    disconnectFutures.add(
      disconnectSmtp().catchError((e) {
        // print('断开 SMTP 服务失败: $e');
      }),
    );
    serviceNames.add('SMTP');

    // 等待所有断开操作完成
    final results = await Future.wait(
      disconnectFutures.asMap().entries.map((entry) async {
        try {
          await entry.value;
          // print('${serviceNames[entry.key]} 服务已成功断开或无需操作。');
          return null; // 表示成功或无需操作
        } catch (e) {
          // print('在等待 ${serviceNames[entry.key]} 服务断开时捕获到未处理的错误: $e');
          return e; // 返回错误对象
        }
      }),
    );

    // 检查是否有错误发生
    bool allDisconnectedSuccessfully = true;
    for (int i = 0; i < results.length; i++) {
      if (results[i] != null) {
        allDisconnectedSuccessfully = false;
        // print('服务 ${serviceNames[i]} 在断开过程中遇到错误: ${results[i]}');
      }
    }

    if (allDisconnectedSuccessfully) {
      // print('所有邮件服务均已成功断开或之前未连接。');
    } else {
      // print('部分邮件服务在断开过程中遇到问题。请检查日志。');
      // 可以考虑抛出一个聚合错误，或者根据需求处理
    }
  }
}
