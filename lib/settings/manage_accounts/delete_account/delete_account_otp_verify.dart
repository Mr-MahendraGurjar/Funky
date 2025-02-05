import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
// import 'package:pinput/pin_put/pin_put.dart';
import 'package:pinput/pinput.dart';

import '../../../Authentication/advertiser_login/controller/advertiser_login_Controller.dart';
import '../../../Authentication/authentication_screen.dart';
import '../../../Utils/App_utils.dart';
import '../../../Utils/asset_utils.dart';
import '../../../Utils/colorUtils.dart';
import '../../../Utils/toaster_widget.dart';
import '../../../custom_widget/common_buttons.dart';
import '../../../sharePreference.dart';

class DeleteAccountOTP extends StatefulWidget {
  const DeleteAccountOTP({super.key});

  @override
  State<DeleteAccountOTP> createState() => _DeleteAccountOTPState();
}

class _DeleteAccountOTPState extends State<DeleteAccountOTP> {
  PageController? _pageController_customer;

  final TextEditingController _pinOTPController = TextEditingController();
  final FocusNode _pinOTPFocus = FocusNode();

  final BoxDecoration pinOTPDecoration = BoxDecoration(
    boxShadow: const [
      BoxShadow(
        color: Colors.black,
        blurRadius: 10,
        offset: Offset(0, 0),
        spreadRadius: -8,
      ),
    ],
    color: Colors.white,
    borderRadius: BorderRadius.circular(21),
  );
  final BoxDecoration pinOTPDecoration2 = BoxDecoration(
      boxShadow: const [
        BoxShadow(
          color: Colors.black,
          blurRadius: 10,
          offset: Offset(0, 0),
          spreadRadius: -8,
        ),
      ],
      color: Colors.white,
      borderRadius: BorderRadius.circular(21),
      border: Border.all(
        color: Colors.transparent,
      ));
  Timer? countdownTimer;
  Duration myDuration = const Duration(seconds: 30);

  void startTimer() {
    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  bool times_up = false;

  void setCountDown() {
    const reduceSecondsBy = 1;
    if (mounted) {
      setState(() {
        final seconds = myDuration.inSeconds - reduceSecondsBy;
        if (seconds < 0) {
          countdownTimer!.cancel();
          times_up = true;
          print('timesup');
        } else {
          myDuration = Duration(seconds: seconds);
        }
      });
    }
  }

  @override
  void initState() {
    init();
    _pageController_customer = PageController(initialPage: 0, keepPage: false);
    startTimer();
    super.initState();
  }

  final Advertiser_Login_screen_controller _advertiser_login_screen_controller =
      Get.put(Advertiser_Login_screen_controller(),
          tag: Advertiser_Login_screen_controller().toString());

  init() async {
    await _advertiser_login_screen_controller.send_otp_account(
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    final seconds = myDuration.inSeconds.remainder(60);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
          backgroundColor: Colors.black,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text(
              'Delete Account',
              style: TextStyle(
                  fontSize: 16, color: Colors.white, fontFamily: 'PB'),
            ),
            centerTitle: true,
            leadingWidth: 100,
            leading: Padding(
              padding: const EdgeInsets.only(
                right: 20.0,
                top: 0.0,
                bottom: 5.0,
              ),
              child: ClipRRect(
                  child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
              )),
            ),
          ),
          body: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 96,
                    ),
                    Container(
                      child: const Text(
                        'Enter Otp',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'PB',
                            color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      height: 41,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 30, right: 30),
                      child: Pinput(
                        length: 4,
                        // textStyle: TextStyle(fontFamily: 'PR', fontSize: 32, color: Colors.black),
                        // eachFieldHeight: 60,
                        // eachFieldWidth: 60,
                        // eachFieldMargin: EdgeInsets.all(7),
                        focusNode: _pinOTPFocus,
                        controller: _pinOTPController,
                        // submittedFieldDecoration: pinOTPDecoration,
                        // selectedFieldDecoration: pinOTPDecoration,
                        // followingFieldDecoration: pinOTPDecoration2,
                        pinAnimationType: PinAnimationType.rotation,
                      ),
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    Container(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$seconds',
                          style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'PB',
                              color: Colors.white),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Image.asset(
                          AssetUtils.timer_icon,
                          width: 22,
                          height: 22,
                          fit: BoxFit.fill,
                        ),
                      ],
                    )),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 20, left: 20),
                      child: common_button(
                        onTap: () async {
                          await _advertiser_login_screen_controller.VerifyOtp(
                              context: context, otp: _pinOTPController.text);
                          if (_advertiser_login_screen_controller
                                  .verifymodel!.error ==
                              false) {
                            delete_account(context: context);
                          }
                        },
                        backgroud_color: HexColor(CommonColor.pinkFont),
                        lable_text: 'Verify',
                        lable_text_color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (times_up) {
                          init();
                        }
                      },
                      child: Text(
                        'Resend',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'PB',
                            color: (times_up ? Colors.white : Colors.grey)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Future<dynamic> delete_account({
    required BuildContext context,
  }) async {
    // setState(() {
    //   isclearing = true;
    // });
    debugPrint('0-0-0-0-0-0-0 token');
    String idUser = await PreferenceManager().getPref(URLConstants.id);

    var url = (URLConstants.base_url + URLConstants.DeleteAccount);

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
      if (data["error"] == false) {
        // setState(() {
        //   isclearing =false;
        // });
        logOut_function();
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

  logOut_function() async {
    await PreferenceManager().setPref(URLConstants.id, ' ');
    await PreferenceManager().setPref(URLConstants.type, '');
    await Get.to(const AuthenticationScreen());
    setState(() {});
    CommonWidget().showToaster(msg: 'User LoggedOut');
  }
}
