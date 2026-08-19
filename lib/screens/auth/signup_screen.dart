import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:soul_voice/core/theme/constants/app_colors.dart';
import 'package:soul_voice/screens/home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // ================= FORM =================

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // ================= CONTROLLERS =================

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // ================= STATES =================

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  // ================= DISPOSE =================

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  // ============================================================
  // CREATE ACCOUNT
  // ============================================================

  Future<void> _createAccount() async {
    // Validate form first
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Hide keyboard
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
    });

    try {
      // ========================================================
      // FIREBASE CREATE USER
      // ========================================================

      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );

      // ========================================================
      // SAVE USER NAME IN FIREBASE
      // ========================================================

      final User? user = userCredential.user;

      if (user != null) {
        await user.updateDisplayName(_nameController.text.trim());

        await user.reload();
      }

      if (!mounted) return;

      // Success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created successfully!')),
      );

      // ========================================================
      // GO TO HOME
      // ========================================================

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    }
    // ==========================================================
    // FIREBASE ERRORS
    // ==========================================================
    on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case 'email-already-in-use':
          message = 'This email is already registered.';
          break;

        case 'invalid-email':
          message = 'Please enter a valid email address.';
          break;

        case 'weak-password':
          message = 'Password must be at least 6 characters.';
          break;

        case 'network-request-failed':
          message = 'Internet connection problem.';
          break;

        case 'operation-not-allowed':
          message = 'Email/Password authentication is not enabled in Firebase.';
          break;

        case 'too-many-requests':
          message = 'Too many attempts. Please try again later.';
          break;

        default:
          message = 'Signup failed: ${e.message ?? e.code}';
      }

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));

      // Debug console mein exact error bhi show hoga
      debugPrint('Firebase Auth Error Code: ${e.code}');
      debugPrint('Firebase Auth Error Message: ${e.message}');
    }
    // ==========================================================
    // OTHER ERRORS
    // ==========================================================
    catch (e) {
      debugPrint('Signup Error: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Something went wrong: $e')));
    }
    // ==========================================================
    // STOP LOADING
    // ==========================================================
    finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // ============================================================
  // GOOGLE SIGN-IN METHOD
  // ============================================================

  Future<void> _signUpWithGoogle() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
    });

    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signed in with Google successfully!')),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Google Sign-In failed.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In Error: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // ============================================================
  // PASSWORD VALIDATION
  // ============================================================

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final Color textColor = theme.colorScheme.onSurface;

    final Color secondaryColor = theme.colorScheme.onSurface.withValues(
      alpha: 0.65,
    );

    final Color surfaceColor = theme.colorScheme.surface;

    final Color borderColor = theme.dividerColor;

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
                const SizedBox(height: 35),

                // ==================================================
                // LOGO
                // ==================================================
                Center(
                  child: Container(
                    height: 76,
                    width: 76,

                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(22),

                      border: Border.all(color: AppColors.primary, width: 1.5),
                    ),

                    child: const Icon(
                      Icons.graphic_eq_rounded,
                      color: AppColors.primary,
                      size: 40,
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // ==================================================
                // TITLE
                // ==================================================
                Center(
                  child: Text(
                    'Create Account',

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
                    'Start your Soul Voice journey',

                    style: TextStyle(color: secondaryColor, fontSize: 15),
                  ),
                ),

                const SizedBox(height: 35),

                // ==================================================
                // FULL NAME
                // ==================================================
                Text(
                  'Full Name',

                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: _nameController,

                  textInputAction: TextInputAction.next,

                  style: TextStyle(color: textColor),

                  decoration: const InputDecoration(
                    hintText: 'Enter your full name',

                    prefixIcon: Icon(Icons.person_outline_rounded),
                  ),

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your name';
                    }

                    if (value.trim().length < 2) {
                      return 'Name is too short';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 18),

                // ==================================================
                // EMAIL
                // ==================================================
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

                  textInputAction: TextInputAction.next,

                  autocorrect: false,

                  style: TextStyle(color: textColor),

                  decoration: const InputDecoration(
                    hintText: 'Enter your email',

                    prefixIcon: Icon(Icons.email_outlined),
                  ),

                  validator: (value) {
                    final String email = value?.trim() ?? '';

                    if (email.isEmpty) {
                      return 'Please enter your email';
                    }

                    final bool isValid = RegExp(
                      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                    ).hasMatch(email);

                    if (!isValid) {
                      return 'Please enter a valid email';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 18),

                // ==================================================
                // PASSWORD
                // ==================================================
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

                  textInputAction: TextInputAction.next,

                  style: TextStyle(color: textColor),

                  decoration: InputDecoration(
                    hintText: 'Create a password',

                    prefixIcon: const Icon(Icons.lock_outline_rounded),

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

                  validator: _validatePassword,
                ),

                const SizedBox(height: 18),

                // ==================================================
                // CONFIRM PASSWORD
                // ==================================================
                Text(
                  'Confirm Password',

                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: _confirmPasswordController,

                  obscureText: _obscureConfirmPassword,

                  textInputAction: TextInputAction.done,

                  onFieldSubmitted: (_) {
                    if (!_isLoading) {
                      _createAccount();
                    }
                  },

                  style: TextStyle(color: textColor),

                  decoration: InputDecoration(
                    hintText: 'Confirm your password',

                    prefixIcon: const Icon(Icons.lock_outline_rounded),

                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },

                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                    ),
                  ),

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }

                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 28),

                // ==================================================
                // CREATE ACCOUNT BUTTON
                // ==================================================
                SizedBox(
                  width: double.infinity,
                  height: 52,

                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _createAccount,

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
                            'Create Account',

                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 22),

                // ==================================================
                // OR
                // ==================================================
                Row(
                  children: [
                    Expanded(child: Divider(color: borderColor)),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),

                      child: Text(
                        'OR',

                        style: TextStyle(color: secondaryColor, fontSize: 12),
                      ),
                    ),

                    Expanded(child: Divider(color: borderColor)),
                  ],
                ),

                const SizedBox(height: 22),

                // ==================================================
                // GOOGLE
                // ==================================================
                SizedBox(
                  width: double.infinity,
                  height: 52,

                  child: OutlinedButton.icon(
                    onPressed: _isLoading ? null : _signUpWithGoogle,

                    icon: const Icon(Icons.g_mobiledata_rounded),

                    label: const Text('Continue with Google'),

                    style: OutlinedButton.styleFrom(
                      foregroundColor: textColor,

                      side: BorderSide(color: borderColor),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                // ==================================================
                // LOGIN
                // ==================================================
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },

                    child: Text.rich(
                      TextSpan(
                        text: 'Already have an account? ',

                        style: TextStyle(color: secondaryColor),

                        children: const [
                          TextSpan(
                            text: 'Login',

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