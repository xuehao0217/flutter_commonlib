# DESIGN.md（Vercel）在本工程中的用法

本目录下的 [`DESIGN.md`](./DESIGN.md) 来自开源合集 [VoltAgent/awesome-design-md](https://github.com/VoltAgent/awesome-design-md) 的 `design-md/vercel`，**MIT License**；可自行与上游同步更新。

## 与代码的对应关系

| DESIGN.md 内容 | Flutter 落地 |
|----------------|---------------|
| 色板（Vercel Black、Develop Blue、灰阶等） | `common_core/lib/style/design_md_vercel_tokens.dart` + `theme.dart` 中 `ColorScheme` |
| Geist 字体与偏紧字距 | `package:google_fonts` → `GoogleFonts.geistTextTheme` + 大标题 `letterSpacing` |
| Shadow-as-border（约 8% 黑描边） | `CardTheme` 的 `RoundedRectangleBorder(side: …)` |
| 按钮圆角约 6px | `FilledButtonTheme` / `OutlinedButtonTheme` |

全局 `GetMaterialApp` 仍使用 `common_core` 的 `appLightThemeData` / `appDarkThemeData`（见 `lib/main.dart`），因此**全应用默认即按该 DESIGN 气质渲染**。

## 换成其它站点风格

1. 从 [awesome-design-md 的 `design-md/`](https://github.com/VoltAgent/awesome-design-md/tree/main/design-md) 另选目录，将其中 `DESIGN.md`（及可选 `preview.html`）拷到 `docs/` 下新文件夹。
2. 在 `common_core/lib/style/` 增加新 tokens 文件（或改现有 tokens），并调整 `theme.dart` 中 `ColorScheme` / `TextTheme` / 组件主题。
3. 对 Cursor / Agent 说明：「新页面须遵守 `docs/…/DESIGN.md`。」
