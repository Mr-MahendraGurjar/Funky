import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:funky_new/custom_widget/page_loader.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pinput/pinput.dart';

import '../../../Utils/asset_utils.dart';
import '../../../Utils/colorUtils.dart';
import '../../../custom_widget/common_buttons.dart';
import '../../../dashboard/dashboard_screen.dart';
import '../Utils/App_utils.dart';
import '../homepage/controller/homepage_controller.dart';
import '../news_feed/controller/news_feed_controller.dart';
import '../search_screen/search__screen_controller.dart';
import '../sharePreference.dart';
import 'advertiser_login/controller/advertiser_login_Controller.dart';
import 'creator_login/controller/creator_login_controller.dart';
import 'kids_login/controller/kids_login_controller.dart';

class VerifyOtpAuth extends StatefulWidget {
  const VerifyOtpAuth({super.key});

  @override
  State<VerifyOtpAuth> createState() => _VerifyOtpAuthState();
}

class _VerifyOtpAuthState extends State<VerifyOtpAuth> {
  PageController? _pageController_customer;

  bool times_up = false;

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
    _pageController_customer = PageController(initialPage: 0, keepPage: false);
    startTimer();
    super.initState();
  }

  final Creator_Login_screen_controller _creator_login_screen_controller =
      Get.put(Creator_Login_screen_controller(),
          tag: Creator_Login_screen_controller().toString());

  final HomepageController homepageController =
      Get.put(HomepageController(), tag: HomepageController().toString());

  final Search_screen_controller _search_screen_controller = Get.put(
      Search_screen_controller(),
      tag: Search_screen_controller().toString());

  final NewsFeed_screen_controller news_feed_controller = Get.put(
      NewsFeed_screen_controller(),
      tag: NewsFeed_screen_controller().toString());

  final Kids_Login_screen_controller _kids_loginScreenController = Get.put(
      Kids_Login_screen_controller(),
      tag: Kids_Login_screen_controller().toString());

  final Advertiser_Login_screen_controller _advertiser_login_screen_controller =
      Get.put(Advertiser_Login_screen_controller(),
          tag: Advertiser_Login_screen_controller().toString());

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
              'Login',
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
                    //
                    // GestureDetector(
                    //   onTap: (){
                    //     if(times_up){
                    //       _advertiser_login_screen_controller.send_otp_account(context: context);
                    //     }
                    //   },
                    //   child: Text(
                    //     'Resend',
                    //     style: TextStyle(
                    //         fontSize: 16,
                    //         fontFamily: 'PB',
                    //         color:(times_up ? Colors.white: Colors.grey)),
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    Container(
                      margin: const EdgeInsets.only(right: 20, left: 20),
                      child: common_button(
                        onTap: () async {
                          await _advertiser_login_screen_controller.VerifyOtp(
                              context: context, otp: _pinOTPController.text);
                          if (_advertiser_login_screen_controller
                                  .verifymodel!.error ==
                              false) {
                            // await _creator_login_screen_controller.CreatorgetUserInfo_Email(
                            //     context: context,
                            //     UserId: _advertiser_login_screen_controller.loginModel!.user![0].id!);

                            await _advertiser_login_screen_controller.clear();
                            await _creator_login_screen_controller.clear();
                            await _kids_loginScreenController.clear();

                            String idUser = await PreferenceManager()
                                .getPref(URLConstants.id);
                            String socialTypeUser = await PreferenceManager()
                                .getPref(URLConstants.social_type);
                            await homepageController.getAllVideosList();
                            await homepageController.getAllImagesList();
                            await _search_screen_controller.getDiscoverFeed(
                                context: context);
                            await news_feed_controller.getAllNewsFeedList();

                            await PreferenceManager()
                                .getPref(URLConstants.social_type);
                            // print("id----- $idUser");
                            print("id----- $socialTypeUser");
                            (socialTypeUser == ""
                                ? await _creator_login_screen_controller
                                    .CreatorgetUserInfo_Email(
                                        context: context, UserId: idUser)
                                : await _creator_login_screen_controller
                                    .getUserInfo_social());
                            // await _creator_login_screen_controller.PostToken(context: context, token: token!, userid: id_user);

                            hideLoader(context);
                            await Get.to(Dashboard(
                              page: 0,
                            ));
                          }
                        },
                        backgroud_color: HexColor(CommonColor.pinkFont),
                        lable_text: 'Verify',
                        lable_text_color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  selectTowerBottomSheet(BuildContext context) {
    final screenheight = MediaQuery.of(context).size.height;
    final screenwidth = MediaQuery.of(context).size.width;
    showModalBottomSheet(
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: StatefulBuilder(
            builder: (context, state) {
              return Container(
                height: screenheight * 0.43,
                width: screenwidth,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    // stops: [0.1, 0.5, 0.7, 0.9],
                    colors: [
                      HexColor("#C12265"),
                      HexColor("#000000"),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 23.9),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(23),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Icon(
                            Icons.check,
                            size: 40,
                          ),
                        ),
                      ),
                      Container(
                        child: const Text(
                          'Your email has been updated',
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'PR',
                              color: Colors.white),
                        ),
                      ),
                      Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 40),
                          child: common_button(
                            onTap: () {
                              Get.to(Dashboard(page: 0));
                              // selectTowerBottomSheet(context);
                              // _kids_loginScreenController.ParentEmailVerification(context);
                            },
                            backgroud_color: Colors.white,
                            lable_text: 'Ge to Dashboard',
                            lable_text_color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
