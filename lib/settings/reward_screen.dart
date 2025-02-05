import 'package:flutter/material.dart';
import 'package:funky_new/Utils/asset_utils.dart';
import 'package:funky_new/Utils/colorUtils.dart';
import 'package:funky_new/custom_widget/page_loader.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../Utils/App_utils.dart';
import '../dashboard/dashboard_screen.dart';
import '../services/stripe_service.dart';
import '../sharePreference.dart';
import 'controller.dart';

class RewardScreen extends StatefulWidget {
  const RewardScreen({super.key});

  @override
  State<RewardScreen> createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> {
  Route _createQrRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          Dashboard(page: 0),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  final Settings_screen_controller _settings_screen_controller = Get.put(
      Settings_screen_controller(),
      tag: Settings_screen_controller().toString());

  @override
  void initState() {
    super.initState();
  }

  init() async {
    String idUser = await PreferenceManager().getPref(URLConstants.id);

    await _settings_screen_controller.getRewardList(userId: idUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Reward',
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
              Navigator.of(context).push(_createQrRoute());
              // Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          )),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 25),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: const Text(
                  'Your balance',
                  style: TextStyle(
                      fontSize: 15, color: Colors.pink, fontFamily: 'PB'),
                ),
              ),
              Obx(
                () => _settings_screen_controller.isRewardLoading.value == true
                    ? Container(
                        color: Colors.transparent,
                        height: 80,
                        width: 200,
                        child: Container(
                          color: Colors.transparent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                // color: Colors.pink,
                                backgroundColor: HexColor(CommonColor.pinkFont),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.white70, //<-- SEE HERE
                                ),
                              ),
                              // Text('Loading...',style: TextStyle(color: Colors.white,fontSize: 18,fontFamily: 'PR'),)
                            ],
                          ),
                        )
                        // Material(
                        //   color: Colors.transparent,
                        //   child: LoadingIndicator(
                        //     backgroundColor: Colors.transparent,
                        //     indicatorType: Indicator.ballScale,
                        //     colors: _kDefaultRainbowColors,
                        //     strokeWidth: 4.0,
                        //     pathBackgroundColor: Colors.yellow,
                        //     // showPathBackground ? Colors.black45 : null,
                        //   ),
                        // ),
                        )
                    : Container(
                        margin: const EdgeInsets.symmetric(vertical: 30),
                        child: Text(
                          '${_settings_screen_controller.getRewardModel!.totalReward} Funky Coins',
                          style: const TextStyle(
                              fontSize: 18,
                              color: Colors.green,
                              fontFamily: 'PM'),
                        ),
                      ),
              ),
              InkWell(
                onTap: () async {
                  showLoader(context);
                  await StripePaymentHandle.stripeMakePayment();
                  hideLoader(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: HexColor(CommonColor.pinkFont)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Add money to account',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontFamily: 'PM'),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Container(
                          child: const Icon(
                            Icons.add_circle_outline,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 30),
                child: Row(
                  children: [
                    Container(
                      child: Image.asset(
                        AssetUtils.rewardsIcons,
                        scale: 2.5,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'Reward History',
                      style: TextStyle(
                          fontSize: 15, color: Colors.pink, fontFamily: 'PM'),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Competition video',
                      style: TextStyle(
                          fontSize: 15, color: Colors.white, fontFamily: 'PM'),
                    ),
                    Text(
                      '20 USD',
                      style: TextStyle(
                          fontSize: 15, color: Colors.yellow, fontFamily: 'PM'),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Video people like',
                      style: TextStyle(
                          fontSize: 15, color: Colors.white, fontFamily: 'PM'),
                    ),
                    Text(
                      '20 USD',
                      style: TextStyle(
                          fontSize: 15, color: Colors.yellow, fontFamily: 'PM'),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Post explore',
                      style: TextStyle(
                          fontSize: 15, color: Colors.white, fontFamily: 'PM'),
                    ),
                    Text(
                      '20 USD',
                      style: TextStyle(
                          fontSize: 15, color: Colors.yellow, fontFamily: 'PM'),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 1),
                      borderRadius: BorderRadius.circular(30)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Container(
                          child: const Text(
                            'Fill up Stripe details',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontFamily: 'PM'),
                          ),
                        ),
                        Image.asset(AssetUtils.advertisor_stripe),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
