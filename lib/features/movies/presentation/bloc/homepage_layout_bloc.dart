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
  final List<HomeSliderModel> sliders;
  final List<LayoutSectionModel> sections;

  const HomepageLayoutLoaded({
    required this.sliders,
    required this.sections,
  });

  @override
  List<Object?> get props => [sliders, sections];
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
      final slidersFuture = repository.getHomeSliders();
      final layoutFuture = repository.getHomepageLayout(screenName: event.screenName);

      final results = await Future.wait([slidersFuture, layoutFuture]);
      final sliders = results[0] as List<HomeSliderModel>;
      final layout = results[1] as HomepageLayoutResponseModel;

      emit(HomepageLayoutLoaded(
        sliders: sliders,
        sections: layout.sections,
      ));
    } on AppException catch (e) {
      emit(HomepageLayoutError(e.message));
    } catch (e) {
      emit(const HomepageLayoutError('Failed to load homepage layout.'));
    }
  }
}
