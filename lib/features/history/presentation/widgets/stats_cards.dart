/// 操作历史统计指标卡片组，采用极客工作室高奢陶瓷指标卡设计
///
/// @author Ateng
/// @since 2026-09-23
library;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/studio_card.dart';
import '../../../toolbox/domain/models/tool_type.dart';

/// 统计指标单卡片
class StatTile extends StatelessWidget {
  /// 标签
  final String label;

  /// 数值
  final int count;

  /// 辅助描述
  final String description;

  /// 图标
  final IconData icon;

  /// 主题色
  final Color color;

  /// 图标柔和浅底色
  final Color bgTint;

  /// 构造函数
  const StatTile({
    super.key,
    required this.label,
    required this.count,
    required this.description,
    required this.icon,
    required this.color,
    required this.bgTint,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return StudioCard(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(7.0),
                decoration: BoxDecoration(
                  color: isDark ? color.withAlpha(30) : bgTint,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: color.withAlpha(50),
                    width: 0.8,
                  ),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withAlpha(120),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text(
                  description,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.outline,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$count',
                style: const TextStyle(
                  fontFamily: 'JetBrains Mono',
                  fontFamilyFallback: ['Consolas', 'Menlo', 'monospace'],
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '次',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.outline,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
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
    final jsonCount = stats[ToolType.json] ?? 0;
    final timestampCount = stats[ToolType.timestamp] ?? 0;
    final hashCount = stats[ToolType.hash] ?? 0;
    final timeCryptoCount = timestampCount + hashCount;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 640;
        final tiles = [
          StatTile(
            label: '累计操作调用',
            count: totalCount,
            description: '全量不可变留痕',
            icon: Icons.analytics_outlined,
            color: AppColors.electricAzure,
            bgTint: const Color(0xFFE0F2FE),
          ),
          const StatTile(
            label: 'JSON 格式化',
            count: 0,
            description: '高频校验美化',
            icon: Icons.code,
            color: Color(0xFF16A34A),
            bgTint: Color(0xFFDCFCE7),
          ),
          const StatTile(
            label: '时间戳与编解码',
            count: 0,
            description: '开发者日常转化',
            icon: Icons.vpn_key_outlined,
            color: Color(0xFFD97706),
            bgTint: Color(0xFFFEF3C7),
          ),
        ];

        // 动态注入真实数据
        final activeTiles = [
          tiles[0],
          StatTile(
            label: 'JSON 格式化',
            count: jsonCount,
            description: '高频校验美化',
            icon: Icons.code,
            color: const Color(0xFF16A34A),
            bgTint: const Color(0xFFDCFCE7),
          ),
          StatTile(
            label: '时间戳与编解码',
            count: timeCryptoCount,
            description: '开发者日常转化',
            icon: Icons.vpn_key_outlined,
            color: const Color(0xFFD97706),
            bgTint: const Color(0xFFFEF3C7),
          ),
        ];

        if (isWide) {
          return Row(
            children: activeTiles
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
        return Column(
          children: activeTiles
              .map(
                (t) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: t,
                ),
              )
              .toList(),
        );
      },
    );
  }
}
