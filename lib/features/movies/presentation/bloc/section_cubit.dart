import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/models/movie_models.dart';
import '../../data/repositories/movies_repository.dart';

abstract class SectionState extends Equatable {
  const SectionState();
  @override
  List<Object?> get props => [];
}

class SectionInitial extends SectionState {}

class SectionLoading extends SectionState {}

class SectionLoaded extends SectionState {
  final List<Movie> movies;

  const SectionLoaded(this.movies);

  @override
  List<Object?> get props => [movies];
}

class SectionEmpty extends SectionState {}

class SectionError extends SectionState {
  final String message;

  const SectionError(this.message);

  @override
  List<Object?> get props => [message];
}

class SectionCubit extends Cubit<SectionState> {
  final MoviesRepository repository;

  SectionCubit(this.repository) : super(SectionInitial());

  Future<void> fetchSectionData(String endpointOrSectionId) async {
    emit(SectionLoading());
    try {
      final movies = await repository.getSectionData(endpointOrSectionId);
      if (movies.isEmpty) {
        emit(SectionEmpty());
      } else {
        emit(SectionLoaded(movies));
      }
    } on AppException catch (e) {
      emit(SectionError(e.message));
    } catch (e) {
      emit(const SectionError('Failed to load section content.'));
    }
  }
}
