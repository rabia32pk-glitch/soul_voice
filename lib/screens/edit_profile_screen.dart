import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:soul_voice/core/theme/constants/app_colors.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      nameController.text = prefs.getString('profile_name') ?? 'User Name';

      emailController.text =
          prefs.getString('profile_email') ?? 'user@example.com';

      _imagePath = prefs.getString('profile_image');
    });
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) return;

    final directory = await getApplicationDocumentsDirectory();

    final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final savedFile = await File(
      image.path,
    ).copy('${directory.path}/$fileName');

    if (!mounted) return;

    setState(() {
      _imagePath = savedFile.path;
    });
  }

  Future<void> _saveProfile() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('profile_name', nameController.text.trim());

    await prefs.setString('profile_email', emailController.text.trim());

    if (_imagePath != null) {
      await prefs.setString('profile_image', _imagePath!);
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully')),
    );

    Navigator.pop(context, true);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [
          Center(
            child: GestureDetector(
              onTap: _pickImage,

              child: Stack(
                children: [
                  Container(
                    height: 105,
                    width: 105,

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,

                      color: AppColors.primary.withValues(alpha: 0.15),

                      border: Border.all(color: AppColors.primary, width: 2),
                    ),

                    child: ClipOval(
                      child:
                          _imagePath != null && File(_imagePath!).existsSync()
                          ? Image.file(File(_imagePath!), fit: BoxFit.cover)
                          : const Icon(
                              Icons.person_rounded,
                              size: 50,
                              color: AppColors.primary,
                            ),
                    ),
                  ),

                  Positioned(
                    bottom: 0,
                    right: 0,

                    child: Container(
                      height: 34,
                      width: 34,

                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,

                        border: Border.all(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          width: 2,
                        ),
                      ),

                      child: const Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          const Center(
            child: Text(
              'Tap the picture to change',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
          ),

          const SizedBox(height: 30),

          TextField(
            controller: nameController,

            decoration: const InputDecoration(
              labelText: 'Name',
              prefixIcon: Icon(Icons.person_outline),
            ),
          ),

          const SizedBox(height: 15),

          TextField(
            controller: emailController,

            keyboardType: TextInputType.emailAddress,

            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email_outlined),
            ),
          ),

          const SizedBox(height: 25),

          SizedBox(
            height: 50,

            child: ElevatedButton(
              onPressed: _saveProfile,

              child: const Text('Save Changes'),
            ),
          ),
        ],
      ),
    );
  }
}
