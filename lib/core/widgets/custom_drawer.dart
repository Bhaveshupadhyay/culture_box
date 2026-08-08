import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app/di/service_locator.dart';
import '../../app/theme/app_theme.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_event.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/movies/presentation/pages/home_page.dart';
import '../../features/movies/presentation/pages/search_page.dart';
import '../../features/profile/presentation/pages/devices_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/subscription/presentation/pages/choose_plan_page.dart';
import 'culturebox_logo.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = ServiceLocator.instance.authBloc;

    return BlocProvider.value(
      value: authBloc,
      child: Drawer(
        backgroundColor: AppColors.background,
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // Drawer Header Banner
              Container(
                padding: AppSpacing.all20,
                color: AppColors.darkBanner,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CultureBoxLogo(fontSize: 15),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    AppSpacing.vGap8,
                    Text(
                      'Your ultimate streaming destination for premium movies, series, and entertainment content. Watch anywhere, anytime on cultureboxtv.com',
                      style: AppTextStyles.drawerDesc,
                    ),
                  ],
                ),
              ),
              AppSpacing.vGap12,
              // Menu Items
              _buildDrawerTile(
                context,
                icon: Icons.home,
                title: 'Home',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
              ),
              _buildDrawerTile(
                context,
                icon: Icons.whatshot,
                title: 'Trending',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchPage(initialQuery: 'Trending'),
                    ),
                  );
                },
              ),
              _buildDrawerTile(
                context,
                icon: Icons.search,
                title: 'Search',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SearchPage()),
                  );
                },
              ),
              _buildDrawerTile(
                context,
                icon: Icons.card_membership,
                title: 'Start Subscription',
                isHighlight: true,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChoosePlanPage()),
                  );
                },
              ),
              _buildDrawerTile(
                context,
                icon: Icons.devices,
                title: 'Connected Devices',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DevicesPage()),
                  );
                },
              ),
              _buildDrawerTile(
                context,
                icon: Icons.person,
                title: 'Profile',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfilePage()),
                  );
                },
              ),
              _buildDrawerTile(
                context,
                icon: Icons.settings,
                title: 'Settings',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsPage()),
                  );
                },
              ),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is Authenticated) {
                    return _buildDrawerTile(
                      context,
                      icon: Icons.logout,
                      title: 'Sign Out (${state.user.email})',
                      onTap: () {
                        Navigator.pop(context);
                        authBloc.add(AuthLogoutRequested());
                      },
                    );
                  }
                  return _buildDrawerTile(
                    context,
                    icon: Icons.login,
                    title: 'Sign In / Register',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                    },
                  );
                },
              ),
              AppSpacing.vGap24,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isHighlight = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isHighlight ? AppColors.logoGold : Colors.white70,
      ),
      title: Text(
        title,
        style: isHighlight
            ? AppTextStyles.drawerTileHighlight
            : AppTextStyles.drawerTile,
      ),
      onTap: onTap,
    );
  }
}
