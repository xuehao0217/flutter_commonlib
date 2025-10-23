import 'package:flutter/cupertino.dart';

void main(){
  // 配置 WebView 右侧标题内容
  WebBuildConfig().setRightTitleBuilder((context, url) {
    if (url.contains("baidu")) {
      return Row();
    }
    return Row(); // 默认空
  });
}

/// 单例 WebBuildConfig
class WebBuildConfig {
  WebBuildConfig._privateConstructor();

  static final WebBuildConfig _instance = WebBuildConfig._privateConstructor();

  factory WebBuildConfig() => _instance;

  /// 回调类型：传入 context 和当前 url，返回 Widget
  Widget Function(BuildContext context, String url)? rightTitleBuilder;

  /// 设置右侧标题内容回调
  void setRightTitleBuilder(Widget Function(BuildContext context, String url) builder) {
    rightTitleBuilder = builder;
  }

  /// 获取右侧标题 Widget
  Widget buildRightTitleContent(BuildContext context, String url) {
    if (rightTitleBuilder != null) {
      return rightTitleBuilder!(context, url);
    }
    return Row(); // 默认空
  }

}

