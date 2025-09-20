import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'modules/home/home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String? _error;


Future<void> _signup(BuildContext context) async {
  if (!_formKey.currentState!.validate()) return;

  setState(() {
    _loading = true;
    _error = null;
  });

  final authProvider = Provider.of<AuthProvider>(context, listen: false);

  // 1️⃣ Call signup API
  final signupResult = await authProvider.signup(
    _emailController.text.trim(),
    _passwordController.text.trim(),
  );

  if (signupResult != null) {
    setState(() {
      _loading = false;
      _error = signupResult; // Show signup error
    });
    return;
  }

  // 2️⃣ Auto-login
  final loginError = await authProvider.signin(
    _emailController.text.trim(),
    _passwordController.text.trim(),
  );

  if (loginError != null) {
    setState(() {
      _loading = false;
      _error = loginError; // Show signin error
    });
    return;
  }

  // ✅ Success: navigate back
  if (loginError == null && mounted) {
     Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (_) => HomeScreen()),
    (route) => false, // remove all previous screens from stack
  );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
        title: const Text("Sign Up"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Create Account ✨",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Sign up to continue",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 24),

                    // Email
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? "Enter your email" : null,
                    ),
                    const SizedBox(height: 16),

                    // Password
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                      validator: (value) =>
                          value == null || value.isEmpty ? "Enter your password" : null,
                    ),
                    const SizedBox(height: 20),

                    if (_error != null)
                      Text(
                        _error!,
                        style: const TextStyle(color: Colors.red),
                      ),

                    const SizedBox(height: 10),

                    // Signup Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _loading ? null : () => _signup(context),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: _loading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text("Sign Up"),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Go to Signin Button
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Already have an account? Sign In",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
