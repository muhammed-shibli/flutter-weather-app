import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-9656323939487013/2029322064";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  // static String get interstitialAdUnitId {
  //   if (Platform.isAndroid) {
  //     return "ca-app-pub-3940256099942544/8691691433";
  //   } else if (Platform.isIOS) {
  //     return "ca-app-pub-3940256099942544/5135589807";
  //   } else {
  //     throw new UnsupportedError("Unsupported platform");
  //   }
  // }
}