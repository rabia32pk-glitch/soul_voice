import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:soul_voice/core/theme/constants/app_colors.dart';
import 'package:soul_voice/core/theme/theme_cubit.dart';
import 'package:soul_voice/screens/auth/login_screens.dart';

import 'package:soul_voice/screens/edit_profile_screen.dart';
import 'package:soul_voice/screens/favourite_screens.dart';
import 'package:soul_voice/screens/notifications_screen.dart';
import 'package:soul_voice/screens/privacy_screen.dart';
import 'package:soul_voice/screens/security_screen.dart';
import 'package:soul_voice/screens/splash.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = 'User Name';
  String _email = 'user@example.com';
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      _name = prefs.getString('profile_name') ?? 'User Name';
      _email = prefs.getString('profile_email') ?? 'user@example.com';
      _imagePath = prefs.getString('profile_image');
    });
  }

  Future<void> _openEditProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EditProfileScreen()),
    );

    await _loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        final isDark = themeMode == ThemeMode.dark;

        final backgroundColor = isDark ? AppColors.background : Colors.white;

        final surfaceColor = isDark
            ? AppColors.surface
            : const Color(0xFFF7F7F7);

        final primaryTextColor = isDark
            ? AppColors.textPrimary
            : Colors.black87;

        final secondaryTextColor = isDark
            ? AppColors.textSecondary
            : Colors.black54;

        final borderColor = isDark ? AppColors.border : const Color(0xFFE0E0E0);

        return Scaffold(
          backgroundColor: backgroundColor,

          appBar: AppBar(
            backgroundColor: backgroundColor,
            elevation: 0,
            centerTitle: true,

            title: Text(
              'Profile',
              style: TextStyle(
                color: primaryTextColor,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            iconTheme: IconThemeData(color: primaryTextColor),
          ),

          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),

              child: Column(
                children: [
                  // =====================================================
                  // PROFILE
                  // =====================================================
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),

                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: borderColor),
                    ),

                    child: Column(
                      children: [
                        // ================= PROFILE IMAGE =================
                        GestureDetector(
                          onTap: _openEditProfile,

                          child: Container(
                            height: 92,
                            width: 92,

                            decoration: BoxDecoration(
                              shape: BoxShape.circle,

                              color: AppColors.primary.withValues(alpha: 0.15),

                              border: Border.all(
                                color: AppColors.primary,
                                width: 2,
                              ),
                            ),

                            child: ClipOval(
                              child:
                                  _imagePath != null &&
                                      File(_imagePath!).existsSync()
                                  ? Image.file(
                                      File(_imagePath!),
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(
                                      Icons.person_rounded,
                                      color: AppColors.primary,
                                      size: 48,
                                    ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        Text(
                          _name,

                          style: TextStyle(
                            color: primaryTextColor,
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          _email,

                          style: TextStyle(
                            color: secondaryTextColor,
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 18),

                        SizedBox(
                          width: double.infinity,

                          child: OutlinedButton.icon(
                            onPressed: _openEditProfile,

                            icon: const Icon(Icons.edit_outlined),

                            label: const Text('Edit Profile'),

                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,

                              side: const BorderSide(color: AppColors.primary),

                              padding: const EdgeInsets.symmetric(vertical: 13),

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // =====================================================
                  // ACCOUNT
                  // =====================================================
                  _SectionTitle(title: 'Account', textColor: primaryTextColor),

                  const SizedBox(height: 10),

                  _ProfileOption(
                    icon: Icons.person_outline_rounded,
                    title: 'Personal Information',
                    subtitle: 'Manage your profile information',
                    surfaceColor: surfaceColor,
                    borderColor: borderColor,
                    titleColor: primaryTextColor,
                    subtitleColor: secondaryTextColor,

                    onTap: _openEditProfile,
                  ),

                  _ProfileOption(
                    icon: Icons.favorite_border_rounded,
                    title: 'My Favorites',
                    subtitle: 'View your saved quotes',
                    surfaceColor: surfaceColor,
                    borderColor: borderColor,
                    titleColor: primaryTextColor,
                    subtitleColor: secondaryTextColor,

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const FavoritesScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // =====================================================
                  // SETTINGS
                  // =====================================================
                  _SectionTitle(title: 'Settings', textColor: primaryTextColor),

                  const SizedBox(height: 10),

                  _ProfileOption(
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    subtitle: 'App preferences and options',
                    surfaceColor: surfaceColor,
                    borderColor: borderColor,
                    titleColor: primaryTextColor,
                    subtitleColor: secondaryTextColor,

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),

                  _ProfileOption(
                    icon: Icons.notifications_none_rounded,
                    title: 'Notifications',
                    subtitle: 'Manage notification preferences',
                    surfaceColor: surfaceColor,
                    borderColor: borderColor,
                    titleColor: primaryTextColor,
                    subtitleColor: secondaryTextColor,

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NotificationsScreen(),
                        ),
                      );
                    },
                  ),

                  // =====================================================
                  // DARK MODE
                  // =====================================================
                  _ProfileOption(
                    icon: isDark
                        ? Icons.dark_mode_rounded
                        : Icons.light_mode_rounded,

                    title: 'Dark Theme',

                    subtitle: isDark
                        ? 'Dark mode is enabled'
                        : 'Light mode is enabled',

                    surfaceColor: surfaceColor,
                    borderColor: borderColor,
                    titleColor: primaryTextColor,
                    subtitleColor: secondaryTextColor,

                    trailing: Switch(
                      value: isDark,

                      onChanged: (value) {
                        context.read<ThemeCubit>().setTheme(value);
                      },

                      activeThumbColor: AppColors.primary,
                    ),

                    onTap: () {
                      context.read<ThemeCubit>().setTheme(!isDark);
                    },
                  ),

                  const SizedBox(height: 20),

                  // =====================================================
                  // PRIVACY & SECURITY
                  // =====================================================
                  _SectionTitle(
                    title: 'Privacy & Security',
                    textColor: primaryTextColor,
                  ),

                  const SizedBox(height: 10),

                  _ProfileOption(
                    icon: Icons.lock_outline_rounded,
                    title: 'Privacy',
                    subtitle: 'Manage your privacy settings',
                    surfaceColor: surfaceColor,
                    borderColor: borderColor,
                    titleColor: primaryTextColor,
                    subtitleColor: secondaryTextColor,

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PrivacyScreen(),
                        ),
                      );
                    },
                  ),

                  _ProfileOption(
                    icon: Icons.security_outlined,
                    title: 'Security',
                    subtitle: 'Manage your account security',
                    surfaceColor: surfaceColor,
                    borderColor: borderColor,
                    titleColor: primaryTextColor,
                    subtitleColor: secondaryTextColor,

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SecurityScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 25),

                  // =====================================================
                  // LOGOUT
                  // =====================================================
                  SizedBox(
                    width: double.infinity,

                    child: OutlinedButton.icon(
                      onPressed: () {
                        _showLogoutDialog(context);
                      },

                      icon: const Icon(Icons.logout_rounded),

                      label: const Text('Logout'),

                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.redAccent,

                        side: const BorderSide(color: Colors.redAccent),

                        padding: const EdgeInsets.symmetric(vertical: 14),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // =====================================================
                  // DELETE ACCOUNT
                  // =====================================================
                  TextButton(
                    onPressed: () {
                      _showDeleteAccountDialog(context);
                    },

                    child: const Text(
                      'Delete Account',

                      style: TextStyle(color: Colors.redAccent, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // =====================================================
  // LOGOUT DIALOG
  // =====================================================

  void _showLogoutDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.surface : Colors.white,

          title: Text(
            'Logout',

            style: TextStyle(
              color: isDark ? AppColors.textPrimary : Colors.black87,
            ),
          ),

          content: Text(
            'Are you sure you want to logout?',

            style: TextStyle(
              color: isDark ? AppColors.textSecondary : Colors.black54,
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text('Cancel'),
            ),

            TextButton(
  onPressed: () {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
      (route) => false,
    );
  },
  child: const Text(
    'Logout',
    style: TextStyle(color: Colors.redAccent),
  ),
),
          ],
        );
      },
    );
  }

  // =====================================================
  // DELETE ACCOUNT DIALOG
  // =====================================================

  void _showDeleteAccountDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.surface : Colors.white,

          title: Text(
            'Delete Account',

            style: TextStyle(
              color: isDark ? AppColors.textPrimary : Colors.black87,
            ),
          ),

          content: Text(
            'This action cannot be undone. Are you sure?',

            style: TextStyle(
              color: isDark ? AppColors.textSecondary : Colors.black54,
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text('Cancel'),
            ),

            TextButton(
  onPressed: () async {
    final prefs = await SharedPreferences.getInstance();

    // Saved user data clear
    await prefs.clear();

    if (!context.mounted) return;

    // Delete ke baad Splash Screen par
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const SplashScreen(),
      ),
      (route) => false,
    );
  },
  child: const Text(
    'Delete',
    style: TextStyle(color: Colors.redAccent),
  ),
),
          ],
        );
      },
    );
  }
}

// =====================================================
// SECTION TITLE
// =====================================================

class _SectionTitle extends StatelessWidget {
  final String title;
  final Color textColor;

  const _SectionTitle({required this.title, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,

      child: Text(
        title,

        style: TextStyle(
          color: textColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// =====================================================
// PROFILE OPTION
// =====================================================

class _ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  final Color surfaceColor;
  final Color borderColor;
  final Color titleColor;
  final Color subtitleColor;

  final Widget? trailing;
  final VoidCallback onTap;

  const _ProfileOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.surfaceColor,
    required this.borderColor,
    required this.titleColor,
    required this.subtitleColor,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),

      decoration: BoxDecoration(
        color: surfaceColor,

        borderRadius: BorderRadius.circular(16),

        border: Border.all(color: borderColor),
      ),

      child: ListTile(
        onTap: onTap,

        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),

        leading: Container(
          height: 42,
          width: 42,

          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),

            borderRadius: BorderRadius.circular(12),
          ),

          child: Icon(icon, color: AppColors.primary),
        ),

        title: Text(
          title,

          style: TextStyle(
            color: titleColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),

        subtitle: Text(
          subtitle,

          style: TextStyle(color: subtitleColor, fontSize: 11),
        ),

        trailing:
            trailing ??
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: subtitleColor,
              size: 16,
            ),
      ),
    );
  }
}

// =====================================================
// SETTINGS SCREEN
// =====================================================

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark ? AppColors.background : Colors.white;

    final surfaceColor = isDark ? AppColors.surface : const Color(0xFFF7F7F7);

    final primaryTextColor = isDark ? AppColors.textPrimary : Colors.black87;

    final secondaryTextColor = isDark
        ? AppColors.textSecondary
        : Colors.black54;

    final borderColor = isDark ? AppColors.border : const Color(0xFFE0E0E0);

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,

        title: Text(
          'Settings',

          style: TextStyle(
            color: primaryTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),

        iconTheme: IconThemeData(color: primaryTextColor),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [
          Text(
            'Preferences',

            style: TextStyle(
              color: primaryTextColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 14),

          _SettingsTile(
            icon: Icons.notifications_none_rounded,
            title: 'Notifications',
            subtitle: 'Control your notifications',
            surfaceColor: surfaceColor,
            borderColor: borderColor,
            titleColor: primaryTextColor,
            subtitleColor: secondaryTextColor,

            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              );
            },
          ),

          

          _SettingsTile(
            icon: Icons.lock_outline_rounded,
            title: 'Privacy',
            subtitle: 'Manage privacy settings',
            surfaceColor: surfaceColor,
            borderColor: borderColor,
            titleColor: primaryTextColor,
            subtitleColor: secondaryTextColor,

            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PrivacyScreen()),
              );
            },
          ),

          _SettingsTile(
            icon: Icons.info_outline_rounded,
            title: 'About Soul Voice',
            subtitle: 'App information',
            surfaceColor: surfaceColor,
            borderColor: borderColor,
            titleColor: primaryTextColor,
            subtitleColor: secondaryTextColor,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

// =====================================================
// SETTINGS TILE
// =====================================================

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  final Color surfaceColor;
  final Color borderColor;
  final Color titleColor;
  final Color subtitleColor;

  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.surfaceColor,
    required this.borderColor,
    required this.titleColor,
    required this.subtitleColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),

      decoration: BoxDecoration(
        color: surfaceColor,

        borderRadius: BorderRadius.circular(16),

        border: Border.all(color: borderColor),
      ),

      child: ListTile(
        onTap: onTap,

        leading: Icon(icon, color: AppColors.primary),

        title: Text(
          title,

          style: TextStyle(color: titleColor, fontWeight: FontWeight.w600),
        ),

        subtitle: Text(
          subtitle,

          style: TextStyle(color: subtitleColor, fontSize: 12),
        ),

        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          color: subtitleColor,
          size: 15,
        ),
      ),
    );
  }
}
