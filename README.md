# Flutter 跨平台演示与 GitHub Actions 全平台自动化打包发布

[![CI/CD Pipeline](https://github.com/atengk/flutter-multiplatform-demo/actions/workflows/pipeline.yml/badge.svg)](https://github.com/atengk/flutter-multiplatform-demo/actions/workflows/pipeline.yml)
[![GitHub Release](https://img.shields.io/github/v/release/atengk/flutter-multiplatform-demo?logo=github&color=blue)](https://github.com/atengk/flutter-multiplatform-demo/releases)
[![Flutter Version](https://img.shields.io/badge/Flutter-3.x%20Stable-02569B?logo=flutter)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

本项目是一个基于 **Flutter & Dart** 构建的工业级跨平台演示工程，深度融合 **GitHub Actions** 全平台自动化 CI/CD 流水线，实现日常提交快速质量门禁，以及版本标签推送时**全自动多平台编译、标准向导安装包封装、校验哈希生成与 GitHub Releases 制品分发**。

---

## 平台支持矩阵与制品清单 (全架构覆盖)

流水线采用工业级标准命名规范（`[应用名]_[版本号]_[平台]_[架构].[扩展名]`），单次发版全自动产出 **13 个标准制品**：

| 操作系统 / 生态 | 架构 | 规范化安装包 / 制品文件名 | 格式 | 遵循标准与特性说明 |
| :--- | :--- | :--- | :---: | :--- |
| 🪟 **Windows** | `x64` | `flutter-multiplatform-demo_1.0.5_windows_x64_setup.exe`<br>`flutter-multiplatform-demo_1.0.5_windows_x64_portable.zip` | `.exe`<br>`.zip` | **Inno Setup 原生简体中文安装向导** (含开始菜单、桌面图标与卸载器)<br>免安装便携绿色包 (支持 Win11 ARM 转译运行) |
| 🍎 **macOS** | Universal | `flutter-multiplatform-demo_1.0.5_macos_universal.dmg`<br>`flutter-multiplatform-demo_1.0.5_macos_universal.zip` | `.dmg`<br>`.zip` | **标准挂载磁盘安装镜像** (含拖拽至 Applications 原生安装)<br>通用双架构 App Bundle 绿色包 (M 芯片与 Intel 原生即开) |
| 📱 **iOS** | `arm64` | `flutter-multiplatform-demo_1.0.5_ios_arm64.ipa` | `.ipa` | 标准未签名测试安装包 (支持 TrollStore / AltStore / 企业自签) |
| 🤖 **Android** | Universal | `flutter-multiplatform-demo_1.0.5_android_universal.apk` | `.apk` | 生产环境 Release APK 胖包 (内置 ARMv7/ARM64/x86 全部原生库) |
| 🌐 **Web** | Web | `flutter-multiplatform-demo_1.0.5_web.zip` | `.zip` | 包含静态 HTML/JS/Wasm 资源的网站整包 (可直接部署至 Pages/Nginx) |
| 🐧 **Linux (传统 PC/服务器)** | `x86_64` | `flutter-multiplatform-demo_1.0.5_linux_amd64.deb`<br>`flutter-multiplatform-demo-1.0.5-1.x86_64.rpm`<br>`flutter-multiplatform-demo_1.0.5_linux_x86_64_portable.tar.gz` | `.deb`<br>`.rpm`<br>`.tar.gz` | 遵循 **Debian 官方规范** (`_amd64.deb`)，适配 Ubuntu/Debian/Deepin<br>遵循 **RedHat 官方规范** (`-1.x86_64.rpm`)，适配 RHEL/CentOS/Fedora<br>便携运行包 (保留 `0755` 权限) |
| 🐉 **Linux (国产信创/树莓派)** | `arm64` | `flutter-multiplatform-demo_1.0.5_linux_arm64.deb`<br>`flutter-multiplatform-demo-1.0.5-1.aarch64.rpm`<br>`flutter-multiplatform-demo_1.0.5_linux_arm64_portable.tar.gz` | `.deb`<br>`.rpm`<br>`.tar.gz` | 专为**统信 UOS / 银河麒麟** ARM64 信创桌面设计的标准安装包<br>专为 **openEuler / RedHat ARM** 信创服务器设计的 RPM 安装包<br>树莓派/单板机运行包 |

---

## 自动化流水线架构 (`pipeline.yml`)

项目已全面重构为单一高内聚流水线，包含并发防抖、文档提交过滤、Gradle 缓存加速与全自动哈希校验。

```mermaid
flowchart TD
    Trigger["触发事件<br/>• 代码推送到 main<br/>• 创建 Pull Request<br/>• 推送版本标签 (v*)<br/>• 手动触发 (workflow_dispatch)"]

    Trigger --> Filter{"过滤检查<br/>(paths-ignore)"}
    Filter -->|文档类修改 (*.md / docs)| Silent["跳过执行 (节约算力)"]
    Filter -->|代码与配置变更| Gate["阶段 1：全局质量门禁 (Lint & Test)<br/>代码格式化 + 静态分析 + 单元测试 (约 40s)"]

    Gate -->|门禁失败| Stop["立即中断 (阻断后续构建)"]
    Gate -->|普通提交通过| Done["CI 正常完成 (绿色通过)"]
    Gate -->|Tag / 手动触发通过| Meta["阶段 1.5：版本号解析 (resolve-meta)"]

    Meta --> Matrix["阶段 2：全平台与多架构并行打包矩阵"]

    subgraph Matrix["7 大并行打包任务"]
        Win["Windows (windows-latest)<br/>• 绿色 ZIP<br/>• Inno Setup 中文安装包"]
        Mac["macOS (macos-latest)<br/>• 便携 ZIP<br/>• 原生 DMG 磁盘镜像"]
        iOS["iOS (macos-latest)<br/>• 未签名 Payload IPA"]
        And["Android (ubuntu-latest)<br/>• Gradle 依赖缓存加速<br/>• Universal Fat APK"]
        Web["Web (ubuntu-latest)<br/>• HTML5 / Wasm 资源包"]
        Lx64["Linux x86_64 (ubuntu-latest)<br/>• DEB + RPM + TAR.GZ"]
        Larm["Linux ARM64 (ubuntu-24.04-arm 物理机)<br/>• 统信/麒麟 DEB + openEuler RPM"]
    end

    Matrix --> Publish["阶段 3：汇总与发布 (Publish GitHub Release)"]
    Publish --> Checksum["生成 SHA-256 校验清单 (checksums.txt)"]
    Publish --> ReleaseBody["动态生成 Markdown 结构化下载指南"]
    Checksum --> FinalRelease["GitHub Releases 正式发布"]
    ReleaseBody --> FinalRelease
```

---

## 产物完整性校验 (SHA-256 Checksums)

每个 Release 发行版均附带 `checksums.txt`，供用户核对下载文件的完整性与真实性：

- **Linux / macOS 终端**：
  ```bash
  sha256sum -c checksums.txt
  ```
- **Windows PowerShell**：
  ```powershell
  Get-FileHash <文件名> -Algorithm SHA256
  ```

---

## 本地开发与运行指南

如本地已安装 Flutter SDK (3.x+)：

```bash
# 1. 获取依赖
flutter pub get

# 2. 代码格式化检查与静态分析
dart format --output=none --set-exit-if-changed .
flutter analyze

# 3. 运行单元与 Widget 冒烟测试
flutter test

# 4. 本地启动运行 (自动检测目标设备)
flutter run
```

---

## 规范指引
项目专有 AI Agent 协同与开发规范详见 [AGENTS.md](AGENTS.md)。
