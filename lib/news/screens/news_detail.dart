import 'package:flutter/material.dart';
import 'package:gamehunt/news/models/news_model.dart';
import 'package:gamehunt/widgets/navbar.dart';
import 'package:gamehunt/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class NewsDetail extends StatelessWidget {
  final News news;

  const NewsDetail({Key? key, required this.news}) : super(key: key);
  final primaryColor = const Color(0xFFF44336);

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: Navbar(primaryColor: primaryColor),
      drawer: const LeftDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(news.fields.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(news.fields.author, style: TextStyle(fontSize: 12)),
            const SizedBox(width: 10),
            Text(news.fields.updateDate.toIso8601String(), style: TextStyle(fontSize: 12)),
            const SizedBox(height: 8),
            Text(news.fields.article, style: TextStyle(fontSize: 16)),
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
