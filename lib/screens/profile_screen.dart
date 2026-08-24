import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'package:soul_voice/screens/auth/login_screens.dart';
import 'package:soul_voice/services/auth_service.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:soul_voice/core/theme/constants/app_colors.dart';
import 'package:soul_voice/core/theme/theme_cubit.dart';
import 'package:soul_voice/screens/about_soul_voice_screen.dart';
import 'package:soul_voice/screens/edit_profile_screen.dart';
import 'package:soul_voice/screens/heplsupportscreen.dart';
import 'package:soul_voice/screens/privacy_screen.dart';
import 'package:soul_voice/screens/security_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = 'User';
  String _email = '';
  String? _photoUrl;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    final prefs = await SharedPreferences.getInstance();

    if (user != null) {
      _email = user.email ?? '';
      _name = (user.displayName != null && user.displayName!.isNotEmpty)
          ? user.displayName!
          : (user.email?.split('@').first ?? 'User');
      _photoUrl = user.photoURL;

      try {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists && userDoc.data() != null) {
          final data = userDoc.data()!;
          if (data['name'] != null && data['name'].toString().isNotEmpty) {
            _name = data['name'];
          }
          if (data['photoUrl'] != null &&
              data['photoUrl'].toString().isNotEmpty) {
            _photoUrl = data['photoUrl'];
          }
        }
      } catch (e) {
        debugPrint("Firestore Profile Fetch Error: $e");
      }
    }

    _imagePath = prefs.getString('profile_image');

    if (mounted) {
      setState(() {});
    }
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

        final backgroundColor = isDark
            ? AppColors.background
            : const Color(0xFFFBF8F2);
        final cardColor = isDark ? AppColors.surface : Colors.white;
        final iconBoxColor = isDark
            ? AppColors.primary.withValues(alpha: 0.2)
            : const Color(0xFFF5EFE6);
        final goldenIconColor = isDark
            ? AppColors.primary
            : const Color(0xFFC6A152);
        final primaryTextColor = isDark
            ? AppColors.textPrimary
            : const Color(0xFF4A3728);
        final secondaryTextColor = isDark
            ? AppColors.textSecondary
            : const Color(0xFF9E9185);

        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: backgroundColor,
            elevation: 0,
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: Text(
              'My Profile',
              style: TextStyle(
                color: primaryTextColor,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 650),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // =====================================================
                      // TOP MAIN PROFILE CARD
                      // =====================================================
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Row(
                          children: [
                            // Avatar Circle
                            Stack(
                              children: [
                                GestureDetector(
                                  onTap: _openEditProfile,
                                  child: Container(
                                    height: 75,
                                    width: 75,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isDark
                                          ? AppColors.primary.withValues(
                                              alpha: 0.2,
                                            )
                                          : const Color(0xFFF7F1E5),
                                    ),
                                    child: ClipOval(
                                      child:
                                          _imagePath != null &&
                                              File(_imagePath!).existsSync()
                                          ? Image.file(
                                              File(_imagePath!),
                                              fit: BoxFit.cover,
                                            )
                                          : (_photoUrl != null &&
                                                _photoUrl!.isNotEmpty)
                                          ? Image.network(
                                              _photoUrl!,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => Icon(
                                                    Icons.person,
                                                    color: goldenIconColor,
                                                    size: 52,
                                                  ),
                                            )
                                          : Icon(
                                              Icons.person,
                                              color: goldenIconColor,
                                              size: 52,
                                            ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 2,
                                  right: 2,
                                  child: GestureDetector(
                                    onTap: _openEditProfile,
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: goldenIconColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt_rounded,
                                        color: Colors.white,
                                        size: 13,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 16),

                            // Name & Email Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: primaryTextColor,
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _email,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: secondaryTextColor,
                                      fontSize: 13,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),

                            // Edit Pencil Icon
                            IconButton(
                              onPressed: _openEditProfile,
                              icon: Icon(
                                Icons.edit_outlined,
                                color: secondaryTextColor,
                                size: 22,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 22),

                      // =====================================================
                      // SECTION: ACCOUNT
                      // =====================================================
                      _SectionHeader(title: 'Account', color: primaryTextColor),
                      const SizedBox(height: 10),

                      _SampleOptionItem(
                        icon: Icons.person_outline_rounded,
                        title: 'Account Settings',
                        cardColor: cardColor,
                        iconBoxColor: iconBoxColor,
                        iconColor: goldenIconColor,
                        textColor: primaryTextColor,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SettingsScreen(),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      // =====================================================
                      // SECTION: APPEARANCE
                      // =====================================================
                      _SectionHeader(
                        title: 'Appearance',
                        color: primaryTextColor,
                      ),
                      const SizedBox(height: 10),

                      _SampleOptionItem(
                        icon: Icons.wb_sunny_outlined,
                        title: 'Dark Mode',
                        cardColor: cardColor,
                        iconBoxColor: iconBoxColor,
                        iconColor: goldenIconColor,
                        textColor: primaryTextColor,
                        trailing: Transform.scale(
                          scale: 0.85,
                          child: Switch(
                            value: isDark,
                            onChanged: (val) {
                              context.read<ThemeCubit>().toggleTheme();
                            },
                            activeThumbColor: isDark
                                ? AppColors.primary
                                : const Color(0xFF333333),
                            inactiveThumbColor: const Color(0xFF333333),
                            inactiveTrackColor: const Color(0xFFE5DECE),
                          ),
                        ),
                        onTap: () {
                          context.read<ThemeCubit>().toggleTheme();
                        },
                      ),

                      const SizedBox(height: 20),

                      // =====================================================
                      // SECTION: INFORMATION
                      // =====================================================
                      _SectionHeader(
                        title: 'Information',
                        color: primaryTextColor,
                      ),
                      const SizedBox(height: 10),

                      _SampleOptionItem(
                        icon: Icons.shield_outlined,
                        title: 'Privacy Policy',
                        cardColor: cardColor,
                        iconBoxColor: iconBoxColor,
                        iconColor: goldenIconColor,
                        textColor: primaryTextColor,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PrivacyScreen(),
                            ),
                          );
                        },
                      ),

                      _SampleOptionItem(
                        icon: Icons.security_rounded,
                        title: 'Security',
                        cardColor: cardColor,
                        iconBoxColor: iconBoxColor,
                        iconColor: goldenIconColor,
                        textColor: primaryTextColor,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SecurityScreen(),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 22),

                      // =====================================================
                      // LOGOUT BUTTON
                      // =====================================================
                      _SampleOptionItem(
                        icon: Icons.logout_rounded,
                        title: 'Log Out',
                        cardColor: cardColor,
                        iconBoxColor: const Color(0xFFFDE8E8),
                        iconColor: const Color(0xFFE57373),
                        textColor: const Color(0xFFE57373),
                        showArrow: false,
                        onTap: () => _showLogoutDialog(context),
                      ),

                      const SizedBox(height: 12),

                      // =====================================================
                      // DELETE ACCOUNT BUTTON
                      // =====================================================
                      Center(
                        child: TextButton(
                          onPressed: () => _showDeleteAccountDialog(context),
                          child: const Text(
                            'Delete Account',
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          scrollable: true,
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
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(ctx);
                try {
                  // 1. Complete Sign Out (Firebase + Google + SharedPrefs)
                  await AuthService.instance.signOut();

                  // 2. Navigate to Onboarding Screen and clear stack
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Logout failed: $e')),
                    );
                  }
                }
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

  void _showDeleteAccountDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          scrollable: true,
          backgroundColor: isDark ? AppColors.surface : Colors.white,
          title: Text(
            'Delete Account',
            style: TextStyle(
              color: isDark ? AppColors.textPrimary : Colors.black87,
            ),
          ),
          content: Text(
            'This action cannot be undone and all your data will be deleted permanently. Are you sure?',
            style: TextStyle(
              color: isDark ? AppColors.textSecondary : Colors.black54,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(ctx);
                try {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .delete();

                    final prefs = await SharedPreferences.getInstance();
                    await prefs.clear();

                    await user.delete();

                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    }
                  }
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'requires-recent-login' && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'For security reasons, please login again before deleting your account.',
                        ),
                      ),
                    );
                  } else if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Delete failed: ${e.message}')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Delete failed: $e')),
                    );
                  }
                }
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

class _SectionHeader extends StatelessWidget {
  final String title;
  final Color color;

  const _SectionHeader({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold),
    );
  }
}

class _SampleOptionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color cardColor;
  final Color iconBoxColor;
  final Color iconColor;
  final Color textColor;
  final Widget? trailing;
  final bool showArrow;
  final VoidCallback onTap;

  const _SampleOptionItem({
    required this.icon,
    required this.title,
    required this.cardColor,
    required this.iconBoxColor,
    required this.iconColor,
    required this.textColor,
    required this.onTap,
    this.trailing,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          onTap: onTap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          leading: Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: iconBoxColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
        title: Text(
          title,
          style: TextStyle(
            color: textColor,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing:
            trailing ??
            (showArrow
                ? Icon(
                    Icons.chevron_right_rounded,
                    color: textColor.withValues(alpha: 0.35),
                    size: 22,
                  )
                : null),
        ),
      ),
    );
  }
}

// =====================================================
// SETTINGS SCREEN (UPDATED WITH THE 4 SPECIFIC ITEMS)
// =====================================================

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _openStoreRating(BuildContext context) async {
    const packageName = 'com.example.soul_voice';

    final Uri appStoreUrl = Uri.parse('market://details?id=$packageName');
    final Uri webStoreUrl = Uri.parse(
      'https://play.google.com/store/apps/details?id=$packageName',
    );

    try {
      if (await canLaunchUrl(appStoreUrl)) {
        await launchUrl(appStoreUrl, mode: LaunchMode.externalApplication);
      } else if (await canLaunchUrl(webStoreUrl)) {
        await launchUrl(webStoreUrl, mode: LaunchMode.externalApplication);
      } else {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch Play Store')),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not open store link: $e')));
    }
  }

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
          'Account Settings',
          style: TextStyle(
            color: primaryTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: primaryTextColor),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650),
            child: ListView(
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

                // 1. Help & Support
                _SettingsTile(
                  icon: Icons.help_outline_rounded,
                  title: 'Help & Support',
                  subtitle: 'Get in touch with us',
                  surfaceColor: surfaceColor,
                  borderColor: borderColor,
                  titleColor: primaryTextColor,
                  subtitleColor: secondaryTextColor,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HelpSupportScreen(),
                      ),
                    );
                  },
                ),

                // 2. Share
                _SettingsTile(
                  icon: Icons.share_rounded,
                  title: 'Share Soul Voice',
                  subtitle: 'Share with your friends',
                  surfaceColor: surfaceColor,
                  borderColor: borderColor,
                  titleColor: primaryTextColor,
                  subtitleColor: secondaryTextColor,
                  onTap: () async {
                    const appLink =
                        'https://play.google.com/store/apps/details?id=com.example.soul_voice';

                    try {
                      final result = await SharePlus.instance.share(
                        ShareParams(
                          text:
                              'Check out Soul Voice app for daily quotes and inspiration!\nDownload now: $appLink',
                          subject: 'Soul Voice App',
                        ),
                      );

                      if (result.status == ShareResultStatus.unavailable &&
                          context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Sharing is not supported on this platform/device.',
                            ),
                          ),
                        );
                      }
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Sharing is not available on this device.',
                          ),
                        ),
                      );
                    }
                  },
                ),

                // 3. Rate Us
                _SettingsTile(
                  icon: Icons.star_border_rounded,
                  title: 'Rate Us',
                  subtitle: 'Give us your feedback',
                  surfaceColor: surfaceColor,
                  borderColor: borderColor,
                  titleColor: primaryTextColor,
                  subtitleColor: secondaryTextColor,
                  onTap: () => _openStoreRating(context),
                ),

                // 4. About Service
                _SettingsTile(
                  icon: Icons.info_outline_rounded,
                  title: 'About Service',
                  subtitle: 'App information and details',
                  surfaceColor: surfaceColor,
                  borderColor: borderColor,
                  titleColor: primaryTextColor,
                  subtitleColor: secondaryTextColor,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AboutSoulVoiceScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
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
      child: Material(
        color: surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: borderColor),
        ),
        clipBehavior: Clip.antiAlias,
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
      ),
    );
  }
}
