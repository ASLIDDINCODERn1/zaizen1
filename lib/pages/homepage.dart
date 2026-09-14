import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:zaizen/auth/profile_store.dart';
import 'package:zaizen/locale_provider.dart';
import 'package:zaizen/pages/notifications_inbox.dart';
import 'package:zaizen/pages/profile.dart';
import 'package:zaizen/pages/settings.dart';
import 'package:zaizen/ui/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tabIndex = 0;
  final List<Widget> _pages = const [_HomeTab(), _LeaderboardTab(), ProfileTab(), SettingsTab()];

  @override
  Widget build(BuildContext context) {
    final c = ZColors.of(context);
    final dark = context.watch<ThemeProvider>().isDark;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: dark ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        extendBody: true,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [c.bgTop, c.bgBottom],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            top: false,
            bottom: false,
            child: IndexedStack(index: _tabIndex, children: _pages),
          ),
        ),
        bottomNavigationBar: _FloatingNavBar(currentIndex: _tabIndex, onTap: (i) => setState(() => _tabIndex = i)),
      ),
    );
  }
}

class _FloatingNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const _FloatingNavBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<LocaleProvider>().strings;
    final c = ZColors.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(PageGutters.navSide(context), 0, PageGutters.navSide(context), 18),
      child: Container(
        height: 66,
        decoration: BoxDecoration(
          color: c.surface.withValues(alpha: 0.94),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: c.border.withValues(alpha: 0.35), width: 0.6),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.10), blurRadius: 18, offset: const Offset(0, 8))],
        ),
        child: Row(
          children: [
            _NavButton(icon: currentIndex == 0 ? CupertinoIcons.house_fill : CupertinoIcons.house, label: s.navHome, active: currentIndex == 0, onTap: () => onTap(0)),
            _NavButton(icon: currentIndex == 1 ? CupertinoIcons.chart_bar_fill : CupertinoIcons.chart_bar, label: s.navRating, active: currentIndex == 1, onTap: () => onTap(1)),
            _NavButton(icon: currentIndex == 2 ? CupertinoIcons.person_fill : CupertinoIcons.person, label: s.navProfile, active: currentIndex == 2, onTap: () => onTap(2)),
            _NavButton(icon: currentIndex == 3 ? CupertinoIcons.gear_alt_fill : CupertinoIcons.gear, label: s.navSettings, active: currentIndex == 3, onTap: () => onTap(3)),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _NavButton({required this.icon, required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = ZColors.of(context);
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: active ? c.primary.withValues(alpha: 0.16) : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, size: 20, color: active ? c.primary : c.textMuted),
            ),
            const SizedBox(height: 2),
            FittedBox(
              child: Text(
                label,
                maxLines: 1,
                style: TextStyle(fontSize: 10, fontWeight: active ? FontWeight.w700 : FontWeight.w500, color: active ? c.primary : c.textMuted),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SmoothCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  const _SmoothCard({required this.child, this.padding = const EdgeInsets.all(16)});
  @override
  Widget build(BuildContext context) {
    final c = ZColors.of(context);
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: c.surface.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.border.withValues(alpha: 0.55), width: 0.7),
      ),
      child: child,
    );
  }
}

Map<String, String> _hubCopy(String code) {
  switch (code) {
    case 'ru':
      return {
        'lessons': 'Уроки',
        'lessonsSub': 'Начать урок',
        'chat': 'Чат',
        'chatSub': 'Realtime',
        'practice': 'Практика',
        'practiceSub': 'Упражнения',
        'saved': 'Избранное',
        'savedSub': 'Ваши закладки',
        'boardEmpty': 'Пока пусто',
        'boardHint': 'Рейтинг появится после realtime',
      };
    case 'en':
      return {
        'lessons': 'Lessons',
        'lessonsSub': 'Start a lesson',
        'chat': 'Chat',
        'chatSub': 'Realtime',
        'practice': 'Practice',
        'practiceSub': 'Drills',
        'saved': 'Saved',
        'savedSub': 'Your bookmarks',
        'boardEmpty': 'No rankings yet',
        'boardHint': 'Players will appear here in realtime',
      };
    case 'ja':
      return {
        'lessons': 'レッスン',
        'lessonsSub': '学習を始める',
        'chat': 'チャット',
        'chatSub': 'リアルタイム',
        'practice': '練習',
        'practiceSub': '問題',
        'saved': '保存',
        'savedSub': 'ブックマーク',
        'boardEmpty': 'まだランキングはありません',
        'boardHint': 'リアルタイムで表示されます',
      };
    default:
      return {
        'lessons': 'Darslar',
        'lessonsSub': 'Darsni boshlash',
        'chat': 'Chat',
        'chatSub': 'Realtime',
        'practice': 'Mashq',
        'practiceSub': 'Mashqlar',
        'saved': 'Saqlangan',
        'savedSub': 'Belgilanganlar',
        'boardEmpty': 'Hozircha reyting bo\'sh',
        'boardHint': 'Realtime ulagach, o\'yinchilar shu yerda chiqadi',
      };
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();
  @override
  Widget build(BuildContext context) {
    final s = context.watch<LocaleProvider>().strings;
    final t = _hubCopy(context.watch<LocaleProvider>().locale.languageCode);
    final profile = context.watch<ProfileStore>();
    final avatar = profile.avatarUrl;
    final c = ZColors.of(context);
    return ListView(
      padding: PageGutters.of(context),
      physics: const BouncingScrollPhysics(),
      children: [
        Row(children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: c.primary, width: 1.6)),
            child: ClipOval(
              child: avatar != null && avatar.isNotEmpty
                  ? Image.network(avatar, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Icon(CupertinoIcons.person_fill, color: c.primary))
                  : Icon(CupertinoIcons.person_fill, color: c.primary),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(s.welcome, style: TextStyle(color: c.textMuted, fontSize: 13)),
            Text(profile.name.isEmpty ? 'User' : profile.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: c.textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
          ])),
          _IconCircle(icon: CupertinoIcons.bell, onTap: () {
            Navigator.of(context).push(CupertinoPageRoute(builder: (_) => const NotificationsInboxScreen()));
          }),
        ]),
        const SizedBox(height: 20),
        Row(children: [
          Expanded(child: _StatCard(icon: CupertinoIcons.star_fill, value: '0', label: s.score, color: c.primary)),
          const SizedBox(width: 10),
          Expanded(child: _StatCard(icon: CupertinoIcons.flame_fill, value: '0', label: s.streak, color: c.primary)),
          const SizedBox(width: 10),
          Expanded(child: _StatCard(icon: CupertinoIcons.rosette, value: '#0', label: s.rank, color: c.primary)),
        ]),
        const SizedBox(height: 18),
        _FeatureCard(
          icon: CupertinoIcons.square_favorites_alt_fill,
          title: t['lessons']!,
          subtitle: t['lessonsSub']!,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _MiniCard(icon: CupertinoIcons.bubble_left_bubble_right_fill, title: t['chat']!, subtitle: t['chatSub']!)),
            const SizedBox(width: 10),
            Expanded(child: _MiniCard(icon: CupertinoIcons.compass_fill, title: t['practice']!, subtitle: t['practiceSub']!)),
          ],
        ),
        const SizedBox(height: 10),
        _StripCard(icon: CupertinoIcons.bookmark_fill, title: t['saved']!, subtitle: t['savedSub']!),
      ],
    );
  }
}

class _Pane extends StatelessWidget {
  final Widget child;
  final double? height;
  const _Pane({required this.child, this.height});

  @override
  Widget build(BuildContext context) {
    final c = ZColors.of(context);
    return Container(
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: c.surface.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06), width: 0.8),
      ),
      child: child,
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _FeatureCard({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final c = ZColors.of(context);
    return _Pane(
      height: 108,
      child: Stack(
        children: [
          Positioned(
            right: -18,
            top: -24,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(shape: BoxShape.circle, color: c.primary.withValues(alpha: 0.10)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 14, 16),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: c.primary.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: c.primary, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(title, style: TextStyle(color: c.textPrimary, fontWeight: FontWeight.w700, fontSize: 17)),
                      const SizedBox(height: 4),
                      Text(subtitle, style: TextStyle(color: c.textMuted, fontSize: 13)),
                    ],
                  ),
                ),
                Icon(CupertinoIcons.chevron_forward, size: 16, color: c.textMuted),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _MiniCard({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final c = ZColors.of(context);
    return _Pane(
      height: 118,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: c.primary.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: c.primary, size: 18),
            ),
            const Spacer(),
            Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: c.textPrimary, fontWeight: FontWeight.w700, fontSize: 15)),
            const SizedBox(height: 2),
            Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: c.textMuted, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _StripCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _StripCard({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final c = ZColors.of(context);
    return _Pane(
      height: 64,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: c.primary.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: c.primary, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: c.textPrimary, fontWeight: FontWeight.w700, fontSize: 14.5)),
                  Text(subtitle, style: TextStyle(color: c.textMuted, fontSize: 12)),
                ],
              ),
            ),
            Icon(CupertinoIcons.chevron_forward, size: 16, color: c.textMuted),
          ],
        ),
      ),
    );
  }
}

class _IconCircle extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconCircle({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final c = ZColors.of(context);
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minSize: 0,
      onPressed: onTap,
      child: Container(
        width: 44, height: 44,
        decoration: BoxDecoration(color: c.surface, shape: BoxShape.circle, border: Border.all(color: c.border.withValues(alpha: 0.5), width: 0.7)),
        child: Icon(icon, color: c.primary, size: 19),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  const _StatCard({required this.icon, required this.value, required this.label, required this.color});
  @override
  Widget build(BuildContext context) {
    final c = ZColors.of(context);
    return _SmoothCard(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      child: Column(children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 8),
        FittedBox(child: Text(value, style: TextStyle(color: c.textPrimary, fontWeight: FontWeight.w700, fontSize: 15))),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(color: c.textMuted, fontSize: 11)),
      ]),
    );
  }
}

class _LeaderboardTab extends StatelessWidget {
  const _LeaderboardTab();

  @override
  Widget build(BuildContext context) {
    final s = context.watch<LocaleProvider>().strings;
    final t = _hubCopy(context.watch<LocaleProvider>().locale.languageCode);
    final c = ZColors.of(context);
    return ListView(
      padding: PageGutters.of(context),
      physics: const BouncingScrollPhysics(),
      children: [
        Text(s.leaderboardTitle, style: TextStyle(color: c.textPrimary, fontSize: 22, fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text(s.leaderboardSub, style: TextStyle(color: c.textMuted, fontSize: 13.5)),
        const SizedBox(height: 48),
        Center(
          child: Column(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: c.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(CupertinoIcons.chart_bar_alt_fill, color: c.primary, size: 28),
              ),
              const SizedBox(height: 16),
              Text(
                t['boardEmpty']!,
                textAlign: TextAlign.center,
                style: TextStyle(color: c.textPrimary, fontWeight: FontWeight.w700, fontSize: 16),
              ),
              const SizedBox(height: 6),
              Text(
                t['boardHint']!,
                textAlign: TextAlign.center,
                style: TextStyle(color: c.textMuted, fontSize: 13.5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
