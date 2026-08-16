import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:soul_voice/core/theme/constants/app_colors.dart';
import 'package:soul_voice/screens/auth/signup_screen.dart';
import 'package:soul_voice/screens/auth/forgot_password.dart';
import 'package:soul_voice/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ================= LOGIN =================

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login successful'),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Something went wrong.';

      switch (e.code) {
        case 'invalid-credential':
          message = 'Incorrect email or password.';
          break;

        case 'invalid-email':
          message = 'Please enter a valid email.';
          break;

        case 'user-not-found':
          message = 'No account found with this email.';
          break;

        case 'wrong-password':
          message = 'Incorrect password.';
          break;

        case 'user-disabled':
          message = 'This account has been disabled.';
          break;

        case 'too-many-requests':
          message = 'Too many attempts. Please try again later.';
          break;

        case 'network-request-failed':
          message = 'Please check your internet connection.';
          break;

        case 'configuration-not-found':
          message = 'Firebase Authentication is not configured correctly.';
          break;
      }

      _showMessage(message);

      debugPrint('Firebase Auth Error Code: ${e.code}');
      debugPrint('Firebase Auth Error Message: ${e.message}');
    } catch (e) {
      _showMessage('Unable to login. Please try again.');

      debugPrint('Login Error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // ================= MESSAGE =================

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final textColor = theme.colorScheme.onSurface;

    final secondaryColor = theme.colorScheme.onSurface.withValues(
      alpha: 0.65,
    );

    final surfaceColor = theme.colorScheme.surface;

    final borderColor = theme.dividerColor;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      body: SafeArea(
        child: Form(
          key: _formKey,

          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const SizedBox(height: 45),

                // ================= LOGO =================

                Center(
                  child: Container(
                    height: 76,
                    width: 76,

                    decoration: BoxDecoration(
                      color: surfaceColor,

                      borderRadius: BorderRadius.circular(22),

                      border: Border.all(
                        color: AppColors.primary,
                        width: 1.5,
                      ),
                    ),

                    child: const Icon(
                      Icons.graphic_eq_rounded,

                      color: AppColors.primary,

                      size: 40,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // ================= TITLE =================

                Center(
                  child: Text(
                    'Welcome Back',

                    style: TextStyle(
                      color: textColor,

                      fontSize: 30,

                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Center(
                  child: Text(
                    'Sign in to continue your journey',

                    style: TextStyle(
                      color: secondaryColor,

                      fontSize: 15,
                    ),
                  ),
                ),

                const SizedBox(height: 42),

                // ================= EMAIL =================

                Text(
                  'Email',

                  style: TextStyle(
                    color: textColor,

                    fontSize: 14,

                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: _emailController,

                  keyboardType: TextInputType.emailAddress,

                  style: TextStyle(
                    color: textColor,
                  ),

                  decoration: const InputDecoration(
                    hintText: 'Enter your email',

                    prefixIcon: Icon(
                      Icons.email_outlined,
                    ),
                  ),

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email';
                    }

                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // ================= PASSWORD =================

                Text(
                  'Password',

                  style: TextStyle(
                    color: textColor,

                    fontSize: 14,

                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: _passwordController,

                  obscureText: _obscurePassword,

                  style: TextStyle(
                    color: textColor,
                  ),

                  decoration: InputDecoration(
                    hintText: 'Enter your password',

                    prefixIcon: const Icon(
                      Icons.lock_outline,
                    ),

                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },

                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                    ),
                  ),

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 10),

                // ================= FORGOT PASSWORD =================

                Align(
                  alignment: Alignment.centerRight,

                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (_) =>
                              const ForgotPasswordScreen(),
                        ),
                      );
                    },

                    child: const Text(
                      'Forgot Password?',

                      style: TextStyle(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // ================= LOGIN =================

                SizedBox(
                  width: double.infinity,

                  height: 52,

                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,

                    child: _isLoading
                        ? const SizedBox(
                            height: 22,

                            width: 22,

                            child: CircularProgressIndicator(
                              strokeWidth: 2,

                              color: Colors.black,
                            ),
                          )
                        : const Text(
                            'Login',

                            style: TextStyle(
                              fontSize: 16,

                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 24),

                // ================= OR =================

                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: borderColor,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                      ),

                      child: Text(
                        'OR',

                        style: TextStyle(
                          color: secondaryColor,

                          fontSize: 12,
                        ),
                      ),
                    ),

                    Expanded(
                      child: Divider(
                        color: borderColor,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ================= GOOGLE =================

                SizedBox(
                  width: double.infinity,

                  height: 52,

                  child: OutlinedButton.icon(
                    onPressed: () {
                      _showMessage(
                        'Google Sign-In will be added next.',
                      );
                    },

                    icon: const Icon(
                      Icons.g_mobiledata_rounded,
                    ),

                    label: const Text(
                      'Continue with Google',
                    ),

                    style: OutlinedButton.styleFrom(
                      foregroundColor: textColor,

                      side: BorderSide(
                        color: borderColor,
                      ),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // ================= SIGN UP =================

                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (_) => const SignupScreen(),
                        ),
                      );
                    },

                    child: Text.rich(
                      TextSpan(
                        text: "Don't have an account? ",

                        style: TextStyle(
                          color: secondaryColor,
                        ),

                        children: const [
                          TextSpan(
                            text: 'Sign Up',

                            style: TextStyle(
                              color: AppColors.primary,

                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}