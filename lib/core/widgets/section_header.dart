/// 全局通用分栏与模块卡片标题组件
///
/// @author Ateng
/// @since 2026-09-22
library;

import 'package:flutter/material.dart';

/// 统一模块卡片标题
class SectionHeader extends StatelessWidget {
  /// 标题文字
  final String title;

  /// 副标题说明（可选）
  final String? subtitle;

  /// 对应前缀图标
  final IconData icon;

  /// 右侧附加操作部件（可选）
  final Widget? trailing;

  /// 构造函数
  const SectionHeader({
    super.key,
    required this.title,
    required this.icon,
    this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Icon(
              icon,
              size: 20,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.outline,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
