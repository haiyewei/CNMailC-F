import 'package:flutter/material.dart';
import '../components/add_mail_card.dart'; // 导入 AddMailCard
import '../components/edit_mail_card.dart'; // 导入 EditMailCard

enum _CardType { main, add, edit }

class MailSettingsPage extends StatefulWidget {
  const MailSettingsPage({super.key});

  @override
  State<MailSettingsPage> createState() => _MailSettingsPageState();
}

class _MailSettingsPageState extends State<MailSettingsPage> {
  _CardType _currentCard = _CardType.main;

  Widget _buildMainCard() {
    final colorScheme = Theme.of(context).colorScheme;
    // _buildCard 的逻辑现在移到这里，并根据需要调整
    // 原 _buildCard 的 onTap 参数不再直接使用，而是通过内部按钮的 onTap 改变状态

    return Card(
      elevation: 2,
      shadowColor: colorScheme.shadow.withAlpha((255 * 0.2).round()),
      surfaceTintColor: colorScheme.surfaceTint,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding( // 移除了外部InkWell，因为主卡片本身不可点击，而是其内部元素可点击
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0), // 减小按钮行与Divider的间距
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _currentCard = _CardType.add;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0), // 减小按钮内边距
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_circle_outline, color: colorScheme.primary, size: 28),
                            const SizedBox(width: 16),
                            Text(
                              '添加邮箱',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _currentCard = _CardType.edit;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0), // 减小按钮内边距
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.edit, color: colorScheme.primary, size: 28),
                            const SizedBox(width: 16),
                            Text(
                              '编辑邮箱',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            const SizedBox(height: 16), // 添加一些空间，如果下面有内容的话
            // 此处可以放置主卡片的其他内容，例如已保存邮箱列表
            // 为简单起见，暂时留空或放置一个提示
            Expanded(
              child: Center(
                child: Text(
                  '已保存的邮箱列表将显示在此处',
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget cardToDisplay;
    switch (_currentCard) {
      case _CardType.add:
        cardToDisplay = AddMailCard(onExit: () {
          setState(() {
            _currentCard = _CardType.main;
          });
        });
        break;
      case _CardType.edit:
        cardToDisplay = EditMailCard(onExit: () {
          setState(() {
            _currentCard = _CardType.main;
          });
        });
        break;
      case _CardType.main:
        cardToDisplay = _buildMainCard();
        break;

    }

    return Padding(
      padding: const EdgeInsets.all(5), // 根据之前的修改，这里的padding值可能是16或5
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: cardToDisplay,
          ),
        ],
      ),
    );
  }
}