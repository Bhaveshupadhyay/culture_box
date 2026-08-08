import '../../../../core/models/device_models.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';

class DevicesApiService {
  final ApiClient apiClient;

  DevicesApiService(this.apiClient);

  /// Get Connected Devices (GET /devices)
  Future<List<DeviceModel>> getConnectedDevices() async {
    final response = await apiClient.get(ApiEndpoints.devices);
    final json = response.data as Map<String, dynamic>;
    if (json.containsKey('data') && json['data'] is List) {
      return (json['data'] as List)
          .map((e) => DeviceModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  /// Remove Connected Device (DELETE /devices/{device_id}/{del_device_id})
  Future<void> removeDevice(String deviceId, String delDeviceId) async {
    await apiClient.delete(ApiEndpoints.removeDevice(deviceId, delDeviceId));
  }
}
