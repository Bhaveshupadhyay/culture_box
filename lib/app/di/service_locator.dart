import 'package:shared_preferences/shared_preferences.dart';
import '../../core/network/api_client.dart';
import '../../core/storage/auth_local_storage.dart';
import '../../features/auth/application/auth_service.dart';
import '../../features/auth/data/api/auth_api_service.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_event.dart';
import '../../features/movies/data/api/movies_api_service.dart';
import '../../features/movies/data/repositories/movies_repository.dart';
import '../../features/movies/presentation/bloc/homepage_layout_bloc.dart';
import '../../features/movies/presentation/bloc/movie_details_cubit.dart';
import '../../features/movies/presentation/bloc/search_cubit.dart';

class ServiceLocator {
  static final ServiceLocator instance = ServiceLocator._internal();
  ServiceLocator._internal();

  late final SharedPreferences sharedPreferences;
  late final AuthLocalStorage authLocalStorage;
  late final ApiClient apiClient;

  late final AuthApiService authApiService;
  late final AuthRepository authRepository;
  late final AuthService authService;
  late final AuthBloc authBloc;

  late final MoviesApiService moviesApiService;
  late final MoviesRepository moviesRepository;
  late final HomepageLayoutBloc homepageLayoutBloc;

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    sharedPreferences = await SharedPreferences.getInstance();
    authLocalStorage = AuthLocalStorage(sharedPreferences);
    apiClient = ApiClient(authLocalStorage: authLocalStorage);

    // Auth
    authApiService = AuthApiService(apiClient);
    authRepository = AuthRepository(
      authApiService: authApiService,
      authLocalStorage: authLocalStorage,
    );
    authService = AuthService(authRepository);
    authBloc = AuthBloc(authService)..add(AuthCheckRequested());

    // Movies & SDUI
    moviesApiService = MoviesApiService(apiClient);
    moviesRepository = MoviesRepository(moviesApiService: moviesApiService);
    homepageLayoutBloc = HomepageLayoutBloc(moviesRepository);

    _initialized = true;
  }

  MovieDetailsCubit createMovieDetailsCubit() => MovieDetailsCubit(moviesRepository);
  SearchCubit createSearchCubit() => SearchCubit(moviesRepository);
}
