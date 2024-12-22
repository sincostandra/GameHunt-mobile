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
  final VoidCallback onDelete;

  CommentItem({
    required this.comment,
    required this.isAdmin,
    required this.game,
    required this.onDelete
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
                  onPressed: onDelete
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