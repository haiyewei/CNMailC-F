import 'package:enough_mail/enough_mail.dart';
import 'package:cnmailc/services/mail/mail_service.dart';

class MailTest {
  final MailService mailService;
  final bool useImap;

  MailTest({
    required this.mailService,
    required this.useImap,
  });

  Future<String> runMailTest() async {
    try {
      // 发送测试邮件
      final builder = MessageBuilder.prepareMultipartAlternativeMessage(
        plainText: '这是一封测试邮件，请勿回复。',
        htmlText: '这是一封测试邮件，请勿回复。',
      )
        ..from = [MailAddress('CNMailC', mailService.userName)]
        ..to = [MailAddress('MY-EMAIL', mailService.userName)]
        ..subject = '测试邮件';
      final mimeMessage = builder.buildMimeMessage();
      bool sendResult = await mailService.sendSmtpMessage(
        from: '',
        to: '',
        subject: '测试邮件',
        plainText: '这是一封测试邮件，请勿回复。',
        mimeMessage: mimeMessage,
      );

      if (!sendResult) {
        return '发送测试邮件失败：可能是 SMTP 配置错误或服务器拒绝了请求';
      }

      // 等待一段时间以确保邮件到达
      await Future.delayed(Duration(seconds: 5));

      // 接收邮件
      List<MimeMessage> messages;
      if (useImap) {
        messages = await mailService.fetchImapMessages(messageCount: 1);
      } else {
        messages = await mailService.fetchPopMessages();
      }

      if (messages.isEmpty) {
        return '未收到测试邮件';
      }

      // 由于 enough_mail 库的限制，暂时不实现删除功能，直接提示成功
      return '测试成功：邮件已发送并接收';
    } catch (e) {
      return '测试失败：连接服务器时出错 - $e';
    }
  }
}
