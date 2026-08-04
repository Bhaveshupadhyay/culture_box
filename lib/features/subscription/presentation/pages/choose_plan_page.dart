import 'package:flutter/material.dart';
import '../../../../app/theme/app_theme.dart';

class ChoosePlanPage extends StatefulWidget {
  const ChoosePlanPage({super.key});

  @override
  State<ChoosePlanPage> createState() => _ChoosePlanPageState();
}

class _ChoosePlanPageState extends State<ChoosePlanPage> {
  int _selectedPlanIndex = 1;

  final List<Map<String, dynamic>> _plans = [
    {
      'title': 'BASIC',
      'price': '\$7.99',
      'period': '/ month',
      'resolution': '720p HD',
      'features': [
        'Watch on 1 device at a time',
        'Unlimited movies and TV shows',
        'Cancel anytime',
      ],
      'isPopular': false,
    },
    {
      'title': 'STANDARD',
      'price': '\$13.99',
      'period': '/ month',
      'resolution': '1080p Full HD',
      'features': [
        'Watch on 2 devices simultaneously',
        'Full HD resolution',
        'Download to watch offline',
        'Unlimited movies and TV shows',
      ],
      'isPopular': true,
    },
    {
      'title': 'PREMIUM 4K',
      'price': '\$18.99',
      'period': '/ month',
      'resolution': '4K Ultra HD + HDR',
      'features': [
        'Watch on 4 devices simultaneously',
        'Ultra HD (4K) + Spatial Audio',
        'Unlimited downloads on 6 devices',
        'Priority Customer Support',
      ],
      'isPopular': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('CHOOSE YOUR PLAN'),
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
            Text(
              'Select the plan that fits your streaming style',
              style: AppTextStyles.bodySecondary,
            ),
            AppSpacing.vGap20,
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _plans.length,
              itemBuilder: (context, index) {
                final plan = _plans[index];
                final isSelected = _selectedPlanIndex == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedPlanIndex = index;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(bottom: AppSpacing.px16),
                    padding: AppSpacing.all20,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.darkBanner
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(AppSpacing.px12),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.logoGold
                            : Colors.white12,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              plan['title'],
                              style: AppTextStyles.planTitle,
                            ),
                            if (plan['isPopular'])
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.px8, vertical: AppSpacing.px4),
                                decoration: BoxDecoration(
                                  gradient: AppColors.buttonGradient,
                                  borderRadius: BorderRadius.circular(AppSpacing.px4),
                                ),
                                child: Text(
                                  'MOST POPULAR',
                                  style: AppTextStyles.badgeText.copyWith(color: Colors.black, fontWeight: FontWeight.w900),
                                ),
                              ),
                          ],
                        ),
                        AppSpacing.vGap8,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              plan['price'],
                              style: AppTextStyles.planPrice,
                            ),
                            Text(
                              plan['period'],
                              style: AppTextStyles.planPeriod,
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.px8, vertical: AppSpacing.px4),
                              decoration: BoxDecoration(
                                color: Colors.white12,
                                borderRadius: BorderRadius.circular(AppSpacing.px4),
                              ),
                              child: Text(
                                plan['resolution'],
                                style: AppTextStyles.planResolution,
                              ),
                            ),
                          ],
                        ),
                        const Divider(color: Colors.white12, height: AppSpacing.px24),
                        ...List.generate(
                          (plan['features'] as List).length,
                          (fIndex) => Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.px6),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle,
                                    color: AppColors.logoGold, size: 16),
                                AppSpacing.hGap8,
                                Text(
                                  plan['features'][fIndex],
                                  style: AppTextStyles.featureText,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            AppSpacing.vGap20,
            Container(
              width: double.infinity,
              height: AppSpacing.px50,
              decoration: BoxDecoration(
                gradient: AppColors.buttonGradient,
                borderRadius: BorderRadius.circular(AppSpacing.px10),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.px10),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Subscribed to ${_plans[_selectedPlanIndex]['title']} Plan!',
                      ),
                    ),
                  );
                },
                child: Text(
                  'CONTINUE TO PAYMENT',
                  style: AppTextStyles.buttonTextDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
