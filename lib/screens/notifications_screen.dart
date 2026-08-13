import 'package:flutter/material.dart';
import 'package:soul_voice/core/theme/constants/app_colors.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        actions: [
          TextButton(
            onPressed: () {
              // Baad mein notifications ko read mark karenge.
            },
            child: const Text(
              'Mark all read',
              style: TextStyle(color: AppColors.primary, fontSize: 12),
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          children: [
            const Text(
              'Today',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            _NotificationCard(
              icon: Icons.auto_awesome_rounded,
              title: 'Daily Quote',
              message: 'A new inspiring quote is available for you.',
              time: 'Just now',
              isUnread: true,
            ),

            _NotificationCard(
              icon: Icons.favorite_rounded,
              title: 'Keep Inspiring',
              message: 'Save your favorite quotes and revisit them anytime.',
              time: 'Today',
              isUnread: false,
            ),

            const SizedBox(height: 20),

            const Text(
              'Earlier',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            _NotificationCard(
              icon: Icons.format_quote_rounded,
              title: 'New Quotes',
              message: 'Discover new thoughts and words of wisdom.',
              time: 'Yesterday',
              isUnread: false,
            ),

            _NotificationCard(
              icon: Icons.notifications_none_rounded,
              title: 'Welcome to Soul Voice',
              message: 'Explore categories and find quotes that inspire you.',
              time: '2 days ago',
              isUnread: false,
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// NOTIFICATION CARD
// =====================================================

class _NotificationCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String time;
  final bool isUnread;

  const _NotificationCard({
    required this.icon,
    required this.title,
    required this.message,
    required this.time,
    required this.isUnread,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isUnread
            ? AppColors.primary.withValues(alpha: 0.08)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: isUnread
              ? AppColors.primary.withValues(alpha: 0.35)
              : AppColors.border,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: AppColors.primary, size: 23),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    if (isUnread)
                      Container(
                        height: 8,
                        width: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 5),

                Text(
                  message,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  time,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
