import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soul_voice/core/theme/constants/app_colors.dart';
import 'package:soul_voice/core/theme/theme_cubit.dart';
import 'package:soul_voice/screens/about_soul_voice_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _autoRotate = true;
  String _selectedFontSize = 'Medium';
  String _selectedFontStyle = 'Modern';

  void _showClearCacheDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.surface : Colors.white,
          title: Text(
            'Clear App Cache',
            style: TextStyle(
              color: isDark ? AppColors.textPrimary : Colors.black87,
            ),
          ),
          content: Text(
            'Are you sure you want to clear temporary stored quotes and cache?',
            style: TextStyle(
              color: isDark ? AppColors.textSecondary : Colors.black54,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('App cache cleared successfully!'),
                  ),
                );
              },
              child: const Text(
                'Clear',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showFontSizeDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.surface : Colors.white,
          title: Text(
            'Select Text Size',
            style: TextStyle(
              color: isDark ? AppColors.textPrimary : Colors.black87,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: ['Small', 'Medium', 'Large'].map((size) {
              return RadioListTile<String>(
                title: Text(
                  size,
                  style: TextStyle(
                    color: isDark ? AppColors.textPrimary : Colors.black87,
                  ),
                ),
                value: size,
                groupValue: _selectedFontSize,
                activeColor: AppColors.primary,
                onChanged: (value) {
                  setState(() {
                    _selectedFontSize = value!;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showFontStyleDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.surface : Colors.white,
          title: Text(
            'Select Font Style',
            style: TextStyle(
              color: isDark ? AppColors.textPrimary : Colors.black87,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: ['Modern', 'Serif', 'Elegant', 'Handwritten'].map((font) {
              return RadioListTile<String>(
                title: Text(
                  font,
                  style: TextStyle(
                    color: isDark ? AppColors.textPrimary : Colors.black87,
                  ),
                ),
                value: font,
                groupValue: _selectedFontStyle,
                activeColor: AppColors.primary,
                onChanged: (value) {
                  setState(() {
                    _selectedFontStyle = value!;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
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
              'Settings',
              style: TextStyle(
                color: primaryTextColor,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            iconTheme: IconThemeData(color: primaryTextColor),
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                'Quote Display Preferences',
                style: TextStyle(
                  color: primaryTextColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 14),

              // ================= FONT STYLE =================
              _SettingsTile(
                icon: Icons.text_fields_rounded,
                title: 'Font Style',
                subtitle: 'Current: $_selectedFontStyle',
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                titleColor: primaryTextColor,
                subtitleColor: secondaryTextColor,
                onTap: () => _showFontStyleDialog(context, isDark),
              ),

              // ================= QUOTE TEXT SIZE =================
              _SettingsTile(
                icon: Icons.format_size_rounded,
                title: 'Quote Text Size',
                subtitle: 'Current: $_selectedFontSize',
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                titleColor: primaryTextColor,
                subtitleColor: secondaryTextColor,
                onTap: () => _showFontSizeDialog(context, isDark),
              ),

              // ================= AUTO ROTATE =================
              _SettingsTile(
                icon: Icons.autorenew_rounded,
                title: 'Auto-Rotate Quotes',
                subtitle: 'Automatically refresh home quotes',
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                titleColor: primaryTextColor,
                subtitleColor: secondaryTextColor,
                trailing: Switch(
                  value: _autoRotate,
                  onChanged: (value) {
                    setState(() {
                      _autoRotate = value;
                    });
                  },
                  activeThumbColor: AppColors.primary,
                ),
                onTap: () {
                  setState(() {
                    _autoRotate = !_autoRotate;
                  });
                },
              ),

              const SizedBox(height: 24),

              Text(
                'Storage & App Info',
                style: TextStyle(
                  color: primaryTextColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 14),

              // ================= CLEAR CACHE =================
              _SettingsTile(
                icon: Icons.cleaning_services_outlined,
                title: 'Clear App Cache',
                subtitle: 'Free up local memory and temporary quotes',
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                titleColor: primaryTextColor,
                subtitleColor: secondaryTextColor,
                onTap: () => _showClearCacheDialog(context, isDark),
              ),

              // ================= ABOUT SOUL VOICE =================
              _SettingsTile(
                icon: Icons.info_outline_rounded,
                title: 'About Soul Voice',
                subtitle: 'App version, vision & info',
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
        );
      },
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
  final Widget? trailing;

  const _SettingsTile({
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
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          height: 40,
          width: 40,
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
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: subtitleColor, fontSize: 12),
        ),
        trailing:
            trailing ??
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: subtitleColor,
              size: 15,
            ),
      ),
    );
  }
}
