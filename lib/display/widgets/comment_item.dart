import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gamehunt/display/screens/game_details.dart';
import 'dart:convert';
import 'package:gamehunt/models/game.dart';
import 'package:gamehunt/display/models/comment.dart';
import 'package:intl/intl.dart';

class CommentItem extends StatelessWidget {
  final CommentEntry comment;
  final bool isAdmin;
  final Game game;

  CommentItem({
    required this.comment,
    required this.isAdmin,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(comment.fields.created);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                comment.fields.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              if (isAdmin)
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
              // Karena tidak ada deleteJson, kita gunakan http.delete
              final url = Uri.parse(
                  "http://127.0.0.1:8000/display/delete-comment-flutter/${comment.pk}/");
              final httpResponse =
                  await http.delete(url);
              if (httpResponse.statusCode ==
                  200) {
                final responseData = jsonDecode(
                    httpResponse.body);
                if (responseData['status'] ==
                    'success') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            GameDetailPage(game: game, isAdmin: true)),
                  );
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                          "Comment successfully deleted!"),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                          "Error deleting comment."),
                    ),
                  );
                }
              } else {
                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                        "Error deleting comment."),
                  ),
                );
              }
            },
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            comment.fields.body,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            'Posted on: $formattedDate',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}