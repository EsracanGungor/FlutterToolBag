import 'package:flutter/material.dart';
import 'package:flutter_tool_bag/theme_values.dart';

class ThemeNotifier with ChangeNotifier {
  ThemeData _themeData = greenTheme;

  ThemeNotifier(this._themeData);

  getTheme() => _themeData;

  setTheme(ThemeData themeData) async {
    _themeData = themeData;
    notifyListeners();
  }
}