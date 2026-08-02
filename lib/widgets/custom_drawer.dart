import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../screens/home_screen.dart';
import '../screens/search_screen.dart';
import '../screens/choose_plan_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/settings_screen.dart';
import 'culturebox_logo.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
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
                    builder: (context) =>
                        const SearchScreen(initialQuery: 'Trending'),
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
                  MaterialPageRoute(builder: (context) => const SearchScreen()),
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
                  MaterialPageRoute(
                      builder: (context) => const ChoosePlanScreen()),
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
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
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
                  MaterialPageRoute(
                      builder: (context) => const SettingsScreen()),
                );
              },
            ),
            const Divider(color: Colors.white12, height: AppSpacing.px32),
            // Genres Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.px16, vertical: AppSpacing.px8),
              child: Text(
                'BROWSE BY GENRE',
                style: AppTextStyles.sectionHeaderSmall,
              ),
            ),
            Wrap(
              spacing: AppSpacing.px8,
              runSpacing: AppSpacing.px8,
              children: [
                'Action',
                'Adventure',
                'Comedy',
                'Crime',
                'Drama',
                'Fantasy',
                'Horror',
                'Romance',
                'Science Fiction',
                'Thriller'
              ].map((genre) {
                return Padding(
                  padding: const EdgeInsets.only(left: AppSpacing.px16),
                  child: FilterChip(
                    label: Text(
                      genre,
                      style: AppTextStyles.bodySmall,
                    ),
                    backgroundColor: AppColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.px6),
                    ),
                    onSelected: (selected) {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SearchScreen(initialQuery: genre),
                        ),
                      );
                    },
                  ),
                );
              }).toList(),
            ),
            AppSpacing.vGap24,
          ],
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.px12, vertical: AppSpacing.px4),
      decoration: BoxDecoration(
        gradient: isHighlight ? AppColors.buttonGradient : null,
        color: isHighlight ? null : Colors.transparent,
        borderRadius: BorderRadius.circular(AppSpacing.px8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isHighlight ? Colors.black : Colors.white70,
        ),
        title: Text(
          title,
          style: isHighlight ? AppTextStyles.drawerTileHighlight : AppTextStyles.drawerTile,
        ),
        onTap: onTap,
      ),
    );
  }
}
