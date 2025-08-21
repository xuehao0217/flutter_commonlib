import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

enum PurchaseType {
  consumable,       // 消耗型商品
  nonConsumable,    // 非消耗型商品（一次性购买）
  subscription,     // 订阅商品
}

/// 内购购买结果回调
typedef PurchaseResultCallback = void Function(
    PurchaseStatus status,
    PurchaseDetails? details,
    String? error,
    );

class BuyHelper {
  /// 全局唯一实例
  static final BuyHelper instance = BuyHelper._internal();

  /// 私有构造函数
  BuyHelper._internal();

  late final InAppPurchase _inAppPurchase;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  final Map<String, ProductDetails> _productCache = {};
  bool _isPurchasing = false;

  PurchaseResultCallback? _onPurchaseResult;

  /// 初始化内购（应用启动时调用一次）
  Future<void> initialize({PurchaseResultCallback? onPurchaseResult}) async {
    _inAppPurchase = InAppPurchase.instance;
    _onPurchaseResult = onPurchaseResult;

    debugPrint("BuyHelper: 初始化内购...");

    final available = await _inAppPurchase.isAvailable();
    debugPrint("BuyHelper: Store available = $available");
    if (!available) {
      _notifyResult(PurchaseStatus.error, null, 'Store not available');
      return;
    }

    _subscription ??= _inAppPurchase.purchaseStream.listen(
      _handlePurchaseUpdate,
      onError: (error) {
        debugPrint("BuyHelper: purchaseStream error = $error");
        _notifyResult(PurchaseStatus.error, null, error.toString());
      },
    );
    debugPrint("BuyHelper: 内购监听已启动");
  }

  /// 设置或更新购买回调
  void setPurchaseCallback(PurchaseResultCallback callback) {
    _onPurchaseResult = callback;
    debugPrint("BuyHelper: 回调已更新");
  }

  /// 查询商品
  Future<void> loadProducts(Set<String> productIds) async {
    debugPrint("BuyHelper: 查询商品 productIds = $productIds");
    try {
      final response = await _inAppPurchase.queryProductDetails(productIds);
      if (response.error != null) {
        debugPrint("BuyHelper: 查询商品失败 error = ${response.error!.message}");
        _notifyResult(PurchaseStatus.error, null, response.error!.message);
        return;
      }
      if (response.productDetails.isEmpty) {
        debugPrint("BuyHelper: 查询结果为空");
        _notifyResult(PurchaseStatus.error, null, 'No products found');
        return;
      }

      for (var p in response.productDetails) {
        _productCache[p.id] = p;
        debugPrint("BuyHelper: 缓存商品 ${p.id}, title=${p.title}, price=${p.price}");
      }
    } catch (e) {
      debugPrint("BuyHelper: 查询商品异常 = $e");
      _notifyResult(PurchaseStatus.error, null, e.toString());
    }
  }

  /// 发起购买
  Future<void> buy(String productId, {required PurchaseType type}) async {
    debugPrint("BuyHelper: 尝试购买 productId = $productId, type = $type");
    if (_isPurchasing) {
      debugPrint("BuyHelper: 已有购买进行中，拒绝本次请求");
      _notifyResult(PurchaseStatus.error, null, 'Another purchase in progress');
      return;
    }
    _isPurchasing = true;

    try {
      final product = _productCache[productId];
      if (product == null) {
        debugPrint("BuyHelper: 商品未缓存: $productId");
        _notifyResult(PurchaseStatus.error, null, 'Product not found: $productId');
        return;
      }

      final param = PurchaseParam(productDetails: product);
      debugPrint("BuyHelper: 发起购买 param = $param");

      switch (type) {
        case PurchaseType.consumable:
          await _inAppPurchase.buyConsumable(
            purchaseParam: param,
            autoConsume: true,
          );
          debugPrint("BuyHelper: buyConsumable 调用完成");
          break;
        case PurchaseType.nonConsumable:
        case PurchaseType.subscription:
          await _inAppPurchase.buyNonConsumable(purchaseParam: param);
          debugPrint("BuyHelper: buyNonConsumable 调用完成");
          break;
      }
    } catch (e) {
      debugPrint("BuyHelper: 购买异常 = $e");
      _notifyResult(PurchaseStatus.error, null, e.toString());
    } finally {
      _isPurchasing = false;
    }
  }

  /// 恢复购买
  Future<void> restorePurchases() async {
    debugPrint("BuyHelper: restorePurchases 调用");
    try {
      await _inAppPurchase.restorePurchases();
      debugPrint("BuyHelper: restorePurchases 成功触发");
    } catch (e) {
      debugPrint("BuyHelper: restorePurchases 异常 = $e");
      _notifyResult(PurchaseStatus.error, null, e.toString());
    }
  }

  /// 处理购买更新
  Future<void> _handlePurchaseUpdate(List<PurchaseDetails> detailsList) async {
    debugPrint("BuyHelper: purchaseStream 更新: $detailsList");
    for (var purchase in detailsList) {
      debugPrint("BuyHelper: 处理购买状态 ${purchase.status} for ${purchase.productID}");
      switch (purchase.status) {
        case PurchaseStatus.pending:
          _notifyResult(PurchaseStatus.pending, purchase, null);
          break;
        case PurchaseStatus.canceled:
          _notifyResult(PurchaseStatus.canceled, purchase, null);
          _isPurchasing = false;
          break;
        case PurchaseStatus.error:
          _notifyResult(PurchaseStatus.error, purchase, purchase.error?.message);
          _isPurchasing = false;
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          _notifyResult(purchase.status, purchase, null);

          debugPrint("BuyHelper: 验证购买 ${purchase.productID}");
          if (Platform.isAndroid) {
            await _verifyAndroidPurchase(purchase);
          } else if (Platform.isIOS) {
            await _verifyIOSPurchase(purchase);
          }

          if (purchase.pendingCompletePurchase) {
            await _inAppPurchase.completePurchase(purchase);
            debugPrint("BuyHelper: completePurchase 调用完成");
          }
          _isPurchasing = false;
          break;
      }
    }
  }

  Future<void> _verifyAndroidPurchase(PurchaseDetails details) async {
    debugPrint("BuyHelper: Android 收据验证 (预留)");
  }

  Future<void> _verifyIOSPurchase(PurchaseDetails details) async {
    debugPrint("BuyHelper: iOS 收据验证 (预留) ${details.verificationData.serverVerificationData} --------- ${details.verificationData.localVerificationData}");
  }

  void _notifyResult(PurchaseStatus status, PurchaseDetails? details, String? error) {
    debugPrint("BuyHelper: 触发回调 status=$status, product=${details?.productID}, error=$error");
    _onPurchaseResult?.call(status, details, error);
  }

  /// 释放资源
  Future<void> dispose() async {
    debugPrint("BuyHelper: dispose 调用");
    await _subscription?.cancel();
    _subscription = null;
  }



  // /// 根据 productId 获取价格（格式化后的字符串，如 "US$18.00"）
  // String? getProductPrice(String productId) {
  //   final product = _productCache[productId];
  //   return product?.price; // 已经是本地化后的价格字符串
  // }


  /// 获取格式化价格（金额 + 货币符号，不带国家码）
  String? getProductPrice(String productId) {
    final product = _productCache[productId];
    if (product == null) return null;

    final price = product.rawPrice.toStringAsFixed(2); // 金额保留两位小数
    final symbol = _currencySymbol(product.currencyCode);
    return "$symbol$price";
  }

  /// 辅助方法：根据 currencyCode 返回货币符号
  static String _currencySymbol(String? code) {
    switch (code) {
      case "USD": return "\$";   // 美元
      case "CNY": return "¥";    // 人民币
      case "EUR": return "€";    // 欧元
      case "GBP": return "£";    // 英镑
      case "JPY": return "¥";    // 日元
      case "KRW": return "₩";    // 韩元
      case "RUB": return "₽";    // 卢布
      case "INR": return "₹";    // 印度卢比
      case "BRL": return "R\$";  // 巴西雷亚尔
      case "AUD": return "A\$";  // 澳元
      case "CAD": return "C\$";  // 加元
      case "HKD": return "HK\$"; // 港币
      case "TWD": return "NT\$"; // 新台币
      case "SGD": return "S\$";  // 新加坡元
      case "THB": return "฿";    // 泰铢
      case "MXN": return "Mex\$"; // 墨西哥比索
      default: return code ?? ""; // 找不到就返回货币码本身
    }
  }

}
