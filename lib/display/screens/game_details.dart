import 'package:flutter/material.dart';
import 'package:gamehunt/models/game.dart'; // Adjust the import according to your project structure
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:gamehunt/home/home.dart';

class GameDetailPage extends StatelessWidget {
  final Game game;

  GameDetailPage({required this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(game.fields.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildOverviewBox(context),
            _buildDetailBox(context, "Name", game.fields.name),
            _buildDetailBox(context, "Description", game.fields.description),
            _buildDetailBox(context, "Year", game.fields.year.toString()),
            _buildDetailBox(context, "Developer", game.fields.developer),
            _buildDetailBox(context, "Genre", game.fields.genre),
            _buildDetailBox(context, "Ratings", game.fields.ratings.toString()),
            _buildDetailBox(context, "Harga", game.fields.harga.toString()),
            _buildDetailBox(context, "Toko 1", game.fields.toko1),
            _buildDetailBox(context, "Alamat 1", game.fields.alamat1),
            if (game.fields.toko2 != null)
              _buildDetailBox(context, "Toko 2", game.fields.toko2!),
            if (game.fields.alamat2 != null)
              _buildDetailBox(context, "Alamat 2", game.fields.alamat2!),
            const SizedBox(height: 16),
            _buildCommentForm(context),
            const SizedBox(height: 16),
            _buildCommentSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewBox(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
          width: MediaQuery.of(context).size.width * 0.9,
            margin: const EdgeInsets.only(top: 80.0, bottom: 16.0),
            padding: const EdgeInsets.only(top: 20.0, left:16.0, right: 16.0, bottom: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
              border: Border.all(color: Colors.grey.withOpacity(0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40), // Space for the image
                Text(
                  game.fields.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${game.fields.ratings} • ${game.fields.developer} • ${game.fields.genre} • ${game.fields.year}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Handle See Reviews button press
                  },
                  child: const Text('See Reviews'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    // Handle Wishlist button press
                  },
                  child: const Text('Wishlist'),
                ),
              ],
            ),
          ),
          Positioned(
            top: 16.0,
            left: (MediaQuery.of(context).size.width * 0.9) / 2 - 60,
            child: CircleAvatar(
              radius: 60,
              // backgroundImage: NetworkImage(game.fields.imageUrl), // Replace with your image URL
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailBox(BuildContext context, String title, String content) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              content,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentSection(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Comments',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            _buildCommentItem('User1', 'This game is amazing!'),
            _buildCommentItem('User2', 'I love the graphics and gameplay.'),
            _buildCommentItem('User3', 'Could use some improvements in the storyline.'),
            // Add more comments as needed
          ],
        ),
      ),
    );
  }

  Widget _buildCommentItem(String username, String comment) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            username,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            comment,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentForm(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String _content = "";

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
                _content = value!;
              },
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Isi komen tidak boleh kosong!";
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
                      "http://127.0.0.1:8000/create-flutter/",
                      jsonEncode(<String, String>{
                        'content': _content,
                      }),
                    );
                    if (context.mounted) {
                      if (response['status'] == 'success') {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Komentar berhasil disimpan!"),
                        ));
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),
                        );
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content:
                              Text("Terdapat kesalahan, silakan coba lagi."),
                        ));
                      }
                    }
                  }
                },
                child: const Text(
                  "Save",
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
