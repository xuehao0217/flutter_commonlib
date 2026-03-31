import 'package:common_core/base/base_stateful_widget.dart';
import 'package:common_core/widget/bottom_navigation_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commonlib/l10n/app_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

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
    initialization();
    WidgetsBinding.instance.addObserver(this);
  }

  void initialization() async {
    FlutterNativeSplash.remove();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget buildPageContent(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BottomNavigationBarWidget(
      bottomNavigationBarItems: [
        BottomNavigationBarItem(
          icon: Semantics(
            label: l10n.tabHome,
            button: true,
            child: const Icon(Icons.home),
          ),
          label: l10n.tabHome,
        ),
        BottomNavigationBarItem(
          icon: Semantics(
            label: l10n.tabMessage,
            button: true,
            child: const Icon(Icons.message_rounded),
          ),
          label: l10n.tabMessage,
        ),
        BottomNavigationBarItem(
          icon: Semantics(
            label: l10n.tabMine,
            button: true,
            child: const Icon(Icons.people),
          ),
          label: l10n.tabMine,
        ),
      ],
      children: [HomePage(), MsgPage(), MyPage()],
    );
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
