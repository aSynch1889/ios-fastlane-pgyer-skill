# iOS Fastlane Skill

English | [中文](#中文说明)

A reusable Codex skill to bootstrap and standardize iOS fastlane with match signing, quality gates, CI lanes, multi-environment lanes, release lanes, changelog/manifest outputs, screenshot+metadata pipeline, and channel notifications.

## Overview

This skill targets production-grade iOS delivery workflows where teams need:

- Consistent fastlane structure across multiple projects
- Stable signing behavior in local and CI environments
- Multi-channel release support (Pgyer, TestFlight, App Store)
- Better observability (duration, artifact summary, changelog, failure context)

It generates templates and scripts so teams can focus on project-specific config instead of rewriting lanes.

## Features

- Generates:
  - `fastlane/Fastfile`
  - `fastlane/Appfile`
  - `fastlane/Pluginfile`
  - `fastlane/.env.fastlane.example`
  - `fastlane/.env.fastlane.staging.example`
  - `fastlane/.env.fastlane.prod.example`
- Supports `.xcworkspace` and `.xcodeproj`
- Auto-detects key project fields during bootstrap
- Lanes:
  - Base: `prepare`, `quality_gate`, `versioning`, `validate_config`, `clean_builds`
  - Signing: `certificates`, `profiles`
  - Build/Distribute: `dev`, `dis`, `staging`, `prod`
  - CI: `ci_setup`, `ci_build_dev`, `ci_build_dis`
  - Release: `snapshot_capture`, `metadata_sync`, `release_testflight`, `release_appstore`
- Hooks and observability:
  - `before_all` / `after_all` / `error`
  - Changelog markdown: `fastlane/builds/CHANGELOG_<env>_<version>_<build>.md`
  - Artifact manifest: `fastlane/builds/ARTIFACT_MANIFEST_<lane>_<timestamp>.json`
- Notifications:
  - Slack webhook
  - WeChat webhook

## Prerequisites

- macOS + Xcode CLI tools (`xcodebuild` in PATH)
- Ruby + Bundler
- iOS project with `.xcodeproj` or `.xcworkspace`

Optional but recommended:

- `match` certificate repo + `MATCH_PASSWORD`
- App Store Connect API key file (`.p8`) for release lanes

## Quick Start

### 1. Preview auto-detected config

```bash
bash /Users/newdroid/.codex/skills/ios-fastlane-skill/scripts/bootstrap_fastlane.sh --dry-run
```

### 2. Generate templates

```bash
bash /Users/newdroid/.codex/skills/ios-fastlane-skill/scripts/bootstrap_fastlane.sh \
  --match-git-url "git@github.com:your-org/certificates.git" \
  --enable-tests true \
  --enable-swiftlint false \
  --enable-slack-notify true
```

### 3. Prepare env files

```bash
cp fastlane/.env.fastlane.example fastlane/.env.fastlane
cp fastlane/.env.fastlane.staging.example fastlane/.env.fastlane.staging
cp fastlane/.env.fastlane.prod.example fastlane/.env.fastlane.prod
```

### 4. Install and validate

```bash
bundle install
bundle exec fastlane ios validate_config
```

## Bootstrap Modes

### Mode A: Standard CLI options

Use command-line arguments for direct setup.

### Mode B: Config file

Create a `fastlane-skill.conf` (key=value), then run:

```bash
bash /Users/newdroid/.codex/skills/ios-fastlane-skill/scripts/bootstrap_fastlane.sh \
  --config ./fastlane-skill.conf
```

### Mode C: Interactive wizard

```bash
bash /Users/newdroid/.codex/skills/ios-fastlane-skill/scripts/bootstrap_fastlane.sh --interactive
```

## Common Lane Examples

### Signing

```bash
bundle exec fastlane ios certificates
bundle exec fastlane ios profiles
```

### Build and distribute

```bash
bundle exec fastlane ios dev
bundle exec fastlane ios dis
bundle exec fastlane ios staging
bundle exec fastlane ios prod
```

### CI

```bash
bundle exec fastlane ios ci_setup
bundle exec fastlane ios ci_build_dev
bundle exec fastlane ios ci_build_dis
```

### Screenshot + metadata pipeline

```bash
bundle exec fastlane ios snapshot_capture
bundle exec fastlane ios metadata_sync
```

### Release channels

```bash
bundle exec fastlane ios release_testflight
bundle exec fastlane ios release_appstore
```

## Important Env Keys

```text
PGYER_API_KEY
PGYER_APP_URL

MATCH_GIT_URL
MATCH_GIT_BRANCH
MATCH_PASSWORD

ENABLE_QUALITY_GATE
ENABLE_TESTS
ENABLE_SWIFTLINT

ENABLE_SLACK_NOTIFY
SLACK_WEBHOOK_URL
ENABLE_WECHAT_NOTIFY
WECHAT_WEBHOOK_URL

APP_STORE_CONNECT_API_KEY_PATH
TESTFLIGHT_GROUPS

ENABLE_SNAPSHOT
SNAPSHOT_SCHEME
SNAPSHOT_DEVICES
SNAPSHOT_LANGUAGES
METADATA_PATH
ENABLE_METADATA_UPLOAD
ENABLE_SCREENSHOT_UPLOAD

GYM_SKIP_CLEAN
DERIVED_DATA_PATH
CI_BUNDLE_INSTALL
CI_COCOAPODS_DEPLOYMENT
ENABLE_ARTIFACT_MANIFEST
```

## Script Parameters

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
--signing-style automatic|manual
--match-git-url
--match-git-branch
--enable-quality-gate true|false
--enable-tests true|false
--enable-swiftlint true|false
--enable-slack-notify true|false
--enable-wechat-notify true|false
--enable-snapshot true|false
--snapshot-scheme AppScheme
--snapshot-devices "iPhone 15 Pro,iPhone 15"
--snapshot-languages "en-US,zh-Hans"
--metadata-path fastlane/metadata
--enable-metadata-upload true|false
--enable-screenshot-upload true|false
--gym-skip-clean true|false
--derived-data-path /path
--ci-bundle-install true|false
--ci-cocoapods-deployment true|false
--config path
--interactive
--dry-run
```

## Outputs and Observability

After build/release lanes, check:

- IPA files in `fastlane/builds/`
- Changelog markdown in `fastlane/builds/CHANGELOG_*.md`
- Artifact manifests in `fastlane/builds/ARTIFACT_MANIFEST_*.json`

Notification messages include lane/status/version/build/commit and summary fields such as duration and ipa size.

## Notes

- In manual signing mode, configure profiles/team/match carefully.
- For App Store release, ensure metadata path and App Store Connect auth are valid.
- For screenshot pipeline, configure devices/languages explicitly for deterministic outputs.

---

## 中文说明

这是一个可复用的 Codex skill，用于在 iOS 项目中快速搭建并标准化 fastlane 流程，覆盖签名管理、质量门禁、CI、多环境发布、截图与元数据、发布渠道以及构建可观测。

## 总览

这个 skill 适用于“要长期维护发布链路”的团队场景，目标是解决：

- 多项目 fastlane 结构不一致，迁移和维护成本高
- 本地和 CI 签名行为不稳定，容易出现证书/描述文件问题
- 发布渠道割裂，无法统一到蒲公英/TestFlight/App Store
- 构建结果不可观测，失败排查成本高

通过模板和脚本，把通用能力固化，项目侧只维护配置。

## 功能清单

- 自动生成：
  - `fastlane/Fastfile`
  - `fastlane/Appfile`
  - `fastlane/Pluginfile`
  - `fastlane/.env.fastlane.example`
  - `fastlane/.env.fastlane.staging.example`
  - `fastlane/.env.fastlane.prod.example`
- 支持 `.xcworkspace` / `.xcodeproj`
- 初始化时自动识别核心工程参数
- 内置 lanes：
  - 基础：`prepare`、`quality_gate`、`versioning`、`validate_config`、`clean_builds`
  - 签名：`certificates`、`profiles`
  - 构建分发：`dev`、`dis`、`staging`、`prod`
  - CI：`ci_setup`、`ci_build_dev`、`ci_build_dis`
  - 发布：`snapshot_capture`、`metadata_sync`、`release_testflight`、`release_appstore`
- 内置 hooks 与可观测：
  - `before_all` / `after_all` / `error`
  - 变更文档：`fastlane/builds/CHANGELOG_<env>_<version>_<build>.md`
  - 产物清单：`fastlane/builds/ARTIFACT_MANIFEST_<lane>_<timestamp>.json`
- 通知通道：
  - Slack webhook
  - 企业微信 webhook

## 前置要求

- macOS + Xcode 命令行工具（PATH 内可用 `xcodebuild`）
- Ruby + Bundler
- iOS 工程（`.xcodeproj` 或 `.xcworkspace`）

可选但推荐：

- `match` 证书仓库 + `MATCH_PASSWORD`
- App Store Connect API Key（`.p8`）

## 快速开始

### 1. 先预览自动探测结果

```bash
bash /Users/newdroid/.codex/skills/ios-fastlane-skill/scripts/bootstrap_fastlane.sh --dry-run
```

### 2. 生成模板

```bash
bash /Users/newdroid/.codex/skills/ios-fastlane-skill/scripts/bootstrap_fastlane.sh \
  --match-git-url "git@github.com:your-org/certificates.git" \
  --enable-tests true \
  --enable-swiftlint false \
  --enable-slack-notify true
```

### 3. 准备环境文件

```bash
cp fastlane/.env.fastlane.example fastlane/.env.fastlane
cp fastlane/.env.fastlane.staging.example fastlane/.env.fastlane.staging
cp fastlane/.env.fastlane.prod.example fastlane/.env.fastlane.prod
```

### 4. 安装并校验

```bash
bundle install
bundle exec fastlane ios validate_config
```

## 初始化模式

### 模式 A：命令行参数模式

直接在命令中传参，适合一次性初始化。

### 模式 B：配置文件模式

先写 `fastlane-skill.conf`（`key=value`），再执行：

```bash
bash /Users/newdroid/.codex/skills/ios-fastlane-skill/scripts/bootstrap_fastlane.sh \
  --config ./fastlane-skill.conf
```

### 模式 C：交互向导模式

```bash
bash /Users/newdroid/.codex/skills/ios-fastlane-skill/scripts/bootstrap_fastlane.sh --interactive
```

## 常见 Lane 用法

### 签名相关

```bash
bundle exec fastlane ios certificates
bundle exec fastlane ios profiles
```

### 构建与分发

```bash
bundle exec fastlane ios dev
bundle exec fastlane ios dis
bundle exec fastlane ios staging
bundle exec fastlane ios prod
```

### CI 场景

```bash
bundle exec fastlane ios ci_setup
bundle exec fastlane ios ci_build_dev
bundle exec fastlane ios ci_build_dis
```

### 截图与元数据流水线

```bash
bundle exec fastlane ios snapshot_capture
bundle exec fastlane ios metadata_sync
```

### 发布渠道

```bash
bundle exec fastlane ios release_testflight
bundle exec fastlane ios release_appstore
```

## 关键环境变量

```text
PGYER_API_KEY
PGYER_APP_URL

MATCH_GIT_URL
MATCH_GIT_BRANCH
MATCH_PASSWORD

ENABLE_QUALITY_GATE
ENABLE_TESTS
ENABLE_SWIFTLINT

ENABLE_SLACK_NOTIFY
SLACK_WEBHOOK_URL
ENABLE_WECHAT_NOTIFY
WECHAT_WEBHOOK_URL

APP_STORE_CONNECT_API_KEY_PATH
TESTFLIGHT_GROUPS

ENABLE_SNAPSHOT
SNAPSHOT_SCHEME
SNAPSHOT_DEVICES
SNAPSHOT_LANGUAGES
METADATA_PATH
ENABLE_METADATA_UPLOAD
ENABLE_SCREENSHOT_UPLOAD

GYM_SKIP_CLEAN
DERIVED_DATA_PATH
CI_BUNDLE_INSTALL
CI_COCOAPODS_DEPLOYMENT
ENABLE_ARTIFACT_MANIFEST
```

## 脚本参数

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
--signing-style automatic|manual
--match-git-url
--match-git-branch
--enable-quality-gate true|false
--enable-tests true|false
--enable-swiftlint true|false
--enable-slack-notify true|false
--enable-wechat-notify true|false
--enable-snapshot true|false
--snapshot-scheme AppScheme
--snapshot-devices "iPhone 15 Pro,iPhone 15"
--snapshot-languages "en-US,zh-Hans"
--metadata-path fastlane/metadata
--enable-metadata-upload true|false
--enable-screenshot-upload true|false
--gym-skip-clean true|false
--derived-data-path /path
--ci-bundle-install true|false
--ci-cocoapods-deployment true|false
--config path
--interactive
--dry-run
```

## 产物与可观测

构建后可在 `fastlane/builds/` 查看：

- IPA 包
- `CHANGELOG_*.md`（变更说明）
- `ARTIFACT_MANIFEST_*.json`（产物清单）

通知内容默认包含 lane/status/version/build/commit，以及耗时、包体积等摘要。

## 说明

- 手动签名模式下请确保 profile/team/match 配置正确。
- App Store 发布前请确认 metadata 路径和 App Store Connect 鉴权文件有效。
- 截图流水线建议固定 devices/languages，保证输出稳定。
