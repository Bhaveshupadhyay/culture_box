import 'package:flutter/material.dart';
import '../../../../app/theme/app_theme.dart';
import '../../data/models/movie.dart';
import '../../data/sources/mock_movies.dart';
import '../widgets/movie_card.dart';

class SearchPage extends StatefulWidget {
  final String? initialQuery;

  const SearchPage({super.key, this.initialQuery});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _searchController;
  String _selectedGenre = 'All';
  List<Movie> _filteredMovies = [];

  final List<String> _genres = [
    'All',
    'Action',
    'Adventure',
    'Comedy',
    'Crime',
    'Drama',
    'Historical',
    'Science Fiction',
    'Thriller'
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery ?? '');
    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      if (_genres.contains(widget.initialQuery)) {
        _selectedGenre = widget.initialQuery!;
      }
    }
    _applyFilters();
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      _filteredMovies = mockMovies.where((movie) {
        final matchesQuery = query.isEmpty ||
            movie.title.toLowerCase().contains(query) ||
            movie.description.toLowerCase().contains(query) ||
            movie.genres.any((g) => g.toLowerCase().contains(query));

        final matchesGenre = _selectedGenre == 'All' ||
            movie.genres.contains(_selectedGenre) ||
            (query == 'trending' && movie.isTrending);

        return matchesQuery && matchesGenre;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('SEARCH'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: AppSpacing.all16,
            child: TextField(
              controller: _searchController,
              onChanged: (_) => _applyFilters(),
              style: AppTextStyles.bodyText,
              decoration: InputDecoration(
                hintText: 'Search for movies & TV shows...',
                hintStyle: AppTextStyles.searchHint,
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white70),
                        onPressed: () {
                          _searchController.clear();
                          _applyFilters();
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.px14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.px10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(
            height: AppSpacing.px40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: AppSpacing.h16,
              itemCount: _genres.length,
              itemBuilder: (context, index) {
                final genre = _genres[index];
                final isSelected = genre == _selectedGenre;
                return Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.px8),
                  child: ChoiceChip(
                    label: Text(
                      genre,
                      style: isSelected ? AppTextStyles.chipSelected : AppTextStyles.chipUnselected,
                    ),
                    selected: isSelected,
                    selectedColor: AppColors.logoGold,
                    backgroundColor: AppColors.surface,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedGenre = genre;
                        });
                        _applyFilters();
                      }
                    },
                  ),
                );
              },
            ),
          ),
          AppSpacing.vGap16,
          Expanded(
            child: _filteredMovies.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off, size: 60, color: Colors.white30),
                        AppSpacing.vGap16,
                        Text(
                          'No movies found',
                          style: AppTextStyles.emptyStateTitle,
                        ),
                        AppSpacing.vGap8,
                        Text(
                          'Try searching for another keyword or genre',
                          style: AppTextStyles.emptyStateSubtitle,
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: AppSpacing.h16,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: AppSpacing.px14,
                      mainAxisSpacing: AppSpacing.px14,
                    ),
                    itemCount: _filteredMovies.length,
                    itemBuilder: (context, index) {
                      return MovieCard(
                        movie: _filteredMovies[index],
                        width: double.infinity,
                        height: double.infinity,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
