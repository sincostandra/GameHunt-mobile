import 'package:flutter/material.dart';
import 'package:gamehunt/review/models/review.dart';
import 'package:gamehunt/models/game.dart';
import 'package:gamehunt/review/widgets/game_info_card.dart';
import 'package:gamehunt/review/widgets/review_card.dart';
import 'package:gamehunt/review/screens/add_review.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReviewPage extends StatefulWidget {
  final String gameId;
  const ReviewPage({super.key, required this.gameId});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  List<Review> reviews = [];
  Review? userReview;
  Game? game;
  bool isLoading = true;
  String? error;

  bool isAdmin = false;
  String currentUsername = "";

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // Fetch user role and username
  Future<void> fetchUserData() async {
    final request = context.read<CookieRequest>();
    try {
      final response = await request.get('https://utandra-nur-gamehunts.pbp.cs.ui.ac.id/review/get_user_role');
      setState(() {
        isAdmin = response['role'] == 'admin';
        currentUsername = response['username'] ?? "";
      });
    } catch (e) {
      print('Error fetching user role: $e');
    }
  }

  // Fetch the game data, all reviews, and user review
  Future<void> fetchData() async {
    setState(() { isLoading = true; });
    final request = context.read<CookieRequest>();
    try {
      await fetchUserData();

      final gameResponse = await request.get(
        'https://utandra-nur-gamehunts.pbp.cs.ui.ac.id/search/json/${widget.gameId}',
      );
      final allResponse = await request.get(
        'https://utandra-nur-gamehunts.pbp.cs.ui.ac.id/review/get_review_json/${widget.gameId}',
      );
      final userResponse = await request.get(
        'https://utandra-nur-gamehunts.pbp.cs.ui.ac.id/review/get_user_review/${widget.gameId}',
      );

      setState(() {
        if (gameResponse is List && gameResponse.isNotEmpty) {
          game = Game.fromJson(gameResponse[0]);
        }
        if (allResponse is List) {
          reviews = allResponse.map((e) => Review.fromJson(e)).toList();
        }
        if (userResponse != null && userResponse.isNotEmpty) {
          userReview = Review.fromJson(userResponse);
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _voteReview(int reviewId, String voteType) async {
  final request = context.read<CookieRequest>();
  final url = "https://utandra-nur-gamehunts.pbp.cs.ui.ac.id/review/vote_flutter/";

  try {
    final response = await request.post(url, {
      'review_id': reviewId.toString(),
      'vote_type': voteType,
    });

    final data = response;
    if (data['status'] == 'success') {
      await fetchData(); // Refresh to reorder reviews by vote_score
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vote successful')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'] ?? 'Failed to vote')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error voting: $e')),
    );
  }
}

  Future<void> _deleteReview(int reviewId) async {
  final request = context.read<CookieRequest>();
  // Delete di PWS gabisa, jadi pake post aja
  // final url = Uri.parse("https://utandra-nur-gamehunts.pbp.cs.ui.ac.id/review/delete_review_flutter/$reviewId");
  
  // If it's user's own review, update state immediately
  if (userReview?.id == reviewId) {
    setState(() {
      userReview = null;  // Clear user review first
    });
  }

  try {
    final response = await request.post(
      "https://utandra-nur-gamehunts.pbp.cs.ui.ac.id/review/delete_review_flutter/$reviewId/",
      {}
    );

    if (response['status'] == 'success') {
      await fetchData(); // Refresh data
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review deleted successfully')),
      );
    } else {
      throw Exception(response['message']);
    }
  } catch (e) {
    // If error, revert the state
    if (userReview == null) {
      await fetchData();
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    const primaryRed = Color(0xFFFF5252);
    const darkBlue = Color(0xFF1C1E26);
    const lightGray = Color(0xFFD1D1D1);

    return Scaffold(
      appBar: AppBar(
      backgroundColor: primaryRed,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Reviews',
        style: TextStyle(color: Colors.white),
      ),
    ),
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryRed))
          : error != null
              ? Center(child: Text(error!, style: TextStyle(color: darkBlue)))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (game != null) GameInfoCard(game: game!),
                      const SizedBox(height: 24),
                      const Text(
                        'Your Review',
                        style: TextStyle(
                          color: darkBlue,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      userReview == null
                          ? SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddReviewPage(gameId: widget.gameId),
                                    ),
                                  ).then((value) {
                                    if (value == true) {
                                      fetchData();
                                    }
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryRed,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Add Review',
                                  style: TextStyle(
                                    color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            )
                          : Column(
                              children: [
                                ReviewCard(
                                  review: userReview!,
                                  isAdmin: isAdmin,
                                  currentUsername: currentUsername,
                                  onDeleteReview: _deleteReview,
                                  onVote: _voteReview
                                ),
                                const Divider(color: primaryRed),
                              ],
                            ),
                      const SizedBox(height: 24),
                      const Text(
                        'Other Reviews',
                        style: TextStyle(
                          color: darkBlue,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      reviews.where((review) => userReview == null || review.id != userReview!.id).isEmpty
                          ? const Center(
                              child: Column(
                                children: [
                                  Icon(Icons.mail_outline, color: lightGray, size: 80),
                                  SizedBox(height: 16),
                                  Text(
                                    'No other reviews yet.',
                                    style: TextStyle(color: lightGray, fontSize: 16),
                                  ),
                                ],
                              ),
                            )
                          : Column(
                              children: reviews
                                  .where((review) => userReview == null || review.id != userReview!.id)
                                  .map((review) => Column(
                                        children: [
                                          ReviewCard(
                                            review: review,
                                            isAdmin: isAdmin,
                                            currentUsername: currentUsername,
                                            onDeleteReview: _deleteReview,
                                            onVote: _voteReview
                                          ),
                                          const Divider(color: primaryRed),
                                        ],
                                      ))
                                  .toList(),
                            ),
                    ],
                  ),
                ),
    );
  }
}