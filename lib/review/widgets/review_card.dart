import 'package:flutter/material.dart';
import 'package:gamehunt/review/models/review.dart';

class ReviewCard extends StatelessWidget {
  final Review review;

  const ReviewCard({super.key, required this.review});

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
        side: const BorderSide(color: primaryRed, width: 1),
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
                  style: const TextStyle(
                    color: white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Score: ${review.score}',
                  style: const TextStyle(
                    color: primaryRed,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Title
            Text(
              review.title,
              style: const TextStyle(
                color: white,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            // Content  
            Text(
              review.content,
              style: const TextStyle(
                color: lightGray,
                fontSize: 16,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 8),
            // Date
            Text(
              review.date,
              style: const TextStyle(
                color: lightGray,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            // Vote Score
            Row(
              children: [
                const Icon(Icons.thumb_up, color: primaryRed, size: 20),
                const SizedBox(width: 4),
                Text(
                  '${review.voteScore}',
                  style: const TextStyle(
                    color: lightGray,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                if (review.userUpvoted)
                  const Icon(Icons.arrow_upward, color: primaryRed, size: 20),
                if (review.userDownvoted)
                  const Icon(Icons.arrow_downward, color: primaryRed, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}