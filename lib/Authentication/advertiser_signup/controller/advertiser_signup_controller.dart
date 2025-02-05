import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:funky_new/custom_widget/page_loader.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../Utils/App_utils.dart';
import '../../../Utils/toaster_widget.dart';
import '../../../dashboard/dashboard_screen.dart';
import '../../../homepage/controller/homepage_controller.dart';
import '../../../news_feed/controller/news_feed_controller.dart';
import '../../../search_screen/search__screen_controller.dart';
import '../../../sharePreference.dart';
import '../../../shared/network/cache_helper.dart';
import '../../creator_login/controller/creator_login_controller.dart';
import '../../creator_login/model/creator_loginModel.dart';
import '../../creator_signup/controller/creator_signup_controller.dart';
import '../../creator_signup/model/countryModelclass.dart';
import '../../creator_signup/model/otpVerifyModel.dart';
import '../../kids_login/model/parents_otp_model.dart';
import '../ui/advertisor_otp_verification.dart';

class Advertiser_signup_controller extends GetxController {
  TextEditingController fullname_controller = TextEditingController();
  TextEditingController username_controller = TextEditingController();
  TextEditingController email_controller = TextEditingController();
  TextEditingController phone_controller = TextEditingController();
  TextEditingController parentEmail_controller = TextEditingController();
  TextEditingController password_controller = TextEditingController();
  TextEditingController confirm_password_controller = TextEditingController();
  TextEditingController location_controller = TextEditingController();
  TextEditingController gender_controller = TextEditingController();
  TextEditingController reffralCode_controller = TextEditingController();
  TextEditingController countryCode_controller = TextEditingController();
  TextEditingController aboutMe_controller = TextEditingController();

  RxBool isLoading = false.obs;
  LoginModel? loginModel;
  String? selected_gender;

  String? selected_country;
  String? selected_country_code = '+91';

  final Creator_Login_screen_controller _creator_login_screen_controller =
      Get.put(Creator_Login_screen_controller(),
          tag: Creator_Login_screen_controller().toString());

  File? imgFile;

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  final HomepageController homepageController =
      Get.put(HomepageController(), tag: HomepageController().toString());

  final Search_screen_controller _search_screen_controller = Get.put(
      Search_screen_controller(),
      tag: Search_screen_controller().toString());

  final NewsFeed_screen_controller news_feed_controller = Get.put(
      NewsFeed_screen_controller(),
      tag: NewsFeed_screen_controller().toString());
  String? token;

  void pushFCMtoken() async {
    FirebaseMessaging.instance.getToken().then((value) {
      // setState(() {
      token = value;
      // });
    });
  }

  final Creator_signup_controller _creator_signup_controller = Get.put(
      Creator_signup_controller(),
      tag: Creator_signup_controller().toString());

  Future<dynamic> Advertiser_signup({required BuildContext context}) async {
    // showLoader(context);
    var url = URLConstants.base_url + URLConstants.SignUpApi;
    var request = http.MultipartRequest('POST', Uri.parse(url));
    // List<int> imageBytes = imgFile!.readAsBytesSync();
    // String baseimage = base64Encode(imageBytes);

    if (imgFile != null) {
      var files = http.MultipartFile(
          'image',
          File(imgFile!.path).readAsBytes().asStream(),
          File(imgFile!.path).lengthSync(),
          filename: imgFile!.path.split("/").last);
      request.files.add(files);
    }
    request.fields['fullName'] = fullname_controller.text;
    request.fields['userName'] = username_controller.text;
    request.fields['email'] = email_controller.text;
    request.fields['phone'] = phone_controller.text;
    request.fields['password'] = password_controller.text;
    request.fields['gender'] = gender_controller.text;
    request.fields['location'] = selected_country!;
    request.fields['referral_code'] = reffralCode_controller.text;
    request.fields['countryCode'] = selected_country_code!;
    request.fields['about'] = aboutMe_controller.text;
    request.fields['type'] = 'Advertiser';

    //userId,tagLine,description,address,postImage,uploadVideo,isVideo
    // request.files.add(await http.MultipartFile.fromPath(
    //     "image", widget.ImageFile.path));

    var response = await request.send();
    var responsed = await http.Response.fromStream(response);
    print(response.statusCode);
    print("response - ${response.statusCode}");

    if (response.statusCode == 200) {
      isLoading(false);
      var data = jsonDecode(responsed.body);
      loginModel = LoginModel.fromJson(data);
      print(loginModel);
      if (loginModel!.error == false) {
        if (loginModel!.message == 'User Already Exists') {
          CommonWidget().showErrorToaster(msg: loginModel!.message!);
          print(loginModel!.message!);
          CacheHelper.saveData(key: "uId", value: loginModel!.user![0].id!);
          CacheHelper.saveData(
              key: "userName", value: loginModel!.user![0].userName!);
          await Get.to(Dashboard(page: 0));
        } else {
          CommonWidget().showToaster(msg: loginModel!.message!);
          print(loginModel!.message!);

          await PreferenceManager()
              .setPref(URLConstants.id, loginModel!.user![0].id!);
          await PreferenceManager()
              .setPref(URLConstants.type, loginModel!.user![0].type!);

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

          await _creator_login_screen_controller.PostToken(
              context: context,
              token: FirebaseMessaging.instance.getToken().toString(),
              userid: idUser);
          await _creator_signup_controller.SettingsSaveApi(idUser);
          createUserInFirebase(
              name: fullname_controller.text.trim(),
              email: email_controller.text,
              uId: idUser);
          CacheHelper.saveData(key: "uId", value: loginModel!.user![0].id!);
          CacheHelper.saveData(
              key: "userName", value: loginModel!.user![0].userName!);

          await Get.to(Dashboard(page: 0));
        }
        // Get.to(Dashboard());
      } else {
        print('Please try again');
      }
    } else {
      print('Please try again');
    }
  }

  String? photoBase64;
  String? img64;

  RxBool isotpVerifyLoading = false.obs;
  RxBool isotpLoading = false.obs;

  otpVerifyModel? otpverifyModel;
  parentsOtpModel? otpsendModel;

  Future<dynamic> AdvertisorsendOtp(BuildContext context) async {
    showLoader(context);
    debugPrint('0-0-0-0-0-0-0 username');
    isotpLoading(true);
    Map data = {
      'type': 'Advertiser',
      'email': email_controller.text,
      'phone': selected_country_code! + phone_controller.text
    };
    print(data);
    // String body = json.encode(data);

    var url = (URLConstants.base_url + URLConstants.creatorsend_Api);
    print("url : $url");
    print("body : $data");

    var response = await http.post(
      Uri.parse(url),
      body: data,
    );
    print(response.body);
    print(response.request);
    print(response.statusCode);

    if (response.statusCode == 200) {
      isotpLoading(false);
      var data = jsonDecode(response.body);
      otpsendModel = parentsOtpModel.fromJson(data);
      print(loginModel);
      if (otpsendModel!.error == false) {
        CommonWidget().showToaster(msg: 'Enter Otp');
        Get.to(const AdvertisorOtpVerification());
      } else {
        print('Please try again');
        CommonWidget()
            .showErrorToaster(msg: otpsendModel?.message.toString() ?? "");
      }
    } else {
      print('Please try again');
    }
  }

  Future<dynamic> AdvertisorVerifyOtp(
      {required BuildContext context, required String otp_controller}) async {
    debugPrint('0-0-0-0-0-0-0 username');
    isotpVerifyLoading(true);
    Map data = {
      'otp': otp_controller,
    };
    print(data);

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

    if (response.statusCode == 200) {
      isotpVerifyLoading(false);
      var data = jsonDecode(response.body);
      otpverifyModel = otpVerifyModel.fromJson(data);
      print(otpverifyModel);
      if (otpverifyModel!.error == false) {
        CommonWidget().showToaster(msg: otpverifyModel!.message!);
        await Advertiser_signup(context: context);
      } else {
        print('Please try again');
        CommonWidget().showErrorToaster(msg: 'Enter valid Otp');
      }
    } else {
      hideLoader(context);
      print('Please try again');
    }
  }

  countryModel? countrymodelList;
  var getAllCountriesModelList = countryModel().obs;
  RxBool iscountryLoading = false.obs;
  RxList<Data_country> data_country = <Data_country>[].obs;
  Data_country? selectedcountry;

  Future<dynamic> getAllCountriesFromAPI() async {
    iscountryLoading(true);
    String url = (URLConstants.base_url + URLConstants.CountryListApi);

    // debugPrint('Get Sales Token ${tokens.toString()}');
    try {
      http.Response response = await http.get(Uri.parse(url));

      print('Response request: ${response.request}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // final status = data["success"];
        countrymodelList = countryModel.fromJson(data);
        getAllCountriesModelList(countrymodelList);
        if (countrymodelList!.error == false) {
          debugPrint(
              '2-2-2-2-2-2 Inside the product Controller Details ${countrymodelList!.data!.length}');
          iscountryLoading(false);
          data_country = getAllCountriesModelList.value.data!.obs;
          print("data $data_country");
          return countrymodelList;
        } else {
          CommonWidget().showToaster(msg: 'Error');
          return null;
        }
      } else if (response.statusCode == 422) {
        CommonWidget().showToaster(msg: "Error 422");
      } else {
        CommonWidget().showToaster(msg: '');
      }
    } catch (e) {
      print('1-1-1-1 Get Purchase ${e.toString()}');
    }
  }
}
