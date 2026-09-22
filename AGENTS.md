# 项目 Agent 协同与开发规范 (AGENTS.md)

本项目为基于 **Dart & Flutter** 构建的跨平台应用，并集成 **GitHub Actions** 全平台自动化构建、测试、打包与 GitHub Releases 制品分发流水线。

---

## 1. 交互与代码注释规范

- **统一语言**：对话、方案说明、代码注释与提交信息统一使用清晰中文。
- **文件与类级注释**：
  - 新建 Dart 源码或脚本时，顶部必须添加标准文档注释。
  - 核心要素：一句话职责说明、`@author Ateng`、系统真实日期 `@since 2026-09-22`。
  - 在 Dart 3+ 中，文件顶部文档注释后必须紧跟 `library;` 指令，防止静态分析器报告 `dangling_library_doc_comments`。
- **代码质量与空安全**：
  - 集合查询无结果时统一返回空集合，严禁返回 `null`。
  - 严格防御空指针，状态生命周期安全释放。
  - 遵循 Material 3 设计范式与响应式布局。

---

## 2. CI/CD 流水线架构守则 (`pipeline.yml`)

- **单一高内聚流水线**：所有 CI（质量门禁）与 CD（全平台发布）统一维护在 [`.github/workflows/pipeline.yml`](file:///c:/Users/kongyu/Documents/antigravity/noble-babbage/.github/workflows/pipeline.yml) 中，严禁随意拆分成互斥或并行的碎片流水线。
- **并发控制与自动取消**：必须配置 `concurrency: cancel-in-progress: true`，防止多任务堆叠。
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

## 3. Git 提交与版本管理规范

- **规范化提交**：遵循 Conventional Commits 规范，格式为 `<type>(<scope>): <中文描述>`。
- **版本发布标签**：发布版本时统一采用 `vX.Y.Z` 语义化标签格式（如 `v1.0.5`）。
