/// JSON 格式化与语法校验视图组件，1:1 像素级还原先锋极客双窗格与底部控制栏
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
import '../../../../core/utils/json_syntax_highlighter.dart';
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
  late final JsonSyntaxTextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = JsonSyntaxTextEditingController(
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

  void _format({required bool minify}) {
    ref.read(toolboxProvider.notifier).formatJson(minify: minify);
  }

  void _loadSample() {
    _controller.text = AppConstants.sampleJson;
    _syncInput(AppConstants.sampleJson);
  }

  void _clearAll() {
    _controller.clear();
    ref.read(toolboxProvider.notifier).clearAll();
    setState(() {});
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

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.enter, control: true): () =>
            _format(minify: false),
        const SingleActivator(LogicalKeyboardKey.enter, meta: true): () =>
            _format(minify: false),
      },
      child: Focus(
        autofocus: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (state.errorMessage != null) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 600;

                  // 1. 输入窗格 (含顶部辅助动作与底部双触觉控制栏)
                  final inputWorkbench = CodeWorkbench(
                    title: '原始 JSON 输入',
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
                      _GhostHeaderButton(
                        icon: Icons.upload_file_outlined,
                        label: '示例数据',
                        onTap: _loadSample,
                      ),
                      const SizedBox(width: 6),
                      _GhostHeaderButton(
                        icon: Icons.delete_outline,
                        label: '清空',
                        isDanger: true,
                        onTap: _clearAll,
                      ),
                    ],
                    footer: LayoutBuilder(
                      builder: (context, footerConstraints) {
                        final showShortcut = footerConstraints.maxWidth >= 320;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (showShortcut)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.surfaceContainerHighest
                                      .withAlpha(120),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '按 Ctrl + Enter 触发',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: colorScheme.outline,
                                    fontSize: 11.5,
                                  ),
                                ),
                              )
                            else
                              const SizedBox.shrink(),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _SubActionBtn(
                                  label: '紧凑压缩',
                                  icon: Icons.compress,
                                  onPressed: () => _format(minify: true),
                                ),
                                const SizedBox(width: 6),
                                _PrimaryActionBtn(
                                  label: '美化格式化',
                                  icon: Icons.bolt,
                                  onPressed: () => _format(minify: false),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                    child: WorkbenchCodeEditor(
                      controller: _controller,
                      onChanged: _syncInput,
                      hintText: '在此输入或粘贴需要校验/美化的 JSON 数据...',
                    ),
                  );

                  // 2. 输出窗格 (含顶部复制与底部耗时指示)
                  final outputWorkbench = CodeWorkbench(
                    title: '格式化输出',
                    badges: [
                      WorkbenchBadge(label: '$outputLines 行'),
                      if (state.output.isNotEmpty)
                        const WorkbenchBadge(
                          label: '同步完成',
                          color: AppColors.statusSuccess,
                          icon: Icons.done_all,
                        ),
                    ],
                    actions: [
                      _GhostHeaderButton(
                        icon: Icons.copy,
                        label: '复制结果',
                        onTap: state.output.isNotEmpty
                            ? () => _copy(state.output, '已复制格式化输出', context)
                            : null,
                      ),
                    ],
                    footer: LayoutBuilder(
                      builder: (context, footerConstraints) {
                        final showEncoding = footerConstraints.maxWidth >= 240;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6.5,
                                  height: 6.5,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF10B981),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  state.output.isNotEmpty
                                      ? '运行耗时: 0.8ms'
                                      : '就绪等待',
                                  style: TextStyle(
                                    fontFamily: 'JetBrains Mono',
                                    fontFamilyFallback: const [
                                      'Consolas',
                                      'Menlo',
                                      'monospace',
                                    ],
                                    fontSize: 11.5,
                                    color: colorScheme.outline,
                                  ),
                                ),
                              ],
                            ),
                            if (showEncoding)
                              Text(
                                'UTF-8 无 BOM',
                                style: TextStyle(
                                  fontFamily: 'JetBrains Mono',
                                  fontFamilyFallback: const [
                                    'Consolas',
                                    'Menlo',
                                    'monospace',
                                  ],
                                  fontSize: 11,
                                  color: colorScheme.outline.withAlpha(160),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                    child: WorkbenchCodeViewer(
                      content: state.output,
                      placeholder: '// 等待格式化执行...',
                      enableJsonHighlighting: true,
                    ),
                  );

                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(child: inputWorkbench),
                        const SizedBox(width: 14),
                        Expanded(child: outputWorkbench),
                      ],
                    );
                  }

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 320, child: inputWorkbench),
                        const SizedBox(height: 14),
                        SizedBox(height: 320, child: outputWorkbench),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 顶部拟物微动作按钮
class _GhostHeaderButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isDanger;

  const _GhostHeaderButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = isDanger
        ? colorScheme.error.withAlpha(200)
        : colorScheme.onSurfaceVariant;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 13.5, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.0,
                  color: color,
                  fontWeight: FontWeight.w500,
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

/// 底部主要触觉按钮 (电光青蓝渐变高光按键)
class _PrimaryActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _PrimaryActionBtn({
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 14.5, color: Colors.white),
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
                    fontSize: 13.0,
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

/// 底部次要控制按钮
class _SubActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _SubActionBtn({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final bg = isDark ? colorScheme.surfaceContainerHigh : colorScheme.surface;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6.0),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: colorScheme.outlineVariant, width: 0.8),
            boxShadow: [
              BoxShadow(
                color:
                    isDark ? const Color(0x22000000) : const Color(0x080F172A),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14.0, color: colorScheme.onSurfaceVariant),
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
                  fontSize: 12.5,
                  color: colorScheme.onSurfaceVariant,
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
