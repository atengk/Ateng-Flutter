/// 操作历史统计指标卡片组，采用 StudioCard 极客微边框设计
///
/// @author Ateng
/// @since 2026-09-23
library;

import 'package:flutter/material.dart';

import '../../../../core/widgets/studio_card.dart';
import '../../../toolbox/domain/models/tool_type.dart';

/// 统计指标单卡片
class StatTile extends StatelessWidget {
  /// 标签
  final String label;

  /// 数值
  final int count;

  /// 图标
  final IconData icon;

  /// 主题色
  final Color color;

  /// 构造函数
  const StatTile({
    super.key,
    required this.label,
    required this.count,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StudioCard(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: color.withAlpha(25),
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: color.withAlpha(70),
                width: 0.8,
              ),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$count 次',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 统计概览容器组件
class StatsCards extends StatelessWidget {
  /// 总次数
  final int totalCount;

  /// 细分统计
  final Map<ToolType, int> stats;

  /// 构造函数
  const StatsCards({
    super.key,
    required this.totalCount,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 720;
        final tiles = [
          StatTile(
            label: '累计调用',
            count: totalCount,
            icon: Icons.analytics_outlined,
            color: colorScheme.primary,
          ),
          StatTile(
            label: 'JSON 格式化',
            count: stats[ToolType.json] ?? 0,
            icon: ToolType.json.icon,
            color: Colors.teal,
          ),
          StatTile(
            label: '时间戳处理',
            count: stats[ToolType.timestamp] ?? 0,
            icon: ToolType.timestamp.icon,
            color: Colors.amber.shade800,
          ),
          StatTile(
            label: '哈希/编解码',
            count: stats[ToolType.hash] ?? 0,
            icon: ToolType.hash.icon,
            color: Colors.deepPurple,
          ),
        ];

        if (isWide) {
          return Row(
            children: tiles
                .map(
                  (t) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: t,
                    ),
                  ),
                )
                .toList(),
          );
        }
        return GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 2.3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          children: tiles,
        );
      },
    );
  }
}
