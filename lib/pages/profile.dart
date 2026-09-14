import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:zaizen/auth/auth_service.dart';
import 'package:zaizen/auth/profile_store.dart';
import 'package:zaizen/locale_provider.dart';
import 'package:zaizen/pages/profile_menus/personal_info.dart';
import 'package:zaizen/ui/app_theme.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  bool _busy = false;

  Future<void> _editName(BuildContext context) async {
    final store = context.read<ProfileStore>();
    final s = context.read<LocaleProvider>().strings;
    final ctrl = TextEditingController(text: store.name.isNotEmpty ? store.name : AuthService.instance.displayName);
    final ok = await showCupertinoDialog<bool>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(s.editName),
        content: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: CupertinoTextField(controller: ctrl),
        ),
        actions: [
          CupertinoDialogAction(child: Text(s.cancel), onPressed: () => Navigator.pop(ctx, false)),
          CupertinoDialogAction(child: Text(s.save), onPressed: () => Navigator.pop(ctx, true)),
        ],
      ),
    );
    if (ok == true && ctrl.text.trim().isNotEmpty) {
      await AuthService.instance.updateProfile(fullName: ctrl.text.trim());
      if (mounted) await context.read<ProfileStore>().refresh();
    }
  }

  Future<void> _editPhoto() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxWidth: 1024,
      maxHeight: 1024,
      requestFullMetadata: false,
    );
    if (picked == null) return;
    setState(() => _busy = true);
    try {
      final bytes = await picked.readAsBytes();
      final ext = picked.name.contains('.') ? picked.name.split('.').last : 'jpg';
      await AuthService.instance.uploadAvatar(bytes, ext);
      if (mounted) await context.read<ProfileStore>().refresh();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Map<String, String> _cardCopy(String code) {
    switch (code) {
      case 'ru':
        return {
          'lessons': 'Уроки',
          'lessonsSub': '0 уроков',
          'chat': 'Realtime chat',
          'chatSub': 'Живой чат',
          'practice': 'Практика',
          'practiceSub': 'Упражнения',
          'saved': 'Избранное',
          'savedSub': 'Закладки',
        };
      case 'en':
        return {
          'lessons': 'Lessons',
          'lessonsSub': '0 lessons',
          'chat': 'Realtime chat',
          'chatSub': 'Live messages',
          'practice': 'Practice',
          'practiceSub': 'Drills',
          'saved': 'Saved',
          'savedSub': 'Bookmarks',
        };
      case 'ja':
        return {
          'lessons': 'レッスン',
          'lessonsSub': '0レッスン',
          'chat': 'リアルタイムチャット',
          'chatSub': '直接メッセージ',
          'practice': '練習',
          'practiceSub': '問題',
          'saved': '保存',
          'savedSub': 'ブックマーク',
        };
      default:
        return {
          'lessons': 'Darslar',
          'lessonsSub': '0 ta dars',
          'chat': 'Realtime chat',
          'chatSub': 'Jonli suhbat',
          'practice': 'Mashq',
          'practiceSub': 'Mashqlar',
          'saved': 'Saqlangan',
          'savedSub': 'Belgilanganlar',
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watch<LocaleProvider>().strings;
    final code = context.watch<LocaleProvider>().locale.languageCode;
    final t = _cardCopy(code);
    final profile = context.watch<ProfileStore>();
    final auth = AuthService.instance;
    final avatar = profile.avatarUrl ?? auth.avatarUrl;
    final c = ZColors.of(context);
    final dark = context.watch<ThemeProvider>().isDark;
    return ListView(
      padding: PageGutters.of(context),
      physics: const BouncingScrollPhysics(),
      children: [
        Center(
          child: Column(
            children: [
              GestureDetector(
                onTap: _busy ? null : _editPhoto,
                child: Stack(
                  children: [
                    Container(
                      width: 92,
                      height: 92,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: c.primary, width: 2),
                      ),
                      child: ClipOval(
                        child: avatar != null
                            ? Image.network(
                                avatar,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Icon(
                                  CupertinoIcons.person_fill,
                                  color: c.primary,
                                  size: 40,
                                ),
                              )
                            : Icon(CupertinoIcons.person_fill, color: c.primary, size: 40),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: c.primary,
                        child: const Icon(CupertinoIcons.camera_fill, size: 12, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              GestureDetector(
                onTap: () => _editName(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        profile.name.isEmpty ? 'User' : profile.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: c.textPrimary, fontSize: 19, fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(CupertinoIcons.pencil, size: 16, color: c.textMuted),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                profile.email.isEmpty ? auth.email : profile.email,
                style: TextStyle(color: c.textMuted, fontSize: 13.5),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Row(
          children: [
            Expanded(
              child: _GlassCard(
                dark: dark,
                icon: CupertinoIcons.book_fill,
                color: const Color(0xFF3B82F6),
                title: t['lessons']!,
                subtitle: t['lessonsSub']!,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _GlassCard(
                dark: dark,
                icon: CupertinoIcons.chat_bubble_2_fill,
                color: const Color(0xFF22C55E),
                title: t['chat']!,
                subtitle: t['chatSub']!,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _GlassCard(
                dark: dark,
                icon: CupertinoIcons.bolt_fill,
                color: const Color(0xFFF59E0B),
                title: t['practice']!,
                subtitle: t['practiceSub']!,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _GlassCard(
                dark: dark,
                icon: CupertinoIcons.bookmark_fill,
                color: const Color(0xFFA855F7),
                title: t['saved']!,
                subtitle: t['savedSub']!,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Container(
          decoration: BoxDecoration(
            color: c.surface.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: c.border.withValues(alpha: 0.6)),
          ),
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            minSize: 0,
            onPressed: () {
              Navigator.push(context, CupertinoPageRoute(builder: (_) => const PersonalInfoScreen()));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: c.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(CupertinoIcons.person_crop_circle_fill, color: c.primary, size: 17),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      s.personalInfo,
                      style: TextStyle(color: c.textPrimary, fontWeight: FontWeight.w600, fontSize: 14.5),
                    ),
                  ),
                  Icon(CupertinoIcons.chevron_right, color: c.textMuted, size: 16),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _GlassCard extends StatelessWidget {
  final bool dark;
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  const _GlassCard({
    required this.dark,
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 122,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: dark
              ? [color.withValues(alpha: 0.22), const Color(0xFF11151F).withValues(alpha: 0.88)]
              : [color.withValues(alpha: 0.16), Colors.white.withValues(alpha: 0.86)],
        ),
        border: Border.all(color: (dark ? Colors.white : color).withValues(alpha: dark ? 0.10 : 0.22), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const Spacer(),
          Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: dark ? Colors.white : const Color(0xFF0F172A), fontWeight: FontWeight.w700, fontSize: 14.5)),
          const SizedBox(height: 2),
          Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: dark ? const Color(0xFF9AA3B2) : const Color(0xFF64748B), fontSize: 12)),
        ],
      ),
    );
  }
}
