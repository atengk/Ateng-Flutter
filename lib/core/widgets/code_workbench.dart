/// 现代代码与文本工作台窗体组件，支持独立行号槽轨 (Gutter)、底部控制栏 (Footer) 与语法着色
///
/// @author Ateng
/// @since 2026-09-23
library;

import 'package:flutter/material.dart';

import '../utils/json_syntax_highlighter.dart';

/// 代码窗格顶部状态徽章数据模型
class WorkbenchBadge {
  /// 显示文本
  final String label;

  /// 自定义颜色
  final Color? color;

  /// 前缀图标
  final IconData? icon;

  /// 构造函数
  const WorkbenchBadge({
    required this.label,
    this.color,
    this.icon,
  });
}

/// 拟 macOS 窗体装饰三色点组件
class WindowControlsDots extends StatelessWidget {
  /// 构造函数
  const WindowControlsDots({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _WindowDot(color: Color(0xFFFF5F56)),
        SizedBox(width: 5),
        _WindowDot(color: Color(0xFFFFBD2E)),
        SizedBox(width: 5),
        _WindowDot(color: Color(0xFF27C93F)),
      ],
    );
  }
}

class _WindowDot extends StatelessWidget {
  final Color color;

  const _WindowDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8.5,
      height: 8.5,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

/// 专业代码工作台窗格容器
class CodeWorkbench extends StatelessWidget {
  /// 窗格标题
  final String title;

  /// 状态徽章（如行数、字符数、校验结果）
  final List<WorkbenchBadge> badges;

  /// 右上角动作按钮
  final List<Widget> actions;

  /// 窗格核心内容区
  final Widget child;

  /// 窗格底部控制与状态栏
  final Widget? footer;

  /// 构造函数
  const CodeWorkbench({
    super.key,
    required this.title,
    required this.child,
    this.badges = const [],
    this.actions = const [],
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final editorBg = isDark ? const Color(0xFF0F141C) : const Color(0xFFFFFFFF);
    final headerBg = isDark ? const Color(0xFF161B26) : const Color(0xFFF8FAFC);
    final footerBg = isDark ? const Color(0xFF131824) : const Color(0xFFF8FAFC);

    return Container(
      decoration: BoxDecoration(
        color: editorBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? const Color(0x33000000) : const Color(0x0A0F172A),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 7.0,
            ),
            decoration: BoxDecoration(
              color: headerBg,
              border: Border(
                bottom: BorderSide(
                  color: colorScheme.outlineVariant,
                  width: 1.0,
                ),
              ),
            ),
            child: Row(
              children: [
                const WindowControlsDots(),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (final badge in badges) ...[
                          _BadgeChip(badge: badge),
                          const SizedBox(width: 5),
                        ],
                      ],
                    ),
                  ),
                ),
                for (final action in actions) action,
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: editorBg,
              child: child,
            ),
          ),
          if (footer != null)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 6.0,
              ),
              decoration: BoxDecoration(
                color: footerBg,
                border: Border(
                  top: BorderSide(
                    color: colorScheme.outlineVariant,
                    width: 1.0,
                  ),
                ),
              ),
              child: footer!,
            ),
        ],
      ),
    );
  }
}

class _BadgeChip extends StatelessWidget {
  final WorkbenchBadge badge;

  const _BadgeChip({required this.badge});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final badgeColor = badge.color ?? colorScheme.outline;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
      decoration: BoxDecoration(
        color: badgeColor.withAlpha(20),
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(
          color: badgeColor.withAlpha(60),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (badge.icon != null) ...[
            Icon(badge.icon, size: 11.5, color: badgeColor),
            const SizedBox(width: 3),
          ],
          Text(
            badge.label,
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: 11.0,
              color: badgeColor,
              fontWeight: FontWeight.w500,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}

/// 支持独立行号槽轨 (Gutter) 与滚动联动的代码编辑区域
class WorkbenchCodeEditor extends StatefulWidget {
  /// 文本编辑控制器
  final TextEditingController controller;

  /// 输入变化回调
  final ValueChanged<String>? onChanged;

  /// 提示占位文本
  final String? hintText;

  /// 构造函数
  const WorkbenchCodeEditor({
    super.key,
    required this.controller,
    this.onChanged,
    this.hintText,
  });

  @override
  State<WorkbenchCodeEditor> createState() => _WorkbenchCodeEditorState();
}

class _WorkbenchCodeEditorState extends State<WorkbenchCodeEditor> {
  late final ScrollController _contentScrollController;
  late final ScrollController _gutterScrollController;

  @override
  void initState() {
    super.initState();
    _contentScrollController = ScrollController();
    _gutterScrollController = ScrollController();
    _contentScrollController.addListener(_syncScroll);
    widget.controller.addListener(_onTextChanged);
  }

  void _syncScroll() {
    if (_gutterScrollController.hasClients &&
        _gutterScrollController.offset != _contentScrollController.offset) {
      _gutterScrollController.jumpTo(_contentScrollController.offset);
    }
  }

  void _onTextChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _contentScrollController.removeListener(_syncScroll);
    widget.controller.removeListener(_onTextChanged);
    _contentScrollController.dispose();
    _gutterScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final lineCount = widget.controller.text.isEmpty
        ? 1
        : '\n'.allMatches(widget.controller.text).length + 1;

    final gutterBg = isDark ? const Color(0xFF131824) : const Color(0xFFF8FAFC);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: 42.0,
          decoration: BoxDecoration(
            color: gutterBg,
            border: Border(
              right: BorderSide(
                color: colorScheme.outlineVariant.withAlpha(120),
                width: 1.0,
              ),
            ),
          ),
          child: SingleChildScrollView(
            controller: _gutterScrollController,
            physics: const NeverScrollableScrollPhysics(),
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (int i = 1; i <= lineCount; i++)
                  Text(
                    '$i',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontFamily: 'JetBrains Mono',
                      fontFamilyFallback: const [
                        'Consolas',
                        'Menlo',
                        'monospace',
                      ],
                      fontSize: 12.5,
                      height: 1.6,
                      color: colorScheme.outline.withAlpha(160),
                    ),
                    strutStyle: const StrutStyle(
                      fontSize: 14.0,
                      height: 1.6,
                      forceStrutHeight: true,
                    ),
                  ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TextField(
              controller: widget.controller,
              scrollController: _contentScrollController,
              onChanged: widget.onChanged,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              keyboardType: TextInputType.multiline,
              style: TextStyle(
                fontFamily: 'JetBrains Mono',
                fontFamilyFallback: const [
                  'Consolas',
                  'Menlo',
                  'monospace',
                ],
                fontSize: 14.0,
                height: 1.6,
                color: colorScheme.onSurface,
              ),
              strutStyle: const StrutStyle(
                fontSize: 14.0,
                height: 1.6,
                forceStrutHeight: true,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  fontFamily: 'JetBrains Mono',
                  fontFamilyFallback: const [
                    'Consolas',
                    'Menlo',
                    'monospace',
                  ],
                  fontSize: 14.0,
                  height: 1.6,
                  color: colorScheme.outline.withAlpha(140),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// 支持独立行号槽轨 (Gutter)、语法着色与滚动联动的代码展示区域
class WorkbenchCodeViewer extends StatefulWidget {
  /// 显示的文本内容
  final String content;

  /// 内容为空时的占位符
  final String placeholder;

  /// 是否开启 JSON 语法着色
  final bool enableJsonHighlighting;

  /// 构造函数
  const WorkbenchCodeViewer({
    super.key,
    required this.content,
    this.placeholder = '// 等待格式化执行...',
    this.enableJsonHighlighting = true,
  });

  @override
  State<WorkbenchCodeViewer> createState() => _WorkbenchCodeViewerState();
}

class _WorkbenchCodeViewerState extends State<WorkbenchCodeViewer> {
  late final ScrollController _contentScrollController;
  late final ScrollController _gutterScrollController;

  @override
  void initState() {
    super.initState();
    _contentScrollController = ScrollController();
    _gutterScrollController = ScrollController();
    _contentScrollController.addListener(_syncScroll);
  }

  void _syncScroll() {
    if (_gutterScrollController.hasClients &&
        _gutterScrollController.offset != _contentScrollController.offset) {
      _gutterScrollController.jumpTo(_contentScrollController.offset);
    }
  }

  @override
  void dispose() {
    _contentScrollController.removeListener(_syncScroll);
    _contentScrollController.dispose();
    _gutterScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    if (widget.content.isEmpty) {
      return Center(
        child: Text(
          widget.placeholder,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.outline,
            fontFamily: 'JetBrains Mono',
            fontFamilyFallback: const [
              'Consolas',
              'Menlo',
              'monospace',
            ],
          ),
        ),
      );
    }

    final lineCount = '\n'.allMatches(widget.content).length + 1;
    final gutterBg = isDark ? const Color(0xFF131824) : const Color(0xFFF8FAFC);

    final baseTextStyle = TextStyle(
      fontFamily: 'JetBrains Mono',
      fontFamilyFallback: const [
        'Consolas',
        'Menlo',
        'monospace',
      ],
      fontSize: 14.0,
      height: 1.6,
      color: colorScheme.onSurface,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: 42.0,
          decoration: BoxDecoration(
            color: gutterBg,
            border: Border(
              right: BorderSide(
                color: colorScheme.outlineVariant.withAlpha(120),
                width: 1.0,
              ),
            ),
          ),
          child: SingleChildScrollView(
            controller: _gutterScrollController,
            physics: const NeverScrollableScrollPhysics(),
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (int i = 1; i <= lineCount; i++)
                  Text(
                    '$i',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontFamily: 'JetBrains Mono',
                      fontFamilyFallback: const [
                        'Consolas',
                        'Menlo',
                        'monospace',
                      ],
                      fontSize: 12.5,
                      height: 1.6,
                      color: colorScheme.outline.withAlpha(160),
                    ),
                    strutStyle: const StrutStyle(
                      fontSize: 14.0,
                      height: 1.6,
                      forceStrutHeight: true,
                    ),
                  ),
              ],
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            controller: _contentScrollController,
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: widget.enableJsonHighlighting
                  ? SelectableText.rich(
                      JsonSyntaxHighlighter.highlight(
                        widget.content,
                        baseTextStyle,
                      ),
                      strutStyle: const StrutStyle(
                        fontSize: 14.0,
                        height: 1.6,
                        forceStrutHeight: true,
                      ),
                    )
                  : SelectableText(
                      widget.content,
                      style: baseTextStyle,
                      strutStyle: const StrutStyle(
                        fontSize: 14.0,
                        height: 1.6,
                        forceStrutHeight: true,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
