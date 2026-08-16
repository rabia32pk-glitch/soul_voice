import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:soul_voice/core/theme/constants/app_colors.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetLink() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _showMessage('Please enter your email address.');
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      _showMessage('Please enter a valid email address.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );

      if (!mounted) return;

      _showMessage(
        'Password reset link has been sent. Please check your email, Spam, or Junk folder.',
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String message;

      switch (e.code) {
        case 'invalid-email':
          message = 'The email address is invalid.';
          break;

        case 'too-many-requests':
          message = 'Too many requests. Please try again later.';
          break;

        case 'user-disabled':
          message = 'This account has been disabled.';
          break;

        default:
          message = 'Something went wrong: ${e.message}';
      }

      _showMessage(message);
    } catch (e) {
      if (!mounted) return;

      _showMessage('Something went wrong. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const SizedBox(height: 30),

            Center(
              child: Icon(
                Icons.lock_reset_rounded,
                size: 80,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 30),

            Center(
              child: Text(
                'Reset Your Password',
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 12),

            Text(
              'Enter your email and we will send you a password reset link.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(
                  alpha: 0.65,
                ),
                fontSize: 15,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 40),

            Text(
              'Email',
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
              ),
              decoration: const InputDecoration(
                hintText: 'Enter your email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 52,

              child: ElevatedButton(
                onPressed: _isLoading ? null : _sendResetLink,

                child: _isLoading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Send Reset Link',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },

                child: const Text(
                  'Back to Login',
                  style: TextStyle(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

