import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceIdService {
  static const String _deviceIdKey = 'cb_device_id';
  final SharedPreferences _prefs;

  DeviceIdService(this._prefs);

  /// Retrieves or generates a 12-character unique device identifier
  String getDeviceId() {
    String? deviceId = _prefs.getString(_deviceIdKey);
    if (deviceId == null || deviceId.length != 12) {
      deviceId = _generateUniqueId();
      _prefs.setString(_deviceIdKey, deviceId);
    }
    return deviceId;
  }

  /// Detects operating device platform matching backend enum ["android", "ios", "web", "tv"]
  String getDeviceType() {
    if (kIsWeb) return 'web';
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return 'ios';
      case TargetPlatform.android:
        return 'android';
      default:
        return 'web';
    }
  }

  String _generateUniqueId() {
    final now = DateTime.now().microsecondsSinceEpoch.toRadixString(36);
    final random = (now.hashCode ^ 0x5F3759DF).abs().toRadixString(36);
    final combined = (now + random).toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
    if (combined.length >= 12) {
      return combined.substring(0, 12);
    }
    return combined.padRight(12, 'X');
  }
}
