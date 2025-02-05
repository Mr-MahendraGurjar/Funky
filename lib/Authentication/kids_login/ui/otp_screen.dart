import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:funky_project/dashboard/dashboard_screen.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pinput/pinput.dart';

import '../../../Utils/asset_utils.dart';
import '../../../custom_widget/common_buttons.dart';
import '../controller/kids_login_controller.dart';

class OtpScreen extends StatefulWidget {
  final String received_otp;

  const OtpScreen({super.key, required this.received_otp});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _pinOTPController = TextEditingController();
  final FocusNode _pinOTPFocus = FocusNode();
  String? varification;

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

  void setCountDown() {
    const reduceSecondsBy = 1;
    if (mounted) {
      setState(() {
        final seconds = myDuration.inSeconds - reduceSecondsBy;
        if (seconds < 0) {
          countdownTimer!.cancel();
          print('timesup');
        } else {
          myDuration = Duration(seconds: seconds);
        }
      });
    }
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  final Kids_Login_screen_controller _kids_loginScreenController = Get.put(
      Kids_Login_screen_controller(),
      tag: Kids_Login_screen_controller().toString());

  @override
  Widget build(BuildContext context) {
    final seconds = myDuration.inSeconds.remainder(60);
    final screenwidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Container(
          // decoration: BoxDecoration(
          //
          //   image: DecorationImage(
          //     image: AssetImage(AssetUtils.backgroundImage), // <-- BACKGROUND IMAGE
          //     fit: BoxFit.cover,
          //   ),
          // ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              // stops: [0.1, 0.5, 0.7, 0.9],
              colors: [
                HexColor("#000000").withOpacity(0.67),
                HexColor("#000000").withOpacity(0.67),
                HexColor("#C12265").withOpacity(0.67),
                HexColor("#FFFFFF").withOpacity(0.67),
              ],
            ),
            image: DecorationImage(
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5), BlendMode.dstATop),
              image: const AssetImage(
                AssetUtils.backgroundImage4,
              ),
            ),
          ),
        ),
        Scaffold(
          resizeToAvoidBottomInset: false,
          // extendBodyBehindAppBar: true,
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              'Verify OTP',
              style: TextStyle(
                  fontSize: 16, fontFamily: 'PR', color: Colors.white),
            ),
            backgroundColor: Colors.transparent,
          ),
          backgroundColor: Colors.transparent,
          body: SizedBox(
            width: screenwidth,
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
                        fontSize: 16, fontFamily: 'PB', color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 41,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 30, right: 30),
                  child: Pinput(
                    length: 4,
                    // fieldsCount: 4,
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
                          fontSize: 16, fontFamily: 'PB', color: Colors.white),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Image.asset(
                      AssetUtils.timer_icon,
                      width: 22,
                      height: 20,
                      fit: BoxFit.cover,
                    ),
                  ],
                )),
                const SizedBox(
                  height: 20,
                ),
                common_button(
                  onTap: () {
                    _kids_loginScreenController.ParentsVerifyOtp(
                        context: context,
                        otp_controller: _pinOTPController.text);
                    // _kids_loginScreenController.ParentEmailVerification(context);
                  },
                  backgroud_color: Colors.black,
                  lable_text: 'Next',
                  lable_text_color: Colors.white,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
