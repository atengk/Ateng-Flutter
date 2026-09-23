/// DevToolbox 应用冒烟与核心组件渲染单元测试
///
/// @author Ateng
/// @since 2026-09-22
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ateng_flutter/core/constants/app_constants.dart';
import 'package:ateng_flutter/main.dart';

void main() {
  testWidgets('DevToolbox 应用启动与主导航冒烟测试', (WidgetTester tester) async {
    // 0. 设置标准桌面测试视窗尺寸 (1280x800) 确保覆盖桌面极简浮岛外壳
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    // 1. 构建主组件树并挂载 ProviderScope
    await tester.pumpWidget(
      const ProviderScope(
        child: DevToolboxApp(),
      ),
    );
    await tester.pumpAndSettle();

    // 2. 验证顶部应用标题与版本标签正常渲染
    expect(find.text(AppConstants.appTitle), findsOneWidget);
    expect(find.text(AppConstants.appVersion), findsOneWidget);

    // 3. 验证微工具工坊默认渲染与 JSON 格式化按钮
    expect(find.text('微工具工坊'), findsWidgets);
    expect(find.text('TOOLBOX STUDIO'), findsOneWidget);
    expect(find.text('美化格式化'), findsOneWidget);

    // 4. 切换到操作看板 Tab
    final historyTab = find.text('操作看板');
    expect(historyTab, findsWidgets);
    await tester.tap(historyTab.first);
    await tester.pumpAndSettle();

    // 5. 验证操作看板成功激活
    expect(find.text('操作历史与统计 (Activity & History)'), findsOneWidget);
  });
}
