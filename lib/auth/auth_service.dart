import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zaizen/auth/password_rules.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  static const redirectUrl = 'io.zaizen.app://login-callback/';
  static const mediaBucket = 'zaizen';

  bool _listening = false;

  SupabaseClient get client => _client;
  SupabaseClient get _client => Supabase.instance.client;

  User? get currentUser => _client.auth.currentUser;
  Session? get session => _client.auth.currentSession;
  bool get isLoggedIn => session != null;

  Stream<AuthState> get authChanges => _client.auth.onAuthStateChange;

  String get displayName {
    final user = currentUser;
    if (user == null) return '';
    final meta = user.userMetadata ?? {};
    final name = (meta['full_name'] ?? meta['name'] ?? '').toString().trim();
    if (name.isNotEmpty) return name;
    return user.email ?? 'User';
  }

  String get email => currentUser?.email ?? '';

  String? get avatarUrl {
    final user = currentUser;
    if (user == null) return null;
    final meta = user.userMetadata ?? {};
    final fromMeta = meta['avatar_url'] ?? meta['picture'];
    if (fromMeta is String && fromMeta.isNotEmpty) return fromMeta;
    return null;
  }

  void startSessionListener() {
    if (_listening) return;
    _listening = true;
    _client.auth.onAuthStateChange.listen((data) async {
      final event = data.event;
      if (event == AuthChangeEvent.signedIn ||
          event == AuthChangeEvent.userUpdated ||
          event == AuthChangeEvent.tokenRefreshed) {
        try {
          await upsertProfile();
        } catch (_) {}
      }
    });
  }

  Future<AuthResponse> signInWithEmail(String email, String password) async {
    final emailErr = PasswordRules.emailError(email);
    if (emailErr != null) throw AuthFailure(emailErr);
    if (password.isEmpty) throw AuthFailure('Parol kiriting.');
    try {
      final res = await _client.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );
      await upsertProfile();
      return res;
    } catch (e) {
      throw AuthFailure(mapAuthError(e));
    }
  }

  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final nameErr = PasswordRules.nameError(fullName);
    if (nameErr != null) throw AuthFailure(nameErr);
    final emailErr = PasswordRules.emailError(email);
    if (emailErr != null) throw AuthFailure(emailErr);
    final passErr = PasswordRules.passwordError(password, email: email);
    if (passErr != null) throw AuthFailure(passErr);
    try {
      final res = await _client.auth.signUp(
        email: email.trim(),
        password: password,
        data: {
          'full_name': fullName.trim(),
          'name': fullName.trim(),
        },
        emailRedirectTo: redirectUrl,
      );
      if (res.session != null) {
        await upsertProfile(fullName: fullName.trim());
      }
      return res;
    } catch (e) {
      throw AuthFailure(mapAuthError(e));
    }
  }

  Future<void> resetPassword(String email) async {
    final emailErr = PasswordRules.emailError(email);
    if (emailErr != null) throw AuthFailure(emailErr);
    try {
      await _client.auth.resetPasswordForEmail(
        email.trim(),
        redirectTo: redirectUrl,
      );
    } catch (e) {
      throw AuthFailure(mapAuthError(e));
    }
  }

  Future<void> updatePassword(String newPassword) async {
    final passErr = PasswordRules.passwordError(newPassword, email: email);
    if (passErr != null) throw AuthFailure(passErr);
    try {
      await _client.auth.updateUser(UserAttributes(password: newPassword));
    } catch (e) {
      throw AuthFailure(mapAuthError(e));
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final ok = await _client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: redirectUrl,
        authScreenLaunchMode: LaunchMode.externalApplication,
      );
      if (!ok) {
        throw AuthFailure('Google orqali kirish bekor qilindi.');
      }
    } catch (e) {
      if (e is AuthFailure) rethrow;
      throw AuthFailure(mapAuthError(e));
    }
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  Future<void> upsertProfile({String? fullName, String? avatar}) async {
    final user = currentUser;
    if (user == null) return;
    await _client.from('profiles').upsert({
      'id': user.id,
      'email': user.email,
      'full_name': fullName ?? displayName,
      if (avatar != null) 'avatar_url': avatar,
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> updateProfile({String? fullName, String? avatarUrl}) async {
    final data = <String, dynamic>{};
    if (fullName != null) data['full_name'] = fullName;
    if (avatarUrl != null) data['avatar_url'] = avatarUrl;
    if (data.isNotEmpty) {
      await _client.auth.updateUser(UserAttributes(data: data));
    }
    await upsertProfile(fullName: fullName, avatar: avatarUrl);
  }

  Future<String> uploadAvatar(Uint8List bytes, String fileExt) async {
    final user = currentUser;
    if (user == null) throw AuthFailure('Avval tizimga kiring');
    final ext = fileExt.toLowerCase().replaceAll('.', '');
    final path = '${user.id}/avatar.$ext';
    await _client.storage.from(mediaBucket).uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(
            upsert: true,
            contentType: ext == 'png' ? 'image/png' : 'image/jpeg',
          ),
        );
    final url = _client.storage.from(mediaBucket).getPublicUrl(path);
    final withTs = '$url?t=${DateTime.now().millisecondsSinceEpoch}';
    await updateProfile(avatarUrl: withTs);
    return withTs;
  }

  Future<void> deleteAccount() async {
    final user = currentUser;
    if (user == null) return;
    try {
      await _client.from('profiles').delete().eq('id', user.id);
    } catch (_) {}
    try {
      await _client.storage.from(mediaBucket).remove([
        '${user.id}/avatar.png',
        '${user.id}/avatar.jpg',
        '${user.id}/avatar.jpeg',
        '${user.id}/avatar.webp',
      ]);
    } catch (_) {}
    try {
      await _client.rpc('delete_own_account');
    } catch (e) {
      await _client.auth.signOut();
      throw AuthFailure(
        "Akkaunt sessiyasi yopildi. To'liq o'chirish uchun Supabase SQL (delete_own_account) ni ishga tushiring.",
      );
    }
    await _client.auth.signOut();
  }

  static String mapAuthError(Object e) {
    final raw = e.toString().toLowerCase();
    if (e is AuthException) {
      final msg = e.message.toLowerCase();
      if (msg.contains('invalid login credentials')) {
        return "Email yoki parol noto'g'ri.";
      }
      if (msg.contains('email not confirmed')) {
        return 'Avval emailingizni tasdiqlang (pochta qutingizni tekshiring).';
      }
      if (msg.contains('user already registered')) {
        return "Bu email allaqachon ro'yxatdan o'tgan. Kirishga urinib ko'ring.";
      }
      if (msg.contains('password should be at least') ||
          msg.contains('password is known to be weak')) {
        return "Parol kamida 8 belgi, harf va raqamdan iborat bo'lsin.";
      }
      if (msg.contains('unsupported provider') ||
          msg.contains('provider is not enabled') ||
          msg.contains('validation failed')) {
        return "Google provider Supabase dashboardda yoqilmagan.";
      }
      if (msg.contains('rate limit') || msg.contains('over_email_send_rate')) {
        return "Juda ko'p urinish. Birozdan so'ng qayta urinib ko'ring.";
      }
      return e.message;
    }
    if (raw.contains('unsupported provider') ||
        raw.contains('provider is not enabled') ||
        raw.contains('unable to exchange external code')) {
      return "Google provider Supabase dashboardda yoqilmagan yoki Client ID noto'g'ri.";
    }
    if (raw.contains('network') || raw.contains('socket') || raw.contains('failed host')) {
      return "Internet yo'q yoki serverga ulanib bo'lmadi.";
    }
    return e.toString().replaceFirst('Exception: ', '');
  }
}

class AuthFailure implements Exception {
  final String message;
  AuthFailure(this.message);

  @override
  String toString() => message;
}
