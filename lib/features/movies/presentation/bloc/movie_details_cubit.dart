import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/models/movie_models.dart';
import '../../data/repositories/movies_repository.dart';

abstract class MovieDetailsState extends Equatable {
  const MovieDetailsState();
  @override
  List<Object?> get props => [];
}

class MovieDetailsInitial extends MovieDetailsState {}

class MovieDetailsLoading extends MovieDetailsState {}

class MovieDetailsLoaded extends MovieDetailsState {
  final Movie movie;
  final String trailerUrl;
  final String videoUrl;
  final List<Movie> relatedMovies;

  const MovieDetailsLoaded({
    required this.movie,
    required this.trailerUrl,
    required this.videoUrl,
    this.relatedMovies = const [],
  });

  @override
  List<Object?> get props => [movie, trailerUrl, videoUrl, relatedMovies];
}

class MovieDetailsError extends MovieDetailsState {
  final String message;

  const MovieDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}

class MovieDetailsCubit extends Cubit<MovieDetailsState> {
  final MoviesRepository repository;

  MovieDetailsCubit(this.repository) : super(MovieDetailsInitial());

  Future<void> fetchMovieDetails(String movieId) async {
    emit(MovieDetailsLoading());
    try {
      final fullMovie = await repository.getMovieDetails(movieId);
      final intId = int.tryParse(movieId) ?? 0;

      // Concurrently fetch video & trailer asset URLs and recommended content via GET /users/content/{id}/recommended
      final trailerUrlFuture = repository.getMovieVideoUrl(movieId, isTrailer: true);
      final videoUrlFuture = repository.getMovieVideoUrl(movieId, isTrailer: false);
      final relatedFuture = repository.getRecommendedContent(intId);

      final results = await Future.wait([
        trailerUrlFuture,
        videoUrlFuture,
        relatedFuture,
      ]);

      final trailerUrl = results[0] as String;
      final videoUrl = results[1] as String;
      final related = results[2] as List<Movie>;
      final filteredRelated = related.where((m) => m.id != fullMovie.id).take(6).toList();

      emit(MovieDetailsLoaded(
        movie: fullMovie,
        trailerUrl: trailerUrl,
        videoUrl: videoUrl,
        relatedMovies: filteredRelated,
      ));
    } on AppException catch (e) {
      emit(MovieDetailsError(e.message));
    } catch (e) {
      emit(const MovieDetailsError('Failed to load movie details.'));
    }
  }
}
