import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'app/di/service_locator.dart';
import 'app/theme/app_theme.dart';
import 'core/services/notification_service.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/movies/presentation/bloc/homepage_layout_bloc.dart';
import 'features/movies/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    if (kDebugMode) {
      await FirebaseAuth.instance.setSettings(
        appVerificationDisabledForTesting: true,
      );
    }
  } catch (e) {
    debugPrint('Firebase initialization warning: $e');
  }
  await ServiceLocator.instance.init();
  await NotificationService.instance.init();
  runApp(const CultureBoxApp());
}

class CultureBoxApp extends StatelessWidget {
  const CultureBoxApp({super.key});

  @override
  Widget build(BuildContext context) {
    final serviceLocator = ServiceLocator.instance;

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: serviceLocator.authBloc),
        BlocProvider<HomepageLayoutBloc>.value(value: serviceLocator.homepageLayoutBloc),
      ],
      child: MaterialApp(
        title: 'CultureBox TV Network',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const HomePage(),
        onGenerateRoute: (settings) {
          debugPrint('[DeepLink Route Handler] Received route: ${settings.name}');
          final routeName = settings.name ?? '';

          if (routeName.contains('payment-success') || routeName.contains('session_id')) {
            serviceLocator.authRepository.getCurrentUser().then((user) {
              serviceLocator.authBloc.add(AuthCheckRequested());
            });
          }

          return MaterialPageRoute(
            builder: (context) => const HomePage(),
            settings: settings,
          );
        },
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => const HomePage(),
            settings: settings,
          );
        },
      ),
    );
  }
}
