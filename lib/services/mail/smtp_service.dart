import 'package:enough_mail/enough_mail.dart';

/// SMTP 服务类，处理 SMTP 协议相关的邮件发送操作。
class SmtpService {
  final String username;
  final String password;
  final String smtpServerHost;
  final int smtpServerPort;
  final bool smtpIsSecure;
  final String clientDomain; // 添加客户端域名属性

  SmtpClient? _client;

  /// 构造函数，传入 SMTP 服务的配置参数。
  SmtpService({
    required this.username,
    required this.password,
    required this.smtpServerHost,
    required this.smtpServerPort,
    required this.smtpIsSecure,
    this.clientDomain = 'cnmailc.client', // 设置默认或允许外部传入
  });

  bool _isAuthenticated = false; // 新增内部标志跟踪认证状态

  /// 连接并准备发送邮件（如果尚未连接）。
  /// SMTP 通常是无状态的，但在发送前需要连接和认证。
  /// 此方法确保客户端已连接并认证。
  Future<void> _ensureConnectedAndAuthenticated() async {
    if (_client == null || !_client!.isConnected || !_isAuthenticated) {
      _client = SmtpClient(clientDomain, isLogEnabled: true);
      _isAuthenticated = false; // 重置认证状态
      try {
        // 初始连接时使用 SmtpService 的 smtpIsSecure 配置
        await _client!.connectToServer(
          smtpServerHost,
          smtpServerPort,
          isSecure: smtpIsSecure,
        );
        await _client!.ehlo();

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
        if (!smtpIsSecure && _client!.serverInfo.supportsStartTls) {
          // print('SMTP: 初始连接非安全且服务器支持 STARTTLS，尝试升级...');
          await _client!.startTls();
          // print('SMTP: STARTTLS 完成，重新 EHLO...');
          await _client!.ehlo(); // 升级后重新 EHLO
        }

        if (_client!.serverInfo.supportsAuth(AuthMechanism.plain)) {
          await _client!.authenticate(username, password, AuthMechanism.plain);
          _isAuthenticated = true;
        } else if (_client!.serverInfo.supportsAuth(AuthMechanism.login)) {
          await _client!.authenticate(username, password, AuthMechanism.login);
          _isAuthenticated = true;
        } else {
          // 如果都不支持，可以考虑其他机制或抛出更具体的错误
          throw SmtpException(
            _client!, // 此时 _client 已被初始化
            SmtpResponse([
              '504 SMTP server does not support PLAIN or LOGIN authentication.',
            ]),
          );
        }
      } on SmtpException {
        _client = null; // 连接或认证失败时重置客户端
        _isAuthenticated = false;
        rethrow;
      }
    }
  }

  /// 发送邮件。
  Future<void> sendEmail(MimeMessage message) async {
    try {
      await _ensureConnectedAndAuthenticated(); // 确保已连接和认证
      if (_client == null || !_isAuthenticated) {
        // 检查内部认证标志
        // 如果 _client 为 null，则 _ensureConnectedAndAuthenticated 中已抛出异常
        // 此处主要防止 _isAuthenticated 为 false 的情况
        throw SmtpException(
          _client ?? SmtpClient(clientDomain),
          SmtpResponse([
            '503 Client not authenticated or connection failed before send.',
          ]),
        );
      }
      await _client!.sendMessage(message);
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
  Future<void> disconnect() async {
    if (_client != null && _client!.isConnected) {
      try {
        // print('SMTP 客户端状态: isConnected=${_client!.isConnected}');
        await _client!.quit();
        // print('SMTP 客户端已发送 QUIT 命令');
        // SmtpClient 在 quit() 后通常会关闭连接。
      } on SmtpException {
        // print('断开 SMTP 连接失败: $e');
        // 即使 quit 失败，也尝试将客户端置于非活动状态
      } finally {
        _client = null; // 无论成功与否，都将客户端引用置空
        // print('SMTP 客户端引用已置空');
      }
    } else {
      // print('SMTP 客户端未连接或已断开，无需操作。');
      _client = null; // 确保客户端引用已置空
    }
  }
}
