import 'package:flutter/material.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../movies/data/sources/mock_movies.dart';
import '../../../movies/presentation/widgets/movie_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final watchlistMovies = mockMovies.take(3).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('PROFILE'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.all16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: AppSpacing.all16,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.px12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.logoGradient,
                    ),
                    child: const Center(
                      child: Text(
                        'J',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  AppSpacing.hGap16,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jane Doe',
                        style: AppTextStyles.profileName,
                      ),
                      AppSpacing.vGap4,
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.px8, vertical: AppSpacing.px2),
                        decoration: BoxDecoration(
                          color: AppColors.darkBanner,
                          borderRadius: BorderRadius.circular(AppSpacing.px4),
                          border: Border.all(color: AppColors.logoGold),
                        ),
                        child: Text(
                          'PRO SUBSCRIBER',
                          style: AppTextStyles.profileSubscriber,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AppSpacing.vGap24,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'MY WATCHLIST',
                  style: AppTextStyles.sectionHeader,
                ),
                Text(
                  '3 items',
                  style: AppTextStyles.textMuted,
                ),
              ],
            ),
            AppSpacing.vGap12,
            SizedBox(
              height: AppSpacing.px200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: watchlistMovies.length,
                itemBuilder: (context, index) {
                  return MovieCard(movie: watchlistMovies[index]);
                },
              ),
            ),
            AppSpacing.vGap24,
            Text(
              'ACCOUNT & SETTINGS',
              style: AppTextStyles.sectionHeaderSmall,
            ),
            AppSpacing.vGap12,
            _buildProfileOption(Icons.history, 'Watch History', () {}),
            _buildProfileOption(Icons.download, 'Downloads', () {}),
            _buildProfileOption(Icons.payment, 'Billing & Subscriptions', () {}),
            _buildProfileOption(Icons.lock, 'Parental Controls', () {}),
            _buildProfileOption(Icons.help_outline, 'Help & Support', () {}),
            AppSpacing.vGap20,
            SizedBox(
              width: double.infinity,
              height: AppSpacing.px46,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.redAccent),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.px8),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  'SIGN OUT',
                  style: AppTextStyles.signOutText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(
      IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.px8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.px8),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white70),
        title: Text(
          title,
          style: AppTextStyles.bodyText,
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.white38),
        onTap: onTap,
      ),
    );
  }
}
