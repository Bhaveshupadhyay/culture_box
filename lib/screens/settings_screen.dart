import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _cellularDataSaver = false;
  bool _autoPlayNext = true;
  bool _notifications = true;
  String _videoQuality = 'Auto (High)';

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
            'VIDEO PLAYBACK',
            style: AppTextStyles.sectionHeaderSmall,
          ),
          AppSpacing.vGap8,
          ListTile(
            tileColor: AppColors.surface,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.px8)),
            title: Text('Streaming Quality',
                style: AppTextStyles.bodyText),
            subtitle: Text(_videoQuality,
                style: AppTextStyles.textMuted),
            trailing: const Icon(Icons.chevron_right, color: Colors.white38),
            onTap: () {
              _showQualityPicker();
            },
          ),
          AppSpacing.vGap8,
          SwitchListTile(
            tileColor: AppColors.surface,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.px8)),
            title: Text('Save Cellular Data',
                style: AppTextStyles.bodyText),
            subtitle: Text('Stream in lower resolution on mobile networks',
                style: AppTextStyles.textMuted),
            value: _cellularDataSaver,
            activeTrackColor: AppColors.badgeGreen,
            onChanged: (val) {
              setState(() {
                _cellularDataSaver = val;
              });
            },
          ),
          AppSpacing.vGap8,
          SwitchListTile(
            tileColor: AppColors.surface,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.px8)),
            title: Text('Autoplay Next Episode',
                style: AppTextStyles.bodyText),
            value: _autoPlayNext,
            activeTrackColor: AppColors.badgeGreen,
            onChanged: (val) {
              setState(() {
                _autoPlayNext = val;
              });
            },
          ),
          AppSpacing.vGap24,
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

  void _showQualityPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Auto (High)', '1080p Full HD', '720p HD', 'Data Saver']
              .map((q) {
            return ListTile(
              title: Text(q, style: AppTextStyles.bodyText),
              trailing: _videoQuality == q
                  ? const Icon(Icons.check, color: AppColors.primaryBlue)
                  : null,
              onTap: () {
                setState(() {
                  _videoQuality = q;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }
}
