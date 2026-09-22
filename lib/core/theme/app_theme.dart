/// Material 3 与 Raycast 极客风格主题构建器与调色令牌
///
/// @author Ateng
/// @since 2026-09-23
library;

import 'package:flutter/material.dart';

import 'app_colors.dart';

/// 预置的种子强调色选项
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

  /// 预置的高质感强调色
  static const List<AppSeedColor> seedColors = [
    AppSeedColor(label: '电光青', color: AppColors.darkAccentCyan),
    AppSeedColor(label: '极客蓝', color: AppColors.lightAccentPrimary),
    AppSeedColor(label: '赛博紫', color: AppColors.darkAccentIndigo),
    AppSeedColor(label: '琥珀金', color: AppColors.statusWarning),
  ];

  /// 中文字体与西文字体保底栈
  static const List<String> fontFallbacks = [
    'Inter',
    'Noto Sans SC',
    'PingFang SC',
    'Microsoft YaHei',
    'sans-serif',
  ];

  /// 构建明亮模式主题 (Light Studio)
  static ThemeData light(Color seedColor) {
    final baseScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
    );

    final colorScheme = baseScheme.copyWith(
      surface: AppColors.lightSurfaceBase,
      surfaceContainerLowest: AppColors.lightCanvas,
      surfaceContainerLow: AppColors.lightSurfaceCard,
      surfaceContainer: AppColors.lightSurfaceBase,
      surfaceContainerHigh: AppColors.lightSurfaceElevated,
      surfaceContainerHighest: AppColors.lightBorderHover,
      outline: AppColors.lightBorderHover,
      outlineVariant: AppColors.lightBorderHairline,
      primary: seedColor == AppColors.darkAccentCyan
          ? AppColors.lightAccentPrimary
          : seedColor,
      onSurface: AppColors.lightTextPrimary,
      onSurfaceVariant: AppColors.lightTextSecondary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.lightCanvas,
      fontFamilyFallback: fontFallbacks,
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: colorScheme.outlineVariant,
            width: 1,
          ),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
    );
  }

  /// 构建暗黑模式主题 (Dark Studio - Raycast 风格)
  static ThemeData dark(Color seedColor) {
    final baseScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
    );

    final colorScheme = baseScheme.copyWith(
      surface: AppColors.darkSurfaceCard,
      surfaceContainerLowest: AppColors.darkCanvas,
      surfaceContainerLow: AppColors.darkSurfaceBase,
      surfaceContainer: AppColors.darkSurfaceCard,
      surfaceContainerHigh: AppColors.darkSurfaceElevated,
      surfaceContainerHighest: AppColors.darkBorderHover,
      outline: AppColors.darkBorderHover,
      outlineVariant: AppColors.darkBorderHairline,
      primary: seedColor,
      onSurface: AppColors.darkTextPrimary,
      onSurfaceVariant: AppColors.darkTextSecondary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.darkCanvas,
      fontFamilyFallback: fontFallbacks,
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: colorScheme.outlineVariant,
            width: 1,
          ),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
