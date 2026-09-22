/// 工具类型枚举定义
///
/// @author Ateng
/// @since 2026-09-22
library;

import 'package:flutter/material.dart';

/// 微工具类型枚举
enum ToolType {
  /// JSON 格式化与压缩
  json('JSON 格式化', Icons.data_object),

  /// Unix 时间戳与时区换算
  timestamp('时间戳工作室', Icons.access_time),

  /// 哈希与 Base64 编解码
  hash('哈希与编解码', Icons.lock_outline);

  /// 工具显示名称
  final String label;

  /// 工具对应图标
  final IconData icon;

  const ToolType(this.label, this.icon);
}
