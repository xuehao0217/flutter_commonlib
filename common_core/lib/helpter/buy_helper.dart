import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:nb_utils/nb_utils.dart';
import '../net/dio_utils.dart';
import 'call_back.dart';

Future<void> main() async {
  BuyHelper.instance.initialize(
    onPurchaseResult: (status, details, error) {

    },
    verifyPurchase: (details) {
      return HttpUtils.requestNetwork(
        Method.post,
        "verify",
        params: {"jws": details.verificationData.serverVerificationData},
      );
    },
    stateCallBack: (state) {
      if (state == BuyStateType.start) {
        // showLoading();
      } else if (state == BuyStateType.finish) {
        // hideLoading();
      }
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
}

enum PurchaseType { consumable, nonConsumable, subscription }

enum BuyStateType { start, finish }

/// 购买状态回调
typedef PurchaseResultCallback =
    void Function(
      PurchaseStatus? status,
      PurchaseDetails? details,
      String? error,
    );

/// 收据验证回调（需业务侧实现）
typedef VerifyPurchaseCallback = Future<bool> Function(PurchaseDetails details);

class BuyHelper {
  /// 全局唯一实例
  static final BuyHelper instance = BuyHelper._internal();

  BuyHelper._internal();

  late final InAppPurchase _inAppPurchase;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  /// 商品缓存
  final Map<String, ProductDetails> _productCache = {};
  /// 商品优惠价格
  final Map<String, ProductPriceInfo> _iosProductPriceCache = {};

  Map<String, ProductDetails> get allProducts =>
      Map.unmodifiable(_productCache);

  bool _isPurchasing = false;

  PurchaseResultCallback? _onPurchaseResult;
  VerifyPurchaseCallback? _verifyPurchase;
  TArgCallback<BuyStateType>? _stateCallBack;

  // ------------------------ 初始化 ------------------------
  Future<void> initialize({
    PurchaseResultCallback? onPurchaseResult,
    VerifyPurchaseCallback? verifyPurchase,
    TArgCallback<BuyStateType>? stateCallBack,
  }) async {
    _inAppPurchase = InAppPurchase.instance;

    _onPurchaseResult = onPurchaseResult;
    _verifyPurchase = verifyPurchase;
    _stateCallBack = stateCallBack;

    debugPrint("BuyHelper ✅ 初始化内购...");

    final available = await _inAppPurchase.isAvailable();
    debugPrint("BuyHelper ✅ Store available = $available");

    if (!available) {
      _notifyResult(PurchaseStatus.error, null, "Store not available");
      return;
    }

    // 启动监听
    _subscription ??= _inAppPurchase.purchaseStream.listen(
      _handlePurchaseUpdate,
      onError: (error) {
        debugPrint("BuyHelper ❌ purchaseStream error: $error");
        _notifyResult(PurchaseStatus.error, null, error.toString());
      },
    );

    debugPrint("BuyHelper ✅ 内购监听已启动");
  }

  // ------------------------ 商品查询 ------------------------
  Future<void> loadProducts(Set<String> productIds) async {
    debugPrint("BuyHelper ✅ 查询商品 productIds=$productIds");

    try {
      final response = await _inAppPurchase.queryProductDetails(productIds);

      if (response.error != null) {
        debugPrint("BuyHelper ❌ 查询商品失败: ${response.error!.message}");
        _notifyResult(PurchaseStatus.error, null, response.error!.message);
        return;
      }

      if (response.productDetails.isEmpty) {
        debugPrint("BuyHelper ⚠️ 查询结果为空");
        _notifyResult(PurchaseStatus.error, null, "No products found");
        return;
      }

      for (final p in response.productDetails) {
        _productCache[p.id] = p;
        // 处理 iOS 优惠价
        if (p is AppStoreProduct2Details) {
          final sub = p.sk2Product.subscription;
          final offers = sub?.promotionalOffers ?? [];
          if (offers.isNotEmpty) {
            _iosProductPriceCache[p.id] = ProductPriceInfo(
              displayPrice: "${p.currencySymbol}${offers.first.price}",
              originalPrice: p.price,
              hasPromo: true,
            );
            debugPrint(
                "iOS 商品缓存 ✅ : ${p.id}, 原价=${_iosProductPriceCache[p.id]?.originalPrice}, 优惠价=${_iosProductPriceCache[p.id]?.displayPrice}"
            );
          }else{
            _iosProductPriceCache[p.id] = ProductPriceInfo(
              displayPrice: p.price,
              originalPrice: p.price,
              hasPromo: false,
            );
          }
        }
        debugPrint("BuyHelper ✅ 商品缓存: ${p.id}, price=${p.price}");
      }
    } catch (e) {
      debugPrint("BuyHelper ❌ 查询商品异常: $e");
      _notifyResult(PurchaseStatus.error, null, e.toString());
    }
  }

  // ------------------------ 发起购买 ------------------------
  Future<void> buy(String productId, {required PurchaseType type}) async {
    if (_isPurchasing) {
      _notifyResult(PurchaseStatus.error, null, "Another purchase in progress");
      return;
    }
    _stateCallBack?.call(BuyStateType.start);

    _isPurchasing = true;
    debugPrint("BuyHelper ▶️ 发起购买: $productId type=$type");

    try {
      final product = _productCache[productId];
      if (product == null) {
        _notifyResult(PurchaseStatus.error, null, "Product not found");
        return;
      }

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
    } finally {
      _stateCallBack?.call(BuyStateType.finish);
      _isPurchasing = false;
    }
  }

  // ------------------------ 恢复购买 ------------------------
  Future<void> restorePurchases() async {
    debugPrint("BuyHelper ▶️ restorePurchases()");
    try {
      await _inAppPurchase.restorePurchases();
    } catch (e) {
      _notifyResult(PurchaseStatus.error, null, e.toString());
    }
  }

  // ------------------------ 处理购买状态 ------------------------
  Future<void> _handlePurchaseUpdate(List<PurchaseDetails> list) async {
    for (final purchase in list) {
      debugPrint(
        "BuyHelper 🔄 处理购买状态：${purchase.productID} status=${purchase.status}",
      );

      _notifyResult(purchase.status, purchase, null);

      switch (purchase.status) {
        case PurchaseStatus.pending:
          break;

        case PurchaseStatus.canceled:
        case PurchaseStatus.error:
          _stateCallBack?.call(BuyStateType.finish); // ✅ 新增
          _isPurchasing = false;
          break;

        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          await _processVerifiedPurchase(purchase);
          break;
      }
    }
  }

  
  // ------------------------ 外部验证 + 完成交易 ------------------------
  Future<void> _processVerifiedPurchase(PurchaseDetails purchase) async {
    bool verified = false;

    if (_verifyPurchase != null) {
      verified = await _verifyPurchase!(purchase);
    } else {
      verified = true; // 默认全部验证成功
    }

    debugPrint(
      "BuyHelper ✅ verified=$verified pendingCompletePurchase=${purchase.pendingCompletePurchase}",
    );

    if (verified) {
      if (purchase.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchase);
        debugPrint("BuyHelper ✅ completePurchase 调用完成");
      } else {
        debugPrint("BuyHelper ⚠️ 无需 completePurchase（系统已自动处理）");
      }
    }

    _stateCallBack?.call(BuyStateType.finish);
    _isPurchasing = false;
  }

  // ------------------------ 回调事件 ------------------------
  void _notifyResult(
    PurchaseStatus status,
    PurchaseDetails? details,
    String? error,
  ) {
    debugPrint(
      "BuyHelper 🔔 回调状态：$status, product=${details?.productID}, error=$error",
    );
    _onPurchaseResult?.call(status, details, error);
  }

  // ------------------------ 释放资源 ------------------------
  Future<void> dispose() async {
    await _subscription?.cancel();
    _subscription = null;
    debugPrint("BuyHelper ✅ dispose()");
  }

  // ------------------------ 价格工具 ------------------------
  /// 获取指定商品的本地化价格字符串
  ///
  /// - 根据商品 ID 从缓存中读取 [ProductDetails]
  /// - 使用 `_currencySymbol` 转换货币符号（支持 USD、CNY、JPY、EUR、GBP 等）
  /// - 格式化价格为两位小数
  ///
  /// 示例：
  /// ```dart
  /// BuyHelper.instance.getProductPrice("premium_1year"); // 输出示例: ¥68.00
  /// ```
  ///
  /// 返回：
  /// - 格式化后的价格字符串，例如 `$4.99`、`¥68.00`
  /// - 若未查询到商品则返回 `null`
  String? getProductPrice(String id) {
    final p = _productCache[id];
    if (p == null) return null;

    final symbol = _currencySymbol(p.currencyCode);
    return "$symbol${p.rawPrice.toStringAsFixed(2)}";
  }

  /// 获取指定商品的“月均价”字符串（常用于年订阅显示）
  ///
  /// - 默认将总价平均分为 12 个月，可通过 [months] 参数自定义
  /// - 例如：`¥120.00` 按 12 个月拆分后输出 `¥10.00/month`
  ///
  /// 示例：
  /// ```dart
  /// BuyHelper.instance.getMonthlyPrice("premium_1year"); // 输出: ¥10.00/month
  /// ```
  ///
  /// 返回：
  /// - 格式化的月均价格字符串，例如 `$0.99/month`
  /// - 若商品未找到则返回 `null`
  String? getMonthlyPrice(String id, {int months = 12}) {
    final p = _productCache[id];
    if (p == null) return null;

    // 保留两位小数，防止精度问题
    final monthly = (p.rawPrice / months * 100).truncateToDouble() / 100.0;

    final symbol = _currencySymbol(p.currencyCode);
    return "$symbol${monthly.toStringAsFixed(2)}/month";
  }

  /// 将货币代码（ISO 4217）转换为对应的符号
  ///
  /// - 常见货币包括：
  ///   - USD → `$`
  ///   - CNY / JPY → `¥`
  ///   - EUR → `€`
  ///   - GBP → `£`
  /// - 未知货币返回原始代码
  ///
  /// 示例：
  /// ```dart
  /// _currencySymbol("USD"); // "$"
  /// _currencySymbol("JPY"); // "¥"
  /// _currencySymbol("KRW"); // "KRW"
  /// ```
  static String _currencySymbol(String? code) {
    switch (code) {
      case "USD":
        return "\$";
      case "CNY":
      case "JPY":
        return "¥";
      case "EUR":
        return "€";
      case "GBP":
        return "£";
      default:
        return code ?? '';
    }
  }

  /// 获取价格信息
  /// 返回 PriceInfo 对象
  ProductPriceInfo? getIOSPriceInfo(String productId) {
    return _iosProductPriceCache[productId];
  }


  Future<void> showOfferCodeRedemptionSheet() async {
    if (isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
      _inAppPurchase
          .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.presentCodeRedemptionSheet();
      debugPrint("BuyHelper ▶️ 打开 iOS Offer Code 界面");
    }}
}


class ProductPriceInfo {
  final String displayPrice; //（优惠/免费试用优先）
  final String originalPrice; // 原价
  final bool hasPromo; // 是否有优惠

  ProductPriceInfo({
    required this.displayPrice,
    required this.originalPrice,
    this.hasPromo = false,
  });
}
