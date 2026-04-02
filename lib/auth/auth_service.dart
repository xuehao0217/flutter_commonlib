import 'package:common_core/helpter/sp_helper.dart';
import 'package:get/get.dart';

import '../router/router_config.dart';

/// 登录态（示例：本地 token；可替换为真实接口返回的 accessToken）。
class AuthService extends GetxService {
  static AuthService get to => Get.find<AuthService>();

  static const _tokenKey = 'flutter_commonlib_auth_token';

  /// 登录页 [Get.arguments] 中的 key：登录成功后优先 [Get.offNamed] 到该路由。
  static const afterLoginRouteArg = 'afterLoginRoute';

  /// 仅对需要门控的入口调用：已登录则直达 [targetRoute]，否则先打开登录页并带上回跳参数。
  static void openWithLoginGateIfNeeded(String targetRoute) {
    final auth = Get.find<AuthService>();
    if (auth.isLoggedIn.value) {
      Get.toNamed(targetRoute);
      return;
    }
    Get.toNamed(
      RouterUrlConfig.login,
      arguments: {afterLoginRouteArg: targetRoute},
    );
  }

  final isLoggedIn = false.obs;

  /// 须在 [CommonCore.init] 完成 [SPUtil.init] 之后调用。
  Future<AuthService> init() async {
    final t = await SPUtil.getString(_tokenKey, defaultValue: '');
    isLoggedIn.value = t.isNotEmpty;
    return this;
  }

  /// Demo：账号密码非空即视为成功。对接后端时在发请求成功后 [SPUtil.putString] 写入 token。
  Future<void> login(String account, String password) async {
    if (account.isEmpty || password.isEmpty) {
      throw ArgumentError('请输入账号和密码');
    }
    await SPUtil.putString(_tokenKey, 'demo:$account');
    isLoggedIn.value = true;
  }

  Future<void> logout() async {
    await SPUtil.remove(_tokenKey);
    isLoggedIn.value = false;
    Get.offAllNamed(RouterUrlConfig.main);
  }

  /// 仅 Demo：清 token、视为未登录，**不**改当前路由（留在首页测门控）。
  Future<void> clearSessionKeepNavigation() async {
    await SPUtil.remove(_tokenKey);
    isLoggedIn.value = false;
  }

  /// 仅 Demo：写入占位 token，视为已登录（不经过登录页）。
  Future<void> markLoggedInForDemo() async {
    await SPUtil.putString(_tokenKey, 'demo_switch_on');
    isLoggedIn.value = true;
  }
}
