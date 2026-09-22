/// Raycast 极客风格专业代码与文本工作台窗体组件
///
/// @author Ateng
/// @since 2026-09-23
library;

import 'package:flutter/material.dart';

/// 代码窗格顶部状态徽章数据模型
class WorkbenchBadge {
  /// 显示文本
  final String label;

  /// 自定义颜色
  final Color? color;

  /// 前缀图标
  final IconData? icon;

  /// 构造函数
  const WorkbenchBadge({
    required this.label,
    this.color,
    this.icon,
  });
}

/// 拟 macOS 窗体装饰三色点组件
class WindowControlsDots extends StatelessWidget {
  /// 构造函数
  const WindowControlsDots({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _WindowDot(color: Color(0xFFFF5F56)),
        SizedBox(width: 5),
        _WindowDot(color: Color(0xFFFFBD2E)),
        SizedBox(width: 5),
        _WindowDot(color: Color(0xFF27C93F)),
      ],
    );
  }
}

class _WindowDot extends StatelessWidget {
  final Color color;

  const _WindowDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 9,
      height: 9,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

/// 专业代码工作台窗格
class CodeWorkbench extends StatelessWidget {
  /// 窗格标题
  final String title;

  /// 状态徽章（如行数、字符数、校验结果）
  final List<WorkbenchBadge> badges;

  /// 右上角动作按钮
  final List<Widget> actions;

  /// 窗格核心内容区
  final Widget child;

  /// 构造函数
  const CodeWorkbench({
    super.key,
    required this.title,
    required this.child,
    this.badges = const [],
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // 代码编辑器专用内层底色
    final editorBg = isDark ? const Color(0xFF090A0E) : const Color(0xFFF8FAFC);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: 1.0,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 6.0,
            ),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF0D0F14)
                  : colorScheme.surfaceContainerLow,
              border: Border(
                bottom: BorderSide(
                  color: colorScheme.outlineVariant,
                  width: 1.0,
                ),
              ),
            ),
            child: Row(
              children: [
                const WindowControlsDots(),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (final badge in badges) ...[
                          _BadgeChip(badge: badge),
                          const SizedBox(width: 4),
                        ],
                      ],
                    ),
                  ),
                ),
                for (final action in actions) action,
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: editorBg,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeChip extends StatelessWidget {
  final WorkbenchBadge badge;

  const _BadgeChip({required this.badge});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final badgeColor = badge.color ?? colorScheme.outline;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
      decoration: BoxDecoration(
        color: badgeColor.withAlpha(25),
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(
          color: badgeColor.withAlpha(80),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (badge.icon != null) ...[
            Icon(badge.icon, size: 10, color: badgeColor),
            const SizedBox(width: 2),
          ],
          Text(
            badge.label,
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: 9.5,
              color: badgeColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
