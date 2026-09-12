/// Oddiy, lekin mustahkam parol/email/ism tekshiruvi.
class PasswordRules {
  PasswordRules._();

  static const minLength = 8;
  static const maxLength = 72;

  static const _weak = {
    'password',
    'password1',
    'password123',
    'qwerty',
    'qwerty123',
    '12345678',
    '123456789',
    '1234567890',
    '11111111',
    '00000000',
    'abcdefgh',
    'letmein',
    'welcome',
    'admin123',
    'zaizen',
    'zaizen123',
    'parol123',
    'qwertyui',
    'iloveyou',
    'abc12345',
  };

  static final _emailRe = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$');
  static final _letterRe = RegExp(r'[A-Za-zА-яЁёЎўҚқҒғҲҳ]');
  static final _digitRe = RegExp(r'\d');

  static String? emailError(String email) {
    final v = email.trim();
    if (v.isEmpty) return 'Email kiriting.';
    if (!_emailRe.hasMatch(v)) return "Email formati noto'g'ri.";
    return null;
  }

  static String? nameError(String name) {
    final v = name.trim();
    if (v.isEmpty) return 'Ismingizni kiriting.';
    if (v.length < 2) return "Ism kamida 2 ta belgidan iborat bo'lsin.";
    return null;
  }

  static String? passwordError(String password, {String? email}) {
    final p = password;
    if (p.isEmpty) return 'Parol kiriting.';
    if (p.contains(' ')) return "Parolda bo'sh joy bo'lmasin.";
    if (p.length < minLength) {
      return "Parol kamida $minLength ta belgidan iborat bo'lsin.";
    }
    if (p.length > maxLength) {
      return "Parol $maxLength belgidan oshmasin.";
    }
    if (!_letterRe.hasMatch(p)) return "Parolda kamida 1 ta harf bo'lsin.";
    if (!_digitRe.hasMatch(p)) return "Parolda kamida 1 ta raqam bo'lsin.";
    if (_weak.contains(p.toLowerCase())) {
      return "Bu parol juda oddiy. Boshqasini tanlang.";
    }
    if (email != null && email.trim().isNotEmpty) {
      final local = email.trim().split('@').first.toLowerCase();
      if (local.length >= 3 && p.toLowerCase().contains(local)) {
        return "Parol emailingizga o'xshamasin.";
      }
    }
    return null;
  }

  static String? confirmError(String password, String confirm) {
    if (confirm.isEmpty) return 'Parolni tasdiqlang.';
    if (password != confirm) return 'Parollar mos emas.';
    return null;
  }

  /// 0 zaif … 4 juda yaxshi
  static int strength(String password) {
    if (password.isEmpty) return 0;
    var score = 0;
    if (password.length >= minLength) score++;
    if (password.length >= 12) score++;
    if (_letterRe.hasMatch(password) && _digitRe.hasMatch(password)) score++;
    if (RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[a-z]').hasMatch(password)) {
      score++;
    }
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(password)) score++;
    if (_weak.contains(password.toLowerCase())) score = score.clamp(0, 1);
    return score.clamp(0, 4);
  }

  static String strengthLabel(int score) {
    switch (score) {
      case 0:
      case 1:
        return 'Zaif';
      case 2:
        return "O'rtacha";
      case 3:
        return 'Yaxshi';
      default:
        return 'Mustahkam';
    }
  }
}
