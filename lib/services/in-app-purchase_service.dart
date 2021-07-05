import 'dart:convert';
import 'dart:io' show Platform;
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:pdoc/constants.dart';

//import for GooglePlayProductDetails
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

//import for SkuDetailsWrapper
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:rxdart/rxdart.dart';

class InAppPurchaseService {
  final PublishSubject<List<PurchaseDetails>> _purchaseSubject = PublishSubject();

  InAppPurchase _iap = InAppPurchase.instance;

  InAppPurchaseService() {
    // In App Purchase plugin does not provide functionality to wait for restorePurchase() response;
    // This subject is created to wait until new data is emitted to purchaseStream by using _getNewPurchaseDetails()
    _iap.purchaseStream.listen((event) {
      _purchaseSubject.add(event);
    });
  }

  Future<bool> get isAvailable => _iap.isAvailable();

  Future<List<ProductDetails>> getProducts() async {
    ProductDetailsResponse response = await _iap.queryProductDetails(InAppPurchaseConstants.productIds);
    return response.productDetails;
  }

  Future<List<PurchaseDetails>> getPastPurchases() async {
    final List<PurchaseDetails> purchases = await restorePurchases();

    if (Platform.isIOS) {
      for (var purchase in purchases) {
        _iap.completePurchase(purchase);
      }
    }

    return purchases;
  }

  Future<List<PurchaseDetails>> restorePurchases() async {
    await _iap.restorePurchases();
    final List<PurchaseDetails> purchases = await _getNewPurchaseDetails();
    return purchases;
  }

  PurchaseDetails? hasPurchased({
    required String productId,
    required List<PurchaseDetails> purchases,
    required String userId,
  }) {
    PurchaseDetails? purchase;
    try {
      purchase = purchases.firstWhere((purchase) {
        final bool isIdMatched = purchase.productID == productId;
        final bool isStatusValid = _isPurchasedStatusValid(purchase: purchase);
        final bool isUserIdMatched =
            jsonDecode(purchase.verificationData.localVerificationData)["obfuscatedAccountId"] == userId;

        return isIdMatched && isStatusValid && isUserIdMatched;
      });
    } catch (e) {}
    return purchase;
  }

  Future<List<PurchaseDetails>?> buyProduct({
    required ProductDetails product,
    required String userId,
  }) async {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product, applicationUserName: userId);
    _iap.buyNonConsumable(purchaseParam: purchaseParam);
    final List<PurchaseDetails> newPurchases = await _getNewPurchaseDetails();
    return newPurchases;
  }

  Future<List<PurchaseDetails>?> buySubscription({
    required ProductDetails product,
    required String userId,
  }) async {
    final List<PurchaseDetails> purchases = await getPastPurchases();

    PurchaseDetails? oldPurchaseDetails;

    try {
      oldPurchaseDetails = purchases.firstWhere((purchase) => _isPurchasedStatusValid(purchase: purchase));
    } catch (e) {
      return await buyProduct(product: product, userId: userId);
    }

    if (oldPurchaseDetails is GooglePlayPurchaseDetails) {
      return await _upgradeGooglePlaySubscription(
        product: product,
        userId: userId,
        oldPurchaseDetails: oldPurchaseDetails,
      );
    }

    return null;
  }

  // TODO: IOS
  Future<List<PurchaseDetails>?> _upgradeGooglePlaySubscription({
    required ProductDetails product,
    required String userId,
    required PurchaseDetails oldPurchaseDetails,
  }) async {
    final GooglePlayPurchaseDetails oldGooglePlayPurchaseDetails = oldPurchaseDetails as GooglePlayPurchaseDetails;

    PurchaseParam purchaseParam = GooglePlayPurchaseParam(
      productDetails: product,
      applicationUserName: userId,
      changeSubscriptionParam: ChangeSubscriptionParam(
        oldPurchaseDetails: oldGooglePlayPurchaseDetails,
        // TODO: Think about best downgrade/upgrade method
        prorationMode: ProrationMode.immediateWithTimeProration,
      ),
    );

    await _iap.buyNonConsumable(purchaseParam: purchaseParam);

    final List<PurchaseDetails> newPurchases = await _getNewPurchaseDetails();

    return newPurchases;
  }

  bool _isPurchasedStatusValid({required PurchaseDetails purchase}) {
    return purchase.status == PurchaseStatus.purchased || purchase.status == PurchaseStatus.restored;
  }

  Future<List<PurchaseDetails>> _getNewPurchaseDetails() async {
    final List<PurchaseDetails> purchases = await _purchaseSubject.first;
    return purchases;
  }
}
