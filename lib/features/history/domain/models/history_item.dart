/// 操作历史条目领域模型
///
/// @author Ateng
/// @since 2026-09-22
library;

import 'package:ateng_flutter/features/toolbox/domain/models/tool_type.dart';

/// 历史记录实体类
class HistoryItem {
  /// 唯一标识
  final String id;

  /// 所属工具类型
  final ToolType toolType;

  /// 动作名称说明
  final String actionName;

  /// 输入摘要
  final String inputSummary;

  /// 输出完整内容
  final String outputContent;

  /// 执行时间戳
  final DateTime timestamp;

  /// 构造函数
  const HistoryItem({
    required this.id,
    required this.toolType,
    required this.actionName,
    required this.inputSummary,
    required this.outputContent,
    required this.timestamp,
  });

  /// 转换为 JSON Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'toolType': toolType.name,
      'actionName': actionName,
      'inputSummary': inputSummary,
      'outputContent': outputContent,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  /// 从 JSON Map 解析
  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    final toolTypeName = json['toolType'] as String? ?? 'json';
    final matchedTool = ToolType.values.firstWhere(
      (ToolType e) => e.name == toolTypeName,
      orElse: () => ToolType.json,
    );

    return HistoryItem(
      id: json['id'] as String? ?? '',
      toolType: matchedTool,
      actionName: json['actionName'] as String? ?? '',
      inputSummary: json['inputSummary'] as String? ?? '',
      outputContent: json['outputContent'] as String? ?? '',
      timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}
