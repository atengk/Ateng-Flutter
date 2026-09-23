/// Material 3 与 Linear / Stripe 现代极客风格主题构建器与调色令牌
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
    AppSeedColor(label: '赛博紫', color: AppColors.lightAccentIndigo),
    AppSeedColor(label: '琥珀金', color: AppColors.statusWarning),
  ];

  /// 中文字体与西文字体保底栈 (优先命中本地系统高清抗锯齿中文字体)
  static const List<String> fontFallbacks = [
    'Microsoft YaHei',
    'PingFang SC',
    'Hiragino Sans GB',
    'Noto Sans SC',
    'Inter',
    'Segoe UI',
    'sans-serif',
  ];

  /// 等宽字体序列
  static const List<String> monoFontFallbacks = [
    'JetBrains Mono',
    'Menlo',
    'Consolas',
    'monospace',
  ];

  /// 构建统一排版样式 (遵从 DESIGN.md 中文排版四大红线)
  static TextTheme _buildTextTheme(
    Brightness brightness,
    Color primaryTextColor,
    Color secondaryTextColor,
  ) {
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: 0.2,
        color: primaryTextColor,
        leadingDistribution: TextLeadingDistribution.even,
      ),
      headlineMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: 0,
        color: primaryTextColor,
        leadingDistribution: TextLeadingDistribution.even,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.4,
        letterSpacing: 0,
        color: primaryTextColor,
        leadingDistribution: TextLeadingDistribution.even,
      ),
      bodyMedium: TextStyle(
        fontSize: 14.5,
        fontWeight: FontWeight.w400,
        height: 1.55,
        letterSpacing: 0,
        color: primaryTextColor,
        leadingDistribution: TextLeadingDistribution.even,
      ),
      bodySmall: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.5,
        letterSpacing: 0,
        color: secondaryTextColor,
        leadingDistribution: TextLeadingDistribution.even,
      ),
      labelMedium: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        height: 1.3,
        letterSpacing: 0,
        color: secondaryTextColor,
        leadingDistribution: TextLeadingDistribution.even,
      ),
      labelSmall: TextStyle(
        fontSize: 11.5,
        fontWeight: FontWeight.w500,
        height: 1.3,
        letterSpacing: 0,
        color: secondaryTextColor,
        leadingDistribution: TextLeadingDistribution.even,
      ),
    );
  }

  /// 构建明亮模式主题 (Light Studio - 默认核心)
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
      primary: seedColor,
      onSurface: AppColors.lightTextPrimary,
      onSurfaceVariant: AppColors.lightTextSecondary,
      error: AppColors.statusError,
    );

    final textTheme = _buildTextTheme(
      Brightness.light,
      AppColors.lightTextPrimary,
      AppColors.lightTextSecondary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.lightCanvas,
      textTheme: textTheme,
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
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightCanvas,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
      ),
    );
  }

  /// 构建暗黑模式主题 (Modern Dark - 次级模式)
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
      error: AppColors.statusError,
    );

    final textTheme = _buildTextTheme(
      Brightness.dark,
      AppColors.darkTextPrimary,
      AppColors.darkTextSecondary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.darkCanvas,
      textTheme: textTheme,
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
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurfaceBase,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
      ),
    );
  }
}
