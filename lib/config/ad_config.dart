/// Configuration for AD Unit ID
/// Edit these with what you got from google mobile ad sdk
/// Get your keys from here
/// https://admob.google.com/home/
class AdConfig {
  /// If the ad is on
  static const bool isAdOn = false;

  /// How many post after you wanna display ads [HomePage] or [FeatureTab]
  static int adIntervalInHomePage = 5;

  /// How many post after you wanna display ads in CategoryView
  static int adIntervalInCategory = 5;

  /* <---- ANDROID -----> */
  static const String androidBannerAdID =
      'ca-app-pub-2548139596011442/6849850359';
  static const String androidInterstitialAdID =
      'ca-app-pub-2548139596011442/4930264028';

  /* <---- IOS -----> */
  static const String iosBannerAdID = 'ca-app-pub-2548139596011442/7692158734';
  static const String iosInterstitialAdID =
      'ca-app-pub-2548139596011442/4000325737';
}
