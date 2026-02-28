# iOS Fastlane Skill 使用指南（中文详细版）

这是一份可直接用于博客发布的实战文档，介绍如何触发并使用 `ios-fastlane-skill`，在 iOS 项目中快速搭建一套可维护的 fastlane 发布体系。

## 一、这个 Skill 解决什么问题

在很多 iOS 团队里，fastlane 往往存在这些问题：

- 每个项目写法不同，迁移成本高。
- 签名配置分散，CI 经常因证书/描述文件失败。
- 发布链路不完整，只能本地打包，难以统一到 TestFlight / App Store。
- 缺乏可观测性，失败后不知道看哪里、产物信息不完整。

`ios-fastlane-skill` 的目标就是：

- 一次初始化，标准化 fastlane 结构。
- 支持本地、CI、多环境、多个发布渠道。
- 默认包含质量门禁、变更记录、通知和构建摘要。

## 二、如何触发 Skill

你可以在 Codex 对话中直接用下面任一方式触发。

### 1. 中文触发示例

```text
请使用 $ios-fastlane-skill，帮我在当前 iOS 项目初始化 fastlane。
```

```text
使用 ios-fastlane-skill，先自动探测参数，再生成可用于 CI 和发布的 fastlane 配置。
```

### 2. 英文触发示例

```text
Use $ios-fastlane-skill to bootstrap fastlane in this iOS project.
```

```text
Use ios-fastlane-skill, auto-detect project settings, and generate production-ready lanes.
```

## 三、初始化流程（推荐）

### 第一步：先 dry-run 看自动识别结果

```bash
bash /Users/newdroid/.codex/skills/ios-fastlane-skill/scripts/bootstrap_fastlane.sh --dry-run
```

你会看到识别结果，比如：

- `PROJECT_NAME`
- `WORKSPACE` / `XCODEPROJ`
- `SCHEME_DEV` / `SCHEME_DIS`
- `BUNDLE_ID_DEV` / `BUNDLE_ID_DIS`
- `TEAM_ID`
- `SIGNING_STYLE`

### 第二步：正式生成配置文件

```bash
bash /Users/newdroid/.codex/skills/ios-fastlane-skill/scripts/bootstrap_fastlane.sh \
  --match-git-url "git@github.com:your-org/certificates.git" \
  --enable-tests true \
  --enable-swiftlint false \
  --enable-slack-notify true
```

### 第三步：复制环境配置

```bash
cp fastlane/.env.fastlane.example fastlane/.env.fastlane
cp fastlane/.env.fastlane.staging.example fastlane/.env.fastlane.staging
cp fastlane/.env.fastlane.prod.example fastlane/.env.fastlane.prod
```

然后填写关键变量，例如：

- `PGYER_API_KEY`
- `MATCH_PASSWORD`（若使用 match）
- `SLACK_WEBHOOK_URL` / `WECHAT_WEBHOOK_URL`
- `APP_STORE_CONNECT_API_KEY_PATH`（用于 TestFlight / App Store）

### 第四步：安装并验证

```bash
bundle install
bundle exec fastlane ios validate_config
```

## 四、两种高级初始化方式

## 1. 交互式向导

适合第一次接触这个 skill，希望一步一步确认参数。

```bash
bash /Users/newdroid/.codex/skills/ios-fastlane-skill/scripts/bootstrap_fastlane.sh --interactive
```

## 2. 配置文件模式（推荐团队使用）

创建 `fastlane-skill.conf`：

```ini
PROJECT_NAME=MyApp
SIGNING_STYLE=manual
MATCH_GIT_URL=git@github.com:your-org/certificates.git
ENABLE_TESTS=true
ENABLE_SWIFTLINT=false
ENABLE_SLACK_NOTIFY=true
GYM_SKIP_CLEAN=false
CI_BUNDLE_INSTALL=true
```

执行：

```bash
bash /Users/newdroid/.codex/skills/ios-fastlane-skill/scripts/bootstrap_fastlane.sh --config ./fastlane-skill.conf
```

说明：命令行参数优先级高于配置文件参数。

## 五、常用 Lane 场景

## 1. 本地开发分发

```bash
bundle exec fastlane ios dev
bundle exec fastlane ios dis
```

- `dev` 适合测试环境快速分发。
- `dis` 适合对外分发（默认 `ad-hoc`，可配置覆盖）。

## 2. 多环境发布

```bash
bundle exec fastlane ios staging
bundle exec fastlane ios prod
```

- `staging` 自动读取 `fastlane/.env.fastlane.staging`
- `prod` 自动读取 `fastlane/.env.fastlane.prod`

你可以在对应 env 文件里控制：

- `STAGING_SCHEME` / `PROD_SCHEME`
- `*_BUNDLE_ID`
- `*_EXPORT_METHOD`
- `*_UPLOAD_PGYER`

## 3. CI 场景

```bash
bundle exec fastlane ios ci_setup
bundle exec fastlane ios ci_build_dev
bundle exec fastlane ios ci_build_dis
```

CI 默认支持：

- `setup_ci`
- `bundle install`（可开关）
- `cocoapods deployment`（可开关）
- `certificates readonly`

## 4. 发布到 Apple 渠道

```bash
bundle exec fastlane ios release_testflight
bundle exec fastlane ios release_appstore
```

对应能力：

- `pilot` 上传 TestFlight
- `deliver` 上传 App Store Connect（默认不自动提交审核）

## 5. 签名同步

```bash
bundle exec fastlane ios certificates
bundle exec fastlane ios profiles
```

- `certificates`：按类型同步（development / adhoc / appstore）
- `profiles`：一次同步三种类型，适合团队初始化和 CI 准备

截图与元数据同步：

```bash
bundle exec fastlane ios snapshot_capture
bundle exec fastlane ios metadata_sync
```

## 六、质量门禁与版本策略

## 1. 质量门禁

```bash
bundle exec fastlane ios quality_gate
```

门禁项由 env 开关控制：

- `ENABLE_TESTS=true`：运行 `scan`
- `ENABLE_SWIFTLINT=true`：运行 `swiftlint`

失败即中断后续发布。

## 2. 版本策略

```bash
bundle exec fastlane ios versioning
```

支持：

- 指定 build number
- 从 tag 尾部数字取 build number（失败则回退 commit count）
- 自动生成 changelog 元信息

## 七、通知与构建产物

构建完成后默认会产出：

- IPA：`fastlane/builds/*.ipa`
- 变更文档：`fastlane/builds/CHANGELOG_<env>_<version>_<build>.md`
- 产物清单：`fastlane/builds/ARTIFACT_MANIFEST_<lane>_<timestamp>.json`

通知通道支持：

- Slack webhook
- 企业微信 webhook

通知内容会包含关键信息：

- lane
- version / build
- commit
- changelog 文件名
- 耗时和包体积（可观测摘要）

## 八、推荐的团队落地顺序

## 1. 单项目先跑通

先完成：

- `validate_config`
- `dev`
- `ci_build_dev`

## 2. 再启用签名标准化

启用 `match` 后跑：

- `certificates`
- `profiles`

## 3. 最后接入发布渠道

接入：

- `release_testflight`
- `release_appstore`

并打通 Slack / 企业微信通知。

## 九、常见问题

## 1. 手动签名缺 Team ID 会怎样？

不会阻塞初始化，会使用占位值并给出提醒。建议后续补齐真实 Team ID。

## 2. 没有 workspace 只有 xcodeproj 能用吗？

可以。脚本会自动识别 `.xcodeproj`。

## 3. 不想每次 clean，想加速怎么办？

在 env 中配置：

- `GYM_SKIP_CLEAN=true`
- `DERIVED_DATA_PATH=/your/cache/path`

## 4. CI 上如何减少依赖安装时间？

- `CI_BUNDLE_INSTALL=true` 配合 `vendor/bundle` 缓存
- `CI_COCOAPODS_DEPLOYMENT=true` 保持依赖稳定

## 十、最小可跑命令清单

```bash
bash /Users/newdroid/.codex/skills/ios-fastlane-skill/scripts/bootstrap_fastlane.sh --dry-run
bash /Users/newdroid/.codex/skills/ios-fastlane-skill/scripts/bootstrap_fastlane.sh
bundle install
cp fastlane/.env.fastlane.example fastlane/.env.fastlane
bundle exec fastlane ios validate_config
bundle exec fastlane ios dev
```

完成以上步骤后，再逐步启用 CI、staging/prod、TestFlight、App Store。
