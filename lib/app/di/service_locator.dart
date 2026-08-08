import 'package:shared_preferences/shared_preferences.dart';
import '../../core/network/api_client.dart';
import '../../core/storage/auth_local_storage.dart';
import '../../core/storage/device_id_service.dart';
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
import '../../features/profile/data/api/devices_api_service.dart';
import '../../features/profile/data/repositories/devices_repository.dart';
import '../../features/subscription/data/api/subscription_api_service.dart';
import '../../features/subscription/data/repositories/subscription_repository.dart';

class ServiceLocator {
  ServiceLocator._();
  static final ServiceLocator instance = ServiceLocator._();

  late final SharedPreferences sharedPreferences;
  late final AuthLocalStorage authLocalStorage;
  late final DeviceIdService deviceIdService;
  late final ApiClient apiClient;

  late final AuthApiService authApiService;
  late final AuthRepository authRepository;
  late final AuthService authService;
  late final AuthBloc authBloc;

  late final MoviesApiService moviesApiService;
  late final MoviesRepository moviesRepository;
  late final HomepageLayoutBloc homepageLayoutBloc;

  late final SubscriptionApiService subscriptionApiService;
  late final SubscriptionRepository subscriptionRepository;

  late final DevicesApiService devicesApiService;
  late final DevicesRepository devicesRepository;

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    sharedPreferences = await SharedPreferences.getInstance();
    authLocalStorage = AuthLocalStorage(sharedPreferences);
    deviceIdService = DeviceIdService(sharedPreferences);
    apiClient = ApiClient(authLocalStorage: authLocalStorage);

    // Subscription & Payments
    subscriptionApiService = SubscriptionApiService(apiClient);
    subscriptionRepository = SubscriptionRepository(subscriptionApiService: subscriptionApiService);

    // Auth
    authApiService = AuthApiService(apiClient);
    authRepository = AuthRepository(
      authApiService: authApiService,
      authLocalStorage: authLocalStorage,
      deviceIdService: deviceIdService,
      subscriptionApiService: subscriptionApiService,
    );
    authService = AuthService(authRepository);
    authBloc = AuthBloc(authService)..add(AuthCheckRequested());

    // Movies & SDUI
    moviesApiService = MoviesApiService(apiClient);
    moviesRepository = MoviesRepository(moviesApiService: moviesApiService);
    homepageLayoutBloc = HomepageLayoutBloc(moviesRepository);

    // Connected Devices
    devicesApiService = DevicesApiService(apiClient);
    devicesRepository = DevicesRepository(devicesApiService: devicesApiService);

    _initialized = true;
  }

  MovieDetailsCubit createMovieDetailsCubit() => MovieDetailsCubit(moviesRepository);
  SearchCubit createSearchCubit() => SearchCubit(moviesRepository);
}
