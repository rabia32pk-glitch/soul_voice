import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Privacy',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Icon(Icons.lock_outline_rounded, size: 60, color: Colors.blue),

          const SizedBox(height: 20),

          const Text(
            'Privacy Settings',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          Text(
            'Manage how your information is used '
            'and protected inside Soul Voice.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.65),
              height: 1.5,
            ),
          ),

          const SizedBox(height: 30),

          const ListTile(
            leading: Icon(Icons.visibility_outlined),
            title: Text('Profile Visibility'),
            subtitle: Text('Control who can see your profile.'),
          ),

          const ListTile(
            leading: Icon(Icons.data_usage_outlined),
            title: Text('Data Usage'),
            subtitle: Text('Manage your application data.'),
          ),
        ],
      ),
    );
  }
}
