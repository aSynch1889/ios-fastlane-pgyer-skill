# iOS Fastlane Pgyer Skill

English | [中文](#中文说明)

A reusable Codex skill for bootstrapping iOS `fastlane` pipelines with Dev/Dis lanes and Pgyer upload.

## Features

- Generates `fastlane/Fastfile`, `fastlane/Appfile`, and `fastlane/Pluginfile`
- Supports both `.xcworkspace` and `.xcodeproj` projects
- Auto-detects key values from your iOS project:
  - workspace/project
  - scheme (prefers project-name scheme)
  - bundle identifiers
  - signing style (`automatic` / `manual`)
  - team id (optional)
- Supports both signing modes:
  - `automatic`: no profile required
  - `manual`: requires profiles; if team id is missing, uses `YOUR_TEAM_ID` placeholder with warning

## Repository Structure

```text
SKILL.md
agents/openai.yaml
assets/fastlane/Fastfile.template
assets/fastlane/Appfile.template
assets/fastlane/Pluginfile.template
scripts/bootstrap_fastlane.sh
```

## Prerequisites

- macOS with Xcode CLI tools
- Ruby/Bundler (for running fastlane)
- `xcodebuild` available in PATH

## Quick Start

Run in your iOS project root:

```bash
bash /Users/newdroid/.codex/skills/ios-fastlane-pgyer/scripts/bootstrap_fastlane.sh --dry-run
```

If resolved config looks correct:

```bash
bash /Users/newdroid/.codex/skills/ios-fastlane-pgyer/scripts/bootstrap_fastlane.sh
```

Then install and run:

```bash
bundle install
export PGYER_API_KEY=your_key
bundle exec fastlane ios dev
bundle exec fastlane ios dis
```

## Common Overrides

```bash
bash /Users/newdroid/.codex/skills/ios-fastlane-pgyer/scripts/bootstrap_fastlane.sh \
  --signing-style manual \
  --profile-dev myapp_dev \
  --profile-dis myapp_dis \
  --team-id ABCD123456
```

Only `.xcodeproj` project:

```bash
bash /Users/newdroid/.codex/skills/ios-fastlane-pgyer/scripts/bootstrap_fastlane.sh \
  --xcodeproj MyApp.xcodeproj
```

## Parameters

```text
--project-name
--workspace
--xcodeproj
--scheme-dev
--scheme-dis
--bundle-id-dev
--bundle-id-dis
--team-id
--profile-dev
--profile-dis
--signing-style   automatic|manual
--dry-run
```

## Notes

- `dis` lane defaults to `ad-hoc` export. Adjust for `app-store` or `enterprise` if needed.
- Fastfile includes local macOS notifications via `osascript`.

---

## 中文说明

这是一个可复用的 Codex skill，用于在 iOS 项目中快速初始化 `fastlane` 打包流程，并集成蒲公英上传。

### 功能

- 自动生成 `fastlane/Fastfile`、`fastlane/Appfile`、`fastlane/Pluginfile`
- 同时支持 `.xcworkspace` 与 `.xcodeproj`
- 自动探测工程关键参数：
  - workspace/project
  - scheme（优先与项目同名）
  - bundle id
  - 签名模式（`automatic` / `manual`）
  - team id（可选）
- 签名策略：
  - `automatic`：不要求 profile
  - `manual`：要求 profile；缺失 team id 时写入 `YOUR_TEAM_ID` 占位并给出提醒

### 目录结构

```text
SKILL.md
agents/openai.yaml
assets/fastlane/Fastfile.template
assets/fastlane/Appfile.template
assets/fastlane/Pluginfile.template
scripts/bootstrap_fastlane.sh
```

### 前置条件

- macOS + Xcode 命令行工具
- Ruby/Bundler（用于执行 fastlane）
- PATH 中可用 `xcodebuild`

### 快速开始

在 iOS 项目根目录执行：

```bash
bash /Users/newdroid/.codex/skills/ios-fastlane-pgyer/scripts/bootstrap_fastlane.sh --dry-run
```

如果解析结果正确，直接生成：

```bash
bash /Users/newdroid/.codex/skills/ios-fastlane-pgyer/scripts/bootstrap_fastlane.sh
```

然后安装依赖并执行：

```bash
bundle install
export PGYER_API_KEY=your_key
bundle exec fastlane ios dev
bundle exec fastlane ios dis
```

### 常见覆盖参数

```bash
bash /Users/newdroid/.codex/skills/ios-fastlane-pgyer/scripts/bootstrap_fastlane.sh \
  --signing-style manual \
  --profile-dev myapp_dev \
  --profile-dis myapp_dis \
  --team-id ABCD123456
```

只有 `.xcodeproj` 的项目：

```bash
bash /Users/newdroid/.codex/skills/ios-fastlane-pgyer/scripts/bootstrap_fastlane.sh \
  --xcodeproj MyApp.xcodeproj
```

### 参数列表

```text
--project-name
--workspace
--xcodeproj
--scheme-dev
--scheme-dis
--bundle-id-dev
--bundle-id-dis
--team-id
--profile-dev
--profile-dis
--signing-style   automatic|manual
--dry-run
```

### 说明

- `dis` lane 默认 `ad-hoc` 导出，如需 `app-store` 或 `enterprise` 请自行调整。
- Fastfile 内置 `osascript` 本地通知。
