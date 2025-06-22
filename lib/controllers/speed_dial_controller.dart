import '../../models/song_model.dart';
import '../../services/hive_serviceS.dart';
import '../../services/api_serviceS.dart';

class SpeedDialController {
  final _hive = HiveService();
  final _api = ApiService();

  Future<List<SongModel>> getSpeedDialSongs() async {
    final localSongs = await _hive.getRecentSongs();
    if (localSongs.isNotEmpty) return localSongs;
    return await _api.fetchTrendingSongs();
  }
}
