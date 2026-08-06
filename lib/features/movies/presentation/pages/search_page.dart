import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/di/service_locator.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/widgets/shimmer_loading.dart';
import '../bloc/search_cubit.dart';
import '../widgets/movie_card.dart';

class SearchPage extends StatefulWidget {
  final String? initialQuery;

  const SearchPage({super.key, this.initialQuery});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final TextEditingController _searchController;
  late final SearchCubit _searchCubit;
  String _selectedGenre = 'All';
  Timer? _debounce;

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
    _searchCubit = ServiceLocator.instance.createSearchCubit();

    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      if (_genres.contains(widget.initialQuery)) {
        _selectedGenre = widget.initialQuery!;
      }
    }
    _triggerSearch();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _searchCubit.close();
    super.dispose();
  }

  void _triggerSearch() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      _searchCubit.performSearch(
        query: _searchController.text.trim(),
        genre: _selectedGenre == 'All' ? null : _selectedGenre,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _searchCubit,
      child: Scaffold(
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
                onChanged: (_) => _triggerSearch(),
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
                            _triggerSearch();
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
                          _triggerSearch();
                        }
                      },
                    ),
                  );
                },
              ),
            ),
            AppSpacing.vGap16,
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  if (state is SearchLoading) {
                    return const SearchPageShimmer();
                  }

                  if (state is SearchError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: AppTextStyles.bodySecondary,
                      ),
                    );
                  }

                  if (state is SearchEmpty) {
                    return Center(
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
                    );
                  }

                  if (state is SearchLoaded) {
                    final movies = state.movies;
                    return GridView.builder(
                      padding: AppSpacing.h16,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.65,
                        crossAxisSpacing: AppSpacing.px14,
                        mainAxisSpacing: AppSpacing.px14,
                      ),
                      itemCount: movies.length,
                      itemBuilder: (context, index) {
                        return MovieCard(
                          movie: movies[index],
                          width: double.infinity,
                          height: double.infinity,
                        );
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
