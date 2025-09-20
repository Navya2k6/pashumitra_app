// FILE: lib/menu_page.dart

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting the date
import 'package:logger/logger.dart';
import 'dart:ui';
// Add this import at the top of lib/menu_page.dart
import 'package:pashumitra_app/generated/app_localizations.dart'; // Ensure package name is correct
import 'herd_page.dart';
import 'dart:convert'; // For handling JSON data
import 'package:geolocator/geolocator.dart'; // For location
import 'package:http/http.dart' as http; // For API calls
import 'package:image_picker/image_picker.dart'; // For camera

// Your color constants
const Color kPrimaryColor = Color.fromARGB(255, 1, 1, 1);

// INITIALIZE THE LOGGER
final logger = Logger();

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // State variables for weather
  Map<String, dynamic>? _weatherData;
  bool _isLoading = true;
  String? _errorMessage;

  // IMPORTANT: PASTE YOUR FREE API KEY FROM OPENWEATHERMAP HERE
  final String _apiKey = '49d9056bf22c3c126dcd239dc5c683d2';

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  // --- Helper Functions ---
  String _getFormattedDate() {
    // This formats the date like "Sat, 4 Dec"
    return DateFormat('E, d MMM').format(DateTime.now());
  }

  Widget _getWeatherIcon(String? weatherMain) {
    String iconCode;
    // This selects the correct weather icon based on the API response
    switch (weatherMain?.toLowerCase()) {
      case 'clear':
        iconCode = '01d'; // Sun
        break;
      case 'clouds':
        iconCode = '02d'; // Sun with clouds
        break;
      case 'rain':
      case 'drizzle':
        iconCode = '10d'; // Rain
        break;
      case 'thunderstorm':
        iconCode = '11d'; // Thunderstorm
        break;

      case 'snow':
        iconCode = '13d'; // Snow
        break;
      default:
        iconCode = '03d'; // Default to cloudy
    }
    return Image.network(
      'https://openweathermap.org/img/wn/$iconCode@4x.png', // Using larger 4x icon
      width: 100,
      height: 100,
      fit: BoxFit.cover,
    );
  }


  // --- Weather Fetching Logic ---
  Future<void> _fetchWeatherData() async {
    try {
      if (!mounted) return;
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permissions are denied';
        }
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      final url =
          'https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=$_apiKey&units=metric';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            _weatherData = json.decode(response.body);
            _isLoading = false;
          });
        }
      } else {
        throw 'Failed to load weather data. Check API Key.';
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
      logger.e("Weather Error: $e");
    }
  }

  // --- Camera & Gallery Logic ---
  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      logger.i('Image picked from ${source.name}: ${image.path}');
      // You can now process this image file (e.g., send to an API)
    } else {
      logger.w('No image selected from ${source.name}.');
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.camera_alt, color: Colors.black87),
                  title: const Text('Take a Photo', style: TextStyle(color: Colors.black87)),
                  onTap: () {
                    Navigator.of(context).pop();
                    _getImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library, color: Colors.black87),
                  title: const Text('Choose from Gallery', style: TextStyle(color: Colors.black87)),
                  onTap: () {
                    Navigator.of(context).pop();
                    _getImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the localizations object once to reuse
    final localizations = AppLocalizations.of(context)!;

    final List<Widget> pages = [
      buildHomePage(context),
      const HerdPage(),
      // UPDATED: Placeholder titles now use localization keys
      PlaceholderPage(pageName: localizations.herdPageTitle, icon: Icons.pets),
      PlaceholderPage(pageName: localizations.aiChatPageTitle, icon: Icons.chat_bubble),
      PlaceholderPage(pageName: localizations.profilePageTitle, icon: Icons.person),
    ];

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background2.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const Icon(Icons.menu, color: Colors.black54),
          // UPDATED: App title now uses localization key
          title: Text(localizations.appTitle,
              style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
          actions: [
            IconButton(
                icon: const Icon(Icons.account_circle,
                    color: Colors.black54, size: 28),
                onPressed: () {}),
            const SizedBox(width: 8),
          ],
          flexibleSpace: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
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
        ),
        body: IndexedStack(index: _selectedIndex, children: pages),
        floatingActionButton: FloatingActionButton(
          onPressed: _showImageSourceDialog, // This now shows the choice dialog
          backgroundColor: const Color.fromARGB(255, 1, 68, 37),
          child: const Icon(Icons.camera_alt, color: Colors.white),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8.0,
          color: Colors.transparent,
          elevation: 0,
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                height: 60.0,
                decoration:
                    BoxDecoration(color: Colors.white.withOpacity(0.2)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    _buildNavItem(icon: Icons.home_rounded, index: 0, label: localizations.navHome),
                    _buildNavItem(icon: Icons.pets, index: 1, label: localizations.navHerd),
                    const SizedBox(width: 40),
                    _buildNavItem(
                        icon: Icons.chat_bubble, index: 2, label: localizations.navAiChat),
                    _buildNavItem(icon: Icons.person, index: 3, label: localizations.navProfile),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      {required IconData icon, required int index, required String label}) {
    final bool isSelected = _selectedIndex == index;
    final Color activeColor = kPrimaryColor;
    final Color inactiveColor = Colors.grey.shade800;
    return InkWell(
      onTap: () => _onItemTapped(index),
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                color: isSelected ? activeColor : inactiveColor, size: 24),
            const SizedBox(height: 2),
            Text(label,
                style: TextStyle(
                    color: isSelected ? activeColor : inactiveColor,
                    fontSize: 12,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
      ),
    );
  }

  // --- UPDATED Home Page Widget ---
  Widget buildHomePage(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(
        top: kToolbarHeight + MediaQuery.of(context).padding.top + 16,
        bottom: kBottomNavigationBarHeight + 40,
        left: 16,
        right: 16,
      ),
      children: [
        _buildWeatherBox(context),
        const SizedBox(height: 24),
        _buildScanBox(context),
        const SizedBox(height: 24),
        _buildEmergencyBox(context), // The emergency message is now in its own box
      ],
    );
  }

  // --- UPDATED WEATHER WIDGET ---
  Widget _buildWeatherBox(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF81C7F8).withOpacity(0.8),
                const Color.fromARGB(255, 159, 191, 209).withOpacity(0.6),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator(color: Colors.black54))
              : _errorMessage != null
                  ? Center(child: Text(_errorMessage!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(localizations.today, style: const TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(_getFormattedDate(), style: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.location_on, color: Colors.black.withOpacity(0.6), size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${_weatherData?['name'] ?? '...'}',
                                      style: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 16),
                                    ),
                                  ],
                                ),
                                Text(
                                  '${_weatherData?['main']['temp'].round() ?? ''}°C',
                                  style: const TextStyle(color: Colors.black87, fontSize: 56, fontWeight: FontWeight.w900, height: 1.2),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: _getWeatherIcon(_weatherData?['weather'][0]['main']),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          localizations.irrigationMessage,
                          style: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 14),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }

  // --- UPDATED SCAN WIDGET with separate button ---
  Widget _buildScanBox(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF81C7F8).withOpacity(0.8),
                const Color(0xFFB0DFFB).withOpacity(0.6),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(localizations.manageFarmTitle,
                  style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              // This Row of icons is now for display only
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStepIcon(Icons.camera_alt_outlined, localizations.takeAPicture),
                  const Icon(Icons.arrow_forward_ios, color: Colors.black54, size: 16),
                  _buildStepIcon(Icons.pets, localizations.breedIdentification),
                  const Icon(Icons.arrow_forward_ios, color: Colors.black54, size: 16),
                  _buildStepIcon(Icons.psychology_outlined, localizations.getAdvice),
                ],
              ),
              const SizedBox(height: 20),
              // This is the new button that performs the action
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _showImageSourceDialog,
                  icon: const Icon(Icons.camera_alt, color: Colors.white),
                  label: Text(localizations.takePictureButton, style: const TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 1, 68, 37),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // This widget is now only for displaying the icon and label
  Widget _buildStepIcon(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.black87, size: 32),
        const SizedBox(height: 8),
        Text(label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black87, fontSize: 12)),
      ],
    );
  }

  // --- NEW WIDGET for the emergency message ---
  Widget _buildEmergencyBox(BuildContext context) {
    // Add a localization key for this message in your .arb files if you want it to be translated
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2), // Subtle background color
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
           // UPDATED: Using RichText to highlight the phone number
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            // This is the default style for the normal text
            style: const TextStyle(
              color: Color.fromARGB(255, 41, 40, 40),
              fontSize: 14,
              height: 1.6,
            ),
          children: <TextSpan>[
              const TextSpan(text: 'If you need to report a situation involving an animal in immediate danger, please call our emergency number : '),
              TextSpan(
                text: ' 📞 (0) 9820122602',
                // This is the highlight style for the phone number
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
              const TextSpan(text: '. If an animal is injured, please remain with the animal until help is secured.'),
            ],
          ),
        ),
        ),
      ),
    );
  }
}

// PlaceholderPage widget remains the same
class PlaceholderPage extends StatelessWidget {
  final String pageName;
  final IconData icon;

  const PlaceholderPage({super.key, required this.pageName, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.1),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: Colors.white70),
            const SizedBox(height: 16),
            Text(pageName,
                style: const TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}