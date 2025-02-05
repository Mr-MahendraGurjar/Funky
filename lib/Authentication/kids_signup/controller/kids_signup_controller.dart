import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:funky_new/custom_widget/page_loader.dart';
// import 'package:funky_project/Authentication/kids_signup/ui/kids_otp_verification.dart';
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
import '../ui/kids_otp_verification.dart';
import '../ui/kids_signup_email_verification.dart';
import '../ui/paretns_otp_screen.dart';

class Kids_signup_controller extends GetxController {
  bool isPasswordVisible = false;

  isPasswordVisibleUpdate(bool value) {
    isPasswordVisible = value;
    update();
  }

  final Creator_Login_screen_controller _creator_login_screen_controller =
      Get.put(Creator_Login_screen_controller(),
          tag: Creator_Login_screen_controller().toString());

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
  File? imgFile;

  String selected_gender = 'male';
  String? selected_country;
  String? selected_country_code = '+91';

  // Future<dynamic> kids_signup(BuildContext context) async {
  //   debugPrint('0-0-0-0-0-0-0 username');
  //   // try {
  //   //
  //   // } catch (e) {
  //   //   print('0-0-0-0-0-0- SignIn Error :- ${e.toString()}');
  //   // }
  //   isLoading(true);
  //   Map data = {
  //     'fullName': fullname_controller.text,
  //     'userName': username_controller.text,
  //     'email': email_controller.text,
  //     'phone': phone_controller.text,
  //     'parent_email': parentEmail_controller.text,
  //     'password': password_controller.text,
  //     'gender': selected_gender,
  //     'location': location_controller.text,
  //     'referral_code': reffralCode_controller.text,
  //     'image': img64!.substring(0, 100),
  //     'countryCode': countryCode_controller.text,
  //     'about': aboutMe_controller.text,
  //     'type': 'kids',
  //   };
  //   print(data);
  //   // String body = json.encode(data);
  //
  //   var url = (URLConstants.base_url + URLConstants.SignUpApi);
  //   print("url : $url");
  //   print("body : $data");
  //
  //   var response = await http.post(
  //     Uri.parse(url),
  //     body: data,
  //   );
  //   print(response.body);
  //   print(response.request);
  //   print(response.statusCode);
  //   // var final_data = jsonDecode(response.body);
  //
  //   // print('final data $final_data');
  //
  //   if (response.statusCode == 200) {
  //     isLoading(false);
  //     var data = jsonDecode(response.body);
  //     loginModel = LoginModel.fromJson(data);
  //     print(loginModel);
  //     if (loginModel!.error == false) {
  //       print("---------${loginModel!.message}");
  //       if(loginModel!.message == 'User Already Exists'){
  //         CommonWidget().showErrorToaster(msg: loginModel!.message!);
  //       }else{
  //         CommonWidget().showToaster(msg: loginModel!.message!);
  //         Get.to(KidsOtpVerification());
  //         await KidsSendOtp(context);
  //       }
  //       // Get.to(Dashboard());
  //     } else {
  //       print('Please try again');
  //     }
  //   } else {
  //     print('Please try again');
  //   }
  // }
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

  Future<dynamic> kids_signup({required BuildContext context}) async {
    // showLoader(context);
    var url = '${URLConstants.base_url}signup.php';
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
    request.fields['parent_email'] = parentEmail_controller.text;
    request.fields['password'] = password_controller.text;
    request.fields['gender'] = selected_gender;
    request.fields['location'] = selected_country!;
    request.fields['referral_code'] = reffralCode_controller.text;
    request.fields['countryCode'] = selected_country_code!;
    request.fields['about'] = aboutMe_controller.text;
    request.fields['type'] = 'kids';

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
        } else {
          CommonWidget().showToaster(msg: loginModel!.message!);
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

          print("id----- $socialTypeUser");
          (socialTypeUser == ""
              ? await _creator_login_screen_controller.CreatorgetUserInfo_Email(
                  context: context, UserId: idUser)
              : await _creator_login_screen_controller.getUserInfo_social());

          await _creator_login_screen_controller.PostToken(
              context: context, token: token ?? "", userid: idUser);
          await _creator_signup_controller.SettingsSaveApi(idUser);
          createUserInFirebase(
              name: fullname_controller.text.trim(),
              email: email_controller.text,
              uId: idUser);
          CacheHelper.saveData(key: "uId", value: loginModel!.user![0].id!);
          CacheHelper.saveData(
              key: "userName", value: loginModel!.user![0].userName!);
          await Get.to(Dashboard(
            page: 0,
          ));
        }
        // Get.to(Dashboard());
      } else {
        print('Please try again');
      }
    } else {
      print('Please try again');
    }
  }

  RxBool isotpLoading = false.obs;
  parentsOtpModel? otpsendModel;
  String? photoBase64;
  String? img64;

  Future<dynamic> KidsSendOtp(BuildContext context) async {
    showLoader(context);

    isotpLoading(true);
    Map data = {
      'type': 'kids',
      'email': email_controller.text,
      'phone': selected_country_code! + phone_controller.text
    };
    print(data);

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
        hideLoader(context);
        CommonWidget().showToaster(msg: 'Enter Otp');
        print('EnterOtp');
        // Get.to(OtpScreen(received_otp: otpModel!.user![0].body!,));
        Get.to(() => const KidsOtpVerification());
      } else {
        hideLoader(context);
        print('Please try again');
        CommonWidget()
            .showErrorToaster(msg: otpsendModel?.message.toString() ?? "");
      }
    } else {
      hideLoader(context);
      print('Please try again');
    }
  }

  RxBool isotpVerifyLoading = false.obs;
  otpVerifyModel? otpverifyModel;
  parentsOtpModel? otpModel;

  Future<dynamic> KidsVerifyOtp(
      {required BuildContext context, required String otp_controller}) async {
    showLoader(context);
    debugPrint('0-0-0-0-0-0-0 username');
    isotpVerifyLoading(true);
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
        // _creator_login_screen_controller.CreatorgetUserInfo_Email(
        //     UserId: loginModel!.user![0].id!);
        await Get.to(const kids_signup_Email_verification());

        // await kids_signup(context: context);
        // Get.to(Dashboard());
        hideLoader(context);
      } else {
        hideLoader(context);
        print('Please try again');
        CommonWidget().showErrorToaster(msg: 'Enter valid Otp');
      }
    } else {
      hideLoader(context);
      print('Please try again');
    }
  }

  Future<dynamic> ParentEmailVerification(BuildContext context) async {
    showLoader(context);
    debugPrint('0-0-0-0-0-0-0 username');

    Map data = {
      // 'userName': usernameController.text,
      'email': parentEmail_controller.text,
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

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      otpModel = parentsOtpModel.fromJson(data);
      if (otpModel!.error == false) {
        CommonWidget().showToaster(msg: 'Enter Otp');
        print("otp ${otpModel!.user![0].body!}");
        Get.to(() => const ParentsOtpScreen());
      } else {
        hideLoader(context);
        print('Please try again');
        CommonWidget().showErrorToaster(msg: 'Enter valid Phone Number');
      }
    } else {
      hideLoader(context);
      print('Please try again');
    }
  }

  Future<dynamic> ParentsVerifyOtp(
      {required BuildContext context, required String otp_controller}) async {
    showLoader(context);
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
        await kids_signup(context: context);
        showLoader(context);
      } else {
        showLoader(context);
        print('Please try again');
        CommonWidget().showErrorToaster(msg: 'Enter valid Otp');
      }
    } else {
      showLoader(context);
      print('Please try again');
    }
  }

  countryModel? countrymodelList;
  var getAllCountriesModelList = countryModel().obs;
  RxBool iscountryLoading = false.obs;
  RxList<Data_country> data_country = <Data_country>[].obs;
  Data_country? selectedcountry;

  Future<dynamic> getAllCountriesFromAPI() async {
    print('inside country list');
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
        final status = data["success"];
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
