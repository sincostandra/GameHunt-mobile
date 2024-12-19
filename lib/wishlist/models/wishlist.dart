import 'dart:convert';
import 'package:gamehunt/models/game.dart';

List<Wishlist> wishlistFromJson(String str) =>
    List<Wishlist>.from(json.decode(str).map((x) => Wishlist.fromJson(x)));

String wishlistToJson(List<Wishlist> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Wishlist {
  String id;
  Game game;

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

class GameDetails {
  String name;
  String developer;
  String genre;
  double price;
  double ratings;

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
        price: (json["price"] as num).toDouble(),
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
