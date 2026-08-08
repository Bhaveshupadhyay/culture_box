import 'package:flutter/material.dart';
import '../../app/theme/app_theme.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_event.dart';

class SignOutDialog {
  static void show(BuildContext context, AuthBloc authBloc, {bool closeDrawerOnConfirm = false}) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Sign Out', style: AppTextStyles.detailsTitle),
        content: Text(
          'Are you sure you want to sign out of your account?',
          style: AppTextStyles.bodySecondary,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('CANCEL', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.logoRedOrange,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(dialogContext);
              if (closeDrawerOnConfirm && Navigator.canPop(context)) {
                Navigator.pop(context); // Close drawer if open
              }
              authBloc.add(AuthLogoutRequested());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out successfully')),
              );
            },
            child: const Text('SIGN OUT'),
          ),
        ],
      ),
    );
  }
}
