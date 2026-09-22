/// 工具工坊全局输入与转换执行状态管理
///
/// @author Ateng
/// @since 2026-09-22
library;

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/crypto_utils.dart';
import '../../../history/presentation/providers/history_provider.dart';
import '../../domain/models/tool_type.dart';

/// 工具工坊状态模型
class ToolboxState {
  /// 当前选中的微工具
  final ToolType currentTool;

  /// 输入内容
  final String input;

  /// 输出转换结果
  final String output;

  /// 错误提示信息（如有）
  final String? errorMessage;

  /// 构造函数
  const ToolboxState({
    required this.currentTool,
    required this.input,
    required this.output,
    this.errorMessage,
  });

  /// 复制状态
  ToolboxState copyWith({
    ToolType? currentTool,
    String? input,
    String? output,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ToolboxState(
      currentTool: currentTool ?? this.currentTool,
      input: input ?? this.input,
      output: output ?? this.output,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// 工具工坊控制器
class ToolboxNotifier extends StateNotifier<ToolboxState> {
  final Ref _ref;

  /// 构造函数，初始载入示例 JSON
  ToolboxNotifier(this._ref)
      : super(
          const ToolboxState(
            currentTool: ToolType.json,
            input: AppConstants.sampleJson,
            output: '',
          ),
        );

  /// 切换当前工具
  void setTool(ToolType tool) {
    if (state.currentTool == tool) return;
    state = state.copyWith(
      currentTool: tool,
      errorMessage: null,
      clearError: true,
    );
  }

  /// 更新输入文本
  void updateInput(String text) {
    state = state.copyWith(
      input: text,
      clearError: true,
    );
  }

  /// 清空输入与输出
  void clearAll() {
    state = state.copyWith(
      input: '',
      output: '',
      clearError: true,
    );
  }

  /// 格式化或压缩 JSON
  void formatJson({required bool minify}) {
    final raw = state.input.trim();
    if (raw.isEmpty) {
      state = state.copyWith(errorMessage: '输入不能为空');
      return;
    }

    try {
      final dynamic parsed = json.decode(raw);
      final String formatted;
      if (minify) {
        formatted = json.encode(parsed);
      } else {
        const encoder = JsonEncoder.withIndent('  ');
        formatted = encoder.convert(parsed);
      }

      state = state.copyWith(
        output: formatted,
        clearError: true,
      );

      // 记录至操作历史
      _ref.read(historyProvider.notifier).addRecord(
            toolType: ToolType.json,
            actionName: minify ? 'JSON 紧凑压缩' : 'JSON 格式化 (2 空格)',
            input: raw,
            output: formatted,
          );
    } catch (e) {
      state = state.copyWith(
        output: '',
        errorMessage: 'JSON 解析语法错误：$e',
      );
    }
  }

  /// 执行文本编解码或哈希
  void processCrypto(String operation) {
    final raw = state.input;
    if (raw.isEmpty) {
      state = state.copyWith(errorMessage: '输入文本不能为空');
      return;
    }

    String result = '';
    String actionLabel = '';

    switch (operation) {
      case 'md5':
        result = CryptoUtils.md5Hash(raw);
        actionLabel = 'MD5 哈希计算';
      case 'sha256':
        result = CryptoUtils.sha256Hash(raw);
        actionLabel = 'SHA-256 哈希计算';
      case 'base64_encode':
        result = CryptoUtils.base64EncodeText(raw);
        actionLabel = 'Base64 编码';
      case 'base64_decode':
        result = CryptoUtils.base64DecodeText(raw);
        actionLabel = 'Base64 解码';
      case 'url_encode':
        result = CryptoUtils.urlEncodeText(raw);
        actionLabel = 'URL 编码';
      case 'url_decode':
        result = CryptoUtils.urlDecodeText(raw);
        actionLabel = 'URL 解码';
      default:
        result = raw;
        actionLabel = '原始文本';
    }

    state = state.copyWith(
      output: result,
      clearError: true,
    );

    _ref.read(historyProvider.notifier).addRecord(
          toolType: ToolType.hash,
          actionName: actionLabel,
          input: raw,
          output: result,
        );
  }

  /// 回填历史记录到当前工具工坊
  void replayRecord({
    required ToolType toolType,
    required String input,
    required String output,
  }) {
    state = state.copyWith(
      currentTool: toolType,
      input: input,
      output: output,
      clearError: true,
    );
  }
}

/// 全局工具状态提供者
final toolboxProvider = StateNotifierProvider<ToolboxNotifier, ToolboxState>(
  (ref) => ToolboxNotifier(ref),
);
