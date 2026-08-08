import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/di/service_locator.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/widgets/sign_out_dialog.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../subscription/presentation/pages/choose_plan_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final authRepo = ServiceLocator.instance.authRepository;
    final user = await authRepo.getCurrentUser();
    if (mounted) {
      setState(() {
        _currentUser = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = ServiceLocator.instance.authBloc;
    final fbUser = firebase.FirebaseAuth.instance.currentUser;
    final authRepo = ServiceLocator.instance.authRepository;

    return BlocProvider.value(
      value: authBloc,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('PROFILE'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final isAuthenticated = authRepo.isAuthenticated || fbUser != null || state is Authenticated;

            String email = _currentUser?.email ?? '';
            if (email.isEmpty && state is Authenticated) {
              email = state.user.email;
            }
            if (email.isEmpty && fbUser?.email != null) {
              email = fbUser!.email!;
            }
            if (email.isEmpty) {
              email = authRepo.authLocalStorage.getUserEmail() ?? '';
            }

            final displayName = _currentUser?.profileName != null && _currentUser!.profileName!.isNotEmpty
                ? _currentUser!.profileName!
                : (email.isNotEmpty ? email : 'Guest User');

            final initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : 'G';
            final isSubscribed = (_currentUser?.isSubscribed ?? 0) == 1;

            return SingleChildScrollView(
              padding: AppSpacing.all16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Profile Header Card
                  Material(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.px12),
                    child: Padding(
                      padding: AppSpacing.all16,
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppColors.logoGradient,
                            ),
                            child: Center(
                              child: Text(
                                initial,
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          AppSpacing.hGap16,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  displayName,
                                  style: AppTextStyles.profileName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (email.isNotEmpty && email != displayName) ...[
                                  AppSpacing.vGap2,
                                  Text(
                                    email,
                                    style: AppTextStyles.bodySmall,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                                AppSpacing.vGap6,
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: AppSpacing.px8, vertical: AppSpacing.px3),
                                      decoration: BoxDecoration(
                                        color: isSubscribed
                                            ? AppColors.darkBanner
                                            : Colors.grey.shade900,
                                        borderRadius: BorderRadius.circular(AppSpacing.px4),
                                        border: Border.all(
                                          color: isSubscribed
                                              ? AppColors.logoGold
                                              : Colors.white24,
                                        ),
                                      ),
                                      child: Text(
                                        isSubscribed ? 'PRO SUBSCRIBER' : 'FREE MEMBER',
                                        style: AppTextStyles.profileSubscriber.copyWith(
                                          color: isSubscribed
                                              ? AppColors.logoGold
                                              : Colors.white60,
                                        ),
                                      ),
                                    ),
                                    if (!isSubscribed) ...[
                                      AppSpacing.hGap8,
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => const ChoosePlanPage()),
                                          );
                                        },
                                        child: Text(
                                          'Upgrade Plan',
                                          style: TextStyle(
                                            color: AppColors.logoGold,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  /*
                  AppSpacing.vGap24,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'MY WATCHLIST',
                        style: AppTextStyles.sectionHeader,
                      ),
                      Text(
                        '${watchlistMovies.length} items',
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
                  */
                  AppSpacing.vGap24,
                  Text(
                    'ACCOUNT & SETTINGS',
                    style: AppTextStyles.sectionHeaderSmall,
                  ),
                  AppSpacing.vGap12,
                  // _buildProfileOption(Icons.history, 'Watch History', () {}),
                  // _buildProfileOption(Icons.download, 'Downloads', () {}),
                  _buildProfileOption(Icons.payment, 'Billing & Subscriptions', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ChoosePlanPage()),
                    );
                  }),
                  // _buildProfileOption(Icons.lock, 'Parental Controls', () {}),
                  _buildProfileOption(Icons.help_outline, 'Help & Support', () {}),
                  AppSpacing.vGap20,
                  SizedBox(
                    width: double.infinity,
                    height: AppSpacing.px46,
                    child: isAuthenticated
                        ? OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.redAccent),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppSpacing.px8),
                              ),
                            ),
                            onPressed: () => SignOutDialog.show(context, authBloc),
                            child: Text(
                              'SIGN OUT',
                              style: AppTextStyles.signOutText,
                            ),
                          )
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.logoRedOrange,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppSpacing.px8),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginPage()),
                              );
                            },
                            child: const Text('SIGN IN / REGISTER'),
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.px8),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.px8),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          leading: Icon(icon, color: Colors.white70),
          title: Text(
            title,
            style: AppTextStyles.bodyText,
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.white38),
          onTap: onTap,
        ),
      ),
    );
  }
}
