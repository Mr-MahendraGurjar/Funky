import 'dart:convert' as convert;
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:funky_new/Authentication/instagram/instagram_constanr.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
// Import platform specific implementations
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../../Utils/App_utils.dart';
import '../../chat/constants/firestore_constants.dart';
import '../../chat/models/user_chat.dart';
import '../../dashboard/dashboard_screen.dart';
import '../../homepage/model/UserInfoModel.dart';
import '../../sharePreference.dart';
import '../creator_login/controller/creator_login_controller.dart';
import '../creator_login/model/creator_loginModel.dart';
import 'instagram_model.dart';

class InstagramView extends StatefulWidget {
  final String login_type;
  final BuildContext context;

  InstagramView({super.key, required this.login_type, required this.context});

  @override
  _InstagramViewState createState() => _InstagramViewState();
}

class _InstagramViewState extends State<InstagramView> {
  late final WebViewController _controller;
  LoginModel? loginModel;

  @override
  void initState() {
    super.initState();
    _initializeWebViewController();
  }

  void _initializeWebViewController() {
    // Platform specific initialization
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    _controller = WebViewController.fromPlatformCreationParams(params);

    // Common configuration
    _controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onUrlChange: (UrlChange change) {
            if (change.url != null && change.url!.contains(InstagramConstant.redirectUri)) {
              _handleRedirect(change.url!);
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(InstagramConstant.instance.url));

    // Platform specific configuration
    if (_controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (_controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: WebViewWidget(controller: _controller),
    );
  }

  void _handleRedirect(String url) async {
    final InstagramModel instagram = InstagramModel();
    instagram.getAuthorizationCode(url);
    
    await instagram.getTokenAndUserID().then((isDone) {
      if (isDone) {
        instagram.getUserProfile().then((isDone) async {
          await social_group_login(
            username: instagram.username.toString(),
            login_type: widget.login_type,
            context: widget.context,
            fullname: instagram.username.toString(),
          );

          print('${instagram.username} logged in!');
          await Get.to(Dashboard(page: 0));
        });
      }
    });
  }

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<dynamic> social_group_login({
    required BuildContext context,
    required String login_type,
    required String username,
    required String fullname,
  }) async {
    debugPrint('0-0-0-0-0-0-0 username');

    Map data = {
      'fullName': fullname,
      'userName': username,
      'email': " ",
      'phone': " ",
      'parent_email': " ",
      'password': " ",
      'gender': " ",
      'location': " ",
      'referral_code': " ",
      'image': " ",
      'profileUrl': " ",
      'socialId': " ",
      'social_type': "instagram",
      'type': login_type,
    };
    print(data);

    var url = (URLConstants.base_url + URLConstants.socailsignUpApi);
    print("url : $url");
    print("body : $data");

    var response = await http.post(
      Uri.parse(url),
      body: data,
    );
    print("response.body ${response.body}");
    print("response.request ${response.request}");
    print("response.statusCode ${response.statusCode}");

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      loginModel = LoginModel.fromJson(data);
      print("loginModel");
      print("wwwwwwwwwwwww ${loginModel!.user![0].type!}");
      if (loginModel!.error == false) {
        Fluttertoast.showToast(
          msg: "login successfully",
          textColor: Colors.white,
          backgroundColor: Colors.black,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
        await PreferenceManager()
            .setPref(URLConstants.id, loginModel!.user![0].id!);

        await getUserInfo_social();

        /// Firebase database messaging method
        final QuerySnapshot result = await firebaseFirestore
            .collection(FirestoreConstants.pathUserCollection)
            .where(FirestoreConstants.id, isEqualTo: loginModel!.user![0].id)
            .get();
        final List<DocumentSnapshot> documents = result.docs;
        if (documents.isEmpty) {
          print("new user created");
          // Writing data to server because here is a new user
          firebaseFirestore
              .collection(FirestoreConstants.pathUserCollection)
              .doc(loginModel!.user![0].id)
              .set({
            FirestoreConstants.nickname: fullname,
            FirestoreConstants.photoUrl: "",
            FirestoreConstants.id: loginModel!.user![0].id,
            'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
            FirestoreConstants.chattingWith: null
          });

          // Write data to local storage
          // User? currentUser = firebaseUser;
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString(
              FirestoreConstants.id, loginModel!.user![0].id!);
          await prefs.setString(FirestoreConstants.nickname, fullname ?? "");
          await prefs.setString(FirestoreConstants.photoUrl, "");
        } else {
          print("user existed");
          DocumentSnapshot documentSnapshot = documents[0];
          UserChat userChat = UserChat.fromDocument(documentSnapshot);
          // Write data to local
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString(FirestoreConstants.id, userChat.id);
          await prefs.setString(FirestoreConstants.nickname, userChat.nickname);
          await prefs.setString(FirestoreConstants.photoUrl, userChat.photoUrl);
          await prefs.setString(FirestoreConstants.aboutMe, userChat.aboutMe);
        }

        ///
        await Get.to(Dashboard(
          page: 0,
        ));
      } else {
        print('Please try again');
      }
    } else {
      print('Please try again');
    }
  }

  final Creator_Login_screen_controller _loginScreenController = Get.put(
      Creator_Login_screen_controller(),
      tag: Creator_Login_screen_controller().toString());

  Future<dynamic> getUserInfo_social() async {
    _loginScreenController.isuserinfoLoading(true);
    String idUser = await PreferenceManager().getPref(URLConstants.id);
    print("UserID $idUser");
    String url =
        ("${URLConstants.base_url}${URLConstants.user_info_social_Api}?id=$idUser");
    // debugPrint('Get Sales Token ${tokens.toString()}');
    // try {
    // } catch (e) {
    //   print('1-1-1-1 Get Purchase ${e.toString()}');
    // }

    http.Response response = await http.get(Uri.parse(url));

    print('Response request: ${response.request}');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = convert.jsonDecode(response.body);
      _loginScreenController.userInfoModel_email.value =
          UserInfoModel.fromJson(data);
      _loginScreenController
          .getUSerModelList(_loginScreenController.userInfoModel_email.value);
      if (_loginScreenController.userInfoModel_email.value.error == false) {
        debugPrint(
            '2-2-2-2-2-2 Inside the product Controller Details ${_loginScreenController.userInfoModel_email.value.data!.length}');
        _loginScreenController.isuserinfoLoading(false);
        // CommonWidget().showToaster(msg: data["success"].toString());
        return _loginScreenController.userInfoModel_email;
      } else {
        // CommonWidget().showToaster(msg: msg.toString());
        return null;
      }
    } else if (response.statusCode == 422) {
      // CommonWidget().showToaster(msg: msg.toString());
    } else if (response.statusCode == 401) {
      // CommonService().unAuthorizedUser();
    } else {
      // CommonWidget().showToaster(msg: msg.toString());
    }
  }

  AppBar buildAppBar(BuildContext context) => AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'Instagram Login',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Colors.black),
        ),
      );
}
