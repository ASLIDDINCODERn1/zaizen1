import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:zaizen/locale_provider.dart';

enum AppPermissionKind { notification, microphone, photos }

class AppPermissions {
  AppPermissions._();

  static Permission _native(AppPermissionKind kind) {
    switch (kind) {
      case AppPermissionKind.notification:
        return Permission.notification;
      case AppPermissionKind.microphone:
        return Permission.microphone;
      case AppPermissionKind.photos:
        return Permission.photos;
    }
  }

  static Future<bool> isGranted(AppPermissionKind kind) async {
    final status = await _native(kind).status;
    return status.isGranted || status.isLimited;
  }

  static Future<bool> ensure(BuildContext context, AppPermissionKind kind) async {
    if (await isGranted(kind)) return true;

    var status = await _native(kind).status;
    if (!status.isPermanentlyDenied && !status.isRestricted) {
      status = await _native(kind).request();
      if (status.isGranted || status.isLimited) return true;
    }

    if (!context.mounted) return false;
    final enable = await _askToEnable(context, kind);
    if (enable != true) return false;

    status = await _native(kind).status;
    if (status.isPermanentlyDenied || status.isRestricted) {
      await openAppSettings();
      return isGranted(kind);
    }

    status = await _native(kind).request();
    if (status.isGranted || status.isLimited) return true;
    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
    return isGranted(kind);
  }

  static Future<void> requestStartup(BuildContext context) async {
    for (final kind in AppPermissionKind.values) {
      if (!context.mounted) return;
      if (await isGranted(kind)) continue;
      await ensure(context, kind);
    }
  }

  static Future<bool?> _askToEnable(BuildContext context, AppPermissionKind kind) {
    final copy = _copy(context, kind);
    return showCupertinoDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(copy.$1),
        content: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(copy.$2),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(copy.$4),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(copy.$3),
          ),
        ],
      ),
    );
  }

  static (String, String, String, String) _copy(BuildContext context, AppPermissionKind kind) {
    var code = 'uz';
    try {
      code = context.read<LocaleProvider>().locale.languageCode;
    } catch (_) {}
    switch (code) {
      case 'ru':
        switch (kind) {
          case AppPermissionKind.notification:
            return ('Включите уведомления', 'Чтобы получать сообщения, разрешите уведомления.', 'Включить', 'Позже');
          case AppPermissionKind.microphone:
            return ('Включите микрофон', 'Для голоса в чате нужен микрофон.', 'Включить', 'Позже');
          case AppPermissionKind.photos:
            return ('Включите галерею', 'Для фото профиля нужен доступ к фото.', 'Включить', 'Позже');
        }
      case 'en':
        switch (kind) {
          case AppPermissionKind.notification:
            return ('Turn on notifications', 'Allow notifications to receive alerts.', 'Turn on', 'Later');
          case AppPermissionKind.microphone:
            return ('Turn on microphone', 'Chat voice needs microphone access.', 'Turn on', 'Later');
          case AppPermissionKind.photos:
            return ('Turn on photos', 'Profile photo needs gallery access.', 'Turn on', 'Later');
        }
      case 'ja':
        switch (kind) {
          case AppPermissionKind.notification:
            return ('通知をオン', '通知を受け取るには許可が必要です。', 'オン', '後で');
          case AppPermissionKind.microphone:
            return ('マイクをオン', 'チャットの音声にマイクが必要です。', 'オン', '後で');
          case AppPermissionKind.photos:
            return ('写真をオン', 'プロフィール写真にギャラリーが必要です。', 'オン', '後で');
        }
      default:
        switch (kind) {
          case AppPermissionKind.notification:
            return ('Bildirishnomalarni yoqing', 'Xabarlar uchun ruxsat kerak.', 'Yoqing', 'Keyinroq');
          case AppPermissionKind.microphone:
            return ('Mikrofonga ruxsat bering', 'Chatda ovoz uchun mikrofon kerak.', 'Yoqing', 'Keyinroq');
          case AppPermissionKind.photos:
            return ('Galereyani yoqing', 'Profil rasmi uchun galereya kerak.', 'Yoqing', 'Keyinroq');
        }
    }
  }
}
