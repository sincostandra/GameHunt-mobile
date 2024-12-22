import 'package:flutter/material.dart';
import 'package:gamehunt/models/game.dart';

class GameInfoCard extends StatelessWidget {
  final Game game;

  const GameInfoCard({super.key, required this.game});

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
            Text(
              game?.fields.name ?? 'Game Title',
              style: const TextStyle(
                color: white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              game?.fields.description ?? 'No description available.',
              style: const TextStyle(
                color: lightGray,
                fontSize: 16,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.calendar_today, 'Year', '${game?.fields.year ?? "N/A"}'),
            _buildInfoRow(Icons.developer_mode, 'Developer', game?.fields.developer ?? "N/A"),
            _buildInfoRow(Icons.category, 'Genre', game?.fields.genre ?? "N/A"),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFFF5252), size: 20),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFFD1D1D1),
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}