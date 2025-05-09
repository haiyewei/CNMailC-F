import 'package:flutter/material.dart';

class MailSettingsPage extends StatelessWidget {
  const MailSettingsPage({super.key});

  Widget _buildCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
      shadowColor: colorScheme.shadow.withAlpha((255 * 0.2).round()),
      surfaceTintColor: colorScheme.surfaceTint,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: InkWell( // 使用 InkWell 实现点击效果
        borderRadius: BorderRadius.circular(28), // 保持与 Card shape 一致的圆角
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row( // 使用 Row 来模仿 settings_page.dart 中的布局
            children: [
              Icon(icon, color: colorScheme.primary, size: 28),
              const SizedBox(width: 16),
              Expanded( // 使用 Expanded 确保文本能够正确换行
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 20, // 调整字体大小以匹配 settings_page
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: colorScheme.onSurfaceVariant, size: 18), // 添加向右箭头
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final ColorScheme colorScheme = Theme.of(context).colorScheme; // 已在 _buildCard 中获取
    return Scaffold(
      appBar: AppBar(
        title: const Text('邮箱设置'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildCard(
              context: context,
              icon: Icons.add_circle_outline,
              title: '添加邮箱',
              onTap: () {
                // 导航到添加邮箱页面
              },
            ),
            const SizedBox(height: 16.0),
            _buildCard(
              context: context,
              icon: Icons.save_alt,
              title: '已保存的邮箱',
              onTap: () {
                // 导航到已保存的邮箱页面
              },
            ),
            const SizedBox(height: 16.0),
            _buildCard(
              context: context,
              icon: Icons.edit,
              title: '编辑邮箱',
              onTap: () {
                // 导航到编辑邮箱页面
              },
            ),
          ],
        ),
      ),
    );
  }
}