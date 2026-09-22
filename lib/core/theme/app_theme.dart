/// Material 3 主题构建器与调色令牌
///
/// @author Ateng
/// @since 2026-09-22
library;

import 'package:flutter/material.dart';

/// 预置的 Material 3 种子强调色选项
class AppSeedColor {
  /// 显示名称
  final String label;

  /// 对应颜色
  final Color color;

  /// 构造函数
  const AppSeedColor({
    required this.label,
    required this.color,
  });
}

/// 全局主题构建工具类
class AppTheme {
  const AppTheme._();

  /// 预置的 4 款种子强调色
  static const List<AppSeedColor> seedColors = [
    AppSeedColor(label: '经典紫', color: Color(0xFF6750A4)),
    AppSeedColor(label: '科技蓝', color: Color(0xFF1976D2)),
    AppSeedColor(label: '自然绿', color: Color(0xFF2E7D32)),
    AppSeedColor(label: '活力橙', color: Color(0xFFE65100)),
  ];

  /// 构建明亮模式主题
  static ThemeData light(Color seedColor) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.light,
      ),
      fontFamilyFallback: const [
        'Noto Sans SC',
        'PingFang SC',
        'Microsoft YaHei',
        'sans-serif',
      ],
      cardTheme: const CardThemeData(
        elevation: 1,
        margin: EdgeInsets.zero,
      ),
    );
  }

  /// 构建暗黑模式主题
  static ThemeData dark(Color seedColor) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.dark,
      ),
      fontFamilyFallback: const [
        'Noto Sans SC',
        'PingFang SC',
        'Microsoft YaHei',
        'sans-serif',
      ],
      cardTheme: const CardThemeData(
        elevation: 1,
        margin: EdgeInsets.zero,
      ),
    );
  }
}
