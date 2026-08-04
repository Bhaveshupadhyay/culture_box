import '../models/movie.dart';
import '../sources/mock_movies.dart';

abstract class MoviesRepository {
  Future<List<Movie>> getAllMovies();
  Future<List<Movie>> getOriginals();
  Future<List<Movie>> getPopularMovies();
  Future<List<Movie>> getTopRatedMovies();
  Future<List<Movie>> getNowPlayingMovies();
  Future<List<Movie>> searchMovies(String query, {String? genre});
}

class MockMoviesRepository implements MoviesRepository {
  final List<Movie> _movies;

  MockMoviesRepository({List<Movie>? movies}) : _movies = movies ?? mockMovies;

  @override
  Future<List<Movie>> getAllMovies() async {
    return _movies;
  }

  @override
  Future<List<Movie>> getOriginals() async {
    return _movies.where((m) => m.isOriginal).toList();
  }

  @override
  Future<List<Movie>> getPopularMovies() async {
    return _movies.where((m) => m.isPopular).toList();
  }

  @override
  Future<List<Movie>> getTopRatedMovies() async {
    return _movies.where((m) => m.isTopRated).toList();
  }

  @override
  Future<List<Movie>> getNowPlayingMovies() async {
    return _movies.where((m) => m.isNowPlaying).toList();
  }

  @override
  Future<List<Movie>> searchMovies(String query, {String? genre}) async {
    final cleanQuery = query.toLowerCase().trim();
    return _movies.where((movie) {
      final matchesQuery = cleanQuery.isEmpty ||
          movie.title.toLowerCase().contains(cleanQuery) ||
          movie.description.toLowerCase().contains(cleanQuery) ||
          movie.genres.any((g) => g.toLowerCase().contains(cleanQuery));

      final matchesGenre = genre == null ||
          genre == 'All' ||
          movie.genres.contains(genre) ||
          (cleanQuery == 'trending' && movie.isTrending);

      return matchesQuery && matchesGenre;
    }).toList();
  }
}
