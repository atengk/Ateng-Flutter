/// Raycast 极客风格 1px 微发光边框卡片组件
///
/// @author Ateng
/// @since 2026-09-23
library;

import 'package:flutter/material.dart';

/// 极客工作台统一卡片组件
class StudioCard extends StatefulWidget {
  /// 子组件
  final Widget child;

  /// 内边距（可选）
  final EdgeInsetsGeometry padding;

  /// 自定义背景色（可选）
  final Color? backgroundColor;

  /// 自定义圆角大小（默认 12.0）
  final double borderRadius;

  /// 点击回调（可选）
  final VoidCallback? onTap;

  /// 构造函数
  const StudioCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.backgroundColor,
    this.borderRadius = 12.0,
    this.onTap,
  });

  @override
  State<StudioCard> createState() => _StudioCardState();
}

class _StudioCardState extends State<StudioCard> {
  bool _isHovered = false;

  void _onHover(bool hovering) {
    if (_isHovered != hovering) {
      setState(() {
        _isHovered = hovering;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final border = Border.all(
      color: _isHovered ? colorScheme.outline : colorScheme.outlineVariant,
      width: 1.0,
    );

    final bg = widget.backgroundColor ?? colorScheme.surface;

    final container = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      padding: widget.padding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: border,
      ),
      child: widget.child,
    );

    if (widget.onTap != null) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => _onHover(true),
        onExit: (_) => _onHover(false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: container,
        ),
      );
    }

    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: container,
    );
  }
}
