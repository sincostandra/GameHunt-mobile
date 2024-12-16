import 'dart:convert';
import 'package:gamehunt/models/game.dart';  // Import the Game model

// Function to parse JSON into a List<Wishlist>
List<Wishlist> wishlistFromJson(String str) =>
    List<Wishlist>.from(json.decode(str).map((x) => Wishlist.fromJson(x)));

// Function to convert List<Wishlist> to JSON
String wishlistToJson(List<Wishlist> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// Main Wishlist Model
class Wishlist {
  String id;
  Game game;  // Connect to the Game model

  Wishlist({
    required this.id,
    required this.game,
  });

  factory Wishlist.fromJson(Map<String, dynamic> json) => Wishlist(
        id: json["id"],
        game: Game.fromJson(json["game"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "game": game.toJson(),
      };
}

// GameDetails Model (Fields of the Game model in Django)
class GameDetails {
  String name;
  String developer;
  String genre;
  double price;  // Changing from int to double for price
  double ratings;  // Ratings as double

  GameDetails({
    required this.name,
    required this.developer,
    required this.genre,
    required this.price,
    required this.ratings,
  });

  factory GameDetails.fromJson(Map<String, dynamic> json) => GameDetails(
        name: json["name"],
        developer: json["developer"],
        genre: json["genre"],
        price: (json["price"] as num).toDouble(),  // Ensure price is a double
        ratings: (json["ratings"] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "developer": developer,
        "genre": genre,
        "price": price,
        "ratings": ratings,
      };
}