/// Flutter 跨平台演示应用入口，提供平台检测、Material 3 视觉与多端状态交互。
///
/// @author Ateng
/// @since 2026-09-22
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MultiPlatformApp());
}

/// 跨平台演示应用根组件
///
/// @author Ateng
/// @since 2026-09-22
class MultiPlatformApp extends StatelessWidget {
  /// 构造函数
  const MultiPlatformApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Multiplatform Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Noto Sans SC',
      ),
      home: const HomePage(title: 'Flutter 跨平台打包与发布演示'),
    );
  }
}

/// 应用主页面组件
///
/// @author Ateng
/// @since 2026-09-22
class HomePage extends StatefulWidget {
  /// 页面标题
  final String title;

  /// 构造函数
  const HomePage({super.key, required this.title});

  @override
  State<HomePage> createState() => _HomePageState();
}

/// 主页面状态管理类
class _HomePageState extends State<HomePage> {
  int _counter = 0;

  /// 增加计数器
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  /// 获取当前运行平台名称
  String _getPlatformName() {
    if (kIsWeb) {
      return 'Web (浏览器环境)';
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'Android';
      case TargetPlatform.iOS:
        return 'iOS';
      case TargetPlatform.windows:
        return 'Windows 桌面';
      case TargetPlatform.linux:
        return 'Linux 桌面';
      case TargetPlatform.macOS:
        return 'macOS 桌面';
      case TargetPlatform.fuchsia:
        return 'Fuchsia';
    }
  }

  /// 获取平台对应图标
  IconData _getPlatformIcon() {
    if (kIsWeb) {
      return Icons.language;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return Icons.android;
      case TargetPlatform.iOS:
        return Icons.phone_iphone;
      case TargetPlatform.windows:
        return Icons.desktop_windows;
      case TargetPlatform.linux:
        return Icons.computer;
      case TargetPlatform.macOS:
        return Icons.laptop_mac;
      default:
        return Icons.device_unknown;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final platformName = _getPlatformName();
    final platformIcon = _getPlatformIcon();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32.0,
                    vertical: 24.0,
                  ),
                  child: Column(
                    children: [
                      Icon(
                        platformIcon,
                        size: 64,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '当前运行环境',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        platformName,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'GitHub Actions CI/CD 多平台自动化构建演示',
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                '按钮点击次数统计：',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                '$_counter',
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _incrementCounter,
        tooltip: '点击增加计数',
        icon: const Icon(Icons.add),
        label: const Text('递增'),
      ),
    );
  }
}
