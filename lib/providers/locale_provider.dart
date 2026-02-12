import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _keyLocale = 'app_locale';

/// 应用语言状态，默认英语；持久化到 SharedPreferences
class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  LocaleProvider() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_keyLocale);
    if (code != null && (code == 'en' || code == 'zh')) {
      _locale = Locale(code);
      notifyListeners();
    }
  }

  Future<void> setLocale(Locale value) async {
    if (_locale == value) return;
    _locale = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLocale, value.languageCode);
    notifyListeners();
  }
}
