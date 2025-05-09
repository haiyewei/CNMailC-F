import 'package:flutter/material.dart';

class SentPage extends StatelessWidget {
  const SentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Card(
              elevation: 0,
              color: Colors.transparent,
              shadowColor: colorScheme.shadow.withAlpha((255 * 0.2).round()),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // 在这里可以添加发件箱页面的具体内容
                    // 例如，邮件列表等
                    // 为了演示，我们先放一个简单的文本
                    Expanded(
                      child: Center(
                        child: Text(
                          '发件箱内容将显示在此处',
                          style: TextStyle(color: colorScheme.onSurfaceVariant),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}