import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

void main() {
  Future<void> _initPurchase() async {
    // 初始化（App 启动时调用一次）
    BuyHelper.instance.initialize(
      onPurchaseResult: (status, details, error) {

      },
    );
    // 查询商品
    await BuyHelper.instance.loadProducts({
      "premier_month_1",
      "premier_month_12",
      "pro_month_1",
      "pro_month_12",
      "starter_month_1",
      "starter_month_12",
    });

    BuyHelper.instance.buy("productId", type: PurchaseType.subscription);
  }
}

enum PurchaseType { consumable, nonConsumable, subscription }

typedef PurchaseResultCallback =
    void Function(
      PurchaseStatus status,
      PurchaseDetails? details,
      String? error,
    );

class BuyHelper {
  /// 单例
  static final BuyHelper instance = BuyHelper._internal();

  BuyHelper._internal();

  late final InAppPurchase _inAppPurchase;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  final Map<String, ProductDetails> _productCache = {};
  bool _isPurchasing = false;
  PurchaseResultCallback? _onPurchaseResult;

  /// 初始化
  Future<void> initialize({PurchaseResultCallback? onPurchaseResult}) async {
    _inAppPurchase = InAppPurchase.instance;
    _onPurchaseResult = onPurchaseResult;

    debugPrint("BuyHelper: 初始化内购...");
    final available = await _inAppPurchase.isAvailable();
    if (!available) {
      _notifyResult(PurchaseStatus.error, null, 'Store not available');
      return;
    }

    _subscription ??= _inAppPurchase.purchaseStream.listen(
      _handlePurchaseUpdate,
      onError: (error) {
        _notifyResult(PurchaseStatus.error, null, error.toString());
      },
    );

    debugPrint("BuyHelper: 内购监听已启动");
  }

  /// 更新回调
  void setPurchaseCallback(PurchaseResultCallback callback) {
    _onPurchaseResult = callback;
  }

  /// 查询商品
  Future<void> loadProducts(Set<String> productIds) async {
    debugPrint("BuyHelper: 查询商品 productIds = $productIds");
    try {
      final response = await _inAppPurchase.queryProductDetails(productIds);
      if (response.error != null) {
        _notifyResult(PurchaseStatus.error, null, response.error!.message);
        return;
      }

      if (response.productDetails.isEmpty) {
        _notifyResult(PurchaseStatus.error, null, 'No products found');
        return;
      }

      for (var p in response.productDetails) {
        _productCache[p.id] = p;
        debugPrint("BuyHelper: 缓存商品 ${p.id} 价格=${p.price}");
      }
    } catch (e) {
      _notifyResult(PurchaseStatus.error, null, e.toString());
    }
  }

  /// 发起购买
  Future<void> buy(String productId, {required PurchaseType type}) async {
    if (_isPurchasing) {
      _notifyResult(PurchaseStatus.error, null, 'Another purchase in progress');
      return;
    }

    final product = _productCache[productId];
    if (product == null) {
      _notifyResult(
        PurchaseStatus.error,
        null,
        'Product not found: $productId',
      );
      return;
    }

    _isPurchasing = true;

    try {
      final param = PurchaseParam(productDetails: product);
      switch (type) {
        case PurchaseType.consumable:
          await _inAppPurchase.buyConsumable(
            purchaseParam: param,
            autoConsume: true,
          );
          break;
        case PurchaseType.nonConsumable:
        case PurchaseType.subscription:
          await _inAppPurchase.buyNonConsumable(purchaseParam: param);
          break;
      }
    } catch (e) {
      _notifyResult(PurchaseStatus.error, null, e.toString());
      _isPurchasing = false;
    }
  }

  /// 恢复购买
  Future<void> restorePurchases() async {
    try {
      await _inAppPurchase.restorePurchases();
    } catch (e) {
      _notifyResult(PurchaseStatus.error, null, e.toString());
    }
  }

  /// 购买流处理
  Future<void> _handlePurchaseUpdate(List<PurchaseDetails> detailsList) async {
    for (var purchase in detailsList) {
      switch (purchase.status) {
        case PurchaseStatus.pending:
          _notifyResult(PurchaseStatus.pending, purchase, null);
          break;
        case PurchaseStatus.canceled:
          _notifyResult(PurchaseStatus.canceled, purchase, null);
          _isPurchasing = false;
          break;
        case PurchaseStatus.error:
          _notifyResult(
            PurchaseStatus.error,
            purchase,
            purchase.error?.message,
          );
          _isPurchasing = false;
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          _notifyResult(purchase.status, purchase, null);
          await _verifyPurchase(purchase);
          if (purchase.pendingCompletePurchase) {
            await _inAppPurchase.completePurchase(purchase);
          }
          _isPurchasing = false;
          break;
      }
    }
  }

  Future<void> _verifyPurchase(PurchaseDetails details) async {
    if (Platform.isAndroid) {
      debugPrint("BuyHelper: Android 验证购买 (预留)");
    } else if (Platform.isIOS) {
      debugPrint(
        "BuyHelper: iOS 验证购买 ${details.verificationData.serverVerificationData}",
      );
    }
  }

  /// 回调封装
  void _notifyResult(
    PurchaseStatus status,
    PurchaseDetails? details,
    String? error,
  ) {
    debugPrint(
      "BuyHelper: 回调 status=$status, product=${details?.productID}, error=$error",
    );
    _onPurchaseResult?.call(status, details, error);
  }

  /// 获取格式化价格
  String? getProductPrice(String productId) {
    final product = _productCache[productId];
    if (product == null) return null;

    final price = product.rawPrice.toStringAsFixed(2);
    final symbol = _currencySymbol(product.currencyCode);
    return "$symbol$price";
  }

  /// 如果需要原始数值 + 货币代码
  double? getRawPrice(String productId) {
    final product = _productCache[productId];
    return product?.rawPrice;
  }

  /// 币种符号
  static String _currencySymbol(String? code) {
    switch (code) {
      case "USD":
        return "\$";
      case "CNY":
        return "¥";
      case "EUR":
        return "€";
      case "GBP":
        return "£";
      case "JPY":
        return "¥";
      case "KRW":
        return "₩";
      case "RUB":
        return "₽";
      case "INR":
        return "₹";
      case "BRL":
        return "R\$";
      case "AUD":
        return "A\$";
      case "CAD":
        return "C\$";
      case "HKD":
        return "HK\$";
      case "TWD":
        return "NT\$";
      case "SGD":
        return "S\$";
      case "THB":
        return "฿";
      case "MXN":
        return "Mex\$";
      default:
        return code ?? "";
    }
  }

  /// 释放资源
  Future<void> dispose() async {
    await _subscription?.cancel();
    _subscription = null;
  }
}
