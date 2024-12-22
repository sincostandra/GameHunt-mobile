import 'package:flutter/material.dart';
import 'package:gamehunt/review/models/review.dart';

class ReviewCard extends StatelessWidget {
  final Review review;
  final bool isAdmin;
  final String currentUsername;
  final Function(int reviewId) onDeleteReview;
  final Function(int reviewId, String voteType) onVote;

  const ReviewCard({
    super.key,
    required this.review,
    required this.isAdmin,
    required this.currentUsername,
    required this.onDeleteReview,
    required this.onVote,
  });

  Widget _buildStarRating(int score) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          Icons.star,
          size: 20,
          color: index < score ? Colors.amber : Colors.grey[400],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color lightGray = Color(0xFFD1D1D1);
    const Color white = Colors.white;
    const Color primaryRed = Color(0xFFFF5252);
    const Color darkBlue = Color(0xFF1C1E26);

    final canDelete = isAdmin || (review.username == currentUsername);
    final canVote = review.username != currentUsername;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: Card(
        elevation: 8,
        color: darkBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(
            color: primaryRed.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with username, date, and delete button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.person, color: primaryRed, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            review.username,
                            style: const TextStyle(
                              color: white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        review.date,
                        style: TextStyle(
                          color: lightGray.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  if (canDelete)
                    IconButton(
                      icon: const Icon(Icons.delete, color: primaryRed),
                      onPressed: () => onDeleteReview(review.id),
                    ),
                ],
              ),

              const SizedBox(height: 16),

              // Title with bigger font
              Text(
                review.title,
                style: const TextStyle(
                  color: white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              // Star Rating
              _buildStarRating(review.score),

              const SizedBox(height: 12),

              // Content with a more noticeable background
              Container(
                height: 100, // Fixed height
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2D3A), // Slightly lighter than darkBlue
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: lightGray.withOpacity(0.1),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Text(
                    review.content,
                    style: TextStyle(
                      color: lightGray.withOpacity(0.9),
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Move voting section to bottom right
              if (canVote)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_upward_rounded,
                        color: review.userUpvoted ? Colors.green : lightGray,
                        size: 28,
                      ),
                      onPressed: () => onVote(review.id, 'upvote'),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: darkBlue.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${review.voteScore}',
                        style: const TextStyle(
                          color: white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.arrow_downward_rounded,
                        color: review.userDownvoted ? Colors.red : lightGray,
                        size: 28,
                      ),
                      onPressed: () => onVote(review.id, 'downvote'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}