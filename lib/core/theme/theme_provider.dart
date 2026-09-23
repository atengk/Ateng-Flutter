/// 全局主题模式与强调色状态管理，默认开启现代极客明亮模式
///
/// @author Ateng
/// @since 2026-09-23
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';
import 'app_theme.dart';

/// 主题状态模型
class ThemeState {
  /// 主题明暗模式
  final ThemeMode mode;

  /// 当前选中的种子色索引
  final int seedColorIndex;

  /// 构造函数
  const ThemeState({
    required this.mode,
    required this.seedColorIndex,
  });

  /// 获取当前种子色
  Color get currentSeedColor {
    if (seedColorIndex >= 0 && seedColorIndex < AppTheme.seedColors.length) {
      return AppTheme.seedColors[seedColorIndex].color;
    }
    return AppTheme.seedColors.first.color;
  }

  /// 复制并更新属性
  ThemeState copyWith({
    ThemeMode? mode,
    int? seedColorIndex,
  }) {
    return ThemeState(
      mode: mode ?? this.mode,
      seedColorIndex: seedColorIndex ?? this.seedColorIndex,
    );
  }
}

/// 主题状态控制器
class ThemeNotifier extends StateNotifier<ThemeState> {
  /// 构造函数并初始化加载配置（默认优先开启现代极客明亮模式）
  ThemeNotifier()
      : super(
          const ThemeState(
            mode: ThemeMode.light,
            seedColorIndex: 1, // 默认采用极客蓝
          ),
        ) {
    _loadFromPrefs();
  }

  /// 从持久化缓存加载主题偏好
  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final modeName = prefs.getString(AppConstants.prefsThemeModeKey);
    final colorIndex = prefs.getInt(AppConstants.prefsSeedColorKey) ?? 1;

    // 默认采用明亮优先策略 (Light-first by default)
    ThemeMode loadedMode = ThemeMode.light;
    if (modeName == 'dark') {
      loadedMode = ThemeMode.dark;
    } else if (modeName == 'system') {
      loadedMode = ThemeMode.system;
    } else if (modeName == 'light') {
      loadedMode = ThemeMode.light;
    }

    state = state.copyWith(
      mode: loadedMode,
      seedColorIndex: colorIndex,
    );
  }

  /// 切换明暗模式
  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(mode: mode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.prefsThemeModeKey, mode.name);
  }

  /// 切换种子强调色
  Future<void> setSeedColorIndex(int index) async {
    if (index < 0 || index >= AppTheme.seedColors.length) return;
    state = state.copyWith(seedColorIndex: index);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConstants.prefsSeedColorKey, index);
  }
}

/// 全局主题提供者
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>(
  (ref) => ThemeNotifier(),
);
