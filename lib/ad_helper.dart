import 'dart:io';

class AdHelper {

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    // } else if (Platform.isIOS) {
    //   return 'ca-app-pub-3940256099942544/2934735716';
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get nativeAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/2247696110';
    // } else if (Platform.isIOS) {
    //   return 'ca-app-pub-3940256099942544/3986624511';
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  // static String get bannerAdUnitId {
  //   if (Platform.isAndroid) {
  //     return "ca-app-pub-8331234367729530/4947336003";
  //   // } else if (Platform.isIOS) {
  //   //   return "<YOUR_IOS_BANNER_AD_UNIT_ID>";
  //   } else {
  //     throw new UnsupportedError("Unsupported platform");
  //   }
  // }

  // static String get interstitialAdUnitId {
  //   if (Platform.isAndroid) {
  //     return "ca-app-pub-8331234367729530/1624821056";
  //   // } else if (Platform.isIOS) {
  //   //   return "<YOUR_IOS_NATIVE_AD_UNIT_ID>";
  //   } else {
  //     throw new UnsupportedError("Unsupported platform");
  //   }
  // }
}