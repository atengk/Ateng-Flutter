/// 零外部依赖的轻量级 JSON 语法高亮着色器与文本控制器
///
/// @author Ateng
/// @since 2026-09-23
library;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// 专为 JSON 编辑打造的高性能轻量语法着色控制器
class JsonSyntaxTextEditingController extends TextEditingController {
  /// 构造函数
  JsonSyntaxTextEditingController({super.text});

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final baseStyle = style ??
        const TextStyle(
          fontFamily: 'JetBrains Mono',
          fontFamilyFallback: ['Consolas', 'Menlo', 'monospace'],
          fontSize: 13.0,
          height: 1.6,
        );

    return JsonSyntaxHighlighter.highlight(text, baseStyle);
  }
}

/// JSON 语法着色工具类
abstract final class JsonSyntaxHighlighter {
  // 命名捕获组组合正则
  static final RegExp _jsonRegex = RegExp(
    r'(?<key>"[^"\\]*(?:\\.[^"\\]*)*"\s*:)|'
    r'(?<string>"[^"\\]*(?:\\.[^"\\]*)*")|'
    r'(?<number>\b-?\d+(?:\.\d+)?(?:[eE][+-]?\d+)?\b)|'
    r'(?<bool>\b(?:true|false|null)\b)|'
    r'(?<punct>[{}[\],:])',
  );

  /// 将纯文本解析并渲染为彩色 TextSpan
  static TextSpan highlight(String text, TextStyle baseStyle) {
    if (text.isEmpty) {
      return TextSpan(text: '', style: baseStyle);
    }

    final keyStyle = baseStyle.copyWith(
      color: AppColors.electricAzure,
      fontWeight: FontWeight.w600,
    );
    final stringStyle = baseStyle.copyWith(
      color: const Color(0xFF16A34A),
    );
    final numberStyle = baseStyle.copyWith(
      color: const Color(0xFFD97706),
      fontWeight: FontWeight.w600,
    );
    final boolStyle = baseStyle.copyWith(
      color: const Color(0xFF8B5CF6),
      fontWeight: FontWeight.w600,
    );
    final punctStyle = baseStyle.copyWith(
      color: const Color(0xFF64748B),
    );

    final spans = <TextSpan>[];
    var lastIndex = 0;

    for (final match in _jsonRegex.allMatches(text)) {
      if (match.start > lastIndex) {
        spans.add(
          TextSpan(
            text: text.substring(lastIndex, match.start),
            style: baseStyle,
          ),
        );
      }

      final keyGroup = match.namedGroup('key');
      final stringGroup = match.namedGroup('string');
      final numberGroup = match.namedGroup('number');
      final boolGroup = match.namedGroup('bool');
      final punctGroup = match.namedGroup('punct');

      if (keyGroup != null) {
        final colonIdx = keyGroup.lastIndexOf(':');
        if (colonIdx != -1) {
          spans.add(
            TextSpan(
              text: keyGroup.substring(0, colonIdx),
              style: keyStyle,
            ),
          );
          spans.add(
            TextSpan(
              text: keyGroup.substring(colonIdx),
              style: punctStyle,
            ),
          );
        } else {
          spans.add(TextSpan(text: keyGroup, style: keyStyle));
        }
      } else if (stringGroup != null) {
        spans.add(TextSpan(text: stringGroup, style: stringStyle));
      } else if (numberGroup != null) {
        spans.add(TextSpan(text: numberGroup, style: numberStyle));
      } else if (boolGroup != null) {
        spans.add(TextSpan(text: boolGroup, style: boolStyle));
      } else if (punctGroup != null) {
        spans.add(TextSpan(text: punctGroup, style: punctStyle));
      }

      lastIndex = match.end;
    }

    if (lastIndex < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(lastIndex),
          style: baseStyle,
        ),
      );
    }

    return TextSpan(style: baseStyle, children: spans);
  }
}
