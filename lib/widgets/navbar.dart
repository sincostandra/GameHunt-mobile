import 'package:flutter/material.dart';
import 'package:gamehunt/authentication/login.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  final Color primaryColor;

  const Navbar({super.key, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    
    return AppBar(
      backgroundColor: primaryColor,
      elevation: 0,
      centerTitle: true,
      title: const Row(
        mainAxisSize: MainAxisSize.min,
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
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: PopupMenuButton<String>(
            icon: const CircleAvatar(
              backgroundColor: Colors.white24,
              child: Icon(Icons.person, color: Colors.white),
            ),
            onSelected: (value) async {
              if (value == 'logout') {
                final response = await request.logout(
                  'https://utandra-nur-gamehunts.pbp.cs.ui.ac.id/authentication/flutter-logout/'
                );
                String message = response["message"];
                if (context.mounted) {
                    if (response['status']) {
                      String uname = response["username"];
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("$message Sampai jumpa, $uname."),
                      ));
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(message),
                        ),
                      );
                    }
                  }
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}