import 'dart:ui';

class AppLocales {
  static Locale english = const Locale('en', 'US');
  static Locale spanish = const Locale('es', 'ES');

  static List<Locale> supportedLocales = [
    english,
    spanish,
  ];

  /// Returns a formatted version of language
  /// if nothing is present than it will pass the locale to a string
  static String formattedLanguageName(Locale locale) {
    if (locale == spanish) {
      return 'Español';
    } else if (locale == english) {
      return 'English';
    } else {
      return locale.countryCode.toString();
    }
  }
}
