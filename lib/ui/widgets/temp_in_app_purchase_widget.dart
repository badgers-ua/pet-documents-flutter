import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:pdoc/services/in-app-purchase_service.dart';

import '../../locator.dart';

class TempInAppPurchaseWidget extends StatefulWidget {
  final String userId;

  const TempInAppPurchaseWidget({
    required this.userId,
    Key? key,
  }) : super(key: key);

  @override
  _TempInAppPurchaseWidgetState createState() => _TempInAppPurchaseWidgetState();
}

class _TempInAppPurchaseWidgetState extends State<TempInAppPurchaseWidget> {
  final InAppPurchaseService _iapService = locator<InAppPurchaseService>();

  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];

  _load() async {
    final bool _available = await _iapService.isAvailable;

    if (!_available) {
      return;
    }

    final products = await _iapService.getProducts();
    final purchases = await _iapService.getPastPurchases();

    _products = [];
    _purchases = [];

    setState(() {
      _products = products;
      _purchases = purchases;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            _load();
          },
          child: Text("Init In App Purchases"),
        ),
        for (var _p in _products)
          if (_iapService.hasPurchased(
                productId: _p.id,
                purchases: _purchases,
                userId: widget.userId,
              ) !=
              null) ...[
            Center(child: Text("${_p.title.split((' ('))[0]} Purchased")),
          ] else ...[
            TextButton(
              onPressed: () async {
                await _iapService.buySubscription(product: _p, userId: widget.userId);
                _load();
              },
              child: Text("Purchase: ${_p.title.split((' ('))[0]} (${_p.price})"),
            ),
          ]
      ],
    );
  }
}
