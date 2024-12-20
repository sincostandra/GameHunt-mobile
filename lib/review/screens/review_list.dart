import 'package:flutter/material.dart';
import 'package:gamehunt/review/models/review.dart';
import 'package:gamehunt/models/game.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ReviewPage extends StatefulWidget {
  final String gameId;

  const ReviewPage({required this.gameId});

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
      final allResponse = await request.get(
          'http://127.0.0.1:8000/review/get_review_json/${widget.gameId}');
      final userResponse = await request.get(
          'http://127.0.0.1:8000/review/get_user_review/${widget.gameId}');
      final gameResponse = await request.get(
          'http://127.0.0.1:8000/search/json/${widget.gameId}');

      setState(() {
        if (allResponse is List) {
          reviews = allResponse.map((e) => Review.fromJson(e)).toList();
        }
        if (userResponse != null && userResponse.isNotEmpty) {
          userReview = Review.fromJson(userResponse);
        }
        if (gameResponse != null && gameResponse is Map<String, dynamic>) {
          game = Game.fromJson(gameResponse);
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = "Error fetching data: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryRed = Color(0xFFFF5252);
    const Color darkBlue = Color(0xFF1C1E26);
    const Color lightGray = Color(0xFFD1D1D1);
    const Color white = Colors.white;

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
                      // Panel Informasi Game
                      Card(
                        color: darkBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: primaryRed, width: 2),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              // Judul Game
                              Text(
                                game?.fields.name ?? 'Game Title',
                                style: TextStyle(
                                  color: white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 16),
                              // Informasi Game
                              Column(
                                children: [
                                  InfoRow(
                                      icon: Icons.calendar_today,
                                      label: 'Year',
                                      value:
                                          game?.fields.year.toString() ?? ''),
                                  InfoRow(
                                      icon: Icons.developer_mode,
                                      label: 'Developer',
                                      value:
                                          game?.fields.developer ?? ''),
                                  InfoRow(
                                      icon: Icons.category,
                                      label: 'Genre',
                                      value: game?.fields.genre ?? ''),
                                  InfoRow(
                                      icon: Icons.attach_money,
                                      label: 'Price',
                                      value: '\$${game?.fields.harga ?? 0}'),
                                ],
                              ),
                              SizedBox(height: 16),
                              // Deskripsi Game
                              Text(
                                game?.fields.description ??
                                    'No description available.',
                                style: TextStyle(
                                  color: lightGray,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      // Tombol 'Add Review'
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            // Implement navigation to Add Review page
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryRed,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Add Review',
                            style: TextStyle(
                              color: white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      // Bagian Ulasan ('Other Reviews')
                      Text(
                        'Other Reviews',
                        style: TextStyle(
                          color: darkBlue,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      reviews.isEmpty
                          ? Column(
                              children: [
                                Icon(Icons.mail_outline,
                                    color: lightGray, size: 80),
                                SizedBox(height: 16),
                                Text(
                                  'No reviews yet. Be the first to review!',
                                  style: TextStyle(
                                    color: lightGray,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            )
                          : Column(
                              children: reviews.map((review) {
                                return Column(
                                  children: [
                                    ReviewCard(review: review),
                                    Divider(color: primaryRed),
                                  ],
                                );
                              }).toList(),
                            ),
                    ],
                  ),
                ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    const Color lightGray = Color(0xFFD1D1D1);
    const Color white = Colors.white;
    const Color primaryRed = Color(0xFFFF5252);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: primaryRed, size: 20),
          SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              color: white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: lightGray,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  final Review review;

  const ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    const Color lightGray = Color(0xFFD1D1D1);
    const Color white = Colors.white;
    const Color primaryRed = Color(0xFFFF5252);
    const Color darkBlue = Color(0xFF1C1E26);

    return Card(
      color: darkBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: primaryRed, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Username and Score
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  review.username,
                  style: TextStyle(
                    color: white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Score: ${review.score}',
                  style: TextStyle(
                    color: primaryRed,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            // Title
            Text(
              review.title,
              style: TextStyle(
                color: white,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            // Content
            Text(
              review.content,
              style: TextStyle(
                color: lightGray,
                fontSize: 16,
              ),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 8),
            // Date
            Text(
              review.date,
              style: TextStyle(
                color: lightGray,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 8),
            // Vote Score
            Row(
              children: [
                Icon(Icons.thumb_up, color: primaryRed, size: 20),
                SizedBox(width: 4),
                Text(
                  '${review.voteScore}',
                  style: TextStyle(
                    color: lightGray,
                    fontSize: 16,
                  ),
                ),
                Spacer(),
                if (review.userUpvoted)
                  Icon(Icons.arrow_upward, color: primaryRed, size: 20),
                if (review.userDownvoted)
                  Icon(Icons.arrow_downward, color: primaryRed, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}