import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gamehunt/news/screens/news_page.dart';
import '../search/screens/list_gameentry.dart';
import '../userprofile/screens/user_profile_page.dart';
import 'package:gamehunt/widgets/navbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFFF44336);
    return Scaffold(
      appBar: Navbar(primaryColor: primaryColor),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoButton(
              color: Colors.grey,
              child: const Text("User Profile"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserProfilePage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16), // Jarak antar tombol
            CupertinoButton(
              color: Colors.blue,
              child: const Text("View Games"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GameEntryPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16), // Jarak antar tombol
            CupertinoButton(
              color: Colors.pink,
              child: const Text("News"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NewsPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
