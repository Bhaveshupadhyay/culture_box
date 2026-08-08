import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../app/di/service_locator.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/models/movie_models.dart';
import '../../../auth/presentation/pages/login_page.dart';

class ChoosePlanPage extends StatefulWidget {
  const ChoosePlanPage({super.key});

  @override
  State<ChoosePlanPage> createState() => _ChoosePlanPageState();
}

class _ChoosePlanPageState extends State<ChoosePlanPage> {
  int _selectedPlanIndex = 0;
  bool _isLoadingPlans = true;
  bool _isProcessingPayment = false;
  List<PlanModel> _plans = [];

  @override
  void initState() {
    super.initState();
    _loadPlans();
  }

  Future<void> _loadPlans() async {
    setState(() => _isLoadingPlans = true);
    final plans = await ServiceLocator.instance.subscriptionRepository.getPlans();
    if (mounted) {
      setState(() {
        _plans = plans;
        _isLoadingPlans = false;
      });
    }
  }

  void _promptSignIn() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Sign In Required', style: AppTextStyles.detailsTitle),
        content: Text(
          'Please sign in to your CultureBox account before subscribing to a plan.',
          style: AppTextStyles.bodySecondary,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.logoRedOrange,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            child: const Text('SIGN IN'),
          ),
        ],
      ),
    );
  }

  Future<void> _proceedToPayment() async {
    final authRepo = ServiceLocator.instance.authRepository;

    // Check if user is signed in
    if (!authRepo.isAuthenticated) {
      _promptSignIn();
      return;
    }

    if (_plans.isEmpty) return;
    final selectedPlan = _plans[_selectedPlanIndex];

    setState(() => _isProcessingPayment = true);

    try {
      final checkoutUrl = await ServiceLocator.instance.subscriptionRepository.createCheckoutSession(selectedPlan.id);
      final uri = Uri.parse(checkoutUrl);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not open payment URL: $checkoutUrl')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Initiated checkout for ${selectedPlan.planName} plan!'),
            backgroundColor: AppColors.surface,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessingPayment = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authRepo = ServiceLocator.instance.authRepository;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('CHOOSE YOUR PLAN'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoadingPlans
          ? const Center(child: CircularProgressIndicator(color: AppColors.logoGold))
          : SingleChildScrollView(
              padding: AppSpacing.all16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!authRepo.isAuthenticated)
                    Container(
                      margin: const EdgeInsets.only(bottom: AppSpacing.px16),
                      padding: AppSpacing.all12,
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(AppSpacing.px8),
                        border: Border.all(color: Colors.amber.shade700),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.amber.shade400),
                          AppSpacing.hGap10,
                          Expanded(
                            child: Text(
                              'Sign in to your account to activate your subscription upon payment.',
                              style: AppTextStyles.featureText.copyWith(color: Colors.white),
                            ),
                          ),
                          TextButton(
                            onPressed: _promptSignIn,
                            child: const Text('SIGN IN', style: TextStyle(color: AppColors.logoGold, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
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
                      final isPopular = plan.planName.toLowerCase().contains('standard') || index == 1;

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
                            color: isSelected ? AppColors.darkBanner : AppColors.surface,
                            borderRadius: BorderRadius.circular(AppSpacing.px12),
                            border: Border.all(
                              color: isSelected ? AppColors.logoGold : Colors.white12,
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
                                    plan.planName.toUpperCase(),
                                    style: AppTextStyles.planTitle,
                                  ),
                                  if (isPopular)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: AppSpacing.px8, vertical: AppSpacing.px4),
                                      decoration: BoxDecoration(
                                        gradient: AppColors.buttonGradient,
                                        borderRadius: BorderRadius.circular(AppSpacing.px4),
                                      ),
                                      child: Text(
                                        'MOST POPULAR',
                                        style: AppTextStyles.badgeText
                                            .copyWith(color: Colors.black, fontWeight: FontWeight.w900),
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
                                    '\$${plan.monthlyPrice}',
                                    style: AppTextStyles.planPrice,
                                  ),
                                  Text(
                                    ' / month',
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
                                      '${plan.maxScreens} Screen${plan.maxScreens > 1 ? 's' : ''}',
                                      style: AppTextStyles.planResolution,
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(color: Colors.white12, height: AppSpacing.px24),
                              Padding(
                                padding: const EdgeInsets.only(bottom: AppSpacing.px6),
                                child: Row(
                                  children: [
                                    const Icon(Icons.check_circle, color: AppColors.logoGold, size: 16),
                                    AppSpacing.hGap8,
                                    Text(
                                      'Watch on ${plan.maxScreens} device${plan.maxScreens > 1 ? 's' : ''} at a time',
                                      style: AppTextStyles.featureText,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: AppSpacing.px6),
                                child: Row(
                                  children: [
                                    const Icon(Icons.check_circle, color: AppColors.logoGold, size: 16),
                                    AppSpacing.hGap8,
                                    Text(
                                      'Unlimited movies and TV shows',
                                      style: AppTextStyles.featureText,
                                    ),
                                  ],
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
                      onPressed: _isProcessingPayment ? null : _proceedToPayment,
                      child: _isProcessingPayment
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2.5),
                            )
                          : Text(
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
