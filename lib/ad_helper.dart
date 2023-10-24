import 'dart:io';

class AdHelper {
// TEST AD
  // static String get bannerAdUnitId {
  //   if (Platform.isAndroid) {
  //     return 'ca-app-pub-3940256099942544/6300978111';
  //   // } else if (Platform.isIOS) {
  //   //   return 'ca-app-pub-3940256099942544/2934735716';
  //   } else {
  //     throw new UnsupportedError("Unsupported platform");
  //   }
  // }

  // static String get nativeAdUnitId {
  //   if (Platform.isAndroid) {
  //     return 'ca-app-pub-3940256099942544/2247696110';
  //   // } else if (Platform.isIOS) {
  //   //   return 'ca-app-pub-3940256099942544/3986624511';
  //   } else {
  //     throw new UnsupportedError("Unsupported platform");
  //   }
  // }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-8331234367729530/6458162831";
      // } else if (Platform.isIOS) {
      //   return "<YOUR_IOS_BANNER_AD_UNIT_ID>";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-8331234367729530/7176386127";
      // } else if (Platform.isIOS) {
      //   return "<YOUR_IOS_NATIVE_AD_UNIT_ID>";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}
