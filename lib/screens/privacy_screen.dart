import 'package:flutter/material.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  String? _selectedOption;
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

          RadioListTile<String>(
  value: 'public',
  groupValue: _selectedOption,
  onChanged: (value) {
    setState(() {
      _selectedOption = value;
    });
  },
  secondary: const Icon(Icons.visibility_outlined),
  title: const Text('Profile Visibility'),
  subtitle: const Text('Control who can see your profile.'),
),

          RadioListTile<String>(
  value: 'data_usage',
  groupValue: _selectedOption,
  onChanged: (value) {
    setState(() {
      _selectedOption = value;
    });
  },
  secondary: const Icon(Icons.data_usage_outlined),
  title: const Text('Data Usage'),
  subtitle: const Text('Manage your application data.'),
),
        ],
      ),
    );
  }
}
