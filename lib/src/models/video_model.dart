// To parse this JSON data, do
//
//     final video = videoFromJson(jsonString);

import 'dart:convert';

Video videoFromJson(String str) => Video.fromJson(json.decode(str));

String videoToJson(Video data) => json.encode(data.toJson());

class Video {
  String? userName;
  String? videoDate;
  String? videoName;
  String? videoUrl;
  String? videoDescription;

  Video({
    this.userName,
    this.videoDate,
    this.videoName,
    this.videoUrl,
    this.videoDescription,
  });
  
  factory Video.created() =>
      Video(videoDate: DateTime.now().toString());

  factory Video.fromJson(Map<String, dynamic> json) => Video(
        userName: json["user_name"],
        videoDate: json["video_date"],
        videoName: json["video_name"],
        videoUrl: json["video_url"],
        videoDescription: json["video_description"],
      );

  Map<String, dynamic> toJson() => {
        "user_name": userName,
        "video_date": videoDate,
        "video_name": videoName,
        "video_url": videoUrl,
        "video_description": videoDescription,
      };
}
