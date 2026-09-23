/// 操作历史单条卡片组件，采用 StudioCard 现代流水卡片设计
///
/// @author Ateng
/// @since 2026-09-23
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/studio_card.dart';
import '../../domain/models/history_item.dart';

/// 历史单条流水卡片
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
    final isDark = theme.brightness == Brightness.dark;
    final timeStr = DateFormat('MM-dd HH:mm:ss').format(item.timestamp);

    final previewBg =
        isDark ? const Color(0xFF131824) : const Color(0xFFF8FAFC);

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
                  border: Border.all(
                    color: colorScheme.primary.withAlpha(50),
                    width: 0.8,
                  ),
                ),
                child: Icon(
                  item.toolType.icon,
                  size: 14,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                item.actionName,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 1.5),
                decoration: BoxDecoration(
                  color: const Color(0xFF16A34A).withAlpha(20),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: const Text(
                  '1.2ms',
                  style: TextStyle(
                    fontFamily: 'JetBrains Mono',
                    fontFamilyFallback: ['Consolas', 'Menlo', 'monospace'],
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF16A34A),
                  ),
                ),
              ),
              const Spacer(),
              Text(
                timeStr,
                style: TextStyle(
                  fontFamily: 'JetBrains Mono',
                  fontFamilyFallback: const ['Consolas', 'Menlo', 'monospace'],
                  color: colorScheme.outline,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: previewBg,
              borderRadius: BorderRadius.circular(6.0),
              border: Border.all(
                color: colorScheme.outlineVariant.withAlpha(120),
                width: 0.8,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4.0,
                        vertical: 1.0,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.electricAzure.withAlpha(25),
                        borderRadius: BorderRadius.circular(3.0),
                      ),
                      child: const Text(
                        'IN',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: AppColors.electricAzure,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        item.inputSummary,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'JetBrains Mono',
                          fontFamilyFallback: const [
                            'Consolas',
                            'Menlo',
                            'monospace',
                          ],
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 11.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4.0,
                        vertical: 1.0,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF16A34A).withAlpha(25),
                        borderRadius: BorderRadius.circular(3.0),
                      ),
                      child: const Text(
                        'OUT',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF16A34A),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        item.outputContent.replaceAll('\n', ' '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'JetBrains Mono',
                          fontFamilyFallback: const [
                            'Consolas',
                            'Menlo',
                            'monospace',
                          ],
                          color: colorScheme.onSurface,
                          fontSize: 11.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  foregroundColor: colorScheme.onSurfaceVariant,
                ),
                onPressed: () => _copy(item.outputContent, context),
                icon: const Icon(Icons.copy, size: 13),
                label: const Text('复制输出', style: TextStyle(fontSize: 11.5)),
              ),
              const SizedBox(width: 4),
              TextButton.icon(
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  foregroundColor: AppColors.electricAzure,
                ),
                onPressed: onReplay,
                icon: const Icon(Icons.replay, size: 13),
                label: const Text(
                  '回填工坊',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline, size: 15),
                tooltip: '删除此条',
                color: colorScheme.error.withAlpha(200),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
