/// JSON 格式化与语法校验视图组件
///
/// @author Ateng
/// @since 2026-09-22
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
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
  }

  void _copyToClipboard(String text, BuildContext context) {
    if (text.isEmpty) return;
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('已复制到系统剪贴板'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(toolboxProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // 当从历史记录回填时同步输入框控制器
    if (_controller.text != state.input) {
      _controller.text = state.input;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilledButton.icon(
              onPressed: () =>
                  ref.read(toolboxProvider.notifier).formatJson(minify: false),
              icon: const Icon(Icons.format_align_left),
              label: const Text('美化格式化'),
            ),
            FilledButton.tonalIcon(
              onPressed: () =>
                  ref.read(toolboxProvider.notifier).formatJson(minify: true),
              icon: const Icon(Icons.compress),
              label: const Text('紧凑压缩'),
            ),
            OutlinedButton.icon(
              onPressed: () {
                _controller.text = AppConstants.sampleJson;
                _syncInput(AppConstants.sampleJson);
              },
              icon: const Icon(Icons.refresh),
              label: const Text('载入示例'),
            ),
            TextButton.icon(
              onPressed: () {
                _controller.clear();
                ref.read(toolboxProvider.notifier).clearAll();
              },
              icon: const Icon(Icons.clear_all),
              label: const Text('清空'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (state.errorMessage != null)
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: colorScheme.error),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    state.errorMessage!,
                    style: TextStyle(color: colorScheme.onErrorContainer),
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 720;
              final inputWidget = Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('JSON 输入源', style: theme.textTheme.labelLarge),
                          IconButton(
                            icon: const Icon(Icons.copy, size: 18),
                            tooltip: '复制输入',
                            onPressed: () =>
                                _copyToClipboard(_controller.text, context),
                          ),
                        ],
                      ),
                      const Divider(height: 12),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          onChanged: _syncInput,
                          maxLines: null,
                          expands: true,
                          keyboardType: TextInputType.multiline,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 13,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: '在此输入或粘贴需要校验/美化的 JSON 数据...',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );

              final outputWidget = Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('格式化输出', style: theme.textTheme.labelLarge),
                          IconButton(
                            icon: const Icon(Icons.copy, size: 18),
                            tooltip: '复制输出',
                            onPressed: state.output.isNotEmpty
                                ? () => _copyToClipboard(state.output, context)
                                : null,
                          ),
                        ],
                      ),
                      const Divider(height: 12),
                      Expanded(
                        child: SelectableText(
                          state.output.isEmpty ? '等待转换执行...' : state.output,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 13,
                            color: state.output.isEmpty
                                ? colorScheme.outline
                                : colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );

              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: inputWidget),
                    const SizedBox(width: 12),
                    Expanded(child: outputWidget),
                  ],
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: inputWidget),
                    const SizedBox(height: 12),
                    Expanded(child: outputWidget),
                  ],
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
