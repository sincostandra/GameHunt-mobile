import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class AddReviewPage extends StatefulWidget {
  final String gameId;

  const AddReviewPage({super.key, required this.gameId});

  @override
  State<AddReviewPage> createState() => _AddReviewPageState();
}

class _AddReviewPageState extends State<AddReviewPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _scoreController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  bool isLoading = false;

  Future<void> submitReview() async {
    setState(() { isLoading = true; });

    final request = context.read<CookieRequest>();
    try {
      // Pastikan URL di bawah sesuai dengan urls.py Anda
      final response = await request.post(
        "https://utandra-nur-gamehunts.pbp.cs.ui.ac.id/review/create_review_ajax/${widget.gameId}",
        {
          'title': _titleController.text,
          'score': _scoreController.text,    // Pastikan "score" bisa di-casting ke int di sisi Django
          'content': _contentController.text
        },
      );

      // Jika berhasil, tutup halaman & refresh daftar review di halaman sebelumnya
      if (response['title'] != null) {
        Navigator.pop(context, true); 
      } else {
        // Gagal
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add review.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error adding review: $e")),
      );
    } finally {
      setState(() { isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryRed = Color(0xFFFF5252);
    const darkBlue = Color(0xFF1C1E26);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Review'),
        backgroundColor: primaryRed,
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryRed))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Title Field
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Review Title',
                      hintText: 'Enter review title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Score Field
                  TextField(
                    controller: _scoreController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Score',
                      hintText: 'Enter a numeric score',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Content Field
                  TextField(
                    controller: _contentController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: 'Content',
                      hintText: 'Write your review here...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: submitReview,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryRed,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}