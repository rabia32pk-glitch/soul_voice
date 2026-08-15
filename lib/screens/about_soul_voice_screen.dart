import 'package:flutter/material.dart';
import 'package:soul_voice/core/theme/constants/app_colors.dart';

class AboutSoulVoiceScreen extends StatelessWidget {
  const AboutSoulVoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About Soul Voice',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 90,
                width: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.15),
                ),
                child: const Icon(
                  Icons.record_voice_over_rounded,
                  size: 48,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Soul Voice',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              Text(
                'Your voice, your thoughts, your soul.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.65),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Version 1.0.0',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
