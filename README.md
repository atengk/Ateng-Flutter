# Flutter 跨平台演示与 GitHub Actions CI/CD 自动打包发布

本项目是一个使用 **Flutter & Dart** 构建的跨平台 Demo 应用，集成了 **GitHub Actions** 多平台自动化构建工作流，实现代码推送时自动化测试检测，以及发布版本标签（Tag）时全自动编译打包并发布至 GitHub Releases。

## 平台支持矩阵与制品清单

| 平台 | 架构 | 制品文件名 | 格式 | 说明 |
| :--- | :--- | :--- | :--- | :--- |
| 🤖 **Android** | Universal | `flutter-multiplatform-demo-android.apk` | `.apk` | 生产 Release APK 安装包 (内置 ARM/x86 全架构) |
| 📱 **iOS** | arm64 | `flutter-multiplatform-demo-ios.ipa` | `.ipa` | 未签名测试安装包 (支持 TrollStore / AltStore / 自签) |
| 🌐 **Web** | - | `flutter-multiplatform-demo-web.zip` | `.zip` | 包含静态 HTML/JS/Wasm 资源的网站压缩包 |
| 🪟 **Windows** | x64 | `flutter-multiplatform-demo-windows-setup.exe`<br>`flutter-multiplatform-demo-windows.zip` | `.exe`<br>`.zip` | **Inno Setup 单文件向导安装包**<br>绿色免安装便携包 |
| 🍎 **macOS** | Universal | `flutter-multiplatform-demo-macos.dmg`<br>`flutter-multiplatform-demo-macos.zip` | `.dmg`<br>`.zip` | **标准挂载磁盘安装镜像 (含 Applications 快捷)**<br>App Bundle 便携包 |
| 🐧 **Linux (x86_64)** | x86_64 | `flutter-multiplatform-demo-linux-x86_64.deb`<br>`flutter-multiplatform-demo-linux-x86_64.rpm`<br>`flutter-multiplatform-demo-linux-x86_64.zip` | `.deb`<br>`.rpm`<br>`.zip` | **Debian/Ubuntu/Deepin 标准安装包**<br>**RedHat/Fedora/CentOS 标准安装包**<br>独立运行绿色包 |
| 🐉 **Linux (ARM64)** | arm64 | `flutter-multiplatform-demo-linux-arm64.deb`<br>`flutter-multiplatform-demo-linux-arm64.rpm`<br>`flutter-multiplatform-demo-linux-arm64.zip` | `.deb`<br>`.rpm`<br>`.zip` | **统信 UOS / 银河麒麟信创标准包**<br>**openEuler / RedHat 信创标准包**<br>树莓派/ARM64 独立运行包 |

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
