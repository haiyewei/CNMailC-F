import 'package:flutter/material.dart';

class MailSettingsPage extends StatelessWidget {
  const MailSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('邮箱设置'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Card(
              child: ListTile(
                leading: const Icon(Icons.add_circle_outline),
                title: const Text('添加邮箱'),
                onTap: () {
                  // 导航到添加邮箱页面
                },
              ),
            ),
            const SizedBox(height: 16.0),
            Card(
              child: ListTile(
                leading: const Icon(Icons.save_alt),
                title: const Text('已保存的邮箱'),
                onTap: () {
                  // 导航到已保存的邮箱页面
                },
              ),
            ),
            const SizedBox(height: 16.0),
            Card(
              child: ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('编辑邮箱'),
                onTap: () {
                  // 导航到编辑邮箱页面
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}