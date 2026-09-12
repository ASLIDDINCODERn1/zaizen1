import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zaizen/auth/auth_service.dart';
import 'package:zaizen/pages/login.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _email = TextEditingController();
  bool _loading = false;
  String? _message;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    setState(() {
      _loading = true;
      _message = null;
    });
    try {
      await AuthService.instance.resetPassword(_email.text);
      setState(() => _message = 'Parolni tiklash havolasi emailga yuborildi.');
    } catch (e) {
      setState(() => _message = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBottom,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Parolni tiklash', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Emailingizni yozing. Parolni tiklash havolasini yuboramiz.',
              style: TextStyle(color: AppColors.textMuted),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'example@gmail.com',
                hintStyle: const TextStyle(color: AppColors.textMuted),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
            ),
            if (_message != null) ...[
              const SizedBox(height: 12),
              Text(_message!, style: const TextStyle(color: AppColors.textSecondary)),
            ],
            const SizedBox(height: 24),
            CupertinoButton(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(14),
              onPressed: _loading ? null : _send,
              child: _loading
                  ? const CupertinoActivityIndicator(color: Colors.white)
                  : const Text('Havola yuborish', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
