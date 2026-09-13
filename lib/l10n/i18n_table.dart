import 'package:zaizen/l10n/i18n_long.dart';
import 'package:zaizen/l10n/i18n_ui.dart';

const Map<String, Map<String, String>> kI18n = {
  ...kI18nUi,
  ...kI18nLong,
};

const Set<String> kRtlLanguages = {'ar', 'he', 'fa', 'ur'};
