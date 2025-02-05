import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pinput/pinput.dart';

import '../../../Utils/asset_utils.dart';
import '../../../Utils/toaster_widget.dart';
import '../../../custom_widget/common_buttons.dart';
import '../controller/password_reset_controller.dart';

class Password_otp_verification extends StatefulWidget {
  const Password_otp_verification({super.key});

  @override
  State<Password_otp_verification> createState() =>
      _Password_otp_verificationState();
}

class _Password_otp_verificationState extends State<Password_otp_verification> {
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
    setState(() {
      final seconds = myDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        countdownTimer!.cancel();
        print('setCountDown');
      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  final password_reset_controller _password_reset_controller = Get.put(
      password_reset_controller(),
      tag: password_reset_controller().toString());

  @override
  Widget build(BuildContext context) {
    var seconds = myDuration.inSeconds.remainder(60);
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
        GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            // extendBodyBehindAppBar: true,
            appBar: AppBar(
              centerTitle: true,
              title: const Text(
                'Forgot Password ?',
                style: TextStyle(
                    fontSize: 16, fontFamily: 'PR', color: Colors.white),
              ),
              backgroundColor: Colors.transparent,
            ),
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: SizedBox(
                width: screenwidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      // color: Colors.red,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 86, vertical: 10),
                      child: Image.asset(
                        AssetUtils.logo,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      child: const Text(
                        'Enter OTP ',
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
                        focusNode: _pinOTPFocus,
                        controller: _pinOTPController,
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
                        Container(
                          child: Text(
                            '$seconds',
                            style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'PB',
                                color: Colors.white),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Image.asset(
                          AssetUtils.timer_icon,
                          width: 22,
                          height: 20,
                          fit: BoxFit.contain,
                        ),
                      ],
                    )),
                    const SizedBox(
                      height: 20,
                    ),
                    Obx(
                      () => _password_reset_controller.isotpVerifyLoading.value
                          ? const CircularProgressIndicator()
                          : common_button(
                              onTap: () async {
                                // showLoader(context);
                                if (_pinOTPController.text.isEmpty ||
                                    _pinOTPController.text.length < 4) {
                                  CommonWidget().showErrorToaster(
                                      msg: 'Please enter Otp');
                                } else {
                                  await _password_reset_controller
                                      .pass_reset_VerifyOtp(
                                          context: context,
                                          otp_controller:
                                              _pinOTPController.text);
                                }
                              },
                              backgroud_color: Colors.black,
                              lable_text: 'Next',
                              lable_text_color: Colors.white,
                            ),
                    ),
                    TextButton(
                      onPressed: () {
                        print('resend');
                        countdownTimer?.cancel();

                        myDuration = const Duration(seconds: 30);
                        startTimer();
                      },
                      child: const Text(
                        'Resend',
                        style: TextStyle(color: Colors.black),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
