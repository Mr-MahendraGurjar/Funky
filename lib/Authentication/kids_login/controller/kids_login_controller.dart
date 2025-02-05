import 'dart:convert';

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:funky_project/Authentication/kids_login/ui/otp_screen.dart';
// import 'package:funky_project/Utils/toaster_widget.dart';
// import 'package:funky_project/dashboard/dashboard_screen.dart';
// import 'package:funky_project/getx_pagination/binding_utils.dart';
import 'package:get/get.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

// import 'package:twitter_login/twitter_login.dart';

import '../../../Utils/App_utils.dart';
// import '../../../homepage/model/UserInfoModel.dart';
// import '../../../sharePreference.dart';
import '../../../Utils/toaster_widget.dart';
import '../../../custom_widget/page_loader.dart';
import '../../../dashboard/dashboard_screen.dart';
import '../../../homepage/controller/homepage_controller.dart';
import '../../../homepage/model/UserInfoModel.dart';
import '../../../news_feed/controller/news_feed_controller.dart';
import '../../../search_screen/search__screen_controller.dart';
import '../../../sharePreference.dart';
import '../../../shared/network/cache_helper.dart';
import '../../creator_login/controller/creator_login_controller.dart';
import '../../creator_login/model/creator_loginModel.dart';
import '../../creator_signup/model/otpVerifyModel.dart';
import '../../verify_otp_auth_screen.dart';
import '../model/parents_otp_model.dart';
import '../ui/otp_screen.dart';

class Kids_Login_screen_controller extends GetxController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController parentMobileController = TextEditingController();
  final TextEditingController parentEmailController = TextEditingController();
  RxBool isLoginLoading = false.obs;
  LoginModel? loginModel;

  RxBool isotpLoading = false.obs;
  parentsOtpModel? otpModel;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

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

  Future<dynamic> checkLogin(
      {required BuildContext context, required String login_type}) async {
    debugPrint('0-0-0-0-0-0-0 username');
    // try {
    //
    // } catch (e) {
    //   print('0-0-0-0-0-0- SignIn Error :- ${e.toString()}');
    // }
    isLoginLoading(true);
    showLoader(context);
    Map data = {
      'userName': usernameController.text,
      'password': passwordController.text,
      'type': login_type,
    };
    print(data);
    // String body = json.encode(data);

    var url = ("${URLConstants.base_url}login.php");
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

    if (response.statusCode == 200) {
      isLoginLoading(false);
      var data = jsonDecode(response.body);
      loginModel = LoginModel.fromJson(data);
      print(loginModel);
      // print("loginModel!.user![0].id! ${loginModel!.user![0].id!}");
      if (loginModel!.error == false) {
        await PreferenceManager()
            .setPref(URLConstants.id, loginModel!.user![0].id!);
        await PreferenceManager()
            .setPref(URLConstants.type, loginModel!.user![0].type!);

        await PreferenceManager().setPref(URLConstants.social_type, "");

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
          CacheHelper.saveData(
              key: "userName", value: loginModel!.user![0].userName!);
          CacheHelper.saveData(key: "uId", value: loginModel!.user![0].id!);
          hideLoader(context);
          await Get.to(Dashboard(
            page: 0,
          ));
        }

        // String id_user = await PreferenceManager().getPref(URLConstants.id);
        // String socialTypeUser =
        //     await PreferenceManager().getPref(URLConstants.social_type);
        // await homepageController.getAllVideosList();
        // await homepageController.getAllImagesList();
        // await _search_screen_controller.getDiscoverFeed(context: context);
        // await news_feed_controller.getAllNewsFeedList();
        //
        // await PreferenceManager().getPref(URLConstants.social_type);
        // // print("id----- $idUser");
        // print("id----- $socialTypeUser");
        // (socialTypeUser == ""
        //     ? await _loginScreenController.CreatorgetUserInfo_Email(
        //         context: context, UserId: id_user)
        //     : await _loginScreenController.getUserInfo_social());
        //
        // // await _loginScreenController.PostToken(context: context, token: token!, userid: id_user);
        // //
        // // await  Navigator.pushReplacement(
        // //       context,
        // //       MaterialPageRoute(
        // //           builder: (context) =>
        // //               kids_Email_verification()));
        // await Navigator.pushReplacement(context,
        //     MaterialPageRoute(builder: (context) => Dashboard(page: 0)));
        //
        // // print(n.toString());
        // print('/////////////////////////////////////////');
        // clear();
        hideLoader(context);

        // await  Get.to(kids_Email_verification());
      } else {
        hideLoader(context);
        CommonWidget().showErrorToaster(msg: "Invalid Details");
        print('Please try again');
        print('Please try again');
      }
    } else {}
  }

  clear() {
    usernameController.clear();
    passwordController.clear();
  }

  Future<dynamic> ParentEmailVerification(BuildContext context) async {
    debugPrint('0-0-0-0-0-0-0 username');
    // try {
    //
    // } catch (e) {
    //   print('0-0-0-0-0-0- SignIn Error :- ${e.toString()}');
    // }
    isLoginLoading(true);
    Map data = {
      // 'userName': usernameController.text,
      'email': parentEmailController.text,
      // 'type': login_type,
    };
    print(data);
    // String body = json.encode(data);

    var url = (URLConstants.base_url + URLConstants.parentOtpVeri_Api);
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

    if (response.statusCode == 200) {
      isLoginLoading(false);
      var data = jsonDecode(response.body);
      otpModel = parentsOtpModel.fromJson(data);
      if (otpModel!.error == false) {
        CommonWidget().showToaster(msg: 'Enter Otp');
        print("otp ${otpModel!.user![0].body!}");
        Get.to(OtpScreen(
          received_otp: otpModel!.user![0].body!,
        ));
      } else {
        print('Please try again');
        CommonWidget().showErrorToaster(msg: 'Enter valid Phone Number');
      }
    } else {
      print('Please try again');
    }
  }

  RxBool isotpVerifyLoading = false.obs;
  otpVerifyModel? otpverifyModel;

  final Creator_Login_screen_controller _loginScreenController = Get.put(
      Creator_Login_screen_controller(),
      tag: Creator_Login_screen_controller().toString());

  Future<dynamic> ParentsVerifyOtp(
      {required BuildContext context, required String otp_controller}) async {
    debugPrint('0-0-0-0-0-0-0 username');
    isotpVerifyLoading(true);
    String idUser = await PreferenceManager().getPref(URLConstants.id);

    print("UserId $idUser");
    Map data = {
      'otp': otp_controller,
    };
    print(data);
    // String body = json.encode(data);

    var url = (URLConstants.base_url + URLConstants.creatorverify_Api);
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

    if (response.statusCode == 200) {
      isotpVerifyLoading(false);
      var data = jsonDecode(response.body);
      otpverifyModel = otpVerifyModel.fromJson(data);
      print(otpverifyModel);
      if (otpverifyModel!.error == false) {
        CommonWidget().showToaster(msg: 'Signed Up');

        await _loginScreenController.CreatorgetUserInfo_Email(
          UserId: idUser,
          context: context,
        );
      } else {
        print('Please try again');
        CommonWidget().showErrorToaster(msg: 'Enter valid Otp');
      }
    } else {
      print('Please try again');
    }
  }

  RxBool isuserinfoLoading = false.obs;
  UserInfoModel? userInfoModel_email;
  var getUSerModelList = UserInfoModel().obs;
}

class Resource {
  final Status status;

  Resource({required this.status});
}

enum Status { Success, Error, Cancelled }
