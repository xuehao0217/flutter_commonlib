# flutter_commonlib

基于 **Flutter** 的示例应用工程，通过 **path 依赖** 引入本地包 **`common_core`**，演示 **GetX 路由**、**MVVM**、**Dio 网络**、**Firebase（Analytics / Messaging / Crashlytics）**、**本地通知**、**Material 3 主题**与常用业务页（列表刷新、WebView、下载安装 APK 等）。适合作为团队内部 **能力集合与集成参考**，而非发布到 pub.dev 的独立库。

---

## 技术栈概览

| 类别 | 选型 |
|------|------|
| 框架 | Flutter（`pubspec.yaml` 中 `sdk` 见版本约束） |
| 路由 / 依赖注入 | [get](https://pub.dev/packages/get)（`GetMaterialApp`、`GetPage`） |
| 网络 | [dio](https://pub.dev/packages/dio)，封装于 `common_core/lib/net/` |
| 状态与 MVVM | `BaseViewModel`、`BaseVMStatefulWidget` 等（`common_core/lib/base/mvvm/`） |
| 国际化 | `flutter_localizations` + ARB（`lib/l10n/`、`l10n.yaml`） |
| 推送 / 分析 / 崩溃 | Firebase（Messaging、Analytics、Crashlytics 等，按 `pubspec` 版本） |
| 本地通知 | [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications) |
| 弹窗 | [flutter_smart_dialog](https://pub.dev/packages/flutter_smart_dialog) |

---

## 仓库结构

```
flutter_commonlib/          # 主应用（入口 lib/main.dart）
├── common_core/            # 本地 package：网络、主题、基类、通用组件与 Helper
│   └── lib/
│       ├── base/           # Stateful/Stateless、MVVM 基类
│       ├── net/            # HttpUtils、拦截器、BaseEntity
│       ├── helpter/        # 日志、SP、Firebase、通知等（目录名历史拼写）
│       ├── widget/         # 通用 UI 封装
│       └── style/          # 主题 theme.dart
├── lib/
│   ├── main.dart           # 入口：CommonCore.init、HttpUtils、GetMaterialApp
│   ├── l10n/               # ARB 与生成后的 app_localizations（flutter gen-l10n）
│   ├── router/             # 路由表 router_config.dart
│   ├── ui/                 # 示例页面与 ViewModel
│   └── api/                # 业务 HttpApi 等
├── test/                   # 单元 / 组件测试
└── .github/workflows/      # CI：analyze + test
```

---

## 环境要求

- 安装 [Flutter](https://docs.flutter.dev/get-started/install)（版本需满足根目录与 `common_core/pubspec.yaml` 中的 `environment.sdk`）。
- 主工程与 **`common_core`** 需分别能执行 `flutter pub get`（CI 中已对两层目录执行）。

---

## 快速开始

```bash
git clone <你的仓库地址>
cd flutter_commonlib

# 主工程
flutter pub get

# 本地包（CI 与日常开发建议都执行）
cd common_core && flutter pub get && cd ..

# 国际化代码生成（修改 ARB 或 l10n.yaml 后）
flutter gen-l10n

# 运行（需已连接设备或模拟器）
flutter run
```

首屏路由为 **`/main`**（`RouterUrlConfig.main`），对应底部导航 **`MainPage`**（首页 / 消息 / 我的）。

---

## 模块 `common_core` 说明

- **`CommonCore.init`**：统一初始化启动图保留、系统 UI、Chucker（调试）、本地通知插件、SharedPreferences、Firebase Messaging 等（见 `common_core/lib/common_core.dart`）。
- **`HttpUtils.init`**：在主工程 `main.dart` 中传入 `baseUrl` 与 JSON 解析回调，与业务 `HttpApi` 配合使用。
- **主题**：`appLightThemeData` / `appDarkThemeData`（Material 3 + `ColorScheme.fromSeed`），主工程通过 `GetMaterialApp` 的 `theme` / `darkTheme` / `themeMode` 切换。

更细的封装边界与演进建议，见包内代码注释及团队内部架构约定。

---

## 路由

路由常量定义在 **`lib/router/router_config.dart`** 的 `RouterUrlConfig`，须与 `pages` 列表中 `GetPage.name` 一致。示例包括：`/main`、`/list_refresh`、`/webview`、`/download`、`/watermark` 等。

---

## 国际化（l10n）

- 配置：`l10n.yaml`，ARB 位于 `lib/l10n/`（如 `app_en.arb`、`app_zh.arb`）。
- `GetMaterialApp` 已配置 `localizationsDelegates` 与 `supportedLocales`。
- 修改文案后执行：`flutter gen-l10n`。

---

## 测试

```bash
flutter test
```

当前测试位于 `test/`（如 `BaseEntity`、l10n 烟测等），可按业务继续补充。

---

## CI

GitHub Actions（`.github/workflows/flutter.yml`）：在 `push` / `pull_request` 至 `main` 或 `master` 时执行 `flutter pub get`（含 `common_core`）、`flutter analyze`、`flutter test`。

> 若本地使用 **beta / 特定 SDK** 而 CI 使用 **stable**，分析结果可能略有差异，建议在流水线中与本机对齐 Flutter 渠道与版本。

---

## 平台与权限提示（摘要）

以下为集成演示常用能力时的注意点，具体以各插件官方文档为准。

| 能力 | 说明 |
|------|------|
| 本地通知 | Android 需正确配置 **small icon（drawable）**、`POST_NOTIFICATIONS`（Android 13+）及运行时授权；详见 `NotificationHelper` 与 `AndroidManifest.xml`。 |
| 版本更新 / 安装 APK | 下载目录使用应用缓存时一般不需存储权限；安装需 **`REQUEST_INSTALL_PACKAGES`** 及运行时安装权限，见 `DownloadViewModel` 与 Manifest。 |
| Firebase | 需按官方方式配置各平台的 `google-services` / `GoogleService-Info.plist` 等；FCM 后台入口在 `main.dart` 中注册。 |
| 调试抓包 | `DdCheckPlugin` 等仅在 **`kDebugMode`** 下初始化，避免线上误开。 |

---

## 截图 / 演示

如需在 README 中展示 GIF 或截图，请将资源放在本仓库内（例如 `docs/screenshots/`），并使用**相对路径**或可靠 URL，避免外链失效。

---

## 许可与发布

`publish_to: 'none'` 表示默认不作为公开包发布；内部使用请遵循团队许可证与代码规范。
