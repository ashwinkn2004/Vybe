
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/song_model.dart';

final jioSaavnServiceProvider = Provider((ref) => JioSaavnService());

class JioSaavnService {
  final String _baseUrl = "https://saavn.sumit.co";

  /// Search for songs
  Future<List<SongModel>> searchSongs(String query) async {
    try {
      // usage of 'language' param to broaden results
      const allLanguages = "english,hindi,punjabi,tamil,telugu,marathi,gujarati,bengali,kannada,bhojpuri,malayalam,urdu,haryanvi,rajasthani,odia,assamese";
      final response = await http.get(Uri.parse('$_baseUrl/api/search/songs?query=$query&page=1&limit=20&language=$allLanguages'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // API returns { "success": true, "data": { "results": [...] } }
        if (data['success'] == true && data['data'] != null && data['data']['results'] != null) {
          final List<dynamic> results = data['data']['results'];
          return results.map((song) => _mapToSongModel(song)).toList();
        }
      } else {
        print('JioSaavn Search Error: ${response.statusCode} ${response.body}');
      }
      return [];
    } catch (e) {
      print('Error searching JioSaavn: $e');
      return [];
    }
  }

  /// Get Trending/Top songs
  Future<List<SongModel>> getTrendingSongs() async {
    try {
      // Trying /api/modules
      const allLanguages = "english,hindi,punjabi,tamil,telugu,marathi,gujarati,bengali,kannada,bhojpuri,malayalam,urdu,haryanvi,rajasthani,odia,assamese";
      final response = await http.get(Uri.parse('$_baseUrl/api/modules?language=$allLanguages'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
           final trending = data['data']['trending'];
           if (trending != null && trending['songs'] != null) {
             final List<dynamic> songs = trending['songs'];
             return songs.map((song) => _mapToSongModel(song)).toList();
           }
        }
      } else {
         print('JioSaavn Trending Error: ${response.statusCode} ${response.body}');
      }
      // Fallback
      return await searchSongs("Top Global Hits");
    } catch (e) {
      print('Error getting trending: $e');
      return [];
    }
  }

  /// Get song details (audio URL)
  Future<String?> getAudioUrl(String songId) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/api/songs?id=$songId'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
         if (data['success'] == true && data['data'] != null) {
           // data['data'] is usually a list for this endpoint
           final songData = (data['data'] is List && (data['data'] as List).isNotEmpty) 
               ? data['data'][0] 
               : data['data']; 
               
           return _extractAudioUrl(songData);
         }
      } else {
        print('JioSaavn Audio URL Error: ${response.statusCode} ${response.body}');
      }
      return null;
    } catch (e) {
      print('Error getting audio URL: $e');
      return null;
    }
  }

  /// Helper to map response to SongModel
  SongModel _mapToSongModel(dynamic data) {
    String imageUrl = '';
    if (data['image'] != null && data['image'] is List && (data['image'] as List).isNotEmpty) {
      // API uses 'url' for image links often, sometimes 'link'. New API seems to use 'url'.
      // Based on previous search result: "image": [{"quality":"...", "url":"..."}]
      imageUrl = (data['image'] as List).last['url'];
    }
    
    // Artist handling
    // Generic helper to extract artist string
    String artist = 'Unknown';

    if (data['primaryArtists'] != null) {
      if (data['primaryArtists'] is String) {
         artist = data['primaryArtists'];
      } else if (data['primaryArtists'] is List) {
         final List list = data['primaryArtists'];
         if (list.isNotEmpty) {
           if (list.first is String) {
             artist = list.join(', ');
           } else if (list.first is Map) {
             artist = list.map((e) => e['name'].toString()).join(', ');
           }
         }
      }
    }
    
    // Fallback if still unknown or empty
    if (artist == 'Unknown' || artist.isEmpty) {
       if (data['singers'] != null) {
          if (data['singers'] is String) artist = data['singers'];
          if (data['singers'] is List) artist = (data['singers'] as List).join(', '); // classic saavn result
       } else if (data['artists'] != null) {
          // artists: { primary: [...], featured: [...] } or just [...]
          if (data['artists'] is Map && data['artists']['primary'] is List) {
             final List primary = data['artists']['primary'];
             if (primary.isNotEmpty) artist = primary.map((e) => e['name'].toString()).join(', ');
          }
       }
    }

    String? audioUrl = _extractAudioUrl(data);

    return SongModel(
      id: data['id'],
      title: data['name'] ?? 'Unknown',
      artist: artist,
      imageUrl: imageUrl,
      audioUrl: audioUrl,
    );
  }

  Future<List<SongModel>> getForgottenFavorites() async {
    return await searchSongs("Throwback hits 2010s english");
  }

  Future<List<SongModel>> getNewReleases() async {
    return await searchSongs("Latest English songs 2024");
  }

  String? _extractAudioUrl(dynamic data) {
    if (data['downloadUrl'] != null && data['downloadUrl'] is List && (data['downloadUrl'] as List).isNotEmpty) {
      final urls = data['downloadUrl'] as List;
      // Structure: { "quality": "320kbps", "url": "..." }
      var best = urls.firstWhere((e) => e['quality'] == '320kbps', orElse: () => 
          urls.firstWhere((e) => e['quality'] == '160kbps', orElse: () => urls.last)
      );
      return best['url'];
    }
    return null;
  }
}
