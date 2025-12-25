import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/speed_dial_provider.dart';
import '../../../models/song_model.dart';

class SpeedDialSection extends ConsumerWidget {
  const SpeedDialSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final speedDial = ref.watch(speedDialProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Speed Dial',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        speedDial.when(
          data: (songs) => SizedBox(
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: songs.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, index) => _SongCard(song: songs[index]),
            ),
          ),
          loading: () => const CircularProgressIndicator(),
          error: (_, __) => const Text('Failed to load Speed Dial', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}

class _SongCard extends StatelessWidget {
  final SongModel song;
  const _SongCard({required this.song});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: const Color(0xFF101C3D),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.4),
            blurRadius: 25,
            spreadRadius: 1,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              song.imageUrl,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.music_note, size: 50, color: Colors.white24),
            ),
          ),
          const SizedBox(height: 8),
          Text(song.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          Text(song.artist,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}
