// To parse this JSON data, do:v
//
//     final review = reviewFromJson(jsonString);

import 'dart:convert';

List<Review> reviewFromJson(String str) => List<Review>.from(json.decode(str).map((x) => Review.fromJson(x)));

String reviewToJson(List<Review> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Review {
    int id;
    String username;
    String title;
    String content;
    int score;
    String date;
    int voteScore;
    bool userUpvoted;
    bool userDownvoted;

    Review({
        required this.id,
        required this.username,
        required this.title,
        required this.content,
        required this.score,
        required this.date,
        required this.voteScore,
        required this.userUpvoted,
        required this.userDownvoted,
    });

    factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["id"],
        username: json["username"],
        title: json["title"],
        content: json["content"],
        score: json["score"],
        date: json["date"],
        voteScore: json["vote_score"],
        userUpvoted: json["user_upvoted"],
        userDownvoted: json["user_downvoted"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "title": title,
        "content": content,
        "score": score,
        "date": date,
        "vote_score": voteScore,
        "user_upvoted": userUpvoted,
        "user_downvoted": userDownvoted,
    };
}
