import 'package:flash_card/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;
  bool _isDarkMode = false;
  ThemeMode _themeMode = ThemeMode.light;

  //Get the theme data
  ThemeData get themeData => _themeData;
  //Get the dark mode
  bool get isDarkMode => _isDarkMode;

  //Get the theme mode
  ThemeMode get themeMode => _themeMode;

  //Set the theme data
  set setThemeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lightMode) {
      setThemeData = darkMode;
      _isDarkMode = true;
      //debugPrint("Dark mode is on");
    } else {
      setThemeData = lightMode;
      _isDarkMode = false;
      //debugPrint("Dark mode is off");
    }
  }

  //--- seond way to toggle the theme
  void toggleTheme2(bool isDarkMode) {
    _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    _isDarkMode = isDarkMode;
    debugPrint("Current theme>>>: ${_isDarkMode ? "Dark Mode" : "Light Mode"}");
    notifyListeners();
  }
}
