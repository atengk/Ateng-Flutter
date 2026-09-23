# 项目 Agent 协同与开发规范 (AGENTS.md)

本项目为基于 **Dart & Flutter** 构建的企业级跨平台应用，并集成 **GitHub Actions** 全平台自动化构建、测试、打包与 GitHub Releases 制品分发流水线。
UI/UX 视觉与交互规范严格以根目录 [DESIGN.md](DESIGN.md) 为最高设计宪章。
所有参与本项目的 Agent 与开发者必须严格遵循以下架构设计准则、编码规范、设计系统契约与交付流程。

---

## 1. 核心交互与上下文指针 (Context Pointers & Comments)

### 1.1 核心规范指针 (Normative Pointers)
- **UI/UX 设计决策分支**：凡涉及页面开发、组件样式、颜色/字体提取、多端响应式断点时，前置加载并严格遵循 [DESIGN.md](DESIGN.md)。
- **流水线发布分支**：凡涉及 CI 质量门禁检查、跨端打包构建脚本、制品发布配置时，前置加载并遵循 [`.github/workflows/pipeline.yml`](.github/workflows/pipeline.yml)。

### 1.2 语言与代码注释规范
- **统一语言**：对话、方案说明、代码注释、Git 提交与各类交付物统一使用清晰中文。
- **文件与类级标准注释**：
  - 新建 Dart 源码或脚本时，顶部必须添加标准文档注释，随后紧跟 `library;` 指令（防范 Dart 3+ `dangling_library_doc_comments`）：
    ```dart
    /// 核心业务或技术职责的一句话精准说明
    ///
    /// @author Ateng
    /// @since 2026-09-23
    library;
    ```
- **公共 API 与参数契约**：对外开放的 Widget 类、公共 Service 方法、领域模型字段必须提供完整文档注释，清晰说明业务意图与边界约束（空值行为、取值范围、异常类型）；标准 `@override` 与私有自解释方法免除冗余注释。
- **跨平台渲染与符号防御**：
  - **Mermaid 流程图词法防御**：所有包含括号 `(` `)`、斜杠 `/`、星号 `*` 等非纯字母字符的连接线文本，**强制使用双引号包裹**：`-->|"..."|`，防止解析器将括号误判为节点形状起始符；节点 ID 与子图 ID 必须严格隔离，严禁重名冲突。
  - **跨平台通用 Emoji 选型**：优先选用全平台（Windows/macOS/Linux/Android/iOS）100% 具备字模回退支持的通用 Unicode 6.0/7.0 字符（如使用 `💻` 表示 PC，避免新版高位字符导致部分系统降级为豆腐块 `▯`）。

---

## 2. 架构模式与目录分层 (Feature-First Architecture)

项目采用 **Feature-First（特性驱动）** 模块化分层架构，强制保障依赖单向流动：`presentation -> domain <- data`。

```
lib/
├── core/                           # 全局公共基座与基础设施
│   ├── constants/                  # 全局常量、应用配置
│   ├── network/                    # 网络客户端、拦截器、统一异常封装
│   ├── router/                     # 全局声明式路由配置 (go_router)
│   ├── theme/                      # 全局主题、色彩令牌、排版样式
│   ├── utils/                      # 通用工具函数、扩展方法 (Extensions)
│   └── widgets/                    # 全局高复用原子组件
├── features/                       # 业务功能特性模块
│   └── <feature_name>/             # 具体业务模块 (如 toolbox, settings)
│       ├── presentation/           # 展示层：UI 界面、局部微组件与状态控制器
│       │   ├── screens/            # 完整页面
│       │   ├── widgets/            # 当前特性专属拆分组件
│       │   └── providers/          # 状态管理器 (Riverpod Notifier)
│       ├── domain/                 # 领域层：纯 Dart 业务模型与抽象契约 (严禁引入 Flutter UI 依赖)
│       │   ├── models/             # 领域实体 (Entities / Value Objects)
│       │   └── repositories/       # 仓储接口定义
│       └── data/                   # 数据层：数据源交互与仓储具体实现
│           ├── datasources/        # 本地存储 (Hive/Isar) 或远程 API 客户端
│           ├── dtos/               # 数据传输对象与序列化
│           └── repositories/       # 仓储接口的具体实现类
└── main.dart                       # 应用启动入口与全局环境初始化
```

- **纯净领域层**：`domain/` 目录严禁导入 `package:flutter/...`，保持 100% 纯 Dart 逻辑以保证极致单元测试纯度。

---

## 3. 状态管理与路由规范 (State & Routing)

- **状态管理核心 (`flutter_riverpod`)**：
  - **单一不可变数据源**：业务状态统一首选不可变模型（Immutable State），变更仅通过单向事件触发状态生成。
  - **副作用严密隔离**：Widget 的 `build()` 方法内严禁执行异步请求或状态突变；所有副作用必须由 Notifier 显式方法或用户交互手势触发。
  - **局部视觉状态轻量化**：输入焦点、手风琴折叠、单选微状态优先使用原生 `StatefulWidget` 或 `ValueNotifier`，避免全局状态树过度膨胀。
  - **无状态公共服务**：公共 Service 类必须保持无状态（Stateless），业务共享数据交由受管 Provider 维护，严禁通过静态变量共享可变业务状态。
- **声明式路由 (`go_router`)**：
  - 路由跳转统一采用声明式路由 `go_router` 驱动，开箱适配 Web 端 URL 同步与深度链接（Deep Linking）。
  - 桌面端与平板端优先使用 `ShellRoute` 承载常驻侧边导航与内容区域自适应双窗格分栏。

---

## 4. 组件拆分与渲染性能底线 (Widget Hygiene & Performance)

- **独立 Widget 抽取**：
  - 强制将可复用或具有独立语义的代码块提取为独立的 `StatelessWidget` 或 `StatefulWidget` 类，实现 Element 树局部重用与重绘边界（Repaint Boundary）隔离；
  - 严禁在类中使用 `Widget _buildHeader()` 或 `Widget _buildItem()` 等私有辅助方法分割长页面。
- **强制 `const` 构造**：所有无动态依赖的组件、`EdgeInsets`、`TextStyle`、`BorderRadius` 必须显式添加 `const` 关键字。
- **复杂度与行数上限**：
  - 单个 Widget 的 `build()` 方法严禁超过 **80 行**；嵌套层级过深时必须立即下沉为子 Widget；
  - 单个 Dart 源码文件建议控制在 **250 行以内**，超出时按职责拆分独立文件。
- **按需懒加载复用**：针对超过 10 项或动态长度的集合数据，强制使用 `ListView.builder`、`GridView.builder` 或 `CustomScrollView + SliverList`，严禁使用 `SingleChildScrollView + Column` 渲染全量长列表。

---

## 5. 空安全与生命周期防御契约 (Null Safety & Lifecycle)

- **集合非空约定**：数据查询或列表转换无匹配结果时，**统一返回空集合（`const []`、`const {}`），严禁返回 `null`**。
- **安全模式解包**：优先使用空合并运算符 `??` 或 Dart 3 模式匹配（`if (value case final data?) { ... }`），严禁未经前置判空防御的盲目强解包（`!`）。
- **异步上下文 `mounted` 防御**：在 `StatefulWidget` 中，凡跨越 `await` 异步回调之后执行 `setState()`、访问 `context` 或操作 `Navigator` 前，必须前置防御卫语句：
  ```dart
  final result = await fetchRemoteData();
  if (!mounted) return;
  setState(() {
    _data = result;
  });
  ```
- **资源闭环安全释放**：所有包含控制器或流监听的组件，必须在其 `dispose()` 中彻底关闭释放并调用 `super.dispose()`（涵盖 `TextEditingController`、`ScrollController`、`AnimationController`、`StreamSubscription`、`Timer`）。

---

## 6. 设计系统宪章与视觉契约 (DESIGN.md Guard)

所有涉及 UI/UX 界面开发与重构，必须将根目录 [DESIGN.md](DESIGN.md) 作为前置设计约束与第一门禁：

- **默认现代极客白 (Modern Clean Light Studio)**：
  - 应用默认构建与初次加载必须强制为 **明亮模式 (`ThemeMode.light`)**；
  - 界面基底采用冷灰白阶梯（Canvas `#F8FAFC` 与 SurfaceBase `#FFFFFF`），彻底杜绝大面积粗暴死黑与廉价 AI 渐变塑料感。
- **语义化设计令牌**：
  - 严禁在页面或组件中硬编码十六进制颜色或绝对像素字号；
  - 颜色统一通过 `Theme.of(context).colorScheme` 或受管主题令牌动态派生；
  - 字体样式统一通过 `Theme.of(context).textTheme` 派生。
- **8px 原子间距网格标尺**：
  - 严禁魔数边距：所有 Padding、Margin、SizedBox 尺寸必须严格从 8px 律动阶梯取值：`[4, 8, 12, 16, 24, 32, 48]`。
- **弹性自适应导航与截断绝缘**：
  - 所有分段导航（`SegmentedButton`）、标签栏与卡片必须采用基于内容自然撑开的弹性宽度（Intrinsic Width）；
  - 屏幕受限时配备横向平滑滚动或图标折叠降级，**绝对严禁出现核心文字被省略号截断（如“JSON 格...”、“时间戳工...”）的残缺排版**。
- **多端字体栈与排版四大红线**：
  - **跨平台字体栈**：按顺序回退高质量字型（macOS/iOS: PingFang SC, Windows: 微软雅黑, Android/Linux: Noto Sans SC）；
  - **防剪裁 StrutStyle**：固定高度容器（胶囊、Tab、Badge、紧凑按钮）必须配置 `StrutStyle(forceStrutHeight: true, height: 1.3, leading: 0.1)` 并开启 `TextLeadingDistribution.even`，杜绝中文笔画削切；
  - **红线 1 - 绝对禁止负字间距**：汉字方块字严禁 `letterSpacing < 0`，正文固定为 `0`，大标题允许微正向 `0.2`；
  - **红线 2 - 字重克制**：中文标题字重上限严格控制在 `FontWeight.w600`，杜绝超粗黑体（w800/w900）导致汉字笔画粘连成团；
  - **红线 3 - 舒适呼吸感行高**：正文字体行高必须维持充裕（`height >= 1.5`）；
  - **红线 4 - 数字与代码绝对等宽**：时间戳数值、哈希串、代码必须显式指定等宽字体栈（`JetBrains Mono, Menlo, Consolas`）。
- **微动效与无障碍降级**：
  - 标准微动效时长为 `150ms ~ 250ms`，缓动统一采用 `Curves.easeOutCubic`；
  - 当系统开启减弱动态效果（`MediaQuery.disableAnimationsOf(context) == true`）时，所有位移/缩放动效必须优雅降级为纯瞬时切换或纯透明度微变。
- **三级全平台响应式断点与导航形态**：
  - **移动端（Mobile）**：`< 600px`，常驻侧栏隐入底部沉浸浮动 Dock 或抽屉，单列纵向全屏流式布局，触控组件最小热区 $\ge 44dp$；
  - **平板端（Tablet）**：`600px ~ 1024px`，侧栏自适应折叠为 `64dp` 紧凑图标浮岛轨（Slim Icon Rail），顶部 Tab 开启平滑横向滚动，双窗格纵向堆叠；
  - **桌面端（Desktop）**：`> 1024px`，`224dp` 极简浮岛侧栏（浅青蓝柔底与右侧状态点），主视窗 `1440px` 居中黄金留白，双窗格左右并列并标配独立行号槽轨。

---

## 7. 静态分析与质量完成门禁 (Completion Criteria & Analyzer)

所有代码提交必须 100% 通过以下可机检验证条件（Checkable Criteria）：

- **强类型与静态分析门禁**：
  - 语言严格模式已在 `analysis_options.yaml` 中开启（`strict-casts`, `strict-inference`, `strict-raw-types`）；
  - 运行 `flutter analyze` 必须为 **0 errors, 0 warnings**。
- **强制尾随逗号 (Trailing Commas)**：在所有多行参数签名、组件构造调用、集合字面量末尾强制保留逗号 `,`，保障代码差异行最小化。
- **代码提交前格式化零变更校验**：
  - 本地执行格式化：`dart format .`；
  - 格式化门禁验证：`dart format --output=none --set-exit-if-changed .`，退出码必须为 **0**。
- **设计系统遵从度自检**：
  - 检查代码是否存在十六进制裸色值；
  - 检查 Padding/SizedBox 是否违背 8px 网格阶梯；
  - 检查中文 TextStyle 是否出现负字间距或缺失等宽字体绑定。

---

## 8. CI/CD 流水线架构守则 (`pipeline.yml`)

- **单一高内聚流水线**：所有 CI（质量门禁）与 CD（全平台发布）统一维护在 [`.github/workflows/pipeline.yml`](.github/workflows/pipeline.yml) 中，严禁随意拆分成互斥或并行的碎片流水线。
- **并发控制与自动取消**：必须配置 `concurrency: cancel-in-progress: true`，防止多任务堆叠。
- **动态工程缓存防御 (Dynamic Project Cache Guard)**：
  - 针对在 CI 运行时通过 `flutter create` 动态生成宿主工程的项目，**严禁在 `actions/setup-java` 中配置 `cache: 'gradle'`**（因工程生成前缺少 Gradle 描述文件会导致哈希键计算异常终止流水线）。
- **两阶段门禁**：
  1. **日常提交 / PR**：仅运行 `Lint & Test`（快速测试代码格式、静态分析与单元测试）。
  2. **发布触发**：必须先 100% 通过质量门禁，且仅在推送版本标签（`v*`）或手动 `workflow_dispatch` 时，才允许并行拉起全平台耗时打包构建。
- **全平台构建矩阵**：
  - **Windows**：输出 `.exe` (Inno Setup 简体中文向导) 与 `.zip` 便携包；
  - **macOS**：输出 `.dmg` (原生挂载拖拽镜像) 与 `.zip` 便携包；
  - **iOS**：输出 `.ipa` (未签名标准测试包)；
  - **Android**：输出 Universal Fat APK (内置全芯片原生库)；
  - **HarmonyOS NEXT**：输出 `.hap` (纯血鸿蒙/OpenHarmony 标准测试安装包)；
  - **Web**：输出静态部署整包 `.zip`；
  - **Linux**：兼顾 `x86_64` 与 `arm64`，双架构各自产出 `.deb`、`.rpm` 与保留 `0755` 权限的 `.tar.gz`。
- **完整性校验**：所有正式发布必须自动计算并生成 `checksums.txt` (SHA-256 哈希散列)。

---

## 9. Git 提交与版本管理规范

- **规范化提交 (Conventional Commits)**：
  - 格式：`<type>(<scope>): <中文描述>`；
  - 常用类型：`feat`（新特性）、`fix`（修复缺陷）、`refactor`（代码重构）、`docs`（文档更新）、`ci`（流水线修改）、`style`（格式调整）；
  - 保持单次提交的原子性，严禁功能与格式杂糅。
- **版本发布标签**：发布版本时统一采用 `vX.Y.Z` 语义化标签格式（如 `v1.0.5`）。
