import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/providers.dart';
import '../theme.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey      = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure       = true;

  @override
  void dispose() { _usernameCtrl.dispose(); _passwordCtrl.dispose(); super.dispose(); }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthProvider>().login(_usernameCtrl.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Welcome, ${_usernameCtrl.text.trim()}!'), backgroundColor: Colors.green),
      );
      Navigator.pushReplacementNamed(context, '/main');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFF222222),
        title: Text('Sign In',
            style: GoogleFonts.josefinSans(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  ClipOval(
                    child: Image.asset('assets/images/logo.png', height: 70, width: 70, fit: BoxFit.cover),
                  ),
                  const SizedBox(height: 12),
                  Text('Sign In',
                      style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: kDark)),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _usernameCtrl,
                    decoration: _input('Username', Icons.person),
                    validator: (v) => (v == null || v.isEmpty) ? 'Username required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordCtrl,
                    obscureText: _obscure,
                    decoration: _input('Password', Icons.lock).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    validator: (v) => (v == null || v.isEmpty) ? 'Password required' : null,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5cb85c),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                      onPressed: _submit,
                      child: Text('Sign In',
                          style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () => Navigator.pushReplacementNamed(context, '/signup'),
                        child: const Text('Sign Up here',
                            style: TextStyle(color: Color(0xFF007bff), fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _input(String hint, IconData icon) => InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: kPrimary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      );
}
