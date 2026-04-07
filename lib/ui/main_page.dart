import 'package:common_core/base/base_stateful_widget.dart';
import 'package:common_core/widget/bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commonlib/l10n/app_localizations.dart';
import 'package:flutter_commonlib/settings/locale_theme_controller.dart';
import 'package:get/get.dart';

import 'home_page.dart';
import 'msg_page.dart';
import 'my_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<StatefulWidget> createState() => _MainPage();
}

class _MainPage extends BaseStatefulWidget with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget buildPageContent(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Obx(() {
      final apple = LocaleThemeController.to.isAppleDesign;
      if (apple) {
        return CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            items: [
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.home),
                activeIcon: Icon(CupertinoIcons.house_fill),
                label: l10n.tabHome,
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.chat_bubble_2),
                activeIcon: Icon(CupertinoIcons.chat_bubble_2_fill),
                label: l10n.tabMessage,
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.person),
                activeIcon: Icon(CupertinoIcons.person_fill),
                label: l10n.tabMine,
              ),
            ],
          ),
          tabBuilder: (context, index) {
            switch (index) {
              case 0:
                return CupertinoTabView(builder: (_) => HomePage());
              case 1:
                return CupertinoTabView(builder: (_) => MsgPage());
              default:
                return CupertinoTabView(builder: (_) => MyPage());
            }
          },
        );
      }

      return BottomNavigationBarWidget(
        bottomNavigationBarItems: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, semanticLabel: l10n.tabHome),
            activeIcon: Icon(Icons.home_rounded, semanticLabel: l10n.tabHome),
            label: l10n.tabHome,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline_rounded,
                semanticLabel: l10n.tabMessage),
            activeIcon:
                Icon(Icons.chat_rounded, semanticLabel: l10n.tabMessage),
            label: l10n.tabMessage,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded,
                semanticLabel: l10n.tabMine),
            activeIcon: Icon(Icons.person_rounded, semanticLabel: l10n.tabMine),
            label: l10n.tabMine,
          ),
        ],
        children: [HomePage(), MsgPage(), MyPage()],
      );
    });
  }

  @override
  bool showTitleBar() => false;

  @override
  bool showStatusBar() => false;

  @override
  bool showNavigationBar() {
    return false;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!kDebugMode) return;
    switch (state) {
      case AppLifecycleState.resumed:
        debugPrint('didChangeAppLifecycleState resumed');
        break;
      case AppLifecycleState.inactive:
        debugPrint('didChangeAppLifecycleState inactive');
        break;
      case AppLifecycleState.paused:
        debugPrint('didChangeAppLifecycleState paused');
        break;
      case AppLifecycleState.detached:
        debugPrint('didChangeAppLifecycleState detached');
        break;
      case AppLifecycleState.hidden:
        debugPrint('didChangeAppLifecycleState hidden');
        break;
    }
  }
}
