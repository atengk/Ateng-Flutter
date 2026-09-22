/// JSON 格式化与语法校验视图组件，采用极客代码工作台双窗格设计
///
/// @author Ateng
/// @since 2026-09-23
library;

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/code_workbench.dart';
import '../providers/toolbox_provider.dart';

/// JSON 工具视图
class JsonToolView extends ConsumerStatefulWidget {
  /// 构造函数
  const JsonToolView({super.key});

  @override
  ConsumerState<JsonToolView> createState() => _JsonToolViewState();
}

class _JsonToolViewState extends ConsumerState<JsonToolView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: ref.read(toolboxProvider).input,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _syncInput(String val) {
    ref.read(toolboxProvider.notifier).updateInput(val);
    setState(() {});
  }

  void _copy(String text, String tip, BuildContext context) {
    if (text.isEmpty) return;
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(tip), duration: const Duration(seconds: 1)),
    );
  }

  bool _isJsonValid(String input) {
    if (input.trim().isEmpty) return false;
    try {
      jsonDecode(input);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(toolboxProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_controller.text != state.input) {
      _controller.text = state.input;
    }

    final isValid = _isJsonValid(state.input);
    final inputLines =
        state.input.isEmpty ? 0 : '\n'.allMatches(state.input).length + 1;
    final outputLines =
        state.output.isEmpty ? 0 : '\n'.allMatches(state.output).length + 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _StudioActionPill(
              icon: Icons.format_align_left,
              label: '美化格式化',
              isPrimary: true,
              onPressed: () =>
                  ref.read(toolboxProvider.notifier).formatJson(minify: false),
            ),
            _StudioActionPill(
              icon: Icons.compress,
              label: '紧凑压缩',
              onPressed: () =>
                  ref.read(toolboxProvider.notifier).formatJson(minify: true),
            ),
            _StudioActionPill(
              icon: Icons.refresh,
              label: '载入示例',
              onPressed: () {
                _controller.text = AppConstants.sampleJson;
                _syncInput(AppConstants.sampleJson);
              },
            ),
            _StudioActionPill(
              icon: Icons.clear_all,
              label: '清空全部',
              onPressed: () {
                _controller.clear();
                ref.read(toolboxProvider.notifier).clearAll();
                setState(() {});
              },
            ),
          ],
        ),
        if (state.errorMessage != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.statusError.withAlpha(20),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.statusError.withAlpha(80),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 16,
                  color: AppColors.statusError,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    state.errorMessage!,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: AppColors.statusError),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 10),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 500;

              final inputWorkbench = CodeWorkbench(
                title: 'JSON 输入源',
                badges: [
                  WorkbenchBadge(label: '$inputLines 行'),
                  WorkbenchBadge(label: '${state.input.length} 字符'),
                  if (state.input.isNotEmpty)
                    isValid
                        ? const WorkbenchBadge(
                            label: '语法有效',
                            color: AppColors.statusSuccess,
                            icon: Icons.check_circle_outline,
                          )
                        : const WorkbenchBadge(
                            label: '语法错误',
                            color: AppColors.statusError,
                            icon: Icons.cancel_outlined,
                          ),
                ],
                actions: [
                  IconButton(
                    icon: const Icon(Icons.copy, size: 15),
                    tooltip: '复制输入',
                    onPressed: () =>
                        _copy(_controller.text, '已复制输入内容', context),
                  ),
                ],
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: _controller,
                    onChanged: _syncInput,
                    maxLines: null,
                    expands: true,
                    keyboardType: TextInputType.multiline,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12.5,
                      height: 1.55,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '在此输入或粘贴需要校验/美化的 JSON 数据...',
                    ),
                  ),
                ),
              );

              final outputWorkbench = CodeWorkbench(
                title: '格式化输出',
                badges: [
                  WorkbenchBadge(label: '$outputLines 行'),
                  WorkbenchBadge(label: '${state.output.length} 字符'),
                  if (state.output.isNotEmpty)
                    const WorkbenchBadge(
                      label: '转换就绪',
                      color: AppColors.darkAccentCyan,
                      icon: Icons.done_all,
                    ),
                ],
                actions: [
                  IconButton(
                    icon: const Icon(Icons.copy, size: 15),
                    tooltip: '复制输出',
                    onPressed: state.output.isNotEmpty
                        ? () => _copy(state.output, '已复制格式化输出', context)
                        : null,
                  ),
                ],
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: state.output.isEmpty
                      ? Center(
                          child: Text(
                            '// 等待格式化执行...',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.outline,
                              fontFamily: 'monospace',
                            ),
                          ),
                        )
                      : SelectableText(
                          state.output,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12.5,
                            height: 1.55,
                            color: colorScheme.onSurface,
                          ),
                        ),
                ),
              );

              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: inputWorkbench),
                    const SizedBox(width: 10),
                    Expanded(child: outputWorkbench),
                  ],
                );
              }
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 240, child: inputWorkbench),
                    const SizedBox(height: 10),
                    SizedBox(height: 240, child: outputWorkbench),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _StudioActionPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;

  const _StudioActionPill({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bg = isPrimary
        ? colorScheme.primary.withAlpha(30)
        : colorScheme.surfaceContainerHigh;
    final border = isPrimary
        ? colorScheme.primary.withAlpha(90)
        : colorScheme.outlineVariant;
    final textAndIconColor =
        isPrimary ? colorScheme.primary : colorScheme.onSurface;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: border, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: textAndIconColor),
              const SizedBox(width: 6),
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: isPrimary ? FontWeight.bold : FontWeight.w500,
                  fontSize: 12,
                  color: textAndIconColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
