import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  static const redirectUrl = 'io.zaizen.app://login-callback/';

  SupabaseClient get _client => Supabase.instance.client;

  User? get currentUser => _client.auth.currentUser;
  Session? get session => _client.auth.currentSession;
  bool get isLoggedIn => session != null;

  Stream<AuthState> get authChanges => _client.auth.onAuthStateChange;

  String get displayName {
    final user = currentUser;
    if (user == null) return '';
    final meta = user.userMetadata ?? {};
    return (meta['full_name'] ?? meta['name'] ?? user.email ?? 'User').toString();
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

  Future<void> signInWithEmail(String email, String password) async {
    await _client.auth.signInWithPassword(email: email.trim(), password: password);
    await upsertProfile();
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
  }) async {
    await _client.auth.signUp(
      email: email.trim(),
      password: password,
      data: {'full_name': fullName.trim()},
    );
    await upsertProfile(fullName: fullName.trim());
  }

  Future<void> resetPassword(String email) async {
    await _client.auth.resetPasswordForEmail(email.trim(), redirectTo: redirectUrl);
  }

  Future<void> signInWithGoogle() async {
    await _client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: redirectUrl,
      authScreenLaunchMode: LaunchMode.externalApplication,
    );
  }

  Future<void> signInWithFacebook() async {
    await _client.auth.signInWithOAuth(
      OAuthProvider.facebook,
      redirectTo: redirectUrl,
      authScreenLaunchMode: LaunchMode.externalApplication,
    );
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
    if (user == null) throw Exception('Not signed in');
    final path = '${user.id}/avatar.$fileExt';
    await _client.storage.from('avatars').uploadBinary(
          path,
          bytes,
          fileOptions: const FileOptions(upsert: true),
        );
    final url = _client.storage.from('avatars').getPublicUrl(path);
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
      await _client.rpc('delete_own_account');
    } catch (_) {}
    await _client.auth.signOut();
  }
}
