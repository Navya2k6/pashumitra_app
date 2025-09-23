// FILE: lib/detailed_profile_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'otp_page.dart'; // Import the OTP page

class DetailedProfilePage extends StatefulWidget {
  const DetailedProfilePage({super.key});

  @override
  State<DetailedProfilePage> createState() => _DetailedProfilePageState();
}

class _DetailedProfilePageState extends State<DetailedProfilePage> {
  bool _isEditing = false;
  bool _isSendingOtp = false; // To show a loading indicator


  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _phoneController;
  
  File? _profileImage; // To hold the new image file

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _nameController = TextEditingController(text: authProvider.name);
    _ageController = TextEditingController(text: authProvider.age);
    _phoneController = TextEditingController(text: authProvider.phoneNumber);
    
    // Load the initial profile image if it exists
    if (authProvider.imagePath != null) {
      _profileImage = File(authProvider.imagePath!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // --- SAVE ALL CHANGES TO THE PROVIDER ---
  void _saveProfile() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.updateName(_nameController.text);
    authProvider.updateAge(_ageController.text);
     // Check if the phone number was changed
    final newPhoneNumber = _phoneController.text;
    if (newPhoneNumber != authProvider.phoneNumber) {
      // If it changed, start the verification process
      _startPhoneVerification(newPhoneNumber);
    } else {
    // Save the new image path
    authProvider.updateImagePath(_profileImage?.path);

    setState(() {
      _isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile saved successfully!')),
    );
  }
  }

  Future<void> _startPhoneVerification(String phoneNumber) async {
    setState(() => _isSendingOtp = true);
    
    // Format the number for Firebase
    final String formattedPhoneNumber = '+91$phoneNumber';

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: formattedPhoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {
         if (mounted) setState(() => _isSendingOtp = false);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (mounted) {
          setState(() => _isSendingOtp = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to send OTP: ${e.message}")),
          );
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        if (mounted) {
          setState(() => _isSendingOtp = false);
          // Navigate to OTP page when code is sent
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => OtpPage(
              verificationId: verificationId,
              phoneNumber: phoneNumber, // Pass the new number
            ),
          ));
        }
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }


  // --- IMAGE PICKING LOGIC ---
  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source, imageQuality: 50);

    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.of(context).pop();
                  _getImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _getImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
           if (_isSendingOtp)
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Center(child: CircularProgressIndicator(color: Colors.white)),
            )
          else if (_isEditing)
            TextButton(onPressed: _saveProfile, child: const Text('Save'))
          else
            TextButton(onPressed: () => setState(() => _isEditing = true), child: const Text('Edit')),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // --- UPDATED PROFILE PICTURE WIDGET ---
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    // Show the selected image, or the default icon
                    backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                    child: _profileImage == null ? const Icon(Icons.person, size: 60) : null,
                  ),
                  // Show edit button only when in edit mode
                  if (_isEditing)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _showImageSourceDialog,
                        child: const CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.blue,
                          child: Icon(Icons.camera_alt, color: Colors.white, size: 22),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // The fields are now TextFormFields
            TextFormField(
              controller: _nameController,
              enabled: _isEditing,
              decoration: const InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _ageController,
              enabled: _isEditing,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Age',
                prefixIcon: Icon(Icons.calendar_today_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              enabled: _isEditing,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone_outlined),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}