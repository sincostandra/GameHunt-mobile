import 'package:flutter/material.dart';

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  final Color primaryColor;

  const Navbar({Key? key, required this.primaryColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: primaryColor,
      elevation: 0,
      centerTitle: true, // Ini memastikan judul di tengah
      title: Row(
        mainAxisSize:
            MainAxisSize.min, // Supaya item di dalam Row tetap di tengah
        children: [
          const Icon(Icons.games, color: Colors.white),
          const SizedBox(width: 8),
          const Text(
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
