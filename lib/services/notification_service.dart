import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Replace this with your VAPID key from Firebase Console:
  // Firebase Console → Project Settings → Cloud Messaging → Web Push certificates → Generate key pair
  static const String _vapidKey = 'YOUR_VAPID_KEY_HERE';

  static Future<void> initialize() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      final token = await getToken();
      debugPrint('FCM Token: $token');
      // Save this token to Firestore if you want to send targeted notifications
    } else {
      debugPrint('Notification permission denied');
    }
  }

  static Future<String?> getToken() async {
    if (kIsWeb) {
      return await _messaging.getToken(vapidKey: _vapidKey);
    }
    return await _messaging.getToken();
  }
}
