# 卡片

## 主题与样式 (Theming and Styling)

### `getAdaptiveStadiumBorder()`

`getAdaptiveStadiumBorder()` 函数提供一个自适应的胶囊形状边框。它会根据当前的平台（Material 或 Cupertino）返回相应的 `StadiumBorder` 或带有圆角的 `RoundedRectangleBorder`。

此函数非常适用于 `ListTile`、`Card` 等组件的 `shape` 属性，以创建具有平台自适应圆角的 UI 元素。

**使用方法:**

1. **导入函数:**

    ```dart
    import 'package:cnmailc/themes/theme_manager.dart';
    ```

2. **在组件中使用:**

    ```dart
    Card(
      shape: getAdaptiveStadiumBorder(),
      child: ListTile(
        title: Text('一个列表项'),
        // ...
      ),
    )
    ```

3. **在 ThemeData 中使用:**

    ```dart
    ThemeData(
      listTileTheme: ListTileThemeData(
        shape: getAdaptiveStadiumBorder(),
      ),
      cardTheme: CardTheme(
        shape: getAdaptiveStadiumBorder(),
      ),
      // ...
    )
    ```

## 邮件服务 (`MailService`) 使用示例

`MailService` 类 ([`lib/services/mail/mail_service.dart`](lib/services/mail/mail_service.dart:6)) 封装了与邮件服务器交互的逻辑，包括 POP3、IMAP 和 SMTP 协议。以下是如何使用 `MailService` 来调用这些服务的示例。

### 调用说明

1. **创建 `MailService` 实例**:
    首先，你需要提供邮件账户的详细信息（用户名、密码）以及 POP3、IMAP 和 SMTP 服务器的配置（主机、端口、是否使用 SSL/TLS 加密）来实例化 `MailService`。

2. **获取具体服务实例**:
    通过 `MailService` 实例的 getter 方法 (`popService`, `imapService`, `smtpService`) 获取相应的服务实例。

3. **调用服务方法**:
    使用获取到的具体服务实例来执行邮件操作，例如获取邮件列表、检索特定邮件或发送邮件。

4. **错误处理**:
    所有服务方法都是异步的 (`Future`)，并且在发生错误时会重新抛出异常（例如 `PopException`, `ImapException`, `SmtpException`）。你应该使用 `try-catch` 块来处理这些潜在的错误。

5. **依赖**:
    此示例依赖于 `enough_mail` 包。请确保已将其添加到你的 `pubspec.yaml` 文件中。

### Dart 代码示例

```dart
import 'package:cnmailc/services/mail/mail_service.dart';
import 'package:cnmailc/services/mail/pop_service.dart';
import 'package:cnmailc/services/mail/imap_service.dart';
import 'package:cnmailc/services/mail/smtp_service.dart';
import 'package:enough_mail/enough_mail.dart'; // 导入 MimeMessage 等

// 这是一个演示函数，实际使用时请替换为你的应用逻辑
Future<void> demonstrateMailService() async {
  // 1. 配置邮件服务参数 (请替换为你的实际配置)
  const String username = 'your_email@example.com';
  const String password = 'your_password';

  // POP3 服务器配置
  const String pop3Host = 'pop.example.com';
  const int pop3Port = 995; // 通常 SSL/TLS 端口
  const bool pop3IsSecure = true;

  // IMAP 服务器配置
  const String imapHost = 'imap.example.com';
  const int imapPort = 993; // 通常 SSL/TLS 端口
  const bool imapIsSecure = true;

  // SMTP 服务器配置
  const String smtpHost = 'smtp.example.com';
  const int smtpPort = 465; // 通常 SSL/TLS 端口 (或者 587 STARTTLS)
  const bool smtpIsSecure = true;
  const String clientDomain = 'your_client_domain.com'; // SMTP 服务需要, 请替换

  // 2. 创建 MailService 实例
  final mailService = MailService(
    username: username,
    password: password,
    pop3ServerHost: pop3Host,
    pop3ServerPort: pop3Port,
    pop3IsSecure: pop3IsSecure,
    imapServerHost: imapHost,
    imapServerPort: imapPort,
    imapIsSecure: imapIsSecure,
    smtpServerHost: smtpHost,
    smtpServerPort: smtpPort,
    smtpIsSecure: smtpIsSecure,
  );

  // 3. 使用 POP3 服务
  final PopService popService = mailService.popService;
  try {
    print('尝试连接到 POP3 服务器...');
    await popService.connect(); // MailService 内部已处理连接，但 PopService 也提供了独立的 connect
    print('POP3 连接成功。');

    print('尝试获取 POP3 邮件列表...');
    final List<dynamic> popMessages = await popService.fetchMessageList();
    print('获取到 ${popMessages.length} 封 POP3 邮件列表项。');
    if (popMessages.isNotEmpty) {
      // 假设我们想获取第一封邮件的详情
      // 注意: POP3 邮件编号通常从 1 开始，并且可能与列表索引不同。
      // PopMessageItem 通常包含邮件的唯一ID或序号，用于 retrieveMessage。
      // 这里的示例假设 popMessages[0] 包含一个可用的 messageNumber 或 uid。
      // 在实际应用中，你需要从 PopMessageItem 中提取正确的邮件编号。
      // 例如: final int messageNumberToRetrieve = popMessages[0].messageNumber; (假设有此属性)
      // 为了演示，我们假设要获取编号为 1 的邮件 (如果存在)
      if (popMessages.length >= 1) { // 确保至少有一封邮件
        // 假设 popMessages 列表中的元素可以直接用于获取邮件编号，
        // 或者你需要从这些元素中提取邮件的唯一标识符。
        // 对于 `enough_mail` 的 `PopClient.list()`, 返回的是 `PopMessageInfo` 列表。
        // `PopMessageInfo` 有 `messageNumber` 属性。
        if (popMessages[0] is PopMessageInfo) {
            final messageNumberToRetrieve = (popMessages[0] as PopMessageInfo).messageNumber;
            if (messageNumberToRetrieve != null) {
                 print('尝试获取 POP3 邮件编号: $messageNumberToRetrieve...');
                 final MimeMessage? specificPopMessage = await popService.retrieveMessage(messageNumberToRetrieve);
                 if (specificPopMessage != null) {
                    print('成功获取 POP3 邮件: ${specificPopMessage.decodeSubject()}');
                 } else {
                    print('未能获取到指定的 POP3 邮件。');
                 }
            } else {
                print('POP3 邮件列表项中没有有效的 messageNumber。');
            }
        } else {
            print('POP3 邮件列表项类型不符合预期 (PopMessageInfo)。');
        }
      }
    }
  } on PopException catch (e) {
    print('POP3 操作失败: $e');
  } catch (e) {
    print('发生未知错误 (POP3): $e');
  }

  print('\n' + '-' * 20 + '\n');

  // 4. 使用 IMAP 服务
  final ImapService imapService = mailService.imapService;
  try {
    print('尝试连接到 IMAP 服务器...');
    await imapService.connect(); // MailService 内部已处理连接，但 ImapService 也提供了独立的 connect
    print('IMAP 连接成功。');

    print('尝试获取 IMAP 邮件 (最近10封)...');
    final List<MimeMessage> imapMessages = await imapService.fetchMessages(count: 10);
    print('获取到 ${imapMessages.length} 封 IMAP 邮件。');
    for (final message in imapMessages) {
      print('IMAP 邮件主题: ${message.decodeSubject()}');
    }
  } on ImapException catch (e) {
    print('IMAP 操作失败: $e');
  } catch (e) {
    print('发生未知错误 (IMAP): $e');
  }

  print('\n' + '-' * 20 + '\n');

  // 5. 使用 SMTP 服务发送邮件
  final SmtpService smtpService = mailService.smtpService;
  try {
    print('尝试发送邮件...');
    // 构建邮件内容
    final mailBuilder = MessageBuilder.prepareMultipartAlternativeMessage(
      plainText: '这是一封通过 CNMailC 发送的纯文本测试邮件。',
      htmlText: '<p>这是一封通过 <b>CNMailC</b> 发送的 HTML 测试邮件。</p>',
    )
      ..from = [MailAddress(username, 'CNMailC 发件人')] // 发件人显示名称和地址
      ..to = [MailAddress('recipient@example.com', '测试收件人')] // 收件人地址和名称 (请替换)
      ..subject = '来自 CNMailC 的测试邮件';

    final MimeMessage messageToSend = mailBuilder.buildMimeMessage();

    // 注意: SmtpService 内部的 SmtpClient 初始化时需要一个客户端域名。
    // 在 SmtpService.dart 中，它被硬编码为 'your_client_domain.com'。
    // 理想情况下，这个域名应该通过 MailService 或 SmtpService 的构造函数传入。
    // 为了这个示例能运行，你需要修改 SmtpService.dart 中的占位符，
    // 或者修改 SmtpService 以接受 clientDomain 参数。
    // 这里我们假设 SmtpService 内部已正确配置或你已修改它。
    // 如果 SmtpService.dart 中的 `SmtpClient('your_client_domain.com', ...)` 未修改，
    // 你可能需要像下面这样直接使用 SmtpClient，或者修改 SmtpService。

    // **重要提示**: SmtpService.dart 中的 `SmtpClient` 初始化使用了占位符 `your_client_domain.com`。
    // 你需要将其替换为你的实际客户端域名，否则邮件发送可能会失败或被标记为垃圾邮件。
    // 例如: `final client = SmtpClient(clientDomain, isLogEnabled: true);`
    // 确保 `clientDomain` 是一个有效的、你控制的或公共的域名。

    await smtpService.sendEmail(messageToSend);
    print('邮件发送成功!');
  } on SmtpException catch (e) {
    print('SMTP 操作失败: $e');
    if (e.message?.contains('550') ?? false) {
        print('详细错误: 可能是收件人地址无效或被拒收。');
    }
  } catch (e) {
    print('发生未知错误 (SMTP): $e');
  }
}

// 你可以在你的 main 函数或其他地方调用这个演示函数：
// void main() async {
//   await demonstrateMailService();
// }
```

**重要注意事项:**

* **安全性**: 切勿在生产代码中硬编码密码。请使用安全的方式（如环境变量、配置文件、密钥管理服务）来存储和访问敏感凭据。
* **错误处理**: 上述示例中的错误处理比较基础。在实际应用中，你应该根据具体错误类型和业务需求实现更完善的错误处理和用户反馈机制。
* **服务器配置**: 确保你提供的 POP3、IMAP 和 SMTP 服务器信息是准确的。端口号和加密设置（`isSecure`）必须与你的邮件提供商的要求一致。
* **SMTP 客户端域名**: 如代码注释中所述，`SmtpService` 内部使用的 `SmtpClient` 初始化时需要一个客户端域名。请务必修改 [`lib/services/mail/smtp_service.dart`](lib/services/mail/smtp_service.dart:22) 中的占位符 `your_client_domain.com` 为你实际的客户端域名，或者修改 `SmtpService` 以允许通过构造函数传递此域名。
* **POP3 邮件编号**: 获取特定 POP3 邮件时，你需要知道邮件的编号。`PopService.fetchMessageList()` 返回的列表中通常包含这些信息（例如 `PopMessageInfo.messageNumber`），你需要从中提取正确的编号。
* **异步操作**: 所有邮件操作都是异步的，请正确使用 `async/await`。
