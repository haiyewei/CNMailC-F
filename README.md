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
