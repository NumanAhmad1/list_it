import 'package:lisit_mobile_app/const/lib_all.dart';

class CustomTheme {
  /// Light Theme

  static var lightTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: kbackgrounColor,
      primaryColor: ksecondaryColor,
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.light,
        seedColor: kbackgrounColor,
      ),
      fontFamily: GoogleFonts.montserrat().fontFamily,
      progressIndicatorTheme: ProgressIndicatorThemeData(color: kprimaryColor));

  ///Dark Theme

  static var darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: ksecondaryColor,
    primaryColor: kbackgrounColor,
    colorScheme: ColorScheme.fromSeed(
        seedColor: ksecondaryColor, brightness: Brightness.dark),
    fontFamily: GoogleFonts.montserrat().fontFamily,
  );
}
