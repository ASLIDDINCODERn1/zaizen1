import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zaizen/l10n/app_strings.dart';

class LocaleProvider extends ChangeNotifier {
  static const _key = 'app_language_code';

  Locale _locale = const Locale('uz');
  AppStrings _strings = AppStrings.uz;
  bool _isLoaded = false;

  Locale get locale => _locale;
  AppStrings get strings => _strings;
  bool get isLoaded => _isLoaded;

  LocaleProvider() {
    LanguageScope.apply('uz');
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key) ?? 'uz';
    _apply(code);
    _isLoaded = true;
    notifyListeners();
  }

  void _apply(String languageCode) {
    _locale = Locale(languageCode);
    _strings = AppStrings.fromCode(languageCode);
    LanguageScope.apply(languageCode);
  }

  Future<void> setLocale(String languageCode) async {
    if (_locale.languageCode == languageCode) return;
    _apply(languageCode);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, languageCode);
  }
}
