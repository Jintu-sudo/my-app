import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _loading = false;
  String _message = '';
  bool _success = false;

  void _register() async {
    setState(() { _loading = true; _message = ''; });
    try {
      final res = await AuthService.register(
          _usernameCtrl.text.trim(),
          _emailCtrl.text.trim(),
          _passwordCtrl.text);
      setState(() {
        _message = res['message'];
        _success = res['success'] == true;
      });
      if (_success) {
        Future.delayed(const Duration(seconds: 2),
            () => Navigator.pop(context));
      }
    } catch (e) {
      setState(() => _message = 'Connection error. Is the server running?');
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              const Icon(Icons.person_add_rounded, size: 80,
                  color: Color(0xFF4ECCA3)),
              const SizedBox(height: 16),
              const Text('Create Account', style: TextStyle(
                  fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 32),
              TextField(controller: _usernameCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Username', Icons.person)),
              const SizedBox(height: 16),
              TextField(controller: _emailCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Email', Icons.email)),
              const SizedBox(height: 16),
              TextField(controller: _passwordCtrl, obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Password', Icons.lock)),
              if (_message.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(_message, style: TextStyle(
                    color: _success
                        ? const Color(0xFF4ECCA3) : Colors.redAccent)),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4ECCA3),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Register', style: TextStyle(
                        fontSize: 16, color: Colors.black,
                        fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey),
      prefixIcon: Icon(icon, color: const Color(0xFF4ECCA3)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF4ECCA3))),
    );
  }
}