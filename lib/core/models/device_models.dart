import 'package:equatable/equatable.dart';

class DeviceModel extends Equatable {
  final String id;
  final String deviceId;
  final String deviceType;
  final String? lastActive;

  const DeviceModel({
    required this.id,
    required this.deviceId,
    required this.deviceType,
    this.lastActive,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id']?.toString() ?? '',
      deviceId: json['deviceId']?.toString() ?? json['device_id']?.toString() ?? '',
      deviceType: json['deviceType']?.toString() ?? json['device_type']?.toString() ?? 'android',
      lastActive: json['lastActive']?.toString() ?? json['last_active']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'deviceId': deviceId,
      'deviceType': deviceType,
      'lastActive': lastActive,
    };
  }

  @override
  List<Object?> get props => [id, deviceId, deviceType, lastActive];
}
