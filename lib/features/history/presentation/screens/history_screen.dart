/// 操作历史与数据统计看板主屏幕
///
/// @author Ateng
/// @since 2026-09-22
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/studio_card.dart';
import '../../../toolbox/presentation/providers/toolbox_provider.dart';
import '../providers/history_provider.dart';
import '../widgets/history_list_item.dart';
import '../widgets/stats_cards.dart';

/// 历史看板主屏幕
class HistoryScreen extends ConsumerWidget {
  /// 切换至工具 Tab 的回调函数
  final VoidCallback onNavigateToToolbox;

  /// 构造函数
  const HistoryScreen({
    super.key,
    required this.onNavigateToToolbox,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyState = ref.watch(historyProvider);
    final items = historyState.items;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionHeader(
            title: '操作历史与统计 (Activity & History)',
            subtitle: '全量不可变记录、实时使用频次统计与一键工具回填',
            icon: Icons.history,
            trailing: items.isNotEmpty
                ? OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      foregroundColor: colorScheme.error,
                      side: BorderSide(color: colorScheme.error.withAlpha(100)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 4.0,
                      ),
                    ),
                    onPressed: () =>
                        ref.read(historyProvider.notifier).clearAll(),
                    icon: const Icon(Icons.delete_sweep, size: 15),
                    label: const Text(
                      '清空历史',
                      style: TextStyle(fontSize: 12),
                    ),
                  )
                : null,
          ),
          StatsCards(
            totalCount: historyState.totalCount,
            stats: historyState.usageStats,
          ),
          const SizedBox(height: 14),
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: SingleChildScrollView(
                      child: StudioCard(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32.0,
                          vertical: 24.0,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.inbox_outlined,
                              size: 38,
                              color: colorScheme.outline.withAlpha(150),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '暂无操作历史记录',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: colorScheme.outline,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '在微工具工坊执行格式化、计算或转化后将自动在此留痕',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.outline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return HistoryListItem(
                        item: item,
                        onReplay: () {
                          ref.read(toolboxProvider.notifier).replayRecord(
                                toolType: item.toolType,
                                input: item.inputSummary,
                                output: item.outputContent,
                              );
                          onNavigateToToolbox();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('已回填至 ${item.toolType.label}'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        onDelete: () => ref
                            .read(historyProvider.notifier)
                            .deleteItem(item.id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
