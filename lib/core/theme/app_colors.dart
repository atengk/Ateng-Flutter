/// Raycast 与 Linear 极客风格调色体系与色彩阶梯令牌
///
/// @author Ateng
/// @since 2026-09-23
library;

import 'package:flutter/material.dart';

/// 极客工作台全套色彩令牌
abstract final class AppColors {
  // =================== 深空石墨暗黑体系 (Dark Studio) ===================

  /// 暗黑底层全景画布底色
  static const Color darkCanvas = Color(0xFF07080A);

  /// 暗黑一体化侧栏与次级容器表面
  static const Color darkSurfaceBase = Color(0xFF0D0E11);

  /// 暗黑卡片与代码窗格表面
  static const Color darkSurfaceCard = Color(0xFF121316);

  /// 暗黑高亮卡片与激活态表面
  static const Color darkSurfaceElevated = Color(0xFF181A1F);

  /// 暗黑 1px 极细发光微边框
  static const Color darkBorderHairline = Color(0xFF24272E);

  /// 暗黑悬停态微边框
  static const Color darkBorderHover = Color(0xFF383D48);

  /// 电光青强调色（主交互）
  static const Color darkAccentCyan = Color(0xFF00D2B4);

  /// 极客靛蓝（辅助交互）
  static const Color darkAccentIndigo = Color(0xFF6366F1);

  /// 极高对比正文字体颜色
  static const Color darkTextPrimary = Color(0xFFF1F5F9);

  /// 暗黑副标题与弱化文本颜色
  static const Color darkTextSecondary = Color(0xFF94A3B8);

  /// 暗黑极淡占位与空态图标颜色
  static const Color darkTextMuted = Color(0xFF64748B);

  // =================== 润白高对比明亮体系 (Light Studio) ===================

  /// 明亮极净冷灰白画布底色
  static const Color lightCanvas = Color(0xFFF8FAFC);

  /// 明亮基础卡片与白底窗体
  static const Color lightSurfaceBase = Color(0xFFFFFFFF);

  /// 明亮侧栏与输入区域底色
  static const Color lightSurfaceCard = Color(0xFFF1F5F9);

  /// 明亮交互悬停与高亮卡片
  static const Color lightSurfaceElevated = Color(0xFFE2E8F0);

  /// 明亮 1px 浅灰冷色发光微边框
  static const Color lightBorderHairline = Color(0xFFE2E8F0);

  /// 明亮悬停强化边框
  static const Color lightBorderHover = Color(0xFFCBD5E1);

  /// 明亮深邃科技青蓝
  static const Color lightAccentPrimary = Color(0xFF0284C7);

  /// 明亮深石墨正文字色
  static const Color lightTextPrimary = Color(0xFF0F172A);

  /// 明亮次级文字颜色
  static const Color lightTextSecondary = Color(0xFF475569);

  /// 明亮占位说明文字
  static const Color lightTextMuted = Color(0xFF94A3B8);

  // =================== 语义化状态色彩 (Status Colors) ===================

  /// 语法校验成功 / 操作有效翡翠绿
  static const Color statusSuccess = Color(0xFF10B981);

  /// 语法解析失败 / 异常警示红
  static const Color statusError = Color(0xFFEF4444);

  /// 警告与时间戳提示琥珀黄
  static const Color statusWarning = Color(0xFFF59E0B);
}
