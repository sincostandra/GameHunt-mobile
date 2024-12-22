import 'package:flutter/material.dart';
import 'package:gamehunt/models/game.dart';
import 'package:gamehunt/review/models/review.dart';
import 'package:gamehunt/review/widgets/game_info_card.dart';
import 'package:gamehunt/review/widgets/review_card.dart';
import 'package:gamehunt/review/screens/add_review.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
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

  // Ambil role user + username
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

  // Ambil data game, review semua user, review user saat ini
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
        error = null;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  // Hapus review dengan “optimistic update”
  Future<void> _deleteReview(int reviewId) async {
    final request = context.read<CookieRequest>();

    // Temukan review yang akan dihapus
    final toDeleteIndex = reviews.indexWhere((r) => r.id == reviewId);
    final isUserReview = (userReview != null && userReview!.id == reviewId);

    // Simpan data review lama untuk revert jika gagal
    final Review? oldUserReview = userReview;
    final List<Review> oldReviews = List.from(reviews);

    // Hilangkan dari state terlebih dahulu (optimistic)
    setState(() {
      if (isUserReview) {
        userReview = null;
      } else if (toDeleteIndex >= 0) {
        reviews.removeAt(toDeleteIndex);
      }
    });

    // Panggil API untuk hapus di server
    try {
      final response = await request.post(
        'https://utandra-nur-gamehunts.pbp.cs.ui.ac.id/review/delete_review_flutter/$reviewId/',
        {},
      );

      if (response['status'] != 'success') {
        // Jika gagal, kembalikan keadaan seperti semula
        setState(() {
          userReview = oldUserReview;
          reviews = oldReviews;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Failed to delete review.')),
        );
      }
    } catch (e) {
      // Jika error, revert
      setState(() {
        userReview = oldUserReview;
        reviews = oldReviews;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting review: $e')),
      );
    }
  }

  // Voting dengan “optimistic update”
  Future<void> _voteReview(int reviewId, String voteType) async {
    final request = context.read<CookieRequest>();

    // Cari review di reviews atau userReview
    Review? foundReview;
    final idx = reviews.indexWhere((r) => r.id == reviewId);
    if (idx != -1) {
      foundReview = reviews[idx];
    } else if (userReview != null && userReview!.id == reviewId) {
      foundReview = userReview;
    }
    if (foundReview == null) return; // Tidak ketemu

    // Simpan state lama
    final bool oldUpvoted = foundReview.userUpvoted;
    final bool oldDownvoted = foundReview.userDownvoted;
    final int oldScore = foundReview.voteScore;

    // Optimistic update
    setState(() {
      if (voteType == 'upvote') {
        if (!foundReview!.userUpvoted) {
          foundReview.userUpvoted = true;
          foundReview.voteScore++;
          // Jika sebelumnya downvoted
          if (oldDownvoted) {
            foundReview.userDownvoted = false;
            foundReview.voteScore++;
          }
        } else {
          // Batalkan upvote
          foundReview.userUpvoted = false;
          foundReview.voteScore--;
        }
      } else {
        // downvote
        if (!foundReview!.userDownvoted) {
          foundReview.userDownvoted = true;
          foundReview.voteScore--;
          // Jika sebelumnya upvoted
          if (oldUpvoted) {
            foundReview.userUpvoted = false;
            foundReview.voteScore--;
          }
        } else {
          // Batalkan downvote
          foundReview.userDownvoted = false;
          foundReview.voteScore++;
        }
      }
    });

    // Panggil API
    try {
      final response = await request.post(
        'https://utandra-nur-gamehunts.pbp.cs.ui.ac.id/review/vote_flutter/',
        {
          'review_id': reviewId.toString(),
          'vote_type': voteType,
        },
      );

      if (response['status'] != 'success') {
        // Jika server tolak, revert
        setState(() {
          foundReview!.userUpvoted = oldUpvoted;
          foundReview.userDownvoted = oldDownvoted;
          foundReview.voteScore = oldScore;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Failed to vote.')),
        );
      }
    } catch (e) {
      // Error, revert
      setState(() {
        foundReview!.userUpvoted = oldUpvoted;
        foundReview.userDownvoted = oldDownvoted;
        foundReview.voteScore = oldScore;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error voting: $e')),
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
                      // Info game
                      if (game != null) GameInfoCard(game: game!),
                      const SizedBox(height: 24),

                      // User's own review
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
                                onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AddReviewPage(gameId: widget.gameId),
                                    ),
                                  );
                                  // Jika berhasil tambah, panggil fetchData
                                  if (result == true) {
                                    fetchData();
                                  }
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
                                  style: TextStyle(color: Colors.white, fontSize: 16),
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
                                  onVote: _voteReview,
                                ),
                                const Divider(color: primaryRed),
                              ],
                            ),
                      const SizedBox(height: 24),

                      // Other Reviews
                      const Text(
                        'Other Reviews',
                        style: TextStyle(
                          color: darkBlue,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      reviews
                              .where((r) => userReview == null || r.id != userReview!.id)
                              .isEmpty
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
                                  .where((r) => userReview == null || r.id != userReview!.id)
                                  .map((review) => Column(
                                        children: [
                                          ReviewCard(
                                            review: review,
                                            isAdmin: isAdmin,
                                            currentUsername: currentUsername,
                                            onDeleteReview: _deleteReview,
                                            onVote: _voteReview,
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