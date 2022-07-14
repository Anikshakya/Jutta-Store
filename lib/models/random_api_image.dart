// To parse this JSON data, do
//
//     final randomImage = randomImageFromJson(jsonString);

import 'dart:convert';

List<RandomImage> randomImageFromJson(String str) => List<RandomImage>.from(
    json.decode(str).map((x) => RandomImage.fromJson(x)));

String randomImageToJson(List<RandomImage> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RandomImage {
  int albumId;
  int id;
  String title;
  String url;
  String thumbnailUrl;
  RandomImage({
    required this.albumId,
    required this.id,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
  });

  factory RandomImage.fromJson(Map<String, dynamic> json) => RandomImage(
        albumId: json["albumId"],
        id: json["id"],
        title: json["title"],
        url: json["url"],
        thumbnailUrl: json["thumbnailUrl"],
      );

  Map<String, dynamic> toJson() => {
        "albumId": albumId,
        "id": id,
        "title": title,
        "url": url,
        "thumbnailUrl": thumbnailUrl,
      };
}
