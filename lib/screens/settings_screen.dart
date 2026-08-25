import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:soul_voice/core/theme/constants/app_colors.dart';
import 'package:soul_voice/core/theme/theme_cubit.dart';
import 'package:soul_voice/screens/about_soul_voice_screen.dart';
import 'package:soul_voice/screens/heplsupportscreen.dart';
import 'package:soul_voice/screens/privacy_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        final isDark = themeMode == ThemeMode.dark;

        final backgroundColor =
            isDark ? AppColors.background : const Color(0xFFFBF8F2);
        final surfaceColor = isDark ? AppColors.surface : Colors.white;
        final primaryTextColor =
            isDark ? AppColors.textPrimary : const Color(0xFF2C241D);
        final secondaryTextColor =
            isDark ? AppColors.textSecondary : const Color(0xFF6B5E52);
        final borderColor =
            isDark ? AppColors.border : const Color(0xFFE8DFD1);

        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: backgroundColor,
            elevation: 0,
            centerTitle: true,
            title: Text(
              'Settings',
              style: TextStyle(
                color: primaryTextColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 650),
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  children: [
                    // ==========================================
                    // TOP APP INFO CARD
                    // ==========================================
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: borderColor),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 65,
                            width: 65,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary.withValues(alpha: 0.15),
                              border: Border.all(color: AppColors.primary, width: 2),
                            ),
                            child: Image.asset('assets/f1.png', fit: BoxFit.contain),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Soul Voice',
                                  style: TextStyle(
                                    color: primaryTextColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Daily Quotes & Inner Peace',
                                  style: TextStyle(
                                    color: secondaryTextColor,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'v1.0.0 • Offline Ready',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ==========================================
                    // SECTION 1: APPEARANCE
                    // ==========================================
                    _SectionHeader(title: 'Appearance', color: primaryTextColor),
                    const SizedBox(height: 10),

                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: borderColor),
                      ),
                      child: SwitchListTile.adaptive(
                        value: isDark,
                        activeThumbColor: AppColors.primary,
                        onChanged: (val) {
                          context.read<ThemeCubit>().setTheme(val);
                        },
                        secondary: Container(
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          'Dark Theme',
                          style: TextStyle(
                            color: primaryTextColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        subtitle: Text(
                          isDark ? 'Dark mode enabled' : 'Light mode enabled',
                          style: TextStyle(color: secondaryTextColor, fontSize: 12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // ==========================================
                    // SECTION 2: SUPPORT
                    // ==========================================
                    _SectionHeader(title: 'Support', color: primaryTextColor),
                    const SizedBox(height: 10),

                    _SettingsOptionTile(
                      icon: Icons.help_outline_rounded,
                      title: 'Help & Support',
                      subtitle: 'Direct email support & FAQs',
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

                    const SizedBox(height: 18),

                    // ==========================================
                    // SECTION 3: ABOUT & LEGAL
                    // ==========================================
                    _SectionHeader(title: 'About & Legal', color: primaryTextColor),
                    const SizedBox(height: 10),

                    _SettingsOptionTile(
                      icon: Icons.shield_outlined,
                      title: 'Privacy Policy',
                      subtitle: 'Zero data tracking & privacy commitment',
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

                    _SettingsOptionTile(
                      icon: Icons.info_outline_rounded,
                      title: 'About Soul Voice',
                      subtitle: 'Vision, mission, and app credits',
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

                    const SizedBox(height: 25),

                    // Footer
                    Center(
                      child: Text(
                        'Designed & Crafted with ❤️ by Innovex Technologies',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: secondaryTextColor.withValues(alpha: 0.7),
                          fontSize: 12,
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
      style: TextStyle(
        color: color,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _SettingsOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color surfaceColor;
  final Color borderColor;
  final Color titleColor;
  final Color subtitleColor;
  final VoidCallback onTap;

  const _SettingsOptionTile({
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
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: borderColor, width: 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          onTap: onTap,
          leading: Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          title: Text(
            title,
            style: TextStyle(
              color: titleColor,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(color: subtitleColor, fontSize: 12),
          ),
          trailing: Icon(
            Icons.chevron_right_rounded,
            color: subtitleColor.withValues(alpha: 0.6),
            size: 22,
          ),
        ),
      ),
    );
  }
}