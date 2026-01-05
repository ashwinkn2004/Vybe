
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';

import 'package:vybe/services/jiosaavn_service.dart';
import '../models/song_model.dart';

// State class for the player
class PlayerStateModel {
  final bool isPlaying;
  final SongModel? currentSong;
  final Duration position;
  final Duration duration;

  PlayerStateModel({
    this.isPlaying = false,
    this.currentSong,
    this.position = Duration.zero,
    this.duration = Duration.zero,
  });

  PlayerStateModel copyWith({
    bool? isPlaying,
    SongModel? currentSong,
    Duration? position,
    Duration? duration,
  }) {
    return PlayerStateModel(
      isPlaying: isPlaying ?? this.isPlaying,
      currentSong: currentSong ?? this.currentSong,
      position: position ?? this.position,
      duration: duration ?? this.duration,
    );
  }
}

final playerStateProvider = StateNotifierProvider<PlayerNotifier, PlayerStateModel>((ref) {
  return PlayerNotifier(ref);
});

class PlayerNotifier extends StateNotifier<PlayerStateModel> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final Ref _ref;

  PlayerNotifier(this._ref) : super(PlayerStateModel()) {
    _init();
  }

  void _init() {
    // Listen to player state properties
    _audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      if (processingState == ProcessingState.completed) {
         state = state.copyWith(isPlaying: false);
         _audioPlayer.stop(); // Ensure it stops logically
      } else {
        state = state.copyWith(isPlaying: isPlaying);
      }
    });

    _audioPlayer.positionStream.listen((pos) {
      state = state.copyWith(position: pos);
    });

    _audioPlayer.durationStream.listen((dur) {
      state = state.copyWith(duration: dur ?? Duration.zero);
    });
  }

  Future<void> playSong(SongModel song) async {
    try {
      String? url = song.audioUrl;
      

      if (url == null) {
        final jioSaavnService = _ref.read(jioSaavnServiceProvider);
        url = await jioSaavnService.getAudioUrl(song.id);
      }
      
      if (url != null) {
        // Create AudioSource with headers to avoid 403 errors
        final audioSource = AudioSource.uri(
          Uri.parse(url),
          headers: {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
          },
          tag: MediaItem(
            id: song.id,
            title: song.title,
            artist: song.artist,
            artUri: Uri.parse(song.imageUrl),
          ),
        );

        state = state.copyWith(currentSong: song); // Update UI
        await _audioPlayer.setAudioSource(audioSource);
        _audioPlayer.play();
      }
    } catch (e) {
      print("Error playing song: $e");
    }
  }

  void togglePlayPause() {
    if (_audioPlayer.playing) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
  }

  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
