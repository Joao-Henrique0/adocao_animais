import 'package:adocao_animais/theme/theme.dart';
import 'package:flutter/material.dart';


class ThemeProvider with ChangeNotifier {
  bool isDarkMode = false;
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;
  ThemeProvider() {
    //_loadTheme();
  }

  // Future<void> _loadTheme() async {
  //   final themeName = await DbUtil.getSetting('theme');
  //   if (themeName == 'darkMode') {
  //     _themeData = darkMode;
  //   } else {
  //     _themeData = lightMode;
  //   }
  //   notifyListeners();
  // }

  void setTheme(ThemeData themeData) {
    isDarkMode = !isDarkMode;
    _themeData = themeData;
    notifyListeners();
    // DbUtil.insertSetting(
    //     'theme', themeData == darkMode ? 'darkMode' : 'lightMode');
  }

  set themeData(ThemeData themaData) {
    _themeData = themaData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
      setTheme(themeData);
    } else {
      themeData = lightMode;
      setTheme(themeData);
    }
  }
}
