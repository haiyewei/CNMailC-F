import 'package:flutter/material.dart';

class EditMailCard extends StatelessWidget {
  final VoidCallback onExit;

  const EditMailCard({super.key, required this.onExit});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
      shadowColor: colorScheme.shadow.withAlpha((255 * 0.2).round()),
      surfaceTintColor: colorScheme.surfaceTint,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.all(16.0), // 统一使用与 mail_settings_page 一致的内边距
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center, // 移除以允许标题在顶部
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // 新增标题行
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0), // 减小标题内容的内边距
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.edit, color: colorScheme.primary, size: 28),
                  const SizedBox(width: 16),
                  Text(
                    '编辑邮箱账户', // 更明确的标题
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const Spacer(), // 将按钮推到右侧
                  ElevatedButton.icon(
                    icon: Icon(Icons.close, color: colorScheme.onError),
                    label: Text(
                      '退出',
                      style: TextStyle(color: colorScheme.onError),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.error,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    onPressed: onExit,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8.0), // 减小标题行与Divider之间的间距
            const Divider(), // 标题下方的分隔符
            const SizedBox(height: 24), // 分隔符与主要内容的间距
            // 原有内容
            Expanded(
              // 使内容区域填充剩余空间
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    // 移除了 const
                    '“编辑邮箱”卡片组件创建成功！',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
