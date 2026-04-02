# Flutter 代码规范（基于本仓库实践）

本文档总结 `flutter_commonlib` 与 `common_core` 中已采用的工程结构、架构与编码习惯，新增与修改代码时建议对齐本文，避免风格分裂。

---

## 1. 工程与模块边界

| 模块 | 包名 | 职责 |
|------|------|------|
| 宿主应用 | `flutter_commonlib` | `main`、路由、业务页面、宿主 API 与实体、主题扩展 |
| 核心库 | `common_core` | 可复用的基础页、MVVM 基类、网络层通用封装、通用组件与 Helper、`CommonCore.init` 壳层初始化 |

- 宿主通过 **path 依赖** 引用 `common_core`，业务页面可依赖 `package:common_core/...`。
- 宿主的 **业务 ViewModel** 放在 `lib/ui/vm/`，实体放在 `lib/entity/`，接口路径集中在 `lib/api/http_api.dart`。
- `common_core` 内 **不写具体业务接口常量**；由宿主实现 `HttpUtils.init` 的 `baseUrl` 与 JSON 转换回调。

---

## 2. 静态分析与 Lint

- 根目录与 `common_core` 均 **include `package:flutter_lints/flutter.yaml`**（见各模块 `analysis_options.yaml`）。
- 新增规则时在两处同步评估，避免库与宿主不一致。
- 单文件或单行抑制使用 `// ignore:` / `// ignore_for_file:`，并简短注明原因。

---

## 3. 目录与命名

### 3.1 `common_core` 推荐布局（与现有一致）

- `lib/base/`：页面基类、`mvvm/` 下 ViewModel 与 View 抽象。
- `lib/net/`：`HttpUtils`、`Dio` 封装、响应壳 `BaseEntity`、`intercept` 等。
- `lib/widget/`：可复用 UI 组件（列表、输入、WebView 等）。
- `lib/helpter/`：**当前目录名为历史拼写**，与现有 import 路径一致；新代码若大规模调整可再统一重命名为 `helper` 并全局替换。
- `lib/style/`：主题、与主题相关的复用样式。
- `lib/assets/`、`lib/gen_exports.dart`：资源与导出聚合。

### 3.2 宿主 `lib/` 布局

- `main.dart`：启动、全局初始化、根 `GetMaterialApp`。
- `router/router_config.dart`：路由名常量 `RouterUrlConfig`、`GetPage` 列表。
- `ui/`：页面 Widget（`*_page.dart` 或语义化名称如 `home_page.dart`）。
- `ui/vm/`：与页面对应的 `*_view_model.dart`。
- `api/http_api.dart`：`HttpApi` 类，**接口 path 用 `static const`**。
- `entity/`：数据模型；若使用生成代码，配套放在 `lib/generated/json/`。
- `l10n/`：`AppLocalizations` 生成文件。
- `style/`：宿主侧颜色或主题补充。

### 3.3 命名约定

- **类名**：大驼峰 `HomePage`、`HomeViewModel`。
- **文件**：小写 + 下划线 `home_page.dart`、`home_view_model.dart`。
- **路由常量**：与 `GetPage.name` 一致，优先 **snake_case** 字符串，集中在 `RouterUrlConfig`（如 `RouterUrlConfig.list_refresh`）。
- **GetX 可观察变量**：项目内混用 `.obs` 与 `Rx<>`，同一 ViewModel 内建议 **择一风格** 或按是否可空语义区分，避免无意义重复（如 `banner` 与 `rxBanner` 并存时需有明确分工）。

---

## 4. 架构：MVVM + GetX

### 4.1 分层职责

- **View（页面）**：组合 Widget、`buildPageContent` / `buildInner`；尽量不写复杂业务逻辑。
- **ViewModel**：继承 `BaseViewModel`（或带 View 泛型形态的基类），负责请求、状态字段、对 View 的 `showToast` / `showLoading` 回调。
- **View 与 ViewModel 绑定**：通过 `BaseVMStatefulWidget` / `BaseVMStatelessWidget` + `Get.put` / `Get.delete`（及可选 `viewModelTag`）管理生命周期。

### 4.2 网络请求

- 统一走 `BaseViewModel.asyncRequestNetwork` 或 `HttpUtils` 封装，**传入 `CancelToken`**（基类在 `onDispose` 中会取消），避免页面关闭后回调仍执行。
- 业务成功约定与 `BaseEntity.isSuccess()`、`errorCode == 0` 对齐；错误提示默认经 View 的 `showToast`（取消请求等单独码可不做 Toast）。

### 4.3 路由与依赖注入

- 使用 `GetMaterialApp`、`getPages`，跳转与 `RouterUrlConfig` 常量一致；扩展可用 `GetXHelper` 等项目内封装。
- 调试能力（如 Chucker）仅在 `kDebugMode` 下挂载 `navigatorObserver`，与 `main` 中现有模式一致。

---

## 5. import 顺序建议

与现有文件保持一致的可读顺序：

1. `dart:` SDK（如 `async`、`io`）。
2. `package:flutter/...`、`package:flutter_commonlib/...`。
3. `package:common_core/...`。
4. 其他第三方 `package:`（如 `get`、`dio`）。
5. 相对路径 `../`、`./`（同级实体、router、vm）。

组与组之间空一行。

---

## 6. 日志与异常

- 开发日志优先 **Talker / 项目封装的 LoggerHelper**，避免生产路径依赖 `print`；临时调试可用 `debugPrint`，敏感信息勿输出。
- 全局未捕获异常：`runZonedGuarded` 中 Debug 打控制台，若 Firebase 已初始化则 **上报 Crashlytics**（与 `main.dart` 一致）。

---

## 7. 平台与 Flutter 约定

- **Firebase 后台消息入口**必须顶层声明，且带 `@pragma('vm:entry-point')`，内联再 `Firebase.initializeApp`。
- **启动与壳层**：`CommonCore().init` 中处理启动图 preserve、沉浸式状态栏、横竖屏、Chucker 开关、通知、SP、FCM 等；移除启动图使用 `removeSplash()`。
- **资源**：静态资源在 `pubspec.yaml` 的 `flutter.assets` 中声明；生成类资源配合 `flutter: generate: true` 与 l10n。

---

## 8. UI 与交互

- 全屏 Loading / Toast 与 `AbsBaseView` 实现一致时使用 **FlutterSmartDialog**（见基类 `showLoading` / `showToast`）。
- 主题使用 `common_core` 的 `appLightThemeData` / `appDarkThemeData` 及 `Theme.of(context).colorScheme`，避免硬编码色值 scattered（宿主扩展色可放 `lib/style/color.dart`）。

---

## 9. 文档注释

- **对外 API**（`common_core` 的 public 类、重要 `init`、复杂参数）：使用 `///` 简短说明用途与约束（参考 `common_core.dart`、`BaseEntity`）。
- 私有实现、重写 `build` 的纯 UI 可不强制文档，但 **复杂业务分支** 建议一行注释说明意图。

---

## 10. 测试

- 单元测试与大工程依赖相关的测试放在仓库 `test/`，命名 `*_test.dart`。
- 修改 `BaseEntity`、网络解析等基础逻辑时，优先补充或运行现有测试（如 `base_entity_test.dart`）。

---

## 11. 提交前自检（建议）

- `flutter analyze`（根目录与 `common_core` 分别执行，若 CI 只跑根目录也需保证 path 包无新增 warning）。
- `flutter pub get` 能正常解析。
- 新页面：已注册 `GetPage` 且 `RouterUrlConfig` 常量与 `name` 一致。

---

*文档随项目演进可继续补充：例如统一 Rx 命名、目录 `helpter` 迁移计划、接口层是否引入 Repository 等。*
