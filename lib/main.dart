/// DevToolbox 开发者微工具箱应用入口，初始化全局 Provider 与响应式外壳
///
/// @author Ateng
/// @since 2026-09-22
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/widgets/app_scaffold.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: DevToolboxApp(),
    ),
  );
}

/// 开发者微工具箱根组件
class DevToolboxApp extends ConsumerWidget {
  /// 构造函数
  const DevToolboxApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final seedColor = themeState.currentSeedColor;

    return MaterialApp(
      title: AppConstants.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(seedColor),
      darkTheme: AppTheme.dark(seedColor),
      themeMode: themeState.mode,
      home: const AppScaffold(),
    );
  }
}
