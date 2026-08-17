import 'package:flutter/material.dart';
import 'package:soul_voice/Account_verification.dart';
import 'package:soul_voice/core/theme/constants/app_colors.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Security',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .surface,
              borderRadius:
                  BorderRadius.circular(20),
              border: Border.all(
                color:
                    Theme.of(context).dividerColor,
              ),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.security_outlined,
                  size: 55,
                  color: AppColors.primary,
                ),

                const SizedBox(height: 15),

                const Text(
                  'Account Security',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Keep your Soul Voice account secure.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.65),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
           ListView(
  children: [

    // Change Password
    ListTile(
      title: const Text('Change Password'),
      onTap: () {},
    ),

    
    ListTile(
      leading: const Icon(Icons.verified_user_outlined),
      title: const Text('Account Verification'),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 15,
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Accountverification()));
      },
    
    ),

  ],
      ),
        ],
      ),
    );
  }
}