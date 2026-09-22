/// 工具工坊主屏幕
///
/// @author Ateng
/// @since 2026-09-22
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/section_header.dart';
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

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionHeader(
            title: '微工具工坊 (Toolbox Studio)',
            subtitle: '纯原生算法与免网络依赖的高频开发者轻量工具',
            icon: Icons.construction,
            trailing: SegmentedButton<ToolType>(
              segments: ToolType.values
                  .map(
                    (t) => ButtonSegment<ToolType>(
                      value: t,
                      label: Text(t.label),
                      icon: Icon(t.icon, size: 16),
                    ),
                  )
                  .toList(),
              selected: {currentTool},
              onSelectionChanged: (set) {
                if (set.isNotEmpty) {
                  ref.read(toolboxProvider.notifier).setTool(set.first);
                }
              },
            ),
          ),
          const SizedBox(height: 8),
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
