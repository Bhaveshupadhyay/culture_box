import 'package:flutter/material.dart';
import '../../../../app/di/service_locator.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/models/device_models.dart';
import '../../../subscription/presentation/pages/choose_plan_page.dart';

class DevicesPage extends StatefulWidget {
  const DevicesPage({super.key});

  @override
  State<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  bool _isLoading = true;
  List<DeviceModel> _devices = [];
  late final String _currentDeviceId;

  @override
  void initState() {
    super.initState();
    _currentDeviceId = ServiceLocator.instance.deviceIdService.getDeviceId();
    _fetchDevices();
  }

  Future<void> _fetchDevices() async {
    setState(() => _isLoading = true);
    final devices = await ServiceLocator.instance.devicesRepository.getConnectedDevices();
    if (mounted) {
      setState(() {
        _devices = devices;
        _isLoading = false;
      });
    }
  }

  Future<void> _removeDevice(DeviceModel device) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Disconnect Device?', style: TextStyle(color: Colors.white)),
        content: Text(
          'Are you sure you want to remove "${device.deviceId}"? This device will be logged out.',
          style: AppTextStyles.bodySecondary,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.logoRedOrange),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('REMOVE'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final success = await ServiceLocator.instance.devicesRepository.removeDevice(
      _currentDeviceId,
      device.deviceId,
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Device removed successfully.')),
        );
        _fetchDevices();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to remove device.')),
        );
      }
    }
  }

  IconData _getDeviceIcon(String type) {
    final lower = type.toLowerCase();
    if (lower.contains('ios') || lower.contains('mobile') || lower.contains('android')) {
      return Icons.smartphone;
    } else if (lower.contains('tv')) {
      return Icons.tv;
    } else if (lower.contains('web')) {
      return Icons.computer;
    }
    return Icons.devices;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('CONNECTED DEVICES'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.logoGold))
          : SingleChildScrollView(
              padding: AppSpacing.all16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Manage devices connected to your CultureBox account.',
                    style: AppTextStyles.bodySecondary,
                  ),
                  AppSpacing.vGap20,
                  if (_devices.isEmpty)
                    Container(
                      padding: AppSpacing.all24,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppSpacing.px12),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.devices_other, size: 48, color: Colors.white38),
                          AppSpacing.vGap12,
                          Text(
                            'Current Device Registered',
                            style: AppTextStyles.detailsTitle,
                          ),
                          AppSpacing.vGap6,
                          Text(
                            'ID: $_currentDeviceId (${ServiceLocator.instance.deviceIdService.getDeviceType().toUpperCase()})',
                            style: AppTextStyles.bodySecondary,
                          ),
                        ],
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _devices.length,
                      itemBuilder: (context, index) {
                        final device = _devices[index];
                        final isThisDevice = device.deviceId == _currentDeviceId;

                        return Container(
                          margin: const EdgeInsets.only(bottom: AppSpacing.px12),
                          padding: AppSpacing.all16,
                          decoration: BoxDecoration(
                            color: isThisDevice ? AppColors.darkBanner : AppColors.surface,
                            borderRadius: BorderRadius.circular(AppSpacing.px10),
                            border: Border.all(
                              color: isThisDevice ? AppColors.logoGold : Colors.white12,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _getDeviceIcon(device.deviceType),
                                color: isThisDevice ? AppColors.logoGold : Colors.white70,
                                size: 28,
                              ),
                              AppSpacing.hGap12,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          device.deviceType.toUpperCase(),
                                          style: AppTextStyles.cardTitle,
                                        ),
                                        if (isThisDevice) ...[
                                          AppSpacing.hGap8,
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: AppColors.logoGold,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: const Text(
                                              'THIS DEVICE',
                                              style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    AppSpacing.vGap4,
                                    Text(
                                      'ID: ${device.deviceId}',
                                      style: AppTextStyles.cardSubtitle,
                                    ),
                                  ],
                                ),
                              ),
                              if (!isThisDevice)
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                  onPressed: () => _removeDevice(device),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  AppSpacing.vGap24,
                  Container(
                    width: double.infinity,
                    height: AppSpacing.px50,
                    decoration: BoxDecoration(
                      gradient: AppColors.buttonGradient,
                      borderRadius: BorderRadius.circular(AppSpacing.px10),
                    ),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ChoosePlanPage()),
                        );
                      },
                      icon: const Icon(Icons.star, color: Colors.black),
                      label: Text(
                        'UPGRADE PLAN FOR MORE SCREENS',
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
