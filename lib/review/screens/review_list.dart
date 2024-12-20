import 'package:flutter/material.dart';
import 'package:gamehunt/review/models/review.dart';
import 'package:gamehunt/models/game.dart';
import 'package:gamehunt/review/screens/add_review.dart';
import 'package:gamehunt/review/widgets/game_info_card.dart';
import 'package:gamehunt/review/widgets/review_card.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final request = context.read<CookieRequest>();
    try {
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

  @override
  Widget build(BuildContext context) {
    const Color primaryRed = Color(0xFFFF5252);
    const Color darkBlue = Color(0xFF1C1E26);
    const Color lightGray = Color(0xFFD1D1D1);

    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading 
          ? const Center(child: CircularProgressIndicator(color: primaryRed))
          : error != null
              ? Center(child: Text(error!, style: TextStyle(color: darkBlue)))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
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
                                  // TODO: Navigate to add review page
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddReviewPage(gameId: widget.gameId),
                                    ),
                                  ).then((value) {
                                    // Jika value == true, berarti berhasil menambahkan
                                    // Panggil ulang fetchData() agar tampilan tersinkron
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
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                          : Column(
                              children: [
                                ReviewCard(review: userReview!),
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
                      
                      // Filter out user's review from other reviews
                      reviews.where((review) => 
                        userReview == null || review.id != userReview!.id
                      ).isEmpty
                          ? const Center(
                              child: Column(
                                children: [
                                  Icon(Icons.mail_outline, 
                                       color: lightGray, 
                                       size: 80),
                                  SizedBox(height: 16),
                                  Text(
                                    'No other reviews yet.',
                                    style: TextStyle(
                                      color: lightGray, 
                                      fontSize: 16
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Column(
                              children: reviews
                                  .where((review) => 
                                    userReview == null || 
                                    review.id != userReview!.id
                                  )
                                  .map((review) => Column(
                                    children: [
                                      ReviewCard(review: review),
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