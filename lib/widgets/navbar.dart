import 'package:flutter/material.dart';

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  final Color primaryColor;

  const Navbar({super.key, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: primaryColor,
      elevation: 0,
      centerTitle: true, // Ini memastikan judul di tengah
      title: const Row(
        mainAxisSize:
            MainAxisSize.min, // Supaya item di dalam Row tetap di tengah
        children: [
          Icon(Icons.games, color: Colors.white),
          SizedBox(width: 8),
          Text(
            'GameHunt',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
