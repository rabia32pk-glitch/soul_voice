import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Privacy & Data Policy',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Icon(Icons.shield_outlined, size: 60, color: Colors.blue),
                const SizedBox(height: 16),
                const Text(
                  'Your Privacy Matters',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Learn how Soul Voice collects, uses, and protects your information.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.65),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 25),

                // 1. What Data We Collect
                _buildPolicyCard(
                  context,
                  icon: Icons.assignment_outlined,
                  title: '1. What Data We Collect',
                  content:
                      '• Account Info: Your Name and Email Address provided during sign-up or Google Sign-In.\n'
                      '• Profile Media: Profile picture uploaded from your device.\n'
                      '• App Activity: Basic interaction and crash logs to maintain app stability.',
                ),
                const SizedBox(height: 15),

                // 2. Why We Collect Your Data
                _buildPolicyCard(
                  context,
                  icon: Icons.psychology_outlined,
                  title: '2. Why We Collect Your Data',
                  content:
                      '• Authentication: To securely identify you and keep your account safe.\n'
                      '• Personalization: To display your name and profile picture in Soul Voice.\n'
                      '• App Operations: To ensure smooth profile updates and features functionality.',
                ),
                const SizedBox(height: 15),

                // 3. How Your Data Is Stored & Protected
                _buildPolicyCard(
                  context,
                  icon: Icons.lock_clock_outlined,
                  title: '3. Data Storage & Protection',
                  content:
                      'Your data is securely stored in Google Firebase cloud infrastructure.\n'
                      'We DO NOT sell, rent, or share your personal data with third-party advertisers.',
                ),
                const SizedBox(height: 15),

                // 4. Your Rights
                _buildPolicyCard(
                  context,
                  icon: Icons.manage_accounts_outlined,
                  title: '4. Your Rights & Choices',
                  content:
                      '• Profile Control: You can update your display name and photo at any time in Edit Profile.\n'
                      '• Account Deletion: You can permanently erase your account and all associated data anytime using the Delete Account option in Profile.',
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
    return Card(
      elevation: 0,
      color: Theme.of(
        context,
      ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue, size: 22),
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
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
