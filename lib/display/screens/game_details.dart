import 'package:flutter/material.dart';
import 'package:gamehunt/models/game.dart'; // Adjust the import according to your project structure
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:gamehunt/home/home.dart';
import 'package:gamehunt/display/models/comment.dart'; // Adjust the import according to your project structure

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
            _buildStoreBox(context, game.fields.toko1, game.fields.alamat1),
            if (game.fields.toko2 != null && game.fields.toko2!.isNotEmpty)
              _buildStoreBox(context, game.fields.toko2!, game.fields.alamat2!),
            if (game.fields.toko3 != null && game.fields.toko3!.isNotEmpty)
              _buildStoreBox(context, game.fields.toko3!, game.fields.alamat3!),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow, // Background color
                    foregroundColor: Colors.white, // Text color
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star_rate, color: Colors.white), // Built-in icon
                      const SizedBox(width: 8),
                      const Text('See Reviews'),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    // Handle Wishlist button press
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 41, 133, 209), // Background color
                    foregroundColor: Colors.white, // Text color
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.favorite_border, color: Colors.white), // Built-in icon
                      const SizedBox(width: 8),
                      const Text('Wishlist'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: (MediaQuery.of(context).size.width * 0.9) / 2 - 60, // Center the larger image
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0), // Adjust the border radius as needed
              child: Image.asset(
                'images/logo.png', // Replace with your asset image path
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
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

  Widget _buildStoreBox(BuildContext context, String storeName, String address) {
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
        child: Row(
          children: [
            Container(
              width: 80,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_on, color: Colors.red, size: 40),
                  const SizedBox(height: 8),
                  const Text(
                    'Available Store',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    storeName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    address,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentSection(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return FutureBuilder<List<CommentEntry>>(
      future: fetchComment(request, game.pk),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading comments'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No comments found'));
        } else {
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
                  ...snapshot.data!.map((comment) => _buildCommentItem(comment.fields.name, comment.fields.body)).toList(),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Future<List<CommentEntry>> fetchComment(CookieRequest request, String gameId) async {
    final response = await request.get('http://127.0.0.1:8000/display/show-json/$gameId/');
    var data = response;
    List<CommentEntry> listComment = [];
    for (var d in data) {
      if (d != null) {
        listComment.add(CommentEntry.fromJson(d));
      }
    }
    return listComment;
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
                      "http://127.0.0.1:8000/display/create-comment-flutter/",
                      jsonEncode(<String, String>{
                        'body': _body,
                        'game': game.pk,
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
                              builder: (context) => GameDetailPage(game: game)),
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
