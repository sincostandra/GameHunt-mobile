import 'package:flutter/material.dart';
import 'package:gamehunt/models/game.dart'; // Adjust the import according to your project structure

class OverviewBox extends StatelessWidget {
  final Game game;

  OverviewBox({required this.game});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            margin: const EdgeInsets.only(top: 80.0, bottom: 16.0),
            padding: const EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0, bottom: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
              border: Border.all(color: Colors.grey.withOpacity(0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40), // Space for the image
                Text(
                  game.fields.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${game.fields.ratings} • ${game.fields.developer} • ${game.fields.genre} • ${game.fields.year}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Handle See Reviews button press
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow, // Background color
                    foregroundColor: Colors.white, // Text color
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star_rate, color: Colors.white), // Built-in icon
                      const SizedBox(width: 8),
                      const Text('See Reviews'),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    // Handle Wishlist button press
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 41, 133, 209), // Background color
                    foregroundColor: Colors.white, // Text color
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.favorite_border, color: Colors.white), // Built-in icon
                      const SizedBox(width: 8),
                      const Text('Wishlist'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: (MediaQuery.of(context).size.width * 0.9) / 2 - 60, // Center the larger image
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0), // Adjust the border radius as needed
              child: Image.asset(
                'images/logo.png', // Replace with your asset image path
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}