import 'package:flutter/material.dart';
import 'package:gamehunt/news/models/news_model.dart';
import 'package:gamehunt/news/screens/edit_news.dart';

class NewsBox extends StatelessWidget {
  final News news;
  final bool isAdmin;

  const NewsBox({super.key, required this.news, required this.isAdmin});
  
  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFFF44336);
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
            if (isAdmin) ...[
                // const SizedBox(width: 16),
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) =>
                //               const HomePage()),
                //     );
                //   },
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: primaryColor,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(8.0),
                //     ),
                //     padding: const EdgeInsets.symmetric(
                //         horizontal: 16.0, vertical: 12.0),
                //   ),
                //   child: const Text('Delete',
                //       style: TextStyle(
                //           fontSize: 20, fontWeight: FontWeight.bold)),
                // ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                            NewsEditFormPage(initialData: news, newsId: news.pk)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                  ),
                  child: const Text('Edit',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                ),

            ],
            Text(
              news.fields.title,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(news.fields.author),
            const SizedBox(width: 10),
            Text((news.fields.updateDate).toIso8601String()),
            const SizedBox(height: 10),
            Text(
              news.fields.article,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      );
  }
  
}

