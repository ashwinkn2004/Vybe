
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vybe/services/jiosaavn_service.dart';
import '../models/song_model.dart';


final speedDialProvider = FutureProvider<List<SongModel>>((ref) async {
  final jioSaavnService = ref.read(jioSaavnServiceProvider);
  // Fetch trending/top hits from JioSaavn
  return await jioSaavnService.getTrendingSongs();
});
