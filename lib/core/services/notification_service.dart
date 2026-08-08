import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('[NotificationService] Background Push Notification received: ${message.messageId}');
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    // Background Handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Request permissions (iOS & Android 13+)
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    debugPrint('[NotificationService] User granted permission status: ${settings.authorizationStatus}');

    // Get FCM Registration Token
    try {
      final token = await _messaging.getToken();
      debugPrint('[NotificationService] FCM Token: $token');
    } catch (e) {
      debugPrint('[NotificationService] Error getting FCM Token: $e');
    }

    // Token refresh listener
    _messaging.onTokenRefresh.listen((newToken) {
      debugPrint('[NotificationService] FCM Token Refreshed: $newToken');
    });

    // Foreground Notifications Handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('[NotificationService] Foreground Push Received: ${message.notification?.title}');
    });

    // Notification Tapped App Opened Handler
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('[NotificationService] App opened via Push Notification: ${message.notification?.title}');
    });

    // Terminated State Launch Notification Handler
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('[NotificationService] App launched from terminated state via Push: ${initialMessage.notification?.title}');
    }

    _isInitialized = true;
  }
}
