import 'package:flutter/material.dart';
import '../../../../app/theme/app_theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('SETTINGS'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: AppSpacing.all16,
        children: [
          Text(
            'NOTIFICATIONS',
            style: AppTextStyles.sectionHeaderSmall,
          ),
          AppSpacing.vGap8,
          SwitchListTile(
            tileColor: AppColors.surface,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.px8)),
            title: Text('New Release Alerts',
                style: AppTextStyles.bodyText),
            value: _notifications,
            activeTrackColor: AppColors.badgeGreen,
            onChanged: (val) {
              setState(() {
                _notifications = val;
              });
            },
          ),
          AppSpacing.vGap24,
          Text(
            'ABOUT',
            style: AppTextStyles.sectionHeaderSmall,
          ),
          AppSpacing.vGap8,
          Container(
            padding: AppSpacing.all16,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.px8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('App Version', style: AppTextStyles.bodyText),
                Text('1.0.0 (Build 42)',
                    style: AppTextStyles.textMuted),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
