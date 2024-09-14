import 'dart:convert';

class Video {
  int id;
  int count;

  Video({required this.id, required this.count});

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'],
      count: json['count'],
    );
  }

  static Map<String, dynamic> toMap(Video video) => {
        'id': video.id,
        'count': video.count,
      };

  static String encode(List<Video> videos) => json.encode(
        videos
            .map<Map<String, dynamic>>((video) => Video.toMap(video))
            .toList(),
      );

  static List<Video> decode(String videos) =>
      (json.decode(videos) as List<dynamic>)
          .map<Video>((item) => Video.fromJson(item))
          .toList();
}
