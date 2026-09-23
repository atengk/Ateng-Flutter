/// DevToolbox 应用冒烟与核心组件渲染单元测试
///
/// @author Ateng
/// @since 2026-09-22
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ateng_flutter/core/constants/app_constants.dart';
import 'package:ateng_flutter/main.dart';

void main() {
  testWidgets('DevToolbox 应用启动与主导航冒烟测试', (WidgetTester tester) async {
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
    expect(find.text('微工具工坊 (Toolbox Studio)'), findsOneWidget);
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
