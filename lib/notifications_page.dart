// FILE: lib/notifications_page.dart

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'dart:ui'; // Make sure this import is here for ImageFilter

// You can create this a separate widget file, or keep it in the same file.
// For simplicity, we'll include it here.
class NotificationCard extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const NotificationCard({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 36, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// This is the main Notifications page.
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        
        // --- ADD THE flexibleSpace BLOCK HERE ---
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Same blur as your main app bar
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.lightBlue.shade200.withOpacity(0.7),
                    Colors.lime.shade200.withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
        ),
        // --- END OF flexibleSpace BLOCK ---
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          NotificationCard(
            title: 'Vaccination Reminder',
            message: 'Your cow, Lakshmi, is due for her annual vaccination on October 5th.',
            icon: Icons.local_hospital_outlined,
          ),
          NotificationCard(
            title: 'Health Checkup',
            message: 'Schedule a health checkup for your goat. It has been 6 months since the last one.',
            icon: Icons.medical_services_outlined,
          ),
          NotificationCard(
            title: 'New Article Available',
            message: 'Read our latest article: "Tips for managing livestock during the winter season."',
            icon: Icons.article_outlined,
          ),
        ],
      ),
    );
  }
}