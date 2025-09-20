// FILE: lib/herd_page.dart

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'dart:ui';

// A simple class to hold our animal data
class Animal {
  final String name;
  final String breed;
  final double milkYield;
  final String imageUrl;

  const Animal({
    required this.name,
    required this.breed,
    required this.milkYield,
    required this.imageUrl,
  });
}

class HerdPage extends StatelessWidget {
  const HerdPage({super.key});

  // Dummy data for the list of animals
  final List<Animal> _dummyAnimals = const [
    Animal(
      name: 'Lakshmi',
      breed: 'Holstein Friesian',
      milkYield: 25.5,
      imageUrl: 'assets/images/Holstein.jpg',
    ),
    Animal(
      name: 'Ganga',
      breed: 'Jersey',
      milkYield: 22.0,
      imageUrl: 'assets/images/jersey.png',
    ),
    Animal(
      name: 'Yamuna',
      breed: 'Murrah Buffalo',
      milkYield: 18.7,
      imageUrl: 'assets/images/murrah_buffalo.png',
    ),
    // Add more animals here
  ];

  @override
  Widget build(BuildContext context) {
    // A ListView is best for a scrollable list of items
    return ListView.builder(
      // Add padding to account for the AppBar and BottomAppBar
      padding: EdgeInsets.only(
        top: kToolbarHeight + MediaQuery.of(context).padding.top ,
        bottom: kBottomNavigationBarHeight + 40,
        left: 16,
        right: 16,
      ),
      itemCount: _dummyAnimals.length,
      itemBuilder: (context, index) {
        final animal = _dummyAnimals[index];
        // Each item is built by this method
        return _buildAnimalCard(animal);
      },
    );
  }

  // --- UPDATED WIDGET for the animal card ---
  Widget _buildAnimalCard(Animal animal) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          // Set the solid background color
          color: const Color.fromARGB(255, 177, 212, 236),
          borderRadius: BorderRadius.circular(20),
          // Add a subtle shadow for depth
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Animal Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                animal.imageUrl,
                width: 80,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            // Animal Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    animal.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    animal.breed,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${animal.milkYield} Litres/day',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
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