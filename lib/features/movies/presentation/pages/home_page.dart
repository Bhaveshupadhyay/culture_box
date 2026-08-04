import 'package:flutter/material.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/widgets/culturebox_logo.dart';
import '../../../../core/widgets/custom_drawer.dart';
import '../../data/sources/mock_movies.dart';
import '../widgets/hero_carousel.dart';
import '../widgets/movie_section.dart';
import 'search_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final heroMovies = mockMovies.where((m) => m.isOriginal || m.isTrending).toList();
    final originals = mockMovies.where((m) => m.isOriginal).toList();
    final popular = mockMovies.where((m) => m.isPopular).toList();
    final topRated = mockMovies.where((m) => m.isTopRated).toList();
    final nowPlaying = mockMovies.where((m) => m.isNowPlaying).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const CultureBoxLogo(),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchPage()),
              );
            },
          ),
          AppSpacing.hGap8,
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeroCarousel(movies: heroMovies),
            MovieSection(
              title: 'CULTURE BOX TV NETWORK ORIGINALS',
              movies: originals,
            ),
            MovieSection(
              title: 'POPULAR MOVIES',
              movies: popular,
            ),
            MovieSection(
              title: 'TOP RATED',
              movies: topRated,
            ),
            MovieSection(
              title: 'NOW PLAYING',
              movies: nowPlaying,
            ),
            AppSpacing.vGap30,
          ],
        ),
      ),
    );
  }
}
