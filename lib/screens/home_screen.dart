import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vybe/screens/home/widgets/speed_dial_section.dart';

final frequentSongsProvider = Provider<List<Map<String, String>>>(
  (ref) => List.generate(20, (i) {
    final titles = [
      'Believer', 'Shortwave', 'Enemy', 'Closer', 'Starboy', 'Love Me Like You Do',
      'Faded', 'Let Her Go', 'Thunder', 'Radioactive', 'Perfect', 'Shivers',
      'Animals', 'Attention', 'Happier', 'Waves', 'Peaches', 'Blinding Lights',
      'Bad Habits', 'Stay'
    ];
    final artists = [
      'IMAGINE DRAGON', 'RYAN GRIGDRY', 'IMAGINE DRAGON', 'THE CHAINSMOKERS', 'THE WEEKND', 'ELLIE GOULDING',
      'ALAN WALKER', 'PASSENGER', 'IMAGINE DRAGON', 'IMAGINE DRAGON', 'ED SHEERAN', 'ED SHEERAN',
      'MAROON 5', 'CHARLIE PUTH', 'MARSHMELLO', 'MR. PROBZ', 'JUSTIN BIEBER', 'THE WEEKND',
      'ED SHEERAN', 'KID LAROI'
    ];
    return {'title': titles[i], 'artist': artists[i]};
  }),
);

final forgottenFavoritesProvider = Provider<List<Map<String, String>>>(
  (ref) => [
    {'title': 'Memories', 'artist': 'MAROON 5'},
    {'title': 'Photograph', 'artist': 'ED SHEERAN'},
    {'title': 'Sugar', 'artist': 'MAROON 5'},
    {'title': 'Let Me Love You', 'artist': 'JUSTIN BIEBER'},
    {'title': 'Blank Space', 'artist': 'TAYLOR SWIFT'},
  ],
);

final speedDialPageProvider = StateProvider<int>((ref) => 0);

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _pageController = PageController(viewportFraction: 1);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final frequentSongs = ref.watch(frequentSongsProvider);
    final forgottenSongs = ref.watch(forgottenFavoritesProvider);
    final currentPage = ref.watch(speedDialPageProvider);
    final totalPages = (frequentSongs.length / 6).ceil();

    return Scaffold(
      backgroundColor: const Color(0xFF091227),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Welcome\nVybe',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 2 / 1,
                  children: const [
                    _CategoryCard(title: 'New Releases'),
                    _CategoryCard(title: 'Charts'),
                    _CategoryCard(title: 'Moods & Genres'),
                    _CategoryCard(title: 'Featured Playlist'),
                  ],
                ),
                const SpeedDialSection(),

                const SizedBox(height: 24),
                const Text('Forgotten Favorites', style: _sectionTitle),
                const SizedBox(height: 12),
                SizedBox(
                  height: 200,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: forgottenSongs.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (_, index) {
                      final song = forgottenSongs[index];
                      return SongCard(
                        title: song['title']!,
                        artist: song['artist']!,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

const _sectionTitle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w600,
  color: Colors.white,
);

class _CategoryCard extends StatelessWidget {
  final String title;
  const _CategoryCard({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xFF142245),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.indigoAccent.withOpacity(0.1),
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class SongCard extends StatelessWidget {
  final String title;
  final String artist;

  const SongCard({super.key, required this.title, required this.artist});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurpleAccent.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 2,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/trial.jpg',
              fit: BoxFit.cover,
              width: 140,
              height: 140,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          artist,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}