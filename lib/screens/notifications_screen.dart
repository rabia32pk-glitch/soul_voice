import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soul_voice/core/theme/constants/app_colors.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool dailyQuotes = true;
  bool newQuotes = true;
  bool reminders = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  // ==========================================
  // LOAD SAVED SETTINGS
  // ==========================================
  Future<void> _loadNotificationSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (!mounted) return;

      setState(() {
        dailyQuotes = prefs.getBool('daily_quotes') ?? true;
        newQuotes = prefs.getBool('new_quotes') ?? true;
        reminders = prefs.getBool('reminders') ?? false;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // ==========================================
  // SAVE DAILY QUOTES
  // ==========================================
  Future<void> _setDailyQuotes(bool value) async {
    setState(() {
      dailyQuotes = value;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('daily_quotes', value);
  }

  // ==========================================
  // SAVE NEW QUOTES
  // ==========================================
  Future<void> _setNewQuotes(bool value) async {
    setState(() {
      newQuotes = value;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('new_quotes', value);
  }

  // ==========================================
  // SAVE REMINDERS
  // ==========================================
  Future<void> _setReminders(bool value) async {
    setState(() {
      reminders = value;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('reminders', value);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? AppColors.background : const Color(0xFFFBF8F2);
    final cardColor = isDark ? AppColors.surface : Colors.white;
    final primaryTextColor =
        isDark ? AppColors.textPrimary : const Color(0xFF4A3728);
    final secondaryTextColor =
        isDark ? AppColors.textSecondary : const Color(0xFF9E9185);
    final borderColor = isDark ? AppColors.border : const Color(0xFFE8DFD1);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Notifications',
          style: TextStyle(
            color: primaryTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        iconTheme: IconThemeData(color: primaryTextColor),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650),
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    children: [
                      Text(
                        'Notification Preferences',
                        style: TextStyle(
                          color: primaryTextColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Manage how you want to receive quote updates and reminders',
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ==========================================
                      // DAILY QUOTES
                      // ==========================================
                      _NotificationTile(
                        icon: Icons.wb_sunny_outlined,
                        title: 'Daily Quotes',
                        subtitle: 'Receive daily inspirational quotes',
                        value: dailyQuotes,
                        cardColor: cardColor,
                        borderColor: borderColor,
                        textColor: primaryTextColor,
                        subtitleColor: secondaryTextColor,
                        onChanged: (value) {
                          _setDailyQuotes(value);
                        },
                      ),

                      // ==========================================
                      // NEW QUOTES
                      // ==========================================
                      _NotificationTile(
                        icon: Icons.notifications_active_outlined,
                        title: 'New Quotes',
                        subtitle: 'Get notified when new quotes are available',
                        value: newQuotes,
                        cardColor: cardColor,
                        borderColor: borderColor,
                        textColor: primaryTextColor,
                        subtitleColor: secondaryTextColor,
                        onChanged: (value) {
                          _setNewQuotes(value);
                        },
                      ),

                      // ==========================================
                      // REMINDERS
                      // ==========================================
                      _NotificationTile(
                        icon: Icons.alarm_outlined,
                        title: 'Reminders',
                        subtitle: 'Receive reminders to check Soul Voice',
                        value: reminders,
                        cardColor: cardColor,
                        borderColor: borderColor,
                        textColor: primaryTextColor,
                        subtitleColor: secondaryTextColor,
                        onChanged: (value) {
                          _setReminders(value);
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
// NOTIFICATION TILE
// =====================================================

class _NotificationTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final Color cardColor;
  final Color borderColor;
  final Color textColor;
  final Color subtitleColor;
  final ValueChanged<bool> onChanged;

  const _NotificationTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.cardColor,
    required this.borderColor,
    required this.textColor,
    required this.subtitleColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: borderColor, width: 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: SwitchListTile.adaptive(
          value: value,
          onChanged: onChanged,
          activeThumbColor: AppColors.primary,
          secondary: Container(
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
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: subtitleColor,
            ),
          ),
        ),
      ),
    );
  }
}