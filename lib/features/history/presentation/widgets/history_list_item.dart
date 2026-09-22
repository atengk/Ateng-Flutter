/// 操作历史单条卡片组件，采用 StudioCard 极客微边框设计
///
/// @author Ateng
/// @since 2026-09-23
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/studio_card.dart';
import '../../domain/models/history_item.dart';

/// 历史单条卡片
class HistoryListItem extends StatelessWidget {
  /// 历史条目数据
  final HistoryItem item;

  /// 回填回调
  final VoidCallback onReplay;

  /// 删除回调
  final VoidCallback onDelete;

  /// 构造函数
  const HistoryListItem({
    super.key,
    required this.item,
    required this.onReplay,
    required this.onDelete,
  });

  void _copy(String text, BuildContext context) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('已复制输出结果'), duration: Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final timeStr = DateFormat('MM-dd HH:mm:ss').format(item.timestamp);

    return StudioCard(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: Icon(
                  item.toolType.icon,
                  size: 15,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                item.actionName,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                timeStr,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(6.0),
              border: Border.all(
                color: colorScheme.outlineVariant,
                width: 0.8,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '输入: ${item.inputSummary}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '输出: ${item.outputContent.replaceAll('\n', ' ')}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () => _copy(item.outputContent, context),
                icon: const Icon(Icons.copy, size: 14),
                label: const Text('复制', style: TextStyle(fontSize: 12)),
              ),
              TextButton.icon(
                onPressed: onReplay,
                icon: const Icon(Icons.replay, size: 14),
                label: const Text('回填', style: TextStyle(fontSize: 12)),
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline, size: 16),
                tooltip: '删除此条',
                color: colorScheme.error,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
