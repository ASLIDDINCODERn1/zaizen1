import 'package:permission_handler/permission_handler.dart';

class AppPermissions {
  AppPermissions._();

  static bool _busy = false;

  static Future<void> requestStartup() async {
    if (_busy) return;
    _busy = true;
    try {
      for (final permission in <Permission>[
        Permission.notification,
        Permission.microphone,
        Permission.photos,
      ]) {
        final status = await permission.status;
        if (status.isGranted || status.isLimited) continue;
        if (status.isPermanentlyDenied) continue;
        await permission.request();
      }
    } catch (_) {
    } finally {
      _busy = false;
    }
  }
}
