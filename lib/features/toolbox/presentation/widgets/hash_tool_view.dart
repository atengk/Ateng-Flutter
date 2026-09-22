/// 哈希计算与 Base64/URL 编解码视图组件
///
/// @author Ateng
/// @since 2026-09-22
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
            FilledButton.tonal(
              onPressed: () => _runOp('md5'),
              child: const Text('MD5 哈希'),
            ),
            FilledButton.tonal(
              onPressed: () => _runOp('sha256'),
              child: const Text('SHA-256 哈希'),
            ),
            FilledButton.tonal(
              onPressed: () => _runOp('base64_encode'),
              child: const Text('Base64 编码'),
            ),
            FilledButton.tonal(
              onPressed: () => _runOp('base64_decode'),
              child: const Text('Base64 解码'),
            ),
            FilledButton.tonal(
              onPressed: () => _runOp('url_encode'),
              child: const Text('URL 编码'),
            ),
            FilledButton.tonal(
              onPressed: () => _runOp('url_decode'),
              child: const Text('URL 解码'),
            ),
            TextButton.icon(
              onPressed: () {
                _inputController.clear();
                ref.read(toolboxProvider.notifier).clearAll();
              },
              icon: const Icon(Icons.clear_all),
              label: const Text('清空'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _inputController,
              onChanged: (val) =>
                  ref.read(toolboxProvider.notifier).updateInput(val),
              maxLines: 4,
              decoration: const InputDecoration(
                border: InputBorder.none,
                labelText: '输入需要处理的文本内容',
                hintText: '在此输入或粘贴文本...',
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('计算/转换结果', style: theme.textTheme.labelLarge),
                      IconButton(
                        icon: const Icon(Icons.copy, size: 18),
                        tooltip: '复制结果',
                        onPressed: state.output.isNotEmpty
                            ? () => _copy(state.output, context)
                            : null,
                      ),
                    ],
                  ),
                  const Divider(height: 12),
                  Expanded(
                    child: SelectableText(
                      state.output.isEmpty ? '点击上方按钮执行对应运算...' : state.output,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 14,
                        color: state.output.isEmpty
                            ? colorScheme.outline
                            : colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
