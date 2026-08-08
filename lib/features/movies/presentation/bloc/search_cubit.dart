import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/models/movie_models.dart';
import '../../data/repositories/movies_repository.dart';

abstract class SearchState extends Equatable {
  const SearchState();
  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<Movie> movies;

  const SearchLoaded(this.movies);

  @override
  List<Object?> get props => [movies];
}

class SearchEmpty extends SearchState {}

class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object?> get props => [message];
}

class SearchCubit extends Cubit<SearchState> {
  final MoviesRepository repository;

  SearchCubit(this.repository) : super(SearchInitial());

  Future<void> performSearch({String? query, String? genre}) async {
    if (isClosed) return;
    emit(SearchLoading());
    try {
      final results = await repository.searchMovies(q: query, genre: genre);
      if (isClosed) return;
      if (results.isEmpty) {
        emit(SearchEmpty());
      } else {
        emit(SearchLoaded(results));
      }
    } on AppException catch (e) {
      if (isClosed) return;
      emit(SearchError(e.message));
    } catch (e) {
      if (isClosed) return;
      emit(const SearchError('Search request failed.'));
    }
  }
}
