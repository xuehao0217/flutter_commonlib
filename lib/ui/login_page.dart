import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_commonlib/settings/locale_theme_controller.dart';
import 'package:get/get.dart';

import '../auth/auth_service.dart';
import '../router/router_config.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _accountCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _accountCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!LocaleThemeController.to.isAppleDesign) {
      if (!(_formKey.currentState?.validate() ?? false)) return;
    } else {
      if (_accountCtrl.text.trim().isEmpty) {
        SmartDialog.showToast('请输入账号');
        return;
      }
      if (_passwordCtrl.text.isEmpty) {
        SmartDialog.showToast('请输入密码');
        return;
      }
    }
    setState(() => _busy = true);
    try {
      await AuthService.to.login(
        _accountCtrl.text.trim(),
        _passwordCtrl.text,
      );
      if (!mounted) return;
      final raw = Get.arguments;
      String? nextRoute;
      if (raw is Map) {
        final v = raw[AuthService.afterLoginRouteArg];
        if (v is String && v.isNotEmpty) nextRoute = v;
      }
      if (nextRoute != null) {
        Get.offNamed(nextRoute);
      } else {
        Get.offAllNamed(RouterUrlConfig.main);
      }
    } on ArgumentError catch (e) {
      SmartDialog.showToast(e.message ?? '校验失败');
    } catch (e) {
      SmartDialog.showToast('登录失败：$e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (LocaleThemeController.to.isAppleDesign) {
        return _buildCupertino(context);
      }
      return _buildMaterial(context);
    });
  }

  Widget _buildMaterial(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(Icons.lock_outline_rounded,
                        size: 56, color: cs.primary),
                    const SizedBox(height: 20),
                    Text(
                      '登录',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Demo：任意非空账号密码即可进入',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _accountCtrl,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.username],
                      decoration: const InputDecoration(
                        labelText: '账号',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? '请输入账号' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordCtrl,
                      obscureText: true,
                      onFieldSubmitted: (_) => _submit(),
                      autofillHints: const [AutofillHints.password],
                      decoration: const InputDecoration(
                        labelText: '密码',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) =>
                          (v == null || v.isEmpty) ? '请输入密码' : null,
                    ),
                    const SizedBox(height: 28),
                    FilledButton(
                      onPressed: _busy ? null : _submit,
                      child: _busy
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('登 录'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCupertino(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('登录'),
        backgroundColor: cs.surface.withValues(alpha: 0.92),
      ),
      child: Material(
        color: cs.surface,
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              const SizedBox(height: 24),
              Icon(CupertinoIcons.lock_shield, size: 64, color: cs.primary),
              const SizedBox(height: 20),
              Text(
                '欢迎回来',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Demo：任意非空账号密码即可进入',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: cs.onSurfaceVariant,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 28),
              CupertinoFormSection.insetGrouped(
                backgroundColor: cs.surfaceContainerHigh,
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.zero,
                children: [
                  CupertinoTextField(
                    controller: _accountCtrl,
                    placeholder: '账号',
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    autofocus: false,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.username],
                  ),
                  Container(
                    height: 1,
                    margin: const EdgeInsets.only(left: 16),
                    color: cs.outlineVariant,
                  ),
                  CupertinoTextField(
                    controller: _passwordCtrl,
                    placeholder: '密码',
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    obscureText: true,
                    onSubmitted: (_) => _submit(),
                    autofillHints: const [AutofillHints.password],
                  ),
                ],
              ),
              const SizedBox(height: 28),
              CupertinoButton.filled(
                onPressed: _busy ? null : _submit,
                padding: const EdgeInsets.symmetric(vertical: 14),
                borderRadius: BorderRadius.circular(10),
                child: _busy
                    ? const CupertinoActivityIndicator(
                        color: CupertinoColors.white)
                    : const Text('登录'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
