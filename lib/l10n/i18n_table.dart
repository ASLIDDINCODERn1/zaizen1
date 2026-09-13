import 'package:zaizen/l10n/i18n_core.dart';

const Set<String> kRtlLanguages = {'ar', 'he', 'fa', 'ur'};

const Map<String, Map<String, String>> kI18nUi = {
  'navHome': {'uz': 'Bosh sahifa', 'ru': 'Главная', 'en': 'Home', 'ja': 'ホーム', 'ko': '홈', 'zh': '首页', 'ar': 'الرئيسية', 'tr': 'Ana sayfa', 'de': 'Start', 'fr': 'Accueil', 'es': 'Inicio', 'kk': 'Басты бет', 'ky': 'Башкы бет', 'tg': 'Асосӣ', 'az': 'Ana səhifə', 'uk': 'Головна', 'id': 'Beranda', 'hi': 'होम'},
  'navRating': {'uz': 'Reyting', 'ru': 'Рейтинг', 'en': 'Rating', 'ja': 'ランキング', 'ko': '랭킹', 'zh': '排行', 'ar': 'التصنيف', 'tr': 'Sıralama', 'de': 'Rangliste', 'fr': 'Classement', 'es': 'Ranking'},
  'navProfile': {'uz': 'Profil', 'ru': 'Профиль', 'en': 'Profile', 'ja': 'プロフィール', 'ko': '프로필', 'zh': '我的', 'ar': 'الملف', 'tr': 'Profil', 'de': 'Profil', 'fr': 'Profil', 'es': 'Perfil'},
  'navSettings': {'uz': 'Sozlamalar', 'ru': 'Настройки', 'en': 'Settings', 'ja': '設定', 'ko': '설정', 'zh': '设置', 'ar': 'الإعدادات', 'tr': 'Ayarlar', 'de': 'Einstellungen', 'fr': 'Paramètres', 'es': 'Ajustes', 'kk': 'Баптаулар', 'az': 'Parametrlər', 'uk': 'Налаштування'},
  'settingsTitle': {'uz': 'Sozlamalar', 'ru': 'Настройки', 'en': 'Settings', 'ja': '設定', 'ko': '설정', 'zh': '设置', 'ar': 'الإعدادات', 'tr': 'Ayarlar'},
  'appearance': {'uz': "Ko'rinish", 'ru': 'Внешний вид', 'en': 'Appearance', 'ja': '表示', 'ko': '화면', 'zh': '外观', 'tr': 'Görünüm', 'de': 'Darstellung', 'fr': 'Apparence', 'es': 'Apariencia'},
  'darkMode': {'uz': "Qorong'u rejim", 'ru': 'Тёмная тема', 'en': 'Dark mode', 'ja': 'ダークモード', 'ko': '다크 모드', 'zh': '深色模式', 'tr': 'Koyu mod'},
  'lightMode': {'uz': "Yorug' rejim", 'ru': 'Светлая тема', 'en': 'Light mode', 'ja': 'ライトモード', 'ko': '라이트 모드', 'zh': '浅色模式', 'tr': 'Açık mod'},
  'language': {'uz': 'Til', 'ru': 'Язык', 'en': 'Language', 'ja': '言語', 'ko': '언어', 'zh': '语言', 'ar': 'اللغة', 'tr': 'Dil', 'de': 'Sprache', 'fr': 'Langue', 'es': 'Idioma'},
  'security': {'uz': 'Xavfsizlik', 'ru': 'Безопасность', 'en': 'Security', 'ja': 'セキュリティ', 'ko': '보안', 'zh': '安全', 'tr': 'Güvenlik'},
  'logout': {'uz': 'Chiqish', 'ru': 'Выйти', 'en': 'Log out', 'ja': 'ログアウト', 'ko': '로그아웃', 'zh': '退出登录', 'tr': 'Çıkış'},
  'signIn': {'uz': 'Kirish', 'ru': 'Войти', 'en': 'Sign in', 'ja': 'ログイン', 'ko': '로그인', 'zh': '登录', 'tr': 'Giriş'},
  'save': {'uz': 'Saqlash', 'ru': 'Сохранить', 'en': 'Save', 'ja': '保存', 'ko': '저장', 'zh': '保存', 'tr': 'Kaydet'},
  'cancel': {'uz': 'Bekor qilish', 'ru': 'Отмена', 'en': 'Cancel', 'ja': 'キャンセル', 'ko': '취소', 'zh': '取消', 'tr': 'İptal'},
};

const Map<String, Map<String, String>> kI18n = {
  ...kI18nCore,
  ...kI18nUi,
};
