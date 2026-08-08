import '../../../../core/models/movie_models.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';

class SubscriptionApiService {
  final ApiClient apiClient;

  SubscriptionApiService(this.apiClient);

  /// Get available plans (GET /payments/plans)
  Future<List<PlanModel>> getPlans() async {
    final response = await apiClient.get(ApiEndpoints.paymentsPlans);
    final json = response.data as Map<String, dynamic>;
    if (json.containsKey('data')) {
      final data = json['data'];
      if (data is List) {
        return data.map((e) => PlanModel.fromJson(e as Map<String, dynamic>)).toList();
      } else if (data is Map && data.containsKey('plans')) {
        return (data['plans'] as List)
            .map((e) => PlanModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    }
    return [];
  }

  /// Create Checkout Session (POST /payments/checkout-session)
  Future<String> createCheckoutSession(int planId, {String device = 'app'}) async {
    final response = await apiClient.post(
      ApiEndpoints.checkoutSession,
      data: {
        'plan_id': planId,
        'device': device,
      },
    );
    final json = response.data as Map<String, dynamic>;
    if (json.containsKey('data') && json['data'] is Map) {
      final dataMap = json['data'] as Map<String, dynamic>;
      if (dataMap.containsKey('checkout_url')) {
        return dataMap['checkout_url'] as String;
      } else if (dataMap.containsKey('url')) {
        return dataMap['url'] as String;
      }
    }
    if (json.containsKey('checkout_url')) {
      return json['checkout_url'] as String;
    }
    throw Exception('Failed to get checkout session URL');
  }

  /// Get Subscription Status (GET /payments/status)
  Future<Map<String, dynamic>> getStatus() async {
    final response = await apiClient.get(ApiEndpoints.paymentStatus);
    return response.data as Map<String, dynamic>;
  }

  /// Cancel Subscription (POST /payments/cancel)
  Future<void> cancelSubscription() async {
    await apiClient.post(ApiEndpoints.cancelSubscription);
  }
}
