import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:zaizen/auth/profile_store.dart';
import 'package:zaizen/locale_provider.dart';
import 'package:zaizen/pages/notifications_inbox.dart';
import 'package:zaizen/pages/profile.dart';

import 'login.dart' show AppColors;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tabIndex = 0;

  final List<Widget> _pages = const [
    _HomeTab(),
    _LeaderboardTab(),
    ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        extendBody: true,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.bgTop, AppColors.bgBottom],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 0.6],
            ),
          ),
          child: SafeArea(
            top: false,
            bottom: false,
            child: IndexedStack(index: _tabIndex, children: _pages),
          ),
        ),
        bottomNavigationBar: _FloatingNavBar(
          currentIndex: _tabIndex,
          onTap: (i) => setState(() => _tabIndex = i),
        ),
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 22),
      child: Container(
        height: 68,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _NavButton(icon: CupertinoIcons.house_fill, label: s.navHome, active: currentIndex == 0, onTap: () => onTap(0)),
            _NavButton(icon: CupertinoIcons.chart_bar, label: s.navRating, active: currentIndex == 1, onTap: () => onTap(1)),
            _NavButton(icon: CupertinoIcons.person_fill, label: s.navProfile, active: currentIndex == 2, onTap: () => onTap(2)),
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
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
          decoration: BoxDecoration(
            color: active ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 22, color: active ? Colors.white : AppColors.textMuted),
              const SizedBox(height: 3),
              Text(label, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: active ? Colors.white : AppColors.textMuted)),
            ],
          ),
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
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    final s = context.watch<LocaleProvider>().strings;
    final profile = context.watch<ProfileStore>();
    final avatar = profile.avatarUrl;
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 28, 22, 110),
      physics: const BouncingScrollPhysics(),
      children: [
        Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 1.6),
              ),
              child: ClipOval(
                child: avatar != null && avatar.isNotEmpty
                    ? Image.network(
                        avatar,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(CupertinoIcons.person_fill, color: AppColors.primary),
                      )
                    : const Icon(CupertinoIcons.person_fill, color: AppColors.primary),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.welcome, style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
                  Text(
                    profile.name.isEmpty ? 'User' : profile.name,
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            _IconCircle(
              icon: CupertinoIcons.bell_fill,
              onTap: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(builder: (_) => const NotificationsInboxScreen()),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 22),
        Row(
          children: [
            Expanded(child: _StatCard(icon: CupertinoIcons.star_fill, value: '1,248', label: s.score, color: AppColors.primary)),
            const SizedBox(width: 12),
            Expanded(child: _StatCard(icon: CupertinoIcons.flame_fill, value: '12', label: s.streak, color: const Color(0xFFEA580C))),
            const SizedBox(width: 12),
            Expanded(child: _StatCard(icon: CupertinoIcons.rosette, value: '#7', label: s.rank, color: const Color(0xFFEAB308))),
          ],
        ),
        const SizedBox(height: 26),
        Text(s.todayGoal, style: const TextStyle(color: AppColors.textPrimary, fontSize: 17, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        _SmoothCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.15), borderRadius: BorderRadius.circular(14)),
                    child: const Icon(CupertinoIcons.checkmark_seal_fill, color: AppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s.finishLessons, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 15)),
                        const SizedBox(height: 2),
                        Text(s.lessonsProgress, style: const TextStyle(color: AppColors.textMuted, fontSize: 12.5)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: const LinearProgressIndicator(
                  value: 0.66,
                  minHeight: 8,
                  backgroundColor: AppColors.border,
                  valueColor: AlwaysStoppedAnimation(AppColors.primary),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 26),
        Text(s.recentActivity, style: const TextStyle(color: AppColors.textPrimary, fontSize: 17, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        _ActivityTile(icon: CupertinoIcons.book_fill, title: s.activityLesson, subtitle: s.hoursAgo, trailing: '+120'),
        const SizedBox(height: 10),
        _ActivityTile(icon: CupertinoIcons.chat_bubble_2_fill, title: s.activityGroup, subtitle: s.yesterday, trailing: '+40'),
        const SizedBox(height: 10),
        _ActivityTile(icon: CupertinoIcons.line_horizontal_3_decrease_circle, title: s.activityWeekly, subtitle: s.twoDaysAgo, trailing: '+300'),
      ],
    );
  }
}

class _IconCircle extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconCircle({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minSize: 0,
      onPressed: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(icon, color: AppColors.primary, size: 19),
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
    return _SmoothCard(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 15)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 11.5)),
        ],
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String trailing;
  const _ActivityTile({required this.icon, required this.title, required this.subtitle, required this.trailing});

  @override
  Widget build(BuildContext context) {
    return _SmoothCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.15), borderRadius: BorderRadius.circular(13)),
            child: Icon(icon, color: AppColors.primary, size: 19),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 14.5)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
              ],
            ),
          ),
          Text(trailing, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 13.5)),
        ],
      ),
    );
  }
}

class _LeaderboardTab extends StatelessWidget {
  const _LeaderboardTab();

  static const List<Map<String, dynamic>> _users = [
    {'name': 'Malika Yusupova', 'score': 3120, 'rank': 1},
    {'name': 'Jasur Toshev', 'score': 2890, 'rank': 2},
    {'name': 'Dilnoza Rahimova', 'score': 2640, 'rank': 3},
    {'name': 'You', 'score': 1248, 'rank': 7, 'isMe': true},
    {'name': 'Sardor Aliyev', 'score': 1120, 'rank': 8},
    {'name': 'Kamola Nabieva', 'score': 980, 'rank': 9},
  ];

  Color _rankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFEAB308);
      case 2:
        return const Color(0xFFB0B8C9);
      case 3:
        return const Color(0xFFCD7F32);
      default:
        return AppColors.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watch<LocaleProvider>().strings;
    final me = context.watch<ProfileStore>().name;
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 8, 22, 110),
      physics: const BouncingScrollPhysics(),
      children: [
        Text(s.leaderboardTitle, style: const TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text(s.leaderboardSub, style: const TextStyle(color: AppColors.textMuted, fontSize: 13.5)),
        const SizedBox(height: 18),
        for (final u in _users) ...[
          _SmoothCard(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                SizedBox(
                  width: 28,
                  child: Text('#${u['rank']}', style: TextStyle(color: _rankColor(u['rank'] as int), fontWeight: FontWeight.w700, fontSize: 14)),
                ),
                const SizedBox(width: 8),
                const CircleAvatar(
                  radius: 19,
                  backgroundColor: AppColors.border,
                  child: Icon(CupertinoIcons.person_fill, color: AppColors.textMuted, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    (u['isMe'] == true && me.isNotEmpty) ? me : u['name'] as String,
                    style: TextStyle(
                      color: (u['isMe'] == true) ? AppColors.primary : AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.5,
                    ),
                  ),
                ),
                if ((u['rank'] as int) <= 3) Icon(CupertinoIcons.rosette, color: _rankColor(u['rank'] as int), size: 18),
                const SizedBox(width: 6),
                Text('${u['score']}', style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600, fontSize: 13.5)),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}
