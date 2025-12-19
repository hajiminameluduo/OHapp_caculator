# OpenHarmony Calculator (ArkTS)

![OpenHarmony](https://img.shields.io/badge/OpenHarmony-API%2012-blue) ![Language](https://img.shields.io/badge/Language-ArkTS-green) ![License](https://img.shields.io/badge/License-Apache%202.0-lightgrey)

一个基于 OpenHarmony API 12 (HarmonyOS NEXT) 开发的现代化计算器应用。采用 ArkTS 声明式 UI 开发，支持基础四则运算及计算过程显示。

A modern Calculator app built with OpenHarmony API 12 (HarmonyOS NEXT). Developed using ArkTS declarative UI, featuring basic arithmetic operations and calculation process display.

> **Note**: This project is designed for OpenHarmony / HarmonyOS NEXT.

## 📱 预览 / Preview

<!-- 请将你的应用截图放在项目根目录，命名为 screenshot.png，或者修改下面的路径 -->
<!-- Please place your screenshot in the root directory named 'screenshot.png' or update the path below -->
<div align="center">
  <img src="./screenshot.png" width="300" alt="App Screenshot" />
</div>

## ✨ 特性 / Features

*   **声明式 UI (ArkUI)**: 使用 `Grid` 和 `Column` 构建响应式布局。
*   **实时计算过程**: 在结果上方显示完整的计算公式（如 `12 + 5 =`），防止误触。
*   **基础运算**: 支持加、减、乘、除及小数点运算。
*   **逻辑优化**: 包含防除零错误、连续运算处理、智能删除 (DEL) 逻辑。
*   **沉浸式设计**: 区分功能键与数字键的色彩体系。

*   **Declarative UI (ArkUI)**: Responsive layout built with `Grid` and `Column`.
*   **Process Display**: Shows the calculation history (e.g., `12 + 5 =`) above the result to ensure accuracy.
*   **Basic Arithmetic**: Supports addition, subtraction, multiplication, division, and decimals.
*   **Optimized Logic**: Includes divide-by-zero protection, continuous calculation support, and smart delete logic.
*   **Immersive Design**: Distinct color coding for function keys and number keys.

## 🛠️ 技术栈 / Tech Stack

*   **OS**: OpenHarmony / HarmonyOS NEXT
*   **API Version**: API 12 (5.0.0 Release)
*   **Language**: ArkTS (TypeScript extended)
*   **IDE**: DevEco Studio 5.0+

## 🚀 快速开始 / Getting Started

### 环境要求 / Prerequisites

1.  安装 [DevEco Studio](https://developer.huawei.com/consumer/cn/deveco-studio/) 5.0 或更高版本。
2.  配置 OpenHarmony SDK (API 12)。

### 安装步骤 / Installation

1.  克隆仓库 / Clone the repository:
    ```bash
    git clone https://github.com/YourUsername/OpenHarmony-Calculator.git
    ```
2.  使用 DevEco Studio 打开项目目录。
3.  等待 Sync 完成（自动下载依赖）。
4.  连接真机或模拟器。
5.  配置签名 (File -> Project Structure -> Signing Configs -> Automatically generate signature)。
6.  点击 **Run** 运行。

## 📂 项目结构 / Project Structure

```text
entry/src/main
├── ets
│   ├── entryability
│   │   └── EntryAbility.ets    // 应用入口 / App Entry
│   └── pages
│       └── Index.ets           // 计算器核心逻辑与UI / Calculator Logic & UI
├── resources
│   ├── base
│   │   ├── element             // 字符串、颜色配置 / Strings & Colors
│   │   └── media               // 图标资源 / Icons
│   └── zh_CN                   // 中文国际化适配 / Chinese Localization
└── module.json5                // 模块配置文件 / Module Config
