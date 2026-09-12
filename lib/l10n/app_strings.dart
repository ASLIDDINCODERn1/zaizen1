/// Ilovaning barcha UI matnlari.
/// To'liq tarjima: uz, ru, en, ja.
/// Boshqa tillar tanlansa inglizcha ko'rsatiladi.
class AppStrings {
  final String languageCode;

  const AppStrings._(this.languageCode);

  static const AppStrings uz = AppStrings._('uz');
  static const AppStrings ru = AppStrings._('ru');
  static const AppStrings en = AppStrings._('en');
  static const AppStrings ja = AppStrings._('ja');

  static AppStrings fromCode(String code) => AppStrings._(code);

  String get navHome => _t(uz: 'Bosh sahifa', ru: 'Главная', en: 'Home', ja: 'ホーム');
  String get navRating => _t(uz: 'Reyting', ru: 'Рейтинг', en: 'Rating', ja: 'ランキング');
  String get navProfile => _t(uz: 'Profil', ru: 'Профиль', en: 'Profile', ja: 'プロフィール');

  String get profileTitle => navProfile;
  String get personalInfo => _t(uz: "Shaxsiy ma'lumotlar", ru: 'Личная информация', en: 'Personal Info', ja: '個人情報');
  String get notifications => _t(uz: 'Bildirishnomalar', ru: 'Уведомления', en: 'Notifications', ja: '通知');
  String get security => _t(uz: 'Xavfsizlik', ru: 'Безопасность', en: 'Security', ja: 'セキュリティ');
  String get language => _t(uz: 'Til', ru: 'Язык', en: 'Language', ja: '言語');
  String get helpCenter => _t(uz: 'Yordam markazi', ru: 'Центр помощи', en: 'Help Center', ja: 'ヘルプ');
  String get logout => _t(uz: 'Chiqish', ru: 'Выйти', en: 'Log out', ja: 'ログアウト');
  String get save => _t(uz: 'Saqlash', ru: 'Сохранить', en: 'Save', ja: '保存');
  String get cancel => _t(uz: 'Bekor qilish', ru: 'Отмена', en: 'Cancel', ja: 'キャンセル');

  String get languageScreenTitle => _t(uz: 'Tilni tanlang', ru: 'Выберите язык', en: 'Choose Language', ja: '言語を選択');
  String get languageSaved => _t(uz: 'Til muvaffaqiyatli saqlandi!', ru: 'Язык успешно сохранён!', en: 'Language saved!', ja: '言語が保存されました！');
  String get languageSearchHint => _t(uz: 'Til qidirish', ru: 'Поиск языка', en: 'Search language', ja: '言語を検索');

  String get fullName => _t(uz: "To'liq ism", ru: 'Полное имя', en: 'Full Name', ja: '氏名');
  String get email => _t(uz: 'Elektron pochta', ru: 'Эл. почта', en: 'Email', ja: 'メール');
  String get phone => _t(uz: 'Telefon raqam', ru: 'Номер телефона', en: 'Phone Number', ja: '電話番号');
  String get savedSuccess => _t(uz: "Ma'lumotlar muvaffaqiyatli saqlandi!", ru: 'Данные успешно сохранены!', en: 'Data saved successfully!', ja: 'データが保存されました！');

  String get pushNotifications => _t(uz: 'Push bildirishnomalar', ru: 'Push-уведомления', en: 'Push Notifications', ja: 'プッシュ通知');
  String get pushNotificationsDesc => _t(uz: 'Yangi xabarlar va bildirishnomalar', ru: 'Новые сообщения и уведомления', en: 'New messages and alerts', ja: '新しいメッセージと通知');
  String get lessonReminders => _t(uz: 'Dars eslatmalari', ru: 'Напоминания об уроках', en: 'Lesson Reminders', ja: 'レッスンリマインダー');
  String get lessonRemindersDesc => _t(uz: 'Kundalik reja va dars vaqtlari', ru: 'Ежедневный план и время уроков', en: 'Daily schedule and lesson times', ja: '毎日のスケジュールとレッスン時間');
  String get newsUpdates => _t(uz: 'Yangiliklar va takliflar', ru: 'Новости и предложения', en: 'News & Offers', ja: 'ニュースとお知らせ');
  String get newsUpdatesDesc => _t(uz: 'Yangi kurslar va maxsus chegirmalar', ru: 'Новые курсы и специальные скидки', en: 'New courses and special discounts', ja: '新しいコースと特別割引');

  String get contactUs => _t(uz: "Biz bilan bog'lanish", ru: 'Связаться с нами', en: 'Contact Us', ja: 'お問い合わせ');
  String get telegramSupport => _t(uz: 'Telegram yordam', ru: 'Поддержка в Telegram', en: 'Telegram Support', ja: 'テレグラムサポート');
  String get faq => _t(uz: "Ko'p beriladigan savollar", ru: 'Часто задаваемые вопросы', en: 'FAQ', ja: 'よくある質問');
  String get faqAnswer => _t(
    uz: "PIN kodni unutgan taqdirda, qurilmada o'rnatilgan barmoq izi orqali ilovaga kirishingiz yoki hisobni tiklashingiz mumkin.",
    ru: 'Если вы забыли PIN-код, вы можете войти с помощью отпечатка пальца или восстановить аккаунт.',
    en: 'If you forgot your PIN, you can sign in using your fingerprint or restore your account.',
    ja: 'PINを忘れた場合は、指紋認証でサインインするかアカウントを復元できます。',
  );

  String get logoutTitle => _t(uz: 'Hisobdan chiqish', ru: 'Выйти из аккаунта', en: 'Log Out', ja: 'ログアウト');
  String get logoutMessage => _t(uz: "Haqiqatan ham o'z hisobingizdan chiqmoqchimisiz?", ru: 'Вы действительно хотите выйти из своего аккаунта?', en: 'Are you sure you want to log out?', ja: '本当にログアウトしますか？');

  String get appLock => _t(uz: 'Ilovani qulflash', ru: 'Блокировка приложения', en: 'App Lock', ja: 'アプリロック');
  String get pinCode => _t(uz: 'PIN-kod', ru: 'PIN-код', en: 'PIN Code', ja: 'PINコード');
  String get fingerprint => _t(uz: 'Barmoq izi', ru: 'Отпечаток пальца', en: 'Fingerprint', ja: '指紋認証');

  String get noInternet => _t(uz: "Internet yo'q", ru: 'Нет интернета', en: 'No Internet', ja: 'インターネットなし');
  String get noInternetDesc => _t(
    uz: "Iltimos, Wi-Fi yoki mobil internet ulanishingizni tekshiring va qayta urinib ko'ring.",
    ru: 'Пожалуйста, проверьте подключение к Wi-Fi или мобильной сети и повторите попытку.',
    en: 'Please check your Wi-Fi or mobile data connection and try again.',
    ja: 'Wi-Fiまたはモバイルデータの接続を確認して、もう一度お試しください。',
  );
  String get retry => _t(uz: 'Qayta urinish', ru: 'Повторить', en: 'Try Again', ja: '再試行');

  String get navHomeLabel => navHome;
  String get navRatingLabel => navRating;
  String get navProfileLabel => navProfile;

  String get welcome => _t(uz: 'Xush kelibsiz,', ru: 'Добро пожаловать,', en: 'Welcome,', ja: 'ようこそ、');
  String get welcomeLogin => _t(uz: 'Xush kelibsiz!', ru: 'Добро пожаловать!', en: 'Welcome!', ja: 'ようこそ！');
  String get loginSubtitle => _t(uz: 'Hisobingizga kiring va davom eting', ru: 'Войдите в аккаунт, чтобы продолжить', en: 'Sign in to your account to continue', ja: '続行するにはアカウントにログインしてください');
  String get emailAddress => _t(uz: 'Email manzil', ru: 'Эл. почта', en: 'Email address', ja: 'メールアドレス');
  String get password => _t(uz: 'Parol', ru: 'Пароль', en: 'Password', ja: 'パスワード');
  String get rememberMe => _t(uz: 'Meni eslab qol', ru: 'Запомнить меня', en: 'Remember me', ja: 'ログイン状態を保持');
  String get forgotPassword => _t(uz: 'Parolni unutdingizmi?', ru: 'Забыли пароль?', en: 'Forgot password?', ja: 'パスワードをお忘れですか？');
  String get signIn => _t(uz: 'Kirish', ru: 'Войти', en: 'Sign in', ja: 'ログイン');
  String get orContinue => _t(uz: 'Yoki davom eting', ru: 'Или продолжить', en: 'Or continue with', ja: 'または次で続ける');
  String get continueAsGuest => _t(uz: 'Mehmon sifatida davom etish', ru: 'Продолжить как гость', en: 'Continue as guest', ja: 'ゲストとして続ける');
  String get noAccount => _t(uz: "Hisobingiz yo'qmi? ", ru: 'Нет аккаунта? ', en: "Don't have an account? ", ja: 'アカウントをお持ちでないですか？ ');
  String get signUp => _t(uz: "Ro'yxatdan o'tish", ru: 'Регистрация', en: 'Sign up', ja: '登録');

  String get todayGoal => _t(uz: 'Bugungi maqsad', ru: 'Цель на сегодня', en: "Today's Goal", ja: '今日の目標');
  String get recentActivity => _t(uz: "So'nggi faoliyat", ru: 'Недавняя активность', en: 'Recent Activity', ja: '最近の活動');
  String get finishLessons => _t(uz: '3 ta darsni tugating', ru: 'Пройдите 3 урока', en: 'Finish 3 lessons', ja: '3つのレッスンを終える');
  String get lessonsProgress => _t(uz: '2 / 3 tugallandi', ru: '2 / 3 завершено', en: '2 / 3 completed', ja: '2 / 3 完了');
  String get leaderboardTitle => _t(uz: 'Reyting jadvali', ru: 'Таблица рейтинга', en: 'Leaderboard', ja: 'ランキング');
  String get leaderboardSub => _t(uz: 'Ushbu hafta eng faol foydalanuvchilar', ru: 'Самые активные пользователи этой недели', en: 'Most active users this week', ja: '今週のもっともアクティブなユーザー');
  String get hoursAgo => _t(uz: '2 soat oldin', ru: '2 часа назад', en: '2 hours ago', ja: '2時間前');
  String get yesterday => _t(uz: 'Kecha', ru: 'Вчера', en: 'Yesterday', ja: '昨日');
  String get twoDaysAgo => _t(uz: '2 kun oldin', ru: '2 дня назад', en: '2 days ago', ja: '2日前');
  String get score => _t(uz: 'Ball', ru: 'Очки', en: 'Score', ja: 'スコア');
  String get streak => _t(uz: 'Streak', ru: 'Серия', en: 'Streak', ja: 'ストリーク');
  String get rank => _t(uz: "O'rin", ru: 'Место', en: 'Rank', ja: 'ランク');
  String get activityLesson => _t(uz: 'Flutter asoslari', ru: 'Основы Flutter', en: 'Flutter basics', ja: 'Flutterの基礎');
  String get activityGroup => _t(uz: 'Guruh muhokamasi', ru: 'Групповое обсуждение', en: 'Group discussion', ja: 'グループディスカッション');
  String get activityWeekly => _t(uz: 'Haftalik yutuq', ru: 'Недельное достижение', en: 'Weekly achievement', ja: '週間の成果');

  String _t({required String uz, required String ru, required String en, required String ja}) {
    switch (languageCode) {
      case 'uz': return uz;
      case 'ru': return ru;
      case 'ja': return ja;
      case 'en': return en;
      default: return en;
    }
  }
}
