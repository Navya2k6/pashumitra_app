// FILE: lib/profile_page.dart

// ignore_for_file: unused_import, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pashumitra_app/language_selection_screen.dart';
import 'package:pashumitra_app/menu_page.dart'; // For kBottomNavigationBarHeight
import 'dart:io';
import 'detailed_profile_page.dart';
import 'login_page.dart';
import 'theme_provider.dart';
import 'auth_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // --- LOGOUT CONFIRMATION DIALOG ---
  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                // Perform logout, then close the dialog
                Provider.of<AuthProvider>(context, listen: false).logout();
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    // Use a base scaffold to provide a consistent background color
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: authProvider.isLoggedIn
          ? _buildLoggedInProfile(context)
          : _buildLoggedOutProfile(context),
    );
  }

  // --- Logged-In View ---
  Widget _buildLoggedInProfile(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return ListView(
      padding: EdgeInsets.only(
        top: kToolbarHeight + 50,
        bottom: kBottomNavigationBarHeight + 40,
        left: 16,
        right: 16,
      ),
      children: [
        _buildProfileHeader(context),
        const SizedBox(height: 32),

        // First group of settings
        _buildSettingsGroup(
          context: context,
          title: "Preferences",
          children: [
            _buildProfileOption(
              icon: Icons.language,
              title: "Change Language",
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const LanguageSelectionScreen()));
              },
            ),
            const Divider(height: 1, indent: 16, endIndent: 16),
            ListTile(
              leading: const Icon(Icons.dark_mode_outlined),
              title: const Text("Dark Mode", style: TextStyle(fontWeight: FontWeight.w500)),
              trailing: Switch(
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  themeProvider.toggleTheme(value);
                },
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 24),

        // Second group of settings
        _buildSettingsGroup(
          context: context,
          title: "Support",
          children: [
            _buildProfileOption(
              icon: Icons.support_agent,
              title: "Query Support",
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Navigating to support...')),
                );
              },
            ),
            const Divider(height: 1, indent: 16, endIndent: 16),
            _buildProfileOption(
              icon: Icons.info_outline,
              title: "About Us",
              onTap: () {},
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Separate card for the Logout button
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: _buildProfileOption(
            icon: Icons.logout,
            title: "Logout",
            textColor: Colors.red,
            onTap: () {
              _showLogoutConfirmationDialog(context);
            },
          ),
        ),
      ],
    );
  }
  
  // --- Professional Logged-Out View ---
  Widget _buildLoggedOutProfile(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Card(
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.shield_outlined,
                  size: 60,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  'Your Account',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Log in to access your farm details, herd management, and personalized advice.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginPage()));
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    child: const Text('Login'),
                  ),
                ),
                const SizedBox(height: 12),
             
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Reusable UI Components ---

  // A helper to create a titled group of settings
  Widget _buildSettingsGroup({
    required BuildContext context, 
    required String title, 
    required List<Widget> children
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Card(
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  // A reusable ListTile for a standard option
  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DetailedProfilePage()));
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).cardColor,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)]
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundImage: authProvider.imagePath != null
                  ? FileImage(File(authProvider.imagePath!))
                  : null,
              child: authProvider.imagePath == null
                  ? const Icon(Icons.person, size: 40)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    authProvider.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "View Profile",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}