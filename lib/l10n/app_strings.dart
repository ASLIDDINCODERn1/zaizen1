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

  String get confirmPassword => _t(uz: 'Parolni tasdiqlang', ru: 'Подтвердите пароль', en: 'Confirm password', ja: 'パスワードを確認');
  String get nameLabel => _t(uz: 'Ism', ru: 'Имя', en: 'Name', ja: '名前');
  String get orWord => _t(uz: 'yoki', ru: 'или', en: 'or', ja: 'または');
  String get googleContinue => _t(uz: 'Google orqali davom etish', ru: 'Продолжить с Google', en: 'Continue with Google', ja: 'Googleで続行');
  String get createAccount => _t(uz: "Yangi hisob oching", ru: 'Создайте аккаунт', en: 'Create an account', ja: 'アカウントを作成');
  String get signInHint => _t(uz: 'Hisobingizga kiring', ru: 'Войдите в аккаунт', en: 'Sign in to your account', ja: 'アカウントにログイン');
  String get dataSafe => _t(uz: "Ma'lumotlaringiz xavfsiz saqlanadi", ru: 'Ваши данные в безопасности', en: 'Your data is stored securely', ja: 'データは安全に保存されます');
  String get continueNeedLogin => _t(uz: 'Davom etish uchun hisobingizga kiring', ru: 'Чтобы продолжить, войдите в аккаунт', en: 'Sign in to continue', ja: '続けるにはログインしてください');
  String get deleteAccount => _t(uz: "Akkauntni o'chirish", ru: 'Удалить аккаунт', en: 'Delete account', ja: 'アカウントを削除');
  String get deleteAccountMessage => _t(
    uz: "Barcha ma'lumotlaringiz Supabase Auth va bazadan o'chadi. Keyin yangi akkaunt ochishingiz mumkin.",
    ru: 'Все данные будут удалены из Supabase Auth и базы. Потом можно создать новый аккаунт.',
    en: 'All your data will be removed from Supabase Auth and the database. You can create a new account later.',
    ja: 'すべてのデータがSupabase Authとデータベースから削除されます。後で新しいアカウントを作成できます。',
  );
  String get delete => _t(uz: "O'chirish", ru: 'Удалить', en: 'Delete', ja: '削除');
  String get editName => _t(uz: 'Ismni tahrirlash', ru: 'Изменить имя', en: 'Edit name', ja: '名前を編集');
  String get pinUnlockTitle => _t(uz: 'Xavfsizlik PIN kodi', ru: 'PIN-код безопасности', en: 'Security PIN', ja: 'セキュリティPIN');
  String get pinCreateTitle => _t(uz: '1/2: Yangi PIN kiriting', ru: '1/2: Введите новый PIN', en: '1/2: Enter a new PIN', ja: '1/2: 新しいPINを入力');
  String get pinConfirmTitle => _t(uz: '2/2: PIN kodni tasdiqlang', ru: '2/2: Подтвердите PIN', en: '2/2: Confirm PIN', ja: '2/2: PINを確認');
  String get pinUnlockSub => _t(uz: 'Dasturga kirish uchun PIN kodni tering', ru: 'Введите PIN, чтобы открыть приложение', en: 'Enter your PIN to unlock the app', ja: 'アプリを開くにはPINを入力');
  String get pinCreateSub => _t(uz: "4 xonali yangi PIN kod o'ylab toping", ru: 'Придумайте 4-значный PIN', en: 'Choose a 4-digit PIN', ja: '4桁のPINを決めてください');
  String get pinConfirmSub => _t(uz: 'Tasdiqlash uchun xuddi shu kodni qayta tering', ru: 'Для подтверждения введите тот же код', en: 'Enter the same PIN again', ja: '確認のため同じPINを再入力');
  String get pinWrong => _t(uz: "PIN kod noto'g'ri!", ru: 'Неверный PIN-код!', en: 'Incorrect PIN!', ja: 'PINが正しくありません');
  String get pinMismatch => _t(uz: 'Kodlar mos kelmadi! Qaytadan kiriting', ru: 'Коды не совпадают. Повторите ввод', en: 'PINs do not match. Try again', ja: 'PINが一致しません。やり直してください');
  String get pinSaved => _t(uz: 'Muvaffaqiyatli saqlandi!', ru: 'Успешно сохранено!', en: 'Saved successfully!', ja: '保存しました！');
  String get pinSuccess => _t(uz: 'Muvaffaqiyatli!', ru: 'Успешно!', en: 'Success!', ja: '成功しました！');
  String get photoUploadFail => _t(uz: "Rasm yuklanmadi. Qayta urinib ko'ring.", ru: 'Не удалось загрузить фото. Попробуйте ещё раз.', en: 'Photo upload failed. Please try again.', ja: '写真のアップロードに失敗しました。');

  String get authInvalidCredentials => _t(uz: "Email yoki parol noto'g'ri.", ru: 'Неверный email или пароль.', en: 'Incorrect email or password.', ja: 'メールまたはパスワードが正しくありません。');
  String get authEmailNotConfirmed => _t(uz: 'Avval emailingizni tasdiqlang (pochta qutisini tekshiring).', ru: 'Сначала подтвердите email.', en: 'Please confirm your email first.', ja: '先にメールを確認してください。');
  String get authAlreadyRegistered => _t(uz: "Bu email allaqachon ro'yxatdan o'tgan.", ru: 'Этот email уже зарегистрирован.', en: 'This email is already registered.', ja: 'このメールは既に登録されています。');
  String get authWeakPassword => _t(uz: "Parol kamida 8 belgi, harf va raqamdan iborat bo'lsin.", ru: 'Пароль: минимум 8 символов, буква и цифра.', en: 'Password needs 8+ chars, a letter and a number.', ja: 'パスワードは8文字以上、文字と数字が必要です。');
  String get authGoogleDisabled => _t(uz: "Google provider Supabase dashboardda yoqilmagan.", ru: 'Google провайдер не включён в Supabase.', en: 'Google sign-in is not enabled in Supabase.', ja: 'SupabaseでGoogleログインが有効ではありません。');
  String get authRateLimit => _t(uz: "Juda ko'p urinish. Birozdan so'ng qayta urinib ko'ring.", ru: 'Слишком много попыток. Подождите немного.', en: 'Too many attempts. Please wait and try again.', ja: '試行が多すぎます。少し待って再試行してください。');
  String get authNetwork => _t(uz: "Internet yo'q yoki serverga ulanib bo'lmadi.", ru: 'Нет сети или сервер недоступен.', en: 'No internet or the server is unreachable.', ja: 'インターネットがないか、サーバーに接続できません。');
  String get authEnterPassword => _t(uz: 'Parol kiriting.', ru: 'Введите пароль.', en: 'Enter a password.', ja: 'パスワードを入力してください。');
  String get authEnterEmail => _t(uz: 'Email kiriting.', ru: 'Введите email.', en: 'Enter an email.', ja: 'メールを入力してください。');
  String get authBadEmail => _t(uz: "Email formati noto'g'ri.", ru: 'Неверный формат email.', en: 'Invalid email format.', ja: 'メール形式が正しくありません。');
  String get authEnterName => _t(uz: 'Ismingizni kiriting.', ru: 'Введите имя.', en: 'Enter your name.', ja: '名前を入力してください。');
  String get authNameShort => _t(uz: "Ism kamida 2 ta belgidan iborat bo'lsin.", ru: 'Имя должно быть не короче 2 символов.', en: 'Name must be at least 2 characters.', ja: '名前は2文字以上にしてください。');
  String get authPasswordSpace => _t(uz: "Parolda bo'sh joy bo'lmasin.", ru: 'В пароле не должно быть пробелов.', en: 'Password cannot contain spaces.', ja: 'パスワードに空白を含めないでください。');
  String get authPasswordShort => _t(uz: "Parol kamida 8 ta belgidan iborat bo'lsin.", ru: 'Пароль должен содержать минимум 8 символов.', en: 'Password must be at least 8 characters.', ja: 'パスワードは8文字以上にしてください。');
  String get authPasswordLetter => _t(uz: "Parolda kamida 1 ta harf bo'lsin.", ru: 'В пароле нужна хотя бы 1 буква.', en: 'Password must include at least 1 letter.', ja: 'パスワードに文字を1つ以上入れてください。');
  String get authPasswordDigit => _t(uz: "Parolda kamida 1 ta raqam bo'lsin.", ru: 'В пароле нужна хотя бы 1 цифра.', en: 'Password must include at least 1 number.', ja: 'パスワードに数字を1つ以上入れてください。');
  String get authPasswordCommon => _t(uz: "Bu parol juda oddiy. Boshqasini tanlang.", ru: 'Этот пароль слишком простой.', en: 'That password is too common. Choose another.', ja: 'そのパスワードは簡単すぎます。');
  String get authPasswordLikeEmail => _t(uz: "Parol emailingizga o'xshamasin.", ru: 'Пароль не должен быть похож на email.', en: 'Password should not match your email.', ja: 'パスワードをメールと同じにしないでください。');
  String get authConfirmPassword => _t(uz: 'Parolni tasdiqlang.', ru: 'Подтвердите пароль.', en: 'Confirm the password.', ja: 'パスワードを確認してください。');
  String get authPasswordMismatch => _t(uz: 'Parollar mos emas.', ru: 'Пароли не совпадают.', en: 'Passwords do not match.', ja: 'パスワードが一致しません。');
  String get authNeedLogin => _t(uz: 'Avval tizimga kiring.', ru: 'Сначала войдите в аккаунт.', en: 'Please sign in first.', ja: '先にログインしてください。');
  String get authUploadDenied => _t(uz: "Rasm yuklanmadi (storage ruxsati). supabase/setup.sql ni SQL Editorda ishga tushiring.", ru: 'Фото не загрузилось. Запустите supabase/setup.sql в SQL Editor.', en: 'Photo upload blocked. Run supabase/setup.sql in the SQL Editor.', ja: '写真をアップロードできません。SQL Editorで setup.sql を実行してください。');
  String get authDeleteNeedSql => _t(uz: "Sessiya yopildi. Auth dan o'chirish uchun supabase/setup.sql ni ishga tushiring.", ru: 'Сессия закрыта. Чтобы удалить из Auth, запустите setup.sql.', en: 'Signed out. Run setup.sql to delete the Auth user.', ja: 'サインアウトしました。Auth削除には setup.sql を実行してください。');
  String get authAccountCreated => _t(uz: "Hisob yaratildi. Emailni tasdiqlang, so'ng kiring.", ru: 'Аккаунт создан. Подтвердите email, затем войдите.', en: 'Account created. Confirm your email, then sign in.', ja: 'アカウントを作成しました。メール確認後にログインしてください。');
  String get authGoogleCanceled => _t(uz: 'Google orqali kirish bekor qilindi.', ru: 'Вход через Google отменён.', en: 'Google sign-in was canceled.', ja: 'Googleログインがキャンセルされました。');
  String get authResetSent => _t(uz: 'Zaizen nomidan tiklash havolasi yuborildi. Pochta qutisini tekshiring.', ru: 'Ссылка для сброса отправлена от имени Zaizen. Проверьте почту.', en: 'A Zaizen password reset link was sent. Check your inbox.', ja: 'Zaizenからパスワード再設定リンクを送信しました。メールを確認してください。');
  String get resetPasswordTitle => _t(uz: 'Parolni tiklash', ru: 'Сброс пароля', en: 'Reset password', ja: 'パスワード再設定');
  String get resetPasswordDesc => _t(uz: 'Emailingizni yozing. Parolni tiklash havolasini Zaizen nomidan yuboramiz.', ru: 'Введите email. Ссылку для сброса отправим от имени Zaizen.', en: 'Enter your email. We will send a Zaizen password reset link.', ja: 'メールを入力してください。Zaizenから再設定リンクを送ります。');
  String get sendResetLink => _t(uz: 'Havola yuborish', ru: 'Отправить ссылку', en: 'Send link', ja: 'リンクを送信');
  String get newPasswordTitle => _t(uz: 'Yangi parol', ru: 'Новый пароль', en: 'New password', ja: '新しいパスワード');
  String get newPasswordRules => _t(uz: 'Kamida 8 belgi, 1 harf va 1 raqam. Oddiy parollar qabul qilinmaydi.', ru: 'Минимум 8 символов, 1 буква и 1 цифра. Простые пароли не принимаются.', en: 'At least 8 characters, 1 letter and 1 number. Common passwords are rejected.', ja: '8文字以上、文字と数字が必要です。簡単なパスワードは使えません。');
  String get passwordHintShort => _t(uz: '8+ belgi, harf va raqam', ru: '8+ символов, буква и цифра', en: '8+ chars, letter and number', ja: '8文字以上、文字と数字');
  String get passwordUpdated => _t(uz: 'Parol yangilandi. Endi shu parol bilan kiring.', ru: 'Пароль обновлён. Теперь войдите с новым паролем.', en: 'Password updated. Sign in with the new password.', ja: 'パスワードを更新しました。新しいパスワードでログインしてください。');
  String get authPhotoTooLarge => _t(uz: "Rasm 5 MB dan oshmasin.", ru: 'Фото не должно быть больше 5 МБ.', en: 'Photo must be 5 MB or smaller.', ja: '写真は5MB以下にしてください。');
  String get biometricReason => _t(uz: 'Kirish uchun ekrandagi barmoq izini bosing', ru: 'Нажмите датчик отпечатка, чтобы войти', en: 'Use your fingerprint to unlock', ja: '指紋でロックを解除してください');
  String get pinGoingHome => _t(uz: "Asosiy sahifaga o'tilmoqda...", ru: 'Переход на главный экран...', en: 'Opening the home screen...', ja: 'ホーム画面を開いています...');

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

class LanguageScope {
  LanguageScope._();
  static String code = 'uz';
  static AppStrings strings = AppStrings.uz;

  static void apply(String languageCode) {
    code = languageCode;
    strings = AppStrings.fromCode(languageCode);
  }
}
