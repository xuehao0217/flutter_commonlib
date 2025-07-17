import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import '../style/theme.dart';
import 'base_page_widget.dart';


abstract class BaseStatelessWidget extends StatelessWidget with BaseWidgetMixin {
  const BaseStatelessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    changeStatusBarColor(
      iconBrightness: isDarkMode() ? Brightness.light : Brightness.dark,
    );
    return buildCommonStructure(
      context: context,
      content: buildContent(context),
    );
  }

  /// 子类实现
  Widget buildContent(BuildContext context);
}