import '../../../../core/models/movie_models.dart';
import '../api/subscription_api_service.dart';

class SubscriptionRepository {
  final SubscriptionApiService subscriptionApiService;

  SubscriptionRepository({required this.subscriptionApiService});

  Future<List<PlanModel>> getPlans() async {
    try {
      final plans = await subscriptionApiService.getPlans();
      if (plans.isNotEmpty) return plans;
    } catch (_) {}

    return const [
      PlanModel(id: 1, planName: 'BASIC', monthlyPrice: '6.99', maxScreens: 1),
      PlanModel(id: 2, planName: 'STANDARD', monthlyPrice: '13.99', maxScreens: 2),
      PlanModel(id: 3, planName: 'PREMIUM 4K', monthlyPrice: '18.99', maxScreens: 4),
    ];
  }

  Future<String> createCheckoutSession(int planId) async {
    return await subscriptionApiService.createCheckoutSession(planId);
  }

  Future<Map<String, dynamic>> getStatus() async {
    return await subscriptionApiService.getStatus();
  }
}
