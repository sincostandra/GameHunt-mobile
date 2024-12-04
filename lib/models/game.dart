// To parse this JSON data, do
//
//     final game = gameFromJson(jsonString);

import 'dart:convert';

// Fungsi untuk mem-parsing JSON menjadi List<Game>
List<Game> gameFromJson(String str) =>
    List<Game>.from(json.decode(str).map((x) => Game.fromJson(x)));

// Fungsi untuk mengubah List<Game> menjadi JSON
String gameToJson(List<Game> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// Model utama Game
class Game {
  String model;
  String pk;
  Fields fields;

  Game({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Game.fromJson(Map<String, dynamic> json) => Game(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
      );

  Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
      };
}

// Model Fields
class Fields {
  String name;
  int year;
  String description;
  String developer;
  String genre;
  double ratings;
  int harga;
  String toko1;
  String alamat1;
  String? toko2;
  String? alamat2;
  String? toko3;
  String? alamat3;

  Fields({
    required this.name,
    required this.year,
    required this.description,
    required this.developer,
    required this.genre,
    required this.ratings,
    required this.harga,
    required this.toko1,
    required this.alamat1,
    this.toko2,
    this.alamat2,
    this.toko3,
    this.alamat3,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        name: json["name"],
        year: json["year"],
        description: json["description"],
        developer: json["developer"],
        genre: json["genre"],
        ratings: json["ratings"]?.toDouble(),
        harga: json["harga"],
        toko1: json["toko1"], // String bebas
        alamat1: json["alamat1"],
        toko2: json["toko2"], // Nullable string
        alamat2: json["alamat2"],
        toko3: json["toko3"],
        alamat3: json["alamat3"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "year": year,
        "description": description,
        "developer": developer,
        "genre": genre,
        "ratings": ratings,
        "harga": harga,
        "toko1": toko1,
        "alamat1": alamat1,
        "toko2": toko2,
        "alamat2": alamat2,
        "toko3": toko3,
        "alamat3": alamat3,
      };
}
