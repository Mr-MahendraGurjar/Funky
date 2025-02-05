import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;

import '../../shared/network/cache_helper.dart';
import '../notification_service.dart';

class FirebaseMessagingService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // await NotificationService.initialize();
    // NotificationService.showLocalNotification(message);
    // print('push Notification taped');
    // print(message.data['id']);
    //Get.to(() => ChatScreen('${message.data['id']}'));
  }

  static Future<void> onBackgroundMessage() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> initialize() async {
    await _firebaseMessaging.getInitialMessage().then((message) {
      if (message != null) {
        // Handle the initial notification if available
        _handleNotification(message);
      }
    });

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle any message received while the app is in the foreground
      _handleNotification(message);
    });
  }

  static Future<void> _handleNotification(RemoteMessage message) async {
    print("Push Notification==>");
    NotificationService.showLocalNotification(message);
  }

  static Future<bool> sendNotification({
    required String token,
    required String title,
    required String body,
    required String type,
  }) async {
    final jsonCredentials = {
      "type": "service_account",
      "project_id": "skenu-44276",
      "private_key_id": "7ee04881db112a85ef2325c00114ce69571ec956",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDcEkd4xgG+dJew\nkLTIg3ewajjvCO6bKwOis9d3UzubHMZwzTIvfBk11IRpOGLS1G2GVrzgYO0q2v3C\ns9Fg81q40FH7mGuErsKdYqrNygZhlHbB7CqH4zlDa3yxhQtvrcaiXo2JlmB2IIOo\nF9cMwkEWbhttEs3P7BS+3yjwT/FdVzhB7vglPIZKt/F8Xcw57SOuht8UDmwRd28Y\nv6CkTgpaI98fw2iskIMGU3qphzqojq3IZNeWlxJ/TpxcAsSauvhKAldBcl+ZM8EU\ntfTamgHU4tS2x2bhJvJvQXi8wpsIgTocRMFtWBL/JdMesqn+UrUq8o2icN9SM4o6\np1y9qLtrAgMBAAECggEAOT0B3N43NueRSomgk6Rp/XbrPvSmRrJt3CQFbxI1ZxcZ\nX95m5qXS0sbm940EWwyIPhASSRO8q9BQfxMQ6rPwzS/VmugeUuC3WoL+pM6eUUPx\njWeU+kn1q1zqDivp+Q6MItAP5RC5HxA+3fnxY26kyiYyOPDSmfkvviNBvRs1zk41\nKb89nEcvLLoE+WANdW8OEnfNN80Qs4t+dKF2sSiLcE8KFaEDLSu/cFZ0EiYGX6lD\n7XZZwBfmvRmnRfC9UJp4LV6nYdg6aqiOj6MNqMv5c2Pe942DtN80nORIsA20aM1B\nqd68uk+Cw99kdOjt290hvydM7yNj847LUZXgFR0HCQKBgQDt1/hD4UwN25aYIdhy\nKvRJJNv14nCNX25vfB886ME3K884yxTHInSmx0tyrY8ZL4EmzdgyhxXSHSU+YpYU\nHJcFRJ0nbZslXtf0Vde2g3yZhsi/sy0JBFvtffeyPLXlw6PFfoFiocIB4xvIARQf\nvrcVuKMU9cy0nIGaxB4IbjhdmQKBgQDs3v9un60a6C1vnsuQ/UPRrSqBoZ8QWGqD\nsPaEPRUK23NhIy/S/E3ZItXkk4kqUOftQngr0tPNzH6+DAwnQyxLoiWvLY9zEz4z\nyRQ+/QQgm7LDeqX+o3nMfloo1ku0Su4arOGC3ok/Tv68qU8riV89IVv886ysbSiu\nmXG/YNYbowKBgEqfYiNaApSuerdMly5qz65LREAHRaz1bh7IYLypgkWfFysIfIJm\nCxdwm/lk/uq1/t1/4/8mZvA/eLn0EIZK2g8rEeuW9gBpm3Provx+kI9SvJV4z/5u\nQbFnvllLtv5ZvX5vTIT3n3kcGlFMFVZIbgUAoxombI2WNQur0IhwnHqxAoGATqAu\n9Y93LGlJO7XgKH6JFn5+j40QeaJ/qLsC+R41b+csQ2AkrcomJR9VFIyMiUlV0wGv\nVgyjVbq9j2P8XMQFXg2yqJVc+nu2uAXU/JuL1S8ZhZ2eoAmvkluWnduUQYJlyuD7\n8i7gK+2SzRj+OJtey7HZEPvpo0qQqHQyt63zJDUCgYEA2pXDpuYSh8lN9h/d2Bhm\n0gJ+Yb3DYkwVkOkS2B0dZBbsY5CiwJfx1VNnCKbd96lsgBKKXLgNQBlEDmPOUDWA\nXbC4ZU+LFh8C3xoxEeafvEYSxMmaIrFmV9SRR4WeK9gvaITja1upzItG0+5MMix6\nNl4K0kuHj4WyRgVS3XiuNA4=\n-----END PRIVATE KEY-----\n",
      "client_email": "skenu-44276@appspot.gserviceaccount.com",
      "client_id": "104311825866264289181",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/skenu-44276%40appspot.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    final creds = auth.ServiceAccountCredentials.fromJson(jsonCredentials);

    final client = await auth.clientViaServiceAccount(
      creds,
      ['https://www.googleapis.com/auth/cloud-platform'],
    );
    var data = {'id': CacheHelper.getString(key: 'uId'), 'type': type};
    final notificationData = {
      'message': {
        'token': token,
        'notification': {
          'title': title,
          'body': body,
        },
        'data': data,
      },
    };

    const String senderId = '389595322182';
    final response = await client.post(
      Uri.parse(
          'https://fcm.googleapis.com/v1/projects/$senderId/messages:send'),
      headers: {
        'content-type': 'application/json',
      },
      body: jsonEncode(notificationData),
    );

    client.close();
    if (response.statusCode == 200) {
      return true; // Success!
    }
    debugPrint(
        'Notification Sending Error Response status: ${response.statusCode}');
    debugPrint('Notification Response body: ${response.body}');
    return false;
  }

  /* in some device or platform specially in web it may happen get token is
   not supported then you can put these condition to so that  you can not get
   any error in production */

  static Future<String?> generateToken() async {
    var notifyToken = await FirebaseMessaging.instance.isSupported()
        ? await FirebaseMessaging.instance.getToken()
        : "notifyToken";
    debugPrint('FCMTOKEN:::$notifyToken');
    return notifyToken;
  }
}

enum NotificationType { Chat }
