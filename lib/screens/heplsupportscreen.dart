import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:soul_voice/core/theme/constants/app_colors.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final _messageController = TextEditingController();
  bool _isSending = false;

  final List<Map<String, String>> _faqs = [
    {
      'question': 'How do I save my favorite quotes?',
      'answer':
          'You can tap the heart icon on any quote card or detail screen to save it directly to your Favorites tab.',
    },
    {
      'question': 'How do I toggle Dark Theme?',
      'answer':
          'Go to the Settings tab and toggle the "Dark Theme" switch to seamlessly switch between Light and Dark modes.',
    },
    {
      'question': 'Does Soul Voice work offline?',
      'answer':
          'Yes! Soul Voice is built with offline support so you can access hundreds of inspirational quotes and favorites anytime without an active internet connection.',
    },
    {
      'question': 'Is Soul Voice free to use?',
      'answer':
          'Yes, Soul Voice is 100% free to use with full access to all categories, search, favorites, and settings.',
    },
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a message before sending.')),
      );
      return;
    }

    setState(() {
      _isSending = true;
    });

    const supportEmail = 'innovexa.technologies01@gmail.com';

    // Open email client with pre-filled support email
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: supportEmail,
      query: _encodeQueryParameters({
        'subject': 'Soul Voice User Support & Feedback',
        'body':
            'Message:\n$message\n\n'
            '---------------------------\n'
            'Sent from Soul Voice App',
      }),
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        await launchUrl(emailUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Could not launch email app: $e');
    }

    if (mounted) {
      setState(() {
        _isSending = false;
      });
      _messageController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Opening email app to send message...'),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? AppColors.background : Colors.white;
    final surfaceColor = isDark ? AppColors.surface : const Color(0xFFF7F7F7);
    final primaryTextColor = isDark ? AppColors.textPrimary : Colors.black87;
    final secondaryTextColor =
        isDark ? AppColors.textSecondary : Colors.black54;
    final borderColor = isDark ? AppColors.border : const Color(0xFFE0E0E0);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          'Help & Support',
          style: TextStyle(
            color: primaryTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: primaryTextColor),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.support_agent_rounded,
                          size: 48,
                          color: AppColors.primary,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'How can we help you?',
                          style: TextStyle(
                            color: primaryTextColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'We are here to assist you with any questions about Soul Voice.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: secondaryTextColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // FAQs Section
                  Text(
                    'Frequently Asked Questions',
                    style: TextStyle(
                      color: primaryTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  ..._faqs.map((faq) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Material(
                        color: surfaceColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: BorderSide(color: borderColor),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: ExpansionTile(
                          shape: const Border(),
                          title: Text(
                            faq['question']!,
                            style: TextStyle(
                              color: primaryTextColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: Text(
                              faq['answer']!,
                              style: TextStyle(
                                color: secondaryTextColor,
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 25),

                  // Direct Contact Form
                  Text(
                    'Send us a message',
                    style: TextStyle(
                      color: primaryTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: _messageController,
                          maxLines: 4,
                          style: TextStyle(color: primaryTextColor),
                          decoration: InputDecoration(
                            hintText: 'Describe your question or feedback...',
                            hintStyle: TextStyle(
                              color: secondaryTextColor,
                              fontSize: 13,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _isSending ? null : _sendMessage,
                            icon: _isSending
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.send_rounded, size: 18),
                            label: Text(
                              _isSending ? 'Opening Email...' : 'Send Message',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
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