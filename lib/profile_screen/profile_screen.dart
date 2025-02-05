import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:funky_new/custom_widget/page_loader.dart';
import 'package:funky_new/profile_screen/story_view/storyView.dart';
import 'package:funky_new/profile_screen/story_view/view_selected_image.dart';
import 'package:funky_new/profile_screen/tagged_posts_screen.dart';
import 'package:funky_new/profile_screen/viewVideoPosr.dart';
import 'package:funky_new/video_recorder/lib/main.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:marquee/marquee.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sms_mms/sms_mms.dart';

// import 'package:social_share/social_share.dart';
import 'package:telegram/telegram.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Authentication/creator_login/controller/creator_login_controller.dart';
import '../Utils/App_utils.dart';
import '../Utils/asset_utils.dart';
import '../Utils/colorUtils.dart';
import '../Utils/toaster_widget.dart';
import '../custom_widget/common_buttons.dart';
import '../custom_widget/loader_page.dart';
import '../dashboard/post_story_screen.dart';
import '../dashboard/story_/story_image_preview.dart';
import '../settings/analytics_screen.dart';
import '../settings/controller.dart';
import '../sharePreference.dart';
import 'edit_profile_screen.dart';
import 'followers_screen.dart';
import 'following_screen.dart';
import 'imagePostScreen.dart';
import 'music_player.dart';
import 'profile_controller.dart';

class Profile_Screen extends StatefulWidget {
  const Profile_Screen({super.key});

  @override
  State<Profile_Screen> createState() => _Profile_ScreenState();
}

class _Profile_ScreenState extends State<Profile_Screen> with SingleTickerProviderStateMixin {
  final Creator_Login_screen_controller _creator_login_screen_controller =
      Get.put(Creator_Login_screen_controller(), tag: Creator_Login_screen_controller().toString());

  final Settings_screen_controller _settings_screen_controller =
      Get.put(Settings_screen_controller(), tag: Settings_screen_controller().toString());

  final Profile_screen_controller _profile_screen_controller =
      Get.put(Profile_screen_controller(), tag: Profile_screen_controller().toString());

  @override
  void initState() {
    init();
    _tabController = TabController(length: 5, vsync: this);
    super.initState();
  }

  static String? idUserType;

  init() async {
    String idUser = await PreferenceManager().getPref(URLConstants.id);
    String Type_ = await PreferenceManager().getPref(URLConstants.type);
    setState(() {
      idUserType = Type_;
    });
    print("idUserType $idUserType");

    await _profile_screen_controller.get_story_list(context: context, user_id: idUser, login_user_id: idUser);
    await _profile_screen_controller.get_video_list(context: context, user_id: idUser, login_user_id: idUser);
    await _profile_screen_controller.get_gallery_list(
        context: context, user_id: idUser, login_user_id: idUser);
    await _profile_screen_controller.get_tagged_list(context: context, user_id: idUser);
    await _profile_screen_controller.get_posted_music(context: context, user_id: idUser);
    await _profile_screen_controller.get_purchase_music(context: context, user_id: idUser);
    await _settings_screen_controller.getRewardList(userId: idUser);

    await _profile_screen_controller.get_brand_logo(context: context, user_id: idUser);
    await _profile_screen_controller.get_banner_list(context: context, user_id: idUser);
  }

  int index = 0;

  List Story_img = [
    AssetUtils.story_image1,
    AssetUtils.story_image2,
    AssetUtils.story_image3,
    AssetUtils.story_image4,
  ];
  List image_list = [
    AssetUtils.image1,
    AssetUtils.image2,
    AssetUtils.image3,
    AssetUtils.image4,
    AssetUtils.image5,
  ];
  TabController? _tabController;
  final List<Tab> _tabs = [
    Tab(
      iconMargin: const EdgeInsets.all(5),
      height: 75,
      icon: Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: HexColor(CommonColor.blue),
                // spreadRadius: 5,
                blurRadius: 6,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              // stops: [0.1, 0.5, 0.7, 0.9],
              colors: [
                HexColor("#000000"),
                HexColor("#C12265"),
              ],
            ),
            border: Border.all(color: HexColor(CommonColor.blue), width: 1.5)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            AssetUtils.story1,
            height: 25,
            width: 25,
            color: HexColor(CommonColor.blue),
          ),
        ),
      ),
    ),
    Tab(
      iconMargin: const EdgeInsets.all(5),
      height: 75,
      icon: Container(
        // margin: EdgeInsets.only(top: 20),
        height: 45,
        width: 45,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: HexColor(CommonColor.green),
                // spreadRadius: 5,
                blurRadius: 6,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                HexColor("#000000"),
                HexColor("#C12265"),
              ],
            ),
            border: Border.all(color: HexColor(CommonColor.green), width: 1.5)),
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              AssetUtils.story2,
              height: 25,
              width: 25,
              color: HexColor(CommonColor.green),
            )),
      ),
    ),
    Tab(
      iconMargin: const EdgeInsets.all(5),
      height: 75,
      icon: Container(
        // margin: EdgeInsets.only(top: 20),
        height: 45,
        width: 45,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: HexColor(CommonColor.tile),
                // spreadRadius: 5,
                blurRadius: 6,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              // stops: [0.1, 0.5, 0.7, 0.9],
              colors: [
                HexColor("#000000"),
                HexColor("#C12265"),
                // HexColor("#FFFFFF").withOpacity(0.67),
              ],
            ),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: HexColor(CommonColor.tile), width: 1.5)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            AssetUtils.story3,
            height: 25,
            width: 25,
            color: HexColor(CommonColor.tile),
          ),
        ),
      ),
    ),
    Tab(
      iconMargin: const EdgeInsets.all(5),
      height: 75,
      icon: Container(
        // margin: EdgeInsets.only(top: 20),
        height: 45,
        width: 45,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: HexColor(CommonColor.orange),
                // spreadRadius: 5,
                blurRadius: 6,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              // stops: [0.1, 0.5, 0.7, 0.9],
              colors: [
                HexColor("#000000"),
                HexColor("#C12265"),
                // HexColor("#FFFFFF").withOpacity(0.67),
              ],
            ),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: HexColor(CommonColor.orange), width: 1.5)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            AssetUtils.story4,
            height: 25,
            width: 25,
            color: HexColor(CommonColor.orange),
          ),
        ),
      ),
    ),
    Tab(
      iconMargin: const EdgeInsets.all(5),
      height: 75,
      icon: Container(
        // margin: EdgeInsets.only(top: 20),
        height: 45,
        width: 45,
        decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Colors.white,
                // spreadRadius: 5,
                blurRadius: 6,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              // stops: [0.1, 0.5, 0.7, 0.9],
              colors: [
                HexColor("#000000"),
                HexColor("#C12265"),
                // HexColor("#FFFFFF").withOpacity(0.67),
              ],
            ),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.white, width: 1.5)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            AssetUtils.story5,
            height: 25,
            width: 25,
            color: Colors.white,
          ),
        ),
      ),
    ),
  ];

  final List<Tab> _tabs2 = [
    Tab(
      iconMargin: const EdgeInsets.all(5),
      height: 75,
      icon: Container(
        // margin: EdgeInsets.only(top: 40),
        height: 45,
        width: 45,
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: HexColor(CommonColor.blue),
                // spreadRadius: 5,
                blurRadius: 6,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              // stops: [0.1, 0.5, 0.7, 0.9],
              colors: [
                HexColor("#000000"),
                HexColor("#C12265"),
                // HexColor("#FFFFFF").withOpacity(0.67),
              ],
            ),
            border: Border.all(color: HexColor(CommonColor.blue), width: 1.5)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            AssetUtils.story1,
            height: 25,
            width: 25,
            color: HexColor(CommonColor.blue),
          ),
        ),
      ),
    ),
    Tab(
      iconMargin: const EdgeInsets.all(5),
      height: 75,
      icon: Container(
        // margin: EdgeInsets.only(top: 20),
        height: 45,
        width: 45,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: HexColor(CommonColor.green),
                // spreadRadius: 5,
                blurRadius: 6,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              // stops: [0.1, 0.5, 0.7, 0.9],
              colors: [
                HexColor("#000000"),
                HexColor("#C12265"),
                // HexColor("#FFFFFF").withOpacity(0.67),
              ],
            ),
            border: Border.all(color: HexColor(CommonColor.green), width: 1.5)),
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              AssetUtils.brand_logo,
              height: 25,
              width: 25,
              // color: HexColor(CommonColor.green),
            )),
      ),
    ),
    Tab(
      iconMargin: const EdgeInsets.all(5),
      height: 75,
      icon: Container(
        // margin: EdgeInsets.only(top: 20),
        height: 45,
        width: 45,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: HexColor(CommonColor.tile),
                // spreadRadius: 5,
                blurRadius: 6,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              // stops: [0.1, 0.5, 0.7, 0.9],
              colors: [
                HexColor("#000000"),
                HexColor("#C12265"),
                // HexColor("#FFFFFF").withOpacity(0.67),
              ],
            ),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: HexColor(CommonColor.tile), width: 1.5)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            AssetUtils.banner,
            height: 25,
            width: 25,
            // color: HexColor(CommonColor.tile),
          ),
        ),
      ),
    ),
    Tab(
      iconMargin: const EdgeInsets.all(5),
      height: 75,
      icon: Container(
        // margin: EdgeInsets.only(top: 20),
        height: 45,
        width: 45,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: HexColor(CommonColor.orange),
                // spreadRadius: 5,
                blurRadius: 6,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              // stops: [0.1, 0.5, 0.7, 0.9],
              colors: [
                HexColor("#000000"),
                HexColor("#C12265"),
                // HexColor("#FFFFFF").withOpacity(0.67),
              ],
            ),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: HexColor(CommonColor.orange), width: 1.5)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            AssetUtils.story4,
            height: 25,
            width: 25,
            color: HexColor(CommonColor.orange),
          ),
        ),
      ),
    ),
    Tab(
      iconMargin: const EdgeInsets.all(5),
      height: 75,
      icon: Container(
        // margin: EdgeInsets.only(top: 20),
        height: 45,
        width: 45,
        decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Colors.white,
                // spreadRadius: 5,
                blurRadius: 6,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              // stops: [0.1, 0.5, 0.7, 0.9],
              colors: [
                HexColor("#000000"),
                HexColor("#C12265"),
                // HexColor("#FFFFFF").withOpacity(0.67),
              ],
            ),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.white, width: 1.5)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            AssetUtils.story5,
            height: 25,
            width: 25,
            color: Colors.white,
          ),
        ),
      ),
    ),
  ];

  void facebook_pop() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double width = MediaQuery.of(context).size.width;
        double height = MediaQuery.of(context).size.height;
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AlertDialog(
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
              content: Container(
                margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                // height: 122,
                width: width,
                height: height / 3.5,
                // padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    // gradient: LinearGradient(
                    //   begin: Alignment(
                    //       -1.0,
                    //       0.0),
                    //   end: Alignment(
                    //       1.0,
                    //       0.0),
                    //   transform:
                    //   GradientRotation(0.7853982),
                    //   // stops: [0.1, 0.5, 0.7, 0.9],
                    //   colors: [
                    //     HexColor("#000000"),
                    //     HexColor("#000000"),
                    //     HexColor("##E84F90"),
                    //     // HexColor("#ffffff"),
                    //     // HexColor("#FFFFFF").withOpacity(0.67),
                    //   ],
                    // ),
                    color: HexColor('#3b5998'),
                    borderRadius: const BorderRadius.all(Radius.circular(26.0))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Facebook',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, fontFamily: 'PB', color: Colors.white),
                        ),
                        Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                            height: 45,
                            child: TextField(
                              controller: _creator_login_screen_controller.facebook_link_controller,
                              style: const TextStyle(fontSize: 15, fontFamily: 'PR', color: Colors.white),
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                                hintText: 'Enter Profile link',
                                hintStyle: TextStyle(fontSize: 15, fontFamily: 'PR', color: Colors.white),
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white, width: 1),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white, width: 1),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                border: InputBorder.none,
                              ),
                              onChanged: (text) {
                                setState(() {
                                  // fullName = text;
                                  //you can access nameController in its scope to get
                                  // the value of text entered as shown below
                                  //fullName = nameController.text;
                                });
                              },
                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                update_link_facebook(
                                    context: context,
                                    facebook_link:
                                        _creator_login_screen_controller.facebook_link_controller.text,
                                    index: 0);
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20), color: Colors.white),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                                  child: Text(
                                    'Update',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 15, fontFamily: 'PM', color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _launchUrl(_creator_login_screen_controller
                                    .userInfoModel_email.value.data![0].facebookLinks!);
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20), color: Colors.white),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                                  child: Text(
                                    'Open Link',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 15, fontFamily: 'PM', color: Colors.black),
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
              )),
        );
      },
    );
  }

  void drop_down_pop({
    required String title,
    required TextEditingController controller,
    HexColor? back_color,
    required GestureTapCallback? onTap,
    required GestureTapCallback? onLinkTap,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double width = MediaQuery.of(context).size.width;
        double height = MediaQuery.of(context).size.height;
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AlertDialog(
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
              content: Container(
                margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                // height: 122,
                width: width,
                height: height / 3.5,
                // padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: const Alignment(-1.0, 0.0),
                      end: const Alignment(1.0, 0.0),
                      transform: const GradientRotation(0.7853982),
                      // stops: [0.1, 0.5, 0.7, 0.9],
                      colors: [
                        HexColor("#000000"),
                        HexColor("#000000"),
                        HexColor("##E84F90"),
                        // HexColor("#ffffff"),
                        // HexColor("#FFFFFF").withOpacity(0.67),
                      ],
                    ),
                    color: HexColor('#3b5998'),
                    border: Border.all(color: Colors.white, width: 0.5),
                    borderRadius: const BorderRadius.all(Radius.circular(26.0))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 20, fontFamily: 'PB', color: Colors.white),
                        ),
                        Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                            height: 45,
                            child: TextField(
                              controller: controller,
                              style: const TextStyle(fontSize: 15, fontFamily: 'PR', color: Colors.white),
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                                hintText: 'Enter Profile link',
                                hintStyle: TextStyle(fontSize: 15, fontFamily: 'PR', color: Colors.white),
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white, width: 1),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white, width: 1),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                border: InputBorder.none,
                              ),
                              onChanged: (text) {
                                setState(() {
                                  // fullName = text;
                                  //you can access nameController in its scope to get
                                  // the value of text entered as shown below
                                  //fullName = nameController.text;
                                });
                              },
                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: onTap,
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20), color: Colors.white),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                                  child: Text(
                                    'Update',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 15, fontFamily: 'PM', color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: onLinkTap,
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20), color: Colors.white),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                                  child: Text(
                                    'Open Link',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 15, fontFamily: 'PM', color: Colors.black),
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
              )),
        );
      },
    );
  }

  void twitter_pop() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double width = MediaQuery.of(context).size.width;
        double height = MediaQuery.of(context).size.height;
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AlertDialog(
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
              content: Container(
                margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                // height: 122,
                width: width,
                height: height / 3.5,
                // padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    // gradient: LinearGradient(
                    //   begin: Alignment(
                    //       -1.0,
                    //       0.0),
                    //   end: Alignment(
                    //       1.0,
                    //       0.0),
                    //   transform:
                    //   GradientRotation(0.7853982),
                    //   // stops: [0.1, 0.5, 0.7, 0.9],
                    //   colors: [
                    //     HexColor("#000000"),
                    //     HexColor("#000000"),
                    //     HexColor("##E84F90"),
                    //     // HexColor("#ffffff"),
                    //     // HexColor("#FFFFFF").withOpacity(0.67),
                    //   ],
                    // ),
                    color: HexColor('#00acee'),
                    borderRadius: const BorderRadius.all(Radius.circular(26.0))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Twitter',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, fontFamily: 'PB', color: Colors.white),
                        ),
                        Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                            height: 45,
                            child: TextField(
                              // controller: nameController,
                              controller: _creator_login_screen_controller.twitter_link_controller,
                              style: const TextStyle(fontSize: 15, fontFamily: 'PR', color: Colors.white),
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                                hintText: 'Enter Profile link',
                                hintStyle: TextStyle(fontSize: 15, fontFamily: 'PR', color: Colors.white),
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white, width: 1),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white, width: 1),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                border: InputBorder.none,
                              ),
                              onChanged: (text) {
                                setState(() {
                                  // fullName = text;
                                  //you can access nameController in its scope to get
                                  // the value of text entered as shown below
                                  //fullName = nameController.text;
                                });
                              },
                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                update_link_facebook(
                                    context: context,
                                    twitter_links:
                                        _creator_login_screen_controller.twitter_link_controller.text,
                                    index: 2);
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20), color: Colors.white),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                                  child: Text(
                                    'Update',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 15, fontFamily: 'PM', color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _launchUrl(_creator_login_screen_controller
                                    .userInfoModel_email.value.data![0].twitterLinks!);
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20), color: Colors.white),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                                  child: Text(
                                    'Open Link',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 15, fontFamily: 'PM', color: Colors.black),
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
              )),
        );
      },
    );
  }

  void instagram_pop() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double width = MediaQuery.of(context).size.width;
        double height = MediaQuery.of(context).size.height;
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AlertDialog(
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
              content: Container(
                margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                // height: 122,
                width: width,
                height: height / 3.5,
                // padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: const Alignment(-1.0, 0.0),
                      end: const Alignment(1.0, 0.0),
                      transform: const GradientRotation(0.7853982),
                      // stops: [0.1, 0.5, 0.7, 0.9],
                      colors: [
                        HexColor("#000000"),
                        HexColor("#000000"),
                        HexColor("##E84F90"),
                        // HexColor("#ffffff"),
                        // HexColor("#FFFFFF").withOpacity(0.67),
                      ],
                    ),
                    color: HexColor('#3b5998'),
                    border: Border.all(color: Colors.white, width: 0.5),
                    borderRadius: const BorderRadius.all(Radius.circular(26.0))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Instagram',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, fontFamily: 'PB', color: Colors.white),
                        ),
                        Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                            height: 45,
                            child: TextField(
                              controller: _creator_login_screen_controller.instagram_link_controller,
                              // controller: nameController,
                              style: const TextStyle(fontSize: 15, fontFamily: 'PR', color: Colors.white),
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                                hintText: 'Enter Profile link',
                                hintStyle: TextStyle(fontSize: 15, fontFamily: 'PR', color: Colors.white),
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white, width: 1),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white, width: 1),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                border: InputBorder.none,
                              ),
                              onChanged: (text) {
                                setState(() {
                                  // fullName = text;
                                  //you can access nameController in its scope to get
                                  // the value of text entered as shown below
                                  //fullName = nameController.text;
                                });
                              },
                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                update_link_facebook(
                                    context: context,
                                    instagram_links:
                                        _creator_login_screen_controller.instagram_link_controller.text,
                                    index: 1);
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20), color: Colors.white),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                                  child: Text(
                                    'Update',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 15, fontFamily: 'PM', color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _launchUrl(_creator_login_screen_controller
                                    .userInfoModel_email.value.data![0].instagramLinks!);
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20), color: Colors.white),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                                  child: Text(
                                    'Open Link',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 15, fontFamily: 'PM', color: Colors.black),
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
              )),
        );
      },
    );
  }

  // final Uri _url = Uri.parse('https://www.funky.global/');

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }

  String dropdownvalue = 'Apple';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        // appBar: AppBar(
        //   backgroundColor: Colors.transparent,
        //   title: Text(
        //     'My Profile',
        //     style: TextStyle(
        //       fontSize: 16,
        //     ),
        //   ),
        //   centerTitle: true,
        //   actions: [
        //     Container(
        //       margin: EdgeInsets.only(right: 20),
        //       child: IconButton(
        //         icon: Icon(
        //           Icons.more_vert,
        //           color: Colors.white,
        //           size: 25,
        //         ),
        //         onPressed: () {},
        //       ),
        //     ),
        //   ],
        //   leadingWidth: 100,
        //   leading: Container(
        //     margin: EdgeInsets.only(left: 18, top: 0, bottom: 0),
        //     child: IconButton(
        //         padding: EdgeInsets.zero,
        //         onPressed: () {},
        //         icon: (Image.asset(
        //           AssetUtils.story5,
        //           color: HexColor(CommonColor.pinkFont),
        //           height: 20.0,
        //           width: 20.0,
        //           fit: BoxFit.contain,
        //         ))),
        //   ),
        // ),

        body:
            // Obx(() => (_creator_login_screen_controller
            //             .isuserinfoLoading.value ==
            //         true
            //     ?                 Expanded(
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: <Widget>[
            //       Container(
            //           color: Colors.transparent,
            //           height: 80,
            //           width: 200,
            //           child: Container(
            //             color: Colors.transparent,
            //             child: Row(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               children:  [
            //                 CircularProgressIndicator(
            //                   // color: Colors.pink,
            //                   backgroundColor: HexColor(CommonColor.pinkFont),
            //                   valueColor: AlwaysStoppedAnimation<Color>(
            //                     Colors.white70, //<-- SEE HERE
            //                   ),
            //                 ),
            //                 // Text('Loading...',style: TextStyle(color: Colors.white,fontSize: 18,fontFamily: 'PR'),)
            //               ],
            //             ),
            //           )
            //         // Material(
            //         //   color: Colors.transparent,
            //         //   child: LoadingIndicator(
            //         //     backgroundColor: Colors.transparent,
            //         //     indicatorType: Indicator.ballScale,
            //         //     colors: _kDefaultRainbowColors,
            //         //     strokeWidth: 4.0,
            //         //     pathBackgroundColor: Colors.yellow,
            //         //     // showPathBackground ? Colors.black45 : null,
            //         //   ),
            //         // ),
            //       ),
            //     ],
            //   ),
            // )
            //
            //     :
            NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                  backgroundColor: Colors.black,
                  automaticallyImplyLeading: false,
                  expandedHeight: 400.0,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      centerTitle: true,
                      background: Container(
                        margin: const EdgeInsets.only(
                          top: 30,
                        ),
                        child: RefreshIndicator(
                          color: HexColor(CommonColor.pinkFont),
                          onRefresh: () async {
                            String idUser = await PreferenceManager().getPref(URLConstants.id);
                            String socialTypeUser =
                                await PreferenceManager().getPref(URLConstants.social_type);
                            print("id----- $idUser");
                            print("id----- $socialTypeUser");
                            (socialTypeUser == ""
                                ? await _creator_login_screen_controller.CreatorgetUserInfo_Email(
                                    context: context, UserId: idUser)
                                : await _creator_login_screen_controller.getUserInfo_social());
                          },
                          child: SingleChildScrollView(
                              child: Container(
                            // color:  Colors.yellow,
                            child: Obx(
                              () => _creator_login_screen_controller.isuserinfoLoading.value == true
                                  ? Column(
                                      children: [
                                        // Expanded(
                                        //   child: Align(
                                        //     alignment: Alignment.bottomCenter,
                                        //     child: Column(
                                        //       mainAxisAlignment: MainAxisAlignment.center,
                                        //       children: <Widget>[
                                        //         Text('NEW GAME'),
                                        //         Text('Sekiro: Shadows Dies Twice'),
                                        //         RaisedButton(
                                        //           onPressed: () {},
                                        //           child: Text('Play'),
                                        //         ),
                                        //       ],
                                        //     ),
                                        //   ),
                                        // ),
                                        Container(
                                          decoration: BoxDecoration(
                                              // color: HexColor(CommonColor.bloodRed),
                                              color: (idUserType == 'Advertiser'
                                                  ? HexColor(CommonColor.bloodRed)
                                                  : (idUserType == 'Kids'
                                                      ? HexColor("#0b0f54")
                                                      : Colors.black)),
                                              borderRadius: BorderRadius.circular(20)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 10, bottom: 10, right: 16, left: 16),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                            // color: Colors.white,
                                                            ),
                                                      ),
                                                      Expanded(
                                                        flex: 2,
                                                        child: Container(
                                                          alignment: Alignment.center,
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Text(
                                                                _creator_login_screen_controller
                                                                    .userInfoModel_email
                                                                    .value
                                                                    .data![0]
                                                                    .userName!,
                                                                style: const TextStyle(
                                                                    fontSize: 16,
                                                                    color: Colors.white,
                                                                    fontFamily: 'PB'),
                                                              ),
                                                              (_creator_login_screen_controller
                                                                          .userInfoModel_email
                                                                          .value
                                                                          .data![0]
                                                                          .verify ==
                                                                      'true'
                                                                  ? Row(
                                                                      children: [
                                                                        const SizedBox(
                                                                          width: 5,
                                                                        ),
                                                                        Image.asset(
                                                                          AssetUtils.verification_icon,
                                                                          height: 20,
                                                                          width: 20,
                                                                        ),
                                                                      ],
                                                                    )
                                                                  : const SizedBox.shrink())
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                            alignment: Alignment.centerRight,
                                                            margin: const EdgeInsets.only(right: 0),
                                                            child: const SizedBox()),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(top: 0, right: 16, left: 16),
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Stack(
                                                        children: [
                                                          Container(
                                                            // color: Colors.white,
                                                            height: 90,
                                                            width: 90,
                                                            padding: const EdgeInsets.all(2),
                                                            child: ClipRRect(
                                                              borderRadius: BorderRadius.circular(50),
                                                              child: (_creator_login_screen_controller
                                                                      .userInfoModel_email
                                                                      .value
                                                                      .data![0]
                                                                      .image!
                                                                      .isNotEmpty
                                                                  ? Image.network(
                                                                      '${URLConstants.base_data_url}images/${_creator_login_screen_controller.userInfoModel_email.value.data![0].image!}',
                                                                      fit: BoxFit.cover,
                                                                    )
                                                                  : Image.asset(AssetUtils.image1)),
                                                            ),
                                                          ),
                                                          (idUserType == 'Advertiser'
                                                              ? const SizedBox.shrink()
                                                              : Positioned(
                                                                  bottom: 0,
                                                                  right: 2,
                                                                  child: Obx(
                                                                    () => _settings_screen_controller
                                                                                .isRewardLoading.value ==
                                                                            true
                                                                        ? SizedBox(
                                                                            height: 20,
                                                                            width: 20,
                                                                            child: CircularProgressIndicator(
                                                                              strokeWidth: 2,
                                                                              color: HexColor(
                                                                                  CommonColor.pinkFont),
                                                                            ))
                                                                        : Container(
                                                                            decoration: BoxDecoration(
                                                                                color: Colors.white,
                                                                                // color: (idUserType ==
                                                                                //         'Advertiser'
                                                                                //     ? HexColor(CommonColor
                                                                                //         .bloodRed)
                                                                                //     : (idUserType == 'Kids'
                                                                                //         ? HexColor(
                                                                                //             "#0b0f54")
                                                                                //         : Colors
                                                                                //             .black)),
                                                                                boxShadow: const [
                                                                                  BoxShadow(
                                                                                    color: Colors.grey,
                                                                                    offset: Offset(0.0, 1.0),
                                                                                    //(x,y)
                                                                                    blurRadius: 6.0,
                                                                                  ),
                                                                                ],
                                                                                // border: Border
                                                                                //     .all(
                                                                                //     color: (double
                                                                                //         .parse(
                                                                                //         _settings_screen_controller
                                                                                //             .getRewardModel!
                                                                                //             .totalReward!) <=
                                                                                //         1000
                                                                                //         ? HexColor(
                                                                                //         '#CD7F32')
                                                                                //         : (double
                                                                                //         .parse(
                                                                                //         _settings_screen_controller
                                                                                //             .getRewardModel!
                                                                                //             .totalReward!) >=
                                                                                //         1000 &&
                                                                                //         double
                                                                                //             .parse(
                                                                                //             _settings_screen_controller
                                                                                //                 .getRewardModel!
                                                                                //                 .totalReward!) <=
                                                                                //             5000
                                                                                //         ? Colors
                                                                                //         .grey
                                                                                //         : (double
                                                                                //         .parse(
                                                                                //         _settings_screen_controller
                                                                                //             .getRewardModel!
                                                                                //             .totalReward!) >=
                                                                                //         5000
                                                                                //         ? HexColor(
                                                                                //         '#FFD700')
                                                                                //         : Colors
                                                                                //         .black)))),
                                                                                borderRadius:
                                                                                    BorderRadius.circular(
                                                                                        100)),
                                                                            child: Padding(
                                                                                padding:
                                                                                    const EdgeInsets.all(2.0),
                                                                                child: (double.parse(
                                                                                            _settings_screen_controller
                                                                                                .getRewardModel!
                                                                                                .totalReward!) <=
                                                                                        1000
                                                                                    ? Image.asset(
                                                                                        AssetUtils
                                                                                            .bronze_icon,
                                                                                      )
                                                                                    : (double.parse(_settings_screen_controller
                                                                                                    .getRewardModel!
                                                                                                    .totalReward!) >=
                                                                                                1000 &&
                                                                                            double.parse(_settings_screen_controller
                                                                                                    .getRewardModel!
                                                                                                    .totalReward!) <=
                                                                                                5000
                                                                                        ? Image.asset(
                                                                                            AssetUtils
                                                                                                .silver_icon,
                                                                                          )
                                                                                        : (double.parse(
                                                                                                    _settings_screen_controller.getRewardModel!.totalReward!) >=
                                                                                                5000
                                                                                            ? Image.asset(
                                                                                                AssetUtils
                                                                                                    .gold_icon,
                                                                                              )
                                                                                            : Image.asset(
                                                                                                AssetUtils
                                                                                                    .silver_icon,
                                                                                              ))))),
                                                                          ),
                                                                  ))),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Expanded(
                                                        flex: 3,
                                                        child: Container(
                                                          margin: const EdgeInsets.symmetric(horizontal: 15),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    // color: Colors.yellow,
                                                                    child: Obx(
                                                                      () => Text(
                                                                        (_creator_login_screen_controller
                                                                                .userInfoModel_email
                                                                                .value
                                                                                .data![0]
                                                                                .fullName!
                                                                                .isNotEmpty
                                                                            ? '${_creator_login_screen_controller.userInfoModel_email.value.data![0].fullName}'
                                                                            : 'Please update profile'),
                                                                        overflow: TextOverflow.ellipsis,
                                                                        style: TextStyle(
                                                                            fontSize: 16,
                                                                            color: HexColor(
                                                                                CommonColor.pinkFont)),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  IconButton(
                                                                      visualDensity: const VisualDensity(
                                                                          vertical: -4, horizontal: -4),
                                                                      padding:
                                                                          const EdgeInsets.only(left: 5.0),
                                                                      icon: const Icon(
                                                                        Icons.edit,
                                                                        color: Colors.grey,
                                                                        size: 15,
                                                                      ),
                                                                      onPressed: () {
                                                                        Get.to(const EditProfileScreen());
                                                                      }),
                                                                ],
                                                              ),
                                                              Text(
                                                                (_creator_login_screen_controller
                                                                        .userInfoModel_email
                                                                        .value
                                                                        .data![0]
                                                                        .about!
                                                                        .isNotEmpty
                                                                    ? '${_creator_login_screen_controller.userInfoModel_email.value.data![0].about}'
                                                                    : ' '),
                                                                overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(
                                                                    fontSize: 16,
                                                                    color:
                                                                        HexColor(CommonColor.subHeaderColor)),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              IconButton(
                                                                  visualDensity:
                                                                      const VisualDensity(vertical: -4),
                                                                  padding: const EdgeInsets.only(left: 5.0),
                                                                  icon: Image.asset(
                                                                    AssetUtils.like_icon_filled,
                                                                    color: HexColor(CommonColor.pinkFont),
                                                                    height: 20,
                                                                    width: 20,
                                                                  ),
                                                                  onPressed: () {}),
                                                              Text(
                                                                '${_creator_login_screen_controller.userInfoModel_email.value.data![0].followerNumber}',
                                                                style: const TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 12,
                                                                    fontFamily: 'PR'),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              IconButton(
                                                                  padding: const EdgeInsets.only(left: 5.0),
                                                                  visualDensity:
                                                                      const VisualDensity(vertical: -4),
                                                                  icon: Image.asset(
                                                                    AssetUtils.profile_filled,
                                                                    color: HexColor(CommonColor.pinkFont),
                                                                    height: 20,
                                                                    width: 20,
                                                                  ),
                                                                  onPressed: () {
                                                                    Get.to(FollowersList(
                                                                      user_id:
                                                                          _creator_login_screen_controller
                                                                              .userInfoModel_email
                                                                              .value
                                                                              .data![0]
                                                                              .id!,
                                                                    ));
                                                                  }),
                                                              Text(
                                                                '${_creator_login_screen_controller.userInfoModel_email.value.data![0].followerNumber}',
                                                                style: const TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 12,
                                                                    fontFamily: 'PR'),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              IconButton(
                                                                  visualDensity:
                                                                      const VisualDensity(vertical: -4),
                                                                  padding: const EdgeInsets.only(left: 5.0),
                                                                  icon: Image.asset(
                                                                    AssetUtils.following_filled,
                                                                    color: HexColor(CommonColor.pinkFont),
                                                                    height: 20,
                                                                    width: 20,
                                                                  ),
                                                                  onPressed: () {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (_) => FollowingScreen(
                                                                                  user_id:
                                                                                      _creator_login_screen_controller
                                                                                          .userInfoModel_email
                                                                                          .value
                                                                                          .data![0]
                                                                                          .id!,
                                                                                ))).then(
                                                                        (_) => setState(() {}));

                                                                    // Get.to(FollowingScreen());
                                                                  }),
                                                              Text(
                                                                '${_creator_login_screen_controller.userInfoModel_email.value.data![0].followingNumber}',
                                                                style: const TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 12,
                                                                    fontFamily: 'PR'),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(top: 0, right: 16, left: 16),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        flex: 2,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(50),
                                                              ),
                                                              child: IconButton(
                                                                padding: EdgeInsets.zero,
                                                                visualDensity: const VisualDensity(
                                                                    vertical: -4, horizontal: -4),
                                                                icon: Image.asset(
                                                                  AssetUtils.facebook_icon,
                                                                  height: 32,
                                                                  width: 32,
                                                                ),
                                                                onPressed: () {
                                                                  facebook_pop();
                                                                  // _loginScreenController.signInWithFacebook(
                                                                  //     login_type: 'creator', context: context);
                                                                },
                                                              ),
                                                            ),
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(50),
                                                              ),
                                                              child: IconButton(
                                                                padding: EdgeInsets.zero,
                                                                visualDensity: const VisualDensity(
                                                                    vertical: -4, horizontal: -4),
                                                                icon: Image.asset(
                                                                  AssetUtils.instagram_icon,
                                                                  height: 32,
                                                                  width: 32,
                                                                ),
                                                                onPressed: () {
                                                                  instagram_pop();
                                                                  // Get.to(InstagramView());
                                                                },
                                                              ),
                                                            ),
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(50),
                                                              ),
                                                              child: IconButton(
                                                                padding: EdgeInsets.zero,
                                                                visualDensity: const VisualDensity(
                                                                    vertical: -4, horizontal: -4),
                                                                icon: Image.asset(
                                                                  AssetUtils.twitter_icon,
                                                                  height: 32,
                                                                  width: 32,
                                                                ),
                                                                onPressed: () {
                                                                  twitter_pop();
                                                                  // _loginScreenController.signInWithTwitter(context: context, login_type: 'creator');
                                                                },
                                                              ),
                                                            ),
                                                            Container(
                                                              width: 30,
                                                              margin: const EdgeInsets.only(right: 10),
                                                              // color: Colors.pink,
                                                              child: DropdownButtonHideUnderline(
                                                                child: DropdownButton2(
                                                                  customButton: const Icon(
                                                                    Icons.keyboard_arrow_down,
                                                                    color: Colors.white,
                                                                    size: 20,
                                                                  ),
                                                                  items: [
                                                                    DropdownMenuItem(
                                                                        value: "Apple",
                                                                        onTap: () {},
                                                                        child: GestureDetector(
                                                                          onTap: () {
                                                                            drop_down_pop(
                                                                                title: "TikTok",
                                                                                controller:
                                                                                    _creator_login_screen_controller
                                                                                        .tiktok_links_controller,
                                                                                back_color:
                                                                                    HexColor("#FFFFFF"),
                                                                                onTap: () {
                                                                                  update_link_facebook(
                                                                                      context: context,
                                                                                      tiktok_links:
                                                                                          _creator_login_screen_controller
                                                                                              .tiktok_links_controller
                                                                                              .text,
                                                                                      index: 3);
                                                                                },
                                                                                onLinkTap: () {
                                                                                  _launchUrl(
                                                                                      _creator_login_screen_controller
                                                                                          .userInfoModel_email
                                                                                          .value
                                                                                          .data![0]
                                                                                          .tiktokLinks!);
                                                                                });
                                                                          },
                                                                          child: Row(
                                                                            children: [
                                                                              Image.asset(
                                                                                AssetUtils.tiktok,
                                                                                height: 32,
                                                                                width: 32,
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 15,
                                                                              ),
                                                                              const Expanded(
                                                                                child: Text("TikTok",
                                                                                    overflow:
                                                                                        TextOverflow.ellipsis,
                                                                                    style: TextStyle(
                                                                                        color: Colors.black,
                                                                                        fontSize: 16,
                                                                                        fontFamily: 'PR')),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )),
                                                                    DropdownMenuItem(
                                                                        value: "items2",
                                                                        onTap: () {},
                                                                        child: GestureDetector(
                                                                          onTap: () {
                                                                            drop_down_pop(
                                                                                title: "Snapchat",
                                                                                controller:
                                                                                    _creator_login_screen_controller
                                                                                        .snapchat_links_controller,
                                                                                back_color:
                                                                                    HexColor("#FFFFFF"),
                                                                                onTap: () {
                                                                                  update_link_facebook(
                                                                                      context: context,
                                                                                      index: 4,
                                                                                      snapchat_links:
                                                                                          _creator_login_screen_controller
                                                                                              .snapchat_links_controller
                                                                                              .text);
                                                                                },
                                                                                onLinkTap: () {
                                                                                  _launchUrl(
                                                                                      _creator_login_screen_controller
                                                                                          .userInfoModel_email
                                                                                          .value
                                                                                          .data![0]
                                                                                          .snapchatLinks!);
                                                                                });
                                                                          },
                                                                          child: Row(
                                                                            children: [
                                                                              Image.asset(
                                                                                AssetUtils.snapchat,
                                                                                height: 32,
                                                                                width: 32,
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 15,
                                                                              ),
                                                                              const Expanded(
                                                                                child: Text("Snapchat",
                                                                                    overflow:
                                                                                        TextOverflow.ellipsis,
                                                                                    style: TextStyle(
                                                                                        color: Colors.black,
                                                                                        fontSize: 16,
                                                                                        fontFamily: 'PR')),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )),
                                                                    DropdownMenuItem(
                                                                        value: "items2",
                                                                        onTap: () {},
                                                                        child: GestureDetector(
                                                                          onTap: () {
                                                                            drop_down_pop(
                                                                                title: "Linkedin",
                                                                                controller:
                                                                                    _creator_login_screen_controller
                                                                                        .linkedin_links_controller,
                                                                                back_color:
                                                                                    HexColor("#FFFFFF"),
                                                                                onTap: () {
                                                                                  update_link_facebook(
                                                                                      context: context,
                                                                                      index: 5,
                                                                                      linkedin_links:
                                                                                          _creator_login_screen_controller
                                                                                              .linkedin_links_controller
                                                                                              .text);
                                                                                },
                                                                                onLinkTap: () {
                                                                                  _launchUrl(
                                                                                      _creator_login_screen_controller
                                                                                          .userInfoModel_email
                                                                                          .value
                                                                                          .data![0]
                                                                                          .linkedinLinks!);
                                                                                });
                                                                          },
                                                                          child: Row(
                                                                            children: [
                                                                              Image.asset(
                                                                                AssetUtils.linkedin,
                                                                                height: 32,
                                                                                width: 32,
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 15,
                                                                              ),
                                                                              const Expanded(
                                                                                child: Text("Linkedin",
                                                                                    overflow:
                                                                                        TextOverflow.ellipsis,
                                                                                    style: TextStyle(
                                                                                        color: Colors.black,
                                                                                        fontSize: 16,
                                                                                        fontFamily: 'PR')),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )),
                                                                    DropdownMenuItem(
                                                                        value: "items2",
                                                                        onTap: () {
                                                                          print('');
                                                                        },
                                                                        child: GestureDetector(
                                                                          onTap: () {
                                                                            drop_down_pop(
                                                                                title: "Gmail",
                                                                                controller:
                                                                                    _creator_login_screen_controller
                                                                                        .gmail_links_controller,
                                                                                back_color:
                                                                                    HexColor("#FFFFFF"),
                                                                                onTap: () {
                                                                                  update_link_facebook(
                                                                                      context: context,
                                                                                      index: 6,
                                                                                      gmail_links:
                                                                                          _creator_login_screen_controller
                                                                                              .gmail_links_controller
                                                                                              .text);
                                                                                },
                                                                                onLinkTap: () {
                                                                                  _launchUrl(
                                                                                      _creator_login_screen_controller
                                                                                          .userInfoModel_email
                                                                                          .value
                                                                                          .data![0]
                                                                                          .gmailLinks!);
                                                                                });
                                                                          },
                                                                          child: Row(
                                                                            children: [
                                                                              Image.asset(
                                                                                AssetUtils.gmail,
                                                                                height: 32,
                                                                                width: 32,
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 15,
                                                                              ),
                                                                              const Expanded(
                                                                                child: Text("Gmail",
                                                                                    overflow:
                                                                                        TextOverflow.ellipsis,
                                                                                    style: TextStyle(
                                                                                        color: Colors.black,
                                                                                        fontSize: 16,
                                                                                        fontFamily: 'PR')),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )),
                                                                    DropdownMenuItem(
                                                                        value: "items2",
                                                                        onTap: () {
                                                                          print('');
                                                                        },
                                                                        child: GestureDetector(
                                                                          onTap: () {
                                                                            drop_down_pop(
                                                                                title: "WhatsApp",
                                                                                controller:
                                                                                    _creator_login_screen_controller
                                                                                        .whatsapp_links_controller,
                                                                                back_color:
                                                                                    HexColor("#FFFFFF"),
                                                                                onTap: () {
                                                                                  update_link_facebook(
                                                                                      context: context,
                                                                                      index: 7,
                                                                                      whatsapp_links:
                                                                                          _creator_login_screen_controller
                                                                                              .whatsapp_links_controller
                                                                                              .text);
                                                                                },
                                                                                onLinkTap: () async {
                                                                                  // _launchUrl(_creator_login_screen_controller
                                                                                  //     .userInfoModel_email.value
                                                                                  //     .data![0]
                                                                                  //     .whatsappLinks!);
                                                                                  var whatsapp =
                                                                                      "+918700925833";
                                                                                  var whatsappurlAndroid =
                                                                                      "whatsapp://send?phone=$whatsapp&text=hello";
                                                                                  var whatappurlIos =
                                                                                      "https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
                                                                                  if (Platform.isIOS) {
                                                                                    // for iOS phone only
                                                                                    if (await canLaunch(
                                                                                        whatappurlIos)) {
                                                                                      await launch(
                                                                                          whatappurlIos,
                                                                                          forceSafariVC:
                                                                                              false);
                                                                                    } else {
                                                                                      ScaffoldMessenger.of(
                                                                                              context)
                                                                                          .showSnackBar(
                                                                                              const SnackBar(
                                                                                                  content: Text(
                                                                                                      "whatsapp no installed")));
                                                                                    }
                                                                                  } else {
                                                                                    // android , web
                                                                                    if (await canLaunch(
                                                                                        whatsappurlAndroid)) {
                                                                                      await launch(
                                                                                          whatsappurlAndroid);
                                                                                    } else {
                                                                                      ScaffoldMessenger.of(
                                                                                              context)
                                                                                          .showSnackBar(
                                                                                              const SnackBar(
                                                                                                  content: Text(
                                                                                                      "whatsapp no installed")));
                                                                                    }
                                                                                  }
                                                                                });
                                                                          },
                                                                          child: Row(
                                                                            children: [
                                                                              Image.asset(
                                                                                AssetUtils.whatsapp,
                                                                                height: 32,
                                                                                width: 32,
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 15,
                                                                              ),
                                                                              const Expanded(
                                                                                child: Text("WhatsApp",
                                                                                    overflow:
                                                                                        TextOverflow.ellipsis,
                                                                                    style: TextStyle(
                                                                                        color: Colors.black,
                                                                                        fontSize: 16,
                                                                                        fontFamily: 'PR')),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )),
                                                                    DropdownMenuItem(
                                                                        value: "items2",
                                                                        child: GestureDetector(
                                                                          onTap: () {
                                                                            print('');
                                                                            drop_down_pop(
                                                                                title: "Skype",
                                                                                controller:
                                                                                    _creator_login_screen_controller
                                                                                        .skype_links_controller,
                                                                                back_color:
                                                                                    HexColor("#FFFFFF"),
                                                                                onTap: () {
                                                                                  update_link_facebook(
                                                                                      context: context,
                                                                                      index: 8,
                                                                                      skype_links:
                                                                                          _creator_login_screen_controller
                                                                                              .skype_links_controller
                                                                                              .text);
                                                                                },
                                                                                onLinkTap: () {
                                                                                  _launchUrl(
                                                                                      _creator_login_screen_controller
                                                                                          .userInfoModel_email
                                                                                          .value
                                                                                          .data![0]
                                                                                          .skypeLinks!);
                                                                                });
                                                                          },
                                                                          child: Row(
                                                                            children: [
                                                                              Image.asset(
                                                                                AssetUtils.skype,
                                                                                height: 32,
                                                                                width: 32,
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 15,
                                                                              ),
                                                                              const Expanded(
                                                                                child: Text("Skype",
                                                                                    overflow:
                                                                                        TextOverflow.ellipsis,
                                                                                    style: TextStyle(
                                                                                        color: Colors.black,
                                                                                        fontSize: 16,
                                                                                        fontFamily: 'PR')),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )),
                                                                    DropdownMenuItem(
                                                                        value: "items2",
                                                                        child: GestureDetector(
                                                                          onTap: () {
                                                                            print('');
                                                                            drop_down_pop(
                                                                                title: "YouTube",
                                                                                controller:
                                                                                    _creator_login_screen_controller
                                                                                        .youtube_links_controller,
                                                                                back_color:
                                                                                    HexColor("#FFFFFF"),
                                                                                onTap: () {
                                                                                  update_link_facebook(
                                                                                      context: context,
                                                                                      index: 9,
                                                                                      youtube_links:
                                                                                          _creator_login_screen_controller
                                                                                              .youtube_links_controller
                                                                                              .text);
                                                                                },
                                                                                onLinkTap: () {
                                                                                  _launchUrl(
                                                                                      _creator_login_screen_controller
                                                                                          .userInfoModel_email
                                                                                          .value
                                                                                          .data![0]
                                                                                          .youtubeLinks!);
                                                                                });
                                                                          },
                                                                          child: Row(
                                                                            children: [
                                                                              Image.asset(
                                                                                AssetUtils.youtube,
                                                                                height: 32,
                                                                                width: 32,
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 15,
                                                                              ),
                                                                              const Expanded(
                                                                                child: Text("YouTube",
                                                                                    overflow:
                                                                                        TextOverflow.ellipsis,
                                                                                    style: TextStyle(
                                                                                        color: Colors.black,
                                                                                        fontSize: 16,
                                                                                        fontFamily: 'PR')),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )),
                                                                    DropdownMenuItem(
                                                                        value: "items2",
                                                                        child: GestureDetector(
                                                                          onTap: () {
                                                                            print('');
                                                                            drop_down_pop(
                                                                                title: "Pinterest",
                                                                                controller:
                                                                                    _creator_login_screen_controller
                                                                                        .pinterest_links_controller,
                                                                                back_color:
                                                                                    HexColor("#FFFFFF"),
                                                                                onTap: () {
                                                                                  update_link_facebook(
                                                                                      context: context,
                                                                                      index: 10,
                                                                                      pinterest_links:
                                                                                          _creator_login_screen_controller
                                                                                              .pinterest_links_controller
                                                                                              .text);
                                                                                },
                                                                                onLinkTap: () {
                                                                                  _launchUrl(
                                                                                      _creator_login_screen_controller
                                                                                          .userInfoModel_email
                                                                                          .value
                                                                                          .data![0]
                                                                                          .pinterestLinks!);
                                                                                });
                                                                          },
                                                                          child: Row(
                                                                            children: [
                                                                              Image.asset(
                                                                                AssetUtils.pinterest,
                                                                                height: 32,
                                                                                width: 32,
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 15,
                                                                              ),
                                                                              const Expanded(
                                                                                child: Text("Pinterest",
                                                                                    overflow:
                                                                                        TextOverflow.ellipsis,
                                                                                    style: TextStyle(
                                                                                        color: Colors.black,
                                                                                        fontSize: 16,
                                                                                        fontFamily: 'PR')),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )),
                                                                    DropdownMenuItem(
                                                                        value: "items2",
                                                                        child: GestureDetector(
                                                                          onTap: () {
                                                                            print('');
                                                                            drop_down_pop(
                                                                                title: "Redit",
                                                                                controller:
                                                                                    _creator_login_screen_controller
                                                                                        .reddit_links_controller,
                                                                                back_color:
                                                                                    HexColor("#FFFFFF"),
                                                                                onTap: () {
                                                                                  update_link_facebook(
                                                                                      context: context,
                                                                                      index: 11,
                                                                                      reddit_links:
                                                                                          _creator_login_screen_controller
                                                                                              .reddit_links_controller
                                                                                              .text);
                                                                                },
                                                                                onLinkTap: () {
                                                                                  _launchUrl(
                                                                                      _creator_login_screen_controller
                                                                                          .userInfoModel_email
                                                                                          .value
                                                                                          .data![0]
                                                                                          .redditLinks!);
                                                                                });
                                                                          },
                                                                          child: Row(
                                                                            children: [
                                                                              Image.asset(
                                                                                AssetUtils.reddit,
                                                                                height: 32,
                                                                                width: 32,
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 15,
                                                                              ),
                                                                              const Expanded(
                                                                                child: Text("Redit",
                                                                                    overflow:
                                                                                        TextOverflow.ellipsis,
                                                                                    style: TextStyle(
                                                                                        color: Colors.black,
                                                                                        fontSize: 16,
                                                                                        fontFamily: 'PR')),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )),
                                                                    DropdownMenuItem(
                                                                        value: "items2",
                                                                        child: GestureDetector(
                                                                          onTap: () {
                                                                            print('');
                                                                            drop_down_pop(
                                                                                title: "Telegram",
                                                                                controller:
                                                                                    _creator_login_screen_controller
                                                                                        .telegram_links_controller,
                                                                                back_color:
                                                                                    HexColor("#FFFFFF"),
                                                                                onTap: () {
                                                                                  update_link_facebook(
                                                                                      context: context,
                                                                                      index: 12,
                                                                                      telegram_links:
                                                                                          _creator_login_screen_controller
                                                                                              .telegram_links_controller
                                                                                              .text);
                                                                                },
                                                                                onLinkTap: () {
                                                                                  // _launchUrl("https://telegram.me/${_creator_login_screen_controller
                                                                                  //     .userInfoModel_email.value
                                                                                  //     .data![0]
                                                                                  //     .telegramLinks!}");
                                                                                  /// Send message via Telegram
                                                                                  Telegram.send(
                                                                                      username:
                                                                                          _creator_login_screen_controller
                                                                                              .userInfoModel_email
                                                                                              .value
                                                                                              .data![0]
                                                                                              .telegramLinks!,
                                                                                      message:
                                                                                          'Thanks for building Telegram Package :)');
                                                                                  // _launchUrl(_creator_login_screen_controller
                                                                                  //     .userInfoModel_email.value
                                                                                  //     .data![0]
                                                                                  //     .telegramLinks!);
                                                                                });
                                                                          },
                                                                          child: Row(
                                                                            children: [
                                                                              Image.asset(
                                                                                AssetUtils.telegram,
                                                                                height: 32,
                                                                                width: 32,
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 15,
                                                                              ),
                                                                              const Expanded(
                                                                                child: Text("Telegram",
                                                                                    overflow:
                                                                                        TextOverflow.ellipsis,
                                                                                    style: TextStyle(
                                                                                        color: Colors.black,
                                                                                        fontSize: 16,
                                                                                        fontFamily: 'PR')),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )),
                                                                  ],
                                                                  value: dropdownvalue,
                                                                  style: const TextStyle(
                                                                    fontSize: 16,
                                                                    fontFamily: 'PR',
                                                                    color: Colors.white,
                                                                  ),
                                                                  alignment: Alignment.centerLeft,
                                                                  onChanged: (value) {
                                                                    setState(() {});
                                                                  },
                                                                  iconStyleData: const IconStyleData(
                                                                    iconSize: 25,
                                                                    iconEnabledColor: Color(0xff007DEF),
                                                                    iconDisabledColor: Color(0xff007DEF),
                                                                  ),
                                                                  buttonStyleData: ButtonStyleData(
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                        color: Colors.transparent),
                                                                    height: 50,
                                                                    width: 100,
                                                                    elevation: 0,
                                                                    padding: const EdgeInsets.only(
                                                                        left: 15, right: 15),
                                                                  ),
                                                                  enableFeedback: true,
                                                                  dropdownStyleData: DropdownStyleData(
                                                                    width: 100,
                                                                    maxHeight: 200,
                                                                    elevation: 8,
                                                                    scrollbarTheme: const ScrollbarThemeData(
                                                                      radius: Radius.circular(40),
                                                                      thickness: WidgetStatePropertyAll(6),
                                                                    ),
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(24),
                                                                      border: Border.all(
                                                                          width: 1, color: Colors.white),
                                                                      gradient: LinearGradient(
                                                                        begin: Alignment.topLeft,
                                                                        end: Alignment.bottomRight,
                                                                        colors: [
                                                                          HexColor("#000000"),
                                                                          HexColor("#C12265"),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 2,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                Get.to(const AnalyticsScreen());
                                                              },
                                                              child: Container(
                                                                margin:
                                                                    const EdgeInsets.symmetric(horizontal: 0),
                                                                // height: 45,
                                                                // width:(width ?? 300) ,
                                                                decoration: BoxDecoration(
                                                                    color: Colors.white,
                                                                    borderRadius: BorderRadius.circular(25)),
                                                                child: Container(
                                                                    alignment: Alignment.center,
                                                                    margin: const EdgeInsets.symmetric(
                                                                        vertical: 10, horizontal: 20),
                                                                    child: const Text(
                                                                      'Analytics',
                                                                      style: TextStyle(
                                                                          color: Colors.black,
                                                                          fontFamily: 'PR',
                                                                          fontSize: 16),
                                                                    )),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets.symmetric(horizontal: 0),
                                                              // height: 45,
                                                              // width:(width ?? 300) ,
                                                              // decoration: BoxDecoration(
                                                              //     color: Colors.white,
                                                              //     borderRadius:
                                                              //         BorderRadius
                                                              //             .circular(
                                                              //                 25)),
                                                              child: Container(
                                                                // alignment:
                                                                //     Alignment.center,
                                                                // margin: EdgeInsets
                                                                //     .symmetric(
                                                                //         vertical: 10,
                                                                //         horizontal:
                                                                //             30),
                                                                child: Image.asset(
                                                                  AssetUtils.chat_call_icon,
                                                                  height: 45.0,
                                                                  // color: Colors.black,
                                                                  width: 45.0,
                                                                  fit: BoxFit.contain,
                                                                ),
                                                                // Text(
                                                                //   'Chat',
                                                                //   style: TextStyle(
                                                                //       color: Colors
                                                                //           .black,
                                                                //       fontFamily:
                                                                //           'PR',
                                                                //       fontSize: 16),
                                                                // )
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(bottom: 15, top: 10),
                                          color: HexColor(CommonColor.pinkFont).withOpacity(0.7),
                                          height: 1,
                                          width: MediaQuery.of(context).size.width,
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(top: 0, right: 0, left: 0),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Column(
                                                children: [
                                                  Container(
                                                    margin: const EdgeInsets.symmetric(horizontal: 5),
                                                    height: 60,
                                                    width: 60,
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(50),
                                                        border: Border.all(color: Colors.white, width: 3)),
                                                    child: IconButton(
                                                      visualDensity:
                                                          const VisualDensity(vertical: -4, horizontal: -4),
                                                      onPressed: () async {
                                                        // File editedFile = await Navigator
                                                        //         .of(context)
                                                        //     .push(MaterialPageRoute(
                                                        //         builder: (context) =>
                                                        //             StoriesEditor(
                                                        //               // fontFamilyList: font_family,
                                                        //               giphyKey: '',
                                                        //               onDone:
                                                        //                   (String) {},
                                                        //               // filePath:
                                                        //               //     imgFile!.path,
                                                        //             )));
                                                        // if (editedFile != null) {
                                                        //   print(
                                                        //       'editedFile: ${editedFile.path}');
                                                        // }
                                                        // openCamera();
                                                        pop_up();
                                                      },
                                                      icon: Icon(
                                                        Icons.add,
                                                        color: HexColor(CommonColor.pinkFont),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  const Text(
                                                    'Add Story',
                                                    style: TextStyle(
                                                        color: Colors.white, fontFamily: 'PR', fontSize: 12),
                                                  )
                                                ],
                                              ),
                                              Expanded(
                                                child: SizedBox(
                                                    height: 88,
                                                    child: Obx(() => (_profile_screen_controller
                                                                .isStoryLoading.value ==
                                                            true
                                                        ? const LoaderPage()
                                                        : (_profile_screen_controller
                                                                .getStoryModel!.data!.isNotEmpty
                                                            ? ListView.builder(
                                                                itemCount:
                                                                    _profile_screen_controller.story_.length,
                                                                shrinkWrap: true,
                                                                scrollDirection: Axis.horizontal,
                                                                itemBuilder:
                                                                    (BuildContext context, int index) {
                                                                  return Padding(
                                                                    padding: const EdgeInsets.symmetric(
                                                                      horizontal: 8.0,
                                                                    ),
                                                                    child: Column(
                                                                      children: [
                                                                        GestureDetector(
                                                                          onTap: () {
                                                                            print(index);
                                                                            _profile_screen_controller
                                                                                    .story_info =
                                                                                _profile_screen_controller
                                                                                    .getStoryModel!
                                                                                    .data![index]
                                                                                    .storys!;
                                                                            print(_profile_screen_controller
                                                                                .story_info);
                                                                            Get.to(() => StoryScreen(
                                                                                  other_user: false,
                                                                                  title:
                                                                                      _profile_screen_controller
                                                                                          .story_[index]
                                                                                          .title!,
                                                                                  mohit:
                                                                                      _profile_screen_controller
                                                                                          .getStoryModel!
                                                                                          .data![index],
                                                                                  // thumbnail:
                                                                                  //     test_thumb[index],
                                                                                  stories:
                                                                                      _profile_screen_controller
                                                                                          .story_info,
                                                                                  story_no: 0,
                                                                                  stories_title:
                                                                                      _profile_screen_controller
                                                                                          .story_,
                                                                                ));
                                                                            // Get.to(StoryScreen(stories: story_info));
                                                                          },
                                                                          child: SizedBox(
                                                                            height: 60,
                                                                            width: 60,
                                                                            child: ClipRRect(
                                                                              borderRadius:
                                                                                  BorderRadius.circular(50),
                                                                              child: (_profile_screen_controller
                                                                                      .story_[index]
                                                                                      .storys![0]
                                                                                      .storyPhoto!
                                                                                      .isEmpty
                                                                                  ? Image.asset(
                                                                                      // test_thumb[
                                                                                      //     index]
                                                                                      'assets/images/Funky_App_Icon.png')
                                                                                  : (_profile_screen_controller
                                                                                              .story_[index]
                                                                                              .storys![0]
                                                                                              .isVideo ==
                                                                                          'false'
                                                                                      ?
                                                                                      // Image.file(test_thumb[index])
                                                                                      FadeInImage
                                                                                          .assetNetwork(
                                                                                          fit: BoxFit.cover,
                                                                                          image:
                                                                                              "${URLConstants.base_data_url}images/${_profile_screen_controller.story_[index].storys![0].storyPhoto!}",
                                                                                          placeholder:
                                                                                              'assets/images/Funky_App_Icon.png',
                                                                                          // color: HexColor(CommonColor.pinkFont),
                                                                                        )
                                                                                      : Image.asset(
                                                                                          // test_thumb[
                                                                                          //     index]
                                                                                          'assets/images/Funky_App_Icon.png'))),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          height: 5,
                                                                        ),
                                                                        (_profile_screen_controller
                                                                                    .story_[index]
                                                                                    .title!
                                                                                    .length >=
                                                                                5
                                                                            ? SizedBox(
                                                                                height: 20,
                                                                                width: 40,
                                                                                child: Marquee(
                                                                                  text:
                                                                                      '${_profile_screen_controller.story_[index].title}',
                                                                                  style: const TextStyle(
                                                                                      color: Colors.white,
                                                                                      fontFamily: 'PR',
                                                                                      fontSize: 14),
                                                                                  scrollAxis: Axis.horizontal,
                                                                                  crossAxisAlignment:
                                                                                      CrossAxisAlignment
                                                                                          .start,
                                                                                  blankSpace: 20.0,
                                                                                  velocity: 30.0,
                                                                                  pauseAfterRound:
                                                                                      const Duration(
                                                                                          milliseconds: 100),
                                                                                  startPadding: 10.0,
                                                                                  accelerationDuration:
                                                                                      const Duration(
                                                                                          seconds: 1),
                                                                                  accelerationCurve:
                                                                                      Curves.easeIn,
                                                                                  decelerationDuration:
                                                                                      const Duration(
                                                                                          microseconds: 500),
                                                                                  decelerationCurve:
                                                                                      Curves.easeOut,
                                                                                ),
                                                                              )
                                                                            : Text(
                                                                                '${_profile_screen_controller.story_[index].title}',
                                                                                style: const TextStyle(
                                                                                    color: Colors.white,
                                                                                    fontFamily: 'PR',
                                                                                    fontSize: 14),
                                                                              ))
                                                                      ],
                                                                    ),
                                                                  );
                                                                })
                                                            : const SizedBox())))),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(bottom: 0, top: 5),
                                          color: HexColor(CommonColor.pinkFont).withOpacity(0.7),
                                          height: 1,
                                          width: MediaQuery.of(context).size.width,
                                        ),
                                      ],
                                    )
                                  : Column(children: [
                                      // Expanded(
                                      //   child: Align(
                                      //     alignment: Alignment.bottomCenter,
                                      //     child: Column(
                                      //       mainAxisAlignment: MainAxisAlignment.center,
                                      //       children: <Widget>[
                                      //         Text('NEW GAME'),
                                      //         Text('Sekiro: Shadows Dies Twice'),
                                      //         RaisedButton(
                                      //           onPressed: () {},
                                      //           child: Text('Play'),
                                      //         ),
                                      //       ],
                                      //     ),
                                      //   ),
                                      // ),
                                      Container(
                                        decoration: BoxDecoration(
                                            // color: HexColor(CommonColor.bloodRed),
                                            color: (idUserType == 'Advertiser'
                                                ? HexColor(CommonColor.bloodRed)
                                                : (idUserType == 'Kids'
                                                    ? HexColor("#0b0f54")
                                                    : Colors.black)),
                                            borderRadius: BorderRadius.circular(20)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 10, bottom: 10, right: 16, left: 16),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    flex: 1,
                                                    child: Container(
                                                        // color: Colors.white,
                                                        ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Container(
                                                      alignment: Alignment.center,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            _creator_login_screen_controller
                                                                .userInfoModel_email.value.data![0].userName!,
                                                            style: const TextStyle(
                                                                fontSize: 16,
                                                                color: Colors.white,
                                                                fontFamily: 'PB'),
                                                          ),
                                                          (_creator_login_screen_controller
                                                                      .userInfoModel_email
                                                                      .value
                                                                      .data![0]
                                                                      .verify ==
                                                                  'true'
                                                              ? Row(
                                                                  children: [
                                                                    const SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Image.asset(
                                                                      AssetUtils.verification_icon,
                                                                      height: 20,
                                                                      width: 20,
                                                                    ),
                                                                  ],
                                                                )
                                                              : const SizedBox.shrink())
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Container(
                                                        alignment: Alignment.centerRight,
                                                        margin: const EdgeInsets.only(right: 0),
                                                        child: const SizedBox()),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(top: 0, right: 16, left: 16),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Stack(
                                                    children: [
                                                      Container(
                                                        // color: Colors.white,
                                                        height: 90,
                                                        width: 90,
                                                        padding: const EdgeInsets.all(2),
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(50),
                                                          child: (_creator_login_screen_controller
                                                                  .userInfoModel_email
                                                                  .value
                                                                  .data![0]
                                                                  .image!
                                                                  .isNotEmpty
                                                              ? Image.network(
                                                                  '${URLConstants.base_data_url}images/${_creator_login_screen_controller.userInfoModel_email.value.data![0].image!}',
                                                                  fit: BoxFit.cover,
                                                                )
                                                              : Image.asset(AssetUtils.image1)),
                                                        ),
                                                      ),
                                                      ((idUserType == 'Advertiser'
                                                          ? const SizedBox.shrink()
                                                          : Positioned(
                                                              bottom: 0,
                                                              right: 2,
                                                              child: Obx(
                                                                () => _settings_screen_controller
                                                                            .isRewardLoading.value ==
                                                                        true
                                                                    ? SizedBox(
                                                                        height: 20,
                                                                        width: 20,
                                                                        child: CircularProgressIndicator(
                                                                          strokeWidth: 2,
                                                                          color:
                                                                              HexColor(CommonColor.pinkFont),
                                                                        ))
                                                                    : Container(
                                                                        decoration: BoxDecoration(
                                                                            color: Colors.white,
                                                                            // color: (idUserType ==
                                                                            //         'Advertiser'
                                                                            //     ? HexColor(CommonColor
                                                                            //         .bloodRed)
                                                                            //     : (idUserType == 'Kids'
                                                                            //         ? HexColor(
                                                                            //             "#0b0f54")
                                                                            //         : Colors
                                                                            //             .black)),
                                                                            boxShadow: const [
                                                                              BoxShadow(
                                                                                color: Colors.grey,
                                                                                offset: Offset(0.0, 1.0),
                                                                                //(x,y)
                                                                                blurRadius: 6.0,
                                                                              ),
                                                                            ],
                                                                            // border: Border
                                                                            //     .all(
                                                                            //     color: (double
                                                                            //         .parse(
                                                                            //         _settings_screen_controller
                                                                            //             .getRewardModel!
                                                                            //             .totalReward!) <=
                                                                            //         1000
                                                                            //         ? HexColor(
                                                                            //         '#CD7F32')
                                                                            //         : (double
                                                                            //         .parse(
                                                                            //         _settings_screen_controller
                                                                            //             .getRewardModel!
                                                                            //             .totalReward!) >=
                                                                            //         1000 &&
                                                                            //         double
                                                                            //             .parse(
                                                                            //             _settings_screen_controller
                                                                            //                 .getRewardModel!
                                                                            //                 .totalReward!) <=
                                                                            //             5000
                                                                            //         ? Colors
                                                                            //         .grey
                                                                            //         : (double
                                                                            //         .parse(
                                                                            //         _settings_screen_controller
                                                                            //             .getRewardModel!
                                                                            //             .totalReward!) >=
                                                                            //         5000
                                                                            //         ? HexColor(
                                                                            //         '#FFD700')
                                                                            //         : Colors
                                                                            //         .black)))),
                                                                            borderRadius:
                                                                                BorderRadius.circular(100)),
                                                                        child: Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(2.0),
                                                                            child: (double.parse(
                                                                                        _settings_screen_controller
                                                                                            .getRewardModel!
                                                                                            .totalReward!) <=
                                                                                    1000
                                                                                ? Image.asset(
                                                                                    AssetUtils.bronze_icon,
                                                                                    height: 20,
                                                                                    width: 20,
                                                                                  )
                                                                                : (double.parse(_settings_screen_controller.getRewardModel!.totalReward!) >= 1000 &&
                                                                                        double.parse(_settings_screen_controller.getRewardModel!.totalReward!) <=
                                                                                            5000
                                                                                    ? Image.asset(AssetUtils.silver_icon,
                                                                                        height: 20, width: 20)
                                                                                    : (double.parse(_settings_screen_controller.getRewardModel!.totalReward!) >= 5000
                                                                                        ? Image.asset(AssetUtils.gold_icon,
                                                                                            height: 20,
                                                                                            width: 20)
                                                                                        : Image.asset(
                                                                                            AssetUtils.silver_icon,
                                                                                            height: 20,
                                                                                            width: 20))))),
                                                                      ),
                                                              ))))
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Container(
                                                      margin: const EdgeInsets.symmetric(horizontal: 15),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                // color: Colors.yellow,
                                                                child: Text(
                                                                  (_creator_login_screen_controller
                                                                          .userInfoModel_email
                                                                          .value
                                                                          .data![0]
                                                                          .fullName!
                                                                          .isNotEmpty
                                                                      ? '${_creator_login_screen_controller.userInfoModel_email.value.data![0].fullName}'
                                                                      : 'Please update profile'),
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: TextStyle(
                                                                      fontSize: 16,
                                                                      color: HexColor(CommonColor.pinkFont)),
                                                                ),
                                                              ),
                                                              IconButton(
                                                                  visualDensity: const VisualDensity(
                                                                      vertical: -4, horizontal: -4),
                                                                  padding: const EdgeInsets.only(left: 5.0),
                                                                  icon: const Icon(
                                                                    Icons.edit,
                                                                    color: Colors.grey,
                                                                    size: 15,
                                                                  ),
                                                                  onPressed: () {
                                                                    Get.to(() => const EditProfileScreen());
                                                                  }),
                                                            ],
                                                          ),
                                                          Text(
                                                            (_creator_login_screen_controller
                                                                    .userInfoModel_email
                                                                    .value
                                                                    .data![0]
                                                                    .about!
                                                                    .isNotEmpty
                                                                ? '${_creator_login_screen_controller.userInfoModel_email.value.data![0].about}'
                                                                : ' '),
                                                            overflow: TextOverflow.ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                color: HexColor(CommonColor.subHeaderColor)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          IconButton(
                                                              visualDensity:
                                                                  const VisualDensity(vertical: -4),
                                                              padding: const EdgeInsets.only(left: 5.0),
                                                              icon: Image.asset(
                                                                AssetUtils.like_icon_filled,
                                                                color: HexColor(CommonColor.pinkFont),
                                                                height: 20,
                                                                width: 20,
                                                              ),
                                                              onPressed: () {}),
                                                          Text(
                                                            '${_creator_login_screen_controller.userInfoModel_email.value.data![0].followerNumber}',
                                                            style: const TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 12,
                                                                fontFamily: 'PR'),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          IconButton(
                                                              padding: const EdgeInsets.only(left: 5.0),
                                                              visualDensity:
                                                                  const VisualDensity(vertical: -4),
                                                              icon: Image.asset(
                                                                AssetUtils.profile_filled,
                                                                color: HexColor(CommonColor.pinkFont),
                                                                height: 20,
                                                                width: 20,
                                                              ),
                                                              onPressed: () {
                                                                Get.to(FollowersList(
                                                                  user_id: _creator_login_screen_controller
                                                                      .userInfoModel_email.value.data![0].id!,
                                                                ));
                                                              }),
                                                          Text(
                                                            '${_creator_login_screen_controller.userInfoModel_email.value.data![0].followerNumber}',
                                                            style: const TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 12,
                                                                fontFamily: 'PR'),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          IconButton(
                                                              visualDensity:
                                                                  const VisualDensity(vertical: -4),
                                                              padding: const EdgeInsets.only(left: 5.0),
                                                              icon: Image.asset(
                                                                AssetUtils.following_filled,
                                                                color: HexColor(CommonColor.pinkFont),
                                                                height: 20,
                                                                width: 20,
                                                              ),
                                                              onPressed: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (_) => FollowingScreen(
                                                                              user_id:
                                                                                  _creator_login_screen_controller
                                                                                      .userInfoModel_email
                                                                                      .value
                                                                                      .data![0]
                                                                                      .id!,
                                                                            ))).then((_) => setState(() {}));

                                                                // Get.to(FollowingScreen());
                                                              }),
                                                          Text(
                                                            '${_creator_login_screen_controller.userInfoModel_email.value.data![0].followingNumber}',
                                                            style: const TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 12,
                                                                fontFamily: 'PR'),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(top: 0, right: 16, left: 16),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(50),
                                                          ),
                                                          child: IconButton(
                                                            padding: EdgeInsets.zero,
                                                            visualDensity: const VisualDensity(
                                                                vertical: -4, horizontal: -4),
                                                            icon: Image.asset(
                                                              AssetUtils.facebook_icon,
                                                              height: 32,
                                                              width: 32,
                                                            ),
                                                            onPressed: () {
                                                              facebook_pop();
                                                              // _loginScreenController.signInWithFacebook(
                                                              //     login_type: 'creator', context: context);
                                                            },
                                                          ),
                                                        ),
                                                        Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(50),
                                                          ),
                                                          child: IconButton(
                                                            padding: EdgeInsets.zero,
                                                            visualDensity: const VisualDensity(
                                                                vertical: -4, horizontal: -4),
                                                            icon: Image.asset(
                                                              AssetUtils.instagram_icon,
                                                              height: 32,
                                                              width: 32,
                                                            ),
                                                            onPressed: () {
                                                              instagram_pop();
                                                              // Get.to(InstagramView());
                                                            },
                                                          ),
                                                        ),
                                                        Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(50),
                                                          ),
                                                          child: IconButton(
                                                            padding: EdgeInsets.zero,
                                                            visualDensity: const VisualDensity(
                                                                vertical: -4, horizontal: -4),
                                                            icon: Image.asset(
                                                              AssetUtils.twitter_icon,
                                                              height: 32,
                                                              width: 32,
                                                            ),
                                                            onPressed: () {
                                                              twitter_pop();
                                                              // _loginScreenController.signInWithTwitter(context: context, login_type: 'creator');
                                                            },
                                                          ),
                                                        ),
                                                        Container(
                                                            width: 30,
                                                            margin: const EdgeInsets.only(right: 10),
                                                            // color: Colors.pink,
                                                            child: PopupMenuButton(
                                                              icon: const Icon(
                                                                Icons.keyboard_arrow_down,
                                                                color: Colors.white,
                                                                size: 20,
                                                              ),
                                                              itemBuilder: (context) => [
                                                                PopupMenuItem(
                                                                  onTap: () {
                                                                    drop_down_pop(
                                                                        title: "TikTok",
                                                                        controller:
                                                                            _creator_login_screen_controller
                                                                                .tiktok_links_controller,
                                                                        back_color: HexColor("#FFFFFF"),
                                                                        onTap: () {
                                                                          update_link_facebook(
                                                                              context: context,
                                                                              tiktok_links:
                                                                                  _creator_login_screen_controller
                                                                                      .tiktok_links_controller
                                                                                      .text,
                                                                              index: 3);
                                                                        },
                                                                        onLinkTap: () {
                                                                          _launchUrl(
                                                                              _creator_login_screen_controller
                                                                                  .userInfoModel_email
                                                                                  .value
                                                                                  .data![0]
                                                                                  .tiktokLinks!);
                                                                        });
                                                                  },
                                                                  child: Row(
                                                                    children: [
                                                                      Image.asset(
                                                                        AssetUtils.tiktok,
                                                                        height: 32,
                                                                        width: 32,
                                                                      ),
                                                                      const SizedBox(
                                                                        width: 15,
                                                                      ),
                                                                      const Expanded(
                                                                        child: Text("TikTok",
                                                                            overflow: TextOverflow.ellipsis,
                                                                            style: TextStyle(
                                                                                color: Colors.black,
                                                                                fontSize: 16,
                                                                                fontFamily: 'PR')),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                PopupMenuItem(
                                                                  onTap: () {
                                                                    drop_down_pop(
                                                                        title: "Snapchat",
                                                                        controller:
                                                                            _creator_login_screen_controller
                                                                                .snapchat_links_controller,
                                                                        back_color: HexColor("#FFFFFF"),
                                                                        onTap: () {
                                                                          update_link_facebook(
                                                                              context: context,
                                                                              index: 4,
                                                                              snapchat_links:
                                                                                  _creator_login_screen_controller
                                                                                      .snapchat_links_controller
                                                                                      .text);
                                                                        },
                                                                        onLinkTap: () {
                                                                          _launchUrl(
                                                                              _creator_login_screen_controller
                                                                                  .userInfoModel_email
                                                                                  .value
                                                                                  .data![0]
                                                                                  .snapchatLinks!);
                                                                        });
                                                                  },
                                                                  child: Row(
                                                                    children: [
                                                                      Image.asset(
                                                                        AssetUtils.snapchat,
                                                                        height: 32,
                                                                        width: 32,
                                                                      ),
                                                                      const SizedBox(
                                                                        width: 15,
                                                                      ),
                                                                      const Expanded(
                                                                        child: Text("Snapchat",
                                                                            overflow: TextOverflow.ellipsis,
                                                                            style: TextStyle(
                                                                                color: Colors.black,
                                                                                fontSize: 16,
                                                                                fontFamily: 'PR')),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                PopupMenuItem(
                                                                  onTap: () {
                                                                    drop_down_pop(
                                                                        title: "Gmail",
                                                                        controller:
                                                                            _creator_login_screen_controller
                                                                                .gmail_links_controller,
                                                                        back_color: HexColor("#FFFFFF"),
                                                                        onTap: () {
                                                                          update_link_facebook(
                                                                              context: context,
                                                                              index: 6,
                                                                              gmail_links:
                                                                                  _creator_login_screen_controller
                                                                                      .gmail_links_controller
                                                                                      .text);
                                                                        },
                                                                        onLinkTap: () {
                                                                          _launchUrl(
                                                                              _creator_login_screen_controller
                                                                                  .userInfoModel_email
                                                                                  .value
                                                                                  .data![0]
                                                                                  .gmailLinks!);
                                                                        });
                                                                  },
                                                                  child: Row(
                                                                    children: [
                                                                      Image.asset(
                                                                        AssetUtils.gmail,
                                                                        height: 32,
                                                                        width: 32,
                                                                      ),
                                                                      const SizedBox(
                                                                        width: 15,
                                                                      ),
                                                                      const Expanded(
                                                                        child: Text("Gmail",
                                                                            overflow: TextOverflow.ellipsis,
                                                                            style: TextStyle(
                                                                                color: Colors.black,
                                                                                fontSize: 16,
                                                                                fontFamily: 'PR')),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                PopupMenuItem(
                                                                  onTap: () {
                                                                    drop_down_pop(
                                                                        title: "WhatsApp",
                                                                        controller:
                                                                            _creator_login_screen_controller
                                                                                .whatsapp_links_controller,
                                                                        back_color: HexColor("#FFFFFF"),
                                                                        onTap: () {
                                                                          update_link_facebook(
                                                                              context: context,
                                                                              index: 7,
                                                                              whatsapp_links:
                                                                                  _creator_login_screen_controller
                                                                                      .whatsapp_links_controller
                                                                                      .text);
                                                                        },
                                                                        onLinkTap: () async {
                                                                          // _launchUrl(_creator_login_screen_controller
                                                                          //     .userInfoModel_email.value
                                                                          //     .data![0]
                                                                          //     .whatsappLinks!);
                                                                          var whatsapp = "+918700925833";
                                                                          var whatsappurlAndroid =
                                                                              "whatsapp://send?phone=$whatsapp&text=hello";
                                                                          var whatappurlIos =
                                                                              "https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
                                                                          if (Platform.isIOS) {
                                                                            // for iOS phone only
                                                                            if (await canLaunch(
                                                                                whatappurlIos)) {
                                                                              await launch(whatappurlIos,
                                                                                  forceSafariVC: false);
                                                                            } else {
                                                                              ScaffoldMessenger.of(context)
                                                                                  .showSnackBar(const SnackBar(
                                                                                      content: Text(
                                                                                          "whatsapp no installed")));
                                                                            }
                                                                          } else {
                                                                            // android , web
                                                                            if (await canLaunch(
                                                                                whatsappurlAndroid)) {
                                                                              await launch(
                                                                                  whatsappurlAndroid);
                                                                            } else {
                                                                              ScaffoldMessenger.of(context)
                                                                                  .showSnackBar(const SnackBar(
                                                                                      content: Text(
                                                                                          "whatsapp no installed")));
                                                                            }
                                                                          }
                                                                        });
                                                                  },
                                                                  child: Row(
                                                                    children: [
                                                                      Image.asset(
                                                                        AssetUtils.whatsapp,
                                                                        height: 32,
                                                                        width: 32,
                                                                      ),
                                                                      const SizedBox(
                                                                        width: 15,
                                                                      ),
                                                                      const Expanded(
                                                                        child: Text("WhatsApp",
                                                                            overflow: TextOverflow.ellipsis,
                                                                            style: TextStyle(
                                                                                color: Colors.black,
                                                                                fontSize: 16,
                                                                                fontFamily: 'PR')),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                PopupMenuItem(
                                                                  onTap: () {
                                                                    print('');
                                                                    drop_down_pop(
                                                                        title: "Skype",
                                                                        controller:
                                                                            _creator_login_screen_controller
                                                                                .skype_links_controller,
                                                                        back_color: HexColor("#FFFFFF"),
                                                                        onTap: () {
                                                                          update_link_facebook(
                                                                              context: context,
                                                                              index: 8,
                                                                              skype_links:
                                                                                  _creator_login_screen_controller
                                                                                      .skype_links_controller
                                                                                      .text);
                                                                        },
                                                                        onLinkTap: () {
                                                                          _launchUrl(
                                                                              _creator_login_screen_controller
                                                                                  .userInfoModel_email
                                                                                  .value
                                                                                  .data![0]
                                                                                  .skypeLinks!);
                                                                        });
                                                                  },
                                                                  child: Row(
                                                                    children: [
                                                                      Image.asset(
                                                                        AssetUtils.skype,
                                                                        height: 32,
                                                                        width: 32,
                                                                      ),
                                                                      const SizedBox(
                                                                        width: 15,
                                                                      ),
                                                                      const Expanded(
                                                                        child: Text("Skype",
                                                                            overflow: TextOverflow.ellipsis,
                                                                            style: TextStyle(
                                                                                color: Colors.black,
                                                                                fontSize: 16,
                                                                                fontFamily: 'PR')),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                PopupMenuItem(
                                                                  onTap: () {
                                                                    print('');
                                                                    drop_down_pop(
                                                                        title: "YouTube",
                                                                        controller:
                                                                            _creator_login_screen_controller
                                                                                .youtube_links_controller,
                                                                        back_color: HexColor("#FFFFFF"),
                                                                        onTap: () {
                                                                          update_link_facebook(
                                                                              context: context,
                                                                              index: 9,
                                                                              youtube_links:
                                                                                  _creator_login_screen_controller
                                                                                      .youtube_links_controller
                                                                                      .text);
                                                                        },
                                                                        onLinkTap: () {
                                                                          _launchUrl(
                                                                              _creator_login_screen_controller
                                                                                  .userInfoModel_email
                                                                                  .value
                                                                                  .data![0]
                                                                                  .youtubeLinks!);
                                                                        });
                                                                  },
                                                                  child: Row(
                                                                    children: [
                                                                      Image.asset(
                                                                        AssetUtils.youtube,
                                                                        height: 32,
                                                                        width: 32,
                                                                      ),
                                                                      const SizedBox(
                                                                        width: 15,
                                                                      ),
                                                                      const Expanded(
                                                                        child: Text("YouTube",
                                                                            overflow: TextOverflow.ellipsis,
                                                                            style: TextStyle(
                                                                                color: Colors.black,
                                                                                fontSize: 16,
                                                                                fontFamily: 'PR')),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                PopupMenuItem(
                                                                    onTap: () {
                                                                      print('');
                                                                      drop_down_pop(
                                                                          title: "Pinterest",
                                                                          controller:
                                                                              _creator_login_screen_controller
                                                                                  .pinterest_links_controller,
                                                                          back_color: HexColor("#FFFFFF"),
                                                                          onTap: () {
                                                                            update_link_facebook(
                                                                                context: context,
                                                                                index: 10,
                                                                                pinterest_links:
                                                                                    _creator_login_screen_controller
                                                                                        .pinterest_links_controller
                                                                                        .text);
                                                                          },
                                                                          onLinkTap: () {
                                                                            _launchUrl(
                                                                                _creator_login_screen_controller
                                                                                    .userInfoModel_email
                                                                                    .value
                                                                                    .data![0]
                                                                                    .pinterestLinks!);
                                                                          });
                                                                    },
                                                                    child: Row(
                                                                      children: [
                                                                        Image.asset(
                                                                          AssetUtils.pinterest,
                                                                          height: 32,
                                                                          width: 32,
                                                                        ),
                                                                        const SizedBox(
                                                                          width: 15,
                                                                        ),
                                                                        const Expanded(
                                                                          child: Text("Pinterest",
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: TextStyle(
                                                                                  color: Colors.black,
                                                                                  fontSize: 16,
                                                                                  fontFamily: 'PR')),
                                                                        ),
                                                                      ],
                                                                    )),
                                                                PopupMenuItem(
                                                                    onTap: () {
                                                                      print('');
                                                                      drop_down_pop(
                                                                          title: "Redit",
                                                                          controller:
                                                                              _creator_login_screen_controller
                                                                                  .reddit_links_controller,
                                                                          back_color: HexColor("#FFFFFF"),
                                                                          onTap: () {
                                                                            update_link_facebook(
                                                                                context: context,
                                                                                index: 11,
                                                                                reddit_links:
                                                                                    _creator_login_screen_controller
                                                                                        .reddit_links_controller
                                                                                        .text);
                                                                          },
                                                                          onLinkTap: () {
                                                                            _launchUrl(
                                                                                _creator_login_screen_controller
                                                                                    .userInfoModel_email
                                                                                    .value
                                                                                    .data![0]
                                                                                    .redditLinks!);
                                                                          });
                                                                    },
                                                                    child: Row(
                                                                      children: [
                                                                        Image.asset(
                                                                          AssetUtils.reddit,
                                                                          height: 32,
                                                                          width: 32,
                                                                        ),
                                                                        const SizedBox(
                                                                          width: 15,
                                                                        ),
                                                                        const Expanded(
                                                                          child: Text("Redit",
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: TextStyle(
                                                                                  color: Colors.black,
                                                                                  fontSize: 16,
                                                                                  fontFamily: 'PR')),
                                                                        ),
                                                                      ],
                                                                    )),
                                                                PopupMenuItem(
                                                                    onTap: () {
                                                                      print('');
                                                                      drop_down_pop(
                                                                          title: "Telegram",
                                                                          controller:
                                                                              _creator_login_screen_controller
                                                                                  .telegram_links_controller,
                                                                          back_color: HexColor("#FFFFFF"),
                                                                          onTap: () {
                                                                            update_link_facebook(
                                                                                context: context,
                                                                                index: 12,
                                                                                telegram_links:
                                                                                    _creator_login_screen_controller
                                                                                        .telegram_links_controller
                                                                                        .text);
                                                                          },
                                                                          onLinkTap: () {
                                                                            // _launchUrl("https://telegram.me/${_creator_login_screen_controller
                                                                            //     .userInfoModel_email.value
                                                                            //     .data![0]
                                                                            //     .telegramLinks!}");
                                                                            /// Send message via Telegram
                                                                            Telegram.send(
                                                                                username:
                                                                                    _creator_login_screen_controller
                                                                                        .userInfoModel_email
                                                                                        .value
                                                                                        .data![0]
                                                                                        .telegramLinks!,
                                                                                message:
                                                                                    'Thanks for building Telegram Package :)');
                                                                            // _launchUrl(_creator_login_screen_controller
                                                                            //     .userInfoModel_email.value
                                                                            //     .data![0]
                                                                            //     .telegramLinks!);
                                                                          });
                                                                    },
                                                                    child: Row(
                                                                      children: [
                                                                        Image.asset(
                                                                          AssetUtils.telegram,
                                                                          height: 32,
                                                                          width: 32,
                                                                        ),
                                                                        const SizedBox(
                                                                          width: 15,
                                                                        ),
                                                                        const Expanded(
                                                                          child: Text("Telegram",
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: TextStyle(
                                                                                  color: Colors.black,
                                                                                  fontSize: 16,
                                                                                  fontFamily: 'PR')),
                                                                        ),
                                                                      ],
                                                                    )),
                                                              ],
                                                            )
                                                            //     DropdownButtonHideUnderline(
                                                            //   child:
                                                            //       DropdownButton2(
                                                            //     // isExpanded: true,
                                                            //     customButton:
                                                            //         const Icon(
                                                            //       Icons
                                                            //           .keyboard_arrow_down,
                                                            //       color: Colors
                                                            //           .white,
                                                            //       size:
                                                            //           20,
                                                            //     ),
                                                            //     items: [
                                                            //       DropdownMenuItem(
                                                            //           value:
                                                            //               "Apple",
                                                            //           onTap:
                                                            //               () {},
                                                            //           child:
                                                            //               GestureDetector(
                                                            //             onTap: () {
                                                            //               drop_down_pop(
                                                            //                   title: "TikTok",
                                                            //                   controller: _creator_login_screen_controller.tiktok_links_controller,
                                                            //                   back_color: HexColor("#FFFFFF"),
                                                            //                   onTap: () {
                                                            //                     update_link_facebook(context: context, tiktok_links: _creator_login_screen_controller.tiktok_links_controller.text, index: 3);
                                                            //                   },
                                                            //                   onLinkTap: () {
                                                            //                     _launchUrl(_creator_login_screen_controller.userInfoModel_email.value.data![0].tiktokLinks!);
                                                            //                   });
                                                            //             },
                                                            //             child: Row(
                                                            //               children: [
                                                            //                 Image.asset(
                                                            //                   AssetUtils.tiktok,
                                                            //                   height: 32,
                                                            //                   width: 32,
                                                            //                 ),
                                                            //                 const SizedBox(
                                                            //                   width: 15,
                                                            //                 ),
                                                            //                 const Expanded(
                                                            //                   child: Text("TikTok", overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'PR')),
                                                            //                 ),
                                                            //               ],
                                                            //             ),
                                                            //           )),
                                                            //       DropdownMenuItem(
                                                            //           value:
                                                            //               "items2",
                                                            //           onTap:
                                                            //               () {},
                                                            //           child:
                                                            //               GestureDetector(
                                                            //             onTap: () {
                                                            //               drop_down_pop(
                                                            //                   title: "Snapchat",
                                                            //                   controller: _creator_login_screen_controller.snapchat_links_controller,
                                                            //                   back_color: HexColor("#FFFFFF"),
                                                            //                   onTap: () {
                                                            //                     update_link_facebook(context: context, index: 4, snapchat_links: _creator_login_screen_controller.snapchat_links_controller.text);
                                                            //                   },
                                                            //                   onLinkTap: () {
                                                            //                     _launchUrl(_creator_login_screen_controller.userInfoModel_email.value.data![0].snapchatLinks!);
                                                            //                   });
                                                            //             },
                                                            //             child: Row(
                                                            //               children: [
                                                            //                 Image.asset(
                                                            //                   AssetUtils.snapchat,
                                                            //                   height: 32,
                                                            //                   width: 32,
                                                            //                 ),
                                                            //                 const SizedBox(
                                                            //                   width: 15,
                                                            //                 ),
                                                            //                 const Expanded(
                                                            //                   child: Text("Snapchat", overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'PR')),
                                                            //                 ),
                                                            //               ],
                                                            //             ),
                                                            //           )),
                                                            //       DropdownMenuItem(
                                                            //           value:
                                                            //               "items2",
                                                            //           onTap:
                                                            //               () {},
                                                            //           child:
                                                            //               GestureDetector(
                                                            //             onTap: () {
                                                            //               drop_down_pop(
                                                            //                   title: "Linkedin",
                                                            //                   controller: _creator_login_screen_controller.linkedin_links_controller,
                                                            //                   back_color: HexColor("#FFFFFF"),
                                                            //                   onTap: () {
                                                            //                     update_link_facebook(context: context, index: 5, linkedin_links: _creator_login_screen_controller.linkedin_links_controller.text);
                                                            //                   },
                                                            //                   onLinkTap: () {
                                                            //                     _launchUrl(_creator_login_screen_controller.userInfoModel_email.value.data![0].linkedinLinks!);
                                                            //                   });
                                                            //             },
                                                            //             child: Row(
                                                            //               children: [
                                                            //                 Image.asset(
                                                            //                   AssetUtils.linkedin,
                                                            //                   height: 32,
                                                            //                   width: 32,
                                                            //                 ),
                                                            //                 const SizedBox(
                                                            //                   width: 15,
                                                            //                 ),
                                                            //                 const Expanded(
                                                            //                   child: Text("Linkedin", overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'PR')),
                                                            //                 ),
                                                            //               ],
                                                            //             ),
                                                            //           )),
                                                            //       DropdownMenuItem(
                                                            //           value:
                                                            //               "items2",
                                                            //           onTap:
                                                            //               () {
                                                            //             print('');
                                                            //           },
                                                            //           child:
                                                            //               GestureDetector(
                                                            //             onTap: () {
                                                            //               drop_down_pop(
                                                            //                   title: "Gmail",
                                                            //                   controller: _creator_login_screen_controller.gmail_links_controller,
                                                            //                   back_color: HexColor("#FFFFFF"),
                                                            //                   onTap: () {
                                                            //                     update_link_facebook(context: context, index: 6, gmail_links: _creator_login_screen_controller.gmail_links_controller.text);
                                                            //                   },
                                                            //                   onLinkTap: () {
                                                            //                     _launchUrl(_creator_login_screen_controller.userInfoModel_email.value.data![0].gmailLinks!);
                                                            //                   });
                                                            //             },
                                                            //             child: Row(
                                                            //               children: [
                                                            //                 Image.asset(
                                                            //                   AssetUtils.gmail,
                                                            //                   height: 32,
                                                            //                   width: 32,
                                                            //                 ),
                                                            //                 const SizedBox(
                                                            //                   width: 15,
                                                            //                 ),
                                                            //                 const Expanded(
                                                            //                   child: Text("Gmail", overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'PR')),
                                                            //                 ),
                                                            //               ],
                                                            //             ),
                                                            //           )),
                                                            //       DropdownMenuItem(
                                                            //           value:
                                                            //               "items2",
                                                            //           onTap:
                                                            //               () {
                                                            //             print('');
                                                            //           },
                                                            //           child:
                                                            //               GestureDetector(
                                                            //             onTap: () {
                                                            //               drop_down_pop(
                                                            //                   title: "WhatsApp",
                                                            //                   controller: _creator_login_screen_controller.whatsapp_links_controller,
                                                            //                   back_color: HexColor("#FFFFFF"),
                                                            //                   onTap: () {
                                                            //                     update_link_facebook(context: context, index: 7, whatsapp_links: _creator_login_screen_controller.whatsapp_links_controller.text);
                                                            //                   },
                                                            //                   onLinkTap: () async {
                                                            //                     // _launchUrl(_creator_login_screen_controller
                                                            //                     //     .userInfoModel_email.value
                                                            //                     //     .data![0]
                                                            //                     //     .whatsappLinks!);
                                                            //                     var whatsapp = "+918700925833";
                                                            //                     var whatsappurlAndroid = "whatsapp://send?phone=$whatsapp&text=hello";
                                                            //                     var whatappurlIos = "https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
                                                            //                     if (Platform.isIOS) {
                                                            //                       // for iOS phone only
                                                            //                       if (await canLaunch(whatappurlIos)) {
                                                            //                         await launch(whatappurlIos, forceSafariVC: false);
                                                            //                       } else {
                                                            //                         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("whatsapp no installed")));
                                                            //                       }
                                                            //                     } else {
                                                            //                       // android , web
                                                            //                       if (await canLaunch(whatsappurlAndroid)) {
                                                            //                         await launch(whatsappurlAndroid);
                                                            //                       } else {
                                                            //                         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("whatsapp no installed")));
                                                            //                       }
                                                            //                     }
                                                            //                   });
                                                            //             },
                                                            //             child: Row(
                                                            //               children: [
                                                            //                 Image.asset(
                                                            //                   AssetUtils.whatsapp,
                                                            //                   height: 32,
                                                            //                   width: 32,
                                                            //                 ),
                                                            //                 const SizedBox(
                                                            //                   width: 15,
                                                            //                 ),
                                                            //                 const Expanded(
                                                            //                   child: Text("WhatsApp", overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'PR')),
                                                            //                 ),
                                                            //               ],
                                                            //             ),
                                                            //           )),
                                                            //       DropdownMenuItem(
                                                            //           value:
                                                            //               "items2",
                                                            //           child:
                                                            //               GestureDetector(
                                                            //             onTap: () {
                                                            //               print('');
                                                            //               drop_down_pop(
                                                            //                   title: "Skype",
                                                            //                   controller: _creator_login_screen_controller.skype_links_controller,
                                                            //                   back_color: HexColor("#FFFFFF"),
                                                            //                   onTap: () {
                                                            //                     update_link_facebook(context: context, index: 8, skype_links: _creator_login_screen_controller.skype_links_controller.text);
                                                            //                   },
                                                            //                   onLinkTap: () {
                                                            //                     _launchUrl(_creator_login_screen_controller.userInfoModel_email.value.data![0].skypeLinks!);
                                                            //                   });
                                                            //             },
                                                            //             child: Row(
                                                            //               children: [
                                                            //                 Image.asset(
                                                            //                   AssetUtils.skype,
                                                            //                   height: 32,
                                                            //                   width: 32,
                                                            //                 ),
                                                            //                 const SizedBox(
                                                            //                   width: 15,
                                                            //                 ),
                                                            //                 const Expanded(
                                                            //                   child: Text("Skype", overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'PR')),
                                                            //                 ),
                                                            //               ],
                                                            //             ),
                                                            //           )),
                                                            //       DropdownMenuItem(
                                                            //           value:
                                                            //               "items2",
                                                            //           child:
                                                            //               GestureDetector(
                                                            // onTap: () {
                                                            //   print('');
                                                            //   drop_down_pop(
                                                            //       title: "YouTube",
                                                            //       controller: _creator_login_screen_controller.youtube_links_controller,
                                                            //       back_color: HexColor("#FFFFFF"),
                                                            //       onTap: () {
                                                            //         update_link_facebook(context: context, index: 9, youtube_links: _creator_login_screen_controller.youtube_links_controller.text);
                                                            //       },
                                                            //       onLinkTap: () {
                                                            //         _launchUrl(_creator_login_screen_controller.userInfoModel_email.value.data![0].youtubeLinks!);
                                                            //       });
                                                            // },
                                                            // child: Row(
                                                            //   children: [
                                                            //     Image.asset(
                                                            //       AssetUtils.youtube,
                                                            //       height: 32,
                                                            //       width: 32,
                                                            //     ),
                                                            //     const SizedBox(
                                                            //       width: 15,
                                                            //     ),
                                                            //     const Expanded(
                                                            //       child: Text("YouTube", overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'PR')),
                                                            //     ),
                                                            //   ],
                                                            // ),
                                                            //           )),
                                                            // DropdownMenuItem(
                                                            //     value:
                                                            //         "items2",
                                                            //     child:
                                                            //         GestureDetector(
                                                            //       onTap: () {
                                                            //         print('');
                                                            //         drop_down_pop(
                                                            //             title: "Pinterest",
                                                            //             controller: _creator_login_screen_controller.pinterest_links_controller,
                                                            //             back_color: HexColor("#FFFFFF"),
                                                            //             onTap: () {
                                                            //               update_link_facebook(context: context, index: 10, pinterest_links: _creator_login_screen_controller.pinterest_links_controller.text);
                                                            //             },
                                                            //             onLinkTap: () {
                                                            //               _launchUrl(_creator_login_screen_controller.userInfoModel_email.value.data![0].pinterestLinks!);
                                                            //             });
                                                            //       },
                                                            //       child: Row(
                                                            //         children: [
                                                            //           Image.asset(
                                                            //             AssetUtils.pinterest,
                                                            //             height: 32,
                                                            //             width: 32,
                                                            //           ),
                                                            //           const SizedBox(
                                                            //             width: 15,
                                                            //           ),
                                                            //           const Expanded(
                                                            //             child: Text("Pinterest", overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'PR')),
                                                            //           ),
                                                            //         ],
                                                            //       ),
                                                            //     )),
                                                            // DropdownMenuItem(
                                                            //     value:
                                                            //         "items2",
                                                            //     child:
                                                            //         GestureDetector(
                                                            //       onTap: () {
                                                            //         print('');
                                                            //         drop_down_pop(
                                                            //             title: "Redit",
                                                            //             controller: _creator_login_screen_controller.reddit_links_controller,
                                                            //             back_color: HexColor("#FFFFFF"),
                                                            //             onTap: () {
                                                            //               update_link_facebook(context: context, index: 11, reddit_links: _creator_login_screen_controller.reddit_links_controller.text);
                                                            //             },
                                                            //             onLinkTap: () {
                                                            //               _launchUrl(_creator_login_screen_controller.userInfoModel_email.value.data![0].redditLinks!);
                                                            //             });
                                                            //       },
                                                            //       child: Row(
                                                            //         children: [
                                                            //           Image.asset(
                                                            //             AssetUtils.reddit,
                                                            //             height: 32,
                                                            //             width: 32,
                                                            //           ),
                                                            //           const SizedBox(
                                                            //             width: 15,
                                                            //           ),
                                                            //           const Expanded(
                                                            //             child: Text("Redit", overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'PR')),
                                                            //           ),
                                                            //         ],
                                                            //       ),
                                                            //     )),
                                                            // DropdownMenuItem(
                                                            //     value:
                                                            //         "items2",
                                                            //     child:
                                                            //         GestureDetector(
                                                            //       onTap: () {
                                                            //         print('');
                                                            //         drop_down_pop(
                                                            //             title: "Telegram",
                                                            //             controller: _creator_login_screen_controller.telegram_links_controller,
                                                            //             back_color: HexColor("#FFFFFF"),
                                                            //             onTap: () {
                                                            //               update_link_facebook(context: context, index: 12, telegram_links: _creator_login_screen_controller.telegram_links_controller.text);
                                                            //             },
                                                            //             onLinkTap: () {
                                                            //               // _launchUrl("https://telegram.me/${_creator_login_screen_controller
                                                            //               //     .userInfoModel_email.value
                                                            //               //     .data![0]
                                                            //               //     .telegramLinks!}");
                                                            //               /// Send message via Telegram
                                                            //               Telegram.send(username: _creator_login_screen_controller.userInfoModel_email.value.data![0].telegramLinks!, message: 'Thanks for building Telegram Package :)');
                                                            //               // _launchUrl(_creator_login_screen_controller
                                                            //               //     .userInfoModel_email.value
                                                            //               //     .data![0]
                                                            //               //     .telegramLinks!);
                                                            //             });
                                                            //       },
                                                            //       child: Row(
                                                            //         children: [
                                                            //           Image.asset(
                                                            //             AssetUtils.telegram,
                                                            //             height: 32,
                                                            //             width: 32,
                                                            //           ),
                                                            //           const SizedBox(
                                                            //             width: 15,
                                                            //           ),
                                                            //           const Expanded(
                                                            //             child: Text("Telegram", overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'PR')),
                                                            //           ),
                                                            //         ],
                                                            //       ),
                                                            //     )),
                                                            //     ],
                                                            //     value:
                                                            //         dropdownvalue,
                                                            //     style:
                                                            //         const TextStyle(
                                                            //       fontSize:
                                                            //           16,
                                                            //       fontFamily:
                                                            //           'PR',
                                                            //       color: Colors
                                                            //           .white,
                                                            //     ),
                                                            //     alignment:
                                                            //         Alignment
                                                            //             .centerLeft,
                                                            //     onChanged:
                                                            //         (value) {
                                                            //       setState(
                                                            //           () {});
                                                            //     },
                                                            //     // iconSize: 25,
                                                            //     // icon: IconButton(
                                                            //     //   icon: Icon(
                                                            //     //     Icons.keyboard_arrow_down,
                                                            //     //     color: Colors.white,
                                                            //     //     size: 20,
                                                            //     //   ),
                                                            //     //   onPressed: () {
                                                            //     //     print("Dadadadada");
                                                            //     //   },
                                                            //     // ),

                                                            //     // iconEnabledColor: Color(0xff007DEF),
                                                            //     // iconDisabledColor: Color(0xff007DEF),
                                                            //     // buttonHeight: 50,
                                                            //     // buttonWidth: 100,
                                                            //     // enableFeedback: true,
                                                            //     // buttonPadding:
                                                            //     //     const EdgeInsets.only(left: 15, right: 15),
                                                            //     // buttonDecoration: BoxDecoration(
                                                            //     //     borderRadius: BorderRadius.circular(10),
                                                            //     //     color: Colors.transparent),
                                                            //     // buttonElevation: 0,
                                                            //     // itemHeight: 40,
                                                            //     // itemPadding:
                                                            //     //     const EdgeInsets.only(left: 14, right: 14),
                                                            //     // // dropdownMaxHeight: 200,
                                                            //     // dropdownWidth:
                                                            //     //     MediaQuery.of(context).size.width / 2.5,
                                                            //     // dropdownDecoration: BoxDecoration(
                                                            //     //     borderRadius: BorderRadius.circular(24),
                                                            //     //     border: Border.all(width: 1, color: Colors.white),
                                                            //     //     color: Colors.white
                                                            //     //     // gradient: LinearGradient(
                                                            //     //     //   begin: Alignment.topLeft,
                                                            //     //     //   end: Alignment.bottomRight,
                                                            //     //     //   // stops: [0.1, 0.5, 0.7, 0.9],
                                                            //     //     //   colors: [
                                                            //     //     //     HexColor("#000000"),
                                                            //     //     //     HexColor("#C12265"),
                                                            //     //     //     // HexColor("#FFFFFF"),
                                                            //     //     //   ],
                                                            //     //     // ),
                                                            //     //     ),
                                                            //     // dropdownElevation: 8,
                                                            //     // scrollbarRadius: const Radius.circular(40),
                                                            //     // scrollbarThickness: 6,
                                                            //     // scrollbarAlwaysShow: true,
                                                            //     // offset: const Offset(-10, -10),
                                                            //   ),
                                                            // ),

                                                            ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        Container(
                                                          // height: 45,
                                                          // width:(width ?? 300) ,
                                                          decoration: BoxDecoration(
                                                              color: Colors.white,
                                                              borderRadius: BorderRadius.circular(25)),
                                                          child: Container(
                                                              alignment: Alignment.center,
                                                              margin: const EdgeInsets.symmetric(
                                                                  vertical: 0, horizontal: 20),
                                                              child: PopupMenuButton(
                                                                padding: const EdgeInsets.all(0),
                                                                iconSize: 5,
                                                                icon: const Text(
                                                                  'Invite',
                                                                  style: TextStyle(
                                                                      color: Colors.black,
                                                                      fontFamily: 'PR',
                                                                      fontSize: 16),
                                                                ),
                                                                itemBuilder: (context) => [
                                                                  PopupMenuItem(
                                                                      onTap: () async {
                                                                        final Email email = Email(
                                                                          body: 'Start using funky ',
                                                                          subject: 'FUNKY invitation',
                                                                          recipients: [],
                                                                          cc: [],
                                                                          bcc: [],
                                                                          // attachmentPaths: ['/path/to/attachment.zip'],
                                                                          isHTML: false,
                                                                        );

                                                                        await FlutterEmailSender.send(email);
                                                                      },
                                                                      child: const Text('Email',
                                                                          overflow: TextOverflow.ellipsis,
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 16,
                                                                              fontFamily: 'PR'))),
                                                                  PopupMenuItem(
                                                                      onTap: () async {
                                                                        String message =
                                                                            "This is a test message!";
                                                                        List<String> recipents = [
                                                                          "1234567890",
                                                                          "5556787676"
                                                                        ];
                                                                        await SmsMms.send(
                                                                            recipients: [], message: message);
                                                                      },
                                                                      child: const Text('Phone',
                                                                          overflow: TextOverflow.ellipsis,
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 16,
                                                                              fontFamily: 'PR'))),
                                                                  PopupMenuItem(
                                                                      onTap: () async {
                                                                        Share.share("APP_LINK",
                                                                            subject: 'Share App');
                                                                      },
                                                                      child: const Text('Others',
                                                                          overflow: TextOverflow.ellipsis,
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 16,
                                                                              fontFamily: 'PR'))),
                                                                ],
                                                              )),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Container(
                                                          margin: const EdgeInsets.symmetric(horizontal: 0),
                                                          // height: 45,
                                                          // width:(width ?? 300) ,
                                                          // decoration: BoxDecoration(
                                                          //     color: Colors.white,
                                                          //     borderRadius:
                                                          //         BorderRadius
                                                          //             .circular(
                                                          //                 25)),
                                                          child: Container(
                                                            // alignment:
                                                            //     Alignment.center,
                                                            // margin: EdgeInsets
                                                            //     .symmetric(
                                                            //         vertical: 10,
                                                            //         horizontal:
                                                            //             30),
                                                            child: Image.asset(
                                                              AssetUtils.chat_call_icon,
                                                              height: 45.0,
                                                              // color: Colors.black,
                                                              width: 45.0,
                                                              fit: BoxFit.contain,
                                                            ),
                                                            // Text(
                                                            //   'Chat',
                                                            //   style: TextStyle(
                                                            //       color: Colors
                                                            //           .black,
                                                            //       fontFamily:
                                                            //           'PR',
                                                            //       fontSize: 16),
                                                            // )
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ]),
                                        ),
                                      ),

                                      Container(
                                        margin: const EdgeInsets.only(bottom: 15, top: 10),
                                        color: HexColor(CommonColor.pinkFont).withOpacity(0.7),
                                        height: 1,
                                        width: MediaQuery.of(context).size.width,
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 0, right: 0, left: 0),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Column(
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.symmetric(horizontal: 5),
                                                  height: 60,
                                                  width: 60,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(50),
                                                      border: Border.all(color: Colors.white, width: 3)),
                                                  child: IconButton(
                                                    visualDensity:
                                                        const VisualDensity(vertical: -4, horizontal: -4),
                                                    onPressed: () async {
                                                      // File editedFile = await Navigator
                                                      //         .of(context)
                                                      //     .push(MaterialPageRoute(
                                                      //         builder: (context) =>
                                                      //             StoriesEditor(
                                                      //               // fontFamilyList: font_family,
                                                      //               giphyKey: '',
                                                      //               onDone:
                                                      //                   (String) {},
                                                      //               // filePath:
                                                      //               //     imgFile!.path,
                                                      //             )));
                                                      // if (editedFile != null) {
                                                      //   print(
                                                      //       'editedFile: ${editedFile.path}');
                                                      // }
                                                      // openCamera();
                                                      pop_up();
                                                    },
                                                    icon: Icon(
                                                      Icons.add,
                                                      color: HexColor(CommonColor.pinkFont),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                const Text(
                                                  'Add Story',
                                                  style: TextStyle(
                                                      color: Colors.white, fontFamily: 'PR', fontSize: 12),
                                                )
                                              ],
                                            ),
                                            Expanded(
                                              child: SizedBox(
                                                  height: 88,
                                                  child: Obx(() => (_profile_screen_controller
                                                              .isStoryLoading.value ==
                                                          true
                                                      ? const LoaderPage()
                                                      : (_profile_screen_controller
                                                              .getStoryModel!.data!.isNotEmpty
                                                          ? ListView.builder(
                                                              itemCount:
                                                                  _profile_screen_controller.story_.length,
                                                              shrinkWrap: true,
                                                              scrollDirection: Axis.horizontal,
                                                              itemBuilder: (BuildContext context, int index) {
                                                                return Padding(
                                                                  padding: const EdgeInsets.symmetric(
                                                                    horizontal: 8.0,
                                                                  ),
                                                                  child: Column(
                                                                    children: [
                                                                      GestureDetector(
                                                                        onTap: () {
                                                                          print(index);
                                                                          _profile_screen_controller
                                                                                  .story_info =
                                                                              _profile_screen_controller
                                                                                  .getStoryModel!
                                                                                  .data![index]
                                                                                  .storys!;
                                                                          print(_profile_screen_controller
                                                                              .story_info);
                                                                          Get.to(() => StoryScreen(
                                                                                other_user: false,
                                                                                title:
                                                                                    _profile_screen_controller
                                                                                        .story_[index].title!,
                                                                                mohit:
                                                                                    _profile_screen_controller
                                                                                        .getStoryModel!
                                                                                        .data![index],
                                                                                // thumbnail:
                                                                                //     test_thumb[index],
                                                                                stories:
                                                                                    _profile_screen_controller
                                                                                        .story_info,
                                                                                story_no: 0,
                                                                                stories_title:
                                                                                    _profile_screen_controller
                                                                                        .story_,
                                                                              ));
                                                                          // Get.to(StoryScreen(stories: story_info));
                                                                        },
                                                                        child: SizedBox(
                                                                          height: 60,
                                                                          width: 60,
                                                                          child: ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(50),
                                                                            child: (_profile_screen_controller
                                                                                        .story_[index]
                                                                                        .storys!
                                                                                        .isNotEmpty &&
                                                                                    _profile_screen_controller
                                                                                        .story_[index]
                                                                                        .storys![0]
                                                                                        .storyPhoto!
                                                                                        .isEmpty
                                                                                ? Image.asset(
                                                                                    // test_thumb[
                                                                                    //     index]
                                                                                    'assets/images/Funky_App_Icon.png')
                                                                                : (_profile_screen_controller
                                                                                            .story_[index]
                                                                                            .storys!
                                                                                            .isNotEmpty &&
                                                                                        _profile_screen_controller
                                                                                                .story_[index]
                                                                                                .storys![0]
                                                                                                .isVideo ==
                                                                                            'false'
                                                                                    ?
                                                                                    // Image.file(test_thumb[index])
                                                                                    FadeInImage.assetNetwork(
                                                                                        fit: BoxFit.cover,
                                                                                        image:
                                                                                            "${URLConstants.base_data_url}images/${_profile_screen_controller.story_[index].storys![0].storyPhoto!}",
                                                                                        placeholder:
                                                                                            'assets/images/Funky_App_Icon.png',
                                                                                        // color: HexColor(CommonColor.pinkFont),
                                                                                      )
                                                                                    : Image.asset(
                                                                                        // test_thumb[
                                                                                        //     index]
                                                                                        'assets/images/Funky_App_Icon.png'))),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 5,
                                                                      ),
                                                                      (_profile_screen_controller
                                                                                  .story_[index]
                                                                                  .title!
                                                                                  .length >=
                                                                              5
                                                                          ? SizedBox(
                                                                              height: 20,
                                                                              width: 40,
                                                                              child: Marquee(
                                                                                text:
                                                                                    '${_profile_screen_controller.story_[index].title}',
                                                                                style: const TextStyle(
                                                                                    color: Colors.white,
                                                                                    fontFamily: 'PR',
                                                                                    fontSize: 14),
                                                                                scrollAxis: Axis.horizontal,
                                                                                crossAxisAlignment:
                                                                                    CrossAxisAlignment.start,
                                                                                blankSpace: 20.0,
                                                                                velocity: 30.0,
                                                                                pauseAfterRound:
                                                                                    const Duration(
                                                                                        milliseconds: 100),
                                                                                startPadding: 10.0,
                                                                                accelerationDuration:
                                                                                    const Duration(
                                                                                        seconds: 1),
                                                                                accelerationCurve:
                                                                                    Curves.easeIn,
                                                                                decelerationDuration:
                                                                                    const Duration(
                                                                                        microseconds: 500),
                                                                                decelerationCurve:
                                                                                    Curves.easeOut,
                                                                              ),
                                                                            )
                                                                          : Text(
                                                                              '${_profile_screen_controller.story_[index].title}',
                                                                              style: const TextStyle(
                                                                                  color: Colors.white,
                                                                                  fontFamily: 'PR',
                                                                                  fontSize: 14),
                                                                            ))
                                                                    ],
                                                                  ),
                                                                );
                                                              })
                                                          : const SizedBox())))),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(bottom: 0, top: 5),
                                        color: HexColor(CommonColor.pinkFont).withOpacity(0.7),
                                        height: 1,
                                        width: MediaQuery.of(context).size.width,
                                      ),
                                    ]),
                            ),
                          )),
                        ),
                      )),
                  bottom: TabBar(
                    padding: EdgeInsets.zero,
                    indicatorColor: Colors.transparent,
                    controller: _tabController,
                    tabs: (idUserType == 'Advertiser' ? _tabs2 : _tabs),
                  )),
            ];
          },
          body: TabBarView(
            physics: const BouncingScrollPhysics(),
            controller: _tabController,
            children: [
              video_screen(),
              (idUserType == 'Advertiser' ? brand_logo_screen() : gallery_screen()),
              (idUserType == 'Advertiser' ? brand_banner_screen() : Rewards_screen()),
              music_list(),
              tagged_list(),
            ],
          ),
        ));
  }

  Widget brand_logo_screen() {
    return Container(
      margin: const EdgeInsets.only(top: 10, right: 16, left: 16),
      child: RefreshIndicator(
        color: HexColor(CommonColor.pinkFont),
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          String idUser = await PreferenceManager().getPref(URLConstants.id);

          await _profile_screen_controller.get_brand_logo(context: context, user_id: idUser);
        },
        child: SingleChildScrollView(
            child: Obx(() => (_profile_screen_controller.isBrandLogoLoading.value == true
                ? const Center(child: LoaderPage())
                : (_profile_screen_controller.brandLogoList!.error == false
                    ? StaggeredGridView.countBuilder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 4,
                        staggeredTileBuilder: (int index) => StaggeredTile.count(2, index.isEven ? 3 : 2),
                        mainAxisSpacing: 4.0,
                        crossAxisSpacing: 4.0,
                        itemCount: _profile_screen_controller.brandLogoList!.data!.length,
                        itemBuilder: (context, index) => ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: SizedBox(
                            height: 120.0,
                            // width: 120.0,
                            child: (_profile_screen_controller.isBrandLogoLoading.value == true
                                ? CircularProgressIndicator(
                                    color: HexColor(CommonColor.pinkFont),
                                  )
                                : GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      color: Colors.black,
                                      child: (_profile_screen_controller
                                              .brandLogoList!.data![index].logo!.isEmpty
                                          ? Image.asset(AssetUtils.logo)
                                          : FadeInImage.assetNetwork(
                                              fit: BoxFit.cover,
                                              image:
                                                  "${URLConstants.base_data_url}images/${_profile_screen_controller.brandLogoList!.data![index].logo}",
                                              placeholder: 'assets/images/Funky_App_Icon.png',
                                              // color: HexColor(CommonColor.pinkFont),
                                            )),
                                    ),
                                  )),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Container(
                            margin: const EdgeInsets.only(top: 50),
                            child: Text("${_profile_screen_controller.brandLogoList!.message}",
                                style: const TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'PR')),
                          ),
                        ),
                      ))))),
      ),
    );
  }

  Widget brand_banner_screen() {
    return Container(
      margin: const EdgeInsets.only(top: 10, right: 16, left: 16),
      child: RefreshIndicator(
        color: HexColor(CommonColor.pinkFont),
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          String idUser = await PreferenceManager().getPref(URLConstants.id);

          await _profile_screen_controller.get_banner_list(context: context, user_id: idUser);
        },
        child: SingleChildScrollView(
            child: Obx(() => (_profile_screen_controller.isBannerLoading.value == true
                ? const Center(child: LoaderPage())
                : (_profile_screen_controller.bannerGetList!.error == false
                    ? StaggeredGridView.countBuilder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 4,
                        staggeredTileBuilder: (int index) => StaggeredTile.count(2, index.isEven ? 3 : 2),
                        mainAxisSpacing: 4.0,
                        crossAxisSpacing: 4.0,
                        itemCount: _profile_screen_controller.bannerGetList!.data!.length,
                        itemBuilder: (context, index) => ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: SizedBox(
                            height: 120.0,
                            // width: 120.0,
                            child: (_profile_screen_controller.isBannerLoading.value == true
                                ? CircularProgressIndicator(
                                    color: HexColor(CommonColor.pinkFont),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      // Get.to(ImagePostScreen(
                                      //   imageListModel:
                                      //       _profile_screen_controller
                                      //           .galleryModelList!,
                                      //   index_: index,
                                      // ));
                                    },
                                    child: Container(
                                      color: Colors.black,
                                      child: (_profile_screen_controller
                                                  .bannerGetList!.data![index].logo!.isEmpty
                                              ? Image.asset(
                                                  'assets/images/Funky_App_Icon.png',
                                                  fit: BoxFit.cover,
                                                )
                                              : FadeInImage.assetNetwork(
                                                  fit: BoxFit.cover,
                                                  image:
                                                      "${URLConstants.base_data_url}images/${_profile_screen_controller.bannerGetList!.data![index].logo}",
                                                  placeholder: 'assets/images/Funky_App_Icon.png',
                                                  // color: HexColor(CommonColor.pinkFont),
                                                )
                                          // Image.network(
                                          //         '${URLConstants.base_data_url}images/${_galleryModelList!.data![index].postImage}',
                                          //         fit: BoxFit.cover,
                                          //         loadingBuilder: (context, child,
                                          //             loadingProgress) {
                                          //           if (loadingProgress == null) {
                                          //             return child;
                                          //           }
                                          //           return Center(
                                          //               child: SizedBox(
                                          //                   height: 30,
                                          //                   width: 30,
                                          //                   child:
                                          //                       CircularProgressIndicator(
                                          //                     color: HexColor(
                                          //                         CommonColor
                                          //                             .pinkFont),
                                          //                   )));
                                          //           // You can use LinearProgressIndicator, CircularProgressIndicator, or a GIF instead
                                          //         },
                                          //       )
                                          ),
                                    ),
                                  )),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Container(
                            margin: const EdgeInsets.only(top: 50),
                            child: Text("${_profile_screen_controller.bannerGetList!.message}",
                                style: const TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'PR')),
                          ),
                        ),
                      ))))),
      ),
    );
  }

  Widget gallery_screen() {
    return Container(
      margin: const EdgeInsets.only(top: 10, right: 16, left: 16),
      child: RefreshIndicator(
        color: HexColor(CommonColor.pinkFont),
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          String idUser = await PreferenceManager().getPref(URLConstants.id);

          await _profile_screen_controller.get_gallery_list(
              context: context, user_id: idUser, login_user_id: idUser);
        },
        child: SingleChildScrollView(
            child: Obx(() => (_profile_screen_controller.ispostLoading.value == true
                ? const Center(child: LoaderPage())
                : (_profile_screen_controller.galleryModelList!.error == false
                    ? GridView.count(
                        shrinkWrap: true,
                        childAspectRatio: 9 / 13,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 8.0,
                        children: List.generate(
                            _profile_screen_controller.galleryModelList!.data!.length,
                            (index) => ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: SizedBox(
                                    height: 120.0,
                                    // width: 120.0,
                                    child: (_profile_screen_controller.ispostLoading.value == true
                                        ? CircularProgressIndicator(
                                            color: HexColor(CommonColor.pinkFont),
                                          )
                                        : GestureDetector(
                                            onTap: () {
                                              Get.to(ImagePostScreen(
                                                imageListModel: _profile_screen_controller.galleryModelList!,
                                                index_: index,
                                              ));
                                            },
                                            child: Container(
                                              color: Colors.black,
                                              child: (_profile_screen_controller
                                                      .galleryModelList!.data![index].postImage!.isEmpty
                                                  ? Image.asset(AssetUtils.logo)
                                                  : FadeInImage.assetNetwork(
                                                      fit: BoxFit.cover,
                                                      image:
                                                          "${URLConstants.base_data_url}images/${_profile_screen_controller.galleryModelList!.data![index].postImage}",
                                                      placeholder: 'assets/images/Funky_App_Icon.png',
                                                    )),
                                            ),
                                          )),
                                  ),
                                )),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Container(
                            margin: const EdgeInsets.only(top: 50),
                            child: Text("${_profile_screen_controller.galleryModelList!.message}",
                                style: const TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'PR')),
                          ),
                        ),
                      ))))),
      ),
    );
  }

  // bool ispostLoading = true;
  // GalleryModelList? _galleryModelList;

  // Future<dynamic> get_gallery_list(BuildContext context) async {
  //   setState(() {
  //     ispostLoading = true;
  //   });
  //   // showLoader(context);
  //
  //   String idUser = await PreferenceManager().getPref(URLConstants.id);
  //
  //   debugPrint('0-0-0-0-0-0-0 username');
  //   Map data = {'userId': idUser, 'isVideo': 'false', 'login_user_id': idUser};
  //   print(data);
  //   // String body = json.encode(data);
  //
  //   var url = ('${URLConstants.base_url}galleryList.php');
  //   print("url : $url");
  //   print("body : $data");
  //   var response = await http.post(
  //     Uri.parse(url),
  //     body: data,
  //   );
  //   print(response.body);
  //   print(response.request);
  //   print(response.statusCode);
  //   // var final_data = jsonDecode(response.body);
  //   // print('final data $final_data');
  //   if (response.statusCode == 200) {
  //     var data = jsonDecode(response.body);
  //     _galleryModelList = GalleryModelList.fromJson(data);
  //
  //     if (_galleryModelList!.error == false) {
  //       CommonWidget().showToaster(msg: 'Succesful');
  //       // print(_galleryModelList);
  //       setState(() {
  //         ispostLoading = false;
  //       });
  //       // print(_galleryModelList!.data![0].postImage);
  //       // print(_galleryModelList!.data![1].postImage);
  //
  //       // hideLoader(context);
  //       // Get.to(Dashboard());
  //     } else {
  //       setState(() {
  //         ispostLoading = false;
  //       });
  //       print('Please try again');
  //     }
  //   } else {
  //     print('Please try again');
  //   }
  // }

  // bool isvideoLoading = true;
  // bool isthumbLoading = true;
  // VideoModelList? videoModelList;
  // String? filePath;
  // List<File> imgFile_list = [];

  // Future<dynamic> get_video_list(BuildContext context) async {
  //   setState(() {
  //     isvideoLoading = true;
  //   });
  //   // showLoader(context);
  //
  //   String idUser = await PreferenceManager().getPref(URLConstants.id);
  //
  //   debugPrint('0-0-0-0-0-0-0 username');
  //   Map data = {'userId': idUser, 'isVideo': 'true', 'login_user_id': idUser};
  //   print(data);
  //   // String body = json.encode(data);
  //
  //   var url = ('${URLConstants.base_url}post-videoList.php');
  //   print("url : $url");
  //   print("body : $data");
  //   var response = await http.post(
  //     Uri.parse(url),
  //     body: data,
  //   );
  //   print(response.body);
  //   print(response.request);
  //   print(response.statusCode);
  //   // var final_data = jsonDecode(response.body);
  //   // print('final data $final_data');
  //   if (response.statusCode == 200) {
  //     var data = jsonDecode(response.body);
  //     videoModelList = VideoModelList.fromJson(data);
  //
  //     if (videoModelList!.error == false) {
  //       CommonWidget().showToaster(msg: 'Succesful');
  //       // print(videoModelList);
  //
  //       print("videoModelList!.data!.length");
  //       print(videoModelList!.data!.length);
  //       setState(() {
  //         isvideoLoading = false;
  //       });
  //       setState(() {
  //         isthumbLoading = true;
  //       });
  //       for (int i = 0; i < videoModelList!.data!.length; i++) {
  //         final uint8list = await VideoThumbnail.thumbnailFile(
  //           video:
  //           ("http://foxyserver.com/funky/video/${videoModelList!.data![i]
  //               .uploadVideo}"),
  //           thumbnailPath: (await getTemporaryDirectory()).path,
  //           imageFormat: ImageFormat.PNG,
  //           // maxHeight: 64,
  //           // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
  //           quality: 10,
  //         );
  //         print(uint8list);
  //
  //         imgFile_list.add(File(uint8list!));
  //         // print(test_thumb[i].path);
  //
  //         // hideLoader(context);
  //         // print("test----------${imgFile_list[i].path}");
  //       }
  //       setState(() {
  //         isthumbLoading = false;
  //       });
  //
  //       // print("thumbaaaa ;; $imgFile_list");
  //     } else {
  //       setState(() {
  //         isvideoLoading = false;
  //       });
  //       // hideLoader(context);
  //
  //       print('Please try again');
  //     }
  //   } else {
  //     print('Please try again');
  //   }
  // }

  Widget video_screen() {
    return Container(
      margin: const EdgeInsets.only(top: 10, right: 16, left: 16),
      child: RefreshIndicator(
        color: HexColor(CommonColor.pinkFont),
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          String idUser = await PreferenceManager().getPref(URLConstants.id);

          await _profile_screen_controller.get_video_list(
              context: context, user_id: idUser, login_user_id: idUser);
          String socialTypeUser = await PreferenceManager().getPref(URLConstants.social_type);
          print("id----- $idUser");
          print("id----- $socialTypeUser");
          (socialTypeUser == ""
              ? await _creator_login_screen_controller.CreatorgetUserInfo_Email(
                  context: context, UserId: idUser)
              : await _creator_login_screen_controller.getUserInfo_social());
        },
        child: SingleChildScrollView(
            child: Obx(() => (_profile_screen_controller.isvideoLoading.value == true
                ? const Center(child: LoaderPage())
                : (_profile_screen_controller.videoModelList!.error == false
                    ? GridView.count(
                        shrinkWrap: true,
                        childAspectRatio: 9 / 13,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 8.0,
                        children: List.generate(
                            _profile_screen_controller.videoModelList!.data!.length,
                            (index) => Padding(
                                  padding: EdgeInsets.only(top: index.isOdd ? 20 : 0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Positioned.fill(
                                            child: GestureDetector(
                                          onTap: () {
                                            print('data');
                                            // Get.to(VideoViewer(
                                            //   url: videoModelList!
                                            //       .data![index]
                                            //       .uploadVideo!,
                                            // ));
                                            Get.to(VideoPostScreen(
                                              videomodel: _profile_screen_controller.videoModelList!,
                                              index_: index,
                                            ));
                                          },
                                          child: (_profile_screen_controller
                                                  .videoModelList!.data![index].coverImage!.isEmpty
                                              ? Image.asset(
                                                  "assets/images/Funky_App_Icon.png",
                                                  fit: BoxFit.fill,
                                                )
                                              : Image.network(
                                                  "${URLConstants.base_data_url}coverImage/${_profile_screen_controller.videoModelList!.data![index].coverImage}",
                                                  fit: BoxFit.cover,
                                                )),
                                        )),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.black54,
                                              borderRadius: BorderRadius.circular(100)),
                                          child: const Padding(
                                            padding: EdgeInsets.all(5.0),
                                            child: Icon(
                                              Icons.play_arrow,
                                              color: Colors.pink,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Container(
                            margin: const EdgeInsets.only(top: 50),
                            child: Text("${_profile_screen_controller.videoModelList!.message}",
                                style: const TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'PR')),
                          ),
                        ),
                      ))))),
      ),
    );
  }

  Widget tagged_list() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Obx(() => (_profile_screen_controller.isTaggedLoading.value == true
            ? const LoaderPage()
            : (_profile_screen_controller.taggedListModel!.error == false
                ? ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    itemCount: _profile_screen_controller.taggedListModel!.tagList!.length,
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () async {
                          String idUser = await PreferenceManager().getPref(URLConstants.id);

                          print(_profile_screen_controller.taggedListModel!.tagList![index].id);
                          Get.to(TaggedPostScreen(
                            tagged_id: _profile_screen_controller.taggedListModel!.tagList![index].id,
                            tagged_username:
                                _profile_screen_controller.taggedListModel!.tagList![index].userName,
                            user_id: idUser,
                          ));
                        },
                        child: ListTile(
                          visualDensity: const VisualDensity(vertical: 4, horizontal: 4),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: SizedBox(
                                height: 60,
                                width: 60,
                                child: (_profile_screen_controller
                                        .taggedListModel!.tagList![index].image!.isNotEmpty
                                    ? Image.network(
                                        "${URLConstants.base_data_url}images/${_profile_screen_controller.taggedListModel!.tagList![index].image!}",
                                        height: 80,
                                        width: 80,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        AssetUtils.image1,
                                        height: 80,
                                        width: 80,
                                        fit: BoxFit.cover,
                                      ))),
                          ),
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${_profile_screen_controller.taggedListModel!.tagList![index].userName}",
                              style: const TextStyle(fontFamily: 'PM', fontSize: 15, color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    })
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 50),
                        child: Text("${_profile_screen_controller.taggedListModel!.message}",
                            style: const TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'PR')),
                      ),
                    ),
                  )))));
  }

  // GetMusicList? musicList;
  // bool isMusicLoading = true;

  // Future<dynamic> get_music_count() async {
  //   print('Inside creator get email');
  //   setState(() {
  //     isMusicLoading = true;
  //   });
  //   String url = ("${URLConstants.base_url}${URLConstants.MusicGetApi}");
  //   // debugPrint('Get Sales Token ${tokens.toString()}');
  //   // try {
  //   // } catch (e) {
  //   //   print('1-1-1-1 Get Purchase ${e.toString()}');
  //   // }
  //
  //   http.Response response = await http.get(Uri.parse(url));
  //
  //   print('Response request: ${response.request}');
  //   print('Response status: ${response.statusCode}');
  //   print('Response body: ${response.body}');
  //
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     var data = convert.jsonDecode(response.body);
  //     musicList = GetMusicList.fromJson(data);
  //     // getUSerModelList(userInfoModel_email);
  //     if (musicList!.error == false) {
  //       debugPrint(
  //           '2-2-2-2-2-2 Inside the Get UserInfo Controller Details ${musicList!
  //               .data!.length}');
  //       // story_info = getStoryModel!.data!;
  //       // CommonWidget().showToaster(msg: data["success"].toString());
  //       // await Get.to(Dashboard());
  //       setState(() {
  //         isMusicLoading = false;
  //       });
  //       return musicList;
  //     } else {
  //       setState(() {
  //         isMusicLoading = false;
  //       }); // CommonWidget().showToaster(msg: msg.toString());
  //       return null;
  //     }
  //   } else if (response.statusCode == 422) {
  //     // CommonWidget().showToaster(msg: msg.toString());
  //   } else if (response.statusCode == 401) {
  //     // CommonService().unAuthorizedUser();
  //   } else {
  //     // CommonWidget().showToaster(msg: msg.toString());
  //   }
  // }

  bool funky_music = true;

  Widget music_list() {
    return Container(
      child: SingleChildScrollView(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      funky_music = true;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: funky_music ? Colors.white : Colors.transparent),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                      child: Text(
                        'Funky Music',
                        style:
                            TextStyle(fontFamily: 'PR', fontSize: 18, color: HexColor(CommonColor.pinkFont)),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      funky_music = false;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: funky_music ? Colors.transparent : Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                      child: Text(
                        'Purchase Music',
                        style:
                            TextStyle(fontFamily: 'PR', fontSize: 18, color: HexColor(CommonColor.pinkFont)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          (funky_music
              ? Obx(
                  () => (_profile_screen_controller.isMusicLoading.value == true
                      ? const Center(
                          child: LoaderPage(),
                        )
                      : (_profile_screen_controller.musicList!.error == false
                          ? ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(bottom: 100),
                              itemCount: _profile_screen_controller.musicList!.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Music_player2(
                                  music_url: _profile_screen_controller.musicList!.data![index].musicFile!,
                                  title: _profile_screen_controller.musicList!.data![index].songName!,
                                  artist_name: _profile_screen_controller.musicList!.data![index].artistName!,
                                );
                              },
                            )
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Container(
                                  margin: const EdgeInsets.only(top: 50),
                                  child: Text("${_profile_screen_controller.musicList!.message}",
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 16, fontFamily: 'PR')),
                                ),
                              ),
                            ))),
                )
              : Obx(
                  () => (_profile_screen_controller.ispurchaseMusicLoading.value == true
                      ? const Center(
                          child: LoaderPage(),
                        )
                      : (_profile_screen_controller.getPurchaseMusicList!.error == false
                          ? ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(bottom: 100),
                              itemCount: _profile_screen_controller.getPurchaseMusicList!.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Music_player2(
                                  music_url: _profile_screen_controller
                                      .getPurchaseMusicList!.data![index].musicFile!,
                                  title:
                                      _profile_screen_controller.getPurchaseMusicList!.data![index].songName!,
                                  artist_name: _profile_screen_controller
                                      .getPurchaseMusicList!.data![index].artistName!,
                                );
                              },
                            )
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Container(
                                  margin: const EdgeInsets.only(top: 50),
                                  child: Text("${_profile_screen_controller.getPurchaseMusicList!.message}",
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 16, fontFamily: 'PR')),
                                ),
                              ),
                            ))),
                )),
        ],
      )),
    );
  }

  Widget Rewards_screen() {
    return Container(
        child: Obx(() => (_settings_screen_controller.isRewardLoading.value == true
            ? const Center(
                child: LoaderPage(),
              )
            : (_settings_screen_controller.getRewardModel!.error == true
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 50),
                        child: Text("${_settings_screen_controller.getRewardModel!.message}",
                            style: const TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'PR')),
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: _settings_screen_controller.getRewardModel!.rewardList!.length,
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 50),
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 22),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              'You are rewarded with ${_settings_screen_controller.getRewardModel!.rewardList![index].title}',
                              style: const TextStyle(fontSize: 14, fontFamily: 'PR', color: Colors.white),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  AssetUtils.coin_icon,
                                  height: 24,
                                  width: 24,
                                ),
                                const SizedBox(
                                  width: 18,
                                ),
                                Text(
                                  '${_settings_screen_controller.getRewardModel!.rewardList![index].rewardPoint} Coins',
                                  style: const TextStyle(fontSize: 16, fontFamily: 'PR', color: Colors.pink),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              // height: 1,
                              color: HexColor(CommonColor.pinkFont).withOpacity(0.7),
                              height: 0.5,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ],
                        ),
                      );
                    },
                  )))));
  }

  File? imgFile;
  List<XFile>? ListimgFile_;
  final imgPicker = ImagePicker();

  Future image_Gallery() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          double width = MediaQuery.of(context).size.width;
          double height = MediaQuery.of(context).size.height;
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AlertDialog(
                backgroundColor: Colors.transparent,
                contentPadding: EdgeInsets.zero,
                elevation: 0.0,
                // title: Center(child: Text("Evaluation our APP")),
                content: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                  height: MediaQuery.of(context).size.height / 3,
                  // width: 133,
                  // padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: const Alignment(-1.0, 0.0),
                        end: const Alignment(1.0, 0.0),
                        transform: const GradientRotation(0.7853982),
                        // stops: [0.1, 0.5, 0.7, 0.9],
                        colors: [
                          HexColor("#000000"),
                          HexColor("#000000"),
                          HexColor("##E84F90"),
                          HexColor("#ffffff"),
                          // HexColor("#FFFFFF").withOpacity(0.67),
                        ],
                      ),
                      color: Colors.white,
                      border: Border.all(color: Colors.white, width: 1),
                      borderRadius: const BorderRadius.all(Radius.circular(26.0))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: common_button(
                              onTap: () {
                                // openCamera();
                                openGallery();
                                Navigator.pop(context);
                                // Get.toNamed(BindingUtils.signupOption);
                              },
                              backgroud_color: Colors.black,
                              lable_text: 'Image',
                              lable_text_color: Colors.white,
                            ),
                          ),
                          common_button(
                            onTap: () {
                              Pickvideo();
                              Navigator.pop(context);
                              // Get.toNamed(BindingUtils.signupOption);
                            },
                            backgroud_color: Colors.black,
                            lable_text: 'Video',
                            lable_text_color: Colors.white,
                          ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                        ],
                      ),
                    ],
                  ),
                )),
          );
        });
  }

  void openGallery() async {
    // var imgCamera = await imgPicker.pickImage(source: ImageSource.gallery);
    final List<XFile> images = await imgPicker.pickMultiImage(imageQuality: 50);
    ListimgFile_ = images;
    setState(() {});
    print("images.length ${ListimgFile_!.length}");
    for (var i = 0; i < ListimgFile_!.length; i++) {
      print(ListimgFile_![i].path);
    }

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ViewImageSelected(
                  imageData: ListimgFile_!,
                )));
    // setState(() {
    // imgFile = File(imgCamera!.path);
    // _creator_signup_controller.photoBase64 =
    //     base64Encode(imgFile!.readAsBytesSync());
    // print(_creator_signup_controller.photoBase64);
    // });
    ///edit story
    // File editedFile = await Navigator.of(context).push(MaterialPageRoute(
    //     builder: (context) => StoriesEditor(
    //           // fontFamilyList: font_family,
    //           giphyKey:
    //               'https://giphy.com/gifs/congratulations-congrats-xT0xezQGU5xCDJuCPe',
    //           imageData: imgFile,
    //           onDone: (String) {},
    //           // filePath:
    //           //     imgFile!.path,
    //         )));
    // if (editedFile != null) {
    //   print('editedFile: ${editedFile.path}');
    // }
    ///
  }

  void Pickvideo() async {
    var imgCamera = await imgPicker.pickVideo(source: ImageSource.gallery);
    setState(() {
      imgFile = File(imgCamera!.path);
      ListimgFile_ = imgCamera as List<XFile>;
      // _creator_signup_controller.photoBase64 =
      //     base64Encode(imgFile!.readAsBytesSync());
      // print(_creator_signup_controller.photoBase64);
    });
    await Get.to(Story_image_preview(
      ImageFile: ListimgFile_!,
    ));

    // File editedFile = await Navigator.of(context).push(MaterialPageRoute(
    //     builder: (context) => StoriesEditor(
    //           // fontFamilyList: font_family,
    //           giphyKey: '',
    //           imageData: imgFile,
    //           onDone: (String) {},
    //           // filePath:
    //           //     imgFile!.path,
    //         )));
    // if (editedFile != null) {
    //   print('editedFile: ${editedFile.path}');
    // }
  }

  late double screenHeight, screenWidth;

  Future pop_up() {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        elevation: 0.0,
        content: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
          height: MediaQuery.of(context).size.height / 5,
          // width: 133,
          // padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: const Alignment(-1.0, 0.0),
                end: const Alignment(1.0, 0.0),
                transform: const GradientRotation(0.7853982),
                // stops: [0.1, 0.5, 0.7, 0.9],
                colors: [
                  HexColor("#000000"),
                  HexColor("#000000"),
                  HexColor("##E84F90"),
                  HexColor("#ffffff"),
                  // HexColor("#FFFFFF").withOpacity(0.67),
                ],
              ),
              color: Colors.white,
              border: Border.all(color: Colors.white, width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(26.0))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      // mainAxisAlignment:
                      // MainAxisAlignment
                      //     .center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // camera_upload();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MyApp_video(
                                        story: true,
                                      )),
                            );
                          },
                          child: Column(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.camera_alt,
                                  size: 30,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  // camera_upload();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const MyApp_video(
                                              story: true,
                                            )),
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 0),
                                // height: 45,
                                // width:(width ?? 300) ,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white, width: 1),
                                    borderRadius: BorderRadius.circular(25)),
                                child: Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                                    child: const Text(
                                      'Camera',
                                      style: TextStyle(color: Colors.white, fontFamily: 'PR', fontSize: 16),
                                    )),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                          onTap: () async {
                            // File editedFile = await Navigator.of(context)
                            //     .push(MaterialPageRoute(
                            //         builder: (context) => StoriesEditor(
                            //               // fontFamilyList: font_family,
                            //               giphyKey: '',
                            //               onDone: (String) {},
                            //               // filePath:
                            //               //     imgFile!.path,
                            //             )));
                            // if (editedFile != null) {
                            //   print('editedFile: ${editedFile.path}');
                            // }
                            // image_Gallery();
                            Get.to(const Post_story_Screen());
                          },
                          child: Column(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.photo_library_sharp,
                                  size: 30,
                                  color: Colors.white,
                                ),
                                onPressed: () async {
                                  // File editedFile = await Navigator.of(context)
                                  //     .push(MaterialPageRoute(
                                  //         builder: (context) => StoriesEditor(
                                  //               // fontFamilyList: font_family,
                                  //               giphyKey: '',
                                  //               onDone: (String) {},
                                  //               // filePath:
                                  //               //     imgFile!.path,
                                  //             )));
                                  // if (editedFile != null) {
                                  //   print('editedFile: ${editedFile.path}');
                                  // }
                                  // image_Gallery();
                                  Get.to(const Post_story_Screen());
                                },
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 0),
                                // height: 45,
                                // width:(width ?? 300) ,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white, width: 1),
                                    borderRadius: BorderRadius.circular(25)),
                                child: Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                                    child: const Text(
                                      'Gallery',
                                      style: TextStyle(color: Colors.white, fontFamily: 'PR', fontSize: 16),
                                    )),
                              ),
                            ],
                          ),
                        ),

                        // IconButton(
                        //   icon: const Icon(
                        //     Icons
                        //         .video_call,
                        //     size: 40,
                        //     color: Colors
                        //         .grey,
                        //   ),
                        //   onPressed:
                        //       () {
                        //         video_upload();
                        //       },
                        // ),
                      ],
                    ),
                  )

                  // const SizedBox(
                  //   height: 10,
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> update_link_facebook({
    required BuildContext context,
    required int index,
    String? facebook_link,
    String? instagram_links,
    String? twitter_links,
    String? tiktok_links,
    String? snapchat_links,
    String? linkedin_links,
    String? gmail_links,
    String? whatsapp_links,
    String? skype_links,
    String? youtube_links,
    String? pinterest_links,
    String? reddit_links,
    String? telegram_links,
  }) async {
    showLoader(context);

    String idUser = await PreferenceManager().getPref(URLConstants.id);

    debugPrint('0-0-0-0-0-0-0 username');

    Map data = (index == 0
        ? {
            'userId': idUser,
            'facebook_links': facebook_link,
          }
        : (index == 1
            ? {
                'userId': idUser,
                'instagram_links': instagram_links,
              }
            : (index == 2
                ? {
                    'userId': idUser,
                    'twitter_links': twitter_links,
                  }
                : (index == 3
                    ? {
                        'userId': idUser,
                        'tiktok_links': tiktok_links,
                      }
                    : (index == 4
                        ? {
                            'userId': idUser,
                            'snapchat_links': snapchat_links,
                          }
                        : (index == 5
                            ? {
                                'userId': idUser,
                                'linkedin_links': linkedin_links,
                              }
                            : (index == 6
                                ? {
                                    'userId': idUser,
                                    'gmail_links': gmail_links,
                                  }
                                : (index == 7
                                    ? {
                                        'userId': idUser,
                                        'whatsapp_links': whatsapp_links,
                                      }
                                    : (index == 8
                                        ? {
                                            'userId': idUser,
                                            'skype_links': skype_links,
                                          }
                                        : (index == 9
                                            ? {
                                                'userId': idUser,
                                                'youtube_links': youtube_links,
                                              }
                                            : (index == 10
                                                ? {
                                                    'userId': idUser,
                                                    'pinterest_links': pinterest_links,
                                                  }
                                                : (index == 11
                                                    ? {
                                                        'userId': idUser,
                                                        'reddit_links': reddit_links,
                                                      }
                                                    : (index == 12
                                                        ? {
                                                            'userId': idUser,
                                                            'telegram_links': telegram_links,
                                                          }
                                                        : {
                                                            'userId': idUser,
                                                          })))))))))))));

    // Map data = {
    //   'userId': idUser,
    //   'facebook_links': facebook_link,
    //   'instagram_links': instagram_links,
    //   'twitter_links': twitter_links,
    //   'tiktok_links': tiktok_links,
    //   'snapchat_links': snapchat_links,
    //   'linkedin_links': linkedin_links,
    //   'gmail_links': gmail_links,
    //   'whatsapp_links': whatsapp_links,
    //   'skype_links': skype_links,
    //   'youtube_links': youtube_links,
    //   'pinterest_links': pinterest_links,
    //   'reddit_links': reddit_links,
    //   'telegram_links': telegram_links,
    // };
    print(data);
    // String body = json.encode(data);

    var url = ('${URLConstants.base_url}socialLinks.php');
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
      var data = jsonDecode(response.body);
      // _galleryModelList = GalleryModelList.fromJson(data);

      if (data["error"] == false) {
        CommonWidget().showToaster(msg: 'Succesful');
        // print(_galleryModelList);
        Navigator.pop(context);
        hideLoader(context);
      } else {
        Navigator.pop(context);
        hideLoader(context);

        print('Please try again');
      }
    } else {
      Navigator.pop(context);
      hideLoader(context);

      print('Please try again');
    }
  }
}
