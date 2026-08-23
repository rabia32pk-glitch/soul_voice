import 'package:flutter/material.dart';
import 'package:soul_voice/core/theme/constants/app_colors.dart';

class AboutSoulVoiceScreen extends StatelessWidget {
  const AboutSoulVoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final backgroundColor =
        isDark ? AppColors.background : Colors.white;

    final surfaceColor =
        isDark ? AppColors.surface : const Color(0xFFF7F7F7);

    final primaryTextColor =
        isDark ? AppColors.textPrimary : Colors.black87;

    final secondaryTextColor =
        isDark ? AppColors.textSecondary : Colors.black54;

    final borderColor =
        isDark ? AppColors.border : const Color(0xFFE0E0E0);

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          'About Soul Voice',
          style: TextStyle(
            color: primaryTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(
          color: primaryTextColor,
        ),
      ),

      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                20,
                10,
                20,
                30,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // =====================================================
                  // APP HEADER
                  // =====================================================

              Center(
                child: Column(
                  children: [
                    Container(
                      height: 95,
                      width: 95,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary
                            .withValues(alpha: 0.15),
                      ),
                      child: const Icon(
                        Icons.record_voice_over_rounded,
                        size: 50,
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(height: 18),

                    Text(
                      'Soul Voice',
                      style: TextStyle(
                        color: primaryTextColor,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Your voice, your thoughts, your soul.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: secondaryTextColor,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary
                            .withValues(alpha: 0.12),
                        borderRadius:
                            BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Version 1.0.0',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // =====================================================
              // ABOUT
              // =====================================================

              _AboutCard(
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                primaryTextColor: primaryTextColor,
                secondaryTextColor: secondaryTextColor,
                icon: Icons.auto_awesome_rounded,
                title: 'About Soul Voice',
                description:
                    'Soul Voice is a space created to inspire, '
                    'motivate, and bring meaningful words into '
                    'your everyday life. Discover quotes that '
                    'speak to your heart and reflect your thoughts.',
              ),

              const SizedBox(height: 16),

              // =====================================================
              // OUR PURPOSE
              // =====================================================

              _AboutCard(
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                primaryTextColor: primaryTextColor,
                secondaryTextColor: secondaryTextColor,
                icon: Icons.favorite_outline_rounded,
                title: 'Our Purpose',
                description:
                    'Our purpose is to make positive and '
                    'meaningful thoughts easy to discover, '
                    'save, and share. Whether you need motivation, '
                    'wisdom, peace, or a little inspiration, '
                    'Soul Voice is here for you.',
              ),

              const SizedBox(height: 16),

              // =====================================================
              // FEATURES
              // =====================================================

              Text(
                'What You Can Do',
                style: TextStyle(
                  color: primaryTextColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              _FeatureTile(
                icon: Icons.category_outlined,
                title: 'Explore Categories',
                description:
                    'Discover quotes from different categories '
                    'such as Faith, Life, Wisdom, Success, Love '
                    'and Peace.',
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                primaryTextColor: primaryTextColor,
                secondaryTextColor: secondaryTextColor,
              ),

              _FeatureTile(
                icon: Icons.search_rounded,
                title: 'Search Quotes',
                description:
                    'Find quotes quickly by searching for a '
                    'keyword or category.',
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                primaryTextColor: primaryTextColor,
                secondaryTextColor: secondaryTextColor,
              ),

              _FeatureTile(
                icon: Icons.favorite_border_rounded,
                title: 'Save Favorites',
                description:
                    'Save the quotes you love and easily '
                    'find them later in your favorites.',
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                primaryTextColor: primaryTextColor,
                secondaryTextColor: secondaryTextColor,
              ),

              _FeatureTile(
                icon: Icons.share_outlined,
                title: 'Share & Inspire',
                description:
                    'Share meaningful quotes with friends '
                    'and family through your favorite apps.',
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                primaryTextColor: primaryTextColor,
                secondaryTextColor: secondaryTextColor,
              ),

              _FeatureTile(
                icon: Icons.dark_mode_outlined,
                title: 'Dark & Light Mode',
                description:
                    'Choose the appearance that feels '
                    'comfortable for you.',
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                primaryTextColor: primaryTextColor,
                secondaryTextColor: secondaryTextColor,
              ),

              const SizedBox(height: 16),

              // =====================================================
              // OUR VISION
              // =====================================================

              _AboutCard(
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                primaryTextColor: primaryTextColor,
                secondaryTextColor: secondaryTextColor,
                icon: Icons.lightbulb_outline_rounded,
                title: 'Our Vision',
                description:
                    'We believe that a few meaningful words '
                    'can change the way we think, feel, and '
                    'see the world. Soul Voice aims to create '
                    'a simple and peaceful place where every '
                    'quote can become a source of inspiration.',
              ),

              const SizedBox(height: 28),

              // =====================================================
              // BOTTOM MESSAGE
              // =====================================================

              Center(
                child: Column(
                  children: [
                    const Icon(
                      Icons.format_quote_rounded,
                      color: AppColors.primary,
                      size: 32,
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Let every quote be a voice\n'
                      'that inspires your soul.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: primaryTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      'Made with ❤️ for meaningful moments.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: secondaryTextColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ),
);
}
}

// =====================================================
// ABOUT CARD
// =====================================================

class _AboutCard extends StatelessWidget {
  final Color surfaceColor;
  final Color borderColor;
  final Color primaryTextColor;
  final Color secondaryTextColor;

  final IconData icon;
  final String title;
  final String description;

  const _AboutCard({
    required this.surfaceColor,
    required this.borderColor,
    required this.primaryTextColor,
    required this.secondaryTextColor,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: borderColor,
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 42,
                width: 42,

                decoration: BoxDecoration(
                  color: AppColors.primary
                      .withValues(alpha: 0.12),
                  borderRadius:
                      BorderRadius.circular(12),
                ),

                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: primaryTextColor,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Text(
            description,
            style: TextStyle(
              color: secondaryTextColor,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================
// FEATURE TILE
// =====================================================

class _FeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  final Color surfaceColor;
  final Color borderColor;
  final Color primaryTextColor;
  final Color secondaryTextColor;

  const _FeatureTile({
    required this.icon,
    required this.title,
    required this.description,
    required this.surfaceColor,
    required this.borderColor,
    required this.primaryTextColor,
    required this.secondaryTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
        ),
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Container(
            height: 42,
            width: 42,

            decoration: BoxDecoration(
              color: AppColors.primary
                  .withValues(alpha: 0.12),
              borderRadius:
                  BorderRadius.circular(12),
            ),

            child: Icon(
              icon,
              color: AppColors.primary,
              size: 21,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: primaryTextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  description,
                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: 12,
                    height: 1.4,
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