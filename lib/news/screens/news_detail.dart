import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gamehunt/news/models/news_model.dart';
import 'package:gamehunt/news/screens/edit_news.dart';
import 'package:gamehunt/news/screens/news_page.dart';
import 'package:gamehunt/widgets/navbar.dart';
import 'package:gamehunt/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class NewsDetail extends StatelessWidget {
  final News news;
  final bool isAdmin;

  const NewsDetail({super.key, required this.news, required this.isAdmin});
  final primaryColor = const Color(0xFFF44336);

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: Navbar(primaryColor: primaryColor),
      drawer: const LeftDrawer(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (isAdmin) ...[
            FloatingActionButton(
              heroTag: null,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          NewsEditFormPage(initialData: news)),
                );
              },
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              // padding: const EdgeInsets.symmetric(
              //     horizontal: 16.0, vertical: 12.0),
              child: const Icon(
                Icons.edit,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              // child: const Text('Edit News',
              // textAlign: TextAlign.center,
              //   style: TextStyle(
              //       fontSize: 12, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 10),
            FloatingActionButton(
              heroTag: null,
              onPressed: () async {
                // Karena tidak ada deleteJson, kita gunakan http.delete
                //final url = Uri.parse(
                  //  "https://utandra-nur-gamehunts.pbp.cs.ui.ac.id/news/delete-flutter/${news.pk}/");
                final jsonResponse = await request.post("https://utandra-nur-gamehunts.pbp.cs.ui.ac.id/news/delete-flutter/${news.pk}/", {});
                final responseData = jsonResponse;
                if (responseData['status'] == 'success') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const NewsPage()),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Game successfully deleted!"),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Error deleting game."),
                    ),
                  );
                }
              },
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              // padding: const EdgeInsets.symmetric(
              //     horizontal: 16.0, vertical: 12.0),
              child: const Icon(
                Icons.delete,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ]
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(news.fields.title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(news.fields.author, style: const TextStyle(fontSize: 12)),
            const SizedBox(width: 10),
            Text(news.fields.updateDate.toIso8601String(),
                style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 8),
            Text(news.fields.article, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Back'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
