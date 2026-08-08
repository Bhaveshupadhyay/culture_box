import '../../../../core/models/device_models.dart';
import '../api/devices_api_service.dart';

class DevicesRepository {
  final DevicesApiService devicesApiService;

  DevicesRepository({required this.devicesApiService});

  Future<List<DeviceModel>> getConnectedDevices() async {
    try {
      return await devicesApiService.getConnectedDevices();
    } catch (_) {
      return [];
    }
  }

  Future<bool> removeDevice(String deviceId, String delDeviceId) async {
    try {
      await devicesApiService.removeDevice(deviceId, delDeviceId);
      return true;
    } catch (_) {
      return false;
    }
  }
}
