import 'package:firebase_messaging/firebase_messaging.dart';

class FcmService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  /// Get FCM token
  static Future<String?> getToken() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true, // ✅ default phone sound
    );

    return await _firebaseMessaging.getToken();
  }
}
