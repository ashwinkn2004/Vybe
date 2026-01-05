class SongModel {
  final String id;
  final String title;
  final String artist;
  final String imageUrl;
  final String? audioUrl;

  SongModel({
    required this.id,
    required this.title,
    required this.artist,
    required this.imageUrl,
    this.audioUrl,
  });

  factory SongModel.fromVideo(dynamic video) {
    // Handling generic map or YoutubeExplode Video object manually if passed as map
    return SongModel(
      id: video['id'],
      title: video['title'],
      artist: video['artist'],
      imageUrl: video['image'],
      audioUrl: video['audioUrl'],
    );
  }
  
  // Generic fromJson for other uses if needed
  factory SongModel.fromJson(Map<String, dynamic> json) {
    return SongModel(
      id: json['id'].toString(),
      title: json['title'] ?? 'Unknown',
      artist: json['artist'] ?? 'Unknown',
      imageUrl: json['image'] ?? '',
      audioUrl: json['audioUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'image': imageUrl,
      'audioUrl': audioUrl,
    };
  }
}
