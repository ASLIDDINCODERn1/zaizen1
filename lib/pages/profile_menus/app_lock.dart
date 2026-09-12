import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:zaizen/l10n/app_strings.dart';
import 'package:zaizen/locale_provider.dart';
import 'package:zaizen/pages/homepage.dart';
import 'package:zaizen/ui/language_picker_bar.dart';

class AppColors {
  static const Color bgTop = Color(0xFF0F172A);
  static const Color bgBottom = Color(0xFF020617);
  static const Color surface = Color(0xFF1E293B);
  static const Color border = Color(0xFF334155);
  static const Color primary = Color(0xFF3B82F6);
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color textSecondary = Color(0xFFCBD5E1);
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
}

class SecurityHelper {
  static const String _keyPin = 'user_security_pin';
  static const String _keyPinEnabled = 'is_pin_enabled';
  static const String _keyFingerprintEnabled = 'is_fingerprint_enabled';

  static final LocalAuthentication _auth = LocalAuthentication();
  static bool isAuthenticating = false;

  static Future<bool> isFingerprintAvailable() async {
    try {
      final bool isSupported = await _auth.isDeviceSupported();
      final bool canCheck = await _auth.canCheckBiometrics;
      final List<BiometricType> available = await _auth.getAvailableBiometrics();
      return isSupported || canCheck || available.isNotEmpty;
    } catch (e) {
      return true;
    }
  }

  static Future<bool> authenticateWithBiometrics() async {
    try {
      isAuthenticating = true;
      final bool didAuth = await _auth.authenticate(
        localizedReason: LanguageScope.strings.biometricReason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
          useErrorDialogs: true,
          sensitiveTransaction: false,
        ),
      );
      return didAuth;
    } on PlatformException catch (e) {
      debugPrint('Biometrika PlatformException: ${e.code} - ${e.message}');
      return false;
    } catch (e) {
      return false;
    } finally {
      Future.delayed(const Duration(milliseconds: 600), () {
        isAuthenticating = false;
      });
    }
  }

  static Future<String?> getSavedPin() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isEnabled = prefs.getBool(_keyPinEnabled) ?? false;
    if (!isEnabled) return null;
    return prefs.getString(_keyPin);
  }

  static Future<void> savePin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPin, pin);
    await prefs.setBool(_keyPinEnabled, true);
    await prefs.setBool(_keyFingerprintEnabled, true);
  }

  static Future<void> removePin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyPin);
    await prefs.setBool(_keyPinEnabled, false);
    await prefs.setBool(_keyFingerprintEnabled, false);
  }

  static Future<bool> isFingerprintEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyFingerprintEnabled) ?? true;
  }

  static Future<void> setFingerprintEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyFingerprintEnabled, enabled);
  }
}

enum LockScreenMode { unlock, createPin, confirmPin }

class AppLockScreen extends StatefulWidget {
  final VoidCallback? onAuthenticated;
  final bool isInitialSetup;
  final Widget? nextScreen;

  const AppLockScreen({
    super.key,
    this.onAuthenticated,
    this.isInitialSetup = false,
    this.nextScreen,
  });

  @override
  State<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends State<AppLockScreen> with SingleTickerProviderStateMixin {
  LockScreenMode _mode = LockScreenMode.unlock;
  String _enteredPin = '';
  String _tempNewPin = '';
  String? _savedPin;
  String? _errorMessage;

  bool _isFingerprintSupported = true;
  bool _isLoading = true;
  bool _isSubmitting = false;
  bool _isSuccess = false;

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 10)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_shakeController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _shakeController.reverse();
        }
      });
    _initSecurity();
  }

  Future<void> _initSecurity() async {
    final savedPin = await SecurityHelper.getSavedPin();
    final fpSupported = await SecurityHelper.isFingerprintAvailable();
    final fpEnabled = await SecurityHelper.isFingerprintEnabled();
    if (!mounted) return;
    setState(() {
      _savedPin = savedPin;
      _isFingerprintSupported = fpSupported && fpEnabled;
      _isLoading = false;
      if (widget.isInitialSetup || savedPin == null || savedPin.isEmpty) {
        _mode = LockScreenMode.createPin;
      } else {
        _mode = LockScreenMode.unlock;
      }
    });
    if (_mode == LockScreenMode.unlock && _isFingerprintSupported) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 350), () {
          if (mounted) _tryBiometrics();
        });
      });
    }
  }

  Future<void> _tryBiometrics() async {
    if (_isSubmitting || _isSuccess) return;
    _isSubmitting = true;
    final success = await SecurityHelper.authenticateWithBiometrics();
    _isSubmitting = false;
    if (success && mounted) {
      _goToHomeScreen();
    }
  }

  void _goToHomeScreen() {
    if (_isSuccess) return;
    setState(() => _isSuccess = true);
    HapticFeedback.mediumImpact();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      if (widget.onAuthenticated != null) {
        try {
          widget.onAuthenticated!();
        } catch (e) {
          debugPrint('onAuthenticated callback xatosi: $e');
        }
      }
      if (widget.isInitialSetup && Navigator.of(context).canPop()) {
        Navigator.of(context).pop(true);
        return;
      }
      final destination = widget.nextScreen ?? const HomeScreen();
      Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (_, _, _) => destination,
          transitionsBuilder: (_, animation, _, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
        (route) => false,
      );
    });
  }

  void _onNumberTap(String number) {
    if (_isSubmitting || _isSuccess) return;
    if (_enteredPin.length < 4) {
      HapticFeedback.lightImpact();
      setState(() {
        _enteredPin += number;
        _errorMessage = null;
      });
      if (_enteredPin.length == 4) {
        _handlePinEntered();
      }
    }
  }

  void _onBackspaceTap() {
    if (_isSubmitting || _isSuccess) return;
    if (_enteredPin.isNotEmpty) {
      HapticFeedback.selectionClick();
      setState(() {
        _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
        _errorMessage = null;
      });
    }
  }

  Future<void> _handlePinEntered() async {
    setState(() => _isSubmitting = true);
    final s = context.read<LocaleProvider>().strings;
    if (_mode == LockScreenMode.unlock) {
      if (_enteredPin == _savedPin) {
        _goToHomeScreen();
      } else {
        _triggerError(s.pinWrong);
      }
    } else if (_mode == LockScreenMode.createPin) {
      await Future.delayed(const Duration(milliseconds: 150));
      setState(() {
        _tempNewPin = _enteredPin;
        _enteredPin = '';
        _mode = LockScreenMode.confirmPin;
        _isSubmitting = false;
      });
    } else if (_mode == LockScreenMode.confirmPin) {
      if (_enteredPin == _tempNewPin) {
        await SecurityHelper.savePin(_enteredPin);
        HapticFeedback.heavyImpact();
        _goToHomeScreen();
      } else {
        _triggerError(s.pinMismatch);
        setState(() {
          _mode = LockScreenMode.createPin;
          _tempNewPin = '';
        });
      }
    }
  }

  void _triggerError(String message) {
    HapticFeedback.heavyImpact();
    _shakeController.forward(from: 0.0);
    setState(() {
      _errorMessage = message;
      _enteredPin = '';
      _isSubmitting = false;
      _isSuccess = false;
    });
  }

  String _titleOf(AppStrings s) {
    if (_isSuccess) {
      if (_mode == LockScreenMode.unlock) return s.pinSuccess;
      return s.pinSaved;
    }
    switch (_mode) {
      case LockScreenMode.unlock:
        return s.pinUnlockTitle;
      case LockScreenMode.createPin:
        return s.pinCreateTitle;
      case LockScreenMode.confirmPin:
        return s.pinConfirmTitle;
    }
  }

  String _subOf(AppStrings s) {
    if (_isSuccess) {
      if (widget.isInitialSetup && Navigator.of(context).canPop()) {
        return s.pinSaved;
      }
      return s.pinGoingHome;
    }
    switch (_mode) {
      case LockScreenMode.unlock:
        return s.pinUnlockSub;
      case LockScreenMode.createPin:
        return s.pinCreateSub;
      case LockScreenMode.confirmPin:
        return s.pinConfirmSub;
    }
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watch<LocaleProvider>().strings;
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.bgBottom,
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.bgTop, AppColors.bgBottom],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.7],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                Row(
                  children: [
                    if (widget.isInitialSetup)
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => Navigator.pop(context),
                        child: const Icon(CupertinoIcons.xmark, color: AppColors.textPrimary),
                      )
                    else
                      const SizedBox(width: 8),
                    const Spacer(),
                    const LanguagePickerBar(),
                  ],
                ),
                const Spacer(),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: _isSuccess
                        ? AppColors.success.withOpacity(0.2)
                        : AppColors.primary.withOpacity(0.12),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _isSuccess ? AppColors.success : AppColors.primary.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    _isSuccess ? Icons.check_rounded : CupertinoIcons.lock_shield_fill,
                    size: 40,
                    color: _isSuccess ? AppColors.success : AppColors.primary,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _titleOf(s),
                  style: TextStyle(
                    color: _isSuccess ? AppColors.success : AppColors.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _subOf(s),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 13.5),
                ),
                const SizedBox(height: 32),
                AnimatedBuilder(
                  animation: _shakeAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(_shakeAnimation.value, 0),
                      child: child,
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      final bool isFilled = index < _enteredPin.length;
                      final bool isErr = _errorMessage != null;
                      Color dotColor;
                      if (_isSuccess) {
                        dotColor = AppColors.success;
                      } else if (isErr) {
                        dotColor = AppColors.error;
                      } else if (isFilled) {
                        dotColor = AppColors.primary;
                      } else {
                        dotColor = Colors.transparent;
                      }
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        width: isFilled || _isSuccess ? 18 : 14,
                        height: isFilled || _isSuccess ? 18 : 14,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: dotColor,
                          border: Border.all(
                            color: _isSuccess
                                ? AppColors.success
                                : isErr
                                    ? AppColors.error
                                    : isFilled
                                        ? AppColors.primary
                                        : AppColors.border,
                            width: 2,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                SizedBox(
                  height: 36,
                  child: Center(
                    child: _errorMessage != null
                        ? Text(
                            _errorMessage!,
                            style: const TextStyle(color: AppColors.error, fontSize: 13, fontWeight: FontWeight.w600),
                          )
                        : null,
                  ),
                ),
                const Spacer(),
                _buildNumpad(),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNumpad() {
    return Column(
      children: [
        _buildRow(['1', '2', '3']),
        const SizedBox(height: 16),
        _buildRow(['4', '5', '6']),
        const SizedBox(height: 16),
        _buildRow(['7', '8', '9']),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 72,
              height: 72,
              child: (_mode == LockScreenMode.unlock && _isFingerprintSupported)
                  ? CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: _tryBiometrics,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.surface,
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Center(
                          child: Icon(Icons.fingerprint, color: AppColors.primary, size: 34),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            _buildButton('0'),
            SizedBox(
              width: 72,
              height: 72,
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _onBackspaceTap,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surface,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Center(
                    child: Icon(CupertinoIcons.delete_left, color: AppColors.textMuted, size: 24),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRow(List<String> digits) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: digits.map((d) => _buildButton(d)).toList(),
    );
  }

  Widget _buildButton(String digit) {
    return SizedBox(
      width: 72,
      height: 72,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () => _onNumberTap(digit),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surface,
            border: Border.all(color: AppColors.border),
          ),
          child: Center(
            child: Text(
              digit,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 26,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
