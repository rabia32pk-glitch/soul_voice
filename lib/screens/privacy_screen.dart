import 'package:flutter/material.dart';
import 'package:soul_voice/core/theme/constants/app_colors.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryTextColor = isDark ? AppColors.textPrimary : const Color(0xFF2C241D);
    final secondaryTextColor = isDark ? AppColors.textSecondary : const Color(0xFF6B5E52);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Privacy & Data Policy',
          style: TextStyle(
            color: primaryTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Icon(
                  Icons.shield_outlined,
                  size: 60,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Your Privacy is Protected',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Soul Voice is built with an offline-first architecture prioritizing your complete privacy.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: secondaryTextColor,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 25),

                // 1. Data Collection
                _buildPolicyCard(
                  context,
                  icon: Icons.no_accounts_outlined,
                  title: '1. No Personal Data Collected',
                  content:
                      'Soul Voice operates without requiring any account registration or login.\n'
                      'We do not collect names, email addresses, phone numbers, location data, or contact lists.',
                ),
                const SizedBox(height: 15),

                // 2. Local Storage Only
                _buildPolicyCard(
                  context,
                  icon: Icons.smartphone_outlined,
                  title: '2. Local Device Storage',
                  content:
                      'All your app preferences, selected theme (Light/Dark mode), and favorite bookmarked quotes are stored locally on your device using encrypted app sandbox storage.\n'
                      'Your saved data never leaves your device.',
                ),
                const SizedBox(height: 15),

                // 3. Third-Party Sharing
                _buildPolicyCard(
                  context,
                  icon: Icons.lock_outline_rounded,
                  title: '3. Zero Third-Party Sharing',
                  content:
                      'We DO NOT sell, rent, monetize, or share your usage data or information with any third-party advertisers or data brokers.',
                ),
                const SizedBox(height: 15),

                // 4. Contact Us
                _buildPolicyCard(
                  context,
                  icon: Icons.mail_outline_rounded,
                  title: '4. Contact & Support',
                  content:
                      'If you have any questions regarding privacy or feedback, you can reach out directly to our team at:\n'
                      'innovexa.technologies01@gmail.com',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPolicyCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 0,
      color: isDark ? AppColors.surface : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? AppColors.border : const Color(0xFFE8DFD1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primary, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            Text(
              content,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
