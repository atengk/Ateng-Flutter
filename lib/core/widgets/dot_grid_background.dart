/// 现代极客工作室点阵微网格 (Dot Grid) 画布背景组件
///
/// @author Ateng
/// @since 2026-09-23
library;

import 'package:flutter/material.dart';

/// 带有 24px 点阵微纹理的画布背景包装器
class DotGridBackground extends StatelessWidget {
  /// 子组件
  final Widget child;

  /// 点阵网格步长（默认 24px）
  final double gridSpacing;

  /// 点的半径（默认 0.8px）
  final double dotRadius;

  /// 构造函数
  const DotGridBackground({
    super.key,
    required this.child,
    this.gridSpacing = 24.0,
    this.dotRadius = 0.8,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // 明亮模式下采用淡冷灰点，暗黑模式下采用深石墨点
    final dotColor = isDark
        ? const Color(0xFF1E293B)
        : const Color(0xFFCBD5E1).withAlpha(160);

    return CustomPaint(
      painter: _DotGridPainter(
        gridSpacing: gridSpacing,
        dotRadius: dotRadius,
        dotColor: dotColor,
      ),
      child: child,
    );
  }
}

class _DotGridPainter extends CustomPainter {
  final double gridSpacing;
  final double dotRadius;
  final Color dotColor;

  _DotGridPainter({
    required this.gridSpacing,
    required this.dotRadius,
    required this.dotColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = dotColor
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;

    for (double x = 0; x < size.width; x += gridSpacing) {
      for (double y = 0; y < size.height; y += gridSpacing) {
        canvas.drawCircle(Offset(x, y), dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DotGridPainter oldDelegate) {
    return oldDelegate.gridSpacing != gridSpacing ||
        oldDelegate.dotRadius != dotRadius ||
        oldDelegate.dotColor != dotColor;
  }
}
