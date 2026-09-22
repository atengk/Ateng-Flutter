/// 哈希计算与 Base64/URL 编解码视图组件，采用极客工作台设计
///
/// @author Ateng
/// @since 2026-09-23
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/code_workbench.dart';
import '../providers/toolbox_provider.dart';

/// 哈希与编解码工作台
class HashToolView extends ConsumerStatefulWidget {
  /// 构造函数
  const HashToolView({super.key});

  @override
  ConsumerState<HashToolView> createState() => _HashToolViewState();
}

class _HashToolViewState extends ConsumerState<HashToolView> {
  late final TextEditingController _inputController;

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController(
      text: ref.read(toolboxProvider).input,
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _copy(String text, BuildContext context) {
    if (text.isEmpty) return;
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('结果已复制到剪贴板'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _runOp(String op) {
    final notifier = ref.read(toolboxProvider.notifier);
    notifier.updateInput(_inputController.text);
    notifier.processCrypto(op);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(toolboxProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_inputController.text != state.input) {
      _inputController.text = state.input;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilledButton.tonalIcon(
              onPressed: () => _runOp('md5'),
              icon: const Icon(Icons.fingerprint, size: 16),
              label: const Text('MD5 哈希'),
            ),
            FilledButton.tonalIcon(
              onPressed: () => _runOp('sha256'),
              icon: const Icon(Icons.security, size: 16),
              label: const Text('SHA-256'),
            ),
            OutlinedButton.icon(
              onPressed: () => _runOp('base64_encode'),
              icon: const Icon(Icons.lock_outline, size: 16),
              label: const Text('Base64 编码'),
            ),
            OutlinedButton.icon(
              onPressed: () => _runOp('base64_decode'),
              icon: const Icon(Icons.lock_open, size: 16),
              label: const Text('Base64 解码'),
            ),
            OutlinedButton.icon(
              onPressed: () => _runOp('url_encode'),
              icon: const Icon(Icons.link, size: 16),
              label: const Text('URL 编码'),
            ),
            OutlinedButton.icon(
              onPressed: () => _runOp('url_decode'),
              icon: const Icon(Icons.link_off, size: 16),
              label: const Text('URL 解码'),
            ),
            TextButton.icon(
              onPressed: () {
                _inputController.clear();
                ref.read(toolboxProvider.notifier).clearAll();
              },
              icon: const Icon(Icons.clear_all, size: 16),
              label: const Text('清空'),
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
            child: Text(
              state.errorMessage!,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: AppColors.statusError),
            ),
          ),
        ],
        const SizedBox(height: 10),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 500;

              final inputWorkbench = CodeWorkbench(
                title: '原始文本输入',
                badges: [
                  WorkbenchBadge(label: '${state.input.length} 字符'),
                ],
                actions: [
                  IconButton(
                    icon: const Icon(Icons.copy, size: 15),
                    tooltip: '复制输入',
                    onPressed: () => _copy(_inputController.text, context),
                  ),
                ],
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: _inputController,
                    onChanged: (val) =>
                        ref.read(toolboxProvider.notifier).updateInput(val),
                    maxLines: null,
                    expands: true,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '输入需要进行哈希计算或编解码的原始字符串...',
                    ),
                  ),
                ),
              );

              final outputWorkbench = CodeWorkbench(
                title: '计算结果输出',
                badges: [
                  WorkbenchBadge(label: '${state.output.length} 字符'),
                  if (state.output.isNotEmpty)
                    const WorkbenchBadge(
                      label: '完成',
                      color: AppColors.darkAccentCyan,
                      icon: Icons.check,
                    ),
                ],
                actions: [
                  IconButton(
                    icon: const Icon(Icons.copy, size: 15),
                    tooltip: '复制结果',
                    onPressed: state.output.isNotEmpty
                        ? () => _copy(state.output, context)
                        : null,
                  ),
                ],
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: state.output.isEmpty
                      ? Center(
                          child: Text(
                            '// 点击上方算法按钮执行计算...',
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
                            fontSize: 13,
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
                    SizedBox(height: 220, child: inputWorkbench),
                    const SizedBox(height: 10),
                    SizedBox(height: 220, child: outputWorkbench),
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
