import 'package:flutter/material.dart';
import 'package:gamehunt/news/models/news_model.dart';

class NewsBox extends StatelessWidget {
  final News news;

  const NewsBox({super.key, required this.news});
  
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              news.fields.title,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(news.fields.author),
            const SizedBox(height: 10),
            Text((news.fields.updateDate).toString()),
            const SizedBox(height: 10),
            Text(news.fields.article),
          ],
        ),
      );
  }
  
}

