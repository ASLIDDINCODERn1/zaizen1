import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthLinks {
  AuthLinks._();
  static final AuthLinks instance = AuthLinks._();

  StreamSubscription<Uri>? _sub;
  bool _started = false;

  Future<void> start() async {
    if (_started) return;
    _started = true;
    final links = AppLinks();
    try {
      final initial = await links.getInitialLink();
      if (initial != null) await consume(initial);
    } catch (_) {}
    _sub = links.uriLinkStream.listen(consume);
  }

  Future<void> consume(Uri uri) async {
    if (!uri.toString().contains('login-callback')) return;
    try {
      await Supabase.instance.client.auth.getSessionFromUrl(uri);
    } catch (_) {}
  }
}
