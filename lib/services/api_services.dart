import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/song_model.dart';

class ApiService {
  Future<List<SongModel>> fetchTrendingSongs() async {
    final res = await http.get(Uri.parse('https://saavn.dev/api/search/songs?query=Believer'));
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      final List trending = data['data'] ?? [];
      return trending.map((e) => SongModel.fromJson({
        'id': e['id'],
        'title': e['name'],
        'artist': e['primaryArtists'],
        'image': e['image'][2]['link'], // 320px image
      })).toList();
    } else {
      throw Exception('Failed to load trending songs');
    }
  }
}
