import 'dart:io';

import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseApi {
  static const _apiKeyAndroid = 'goog_QajaExAnpGyJuMbSrkKCUodbpqT';
  static const _apiKeiIos = 'appl_qiQasAMolwYuIVFXorjJozJkorJ';
  static bool isPaid = false;

  static Future init() async {
    await Purchases.setLogLevel(LogLevel.debug);
    await Purchases.configure(
      PurchasesConfiguration(Platform.isAndroid ? _apiKeyAndroid : _apiKeiIos),
    );
    await Purchases.getCustomerInfo().then((value) {
      // TODO chage code
       isPaid = value.entitlements.active.isNotEmpty;

    });
  }

  static Future<List<Offering>> fetchOffers() async {
    try {
      final offerings = await Purchases.getOfferings();
      final current = offerings.all.values.toList();
      return current;
    } on PlatformException {
      return [];
    }
  }

  static Future<bool> purchasePackage(Package package) async {
    try {
      await Purchases.purchasePackage(package);
      return true;
    } catch (e) {
      return false;
    }
  }
}
