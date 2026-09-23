/// Raycast 与 Linear 极客风格调色体系与色彩阶梯令牌
///
/// @author Ateng
/// @since 2026-09-23
library;

import 'package:flutter/material.dart';

/// 极客工作台全套色彩令牌
abstract final class AppColors {
  // =================== 润白高对比明亮体系 (Light Studio - 默认核心) ===================

  /// 明亮底层全景画布底色 (纯净冷白，温和不刺眼)
  static const Color lightCanvas = Color(0xFFF8FAFC);

  /// 明亮一级基础卡片与白底窗体表面
  static const Color lightSurfaceBase = Color(0xFFFFFFFF);

  /// 明亮次级侧栏与输入区域底色
  static const Color lightSurfaceCard = Color(0xFFF1F5F9);

  /// 明亮交互悬停与高亮卡片
  static const Color lightSurfaceElevated = Color(0xFFFFFFFF);

  /// 明亮 1px 极细发光微边框
  static const Color lightBorderHairline = Color(0xFFE2E8F0);

  /// 明亮悬停强化边框
  static const Color lightBorderHover = Color(0xFFCBD5E1);

  /// 明亮深邃科技青蓝 (主交互强调色)
  static const Color lightAccentPrimary = Color(0xFF0284C7);

  /// 电光青蓝主品牌强调色 (Electric Azure #0284C7)
  static const Color electricAzure = Color(0xFF0284C7);

  /// 明亮极客靛蓝 (辅助交互)
  static const Color lightAccentIndigo = Color(0xFF6366F1);

  /// 明亮深石墨正文字色 (高对比度，沉稳不死板)
  static const Color lightTextPrimary = Color(0xFF0F172A);

  /// 明亮次级文字颜色 (副标题与字段标签)
  static const Color lightTextSecondary = Color(0xFF475569);

  /// 明亮占位说明文字与空态图标
  static const Color lightTextMuted = Color(0xFF94A3B8);

  /// 明亮微阴影颜色 (0 1px 2px rgba(15,23,42,0.05))
  static const Color lightShadow = Color(0x0D0F172A);

  // =================== 现代深度石墨暗黑体系 (Modern Dark - 次级模式) ===================

  /// 暗黑深空石墨蓝黑底色 (告别死黑，富有纵深感)
  static const Color darkCanvas = Color(0xFF0B0F17);

  /// 暗黑一体化侧栏与一级主容器表面
  static const Color darkSurfaceBase = Color(0xFF111827);

  /// 暗黑卡片与代码窗格表面
  static const Color darkSurfaceCard = Color(0xFF1E293B);

  /// 暗黑高亮卡片与激活态表面
  static const Color darkSurfaceElevated = Color(0xFF334155);

  /// 暗黑 1px 极细发光微边框
  static const Color darkBorderHairline = Color(0xFF1F2937);

  /// 暗黑悬停态微边框
  static const Color darkBorderHover = Color(0xFF374151);

  /// 电光青强调色 (暗黑模式核心醒目色)
  static const Color darkAccentCyan = Color(0xFF00D2B4);

  /// 极客柔和靛紫 (暗黑辅助交互)
  static const Color darkAccentIndigo = Color(0xFF818CF8);

  /// 暗黑高可读正文字体颜色
  static const Color darkTextPrimary = Color(0xFFF8FAFC);

  /// 暗黑副标题与弱化说明文本
  static const Color darkTextSecondary = Color(0xFF94A3B8);

  /// 暗黑极淡占位与空态图标颜色
  static const Color darkTextMuted = Color(0xFF64748B);

  /// 暗黑微阴影颜色
  static const Color darkShadow = Color(0x33000000);

  // =================== 语义化状态色彩 (Status Colors) ===================

  /// 语法校验成功 / 操作有效翡翠绿
  static const Color statusSuccess = Color(0xFF10B981);

  /// 语法解析失败 / 异常警示红
  static const Color statusError = Color(0xFFEF4444);

  /// 警告与时间戳提示琥珀黄
  static const Color statusWarning = Color(0xFFF59E0B);
}
