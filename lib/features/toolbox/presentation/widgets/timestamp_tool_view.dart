/// Unix 时间戳与时间互转工作台组件
///
/// @author Ateng
/// @since 2026-09-23
library;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/studio_card.dart';
import '../../../history/presentation/providers/history_provider.dart';
import '../../domain/models/tool_type.dart';

/// 时间戳工作台视图
class TimestampToolView extends ConsumerStatefulWidget {
  /// 构造函数
  const TimestampToolView({super.key});

  @override
  ConsumerState<TimestampToolView> createState() => _TimestampToolViewState();
}

class _TimestampToolViewState extends ConsumerState<TimestampToolView> {
  Timer? _ticker;
  DateTime _now = DateTime.now();

  late final TextEditingController _tsController;
  late final TextEditingController _dateController;
  String _tsConvertResult = '';
  String _dateConvertResult = '';

  final DateFormat _formatter = DateFormat('yyyy-MM-dd HH:mm:ss');

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _now = DateTime.now();
      });
    });

    _tsController = TextEditingController(
      text: (_now.millisecondsSinceEpoch ~/ 1000).toString(),
    );
    _dateController = TextEditingController(
      text: _formatter.format(_now),
    );
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _tsController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _copy(String text) {
    if (text.isEmpty) return;
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('已复制到剪贴板'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _convertTsToDate() {
    final raw = _tsController.text.trim();
    final val = int.tryParse(raw);
    if (val == null) {
      setState(() => _tsConvertResult = '转换失败：请输入合法的数字时间戳');
      return;
    }

    final isMillis = raw.length >= 13;
    final date = isMillis
        ? DateTime.fromMillisecondsSinceEpoch(val)
        : DateTime.fromMillisecondsSinceEpoch(val * 1000);

    final res = _formatter.format(date);
    setState(() {
      _tsConvertResult =
          '$res (本地时间)\n${_formatter.format(date.toUtc())} (UTC)';
    });

    ref.read(historyProvider.notifier).addRecord(
          toolType: ToolType.timestamp,
          actionName: '时间戳转日期',
          input: raw,
          output: res,
        );
  }

  void _convertDateToTs() {
    final raw = _dateController.text.trim();
    try {
      final date = _formatter.parse(raw);
      final sec = date.millisecondsSinceEpoch ~/ 1000;
      final ms = date.millisecondsSinceEpoch;
      final res = '秒级时间戳: $sec\n毫秒时间戳: $ms';
      setState(() => _dateConvertResult = res);

      ref.read(historyProvider.notifier).addRecord(
            toolType: ToolType.timestamp,
            actionName: '日期转时间戳',
            input: raw,
            output: '$sec ($ms ms)',
          );
    } catch (_) {
      setState(() => _dateConvertResult = '转换失败：格式形如 2026-09-23 12:00:00');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final nowSec = _now.millisecondsSinceEpoch ~/ 1000;
    final nowMs = _now.millisecondsSinceEpoch;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StudioCard(
            backgroundColor: colorScheme.surfaceContainerLow,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '当前系统时间 (Live Ticker)',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _formatter.format(_now),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
                Wrap(
                  spacing: 8,
                  children: [
                    ActionChip(
                      avatar: const Icon(Icons.copy, size: 14),
                      label: Text('秒级: $nowSec'),
                      onPressed: () => _copy(nowSec.toString()),
                    ),
                    ActionChip(
                      avatar: const Icon(Icons.copy, size: 14),
                      label: Text('毫秒: $nowMs'),
                      onPressed: () => _copy(nowMs.toString()),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          StudioCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('时间戳转格式化时间', style: theme.textTheme.titleSmall),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _tsController,
                        style: const TextStyle(fontFamily: 'monospace'),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'Unix 时间戳 (秒或毫秒)',
                          prefixIcon: Icon(Icons.pin, size: 18),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    FilledButton.icon(
                      onPressed: _convertTsToDate,
                      icon: const Icon(Icons.arrow_forward, size: 16),
                      label: const Text('转换'),
                    ),
                  ],
                ),
                if (_tsConvertResult.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SelectableText(
                      _tsConvertResult,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          StudioCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('日期时间转时间戳', style: theme.textTheme.titleSmall),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _dateController,
                        style: const TextStyle(fontFamily: 'monospace'),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: '格式：yyyy-MM-dd HH:mm:ss',
                          prefixIcon: Icon(Icons.calendar_today, size: 18),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    FilledButton.icon(
                      onPressed: _convertDateToTs,
                      icon: const Icon(Icons.arrow_forward, size: 16),
                      label: const Text('转换'),
                    ),
                  ],
                ),
                if (_dateConvertResult.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SelectableText(
                      _dateConvertResult,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
