import 'dart:developer' as consol;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:funky_new/shared/network/cache_helper.dart';
import 'package:get/get.dart';

import '../chat_with_firebase/chat_screen/firebase_chat_screen.dart';
import 'fcm/firebase_messaging_service.dart';

class NotificationService {
  static late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  static Future<void> initialize() async {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    try {
      await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {
          onDidReceiveNotificationResponse(notificationResponse);
        },
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      );
      print('/----Flutter Local Notification initialized-----/');
    } catch (e) {
      consol.log('flutterLocalNotificationsPlugin.initialize error', error: e);
    }
  }

// initialize the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  static const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/notification_icon');

  static InitializationSettings initializationSettings =
      const InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS);

  static const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        //  onDidReceiveLocalNotification: onDidReceiveLocalNotification
      );

  static const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    '0',
    'your channel name',
    channelDescription: 'your channel description',
    importance: Importance.max,
    priority: Priority.max,
    channelShowBadge: true,
    colorized: true,
    enableVibration: true,
    playSound: true,
    ticker: 'ticker',
  );

  static const NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);

  static Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
      List data = payload.split(',');
      print('notification payload:$data');

      if (CacheHelper.getString(key: 'uId').isNotEmpty) {
        if (data[1] == NotificationType.Chat.name) {
          Get.to(() => FirebaseChatScreen(receiverId: '${data[0]}'));
        } else {
          // Get.to(() => LikeScreen());
        }
      }
    }
    // Handle the notification received event
    // You can display a dialog or navigate to a specific page
  }

  static void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    print('onDidReceiveNotificationResponse');
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
      List data = payload!.split(',');
      print('notification payload:$data');

      if (CacheHelper.getString(key: 'uId').isNotEmpty) {
        if (data[1] == NotificationType.Chat.name) {
          Get.to(() => FirebaseChatScreen(receiverId: '${data[0]}'));
        } else {
          // Get.to(() => LikeScreen());
        }
      }
    }
  }

  @pragma('vm:entry-point')
  static void notificationTapBackground(
      NotificationResponse notificationResponse) {
    print('notificationTapBackground');
    //final String? payload = notificationResponse.payload;
    // if (notificationResponse.payload != null) {
    //   if (notificationResponse.payload != null) {
    //     debugPrint('notification payload: $payload');
    //     List data = payload!.split(',');
    //     print(data);
    //     if (data[1] == NotificationType.Chat.name) {
    //       Get.to(() => ChatScreen('$data[0]'));
    //     } else {
    //       Get.to(() => LikeScreen());
    //     }
    //   }
    //   // debugPrint('notification payload: $payload');
    //   // Get.to(() => ChatScreen('$payload'));
    // }
  }

  static void getNotificationAppLaunchDetails() async {
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await _flutterLocalNotificationsPlugin
            .getNotificationAppLaunchDetails();
    print("app launched from notification");

    //check if the notification contains the response or not
    if (notificationAppLaunchDetails!.notificationResponse != null) {
      final response = notificationAppLaunchDetails.notificationResponse;
      //check for the response or payload
      if (response != null && response.payload != null) {
        print("response payload=>${response.payload}");
        //Todo:
        Get.to(() => FirebaseChatScreen(receiverId: '${response.payload}'));
        //Get.to(() => ChatScreen('${response.payload}'));
      } else {
        print("response payload is Null");
      }
    } else {
      // The app was launched by other means (not from a notification)
      print('App was not launched by a notification');
    }
  }

  static void showLocalNotification(RemoteMessage message) async {
    final Map<String, dynamic> payloadData =
        message.data; // Access payload here
    final String id = payloadData['id'] ?? '';
    final String type = payloadData['type'] ?? ''; // Extract payload value
    // Extract payload value
    print('payload=>${message.data}');
    print('payload=>$id');
    print('payload=>$type');
    try {
      _flutterLocalNotificationsPlugin.show(
          0, // Notification ID
          message.notification?.title ?? '', // Title
          message.notification?.body ?? '', // Body
          notificationDetails,
          payload: '$id,$type');
    } catch (e) {
      consol.log('Notification Error', error: e);
    }
  }
}
