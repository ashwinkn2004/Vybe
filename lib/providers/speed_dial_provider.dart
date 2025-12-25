import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/speed_dial_controller.dart';
import '../models/song_model.dart';

final speedDialProvider = FutureProvider<List<SongModel>>((ref) async {
  final controller = SpeedDialController();
  return await controller.getSpeedDialSongs();
});
