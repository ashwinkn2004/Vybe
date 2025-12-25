class SongModel {
  final String id;
  final String title;
  final String artist;
  final String imageUrl;

  SongModel({
    required this.id,
    required this.title,
    required this.artist,
    required this.imageUrl,
  });

  factory SongModel.fromJson(Map<String, dynamic> json) {
    return SongModel(
      id: json['id'].toString(),
      title: json['title'],
      artist: json['artist'],
      imageUrl: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'image': imageUrl,
    };
  }
}
