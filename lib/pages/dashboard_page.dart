import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      // 移除了 Center，修改了 Padding
      padding: const EdgeInsets.all(5.0), // 与 mail_settings_page.dart 保持一致
      child: Column(
        // 添加 Column 和 Expanded 使卡片能够扩展
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Card(
              elevation: 0,
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              shadowColor: colorScheme.shadow.withAlpha(
                51,
              ), // 保持原有的 shadowColor Alpha 值
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  // mainAxisSize: MainAxisSize.min, // 移除此行以允许扩展
                  mainAxisAlignment: MainAxisAlignment.center, // 使内容在卡片中居中
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: colorScheme.primary,
                      size: 80,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '创建成功',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '所有组件已成功创建',
                      style: TextStyle(
                        fontSize: 16,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ], // Card 内部 Column 的 children 结束
                ), // Card 内部的 Column 结束
              ), // Card 内部的 Padding 结束
            ), // Card 结束
          ), // Expanded 结束
        ], // 外部 Column 的 children 结束
      ), // 外部 Column 结束
    ); // 外部 Padding 结束
  }
}
