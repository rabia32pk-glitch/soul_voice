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
    _loadPreferences();
  }

  // ================= LOAD SAVED VALUES =================
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      dailyQuotes = prefs.getBool('dailyQuotes') ?? true;
      newQuotes = prefs.getBool('newQuotes') ?? true;
      reminders = prefs.getBool('reminders') ?? false;
      _isLoading = false;
    });
  }

  // ================= SAVE VALUES LOCALLY =================
  Future<void> _updatePreference(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  'Notification Preferences',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                _NotificationTile(
                  title: 'Daily Quotes',
                  subtitle: 'Receive daily inspirational quotes',
                  value: dailyQuotes,
                  onChanged: (value) {
                    setState(() {
                      dailyQuotes = value;
                    });
                    _updatePreference('dailyQuotes', value);
                  },
                ),
                _NotificationTile(
                  title: 'New Quotes',
                  subtitle: 'Get notified when new quotes are available',
                  value: newQuotes,
                  onChanged: (value) {
                    setState(() {
                      newQuotes = value;
                    });
                    _updatePreference('newQuotes', value);
                  },
                ),
                _NotificationTile(
                  title: 'Reminders',
                  subtitle: 'Receive reminders to check Soul Voice',
                  value: reminders,
                  onChanged: (value) {
                    setState(() {
                      reminders = value;
                    });
                    _updatePreference('reminders', value);
                  },
                ),
              ],
            ),
    );
  }
}

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
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppColors.primary,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
