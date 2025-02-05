import 'dart:async';

import 'package:flutter/material.dart';
import 'package:funky_new/Utils/asset_utils.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:video_player/video_player.dart';

import '../../Authentication/age_verificationScreen.dart';
import '../../homepage/controller/homepage_controller.dart';
import '../../homepage/ui/common_video_guest.dart';

class GuestScreen extends StatefulWidget {
  const GuestScreen({Key? key}) : super(key: key);

  @override
  State<GuestScreen> createState() => _GuestScreenState();
}

class _GuestScreenState extends State<GuestScreen> {
  final HomepageController homepageController = Get.put(HomepageController(), tag: HomepageController().toString());
  VideoPlayerController? _controller;

  bool _onTouch = true;

  Timer? _timer;

  @override
  void initState() {
    init();
    // **
    super.initState();
  }

  init() async {
    await homepageController.getGuestVideosList();
    await video_method();
  }

  video_method() {}

  @override
  void dispose() {
    _controller!.dispose();
    _timer?.cancel();
    super.dispose();
  }

  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: true,
            body: Obx(() => homepageController.isGuestVideoLoading.value != true
                ? Center(
                    child: PageView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: homepageController.guestVideoModel!.data!.length + 1,
                        onPageChanged: (int page) {
                          setState(() {
                            _currentPage = page;
                          });
                          print(_currentPage);
                        },
                        itemBuilder: (BuildContext context, int index) {
                          print("index $index");
                          print("lemnc ${homepageController.guestVideoModel!.data!.length}");
                          return index < homepageController.guestVideoModel!.data!.length
                              ? CommonVideoGuest(
                                  videoListModel: homepageController.guestVideoModel!.data![index],
                                  url: homepageController.guestVideoModel!.data![index].uploadVideo!,
                                  comment_count: homepageController.guestVideoModel!.data![index].commentCount!,
                                  play: true,
                                  description: homepageController.guestVideoModel!.data![index].description!,
                                  songName: homepageController.guestVideoModel!.data![index].musicName!,
                                  image_url: homepageController.guestVideoModel!.data![index].user!.image!,
                                  profile_url: homepageController.guestVideoModel!.data![index].user!.profileUrl!,
                                  singerName: (homepageController.guestVideoModel!.data![index].user!.userName == null
                                      ? ''
                                      : homepageController.guestVideoModel!.data![index].user!.userName!),
                                  video_id: homepageController.guestVideoModel!.data![index].iD!,
                                  video_like_count: homepageController.guestVideoModel!.data![index].likes!,
                                  video_like_status: homepageController.guestVideoModel!.data![index].likeStatus!,
                                )
                              : Container(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        height: MediaQuery.of(context).size.height,
                                        width: MediaQuery.of(context).size.width,
                                        child: Image.asset(
                                          AssetUtils.backgroundGuest,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _scaleDialog(context: context);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.8),
                                              borderRadius: BorderRadius.circular(100)),
                                          child: const Padding(
                                            padding: EdgeInsets.all(15.0),
                                            child: Icon(
                                              Icons.lock_outline,
                                              color: Colors.black,
                                              size: 35,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                        }),
                  )
                : Center(
                    child: Container(
                      child: Text('plaese wait'),
                    ),
                  )))
      ],
    );
  }

  Future<void> _scaleDialog({
    required BuildContext context,
  }) async {
    showGeneralDialog(
      context: context,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: GreetingsPopUp(context: context),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  Widget GreetingsPopUp({
    required BuildContext context,
  }) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
                        margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
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
                                HexColor('#000000'),
                                // HexColor("#ffffff"),
                                // HexColor("#FFFFFF").withOpacity(0.67),
                              ],
                            ),
                            //   color: HexColor('#3b5998'),
                            borderRadius: const BorderRadius.all(Radius.circular(26.0))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                          child: SizedBox(
                            height: height / 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration:
                                      BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(100)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Icon(
                                      Icons.lock_outline,
                                      color: Colors.black,
                                      size: 30,
                                    ),
                                  ),
                                ),
                                Text(
                                  "Signup for more videos",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 18, fontFamily: 'PR', color: Colors.white),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(builder: (context) => AgeVerification()));
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 5),
                                    decoration:
                                        BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                                      child: Text(
                                        'Sign up',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 15, fontFamily: 'PR', color: Colors.black),
                                      ),
                                    ),
                                  ),
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
                                boxShadow: [
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
