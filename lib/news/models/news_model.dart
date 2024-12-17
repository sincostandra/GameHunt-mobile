// To parse this JSON data, do
//
//     final news = newsFromJson(jsonString);

import 'dart:convert';

List<News> newsFromJson(String str) => List<News>.from(json.decode(str).map((x) => News.fromJson(x)));

String newsToJson(List<News> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class News {
    Model model;
    String pk;
    Fields fields;

    News({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory News.fromJson(Map<String, dynamic> json) => News(
        model: modelValues.map[json["model"]]!,
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": modelValues.reverse[model],
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    String title;
    String article;
    String author;
    // DateTime postDate;
    DateTime updateDate;

    Fields({
        required this.title,
        required this.article,
        required this.author,
        // required this.postDate,
        required this.updateDate,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        title: json["title"],
        article: json["article"],
        author: json["author"],
        // postDate: DateTime.parse(json["post_date"]),
        updateDate: DateTime.parse(json["update_date"]),
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "article": article,
        "author": author,
        // "post_date": postDate.toIso8601String(),
        "update_date": updateDate.toIso8601String(),
    };
}

enum Model {
    newsNEWS
}

final modelValues = EnumValues({
    "news.news": Model.newsNEWS
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
