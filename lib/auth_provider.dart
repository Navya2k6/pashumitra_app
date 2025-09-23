// FILE: lib/auth_provider.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn;
  String _name = "Sama Reddy";
  String _age = "35";
  String _phoneNumber = "+91 12345 67890";
  String? _imagePath; 

   bool _hasUnreadNotifications = true; 

  AuthProvider(this._isLoggedIn) {
    // When the app starts, load the saved data
    if (_isLoggedIn) {
      _loadProfile();
    }
  }

  // Getters for the UI to read the data
  bool get isLoggedIn => _isLoggedIn;
  String get name => _name;
  String get age => _age;
  String get phoneNumber => _phoneNumber;
  String? get imagePath => _imagePath; // ADDED: Getter for the image path

   bool get hasUnreadNotifications => _hasUnreadNotifications;

    void markNotificationsAsRead() {
    _hasUnreadNotifications = false;
    notifyListeners(); // This will tell the UI to rebuild
  }

  
  // Method to load data from storage
  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    _name = prefs.getString('userName') ?? _name;
    _age = prefs.getString('userAge') ?? _age;
    _phoneNumber = prefs.getString('userPhone') ?? _phoneNumber;
    _imagePath = prefs.getString('userImagePath'); // ADDED: Load image path
    notifyListeners();
  }
  
  // Methods for the UI to update the data
  Future<void> updateName(String newName) async {
    _name = newName;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', newName);
  }

  Future<void> updateAge(String newAge) async {
    _age = newAge;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userAge', newAge);
  }

  Future<void> updatePhoneNumber(String newPhone) async {
    _phoneNumber = newPhone;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userPhone', newPhone);
  }

  // ADDED: Method to update the image path
  Future<void> updateImagePath(String? newPath) async {
    _imagePath = newPath;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    if (newPath != null) {
      await prefs.setString('userImagePath', newPath);
    } else {
      await prefs.remove('userImagePath');
    }
  }


  Future<void> login() async {
    _isLoggedIn = true;
    await _loadProfile(); // Load data on login
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    // Optionally clear profile data on logout
    // await prefs.remove('userName');
  }
}