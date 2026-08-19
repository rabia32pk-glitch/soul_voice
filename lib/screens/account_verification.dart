import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class Accountverification extends StatefulWidget {
  const Accountverification({super.key});

  @override
  State<Accountverification> createState() => _AccountverificationState();
}

class _AccountverificationState extends State<Accountverification> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  String? generatedOTP;
  bool isOtpSent = false;
  bool isLoading = false;

  // 🔴 IMPORTANT: Apni Gmail aur App Password yahan likhein
  final String senderEmail = 'rabia32pk@gmail.com'; 
  final String appPassword = 'YOUR_16_DIGIT_APP_PASSWORD'; // Yahan 16-digit password paste karein

  // Email Bhejne Ka Function (Mailer Package)
  Future<void> sendOTP() async {
    final userEmail = emailController.text.trim();

    if (userEmail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an email address')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    // 6 Digit Random OTP Code Generate
    final random = Random();
    generatedOTP = (100000 + random.nextInt(900000)).toString();

    // Gmail SMTP Server Configuration
    final smtpServer = gmail(senderEmail, appPassword);

    final message = Message()
      ..from = Address(senderEmail, 'Soul Voice')
      ..recipients.add(userEmail)
      ..subject = 'Soul Voice Account Verification Code'
      ..html = '''
        <h3>Welcome to Soul Voice!</h3>
        <p>Your verification code is:</p>
        <h1 style="color: #2196F3; font-size: 32px;">$generatedOTP</h1>
        <p>Please do not share this code with anyone.</p>
      ''';

    try {
      await send(message, smtpServer);
      setState(() {
        isOtpSent = true;
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verification code sent successfully ❤️')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send code: $e')),
        );
      }
    }
  }

  // Code Verify Karne Ka Function
  void verifyOTP() {
    final enteredOTP = otpController.text.trim();

    if (enteredOTP.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the code')),
      );
      return;
    }

    if (enteredOTP == generatedOTP) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account verified successfully! 🎉')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid code! Please try again ❌')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account Verification')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Icon(Icons.verified_user, size: 70, color: Colors.blue),
            const SizedBox(height: 20),
            const Text(
              'Verify Your Account',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Please verify your account to keep it secure.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),

            // Email Input Field
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // Send Code Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : sendOTP,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        isOtpSent ? 'Resend Code' : 'Send Verification Code',
                        style: const TextStyle(fontSize: 16),
                      ),
              ),
            ),

            // Code Enter Karne Ka Field
            if (isOtpSent) ...[
              const SizedBox(height: 20),
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Enter 6-Digit Code',
                  prefixIcon: Icon(Icons.lock_clock),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: verifyOTP,
                  child: const Text(
                    'Verify Code',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 15),

            // Back Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Back to Security',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}