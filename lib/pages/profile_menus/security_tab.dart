import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zaizen/pages/login.dart';
import 'package:zaizen/pages/profile_menus/app_lock.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool _hasPin = false;
  bool _isFingerprintSupported = false;
  bool _isFingerprintEnabled = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSecurityStatus();
  }

  Future<void> _loadSecurityStatus() async {
    final pin = await SecurityHelper.getSavedPin();
    final fpSupported = await SecurityHelper.isFingerprintAvailable();
    final fpEnabled = await SecurityHelper.isFingerprintEnabled();

    if (!mounted) return;
    setState(() {
      _hasPin = pin != null && pin.isNotEmpty;
      _isFingerprintSupported = fpSupported;
      _isFingerprintEnabled = fpEnabled;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.pop(context),
          child: const Icon(CupertinoIcons.chevron_back, color: AppColors.textPrimary),
        ),
        title: const Text(
          'Xavfsizlik',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
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
          child: _isLoading
              ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
              : ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    const Text(
                      'Qurilma himoyasi',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _SmoothContainer(
                      child: Column(
                        children: [
                          _ActionRow(
                            icon: CupertinoIcons.lock_shield_fill,
                            label: _hasPin ? "PIN kodni o'zgartirish" : "PIN kod o'rnatish",
                            onTap: () async {
                              await Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (_) => const AppLockScreen(
                                    isInitialSetup: true,
                                  ),
                                ),
                              );
                              _loadSecurityStatus();
                            },
                          ),
                          if (_hasPin) ...[
                            const _LineDivider(),
                            _ActionRow(
                              icon: CupertinoIcons.trash_fill,
                              label: "PIN kodni o'chirish",
                              danger: true,
                              onTap: _confirmRemovePin,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    if (_isFingerprintSupported) ...[
                      const Text(
                        'Biometrik himoya',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _SmoothContainer(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.fingerprint,
                                    color: AppColors.primary, size: 22),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Barmoq izi (Fingerprint)',
                                      style: TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      _hasPin
                                          ? 'Dasturga tezkor kirish uchun'
                                          : "Avval PIN kod o'rnating",
                                      style: const TextStyle(
                                          color: AppColors.textMuted, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              CupertinoSwitch(
                                value: _isFingerprintEnabled,
                                activeColor: AppColors.primary,
                                onChanged: _hasPin
                                    ? (val) async {
                                        if (val) {
                                          final ok =
                                              await SecurityHelper.authenticateWithBiometrics();
                                          if (ok) {
                                            await SecurityHelper.setFingerprintEnabled(true);
                                            setState(() => _isFingerprintEnabled = true);
                                          }
                                        } else {
                                          await SecurityHelper.setFingerprintEnabled(false);
                                          setState(() => _isFingerprintEnabled = false);
                                        }
                                      }
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surface.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border.withOpacity(0.5)),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(CupertinoIcons.info_circle_fill,
                              color: AppColors.primary, size: 18),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "PIN kod yoki barmoq izi o'rnatilgach, ilovadan chiqib qayta kirganingizda har safar xavfsizlik tekshiruvi amalga oshiriladi.",
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 12.5,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  void _confirmRemovePin() {
    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text("PIN kodni o'chirish"),
        content: const Text(
          "Haqiqatan ham PIN kod va barmoq izi xavfsizlik qulfini butunlay o'chirmoqchimisiz?",
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('Bekor qilish'),
            onPressed: () => Navigator.pop(ctx),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text("O'chirish"),
            onPressed: () async {
              await SecurityHelper.removePin();
              Navigator.pop(ctx);
              _loadSecurityStatus();
            },
          ),
        ],
      ),
    );
  }
}

class _SmoothContainer extends StatelessWidget {
  final Widget child;
  const _SmoothContainer({required this.child});

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

class _ActionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool danger;

  const _ActionRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = danger ? AppColors.error : AppColors.primary;
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minSize: 0,
      onPressed: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 14),
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

class _LineDivider extends StatelessWidget {
  const _LineDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, color: AppColors.border, indent: 64);
  }
}
