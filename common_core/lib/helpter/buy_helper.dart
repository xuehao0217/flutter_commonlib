import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import '../net/dio_utils.dart';
import 'call_back.dart';

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

/// 应用内购买封装（[in_app_purchase]）。宿主在启动时调用 [initialize]，再按需 [loadProducts]；校验由 [VerifyPurchaseCallback] 注入。
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
        if (p is AppStoreProduct2Details) {
          final sub = p.sk2Product.subscription;
          final offers = sub?.promotionalOffers ?? [];
          if (offers.isNotEmpty) {
            _iosProductPriceCache[p.id] = ProductPriceInfo(
              promotionalPrice: offers.first.price,
              originalPrice: p.rawPrice,
              hasPromo: true,
              currencySymbol: p.currencySymbol,
              currencyCode: p.currencyCode,
            );
            debugPrint(
              "iOS 商品缓存 ✅ : ${p.id}, 原价=${_iosProductPriceCache[p.id]?.originalPrice}, 优惠价=${_iosProductPriceCache[p.id]?.promotionalPrice}",
            );
          } else {
            _iosProductPriceCache[p.id] = ProductPriceInfo(
              promotionalPrice: p.rawPrice,
              originalPrice: p.rawPrice,
              hasPromo: false,
              currencySymbol: p.currencySymbol,
              currencyCode: p.currencyCode,
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
  String? getProductPrice(String id,{int fixed=2}) {
    final p = _productCache[id];
    if (p == null) return null;

    final symbol = _currencySymbol(p.currencyCode);
    return "$symbol${p.rawPrice.toStringAsFixed(fixed)}";
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
  String? getMonthlyPrice(String id, {int fixed=2}) {
    final p = _iosProductPriceCache[id];
    if (p == null) return null;
    final monthly = (p.promotionalPrice / 12 * 100).truncateToDouble() / 100.0;
    return "${p.currencySymbol}${monthly.toStringAsFixed(fixed)}/month";
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
  final double promotionalPrice; // 优惠价格
  final double originalPrice;    // 原价
  final bool hasPromo;           // 是否有优惠
  final String currencySymbol;   // 货币符号，例如 "$"
  final String currencyCode;     // 货币代码，例如 "USD"

  ProductPriceInfo({
    required this.promotionalPrice,
    required this.originalPrice,
    this.hasPromo = false,
    this.currencySymbol = "",
    this.currencyCode = "",
  });

  String get promotionalPriceDisplay =>
      "$currencySymbol${_format(promotionalPrice)}";

  String get originalPriceDisplay =>
      "$currencySymbol${_format(originalPrice)}";

  String _format(double value) {
    return NumberFormat("0.##").format(value);
  }
}
