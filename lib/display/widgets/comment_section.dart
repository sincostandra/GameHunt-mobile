import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:gamehunt/display/models/comment.dart'; // Adjust the import according to your project structure
import 'package:gamehunt/display/widgets/comment_item.dart'; // Import the CommentItem widget
import 'package:gamehunt/models/game.dart'; // Adjust the import according to your project structure
import 'package:gamehunt/display/screens/game_details.dart';

class CommentSection extends StatelessWidget {
  final Game game;
  final bool isAdmin;

  const CommentSection({super.key, required this.game, required this.isAdmin});

  Future<List<CommentEntry>> fetchComment(
      CookieRequest request) async {
    final response = await request.get(
        'https://utandra-nur-gamehunts.pbp.cs.ui.ac.id/display/show-json/${game.pk}/');
    var data = response;
    List<CommentEntry> listComment = [];
    for (var d in data) {
      if (d != null) {
        listComment.add(CommentEntry.fromJson(d));
      }
    }
    return listComment;
  }

  Future<void> _deleteComment(BuildContext context, int commentId) async {
    final request = context.read<CookieRequest>();
    // Delete di PWS gabisa, jadi pake post aja
    // final url = Uri.parse("https://utandra-nur-gamehunts.pbp.cs.ui.ac.id/review/delete_review_flutter/$reviewId");

    try {
      final response = await request.post(
        "https://utandra-nur-gamehunts.pbp.cs.ui.ac.id/display/delete-comment-flutter/$commentId/",
        {}
      );

      if (response['status'] == 'success') {
        await fetchComment(request); // Refresh data
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Comment deleted successfully!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  GameDetailPage(game: game, isAdmin: true)),
        );
      } else {
        throw Exception(response['message']);
      }
    } catch (e) {
      // If error, revert the state
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return FutureBuilder<List<CommentEntry>>(
      future: fetchComment(request),
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
                  ...snapshot.data!.map((comment) => CommentItem(
                      comment: comment, 
                      isAdmin: isAdmin, 
                      game: game, 
                      onDelete: () {
                        _deleteComment(context, comment.pk);
                      })),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
