import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vybe/services/jiosaavn_service.dart';
import 'package:vybe/models/song_model.dart';
import 'package:vybe/providers/audio_player_provider.dart';
import 'package:vybe/providers/speed_dial_provider.dart';
import 'package:vybe/screens/home/widgets/mini_player.dart';

final forgottenFavoritesProvider = FutureProvider<List<SongModel>>((ref) async {
  final jioSaavnService = ref.read(jioSaavnServiceProvider);
  return await jioSaavnService.getForgottenFavorites();
});

final newReleasesProvider = FutureProvider<List<SongModel>>((ref) async {
  final jioSaavnService = ref.read(jioSaavnServiceProvider);
  return await jioSaavnService.getNewReleases();
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF091227),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 120), // Space for MiniPlayer
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const _HeaderActions(),
                  const SizedBox(height: 16),
                  const _GreetingHeader(),
                  const SizedBox(height: 16),
                  const _ShortcutsGrid(),
                  const SizedBox(height: 32),
                  
                  // New Releases Section
                  _SectionBuilder(
                    title: "New Releases",
                    provider: newReleasesProvider,
                  ),
                  const SizedBox(height: 24),
                  
                   // Trending / Speed Dial Section
                  _SectionBuilder(
                    title: "Trending Now",
                    provider: speedDialProvider,
                  ),
                  const SizedBox(height: 24),

                  // Forgotten Favorites Section
                  _SectionBuilder(
                    title: "Forgotten Favorites",
                    provider: forgottenFavoritesProvider,
                  ),
                ],
              ),
            ),
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: MiniPlayer(),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderActions extends ConsumerWidget {
  const _HeaderActions();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
           // Brand / Logo or Title
           const Text(
             "Vybe",
             style: TextStyle(
               color: Colors.white,
               fontSize: 24,
               fontWeight: FontWeight.bold,
               fontFamily: 'Poppins', 
             ),
           ),
           Row(
             children: [
               IconButton(
                 icon: const Icon(Icons.notifications_none, color: Colors.white),
                 onPressed: () {},
               ),
               IconButton(
                 icon: const Icon(Icons.history, color: Colors.white),
                 onPressed: () {},
               ),
               IconButton(
                 icon: const Icon(Icons.settings_outlined, color: Colors.white),
                 onPressed: () {},
               ),
               IconButton(
                 icon: const Icon(Icons.search, color: Colors.white),
                 onPressed: () {
                     showSearch(context: context, delegate: SongSearchDelegate(ref));
                 },
               ),
             ],
           )
        ],
      ),
    );
  }
}

class _GreetingHeader extends StatelessWidget {
  const _GreetingHeader();

  String getgreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        getgreeting(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _ShortcutsGrid extends StatelessWidget {
  const _ShortcutsGrid();

  @override
  Widget build(BuildContext context) {
    // Static placeholders for "Spotify-like" shortcuts
    final shortcuts = [
      {'title': 'Liked Songs', 'color': Colors.indigoAccent},
      {'title': 'On Repeat', 'color': Colors.purpleAccent},
      {'title': 'Gym Vibes', 'color': Colors.redAccent},
      {'title': 'Chill Mix', 'color': Colors.teal},
      {'title': 'Focus Flow', 'color': Colors.blueGrey},
      {'title': 'Discover', 'color': Colors.orangeAccent},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3, // Rectangular shape like Spotify
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: shortcuts.length,
        itemBuilder: (context, index) {
          final item = shortcuts[index];
          return Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.07),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                 Container(
                   width: 50,
                   decoration: BoxDecoration(
                     color: (item['color'] as Color).withOpacity(0.8),
                     borderRadius: const BorderRadius.only(
                       topLeft: Radius.circular(4),
                       bottomLeft: Radius.circular(4),
                     ),
                   ),
                   child: const Center(
                     child: Icon(Icons.music_note, color: Colors.white70),
                   ),
                 ),
                 Expanded(
                   child: Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
                     child: Text(
                       item['title'] as String,
                       style: const TextStyle(
                         color: Colors.white,
                         fontSize: 13,
                         fontWeight: FontWeight.w600,
                       ),
                       maxLines: 2,
                       overflow: TextOverflow.ellipsis,
                     ),
                   ),
                 )
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SectionBuilder extends ConsumerWidget {
  final String title;
  final FutureProvider<List<SongModel>> provider;

  const _SectionBuilder({
    required this.title,
    required this.provider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(provider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180, // Height for image + text
          child: asyncValue.when(
            data: (songs) => ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: songs.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (_, index) {
                final song = songs[index];
                return GestureDetector(
                  onTap: () => ref.read(playerStateProvider.notifier).playSong(song),
                  child: _SpotifySongCard(song: song),
                );
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text("Err: $err", style: const TextStyle(color: Colors.red)),
            ),
          ),
        ),
      ],
    );
  }
}

class _SpotifySongCard extends StatelessWidget {
  final SongModel song;
  const _SpotifySongCard({required this.song});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
                shape: BoxShape.rectangle, // Spotify uses square art usually, or slightly rounded
                // Using slightly rounded for better aesthetic
              ),
              child: Image.network(
                song.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.music_note, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            song.title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            song.artist,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// Reusing existing SearchDelegate
class SongSearchDelegate extends SearchDelegate {
  final WidgetRef ref;
  SongSearchDelegate(this.ref);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      scaffoldBackgroundColor: const Color(0xFF091227),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF091227),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: Colors.white),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white54),
        border: InputBorder.none,
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(icon: const Icon(Icons.clear, color: Colors.white), onPressed: () => query = '')
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) return const SizedBox();

    final jioSaavnService = ref.read(jioSaavnServiceProvider);
    
    return FutureBuilder(
      future: jioSaavnService.searchSongs(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
        }
        final songs = snapshot.data as List<SongModel>? ?? [];
        
        return ListView.builder(
          itemCount: songs.length,
          itemBuilder: (context, index) {
            final song = songs[index];
            return ListTile(
              leading: Image.network(song.imageUrl, width: 40, height: 40, fit: BoxFit.cover),
              title: Text(song.title, style: const TextStyle(color: Colors.white)),
              subtitle: Text(song.artist, style: const TextStyle(color: Colors.grey)),
              onTap: () {
                ref.read(playerStateProvider.notifier).playSong(song);
                close(context, null);
              },
            );
          },
        );
      },
    );
  }
}
