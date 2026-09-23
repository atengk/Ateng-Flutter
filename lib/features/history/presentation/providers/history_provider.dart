/// 操作历史与统计指标状态管理
///
/// @author Ateng
/// @since 2026-09-22
library;

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../../domain/models/history_item.dart';
import '../../../toolbox/domain/models/tool_type.dart';

/// 历史记录状态模型
class HistoryState {
  /// 历史记录列表
  final List<HistoryItem> items;

  /// 构造函数
  const HistoryState({
    required this.items,
  });

  /// 总操作次数
  int get totalCount => items.length;

  /// 各工具使用频次统计
  Map<ToolType, int> get usageStats {
    final stats = <ToolType, int>{
      ToolType.json: 0,
      ToolType.timestamp: 0,
      ToolType.hash: 0,
    };
    for (final item in items) {
      stats[item.toolType] = (stats[item.toolType] ?? 0) + 1;
    }
    return stats;
  }

  /// 复制状态
  HistoryState copyWith({
    List<HistoryItem>? items,
  }) {
    return HistoryState(
      items: items ?? this.items,
    );
  }
}

/// 历史状态控制器
class HistoryNotifier extends StateNotifier<HistoryState> {
  /// 构造函数
  HistoryNotifier() : super(const HistoryState(items: [])) {
    _loadFromStorage();
  }

  /// 从持久化存储中读取历史记录
  Future<void> _loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(AppConstants.prefsHistoryKey);

    if (jsonList == null || jsonList.isEmpty) {
      // 首次加载预置种子记录
      final initialItems = [
        HistoryItem(
          id: 'seed-1',
          toolType: ToolType.json,
          actionName: 'JSON 格式化 (2 空格)',
          inputSummary: '{"app":"DevToolbox","version":"1.0.0"}',
          outputContent: '{\n  "app": "DevToolbox",\n  "version": "1.0.0"\n}',
          timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        ),
        HistoryItem(
          id: 'seed-2',
          toolType: ToolType.hash,
          actionName: 'SHA-256 计算',
          inputSummary: 'Hello Flutter Multiplatform',
          outputContent:
              '19bcf891823eb5fcfb939e6a9a7a69584288006e885c3b995e80dc9e78a631c1',
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        ),
      ];
      state = state.copyWith(items: initialItems);
      await _saveToStorage(initialItems);
      return;
    }

    final loadedItems = <HistoryItem>[];
    for (final raw in jsonList) {
      try {
        final decoded = json.decode(raw);
        if (decoded is Map<String, dynamic>) {
          loadedItems.add(HistoryItem.fromJson(decoded));
        }
      } catch (_) {
        // 忽略异常数据
      }
    }

    state = state.copyWith(items: loadedItems);
  }

  /// 保存当前列表至持久化存储
  Future<void> _saveToStorage(List<HistoryItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = items.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList(AppConstants.prefsHistoryKey, rawList);
  }

  /// 新增一条历史记录
  Future<void> addRecord({
    required ToolType toolType,
    required String actionName,
    required String input,
    required String output,
  }) async {
    final inputTrim = input.trim();
    final inputSummary =
        inputTrim.length > 50 ? '${inputTrim.substring(0, 50)}...' : inputTrim;

    final newItem = HistoryItem(
      id: 'record-${DateTime.now().millisecondsSinceEpoch}',
      toolType: toolType,
      actionName: actionName,
      inputSummary: inputSummary,
      outputContent: output,
      timestamp: DateTime.now(),
    );

    final updated = [newItem, ...state.items];
    state = state.copyWith(items: updated);
    await _saveToStorage(updated);
  }

  /// 删除指定单条记录
  Future<void> deleteItem(String id) async {
    final updated = state.items.where((e) => e.id != id).toList();
    state = state.copyWith(items: updated);
    await _saveToStorage(updated);
  }

  /// 清空全部历史
  Future<void> clearAll() async {
    state = state.copyWith(items: const []);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.prefsHistoryKey);
  }
}

/// 全局历史状态提供者
final historyProvider = StateNotifierProvider<HistoryNotifier, HistoryState>(
  (ref) => HistoryNotifier(),
);
