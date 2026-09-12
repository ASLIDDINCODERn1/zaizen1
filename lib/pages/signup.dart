import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zaizen/auth/auth_service.dart';
import 'package:zaizen/pages/login.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await AuthService.instance.signUpWithEmail(
        email: _email.text,
        password: _pass.text,
        fullName: _name.text,
      );
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hisob yaratildi. Emailni tasdiqlang yoki kiring.'),
          backgroundColor: AppColors.primary,
        ),
      );
    } catch (e) {
      setState(() => _error = e.toString());
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
        title: const Text("Ro'yxatdan o'tish", style: TextStyle(color: Colors.white)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _field('Ism', _name),
          const SizedBox(height: 14),
          _field('Email', _email, type: TextInputType.emailAddress),
          const SizedBox(height: 14),
          _field('Parol', _pass, obscure: true),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: const TextStyle(color: Color(0xFFEF4444), fontSize: 13)),
          ],
          const SizedBox(height: 24),
          CupertinoButton(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(14),
            onPressed: _loading ? null : _submit,
            child: _loading
                ? const CupertinoActivityIndicator(color: Colors.white)
                : const Text("Ro'yxatdan o'tish", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _field(String label, TextEditingController c, {bool obscure = false, TextInputType? type}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
        const SizedBox(height: 8),
        TextField(
          controller: c,
          obscureText: obscure,
          keyboardType: type,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.border),
            ),
          ),
        ),
      ],
    );
  }
}
