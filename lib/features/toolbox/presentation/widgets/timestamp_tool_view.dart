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
                        fontWeight: FontWeight.w600,
                        fontFamily: 'JetBrains Mono',
                        fontFamilyFallback: const [
                          'Consolas',
                          'Menlo',
                          'monospace',
                        ],
                      ),
                    ),
                  ],
                ),
                Wrap(
                  spacing: 8,
                  children: [
                    _CopyTimeChip(
                      label: '秒级: $nowSec',
                      onPressed: () => _copy(nowSec.toString()),
                    ),
                    _CopyTimeChip(
                      label: '毫秒: $nowMs',
                      onPressed: () => _copy(nowMs.toString()),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
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
                        style: const TextStyle(
                          fontFamily: 'JetBrains Mono',
                          fontFamilyFallback: [
                            'Consolas',
                            'Menlo',
                            'monospace',
                          ],
                          fontSize: 13,
                        ),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'Unix 时间戳 (秒或毫秒)',
                          prefixIcon: Icon(Icons.pin, size: 18),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    _ConvertActionBtn(
                      label: '转换',
                      icon: Icons.arrow_forward,
                      onPressed: _convertTsToDate,
                    ),
                  ],
                ),
                if (_tsConvertResult.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withAlpha(80),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: colorScheme.outlineVariant,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SelectableText(
                            _tsConvertResult,
                            style: const TextStyle(
                              fontFamily: 'JetBrains Mono',
                              fontFamilyFallback: [
                                'Consolas',
                                'Menlo',
                                'monospace',
                              ],
                              fontSize: 12.5,
                              height: 1.5,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy, size: 16),
                          tooltip: '复制结果',
                          onPressed: () => _copy(_tsConvertResult),
                        ),
                      ],
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
                        style: const TextStyle(
                          fontFamily: 'JetBrains Mono',
                          fontFamilyFallback: [
                            'Consolas',
                            'Menlo',
                            'monospace',
                          ],
                          fontSize: 13,
                        ),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: '格式：yyyy-MM-dd HH:mm:ss',
                          prefixIcon: Icon(Icons.calendar_today, size: 18),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    _ConvertActionBtn(
                      label: '转换',
                      icon: Icons.arrow_forward,
                      onPressed: _convertDateToTs,
                    ),
                  ],
                ),
                if (_dateConvertResult.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withAlpha(80),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: colorScheme.outlineVariant,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SelectableText(
                            _dateConvertResult,
                            style: const TextStyle(
                              fontFamily: 'JetBrains Mono',
                              fontFamilyFallback: [
                                'Consolas',
                                'Menlo',
                                'monospace',
                              ],
                              fontSize: 12.5,
                              height: 1.5,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy, size: 16),
                          tooltip: '复制结果',
                          onPressed: () => _copy(_dateConvertResult),
                        ),
                      ],
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

class _CopyTimeChip extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _CopyTimeChip({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        visualDensity: VisualDensity.compact,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        side: BorderSide(color: colorScheme.outlineVariant),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      onPressed: onPressed,
      icon: const Icon(Icons.copy, size: 13),
      label: Text(
        label,
        style: const TextStyle(
          fontFamily: 'JetBrains Mono',
          fontFamilyFallback: ['Consolas', 'Menlo', 'monospace'],
          fontSize: 12,
        ),
      ),
    );
  }
}

class _ConvertActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _ConvertActionBtn({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0284C7), Color(0xFF0369A1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [
          BoxShadow(
            color: Color(0x330284C7),
            blurRadius: 4,
            offset: Offset(0, 1.5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(6),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9.5),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 15, color: Colors.white),
                const SizedBox(width: 5),
                Text(
                  label,
                  strutStyle: const StrutStyle(
                    forceStrutHeight: true,
                    height: 1.3,
                    leading: 0.1,
                  ),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12.5,
                    color: Colors.white,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
