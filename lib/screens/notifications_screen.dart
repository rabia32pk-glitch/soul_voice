import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soul_voice/core/theme/constants/app_colors.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState
    extends State<NotificationsScreen> {

  bool dailyQuotes = true;
  bool newQuotes = true;
  bool reminders = false;

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  // ==========================================
  // LOAD SAVED SETTINGS
  // ==========================================

  Future<void> _loadNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      dailyQuotes =
          prefs.getBool('daily_quotes') ?? true;

      newQuotes =
          prefs.getBool('new_quotes') ?? true;

      reminders =
          prefs.getBool('reminders') ?? false;
    });
  }

  // ==========================================
  // SAVE DAILY QUOTES
  // ==========================================

  Future<void> _setDailyQuotes(bool value) async {
    setState(() {
      dailyQuotes = value;
    });

    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(
      'daily_quotes',
      value,
    );
  }

  // ==========================================
  // SAVE NEW QUOTES
  // ==========================================

  Future<void> _setNewQuotes(bool value) async {
    setState(() {
      newQuotes = value;
    });

    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(
      'new_quotes',
      value,
    );
  }

  // ==========================================
  // SAVE REMINDERS
  // ==========================================

  Future<void> _setReminders(bool value) async {
    setState(() {
      reminders = value;
    });

    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(
      'reminders',
      value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Notification Preferences',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          // ==========================================
          // DAILY QUOTES
          // ==========================================

          _NotificationTile(
            title: 'Daily Quotes',
            subtitle:
                'Receive daily inspirational quotes',
            value: dailyQuotes,
            onChanged: (value) {
              _setDailyQuotes(value);
            },
          ),

          // ==========================================
          // NEW QUOTES
          // ==========================================

          _NotificationTile(
            title: 'New Quotes',
            subtitle:
                'Get notified when new quotes are available',
            value: newQuotes,
            onChanged: (value) {
              _setNewQuotes(value);
            },
          ),

          // ==========================================
          // REMINDERS
          // ==========================================

          _NotificationTile(
            title: 'Reminders',
            subtitle:
                'Receive reminders to check Soul Voice',
            value: reminders,
            onChanged: (value) {
              _setReminders(value);
            },
          ),
        ],
      ),
    );
  }
}

// =====================================================
// NOTIFICATION TILE
// =====================================================

class _NotificationTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _NotificationTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),

      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surface,

        borderRadius:
            BorderRadius.circular(16),

        border: Border.all(
          color:
              Theme.of(context).dividerColor,
        ),
      ),

      child: SwitchListTile(
        value: value,

        onChanged: onChanged,

        activeThumbColor:
            AppColors.primary,

        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),

        subtitle: const Text(
          'Receive notifications',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}