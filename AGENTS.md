# 项目 Agent 协同与开发规范 (AGENTS.md)

本项目为基于 **Dart & Flutter** 构建的企业级跨平台应用，并集成 **GitHub Actions** 全平台自动化构建、测试、打包与 GitHub Releases 制品分发流水线。
所有参与本项目的 Agent 与开发者必须严格遵循以下架构设计准则、编码规范与交付流程。

---

## 1. 交互与代码注释规范 (Universal & Comments)

- **统一语言**：对话、方案说明、代码注释、Git 提交与各类交付物统一使用清晰中文。
- **文件与类级标准注释**：
  - 新建 Dart 源码或脚本时，顶部必须添加标准文档注释。
  - 核心要素（独立分行，严禁同行合并）：
    1. **职责说明**：一句话精准概述核心业务或技术职责。
    2. **作者**：固定为 `@author Ateng`。
    3. **日期**：当天真实系统日期，格式为 `@since YYYY-MM-DD`（如 `@since 2026-09-22`）。
  - **Dart 3+ 语法要求**：文件顶部文档注释后必须紧跟 `library;` 指令，防止静态分析器报告 `dangling_library_doc_comments`。
- **公共 API 与参数契约注释**：
  - 对外开放的 Widget 类、公共 Service 方法、领域模型字段必须提供完整文档注释。
  - 聚焦说明业务含义、边界约束（空值行为、参数取值范围、异常说明）。
  - 自解释的私有小方法、标准 `@override` 方法免除冗余注释。
- **文档渲染与跨平台符号安全 (Markdown & Emoji Safeguards)**：
  - **Mermaid 流程图词法防御**：Markdown 架构与流程图中，所有包含括号 `(` `)`、斜杠 `/`、星号 `*` 等非纯字符的连接线文本，**强制使用双引号包裹**：`-->|"..."|`，防止 GitHub 等解析器将括号误判为节点形状起始符引发解析崩溃；节点 ID 与子图（`subgraph`）ID 必须严格隔离，严禁重名冲突。
  - **跨平台通用 Emoji 选型**：文档、支持矩阵表格与状态展示中的图标，必须优先选用全平台（Windows/macOS/Linux/Android/iOS）100% 具备字模回退支持的通用 Unicode 6.0/7.0 字符（如使用 `💻` 表示 Windows/PC，严禁使用新版高位字符如 `🪟` 导致客户端降级显示为“豆腐块”未识别方块 `▯`）。

---

## 2. 架构模式与目录分层 (Feature-First Architecture)

项目采用 **Feature-First（特性驱动）** 模块化架构，实现高内聚、低耦合与高可测试性：

```
lib/
├── core/                           # 全局公共基座与基础设施
│   ├── constants/                  # 全局常量、应用配置
│   ├── network/                    # 网络请求客户端、拦截器、统一异常封装
│   ├── router/                     # 全局路由配置 (go_router)
│   ├── theme/                      # 全局主题、色彩令牌、排版样式
│   ├── utils/                      # 通用工具函数、扩展方法 (Extensions)
│   └── widgets/                    # 全局高复用基础组件 (如通用按钮、空状态图)
├── features/                       # 业务功能特性模块
│   └── <feature_name>/             # 具体业务模块 (如 counter, profile, settings)
│       ├── presentation/           # 展示层：UI 界面、局部组件与状态控制器
│       │   ├── screens/            # 完整页面
│       │   ├── widgets/            # 当前特性独享的细粒度拆分组件
│       │   └── providers/          # 状态管理器 (Riverpod StateNotifier / Notifier)
│       ├── domain/                 # 领域层：纯 Dart 业务模型与抽象契约
│       │   ├── models/             # 领域实体 (Entities / Value Objects)
│       │   └── repositories/       # 仓储接口定义 (不包含具体数据源实现)
│       └── data/                   # 数据层：数据源交互与仓储实现
│           ├── datasources/        # 本地存储 (Hive/Isar) 或远程 API 客户端
│           ├── dtos/               # 数据传输对象与 JSON 序列化 (Freezed / json_serializable)
│           └── repositories/       # 仓储接口的具体实现类
└── main.dart                       # 应用启动入口与全局环境初始化
```

- **依赖单向流动**：`presentation -> domain <- data`。领域层（`domain`）为纯 Dart 逻辑，**严禁依赖任何 Flutter UI 库**，确保业务逻辑具备纯净的单测能力。

---

## 3. 状态管理与路由规范 (State & Routing)

- **状态管理规范 (`flutter_riverpod`)**：
  - 业务状态统一首选 `flutter_riverpod` 管理，实现不可变状态与编译期类型安全。
  - **单一真实数据源**：状态通过不可变对象（Immutable State）表达，变更通过单向事件触发状态更迭。
  - **副作用隔离**：**严禁在 Widget 的 `build()` 生命周期内发起异步请求或突变状态**，副作用必须由 Notifier 方法或用户交互手势显式触发。
  - **局部 UI 状态轻量化**：对于纯局部视觉状态（如输入框光标焦点、折叠展开动画、单选态），推荐使用原生 `StatefulWidget` 或 `ValueNotifier` + `ValueListenableBuilder`，避免全局状态膨胀。
  - **单例无状态**：公共 Service 必须保持无状态（Stateless），严禁使用全局静态变量共享可变业务数据。
- **跨平台路由规范 (`go_router`)**：
  - 统一采用声明式路由 `go_router` 驱动页面跳转。
  - **Web 与多端适配**：开箱即用支持浏览器 URL 同步、刷新保留状态与深度链接（Deep Linking）。
  - **自适应外壳**：桌面端与大屏设备优先使用 `ShellRoute` 承载常驻侧边导航栏与内容区域分栏。

---

## 4. 组件拆分与渲染性能底线 (Widget Hygiene & Performance)

- **严禁私有方法生成 Widget**：
  - **禁止**在类中使用 `Widget _buildHeader()` 或 `Widget _buildListItem()` 式的私有方法分割长页面。
  - **强制**将可复用或具有独立语义的代码块提取为独立的 `StatelessWidget` 或 `StatefulWidget` 类。这样能确保 Flutter Element 树局部重用，并有效隔离重绘边界（Repaint Boundary）。
- **强制 `const` 构造函数**：
  - 所有不依赖动态运行时状态的 Widget、`EdgeInsets`、`TextStyle`、`BorderRadius` 等必须显式添加 `const`。
  - 静态常量集合与不可变模型优先使用 `const` 构造。
- **复杂度与代码行数门禁**：
  - **`build()` 方法**：单个组件的 `build()` 方法严禁超过 **80 行**；嵌套层级过深时必须立即下沉子 Widget。
  - **单文件规模**：单个 Dart 源码文件行数建议控制在 **250 行以内**，超出必须合理按职责拆分到独立文件中。
- **滚动与长列表懒加载**：
  - 针对超过 10 项或长度动态不确定的列表数据，**严禁使用 `SingleChildScrollView + Column`** 渲染全部子节点。
  - 强制使用 `ListView.builder`、`GridView.builder` 或 `CustomScrollView + SliverList` 实现按需懒加载复用。

---

## 5. 空安全与生命周期防御契约 (Null Safety & Lifecycle)

- **集合非空约定**：
  - 查询、列表转换或数据解析无匹配结果时，**统一返回空集合（如 `const []`、`const {}`），严禁返回 `null`**。
- **严禁盲目 Bang 强解包 (`!`)**：
  - 禁止在未作前置防御的情况下对可空对象使用 `!` 强行断言解包。
  - 优先使用空合并运算符 `??` 提供安全兜底，或使用 Dart 3 模式匹配：`if (value case final data?) { ... }`。
- **异步上下文与 `mounted` 防御**：
  - 在 `StatefulWidget` 中，凡是在任何跨越 `await` 异步回调之后调用 `setState()`、访问 `context` 或操作 `Navigator` 前，**必须先执行前置卫语句防御**：
    ```dart
    final result = await fetchRemoteData();
    if (!mounted) return;
    setState(() {
      _data = result;
    });
    ```
- **资源闭环安全释放**：
  - 凡是包含控制器或订阅监听的组件，必须在其 `dispose()` 方法中彻底关闭释放，并紧跟 `super.dispose()`：
    - `TextEditingController.dispose()`
    - `ScrollController.dispose()`
    - `AnimationController.dispose()`
    - `StreamSubscription.cancel()`
    - `Timer.cancel()`

---

## 6. 主题令牌、中文排版与多端响应式 (Theme & Responsive)

- **语义化主题令牌**：
  - **严禁在页面或组件中硬编码十六进制颜色**（如 `Color(0xFF6200EE)`）或绝对像素字号。
  - 颜色统一通过 `Theme.of(context).colorScheme`（如 `colorScheme.primary`、`colorScheme.surface`、`colorScheme.error`）动态感知亮暗色模式。
  - 字体样式统一通过 `Theme.of(context).textTheme`（如 `textTheme.headlineMedium`、`textTheme.bodyMedium`）派生。
- **前端中文排版与字距红线**：
  - **中文字体保底**：全局主题字体栈显式声明现代高质量中文字体（如 `Noto Sans SC`、`PingFang SC`、`Microsoft YaHei`），防范粗糙系统回退。
  - **舒适呼吸感**：正文字体行高必须维持充裕（`height >= 1.3`）。
  - **严禁负字间距**：针对汉字方块字结构，**严禁对中文标题与正文套用负字间距（`letterSpacing < 0`）**，杜绝汉字笔画粘连发虚。
- **多端响应式断点 (Responsive Breakpoints)**：
  - 禁止在容器或卡片中写死固定窗口宽度，统一使用 `LayoutBuilder` 或全局响应式断点自适应布局：
    - **移动端（Mobile）**：`< 600px`，单列纵向全屏流式布局。
    - **平板端（Tablet）**：`600px ~ 1024px`，自适应网格或双列卡片。
    - **桌面端（Desktop）**：`> 1024px`，常驻侧边栏导航、多栏联动面板与弹窗居中限制最大宽度。

---

## 7. 静态分析与代码格式化契约 (Analyzer & Formatting)

- **最高等级强类型检测 (`analysis_options.yaml`)**：
  - 严格开启语言强类型校验，杜绝任何隐式动态类型推导漏洞：
    ```yaml
    analyzer:
      language:
        strict-casts: true
        strict-inference: true
        strict-raw-types: true
    ```
- **强制尾随逗号 (Trailing Commas)**：
  - 在所有多行函数签名、组件构造函数调用、集合字面量结尾处，**强制添加尾随逗号 `,`**。
  - 保证运行 `dart format` 时自动生成优雅的参数折叠缩进，并将 Git 代码审查的 Diff 变动压制到最小单一变更行。
- **代码提交前本地格式化自检 (Pre-commit Format Guard)**：
  - 在执行 Git Commit 前，**强制在本地运行 `dart format .`** 对齐所有代码缩进；
  - 并在提交前通过 `dart format --output=none --set-exit-if-changed .` 校验退出码必须为 0，彻底杜绝在 CI 云端触发 `Changed ... Error: Process completed with exit code 1` 格式门禁中断。

---

## 8. CI/CD 流水线架构守则 (`pipeline.yml`)

- **单一高内聚流水线**：所有 CI（质量门禁）与 CD（全平台发布）统一维护在 [`.github/workflows/pipeline.yml`](file:///c:/Users/kongyu/Documents/antigravity/noble-babbage/.github/workflows/pipeline.yml) 中，严禁随意拆分成互斥或并行的碎片流水线。
- **并发控制与自动取消**：必须配置 `concurrency: cancel-in-progress: true`，防止多任务堆叠。
- **动态生成工程时的缓存防御 (Dynamic Project Cache Guard)**：
  - 对于未在 Git 仓库中直接提交 `android/` 或桌面平台结构、采用在 CI 运行时动态执行 `flutter create` 生成工程的项目，**严禁在 `actions/setup-java` 中配置 `cache: 'gradle'`**（因工程生成前缺少 Gradle 描述文件会导致哈希键计算异常终止流水线）。
- **两阶段门禁**：
  1. **日常提交 / PR**：仅运行 `Lint & Test`（快速测试代码格式、静态分析与单元测试）。
  2. **发布触发**：必须先 100% 通过质量门禁，且仅在推送版本标签（`v*`）或手动 `workflow_dispatch` 时，才允许并行拉起全平台耗时打包构建。
- **多平台构建矩阵约定**：
  - **Windows**：输出 `.exe` (Inno Setup 简体中文向导) 与 `.zip` 便携包。
  - **macOS**：输出 `.dmg` (原生挂载拖拽镜像) 与 `.zip` 便携包。
  - **iOS**：输出 `.ipa` (未签名标准测试包)。
  - **Android**：输出 Universal Fat APK (内置全芯片原生库)。
  - **Web**：输出静态部署整包 `.zip`。
  - **Linux**：必须兼顾 `x86_64` (PC/服务器) 与 `arm64` (信创/树莓派)，双架构各自产出 `.deb`、`.rpm` 与保留 `0755` 权限的 `.tar.gz`。
- **完整性校验**：所有正式发布必须自动计算并生成 `checksums.txt` (SHA-256 哈希散列)。

---

## 9. Git 提交与版本管理规范

- **规范化提交 (Conventional Commits)**：
  - 格式：`<type>(<scope>): <中文描述>`。
  - 常用类型：`feat`（新特性）、`fix`（修复缺陷）、`refactor`（代码重构）、`docs`（文档更新）、`ci`（流水线修改）、`style`（格式调整）。
  - 保持单次提交的原子性，严禁功能与格式杂糅。
- **版本发布标签**：发布版本时统一采用 `vX.Y.Z` 语义化标签格式（如 `v1.0.5`）。
