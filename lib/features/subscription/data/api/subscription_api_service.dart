import '../../../../core/models/movie_models.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';

class SubscriptionApiService {
  final ApiClient apiClient;

  SubscriptionApiService(this.apiClient);

  /// Get available plans (GET /payments/plans)
  Future<List<PlanModel>> getPlans() async {
    final response = await apiClient.get(ApiEndpoints.paymentsPlans);
    if (response.data is! Map<String, dynamic>) return [];
    final json = response.data as Map<String, dynamic>;
    if (json.containsKey('data') && json['data'] != null) {
      final data = json['data'];
      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map((e) => PlanModel.fromJson(e))
            .toList();
      } else if (data is Map<String, dynamic> && data.containsKey('plans') && data['plans'] is List) {
        return (data['plans'] as List)
            .whereType<Map<String, dynamic>>()
            .map((e) => PlanModel.fromJson(e))
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
    if (response.data is! Map<String, dynamic>) {
      throw Exception('Invalid response format from checkout endpoint');
    }
    final json = response.data as Map<String, dynamic>;
    if (json.containsKey('data') && json['data'] is Map<String, dynamic>) {
      final dataMap = json['data'] as Map<String, dynamic>;
      if (dataMap.containsKey('checkout_url') && dataMap['checkout_url'] is String) {
        return dataMap['checkout_url'] as String;
      } else if (dataMap.containsKey('url') && dataMap['url'] is String) {
        return dataMap['url'] as String;
      }
    }
    if (json.containsKey('checkout_url') && json['checkout_url'] is String) {
      return json['checkout_url'] as String;
    }
    throw Exception('Failed to get checkout session URL');
  }

  /// Get Subscription Status (GET /payments/status)
  Future<Map<String, dynamic>> getStatus() async {
    final response = await apiClient.get(ApiEndpoints.paymentStatus);
    if (response.data is Map<String, dynamic>) {
      return response.data as Map<String, dynamic>;
    }
    return {};
  }

  /// Cancel Subscription (POST /payments/cancel)
  Future<void> cancelSubscription() async {
    await apiClient.post(ApiEndpoints.cancelSubscription);
  }
}
