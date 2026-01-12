import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotificationService {
  static final _local = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // 1. Request notification permission
    await FirebaseMessaging.instance.requestPermission();

    // 2. Get FCM token (for debugging & server usage)
    final token = await FirebaseMessaging.instance.getToken();
    debugPrint('FCM TOKEN: $token');

    // 3. Initialize local notifications
    const androidSettings = AndroidInitializationSettings('@drawable/ic_notification');

    const initSettings = InitializationSettings(android: androidSettings);

    await _local.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        _handleTap(response.payload);
      },
    );

    // 4. Handle foreground messages
    FirebaseMessaging.onMessage.listen(_showLocalNotification);

    // 5. Handle when app is opened from background/terminated via notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleTap(jsonEncode(message.data));
    });
  }

  static Future<void> _showLocalNotification(RemoteMessage message) async {
    // Use default system sound + high priority
    const androidDetails = AndroidNotificationDetails(
      'faithconnect_channel',              // Channel ID (must be unique)
      'FaithConnect Notifications',        // Channel name (visible in settings)
      channelDescription: 'Important notifications from FaithConnect',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@drawable/ic_notification',   // Your app icon / notification icon
      playSound: true,                     // ← This uses the DEFAULT PHONE NOTIFICATION SOUND
      enableVibration: true,
      enableLights: true,
      color: Color(0xFF2563EB),            // Optional: accent color for LED light
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _local.show(
      message.hashCode,                    // Unique ID for each notification
      message.notification?.title ?? 'FaithConnect',
      message.notification?.body ?? 'You have a new notification',
      notificationDetails,
      payload: jsonEncode(message.data),
    );
  }

  static void _handleTap(String? payload) {
    if (payload == null) return;

    try {
      final data = jsonDecode(payload) as Map<String, dynamic>;

      switch (data['type']) {
        case 'CHAT':
          Get.toNamed('/chat', arguments: data);
          break;
        case 'POST':
          Get.toNamed('/post', arguments: data);
          break;
        case 'REEL':
          Get.toNamed('/reel', arguments: data);
          break;
        default:
          debugPrint('Unhandled notification type: ${data['type']}');
      }
    } catch (e) {
      debugPrint('Error handling notification tap: $e');
    }
  }
}