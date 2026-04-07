import 'package:common_core/base/mvvm/base_vm_stateful_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commonlib/settings/locale_theme_controller.dart';
import 'package:flutter_commonlib/ui/vm/home_view_model.dart';
import 'package:get/get.dart';

class MsgPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MsgPage();
}

class _MsgPage extends BaseVMStatefulWidget<MsgPage, HomeViewModel> {
  static const _tabs = ['动态', '关注', '系统', '通知'];

  int _segment = 0;

  @override
  String setTitle() => '消息';

  @override
  bool showTitleBar() => false;

  @override
  Color setStatusBarColor() => Colors.transparent;

  @override
  HomeViewModel createViewModel() => HomeViewModel();

  @override
  void initData() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) showToast('消息列表已刷新');
    });
  }

  @override
  Widget buildPageContent(BuildContext context) {
    return Obx(() {
      if (LocaleThemeController.to.isAppleDesign) {
        return _buildApple(context);
      }
      return _buildMaterial(context);
    });
  }

  Widget _buildApple(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ColoredBox(
      color: cs.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: CupertinoSlidingSegmentedControl<int>(
              groupValue: _segment,
              thumbColor: cs.surfaceContainerHigh,
              backgroundColor: cs.surfaceContainerHighest,
              onValueChanged: (v) {
                if (v != null) setState(() => _segment = v);
              },
              children: {
                for (var i = 0; i < _tabs.length; i++)
                  i: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Text(
                      _tabs[i],
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ),
              },
            ),
          ),
          Expanded(
            child: _MessageTabBody(
              index: _segment,
              label: _tabs[_segment],
              colorScheme: cs,
              appleStyle: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaterial(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return DefaultTabController(
      length: _tabs.length,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: cs.surfaceContainerHighest,
            child: TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              labelStyle: tt.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              unselectedLabelStyle: tt.bodyMedium,
              labelColor: cs.primary,
              unselectedLabelColor: cs.onSurfaceVariant,
              indicatorColor: cs.primary,
              indicatorWeight: 3,
              tabs: [for (final t in _tabs) Tab(text: t)],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                for (var i = 0; i < _tabs.length; i++)
                  _MessageTabBody(
                    index: i,
                    label: _tabs[i],
                    colorScheme: cs,
                    appleStyle: false,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageTabBody extends StatelessWidget {
  const _MessageTabBody({
    required this.index,
    required this.label,
    required this.colorScheme,
    required this.appleStyle,
  });

  final int index;
  final String label;
  final ColorScheme colorScheme;
  final bool appleStyle;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              appleStyle
                  ? CupertinoIcons.chat_bubble_2
                  : Icons.forum_outlined,
              size: 56,
              color: colorScheme.outlineVariant,
            ),
            const SizedBox(height: 16),
            Text(
              label,
              style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              appleStyle
                  ? '暂无消息 · 分段 ${index + 1}'
                  : '暂无消息 · Tab ${index + 1}',
              textAlign: TextAlign.center,
              style: tt.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
