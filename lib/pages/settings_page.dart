import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../themes/theme_manager.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:window_manager/window_manager.dart';
import '../services/notify/notify.dart'; // 导入 app_notify
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_info.dart';

class SystemSettingsPage extends StatefulWidget {
  const SystemSettingsPage({super.key});

  @override
  State<SystemSettingsPage> createState() => _SystemSettingsPageState();
}

class _SystemSettingsPageState extends State<SystemSettingsPage> {
  List<ColorOption> _colorOptions = [];
  List<ColorOption> _filteredColorOptions = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  bool _isColorSectionExpanded = false;
  late LaunchAtStartup _launchAtStartup;
  bool _isLaunchAtStartupEnabled = false;

  // 检查是否在桌面平台运行
  bool _isDesktop() {
    if (kIsWeb) {
      return false; // Web平台不被视为桌面平台
    }
    return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
  }

  // 添加估算颜色亮度的方法
  static Brightness estimateBrightnessForColor(Color color) {
    final double relativeLuminance =
        0.2126 * color.r + 0.7152 * color.g + 0.0722 * color.b;
    return relativeLuminance > 128 ? Brightness.light : Brightness.dark;
  }

  @override
  void initState() {
    super.initState();
    _loadColors();
    _searchController.addListener(_searchColors);
    _initializeLaunchAtStartup();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchColors() {
    if (_searchController.text.isEmpty) {
      setState(() {
        _filteredColorOptions = List.from(_colorOptions);
      });
    } else {
      final query = _searchController.text.toLowerCase();
      setState(() {
        _filteredColorOptions =
            _colorOptions
                .where(
                  (color) =>
                      color.name.toLowerCase().contains(query) ||
                      color.pinyinName.toLowerCase().contains(query),
                )
                .toList();
      });
    }
  }

  Future<void> _loadColors() async {
    try {
      // 加载colors.json文件
      final String jsonString = await rootBundle.loadString(
        'assets/themes/colors.json',
      );
      final List<dynamic> colorsJson = jsonDecode(jsonString);

      // 将JSON数据转换为ColorOption对象
      setState(() {
        _colorOptions =
            colorsJson
                .map(
                  (json) => ColorOption(
                    color: HexColor.fromHex(json['hex']),
                    name: json['zh-Hans-name'],
                    pinyinName: json['pinyin-name'],
                  ),
                )
                .toList();
        _filteredColorOptions = List.from(_colorOptions);
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('加载颜色失败: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _initializeLaunchAtStartup() async {
    _launchAtStartup = LaunchAtStartup.instance;
    await _setupLaunchAtStartup(); // 调用新的设置方法
    await _loadLaunchAtStartupStatus();
  }

  Future<void> _setupLaunchAtStartup() async {
    if (!_isDesktop()) return; // 仅在桌面平台设置

    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String? packageName;
      if (Platform.isWindows && packageInfo.packageName.isNotEmpty) {
        // 根据 launch_at_startup 文档，packageName 仅在应用为 MSIX 打包时才需要。
        // 为了安全起见，在 Windows 上如果 packageInfo.packageName 可用，则提供它。
        packageName = packageInfo.packageName;
      }

      _launchAtStartup.setup(
        appName: packageInfo.appName,
        appPath: Platform.resolvedExecutable,
        packageName: packageName,
      );
      debugPrint('Launch at startup setup successful for ${packageInfo.appName}');
    } catch (e) {
      debugPrint('Error setting up launch at startup: $e');
      // 可以选择性地通知用户设置失败
      NotifyController().showNotify(NotifyData(
        message: '设置开机自启失败: $e',
        type: NotifyType.app,
        time: DateTime.now(),
      ));
    }
  }

  Future<void> _loadLaunchAtStartupStatus() async {
    final isEnabled = await _launchAtStartup.isEnabled();
    if (mounted) {
      setState(() {
        _isLaunchAtStartupEnabled = isEnabled;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final colorScheme = Theme.of(context).colorScheme;
    final isDesktop = _isDesktop();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(5),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: double.infinity),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            _buildSection(
            title: '外观设置',
            icon: Icons.palette_outlined,
            children: [
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else
                _buildColorSelector(themeManager),
              // Divider(color: colorScheme.outlineVariant), // Removed
              SwitchListTile(
                title: const Text('跟随系统主题'),
                value: themeManager.followSystem,
                secondary: Icon(
                  Icons.brightness_auto,
                  color: colorScheme.primary,
                ),
                onChanged: (value) {
                  themeManager.setFollowSystem(value);
                  NotifyController().showNotify(NotifyData(
                    message: value ? '已启用跟随系统主题' : '已禁用跟随系统主题',
                    type: NotifyType.app,
                    time: DateTime.now(),
                  ));
                },
              ),
              if (!themeManager.followSystem) ...[
                // Divider(color: colorScheme.outlineVariant), // Removed
                SwitchListTile(
                  title: const Text('深色模式'),
                  value: themeManager.isDarkMode,
                  secondary: Icon(
                    themeManager.isDarkMode
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    color: colorScheme.primary,
                  ),
                  onChanged: (value) {
                    themeManager.setDarkMode(value);
                    NotifyController().showNotify(NotifyData(
                      message: value ? '已切换到深色模式' : '已切换到亮色模式',
                      type: NotifyType.app,
                      time: DateTime.now(),
                    ));
                  },
                ),
              ],
              // 添加质感设计3开关（移到条件块外）
              // Divider(color: colorScheme.outlineVariant), // Removed
              SwitchListTile(
                title: const Text('质感设计3'),
                value: themeManager.useMaterial3,
                secondary: Icon(Icons.color_lens, color: colorScheme.primary),
                onChanged: (value) {
                  themeManager.setUseMaterial3(value);
                  NotifyController().showNotify(NotifyData(
                    message: value ? '已启用质感设计3颜色生成' : '已使用原始颜色模式',
                    type: NotifyType.app,
                    time: DateTime.now(),
                  ));
                },
              ),
              // 仅在桌面平台上显示侧边栏固定选项
              if (isDesktop) ...[
                // Divider(color: colorScheme.outlineVariant), // Removed
                SwitchListTile(
                  title: const Text('固定侧边栏'),
                  value: themeManager.fixedSidebar,
                  secondary: Icon(Icons.dock, color: colorScheme.primary),
                  onChanged: (value) {
                    themeManager.setFixedSidebar(value);
                    NotifyController().showNotify(NotifyData(
                      message: value ? '侧边栏已固定' : '侧边栏已取消固定',
                      type: NotifyType.app,
                      time: DateTime.now(),
                    ));
                  },
                ),
              ],
              // Divider(color: colorScheme.outlineVariant), // Removed
              ListTile(
                title: const Text('重置为默认主题'),
                leading: Icon(Icons.refresh, color: colorScheme.primary),
                onTap: () {
                  themeManager.resetToDefault();
                  // setState(() {}); // ThemeManager should handle rebuild
                  NotifyController().showNotify(NotifyData(
                    message: '已重置为默认主题',
                    type: NotifyType.app,
                    time: DateTime.now(),
                  ));
                },
              ),
            ],
          ),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 16.0), child: Divider()), // Added Divider with Padding
          const SizedBox(height: 16),
          // 仅在桌面平台上添加高级设置部分
          if (isDesktop) ...[
            _buildSection(
              title: '高级设置',
              icon: Icons.settings_outlined,
              children: [
                SwitchListTile(
                  title: const Text('后台存活'),
                  value: themeManager.minimizeToTray,
                  secondary: Icon(
                    Icons.offline_pin,
                    color: colorScheme.primary,
                  ),
                  onChanged: (value) {
                    themeManager.setMinimizeToTray(value);
                  },
                ),
                // Divider(color: colorScheme.outlineVariant), // Removed
                SwitchListTile(
                 title: const Text('开机自启'),
                 value: _isLaunchAtStartupEnabled,
                 secondary: Icon(
                   Icons.power_settings_new,
                   color: colorScheme.primary,
                 ),
                 onChanged: (value) async {
                   if (value) {
                     await _launchAtStartup.enable();
                   } else {
                     await _launchAtStartup.disable();
                   }
                   if (mounted) {
                     setState(() {
                       _isLaunchAtStartupEnabled = value;
                     });
                     NotifyController().showNotify(NotifyData(
                       message: value ? '已启用开机自启' : '已禁用开机自启',
                       type: NotifyType.app,
                       time: DateTime.now(),
                     ));
                   }
                 },
               ),
                // Divider(color: colorScheme.outlineVariant), // Removed
                ListTile(
                  title: const Text('退出应用'),
                  leading: Icon(Icons.exit_to_app, color: colorScheme.error),
                  onTap: () async {
                    // 显示确认对话框
                    final shouldExit = await showDialog<bool>(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: const Text('确认退出'),
                            content: const Text('确定要退出应用吗？'),
                            actions: [
                              TextButton(
                                onPressed:
                                    () => Navigator.of(context).pop(false),
                                child: const Text('取消'),
                              ),
                              FilledButton(
                                onPressed:
                                    () => Navigator.of(context).pop(true),
                                child: Text(
                                  '退出',
                                  style: TextStyle(color: colorScheme.onError),
                                ),
                              ),
                            ],
                          ),
                    );

                    // 添加 mounted 检查
                    if (!mounted) return;
                    if (shouldExit == true) {
                      NotifyController().showNotify(NotifyData(
                        message: '正在退出应用程序...',
                        type: NotifyType.app,
                        time: DateTime.now(),
                      ));
                      // 延迟一小段时间后退出应用程序
                      Future.delayed(
                        const Duration(milliseconds: 500),
                        () async {
                          // 退出应用程序
                          await windowManager.destroy();
                        },
                      );
                    }
                  },
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 16.0), child: Divider()), // Added Divider with Padding
            const SizedBox(height: 16),
          ],
          _buildSection(
            title: '关于',
            icon: Icons.info_outline,
            children: [
              ListTile(
                title: const Text('版本'),
                subtitle: const Text(AppInfo.appVersion), // 显示应用版本号
                leading: Icon(
                  Icons.app_settings_alt,
                  color: colorScheme.primary,
                ),
              ),
              ListTile(
                title: const Text('链接'),
                leading: Icon(
                  Icons.link,
                  color: colorScheme.primary,
                ),
                onTap: () async {
                  final Uri url = Uri.parse(AppInfo.officialLink);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    // 处理无法打开链接的情况
                    NotifyController().showNotify(NotifyData(
                      message: '无法打开链接: ${AppInfo.officialLink}',
                      type: NotifyType.app,
                      time: DateTime.now(),
                    ));
                  }
                },
              ),
            ],
          ),
        ],
      ),
    ), // Closing parenthesis for ConstrainedBox
  ); // Closing parenthesis for SingleChildScrollView
}

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      color: Colors.transparent,
      shadowColor: colorScheme.shadow.withAlpha((255 * 0.2).round()), // 使用 withAlpha
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(42)),
      clipBehavior: Clip.antiAlias, // 添加此行以确保裁剪行为和阴影与圆角一致
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Theme(
          data: Theme.of(context).copyWith(
            listTileTheme: ListTileThemeData(
              shape: getAdaptiveStadiumBorder(), // 使用自适应半圆边框
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding( // 为标题行添加内边距
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Icon(icon, color: colorScheme.primary, size: 28),
                    const SizedBox(width: 16),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8.0), // 减小标题行与下方内容的间距
              ...children,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColorSelector(ThemeManager themeManager) {
    final colorScheme = Theme.of(context).colorScheme;

    // 查找当前选中颜色的名称
    String selectedColorName = '';
    if (themeManager.primaryColor.toARGB32() == Colors.blue.toARGB32()) {
      selectedColorName = '经典蓝';
    } else {
      for (var option in _colorOptions) {
        if (option.color.toARGB32() == themeManager.primaryColor.toARGB32()) {
          selectedColorName = option.name;
          break;
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          // contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0), // 移除自定义内边距以与其他选项对齐
          leading: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: themeManager.primaryColor,
              shape: BoxShape.circle,
              border: Border.all(color: colorScheme.outline, width: 1),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withAlpha((255 * 0.2).round()),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
          title: Text('主色调: $selectedColorName'),
          // subtitle: Text(
          //   selectedColorName,
          //   style: TextStyle(
          //     fontSize: 12, // 减小副标题字体大小
          //     color: colorScheme.onSurfaceVariant,
          //   ),
          // ),
          trailing: Icon(
            _isColorSectionExpanded ? Icons.expand_less : Icons.expand_more,
            color: colorScheme.primary,
          ),
          onTap: () {
            setState(() {
              _isColorSectionExpanded = !_isColorSectionExpanded;
            });
          },
        ),
        if (_isColorSectionExpanded) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '搜索颜色...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 250, // 设置固定高度以便在内容多时可以滚动
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _filteredColorOptions.length,
              itemBuilder: (context, index) {
                final colorOption = _filteredColorOptions[index];
                final isSelected =
                    themeManager.primaryColor.toARGB32() ==
                    colorOption.color.toARGB32();

                return InkWell(
                  onTap: () {
                    themeManager.setPrimaryColor(colorOption.color);
                    NotifyController().showNotify(NotifyData(
                      message: '主题颜色已更改为：${colorOption.name}',
                      type: NotifyType.app,
                      time: DateTime.now(),
                    ));
                    // setState(() {}); // ThemeManager should handle rebuild
                  },
                  customBorder: const CircleBorder(),
                  child: Tooltip(
                    message: colorOption.name,
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorOption.color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color:
                              isSelected
                                  ? colorScheme.onSurface
                                  : Colors.transparent,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.shadow.withAlpha((255 * 0.2).round()),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child:
                          isSelected
                              ? Center(
                                child: Icon(
                                  Icons.check,
                                  color:
                                      estimateBrightnessForColor(
                                                colorOption.color,
                                              ) ==
                                              Brightness.dark
                                          ? Colors.white
                                          : Colors.black,
                                ),
                              )
                              : null,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}

// 颜色选项类
class ColorOption {
  final Color color;
  final String name;
  final String pinyinName;

  ColorOption({
    required this.color,
    required this.name,
    required this.pinyinName,
  });
}

// 用于从十六进制字符串转换为Color的扩展
extension HexColor on Color {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) {
      // 直接使用颜色值，不添加额外的透明度
      buffer.write(hexString.replaceFirst('#', ''));
      // 确保颜色字符串格式为"RRGGBB"（不含透明度）
      if (buffer.length == 6) {
        // 添加完全不透明的透明度
        return Color(int.parse('ff$buffer', radix: 16));
      }
    } else {
      // 处理其他格式的十六进制颜色
      if (hexString.startsWith('#')) {
        buffer.write(hexString.substring(1));
      } else {
        buffer.write(hexString);
      }
    }
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
