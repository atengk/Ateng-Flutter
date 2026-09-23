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

    if (_inputController.text != state.input) {
      _inputController.text = state.input;
    }

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
            _CryptoActionBtn(
              label: 'MD5 哈希',
              icon: Icons.fingerprint,
              isPrimary: true,
              onPressed: () => _runOp('md5'),
            ),
            _CryptoActionBtn(
              label: 'SHA-256',
              icon: Icons.security,
              isPrimary: true,
              onPressed: () => _runOp('sha256'),
            ),
            _CryptoActionBtn(
              label: 'Base64 编码',
              icon: Icons.lock_outline,
              onPressed: () => _runOp('base64_encode'),
            ),
            _CryptoActionBtn(
              label: 'Base64 解码',
              icon: Icons.lock_open,
              onPressed: () => _runOp('base64_decode'),
            ),
            _CryptoActionBtn(
              label: 'URL 编码',
              icon: Icons.link,
              onPressed: () => _runOp('url_encode'),
            ),
            _CryptoActionBtn(
              label: 'URL 解码',
              icon: Icons.link_off,
              onPressed: () => _runOp('url_decode'),
            ),
            _CryptoActionBtn(
              label: '清空全部',
              icon: Icons.clear_all,
              onPressed: () {
                _inputController.clear();
                ref.read(toolboxProvider.notifier).clearAll();
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
                  WorkbenchBadge(label: '$inputLines 行'),
                  WorkbenchBadge(label: '${state.input.length} 字符'),
                ],
                actions: [
                  IconButton(
                    icon: const Icon(Icons.copy, size: 15),
                    tooltip: '复制输入',
                    onPressed: () => _copy(_inputController.text, context),
                  ),
                ],
                child: WorkbenchCodeEditor(
                  controller: _inputController,
                  onChanged: (val) =>
                      ref.read(toolboxProvider.notifier).updateInput(val),
                  hintText: '输入需要进行哈希计算或编解码的原始字符串...',
                ),
              );

              final outputWorkbench = CodeWorkbench(
                title: '计算结果输出',
                badges: [
                  WorkbenchBadge(label: '$outputLines 行'),
                  WorkbenchBadge(label: '${state.output.length} 字符'),
                  if (state.output.isNotEmpty)
                    const WorkbenchBadge(
                      label: '完成',
                      color: AppColors.electricAzure,
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
                child: WorkbenchCodeViewer(
                  content: state.output,
                  placeholder: '// 点击上方算法按钮执行计算...',
                ),
              );

              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: inputWorkbench),
                    const SizedBox(width: 16),
                    Expanded(child: outputWorkbench),
                  ],
                );
              }
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 260, child: inputWorkbench),
                    const SizedBox(height: 16),
                    SizedBox(height: 260, child: outputWorkbench),
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

class _CryptoActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isPrimary;

  const _CryptoActionBtn({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    if (isPrimary) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(6),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6.5),
            decoration: BoxDecoration(
              color: colorScheme.primary.withAlpha(25),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: colorScheme.primary.withAlpha(80),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 14, color: colorScheme.primary),
                const SizedBox(width: 5),
                Text(
                  label,
                  strutStyle: const StrutStyle(
                    forceStrutHeight: true,
                    height: 1.3,
                    leading: 0.1,
                  ),
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: colorScheme.primary,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final bg = isDark ? colorScheme.surfaceContainerHigh : colorScheme.surface;
    final border = colorScheme.outlineVariant;
    final textAndIconColor = colorScheme.onSurface;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6.5),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: border, width: 1),
            boxShadow: [
              BoxShadow(
                color:
                    isDark ? const Color(0x22000000) : const Color(0x0A0F172A),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14.5, color: textAndIconColor),
              const SizedBox(width: 5),
              Text(
                label,
                strutStyle: const StrutStyle(
                  forceStrutHeight: true,
                  height: 1.3,
                  leading: 0.1,
                ),
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: textAndIconColor,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
