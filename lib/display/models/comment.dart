// To parse this JSON data, do
//
//     final commentEntry = commentEntryFromJson(jsonString);

import 'dart:convert';

List<CommentEntry> commentEntryFromJson(String str) => List<CommentEntry>.from(json.decode(str).map((x) => CommentEntry.fromJson(x)));

String commentEntryToJson(List<CommentEntry> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CommentEntry {
    String model;
    int pk;
    Fields fields;

    CommentEntry({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory CommentEntry.fromJson(Map<String, dynamic> json) => CommentEntry(
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

class Fields {
    String game;
    String name;
    String body;
    DateTime created;

    Fields({
        required this.game,
        required this.name,
        required this.body,
        required this.created,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        game: json["game"],
        name: json["name"],
        body: json["body"],
        created: DateTime.parse(json["created"]),
    );

    Map<String, dynamic> toJson() => {
        "game": game,
        "name": name,
        "body": body,
        "created": created.toIso8601String(),
    };
}
