// tools/gen_exports.dart

import 'dart:io';
import 'package:yaml/yaml.dart';

void main() {
  final pubspecFile = File('pubspec.yaml');
  final lockFile = File('pubspec.lock');

  if (!pubspecFile.existsSync() || !lockFile.existsSync()) {
    stderr.writeln('❌ 请确保在项目根目录执行，并且已运行 flutter pub get');
    exit(1);
  }

  // 1. 解析 pubspec.yaml，取出 dependencies 键
  final pubspec = loadYaml(pubspecFile.readAsStringSync());
  final declaredDeps = <String>{};
  if (pubspec['dependencies'] is YamlMap) {
    declaredDeps.addAll((pubspec['dependencies'] as YamlMap).keys.cast<String>());
  }

  if (declaredDeps.isEmpty) {
    stderr.writeln('⚠️ pubspec.yaml 中没有找到 dependencies');
    exit(1);
  }

  // 2. 解析 pubspec.lock，找出 direct main（运行时依赖）项
  final lockLines = lockFile.readAsLinesSync();
  final directMain = <String>{};
  String? currentPkg;
  String? currentDepKind;

  for (var line in lockLines) {
    final pkgMatch = RegExp(r'^  ([^ :]+):').firstMatch(line);
    if (pkgMatch != null) {
      currentPkg = pkgMatch.group(1);
      currentDepKind = null;
      continue;
    }
    final depKindMatch = RegExp(r'^\s{4}dependency: "([^"]+)"').firstMatch(line);
    if (depKindMatch != null) {
      currentDepKind = depKindMatch.group(1);
      continue;
    }
    if (currentPkg != null && currentDepKind == 'direct main') {
      // 如果在 pubspec.yaml 中声明，则保留
      if (declaredDeps.contains(currentPkg)) {
        directMain.add(currentPkg);
      }
      currentPkg = null; // 重置进入下一个
    }
  }

  if (directMain.isEmpty) {
    stderr.writeln('⚠️ 在 pubspec.lock 中没找到与 pubspec.yaml 对应的 direct main 依赖');
    exit(1);
  }

  // 3. 过滤不想导出的包关键词
  final skipKeywords = [
    '_platform_interface',
    '_web',
    '_android',
    '_ios',
    '_macos',
    '_linux',
    '_windows',
    'test',
    'plugin',
    'lints',
  ];

  bool shouldExport(String pkg) {
    return !skipKeywords.any((kw) => pkg.contains(kw));
  }

  final toExport = directMain.where(shouldExport).toList()..sort();

  // 4. 写入 lib/core_exports.dart
  final buffer = StringBuffer()
    ..writeln('// ⚠️ 本文件由 tools/gen_exports.dart 自动生成，请勿手动修改\n');

  for (var pkg in toExport) {
    buffer.writeln("export 'package:$pkg/$pkg.dart';");
  }

  final outFile = File('lib/core_exports.dart');
  outFile.writeAsStringSync(buffer.toString());

  print('✅ 生成完成 lib/core_exports.dart，共导出 ${toExport.length} 个包：');
  for (var pkg in toExport) {
    print('  • $pkg');
  }
}
