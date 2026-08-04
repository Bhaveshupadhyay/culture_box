import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app/di/service_locator.dart';
import 'app/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/movies/presentation/bloc/homepage_layout_bloc.dart';
import 'features/movies/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ServiceLocator.instance.init();
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
      ),
    );
  }
}
