/// MultiPlatformApp 冒烟与组件交互单元测试
///
/// @author Ateng
/// @since 2026-09-22
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_multiplatform_demo/main.dart';

void main() {
  testWidgets('计数器自增功能冒烟测试', (WidgetTester tester) async {
    // 1. 构建主组件树并触发一帧渲染
    await tester.pumpWidget(const MultiPlatformApp());

    // 2. 验证初始状态下计数为 0，且不存在 1
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // 3. 点击递增悬浮按钮并重新调度渲染
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    // 4. 验证计数器数值已变为 1
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
