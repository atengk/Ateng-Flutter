/// 工具工坊主屏幕，采用两头对齐的先锋工作台 Header 架构
///
/// @author Ateng
/// @since 2026-09-23
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/fluid_segmented_control.dart';
import '../../domain/models/tool_type.dart';
import '../providers/toolbox_provider.dart';
import '../widgets/hash_tool_view.dart';
import '../widgets/json_tool_view.dart';
import '../widgets/timestamp_tool_view.dart';

/// 工具工坊屏幕组件
class ToolboxScreen extends ConsumerWidget {
  /// 构造函数
  const ToolboxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(toolboxProvider);
    final currentTool = state.currentTool;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 720;

              final titleBlock = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '微工具工坊',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withAlpha(20),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'TOOLBOX STUDIO',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '免网络依赖的高频开发者轻量化代码处理中心',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.outline,
                      fontSize: 13,
                    ),
                  ),
                ],
              );

              final tabs = FluidSegmentedControl<ToolType>(
                segments: ToolType.values
                    .map(
                      (t) => FluidSegment<ToolType>(
                        value: t,
                        label: t.label,
                        icon: t.icon,
                      ),
                    )
                    .toList(),
                selectedValue: currentTool,
                onSelectionChanged: (tool) {
                  ref.read(toolboxProvider.notifier).setTool(tool);
                },
              );

              if (isWide) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    titleBlock,
                    tabs,
                  ],
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  titleBlock,
                  const SizedBox(height: 12),
                  tabs,
                ],
              );
            },
          ),
          const SizedBox(height: 14),
          Expanded(
            child: switch (currentTool) {
              ToolType.json => const JsonToolView(),
              ToolType.timestamp => const TimestampToolView(),
              ToolType.hash => const HashToolView(),
            },
          ),
        ],
      ),
    );
  }
}
