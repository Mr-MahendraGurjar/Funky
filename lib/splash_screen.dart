// ignore_for_file: prefer_const_constructors, prefer_final_fields

import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:funky_new/custom_widget/page_loader.dart';
import 'package:funky_new/dashboard/dashboard_screen.dart';
import 'package:funky_new/search_screen/search__screen_controller.dart';
import 'package:funky_new/sharePreference.dart';
import 'package:get/get.dart';

import 'Authentication/creator_login/controller/creator_login_controller.dart';
import 'Utils/App_utils.dart';
import 'Utils/asset_utils.dart';
import 'getx_pagination/binding_utils.dart';
import 'homepage/controller/homepage_controller.dart';
import 'news_feed/controller/news_feed_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin? fltNotification;

  @override
  void initState() {
    super.initState();
    initMessaging();
    pushFCMtoken();
    Timer(Duration(seconds: 3), () {
      init();
      // Get.toNamed(BindingUtils.AuthenticationScreenRoute);
    });
  }

  final HomepageController homepageController =
      Get.put(HomepageController(), tag: HomepageController().toString());

  final Search_screen_controller _search_screen_controller = Get.put(
      Search_screen_controller(),
      tag: Search_screen_controller().toString());

  final NewsFeed_screen_controller news_feed_controller = Get.put(
      NewsFeed_screen_controller(),
      tag: NewsFeed_screen_controller().toString());

  final Creator_Login_screen_controller _creator_login_screen_controller =
      Get.put(Creator_Login_screen_controller(),
          tag: Creator_Login_screen_controller().toString());

  String? token;

  void pushFCMtoken() async {
    FirebaseMessaging.instance.getToken().then((value) {
      setState(() {
        token = value;
      });
    });
  }

  init() async {
    String idUser = await PreferenceManager().getPref(URLConstants.id);
    String typeUser = await PreferenceManager().getPref(URLConstants.type);

    //quickblox_id = await _storageRepository.getUserId();

    showLoader(context);
    if (idUser == 'id' ||
        idUser.isEmpty ||
        typeUser == 'type' ||
        typeUser.isEmpty) {
      Get.offAllNamed(BindingUtils.AuthenticationScreenRoute);
    } else {
      // String idUser = await PreferenceManager().getPref(URLConstants.id);
      String socialTypeUser =
          await PreferenceManager().getPref(URLConstants.social_type);
      await homepageController.getAllVideosList();
      await homepageController.getAllImagesList();
      await _search_screen_controller.getDiscoverFeed(context: context);
      await news_feed_controller.getAllNewsFeedList();

      await PreferenceManager().getPref(URLConstants.social_type);
      // print("id----- $idUser");
      print("id----- $socialTypeUser");
      print("idds----- $idUser");
      (socialTypeUser == ""
          ? await _creator_login_screen_controller.CreatorgetUserInfo_Email(
              context: context, UserId: idUser)
          : await _creator_login_screen_controller.getUserInfo_social());
      await _creator_login_screen_controller.PostToken(
          context: context, token: token!, userid: idUser);
      // await _incrementCounter();
      await Get.offAll(Dashboard(
        page: 0,
      ));
    }
  }

  void initMessaging() {
    var androiInit = AndroidInitializationSettings("@mipmap/ic_launcher");
    //var iosInit = DarwinInitializationSettings();
    var initSetting = InitializationSettings(android: androiInit, iOS: null);

    fltNotification = FlutterLocalNotificationsPlugin();
    fltNotification!.initialize(initSetting);
    var androidDetails = AndroidNotificationDetails(
      '1',
      'channelName',
    );
    // var iosDetails = DarwinNotificationDetails(presentSound: true);
    var generalNotificationDetails =
        NotificationDetails(android: androidDetails, iOS: null);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      // FlutterAppBadger.updateBadgeCount(1);
      FlutterAppBadger.updateBadgeCount(1);

      // AndroidNotification? android= message.notification?.apple;
      AppleNotification? android = message.notification?.apple;
      if (notification != null && android != null) {
        print(notification.title);
        fltNotification!.show(notification.hashCode, notification.title,
            notification.body, generalNotificationDetails);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      FlutterAppBadger.removeBadge();
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? _sessionId;

  @override
  Widget build(BuildContext context) {
    // Todo:
    // initBloc(context);
    // bloc?.events?.add(AuthEvent());

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 86),
            child: Image.asset(AssetUtils.logo)),
      ),
    );
  }
}
