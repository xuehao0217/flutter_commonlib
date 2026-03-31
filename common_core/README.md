# common_core

本目录为 **Flutter package**，由主工程 [`flutter_commonlib`](../README.md) 通过 **path 依赖** 引用，集中存放：

- **网络**：`HttpUtils`（Dio）、拦截器、`BaseEntity`
- **MVVM 基类**：`BaseViewModel`、`BaseVMStatefulWidget` 等
- **主题**：`style/theme.dart`（与主工程 `GetMaterialApp` 配合）
- **通用组件**：`lib/widget/`（列表、对话框、WebView 封装、底部导航等）
- **辅助能力**：`helpter/` 下的日志、本地存储、Firebase、通知等（目录名为历史拼写）

## 使用方式

在主工程 `pubspec.yaml` 中：

```yaml
dependencies:
  common_core:
    path: ./common_core
```

初始化入口为 **`CommonCore.init`**（见 `lib/common_core.dart`），具体参数与顺序以源码为准。

## 开发与测试

```bash
cd common_core
flutter pub get
flutter analyze
```

Package 内 **`module:`**（Android / iOS）配置用于可选的 **add-to-app** 场景；若仅作为 path 包被主工程引用，以主工程构建为准。

更完整的项目说明、路由与 CI，见仓库根目录 [**README.md**](../README.md)。

## 代码注释说明

- **入口与网络**：`lib/common_core.dart`、`lib/net/dio_utils.dart`、`lib/net/base_entity.dart` 等配有 `///` 说明职责与约定。
- **页面基类**：`lib/base/`、`lib/base/mvvm/` 描述布局、GetX 生命周期与 `initData` 调用时机。
- **无 `library` 指令的文件**：顶部使用 `//` 文件说明，避免 `dangling_library_doc_comments`；公共类仍以 `///` 为主。

未逐行注释的组件（如部分 `widget/*.dart`）可按需补 [dartdoc](https://dart.dev/tools/dartdoc)。
