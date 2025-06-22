import 'package:hive/hive.dart';
import '../../models/song_model.dart';

class HiveService {
  static const _boxName = 'recent_songs';

  Future<void> saveSong(SongModel song) async {
    final box = await Hive.openBox(_boxName);
    await box.put(song.id, song.toJson());
  }

  Future<List<SongModel>> getRecentSongs() async {
    final box = await Hive.openBox(_boxName);
    return box.values.map((e) => SongModel.fromJson(Map<String, dynamic>.from(e))).toList().reversed.toList();
  }
}
