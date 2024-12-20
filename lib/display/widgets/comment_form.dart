import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:gamehunt/models/game.dart'; // Adjust the import according to your project structure
import 'package:gamehunt/display/screens/game_details.dart';

class CommentForm extends StatelessWidget {
  final Game game;
  final bool isAdmin;

  CommentForm({required this.game, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String _body = "";

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: "Comment",
                labelText: "Comment your thoughts...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              onChanged: (String? value) {
                _body = value!;
              },
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Comment cannot be empty!";
                }
                return null;
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.primary),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final request = context.read<CookieRequest>();
                    // Kirim ke Django dan tunggu respons
                    final response = await request.postJson(
                      "http://127.0.0.1:8000/display/create-comment-flutter/",
                      jsonEncode(<String, String>{
                        'body': _body,
                        'game': game.pk.toString(),
                      }),
                    );
                    if (context.mounted) {
                      if (response['status'] == 'success') {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Comment posted!"),
                        ));
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GameDetailPage(game: game, isAdmin: isAdmin)),
                        );
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content:
                              Text("Error, please try again."),
                        ));
                      }
                    }
                  }
                },
                child: const Text(
                  "Post",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}