import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/models/layout_models.dart';
import '../../data/repositories/movies_repository.dart';

abstract class HomepageLayoutEvent extends Equatable {
  const HomepageLayoutEvent();
  @override
  List<Object?> get props => [];
}

class FetchHomepageLayout extends HomepageLayoutEvent {
  final String screenName;
  const FetchHomepageLayout({this.screenName = 'default'});
  @override
  List<Object?> get props => [screenName];
}

abstract class HomepageLayoutState extends Equatable {
  const HomepageLayoutState();
  @override
  List<Object?> get props => [];
}

class HomepageLayoutInitial extends HomepageLayoutState {}

class HomepageLayoutLoading extends HomepageLayoutState {}

class HomepageLayoutLoaded extends HomepageLayoutState {
  final List<LayoutSectionModel> sections;

  const HomepageLayoutLoaded(this.sections);

  @override
  List<Object?> get props => [sections];
}

class HomepageLayoutError extends HomepageLayoutState {
  final String message;

  const HomepageLayoutError(this.message);

  @override
  List<Object?> get props => [message];
}

class HomepageLayoutBloc extends Bloc<HomepageLayoutEvent, HomepageLayoutState> {
  final MoviesRepository repository;

  HomepageLayoutBloc(this.repository) : super(HomepageLayoutInitial()) {
    on<FetchHomepageLayout>(_onFetchHomepageLayout);
  }

  Future<void> _onFetchHomepageLayout(
    FetchHomepageLayout event,
    Emitter<HomepageLayoutState> emit,
  ) async {
    emit(HomepageLayoutLoading());
    try {
      final layout = await repository.getHomepageLayout(screenName: event.screenName);
      if (layout.sections.isEmpty) {
        emit(const HomepageLayoutError('No sections found.'));
      } else {
        emit(HomepageLayoutLoaded(layout.sections));
      }
    } on AppException catch (e) {
      emit(HomepageLayoutError(e.message));
    } catch (e) {
      emit(const HomepageLayoutError('Failed to load homepage layout.'));
    }
  }
}
