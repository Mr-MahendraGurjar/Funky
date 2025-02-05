import 'dart:async';
import 'dart:convert' as convert;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:funky_new/custom_widget/page_loader.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:pinput/pinput.dart';

// import 'package:pinput/pin_put/pin_put.dart';

import '../../../Authentication/advertiser_login/controller/advertiser_login_Controller.dart';
import '../../../Utils/App_utils.dart';
import '../../../Utils/asset_utils.dart';
import '../../../Utils/colorUtils.dart';
import '../../../sharePreference.dart';
import 'controller.dart';
import 'model/getauthenticationModl.dart';

class TwoFactorAuthScreen extends StatefulWidget {
  const TwoFactorAuthScreen({super.key});

  @override
  State<TwoFactorAuthScreen> createState() => _TwoFactorAuthScreenState();
}

class _TwoFactorAuthScreenState extends State<TwoFactorAuthScreen> {
  bool whats_app = false;
  bool text_message = false;

  final Security_checkup_controller _security_checkup_controller = Get.put(
      Security_checkup_controller(),
      tag: Security_checkup_controller().toString());

  @override
  void initState() {
    getAuthenticationSettings();
    // TODO: implement initState
    super.initState();
  }

  final Advertiser_Login_screen_controller _advertiser_login_screen_controller =
      Get.put(Advertiser_Login_screen_controller(),
          tag: Advertiser_Login_screen_controller().toString());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Authentication',
          style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'PB'),
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
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 134,
                width: 134,
                child: ClipRRect(
                    // borderRadius: BorderRadius.circular(100),
                    child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        // stops: [0.1, 0.5, 0.7, 0.9],
                        colors: [
                          HexColor("#000000"),
                          HexColor("#C12265"),
                          // HexColor("#FFFFFF")
                        ],
                      ),
                      borderRadius: BorderRadius.circular(100)),
                  child: Padding(
                    padding: const EdgeInsets.all(35.0),
                    child: Image.asset(
                      AssetUtils.security_3x,
                      height: 53,
                      width: 65,
                    ),
                  ),
                )),
              ),
              const SizedBox(
                height: 51,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: const Text('WhatsApp',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontFamily: 'PR  ')),
                    ),
                    Transform.scale(
                      scale: 0.7,
                      child: Theme(
                        data: ThemeData(
                            unselectedWidgetColor:
                                HexColor(CommonColor.pinkFont)),
                        child: CupertinoSwitch(
                          value: whats_app,
                          onChanged: (value) async {
                            setState(() {
                              whats_app = value;
                              print(whats_app);
                            });
                            // await _security_checkup_controller.PostSecuritySetting(
                            //     privacy: whats_app.toString(),
                            //     title: 'text_message');
                          },
                          thumbColor: Colors.black,
                          activeColor: HexColor(CommonColor.pinkFont),
                          trackColor: HexColor(CommonColor.pinkFont_light),
                          // activeColor: HexColor(CommonColor.pinkFont),
                          // inactiveTrackColor: Colors.red[100],
                          // inactiveThumbColor: HexColor(CommonColor.pinkFont),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: const Text('Text Message',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontFamily: 'PR  ')),
                    ),
                    Transform.scale(
                      scale: 0.7,
                      child: Theme(
                        data: ThemeData(
                            unselectedWidgetColor:
                                HexColor(CommonColor.pinkFont)),
                        child: CupertinoSwitch(
                          value: text_message,
                          onChanged: (value) async {
                            // startTimer();
                            if (text_message) {
                              setState(() {
                                text_message = value;
                                print(text_message);
                              });
                              await _security_checkup_controller
                                  .PostSecuritySetting(
                                      privacy: text_message.toString(),
                                      title: 'text_message');
                            } else {
                              _scaleDialog(context: context, value1: value);

                              await _advertiser_login_screen_controller
                                  .send_otp_account(context: context);
                            }

                            // await _manage_account_controller.PostUserSetting(
                            //     privacy: ad_pers.toString(),
                            //     title: 'ads_personalization');
                          },
                          thumbColor: Colors.black,
                          activeColor: HexColor(CommonColor.pinkFont),
                          trackColor: HexColor(CommonColor.pinkFont_light),
                          // activeColor: HexColor(CommonColor.pinkFont),
                          // inactiveTrackColor: Colors.red[100],
                          // inactiveThumbColor: HexColor(CommonColor.pinkFont),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  GetAuthenticationModel? getAuthenticationModel;

  Future<dynamic> getAuthenticationSettings() async {
    String idUser = await PreferenceManager().getPref(URLConstants.id);

    String url =
        ("${URLConstants.base_url}${URLConstants.authentication_get}?user_id=$idUser");

    http.Response response = await http.get(Uri.parse(url));

    print('Response request: ${response.request}');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = convert.jsonDecode(response.body);
      getAuthenticationModel = GetAuthenticationModel.fromJson(data);
      // getVideoModelList(searchlistModel);
      if (getAuthenticationModel!.error == false) {
        debugPrint(
            '2-2-2-2-2-2 Inside the product Controller Details ${getAuthenticationModel!.data!}');

        setState(() {
          (getAuthenticationModel!.data!.textMessage == "true"
              ? text_message = true
              : text_message = false);
        });

        // CommonWidget().showToaster(msg: data["success"].toString());
        return getAuthenticationModel;
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

  Future<void> _scaleDialog(
      {required BuildContext context, required bool value1}) async {
    showGeneralDialog(
      context: context,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: GreetingsPopUp(context: context, value1: value1),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

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
    borderRadius: BorderRadius.circular(5),
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
      borderRadius: BorderRadius.circular(5),
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

  Widget GreetingsPopUp({required BuildContext context, required bool value1}) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final seconds = myDuration.inSeconds.remainder(60);

    return StatefulBuilder(// You need this, notice the parameters below:
        builder: (BuildContext context, StateSetter setState) {
      return AlertDialog(
          // insetPadding:
          // EdgeInsets.only(
          //     bottom:
          //     500,
          //     left:
          //     100),
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          elevation: 0.0,
          // title: Center(child: Text("Evaluation our APP")),
          content: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 0),
                        // height: 122,
                        width: width,
                        // height: height / 3.5,
                        // padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: const Alignment(-1.0, 0.0),
                              end: const Alignment(1.0, 0.0),
                              transform: const GradientRotation(0.7853982),
                              // stops: [0.1, 0.5, 0.7, 0.9],
                              colors: [
                                HexColor("#000000"),
                                // HexColor("#000000"),
                                HexColor(CommonColor.pinkFont),
                                // HexColor("#ffffff"),
                                // HexColor("#FFFFFF").withOpacity(0.67),
                              ],
                            ),
                            //   color: HexColor('#3b5998'),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(26.0))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 5),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 00, right: 00, top: 20, bottom: 10),
                                  child: Pinput(
                                    length: 4,
                                    // textStyle: TextStyle(fontFamily: 'PR', fontSize: 22, color: Colors.black),
                                    // eachFieldHeight: 40,
                                    // eachFieldWidth: 40,
                                    // eachFieldMargin: EdgeInsets.all(10),
                                    // eachFieldPadding: EdgeInsets.zero,
                                    focusNode: _pinOTPFocus,
                                    controller: _pinOTPController,
                                    // submittedFieldDecoration: pinOTPDecoration,
                                    // selectedFieldDecoration: pinOTPDecoration,
                                    // followingFieldDecoration: BoxDecoration(
                                    //     boxShadow: const [
                                    //       BoxShadow(
                                    //         color: Colors.black,
                                    //         blurRadius: 10,
                                    //         offset: Offset(0, 0),
                                    //         spreadRadius: -8,
                                    //       ),
                                    //     ],
                                    //     color: Colors.white,
                                    //     borderRadius: BorderRadius.circular(10),
                                    //     border: Border.all(
                                    //       color: Colors.transparent,
                                    //     )),
                                    pinAnimationType: PinAnimationType.rotation,
                                  ),
                                ),
                                // Container(
                                //   margin: EdgeInsets.symmetric(vertical: 10),
                                //     child: Row(
                                //       mainAxisAlignment: MainAxisAlignment.center,
                                //       children: [
                                //         Text(
                                //           '$seconds',
                                //           style: TextStyle(
                                //               fontSize: 16,
                                //               fontFamily: 'PB',
                                //               color: Colors.white),
                                //         ),
                                //         SizedBox(
                                //           width: 10,
                                //         ),
                                //         Image.asset(
                                //           AssetUtils.timer_icon,
                                //           width: 22,
                                //           height: 22,
                                //           fit: BoxFit.fill,
                                //         ),
                                //       ],
                                //     )),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        Navigator.pop(context);

                                        await _advertiser_login_screen_controller
                                            .VerifyOtp(
                                          context: context,
                                          otp: _pinOTPController.text,
                                        );
                                        if (_advertiser_login_screen_controller
                                                .verifymodel!.error ==
                                            false) {
                                          hideLoader(context);
                                          _pinOTPController.clear();
                                          setState(() {
                                            text_message = value1;
                                            print(text_message);
                                          });
                                          await _security_checkup_controller
                                              .PostSecuritySetting(
                                                  privacy:
                                                      text_message.toString(),
                                                  title: 'text_message');
                                        }
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.white),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 20),
                                          child: Text(
                                            'Verify',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'PR',
                                                color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 3, bottom: 3),
                        alignment: Alignment.topRight,
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.black,
                                //   gradient: LinearGradient(
                                //     begin: Alignment.centerLeft,
                                //     end: Alignment.centerRight,
                                //     // stops: [0.1, 0.5, 0.7, 0.9],
                                //     colors: [
                                //       HexColor("#36393E").withOpacity(1),
                                //       HexColor("#020204").withOpacity(1),
                                //     ],
                                //   ),
                                boxShadow: const [
                                  // BoxShadow(
                                  //     color: HexColor('#04060F'),
                                  //     offset: Offset(0, 3),
                                  //     blurRadius: 5)
                                ],
                                borderRadius: BorderRadius.circular(20)),
                            child: const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Icon(
                                Icons.cancel_outlined,
                                size: 20,
                                color: Colors.white,
                                // color: ColorUtils.primary_grey,
                              ),
                            )),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ));
    });
  }
}
