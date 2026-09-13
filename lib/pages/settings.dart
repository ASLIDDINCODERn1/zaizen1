import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaizen/auth/auth_service.dart';
import 'package:zaizen/l10n/app_strings.dart';
import 'package:zaizen/locale_provider.dart';
import 'package:zaizen/pages/profile_menus/language_screen.dart';
import 'package:zaizen/pages/profile_menus/profile_sub.dart' hide LanguageScreen;
import 'package:zaizen/pages/profile_menus/security_tab.dart';
import 'package:zaizen/ui/app_theme.dart';
import 'package:provider/provider.dart' show ReadContext, WatchContext;

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  String _label(AppStrings s, String code) {
    switch (code) {
      case 'navSettings':
        return _t(s, uz: 'Sozlamalar', ru: 'Настройки', en: 'Settings', ja: '設定');
      case 'appearance':
        return _t(s, uz: 