/// 操作历史单条卡片组件
///
/// @author Ateng
/// @since 2026-09-22
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

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
      const SnackBar(
        content: Text('已复制输出结果'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final timeStr = DateFormat('MM-dd HH:mm:ss').format(item.timestamp);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: colorScheme.secondaryContainer,
                  child: Icon(
                    item.toolType.icon,
                    size: 16,
                    color: colorScheme.onSecondaryContainer,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  item.actionName,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  timeStr,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.outline,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withAlpha(120),
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '输入: ${item.inputSummary}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '输出: ${item.outputContent.replaceAll('\n', ' ')}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _copy(item.outputContent, context),
                  icon: const Icon(Icons.copy, size: 16),
                  label: const Text('复制'),
                ),
                TextButton.icon(
                  onPressed: onReplay,
                  icon: const Icon(Icons.replay, size: 16),
                  label: const Text('回填工具'),
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline, size: 18),
                  tooltip: '删除此条',
                  color: colorScheme.error,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
