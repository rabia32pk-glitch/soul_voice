import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:soul_voice/core/theme/theme_cubit.dart';
import 'package:soul_voice/screens/favourite_screens.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final backgroundColor = theme.scaffoldBackgroundColor;
    final surfaceColor = theme.colorScheme.surface;
    final primaryTextColor = theme.colorScheme.onSurface;

    final secondaryTextColor =
        theme.textTheme.bodyMedium?.color?.withOpacity(0.65) ??
        Colors.grey;

    final borderColor =
        theme.dividerColor.withOpacity(0.35);

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Profile',
          style: TextStyle(
            color: primaryTextColor,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          child: Column(
            children: [
              // ================= PROFILE =================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: borderColor,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 92,
                      width: 92,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.colorScheme.primary
                            .withOpacity(0.15),
                        border: Border.all(
                          color: theme.colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.person_rounded,
                        color: theme.colorScheme.primary,
                        size: 48,
                      ),
                    ),

                    const SizedBox(height: 14),

                    Text(
                      'User Name',
                      style: TextStyle(
                        color: primaryTextColor,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      'user@example.com',
                      style: TextStyle(
                        color: secondaryTextColor,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 18),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const PersonalInformationScreen(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.edit_outlined,
                        ),
                        label: const Text(
                          'Edit Profile',
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ================= ACCOUNT =================

              _SectionTitle(
                title: 'Account',
                color: primaryTextColor,
              ),

              const SizedBox(height: 10),

              _ProfileOption(
                icon: Icons.person_outline_rounded,
                title: 'Personal Information',
                subtitle: 'Manage your profile information',
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                titleColor: primaryTextColor,
                subtitleColor: secondaryTextColor,
                iconColor: theme.colorScheme.primary,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const PersonalInformationScreen(),
                    ),
                  );
                },
              ),

              _ProfileOption(
                icon: Icons.favorite_border_rounded,
                title: 'My Favorites',
                subtitle: 'View your saved quotes',
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                titleColor: primaryTextColor,
                subtitleColor: secondaryTextColor,
                iconColor: theme.colorScheme.primary,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const FavoritesScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // ================= SETTINGS =================

              _SectionTitle(
                title: 'Settings',
                color: primaryTextColor,
              ),

              const SizedBox(height: 10),

              _ProfileOption(
                icon: Icons.settings_outlined,
                title: 'Settings',
                subtitle: 'App preferences and options',
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                titleColor: primaryTextColor,
                subtitleColor: secondaryTextColor,
                iconColor: theme.colorScheme.primary,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const SettingsScreen(),
                    ),
                  );
                },
              ),

              _ThemeSwitchOption(
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                titleColor: primaryTextColor,
                subtitleColor: secondaryTextColor,
              ),

              const SizedBox(height: 20),

              // ================= PRIVACY =================

              _SectionTitle(
                title: 'Privacy & Security',
                color: primaryTextColor,
              ),

              const SizedBox(height: 10),

              _ProfileOption(
                icon: Icons.lock_outline_rounded,
                title: 'Privacy',
                subtitle: 'Manage your privacy settings',
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                titleColor: primaryTextColor,
                subtitleColor: secondaryTextColor,
                iconColor: theme.colorScheme.primary,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const PrivacyScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 25),

              // ================= LOGOUT =================

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    _showLogoutDialog(context);
                  },
                  icon: const Icon(
                    Icons.logout_rounded,
                  ),
                  label: const Text('Logout'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    side: const BorderSide(
                      color: Colors.redAccent,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text(
            'Are you sure you want to logout?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.redAccent,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// =====================================================
// SECTION TITLE
// =====================================================

class _SectionTitle extends StatelessWidget {
  final String title;
  final Color color;

  const _SectionTitle({
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          color: color,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// =====================================================
// PROFILE OPTION
// =====================================================

class _ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  final Color surfaceColor;
  final Color borderColor;
  final Color titleColor;
  final Color subtitleColor;
  final Color iconColor;

  final VoidCallback onTap;

  const _ProfileOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.surfaceColor,
    required this.borderColor,
    required this.titleColor,
    required this.subtitleColor,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          color: iconColor,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: titleColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: subtitleColor,
            fontSize: 12,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          color: subtitleColor,
          size: 15,
        ),
      ),
    );
  }
}

// =====================================================
// DARK THEME
// =====================================================

class _ThemeSwitchOption extends StatelessWidget {
  final Color surfaceColor;
  final Color borderColor;
  final Color titleColor;
  final Color subtitleColor;

  const _ThemeSwitchOption({
    required this.surfaceColor,
    required this.borderColor,
    required this.titleColor,
    required this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: ListTile(
        leading: Icon(
          Icons.dark_mode_outlined,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(
          'Dark Theme',
          style: TextStyle(
            color: titleColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          isDark
              ? 'Dark mode is enabled'
              : 'Light mode is enabled',
          style: TextStyle(
            color: subtitleColor,
            fontSize: 12,
          ),
        ),
        trailing: Switch(
          value: isDark,
          onChanged: (value) {
            context.read<ThemeCubit>().setTheme(value);
          },
        ),
      ),
    );
  }
}

// =====================================================
// SETTINGS SCREEN
// =====================================================

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState
    extends State<SettingsScreen> {

  // Current selected language
  String selectedLanguage = 'English';

  // Available languages
  final List<String> languages = [
    'English',
    'Urdu',
    'Hindi',
    'French',
    'Korean',
    'Chinese',
    'Persian',
  ];

  // ===================================================
  // LANGUAGE DIALOG
  // ===================================================

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Choose Language',
          ),

          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: languages.map((language) {
                return RadioListTile<String>(
                  title: Text(language),
                  value: language,
                  groupValue: selectedLanguage,

                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }

                    setState(() {
                      selectedLanguage = value;
                    });

                    Navigator.pop(dialogContext);

                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      SnackBar(
                        content: Text(
                          'Language changed to $value',
                        ),
                        duration:
                            const Duration(seconds: 2),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Preferences',
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          // =================================================
          // LANGUAGE
          // =================================================

          _SettingsTile(
            icon: Icons.language_rounded,
            title: 'Language',
            subtitle: selectedLanguage,
            onTap: _showLanguageDialog,
          ),

          // =================================================
          // NOTIFICATIONS
          // =================================================

          _SettingsTile(
            icon: Icons.notifications_none_rounded,
            title: 'Notifications',
            subtitle:
                'Control your notifications',
            onTap: () {},
          ),

          // =================================================
          // PRIVACY
          // =================================================

          _SettingsTile(
            icon: Icons.lock_outline_rounded,
            title: 'Privacy',
            subtitle:
                'Manage privacy settings',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const PrivacyScreen(),
                ),
              );
            },
          ),

          // =================================================
          // ABOUT
          // =================================================

          _SettingsTile(
            icon: Icons.info_outline_rounded,
            title: 'About Soul Voice',
            subtitle: 'App information',
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Soul Voice',
                applicationVersion: '1.0.0',
              );
            },
          ),
        ],
      ),
    );
  }
}

// =====================================================
// SETTINGS TILE
// =====================================================

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              theme.dividerColor.withOpacity(0.35),
        ),
      ),
      child: ListTile(
        onTap: onTap,

        leading: Icon(
          icon,
          color: theme.colorScheme.primary,
        ),

        title: Text(
          title,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),

        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: theme.textTheme.bodyMedium
                    ?.color
                    ?.withOpacity(0.65) ??
                Colors.grey,
            fontSize: 12,
          ),
        ),

        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          color: theme.textTheme.bodyMedium
                  ?.color
                  ?.withOpacity(0.65) ??
              Colors.grey,
          size: 15,
        ),
      ),
    );
  }
}

// =====================================================
// PRIVACY SCREEN
// =====================================================

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() =>
      _PrivacyScreenState();
}

class _PrivacyScreenState
    extends State<PrivacyScreen> {

  bool saveActivity = true;
  bool personalizedContent = true;
  bool showOnlineStatus = false;
  bool allowNotifications = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Privacy Controls',
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Control your privacy preferences.',
            style: TextStyle(
              color: theme.textTheme.bodyMedium
                      ?.color
                      ?.withOpacity(0.65) ??
                  Colors.grey,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 20),

          _PrivacySwitch(
            title: 'Save Activity',
            subtitle:
                'Save your app activity.',
            value: saveActivity,
            onChanged: (value) {
              setState(() {
                saveActivity = value;
              });
            },
          ),

          _PrivacySwitch(
            title: 'Personalized Content',
            subtitle:
                'Allow personalized content.',
            value: personalizedContent,
            onChanged: (value) {
              setState(() {
                personalizedContent = value;
              });
            },
          ),

          _PrivacySwitch(
            title: 'Show Online Status',
            subtitle:
                'Allow others to see your status.',
            value: showOnlineStatus,
            onChanged: (value) {
              setState(() {
                showOnlineStatus = value;
              });
            },
          ),

          _PrivacySwitch(
            title: 'Privacy Notifications',
            subtitle:
                'Receive privacy notifications.',
            value: allowNotifications,
            onChanged: (value) {
              setState(() {
                allowNotifications = value;
              });
            },
          ),
        ],
      ),
    );
  }
}

// =====================================================
// PRIVACY SWITCH
// =====================================================

class _PrivacySwitch extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _PrivacySwitch({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              theme.dividerColor.withOpacity(0.35),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color:
                        theme.colorScheme.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  subtitle,
                  style: TextStyle(
                    color: theme.textTheme.bodyMedium
                            ?.color
                            ?.withOpacity(0.65) ??
                        Colors.grey,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

// =====================================================
// PERSONAL INFORMATION
// =====================================================

class PersonalInformationScreen
    extends StatefulWidget {
  const PersonalInformationScreen({
    super.key,
  });

  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState
    extends State<PersonalInformationScreen> {

  final nameController =
      TextEditingController();

  final emailController =
      TextEditingController();

  final phoneController =
      TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Personal Information',
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              prefixIcon:
                  Icon(Icons.person_outline),
            ),
          ),

          const SizedBox(height: 15),

          TextField(
            controller: emailController,
            keyboardType:
                TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon:
                  Icon(Icons.email_outlined),
            ),
          ),

          const SizedBox(height: 15),

          TextField(
            controller: phoneController,
            keyboardType:
                TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Phone',
              prefixIcon:
                  Icon(Icons.phone_outlined),
            ),
          ),

          const SizedBox(height: 25),

          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context)
                  .showSnackBar(
                const SnackBar(
                  content: Text(
                    'Information saved successfully',
                  ),
                ),
              );
            },
            child: const Text(
              'Save Information',
            ),
          ),
        ],
      ),
    );
  }
}