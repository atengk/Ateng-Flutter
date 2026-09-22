# Flutter 跨平台演示与 GitHub Actions CI/CD 自动打包发布

本项目是一个使用 **Flutter & Dart** 构建的跨平台 Demo 应用，集成了 **GitHub Actions** 多平台自动化构建工作流，实现代码推送时自动化测试检测，以及发布版本标签（Tag）时全自动编译打包并发布至 GitHub Releases。

## 平台支持矩阵与制品清单

| 平台 | 构建产物 | 格式 | 说明 |
| :--- | :--- | :--- | :--- |
| **Android** | `app-release.apk` | `.apk` | Android 安装包 (Release 模式) |
| **Web** | `web-release.zip` | `.zip` | 包含静态 HTML/JS/Wasm 资源的网站压缩包 |
| **Windows** | `windows-release.zip` | `.zip` | Windows 桌面可执行程序及依赖库压缩包 |
| **Linux** | `linux-release.zip` | `.zip` | Linux 桌面可执行程序及依赖压缩包 |
| **macOS** | `flutter-multiplatform-demo-macos.zip` | `.zip` | macOS 桌面 App Bundle 独立运行包 |

---

## 自动化流水线 (`pipeline.yml`)

项目采用统一的高内聚 CI/CD 流水线，并配置并发防抖机制（`cancel-in-progress: true`），彻底消除重复运行与无效资源消耗。

### 1. 质量门禁阶段 (Lint & Test)
- **触发条件**：向 `master` / `main` 分支提交代码、创建 Pull Request，或推送版本标签。
- **阶段动作**：
  1. 代码格式检查 (`dart format`)
  2. 静态分析 (`flutter analyze`)
  3. 单元测试 (`flutter test`)

### 2. 多平台自动打包与发布阶段 (Build & Release)
- **触发条件**：仅在**推送版本标签**（如 `v1.0.3`）或手动触发 (`workflow_dispatch`) 且**门禁测试全部通过**后执行。
- **阶段动作**：
  1. 并行启动五大平台构建矩阵（Android、Web、Windows、Linux、macOS）。
  2. 自动补充平台原生骨架并完成生产打包与制品压缩。
  3. 最终汇总五大平台产物，自动创建 GitHub Release 并上传所有二进制制品。

---

## 本地运行指南 (可选)

如本地已安装 Flutter SDK：

```bash
# 获取依赖
flutter pub get

# 运行测试
flutter test

# 启动运行
flutter run
```
