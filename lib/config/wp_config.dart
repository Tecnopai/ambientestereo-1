import 'package:flutter/material.dart';

class WPConfig {
  /// The Name of your app
  static const String appName = 'Ambiente Stereo 88.4FM';

  /// The url of your app, should not inclued any '/' slash or any 'https://' or 'http://'
  /// Otherwise it may break the compaitbility, And your website must be
  /// a wordpress website.
  static const String url = 'ambientestereo.fm/sitio';

  /// Primary Color of the App, must be a valid hex code after '0xFF'
  static const Color primaryColor = Color.fromARGB(255, 112, 226, 119);

  /// Used for redirecting users to privacy policy page on your website
  static const String privacyPolicyUrl =
      'https://ambientestereo.fm/sitio/privacy-policy-2/';

  /// Used for redirecting users to privacy terms & services on your website
  static const String termsAndServicesUrl =
      '';

  /// Used for showing about page of website
  static const String aboutPageUrl = 'https://ambientestereo.fm/sitio/2021/06/12/sobre-nosotros-2/';

  /// Support Email
  static const String supportEmail = 'contacto@iglesiacristianapai.com';

  /// Social Links
  static const String facebookUrl = 'https://www.facebook.com/AmbienteStereo/';
  static const String youtubeUrl = 'https://www.youtube.com/c/IglesiaCristianaPAItv';
  static const String twitterUrl = 'https://twitter.com/ambiente884/';
  static const String instagramUrl = 'https://instagram.com/ambientestereo';

  /// If we should force user to login everytime they start the app
  static const bool forceUserToLoginEverytime = false;

  /* <---- Show Post on notificaiton -----> */
  /// If you want to enable a post dialog when a notification arrives, if
  /// it is false a small Toast will appear on the bottom of the screen, see the
  /// example below
  /// https://drive.google.com/file/d/1Dq2ZyNgXTsnFFqm4m9infbnSn4rb-vTl/view?usp=sharing
  static bool showPostDialogOnNotificaiton = false;

  /// IF you want the popular post plugin to be disabled turn this to "false"
  static bool isPopularPostPluginEnabled = false;

  /* <-----------------------> 
      Categories    
   <-----------------------> */

  /// "FEATURED" tag id From Website
  /// the feature tag id which used to identify featured articles
  static const int featuredTagID = 299;

  /// "VIDEO" tag id from website
  /// the id of the video tag, which will help us identify the post type in app
  static const int videoTagID = 285;

  /// Home Page Category Name With Their ID's, the ordering will be same in UI
  /// How to find category ID:
  /// https://njengah.com/find-wordpress-category-id/
  static final homeCategories = <int, String>{
    // ID of Category : Name of the Category
    287: 'Noticias',
    286: 'Lo+Leído',
    285: 'Lo+oído',  
  };

  /// Name of the feature category
  static const featureCategoryName = 'Inicio';
  static const featureCategoryName4 = 'Radio Hits';
  static const featureCategoryName5 = 'Nosotros';
  static const featureCategoryName6 = 'Iglesia Cristiana PAI';
  /// Show horizonatal Logo in home page or title
  /// You can replace the logo in the asset folder
  /// horizonatal logo width is 136x35
  static bool showLogoInHomePage = true;

  /// IF we should keep the caching of home categories tab caching or not
  /// if this is false, then we will fetch new data and refresh the
  /// list if user changes tab or click on one
  static bool enableHomeTabCache = true;

  /// Blocked Categories ID's which will not appear in UI
  ///
  /// How to find category ID:
  /// https://njengah.com/find-wordpress-category-id/
  static List<int> blockedCategoriesIds = [290,271];
}
