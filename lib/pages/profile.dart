import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaizen/locale_provider.dart';
import 'package:zaizen/pages/profile_menus/language_screen.dart';
import 'package:zaizen/pages/profile_menus/profile_sub.dart' hide LanguageScreen;
import 'package:zaizen/pages/profile_menus/security_tab.dart';
import 'login.dart' show AppColors;

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<LocaleProvider>().strings;
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 8, 22, 110),
      physics: const BouncingScrollPhysics(),
      children: [
        Center(
          child: Column(
            children: [
              Container(
                width: 92,
                height: 92,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/avatar.png',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                      CupertinoIcons.person_fill,
                      color: AppColors.primary,
                      size: 40,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Aziz Karimov',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'aziz.karimov@gmail.com',
                style: TextStyle(color: AppColors.textMuted, fontSize: 13.5),
              ),
            ],
          ),
        ),
        const SizedBox(height: 26),
        _CardWrapper(
          child: Column(
            children: [
              _SettingsItem(
                icon: CupertinoIcons.person_fill,
                label: s.personalInfo,
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (_) => const PersonalInfoScreen()),
                  );
                },
              ),
              const _ItemDivider(),
              _SettingsItem(
                icon: CupertinoIcons.bell_fill,
                label: s.notifications,
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (_) => const NotificationsScreen()),
                  );
                },
              ),
              const _ItemDivider(),
              _SettingsItem(
                icon: CupertinoIcons.lock_fill,
                label: s.security,
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (_) => const SecurityScreen()),
                  );
                },
              ),
              const _ItemDivider(),
              _SettingsItem(
                icon: CupertinoIcons.globe,
                label: s.language,
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (_) => const LanguageScreen()),
                  );
                },
              ),
              const _ItemDivider(),
              _SettingsItem(
                icon: CupertinoIcons.question_circle_fill,
                label: s.helpCenter,
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (_) => const HelpCenterScreen()),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _CardWrapper(
          child: _SettingsItem(
            icon: CupertinoIcons.square_arrow_right,
            label: s.logout,
            danger: true,
            onTap: () => _showLogoutDialog(context, s),
          ),
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context, dynamic s) {
    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(s.logoutTitle),
        content: Text(s.logoutMessage),
        actions: [
          CupertinoDialogAction(
            child: Text(s.cancel),
            onPressed: () => Navigator.pop(ctx),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: Text(s.logout),
            onPressed: () {
              Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }
}

class _CardWrapper extends StatelessWidget {
  final Widget child;
  const _CardWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}

class _ItemDivider extends StatelessWidget {
  const _ItemDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, color: AppColors.border, indent: 60);
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool danger;

  const _SettingsItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = danger ? const Color(0xFFEF4444) : AppColors.primary;
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minSize: 0,
      onPressed: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 17),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: danger ? color : AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.5,
                ),
              ),
            ),
            if (!danger)
              const Icon(CupertinoIcons.chevron_right, color: AppColors.textMuted, size: 16),
          ],
        ),
      ),
    );
  }
}
