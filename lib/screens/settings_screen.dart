import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:soul_voice/core/theme/constants/app_colors.dart';
import 'package:soul_voice/screens/about_soul_voice_screen.dart';
import 'package:soul_voice/screens/heplsupportscreen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // Rate Us function (Play Store / App Store kholne ke liye)
  Future<void> _openStoreRating(BuildContext context) async {
    const packageName = 'com.example.soul_voice';
    
    // Play Store app URL
    final Uri appStoreUrl = Uri.parse('market://details?id=$packageName');
    // Web Browser URL
    final Uri webStoreUrl = Uri.parse(
      'https://play.google.com/store/apps/details?id=$packageName',
    );

    try {
      // Pehle Play Store app open karne ki koshish karega
      if (await canLaunchUrl(appStoreUrl)) {
        await launchUrl(appStoreUrl, mode: LaunchMode.externalApplication);
      } 
      // Agar app na khule toh Web Browser par Play Store kholega
      else if (await canLaunchUrl(webStoreUrl)) {
        await launchUrl(webStoreUrl, mode: LaunchMode.externalApplication);
      } else {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch Play Store')),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open store link: $e')),
      );
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
                MaterialPageRoute(builder: (_) => const HelpSupportScreen()),
              );
            },
          ),

          // 2. Share App
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
                final result = await Share.share(
                  'Check out Soul Voice app for daily quotes and inspiration!\nDownload now: $appLink',
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
                    content: Text('Sharing is not available on this device.'),
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

          // 4. About Soul Voice
          _SettingsTile(
            icon: Icons.info_outline_rounded,
            title: 'About Soul Voice',
            subtitle: 'App information',
            surfaceColor: surfaceColor,
            borderColor: borderColor,
            titleColor: primaryTextColor,
            subtitleColor: secondaryTextColor,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutSoulVoiceScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

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