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

`MailService` 类 ([`lib/services/mail/mail_service.dart`](lib/services/mail/mail_service.dart:3)) 封装了与邮件服务器交互的逻辑，包括 POP3、IMAP 和 SMTP 协议。以下是如何使用 `MailService` 来调用这些服务的示例。

### 调用说明

1. **创建 `MailService` 实例**:
    首先，创建一个 `MailService` 实例，并通过 `configure` 方法提供邮件账户的详细信息（用户名、密码）以及 POP3、IMAP 和 SMTP 服务器的配置（主机、端口、是否使用 SSL/TLS 加密、是否启用日志）。

2. **调用服务方法**:
    使用 `MailService` 实例直接执行邮件操作，例如获取邮件列表、检索特定邮件或发送邮件。

3. **错误处理**:
    所有服务方法都是异步的 (`Future`)，并且在发生错误时会打印错误信息。你应该使用 `try-catch` 块来处理这些潜在的错误。

4. **依赖**:
    此示例依赖于 `enough_mail` 包。请确保已将其添加到你的 `pubspec.yaml` 文件中。

### Dart 代码示例

```dart
import 'package:cnmailc/services/mail/mail_service.dart';
import 'package:enough_mail/enough_mail.dart'; // 导入 MimeMessage 等

// 这是一个演示函数，实际使用时请替换为你的应用逻辑
Future<void> demonstrateMailService() async {
  // 1. 配置邮件服务参数 (请替换为你的实际配置)
  const String username = 'your_email@example.com';
  const String password = 'your_password';

  // POP3 服务器配置
  const String popHost = 'pop.example.com';
  const int popPort = 995; // 通常 SSL/TLS 端口
  const bool popIsSecure = true;

  // IMAP 服务器配置
  const String imapHost = 'imap.example.com';
  const int imapPort = 993; // 通常 SSL/TLS 端口
  const bool imapIsSecure = true;

  // SMTP 服务器配置
  const String smtpHost = 'smtp.example.com';
  const int smtpPort = 465; // 通常 SSL/TLS 端口 (或者 587 STARTTLS)
  const bool smtpIsSecure = true;

  // 日志配置
  const bool isLogEnabled = false; // 是否启用日志输出

  // 2. 创建 MailService 实例并配置
  final mailService = MailService();
  mailService.configure(
    userName: username,
    password: password,
    imapServerHost: imapHost,
    imapServerPort: imapPort,
    isImapServerSecure: imapIsSecure,
    popServerHost: popHost,
    popServerPort: popPort,
    isPopServerSecure: popIsSecure,
    smtpServerHost: smtpHost,
    smtpServerPort: smtpPort,
    isSmtpServerSecure: smtpIsSecure,
    isLogEnabled: isLogEnabled,
  );

  // 3. 使用 IMAP 服务获取邮件
  try {
    print('尝试获取 IMAP 邮件 (最近10封)...');
    final List<MimeMessage> imapMessages = await mailService.fetchImapMessages(messageCount: 10);
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

  // 4. 使用 POP3 服务获取邮件
  try {
    print('尝试获取 POP3 邮件...');
    final List<MimeMessage> popMessages = await mailService.fetchPopMessages();
    print('获取到 ${popMessages.length} 封 POP3 邮件。');
    for (final message in popMessages) {
      print('POP3 邮件主题: ${message.decodeSubject()}');
    }
  } on PopException catch (e) {
    print('POP3 操作失败: $e');
  } catch (e) {
    print('发生未知错误 (POP3): $e');
  }

  print('\n' + '-' * 20 + '\n');

  // 5. 使用 SMTP 服务发送邮件
  try {
    print('尝试发送邮件...');
    final bool sendResult = await mailService.sendSmtpMessage(
      from: username,
      to: 'recipient@example.com', // 请替换为实际收件人地址
      subject: '来自 CNMailC 的测试邮件',
      plainText: '这是一封通过 CNMailC 发送的纯文本测试邮件。',
      htmlText: '<p>这是一封通过 <b>CNMailC</b> 发送的 HTML 测试邮件。</p>',
    );
    if (sendResult) {
      print('邮件发送成功!');
    } else {
      print('邮件发送失败。');
    }
  } on SmtpException catch (e) {
    print('SMTP 操作失败: $e');
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
* **异步操作**: 所有邮件操作都是异步的，请正确使用 `async/await`。
