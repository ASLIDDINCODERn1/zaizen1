import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zaizen/auth/auth_service.dart';
import 'package:zaizen/pages/login.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({super.key});

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final _pass = TextEditingController();
  final _confirm = TextEditingController();
  bool _loading = false;
  String? _message;

  @override
  void dispose() {
    _pass.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_pass.text.length < 6) {
      setState(() => _message = "Parol kamida 6 ta belgidan iborat bo'lsin.");
      return;
    }
    if (_pass.text != _confirm.text) {
      setState(() => _message = 'Parollar mos emas.');
      return;
    }
    setState(() {
      _loading = true;
      _message = null;
    });
    try {
      await AuthService.instance.updatePassword(_pass.text);
      if (!mounted) return;
      setState(() => _message = 'Parol yangilandi.');
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
        title: const Text('Yangi parol', style: TextStyle(color: Colors.white)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'Email havolasidan keyin yangi parol o\u2018rnating.',
            style: TextStyle(color: AppColors.textMuted),
          ),
          const SizedBox(height: 20),
          _field('Yangi parol', _pass),
          const SizedBox(height: 14),
          _field('Parolni tasdiqlang', _confirm),
          if (_message != null) ...[
            const SizedBox(height: 12),
            Text(_message!, style: const TextStyle(color: AppColors.textSecondary)),
          ],
          const SizedBox(height: 24),
          CupertinoButton(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(14),
            onPressed: _loading ? null : _save,
            child: _loading
                ? const CupertinoActivityIndicator(color: Colors.white)
                : const Text('Saqlash', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _field(String label, TextEditingController c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
        const SizedBox(height: 8),
        TextField(
          controller: c,
          obscureText: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.border),
            ),
          ),
        ),
      ],
    );
  }
}
