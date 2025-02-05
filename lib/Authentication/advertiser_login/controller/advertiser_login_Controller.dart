import 'dart:convert' as convert;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../Utils/App_utils.dart';
import '../../../Utils/toaster_widget.dart';
import '../../../custom_widget/page_loader.dart';
import '../../../dashboard/dashboard_screen.dart';
import '../../../homepage/controller/homepage_controller.dart';
import '../../../news_feed/controller/news_feed_controller.dart';
import '../../../search_screen/search__screen_controller.dart';
import '../../../settings/manage_accounts/model/PostSettingModel.dart';
import '../../../sharePreference.dart';
import '../../../shared/network/cache_helper.dart';
import '../../creator_login/controller/creator_login_controller.dart';
import '../../creator_login/model/creator_loginModel.dart';
import '../../verify_otp_auth_screen.dart';
import '../model/SendOtpModel.dart';

class Advertiser_Login_screen_controller extends GetxController {
  // RxBool isLoading = false.obs;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  LoginModel? loginModel;

  // final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  final HomepageController homepageController =
      Get.put(HomepageController(), tag: HomepageController().toString());

  final Search_screen_controller _search_screen_controller = Get.put(
      Search_screen_controller(),
      tag: Search_screen_controller().toString());
  final Creator_Login_screen_controller _creator_login_screen_controller =
      Get.put(Creator_Login_screen_controller(),
          tag: Creator_Login_screen_controller().toString());

  final NewsFeed_screen_controller news_feed_controller = Get.put(
      NewsFeed_screen_controller(),
      tag: NewsFeed_screen_controller().toString());

  Future<dynamic> checkLogin(
      {required BuildContext context, required String login_type}) async {
    debugPrint('0-0-0-0-0-0-0 username');

    showLoader(context);
    Map data = {
      'userName': usernameController.text,
      'password': passwordController.text,
      'type': login_type,
    };
    print(data);
    // String body = json.encode(data);

    var url = (URLConstants.base_url + URLConstants.loginApi);
    print("url : $url");
    print("body : $data");
    print('test_api');
    var response = await http.post(
      Uri.parse(url),
      body: data,
    );

    print(response.body);
    print(response.request);
    print(response.statusCode);
    // var final_data = jsonDecode(response.body);

    // print('final data $final_data');

    if (response.statusCode == 200) {
      // isLoading(false);
      var data = jsonDecode(response.body);
      loginModel = LoginModel.fromJson(data);
      print(loginModel);
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
        await PreferenceManager()
            .setPref(URLConstants.type, loginModel!.user![0].type!);
        await PreferenceManager()
            .setPref(URLConstants.userName, loginModel!.user![0].userName!);

        await PreferenceManager().setPref(URLConstants.social_type, "");
        await clear();

        if (loginModel!.user![0].textMessage == 'true') {
          await Get.to(const VerifyOtpAuth());
        } else {
          await clear();

          String idUser = await PreferenceManager().getPref(URLConstants.id);
          String socialTypeUser =
              await PreferenceManager().getPref(URLConstants.social_type);
          await homepageController.getAllVideosList();
          await homepageController.getAllImagesList();
          await _search_screen_controller.getDiscoverFeed(context: context);
          await news_feed_controller.getAllNewsFeedList();

          await PreferenceManager().getPref(URLConstants.social_type);
          // print("id----- $idUser");
          print("id----- $socialTypeUser");
          (socialTypeUser == ""
              ? await _creator_login_screen_controller.CreatorgetUserInfo_Email(
                  context: context, UserId: idUser)
              : await _creator_login_screen_controller.getUserInfo_social());
          // await _creator_login_screen_controller.PostToken(context: context, token: token!, userid: id_user);
          CacheHelper.saveData(key: "uId", value: loginModel!.user![0].id!);
          CacheHelper.saveData(
              key: "userName", value: loginModel!.user![0].userName!);
          hideLoader(context);
          await Get.to(Dashboard(
            page: 0,
          ));
        }

        // ///firebase calls
        // final QuerySnapshot result = await firebaseFirestore
        //     .collection(FirestoreConstants.pathUserCollection)
        //     .where(FirestoreConstants.id, isEqualTo: loginModel!.user![0].id)
        //     .get();
        // final List<DocumentSnapshot> documents = result.docs;
        //
        // DocumentSnapshot documentSnapshot = documents[0];
        // UserChat userChat = UserChat.fromDocument(documentSnapshot);
        // // Write data to local
        // SharedPreferences prefs =
        // await SharedPreferences.getInstance();
        // await prefs.setString(FirestoreConstants.id, userChat.id);
        // await prefs.setString(FirestoreConstants.nickname, userChat.nickname);
        // await prefs.setString(FirestoreConstants.photoUrl, userChat.photoUrl);
        // await prefs.setString(FirestoreConstants.aboutMe, userChat.aboutMe);

        hideLoader(context);
      } else {
        CommonWidget().showToaster(msg: data["message"]);
        hideLoader(context);
        print('Please try again');
      }
    } else {
      CommonWidget().showToaster(msg: data["message"]);

      print('Please try again');
    }
  }

  clear() {
    usernameController.clear();
    passwordController.clear();
  }

  SendOtpModel? sendOtpModel;

  Future<dynamic> send_otp_account({
    required BuildContext context,
  }) async {
    // setState(() {
    //   isclearing = true;
    // });
    debugPrint('0-0-0-0-0-0-0 token');
    String idUser = await PreferenceManager().getPref(URLConstants.id);

    var url = (URLConstants.base_url + URLConstants.send_otp_delete);

    Map data = {
      'user_id': idUser,
      // 'token': token,
    };
    print(data);
    // String body = json.encode(data);

    print("url : $url");
    print("body : $data");

    var response = await http.post(
      Uri.parse(url),
      body: data,
    );
    print(response.body);
    print(response.request);
    print(response.statusCode);
    // var final_data = jsonDecode(response.body);

    // print('final data $final_data');

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body);
      sendOtpModel = SendOtpModel.fromJson(data);

      if (sendOtpModel!.error == false) {
        // setState(() {
        //   isclearing =false;
        // });
        // logOut_function();
        CommonWidget().showToaster(msg: data["message"]);
      } else {
        // setState(() {
        //   isclearing =false;
        // });
        CommonWidget().showToaster(msg: data["message"]);
        print('Please try again');
        print('Please try again');
      }
    } else {}
  }

  PostSettingModel? verifymodel;

  Future<dynamic> VerifyOtp({
    required BuildContext context,
    required String otp,
  }) async {
    showLoader(context);
    String idUser = await PreferenceManager().getPref(URLConstants.id);
    String url = ("${URLConstants.base_url}${URLConstants.verify_otp_delete}");
    // "?privacySetting=$privacy&title=$title&userId=$id_user"
    Map data = {'otp': otp, 'user_id': idUser};
    print(data);
    // String body = json.encode(data);
    var response = await http.post(
      Uri.parse(url),
      body: data,
    );
    print('Response request: ${response.request}');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = convert.jsonDecode(response.body);
      verifymodel = PostSettingModel.fromJson(data);
      // getVideoModelList(searchlistModel);
      if (verifymodel!.error == false) {
        // hideLoader(context);
        debugPrint(
            '2-2-2-2-2-2 Inside the product Controller Details ${verifymodel!.message}');

        return verifymodel;
      } else {
        hideLoader(context);

        CommonWidget().showErrorToaster(msg: verifymodel!.message!.toString());
        // CommonWidget().showToaster(msg: msg.toString());
        return null;
      }
    } else if (response.statusCode == 422) {
      hideLoader(context);

      // CommonWidget().showToaster(msg: msg.toString());
    } else if (response.statusCode == 401) {
      hideLoader(context);

      // CommonService().unAuthorizedUser();
    } else {
      // CommonWidget().showToaster(msg: msg.toString());
    }
  }
}

class Resource {
  final Status status;

  Resource({required this.status});
}

enum Status { Success, Error, Cancelled }
