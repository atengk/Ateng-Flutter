/// 现代线性弹性自适应分段导航控制器 (具备 macOS / Linear 物理平滑滑块与触觉动效)
///
/// @author Ateng
/// @since 2026-09-23
library;

import 'package:flutter/material.dart';

/// 分段项数据契约
class FluidSegment<T> {
  /// 对应枚举或状态值
  final T value;

  /// 显示文案
  final String label;

  /// 前缀图标 (可选)
  final IconData? icon;

  /// 构造函数
  const FluidSegment({
    required this.value,
    required this.label,
    this.icon,
  });
}

/// 弹性自适应分段控制器组件，采用物理平滑滑块（Sliding Pill Indicator）架构
class FluidSegmentedControl<T> extends StatefulWidget {
  /// 分段数据列表
  final List<FluidSegment<T>> segments;

  /// 当前选中的值
  final T selectedValue;

  /// 选中变更回调
  final ValueChanged<T> onSelectionChanged;

  /// 构造函数
  const FluidSegmentedControl({
    super.key,
    required this.segments,
    required this.selectedValue,
    required this.onSelectionChanged,
  });

  @override
  State<FluidSegmentedControl<T>> createState() =>
      _FluidSegmentedControlState<T>();
}

class _FluidSegmentedControlState<T> extends State<FluidSegmentedControl<T>> {
  final GlobalKey _containerKey = GlobalKey();
  late List<GlobalKey> _itemKeys;
  Rect? _pillRect;

  @override
  void initState() {
    super.initState();
    _initKeys();
    _schedulePillUpdate();
  }

  @override
  void didUpdateWidget(covariant FluidSegmentedControl<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.segments.length != oldWidget.segments.length) {
      _initKeys();
    }
    if (widget.selectedValue != oldWidget.selectedValue ||
        widget.segments.length != oldWidget.segments.length) {
      _schedulePillUpdate();
    }
  }

  void _initKeys() {
    _itemKeys = List.generate(widget.segments.length, (_) => GlobalKey());
  }

  void _schedulePillUpdate() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final selectedIndex = widget.segments.indexWhere(
        (s) => s.value == widget.selectedValue,
      );
      if (selectedIndex < 0 || selectedIndex >= _itemKeys.length) return;

      final containerBox =
          _containerKey.currentContext?.findRenderObject() as RenderBox?;
      final selectedBox = _itemKeys[selectedIndex]
          .currentContext
          ?.findRenderObject() as RenderBox?;

      if (containerBox != null && selectedBox != null && selectedBox.hasSize) {
        final offset =
            selectedBox.localToGlobal(Offset.zero, ancestor: containerBox);
        final newRect = Rect.fromLTWH(
          offset.dx,
          offset.dy,
          selectedBox.size.width,
          selectedBox.size.height,
        );
        if (_pillRect != newRect) {
          setState(() {
            _pillRect = newRect;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final disableAnimations = MediaQuery.disableAnimationsOf(context);

    final containerBg =
        isDark ? const Color(0xFF161B26) : colorScheme.surfaceContainerLow;
    final borderSide = BorderSide(
      color: colorScheme.outlineVariant,
      width: 1,
    );

    final duration =
        disableAnimations ? Duration.zero : const Duration(milliseconds: 200);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Container(
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          color: containerBg,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.fromBorderSide(borderSide),
        ),
        child: Stack(
          key: _containerKey,
          children: [
            // 1. 底层平滑滑动实体胶囊
            if (_pillRect != null)
              AnimatedPositioned(
                duration: duration,
                curve: Curves.easeOutCubic,
                left: _pillRect!.left,
                top: _pillRect!.top,
                width: _pillRect!.width,
                height: _pillRect!.height,
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        isDark ? const Color(0xFF1E293B) : colorScheme.surface,
                    borderRadius: BorderRadius.circular(6.0),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF334155)
                          : colorScheme.outlineVariant.withAlpha(120),
                      width: 0.8,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? const Color(0x33000000)
                            : const Color(0x0D0F172A),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),

            // 2. 顶层标签交互项 Row
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < widget.segments.length; i++)
                  _FluidSegmentTab<T>(
                    key: _itemKeys[i],
                    segment: widget.segments[i],
                    isSelected:
                        widget.segments[i].value == widget.selectedValue,
                    duration: duration,
                    onTap: () =>
                        widget.onSelectionChanged(widget.segments[i].value),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FluidSegmentTab<T> extends StatefulWidget {
  final FluidSegment<T> segment;
  final bool isSelected;
  final Duration duration;
  final VoidCallback onTap;

  const _FluidSegmentTab({
    super.key,
    required this.segment,
    required this.isSelected,
    required this.duration,
    required this.onTap,
  });

  @override
  State<_FluidSegmentTab<T>> createState() => _FluidSegmentTabState<T>();
}

class _FluidSegmentTabState<T> extends State<_FluidSegmentTab<T>> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final targetTextColor = widget.isSelected
        ? colorScheme.primary
        : (_isHovered ? colorScheme.onSurface : colorScheme.onSurfaceVariant);

    final targetIconColor = widget.isSelected
        ? colorScheme.primary
        : (_isHovered ? colorScheme.onSurface : colorScheme.onSurfaceVariant);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 7.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            color: (!widget.isSelected && _isHovered)
                ? colorScheme.surfaceContainerHighest.withAlpha(80)
                : Colors.transparent,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.segment.icon != null) ...[
                TweenAnimationBuilder<Color?>(
                  duration: widget.duration,
                  curve: Curves.easeOutCubic,
                  tween: ColorTween(end: targetIconColor),
                  builder: (context, color, _) {
                    return Icon(
                      widget.segment.icon,
                      size: 14.5,
                      color: color,
                    );
                  },
                ),
                const SizedBox(width: 6),
              ],
              AnimatedDefaultTextStyle(
                duration: widget.duration,
                curve: Curves.easeOutCubic,
                style:
                    (theme.textTheme.labelMedium ?? const TextStyle()).copyWith(
                  fontWeight:
                      widget.isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 13.0,
                  color: targetTextColor,
                  letterSpacing: 0,
                ),
                child: Text(
                  widget.segment.label,
                  strutStyle: const StrutStyle(
                    forceStrutHeight: true,
                    height: 1.3,
                    leading: 0.1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
