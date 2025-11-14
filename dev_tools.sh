#!/bin/bash
# ==========================================
# Flutter 全功能开发命令大全
# 功能覆盖：调试、性能、UI、依赖、生成代码、测试、热重载、打包、工具链
# ==========================================

echo "🚀 Flutter 全功能开发命令大全"

# ------------------------------------------
# 1️⃣ 环境 & 工具
# ------------------------------------------
echo "🔹 1. 环境 & 工具"
echo "flutter --version               # 查看 Flutter 版本"
echo "flutter doctor                  # 检查环境配置"
echo "flutter doctor -v               # 查看详细信息"
echo "dart --version                  # 查看 Dart 版本"
echo "flutter channel                 # 查看当前渠道"
echo "flutter channel stable          # 切换到稳定渠道"

# ------------------------------------------
# 2️⃣ 依赖管理
# ------------------------------------------
echo "🔹 2. 依赖管理"
echo "flutter pub get                 # 获取依赖"
echo "flutter pub upgrade             # 升级依赖"
echo "flutter pub outdated            # 查看可升级依赖"
echo "flutter pub cache repair        # 修复缓存"
echo "dart pub global activate <pkg>  # 安装全局工具包"
echo "dart pub global run <pkg>       # 运行全局工具包"

# ------------------------------------------
# 3️⃣ 项目构建
# ------------------------------------------
echo "🔹 3. 项目构建"
echo "flutter clean                   # 清理构建缓存"
echo "flutter build apk               # 构建 APK"
echo "flutter build apk --split-per-abi  # 构建按架构分 APK"
echo "flutter build appbundle         # 构建 AAB"
echo "flutter build ios               # 构建 iOS"
echo "flutter build ios --no-codesign # 构建不签名"

# ------------------------------------------
# 4️⃣ 运行 & 调试
# ------------------------------------------
echo "🔹 4. 运行 & 调试"
echo "flutter run -d <device>         # 启动应用"
echo "flutter attach --debug-port 12345  # 连接已运行应用"
echo "flutter logs -d <device>       # 查看设备日志"
echo "flutter run --release           # 运行 release 版本"
echo "flutter run --profile           # 运行 profile 版本"

# ------------------------------------------
# 5️⃣ 热重载 & 热重启
# ------------------------------------------
echo "🔹 5. 热重载 & 热重启"
echo "r  # 热重载 (运行 flutter run 后按)"
echo "R  # 热重启 (运行 flutter run 后按)"

# ------------------------------------------
# 6️⃣ 性能分析
# ------------------------------------------
echo "🔹 6. 性能分析"
echo "flutter analyze                 # 静态分析"
echo "flutter pub deps                # 查看依赖树"
echo "flutter build apk --analyze-size # 分析 APK size"
echo "flutter build ios --analyze-size # 分析 iOS size"
echo "DevTools → Performance          # 性能分析 UI、CPU、内存"
echo "flutter pub global activate devtools"
echo "flutter pub global run devtools"

# ------------------------------------------
# 7️⃣ UI 相关
# ------------------------------------------
echo "🔹 7. UI 相关"
echo "flutter pub run flutter_native_splash:create  # 配置启动页"
echo "flutter pub run flutter_launcher_icons:main   # 生成应用图标"
echo "flutter pub run lottie:main                  # Lottie 动画"
echo "flutter pub run flutter_screenutil:main      # 屏幕适配"

# ------------------------------------------
# 8️⃣ 代码生成
# ------------------------------------------
echo "🔹 8. 代码生成"
echo "flutter pub run build_runner build --delete-conflicting-outputs  # 一次性生成"
echo "flutter pub run build_runner watch                                  # 实时生成"
echo "常用插件: json_serializable, freezed, injectable, mobx_codegen, retrofit_generator"

# ------------------------------------------
# 9️⃣ 自动化测试
# ------------------------------------------
echo "🔹 9. 自动化测试"
echo "flutter test                        # 单元测试"
echo "flutter drive --target=test_driver/app.dart  # 集成测试 / UI 自动化"
echo "flutter test --coverage             # 单元测试覆盖率"
echo "genhtml coverage/lcov.info -o coverage/html # 生成测试报告"

# ------------------------------------------
# 🔟 代码质量
# ------------------------------------------
echo "🔹 10. 代码质量"
echo "dart format .          # 格式化所有 Dart 文件"
echo "dart fix --apply       # 自动修复问题"
echo "flutter analyze        # 静态分析"
echo "flutter pub run import_sorter:main # 自动整理导包"

# ------------------------------------------
# 12️⃣⃣ Flutter 工具链
# ------------------------------------------
echo "🔹 12. Flutter 工具链"
echo "flutter pub global activate devtools  # 安装 DevTools"
echo "flutter pub global run devtools      # 启动 DevTools"
echo "dart pub global activate fvm         # Flutter 版本管理工具"
echo "fvm use stable / fvm flutter run     # 使用指定 Flutter 版本"

echo "✅ Flutter 全功能命令大全完成"
echo "提示: 将需要执行的命令复制或写入终端执行即可。"
