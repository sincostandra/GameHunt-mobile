import 'package:flutter/material.dart';
import 'package:gamehunt/models/game.dart'; // Adjust the import according to your project structure
import 'package:gamehunt/display/widgets/overview_box.dart';
import 'package:gamehunt/display/widgets/detail_box.dart';
import 'package:gamehunt/display/widgets/store_info_box.dart';
import 'package:gamehunt/display/widgets/comment_form.dart';
import 'package:gamehunt/display/widgets/comment_section.dart';

class GameDetailPage extends StatefulWidget {
  final Game game;
  final bool isAdmin;

  const GameDetailPage({super.key, required this.game, required this.isAdmin});

  @override
  State<GameDetailPage> createState() => _GameDetailPageState();
}

class _GameDetailPageState extends State<GameDetailPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.game.fields.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            OverviewBox(game: widget.game),
            DetailBox(title: "Name", content: widget.game.fields.name), // Use the new widget
            DetailBox(title: "Description", content: widget.game.fields.description), // Use the new widget
            DetailBox(title: "Year", content: widget.game.fields.year.toString()), // Use the new widget
            DetailBox(title: "Developer", content: widget.game.fields.developer), // Use the new widget
            DetailBox(title: "Genre", content: widget.game.fields.genre), // Use the new widget
            DetailBox(title: "Ratings", content: widget.game.fields.ratings.toString()), // Use the new widget
            DetailBox(title: "Harga", content: widget.game.fields.harga.toString()), // Use the new widget
            StoreBox(storeName: widget.game.fields.toko1, address: widget.game.fields.alamat1),
            if (widget.game.fields.toko2 != null && widget.game.fields.toko2!.isNotEmpty)
              StoreBox(storeName: widget.game.fields.toko2!, address: widget.game.fields.alamat2!), // Use the new widget
            if (widget.game.fields.toko3 != null && widget.game.fields.toko3!.isNotEmpty)
              StoreBox(storeName: widget.game.fields.toko3!, address: widget.game.fields.alamat3!), // Use the new widget
            const SizedBox(height: 16),
            CommentForm(game: widget.game, isAdmin: widget.isAdmin),
            const SizedBox(height: 16),
            CommentSection(game: widget.game, isAdmin: widget.isAdmin), // Use the new widget
          ],
        ),
      ),
    );
  }
}