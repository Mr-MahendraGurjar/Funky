import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:funky_new/search_screen/search__screen_controller.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:marquee/marquee.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Authentication/creator_login/controller/creator_login_controller.dart';
import '../Utils/App_utils.dart';
import '../Utils/asset_utils.dart';
import '../Utils/colorUtils.dart';
import '../custom_widget/loader_page.dart';
import '../profile_screen/followers_screen.dart';
import '../profile_screen/following_screen.dart';
import '../profile_screen/imagePostScreen.dart';
import '../profile_screen/music_player.dart';
import '../profile_screen/profile_controller.dart';
import '../profile_screen/story_view/storyView.dart';
import '../profile_screen/tagged_posts_screen.dart';
import '../profile_screen/viewVideoPosr.dart';
import '../settings/controller.dart';
import '../sharePreference.dart';

class SearchUserProfile extends StatefulWidget {
  var search_user_data;
  final String? quickBlox_id;

  // final String UserId;

  SearchUserProfile({super.key, this.search_user_data, this.quickBlox_id});

  @override
  State<SearchUserProfile> createState() => _SearchUserProfileState();
}

class _SearchUserProfileState extends State<SearchUserProfile>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    print('social type: ${widget.search_user_data.socialType}');
    init();
    _tabController = TabController(length: 5, vsync: this);
    super.initState();
  }

  final _creator_Login_screen_controller = Creator_Login_screen_controller();

  final Search_screen_controller _search_screen_controller = Get.put(
      Search_screen_controller(),
      tag: Search_screen_controller().toString());

  final Settings_screen_controller _settings_screen_controller = Get.put(
      Settings_screen_controller(),
      tag: Settings_screen_controller().toString());

  final Profile_screen_controller _profile_screen_controller = Get.put(
      Profile_screen_controller(),
      tag: Profile_screen_controller().toString());
  String? idUserType;

  init() async {
    String loginId = await PreferenceManager().getPref(URLConstants.id);

    (widget.search_user_data.socialType == ""
        ? await _search_screen_controller.CreatorgetUserInfo_Email(
            UserId: widget.search_user_data.id!)
        : await _search_screen_controller.getUserInfo_social(
            UserId: widget.search_user_data.id!));

    // String Type_ = await PreferenceManager().getPref(URLConstants.type);
    // setState(() {
    // idUserType = Type_;
    // });
    print("idUserType $idUserType");
    await _search_screen_controller.compare_data();

    // await get_story_list();
    // await get_video_list(context);
    // await get_gallery_list(context);

    await _profile_screen_controller.get_story_list(
        context: context,
        user_id: widget.search_user_data.id!,
        login_user_id: loginId);
    await _profile_screen_controller.get_video_list(
        context: context,
        user_id: widget.search_user_data.id!,
        login_user_id: loginId);
    await _profile_screen_controller.get_gallery_list(
        context: context,
        user_id: widget.search_user_data.id!,
        login_user_id: loginId);
    await _profile_screen_controller.get_tagged_list(
        context: context, user_id: widget.search_user_data.id!);
    await _profile_screen_controller.get_posted_music(
        context: context, user_id: widget.search_user_data.id!);
    await _profile_screen_controller.get_purchase_music(
        context: context, user_id: widget.search_user_data.id!);
    await _settings_screen_controller.getRewardList(
        userId: widget.search_user_data.id!);

    await _profile_screen_controller.get_brand_logo(
        context: context, user_id: widget.search_user_data.id!);
    await _profile_screen_controller.get_banner_list(
        context: context, user_id: widget.search_user_data.id!);
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

  static final List<Tab> _tabs = [
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
            AssetUtils.story2,
            height: 25,
            width: 25,
            color: HexColor(CommonColor.green),
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
            border:
                Border.all(color: HexColor(CommonColor.orange), width: 1.5)),
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
            border:
                Border.all(color: HexColor(CommonColor.orange), width: 1.5)),
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

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  String dropdownvalue = 'Apple';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        body:
            Obx(() => (_search_screen_controller.isuserinfoLoading.value == true
                ? const Center(child: LoaderPage())
                : NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        SliverAppBar(
                            backgroundColor: Colors.black,
                            automaticallyImplyLeading: false,
                            expandedHeight: (_profile_screen_controller
                                        .isStoryLoading.value ==
                                    true
                                ? 400
                                : (_profile_screen_controller
                                        .getStoryModel!.data!.isEmpty
                                    ? 300
                                    : 400)),
                            floating: false,
                            pinned: true,
                            flexibleSpace: FlexibleSpaceBar(
                                collapseMode: CollapseMode.pin,
                                centerTitle: true,
                                background: Container(
                                  margin: const EdgeInsets.only(
                                      top: 32, right: 0, left: 0),
                                  child: SingleChildScrollView(
                                      child:
                                          Obx(
                                              () =>
                                                  (_search_screen_controller
                                                              .isuserinfoLoading
                                                              .value ==
                                                          true
                                                      ? Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Container(
                                                                    margin: const EdgeInsets
                                                                        .only(
                                                                        left: 5,
                                                                        top: 0,
                                                                        bottom:
                                                                            0),
                                                                    child: IconButton(
                                                                        padding: EdgeInsets.zero,
                                                                        visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
                                                                        onPressed: () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        icon: const Icon(
                                                                          Icons
                                                                              .arrow_back,
                                                                          color:
                                                                              Colors.white,
                                                                        ))),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      '${_search_screen_controller.userInfoModel_email!.data![0].userName}',
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color: Colors
                                                                              .white,
                                                                          fontFamily:
                                                                              'PB'),
                                                                    ),
                                                                    (_search_screen_controller.userInfoModel_email!.data![0].verify ==
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
                                                                        : const SizedBox
                                                                            .shrink())
                                                                  ],
                                                                ),
                                                                PopupMenuButton(itemBuilder: (context) => [
                                                                PopupMenuItem(
                                                                          value:
                                                                              "Apple",
                                                                          onTap:
                                                                              () {},
                                                                          child:
                                                                              GestureDetector(
                                                                            onTap:
                                                                                () async {},
                                                                            child:
                                                                                Container(
                                                                              alignment: Alignment.center,
                                                                              child: const Text("Report", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'PR')),
                                                                            ),
                                                                          )),
                                                                      PopupMenuItem(
                                                                          value:
                                                                              "Apple1",
                                                                          onTap:
                                                                              () {},
                                                                          child:
                                                                              GestureDetector(
                                                                            onTap:
                                                                                () async {
                                                                              print("datssa");
                                                                              print("datssa");
                                                                              _settings_screen_controller.Block_unblock_api(context: context, user_id: _search_screen_controller.userInfoModel_email!.data![0].id!, user_name: _search_screen_controller.userInfoModel_email!.data![0].userName!, social_bloc_type: _search_screen_controller.userInfoModel_email!.data![0].socialType!, block_unblock: (_search_screen_controller.userInfoModel_email!.data![0].userBlockUnblock == 'Block' ? 'Unblock' : 'Block'));
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              alignment: Alignment.center,
                                                                              padding: const EdgeInsets.only(top: 5),
                                                                              child: const Text("Block", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'PR')),
                                                                            ),
                                                                          )),
                                                                ],),
                                                                // DropdownButtonHideUnderline(
                                                                //   child:
                                                                //       DropdownButton2(
                                                                //     //  isExpanded: true,
                                                                //     customButton:
                                                                //         const Padding(
                                                                //       padding: EdgeInsets.symmetric(
                                                                //           vertical:
                                                                //               5.0),
                                                                //       child:
                                                                //           Icon(
                                                                //         Icons
                                                                //             .more_vert,
                                                                //         color: Colors
                                                                //             .white,
                                                                //         size:
                                                                //             25,
                                                                //       ),
                                                                //     ),
                                                                //     items: [
                                                                //       DropdownMenuItem(
                                                                //           value:
                                                                //               "Apple",
                                                                //           onTap:
                                                                //               () {},
                                                                //           child:
                                                                //               GestureDetector(
                                                                //             onTap:
                                                                //                 () async {},
                                                                //             child:
                                                                //                 Container(
                                                                //               alignment: Alignment.center,
                                                                //               child: const Text("Report", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'PR')),
                                                                //             ),
                                                                //           )),
                                                                //       DropdownMenuItem(
                                                                //           value:
                                                                //               "Apple1",
                                                                //           onTap:
                                                                //               () {},
                                                                //           child:
                                                                //               GestureDetector(
                                                                //             onTap:
                                                                //                 () async {
                                                                //               print("datssa");
                                                                //               print("datssa");
                                                                //               _settings_screen_controller.Block_unblock_api(context: context, user_id: _search_screen_controller.userInfoModel_email!.data![0].id!, user_name: _search_screen_controller.userInfoModel_email!.data![0].userName!, social_bloc_type: _search_screen_controller.userInfoModel_email!.data![0].socialType!, block_unblock: (_search_screen_controller.userInfoModel_email!.data![0].userBlockUnblock == 'Block' ? 'Unblock' : 'Block'));
                                                                //               Navigator.pop(context);
                                                                //             },
                                                                //             child:
                                                                //                 Container(
                                                                //               alignment: Alignment.center,
                                                                //               padding: const EdgeInsets.only(top: 5),
                                                                //               child: const Text("Block", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'PR')),
                                                                //             ),
                                                                //           )),
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
                                                                //         (value) {},

                                                                //     iconSize:
                                                                //         25,
                                                                //     iconEnabledColor:
                                                                //         const Color(
                                                                //             0xff007DEF),
                                                                //     iconDisabledColor:
                                                                //         const Color(
                                                                //             0xff007DEF),
                                                                //     buttonHeight:
                                                                //         50,
                                                                //     buttonWidth:
                                                                //         100,
                                                                //     enableFeedback:
                                                                //         true,
                                                                //     buttonPadding: const EdgeInsets
                                                                //         .only(
                                                                //         left:
                                                                //             15,
                                                                //         right:
                                                                //             15),
                                                                //     buttonDecoration: BoxDecoration(
                                                                //         borderRadius:
                                                                //             BorderRadius.circular(
                                                                //                 10),
                                                                //         color: Colors
                                                                //             .transparent),
                                                                //     buttonElevation:
                                                                //         0,
                                                                //     itemHeight:
                                                                //         30,
                                                                //     itemPadding: const EdgeInsets
                                                                //         .only(
                                                                //         left:
                                                                //             14,
                                                                //         right:
                                                                //             14),
                                                                //     dropdownMaxHeight:
                                                                //         200,
                                                                //     dropdownWidth:
                                                                //         150,
                                                                //     dropdownPadding:
                                                                //         null,
                                                                //     dropdownDecoration:
                                                                //         BoxDecoration(
                                                                //       borderRadius:
                                                                //           BorderRadius.circular(
                                                                //               24),
                                                                //       border: Border.all(
                                                                //           width:
                                                                //               1,
                                                                //           color:
                                                                //               Colors.white),
                                                                //       gradient:
                                                                //           LinearGradient(
                                                                //         begin: Alignment
                                                                //             .topLeft,
                                                                //         end: Alignment
                                                                //             .bottomRight,
                                                                //         // stops: [0.1, 0.5, 0.7, 0.9],
                                                                //         colors: [
                                                                //           HexColor(
                                                                //               "#000000"),
                                                                //           HexColor(
                                                                //               "#C12265"),
                                                                //           // HexColor("#FFFFFF"),
                                                                //         ],
                                                                //       ),
                                                                //     ),
                                                                //     dropdownElevation:
                                                                //         8,
                                                                //     scrollbarRadius:
                                                                //         const Radius
                                                                //             .circular(
                                                                //             40),
                                                                //     scrollbarThickness:
                                                                //         6,
                                                                //     scrollbarAlwaysShow:
                                                                //         true,
                                                                //     offset:
                                                                //         const Offset(
                                                                //             -10,
                                                                //             -8),
                                                                //   ),
                                                                // ),
                                                             
                                                              ],
                                                            ),
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                      // color: HexColor(CommonColor.bloodRed),
                                                                      color: (widget.search_user_data.type ==
                                                                              'Advertiser'
                                                                          ? HexColor(CommonColor
                                                                              .bloodRed)
                                                                          : (widget.search_user_data.type == 'Kids'
                                                                              ? HexColor(
                                                                                  "#0b0f54")
                                                                              : Colors
                                                                                  .black)),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20)),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child: Column(
                                                                  children: [
                                                                    Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
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
                                                                                child: Container(
                                                                                  decoration: const BoxDecoration(),
                                                                                  child: (_search_screen_controller.isuserinfoLoading.value == true
                                                                                      ? CircularProgressIndicator(
                                                                                          color: HexColor(CommonColor.pinkFont),
                                                                                        )
                                                                                      : (_search_screen_controller.userInfoModel_email!.data![0].image!.isNotEmpty
                                                                                          ? Image.network(
                                                                                              "${URLConstants.base_data_url}images/${_search_screen_controller.userInfoModel_email!.data![0].image!}",
                                                                                              height: 80,
                                                                                              width: 80,
                                                                                              fit: BoxFit.cover,
                                                                                            )
                                                                                          : (_search_screen_controller.userInfoModel_email!.data![0].profileUrl!.isNotEmpty
                                                                                              ? FadeInImage.assetNetwork(
                                                                                                  height: 80,
                                                                                                  width: 80,
                                                                                                  fit: BoxFit.cover,
                                                                                                  image: _search_screen_controller.userInfoModel_email!.data![0].profileUrl!,
                                                                                                  placeholder: 'assets/images/Funky_App_Icon.png',
                                                                                                  imageErrorBuilder: (context, url, error) => Image.asset(
                                                                                                    "assets/images/Funky_App_Icon.png",
                                                                                                    height: 80,
                                                                                                    width: 80,
                                                                                                    fit: BoxFit.cover,
                                                                                                  ),
                                                                                                )
                                                                                              : Image.asset(
                                                                                                  AssetUtils.image1,
                                                                                                  height: 80,
                                                                                                  width: 80,
                                                                                                  fit: BoxFit.cover,
                                                                                                )))),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            (widget.search_user_data.type == 'Advertiser'
                                                                                ? const SizedBox.shrink()
                                                                                : Positioned(
                                                                                    bottom: 0,
                                                                                    right: 2,
                                                                                    child: Obx(
                                                                                      () => _settings_screen_controller.isRewardLoading.value == true
                                                                                          ? SizedBox(
                                                                                              height: 20,
                                                                                              width: 20,
                                                                                              child: CircularProgressIndicator(
                                                                                                strokeWidth: 2,
                                                                                                color: HexColor(CommonColor.pinkFont),
                                                                                              ))
                                                                                          : Container(
                                                                                              decoration: BoxDecoration(
                                                                                                  color: Colors.white,
                                                                                                  boxShadow: const [
                                                                                                    BoxShadow(
                                                                                                      color: Colors.grey,
                                                                                                      offset: Offset(0.0, 1.0),
                                                                                                      //(x,y)
                                                                                                      blurRadius: 6.0,
                                                                                                    ),
                                                                                                  ],
                                                                                                  borderRadius: BorderRadius.circular(100)),
                                                                                              child: Padding(
                                                                                                padding: const EdgeInsets.all(2.0),
                                                                                                child: (double.parse(_settings_screen_controller.getRewardModel!.totalReward!) <= 1000 ? Image.asset(AssetUtils.bronze_icon, height: 20, width: 20) : (double.parse(_settings_screen_controller.getRewardModel!.totalReward!) >= 1000 && double.parse(_settings_screen_controller.getRewardModel!.totalReward!) <= 5000 ? Image.asset(AssetUtils.silver_icon, height: 20, width: 20) : (double.parse(_settings_screen_controller.getRewardModel!.totalReward!) >= 5000 ? Image.asset(AssetUtils.gold_icon, height: 20, width: 20) : Image.asset(AssetUtils.silver_icon, height: 20, width: 20)))),
                                                                                              ),
                                                                                            ),
                                                                                    ))),
                                                                          ],
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              5,
                                                                        ),
                                                                        Expanded(
                                                                          flex:
                                                                              3,
                                                                          child:
                                                                              Container(
                                                                            margin:
                                                                                const EdgeInsets.only(left: 10),
                                                                            height:
                                                                                100,
                                                                            // alignment: FractionalOffset.center,
                                                                            child:
                                                                                Column(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  (_search_screen_controller.userInfoModel_email!.data![0].fullName!.isNotEmpty ? '${_search_screen_controller.userInfoModel_email!.data![0].fullName}' : 'Please update profile'),
                                                                                  style: TextStyle(fontSize: 14, color: HexColor(CommonColor.pinkFont)),
                                                                                ),
                                                                                const SizedBox(
                                                                                  height: 10,
                                                                                ),
                                                                                Text(
                                                                                  (_search_screen_controller.userInfoModel_email!.data![0].about!.isNotEmpty ? '${_search_screen_controller.userInfoModel_email!.data![0].about}' : ' '),
                                                                                  style: TextStyle(fontSize: 14, color: HexColor(CommonColor.subHeaderColor)),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Row(
                                                                              children: [
                                                                                IconButton(
                                                                                    visualDensity: const VisualDensity(vertical: -4),
                                                                                    padding: const EdgeInsets.only(left: 5.0),
                                                                                    icon: Image.asset(
                                                                                      AssetUtils.like_icon_filled,
                                                                                      color: HexColor(CommonColor.pinkFont),
                                                                                      height: 20,
                                                                                      width: 20,
                                                                                    ),
                                                                                    onPressed: () {}),
                                                                                Text(
                                                                                  '${_search_screen_controller.userInfoModel_email!.data![0].likeCount}',
                                                                                  style: const TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'PR'),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            Row(
                                                                              children: [
                                                                                IconButton(
                                                                                    padding: const EdgeInsets.only(left: 5.0),
                                                                                    visualDensity: const VisualDensity(vertical: -4),
                                                                                    icon: Image.asset(
                                                                                      AssetUtils.profile_filled,
                                                                                      color: HexColor(CommonColor.pinkFont),
                                                                                      height: 20,
                                                                                      width: 20,
                                                                                    ),
                                                                                    onPressed: () {
                                                                                      if (_search_screen_controller.userInfoModel_email!.data![0].followerFollowingShowStatus == "true") {
                                                                                        Get.to(FollowersList(
                                                                                          user_id: widget.search_user_data.id!,
                                                                                          // searchUserid: widget
                                                                                          //     .search_user_data
                                                                                          //     .id!,
                                                                                        ));
                                                                                      }
                                                                                    }),
                                                                                Text(
                                                                                  '${_search_screen_controller.userInfoModel_email!.data![0].followerNumber}',
                                                                                  style: const TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'PR'),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            Row(
                                                                              children: [
                                                                                IconButton(
                                                                                    visualDensity: const VisualDensity(vertical: -4),
                                                                                    padding: const EdgeInsets.only(left: 5.0),
                                                                                    icon: Image.asset(
                                                                                      AssetUtils.following_filled,
                                                                                      color: HexColor(CommonColor.pinkFont),
                                                                                      height: 20,
                                                                                      width: 20,
                                                                                    ),
                                                                                    onPressed: () {
                                                                                      if (_search_screen_controller.userInfoModel_email!.data![0].followerFollowingShowStatus == "true") {
                                                                                        Get.to(FollowingScreen(
                                                                                          user_id: widget.search_user_data.id!,
                                                                                        ));
                                                                                      }
                                                                                    }),
                                                                                Text(
                                                                                  '${_search_screen_controller.userInfoModel_email!.data![0].followingNumber}',
                                                                                  style: const TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'PR'),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Expanded(
                                                                          flex:
                                                                              2,
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Container(
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.circular(50),
                                                                                ),
                                                                                child: IconButton(
                                                                                  padding: EdgeInsets.zero,
                                                                                  visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
                                                                                  icon: Image.asset(
                                                                                    AssetUtils.facebook_icon,
                                                                                    height: 30,
                                                                                    width: 30,
                                                                                  ),
                                                                                  onPressed: () async {
                                                                                    if (_search_screen_controller.userInfoModel_email!.data![0].socialLinkShowStatus == "true") {
                                                                                      if (_search_screen_controller.userInfoModel_email!.data![0].facebookLinks!.isNotEmpty) {
                                                                                        if (await launchUrl(Uri.parse(_search_screen_controller.userInfoModel_email!.data![0].facebookLinks!))) {
                                                                                          throw 'Could not launch ${_search_screen_controller.userInfoModel_email!.data![0].facebookLinks!}';
                                                                                        }
                                                                                      }
                                                                                    }
                                                                                  },
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.circular(50),
                                                                                ),
                                                                                child: IconButton(
                                                                                  padding: EdgeInsets.zero,
                                                                                  visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
                                                                                  icon: Image.asset(
                                                                                    AssetUtils.instagram_icon,
                                                                                    height: 30,
                                                                                    width: 30,
                                                                                  ),
                                                                                  onPressed: () async {
                                                                                    if (_search_screen_controller.userInfoModel_email!.data![0].socialLinkShowStatus == "true") {
                                                                                      if (_search_screen_controller.userInfoModel_email!.data![0].instagramLinks!.isNotEmpty) {
                                                                                        if (await launchUrl(Uri.parse(_search_screen_controller.userInfoModel_email!.data![0].instagramLinks!))) {
                                                                                          throw 'Could not launch ${_search_screen_controller.userInfoModel_email!.data![0].instagramLinks!}';
                                                                                        }
                                                                                      }
                                                                                    }
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
                                                                                  visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
                                                                                  icon: Image.asset(
                                                                                    AssetUtils.twitter_icon,
                                                                                    height: 30,
                                                                                    width: 30,
                                                                                  ),
                                                                                  onPressed: () async {
                                                                                    if (_search_screen_controller.userInfoModel_email!.data![0].socialLinkShowStatus == "true") {
                                                                                      if (_search_screen_controller.userInfoModel_email!.data![0].twitterLinks!.isNotEmpty) {
                                                                                        if (await launchUrl(Uri.parse(_search_screen_controller.userInfoModel_email!.data![0].twitterLinks!))) {
                                                                                          throw 'Could not launch ${_search_screen_controller.userInfoModel_email!.data![0].twitterLinks!}';
                                                                                        }
                                                                                      }
                                                                                    }

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
                                                                                        onTap: () async {
                                                                                          if (_search_screen_controller.userInfoModel_email!.data![0].socialLinkShowStatus == "true") {
                                                                                            if (_search_screen_controller.userInfoModel_email!.data![0].tiktokLinks!.isNotEmpty) {
                                                                                              if (await launchUrl(Uri.parse(_search_screen_controller.userInfoModel_email!.data![0].tiktokLinks!))) {
                                                                                                throw 'Could not launch ${_search_screen_controller.userInfoModel_email!.data![0].twitterLinks!}';
                                                                                              }
                                                                                            }
                                                                                          }
                                                                                        },
                                                                                        child: Row(
                                                                                          children: [
                                                                                            Image.asset(
                                                                                              AssetUtils.tiktok,
                                                                                              height: 32,
                                                                                              width: 32,
                                                                                            ),
                                                                                            const SizedBox(width: 15),
                                                                                            const Expanded(
                                                                                              child: Text("TikTok", 
                                                                                                overflow: TextOverflow.ellipsis,
                                                                                                style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'PR')
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                    value: dropdownvalue,
                                                                                    style: const TextStyle(
                                                                                      fontSize: 16,
                                                                                      fontFamily: 'PR',
                                                                                      color: Colors.white,
                                                                                    ),
                                                                                    alignment: Alignment.centerLeft,
                                                                                    onChanged: (value) {
                                                                                      setState(() {
                                                                                        dropdownvalue = value.toString();
                                                                                      });
                                                                                    },
                                                                                    iconStyleData: const IconStyleData(
                                                                                      iconSize: 25,
                                                                                      iconEnabledColor: Color(0xff007DEF),
                                                                                      iconDisabledColor: Color(0xff007DEF),
                                                                                    ),
                                                                                    buttonStyleData: ButtonStyleData(
                                                                                      decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius.circular(10),
                                                                                        color: Colors.transparent
                                                                                      ),
                                                                                      height: 50,
                                                                                      width: 100,
                                                                                      elevation: 0,
                                                                                      padding: const EdgeInsets.only(left: 14, right: 14),
                                                                                    ),
                                                                                    enableFeedback: true,
                                                                                    dropdownStyleData: DropdownStyleData(
                                                                                      padding: EdgeInsets.zero,
                                                                                      width: 150,
                                                                                      maxHeight: 200,
                                                                                      elevation: 8,
                                                                                      scrollbarTheme: const ScrollbarThemeData(
                                                                                        radius: Radius.circular(40),
                                                                                        thickness: WidgetStatePropertyAll(8),
                                                                                      ),
                                                                                      decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius.circular(24),
                                                                                        border: Border.all(width: 1, color: Colors.white),
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
                                                                          flex:
                                                                              2,
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.end,
                                                                            children: [
                                                                              Obx(() => (_search_screen_controller.comapre_loading.value == true
                                                                                  ? SizedBox(
                                                                                      height: 20,
                                                                                      width: 20,
                                                                                      child: CircularProgressIndicator(
                                                                                        color: HexColor(CommonColor.pinkFont),
                                                                                        strokeWidth: 2,
                                                                                      ))
                                                                                  : GestureDetector(
                                                                                      onTap: () async {
                                                                                        await _search_screen_controller.Follow_unfollow_api(context: context, user_id: widget.search_user_data.id, user_social: widget.search_user_data.socialType, follow_unfollow: (_search_screen_controller.is_follower != null && _search_screen_controller.is_following != null ? 'unfollow' : (_search_screen_controller.is_follower != null && _search_screen_controller.is_following == null ? 'follow' : (_search_screen_controller.is_follower == null && _search_screen_controller.is_following != null ? "unfollow" : (_search_screen_controller.is_follower == null && _search_screen_controller.is_following == null ? "follow" : 'follow'))))).then((value) => setState(() {}));
                                                                                      },
                                                                                      child: Container(
                                                                                        margin: const EdgeInsets.symmetric(horizontal: 0),
                                                                                        // height: 45,
                                                                                        // width:(width ?? 300) ,
                                                                                        decoration: BoxDecoration(color: (_search_screen_controller.is_follower != null && _search_screen_controller.is_following != null ? Colors.black : (_search_screen_controller.is_follower != null && _search_screen_controller.is_following == null ? Colors.white : (_search_screen_controller.is_follower == null && _search_screen_controller.is_following != null ? Colors.black : (_search_screen_controller.is_follower == null && _search_screen_controller.is_following == null ? Colors.white : Colors.white)))), border: Border.all(width: 1, color: (_search_screen_controller.is_follower != null && _search_screen_controller.is_following != null ? Colors.white : (_search_screen_controller.is_follower != null && _search_screen_controller.is_following == null ? HexColor(CommonColor.pinkFont) : (_search_screen_controller.is_follower == null && _search_screen_controller.is_following != null ? Colors.white : (_search_screen_controller.is_follower == null && _search_screen_controller.is_following == null ? HexColor("#ffffff") : Colors.white))))), borderRadius: BorderRadius.circular(25)),
                                                                                        child: Container(
                                                                                            alignment: Alignment.center,
                                                                                            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                                                                                            child: Text(
                                                                                              (_search_screen_controller.is_follower != null && _search_screen_controller.is_following != null ? 'Following' : (_search_screen_controller.is_follower != null && _search_screen_controller.is_following == null ? 'Follow' : (_search_screen_controller.is_follower == null && _search_screen_controller.is_following != null ? "Following" : (_search_screen_controller.is_follower == null && _search_screen_controller.is_following == null ? 'Follow' : (_search_screen_controller.is_follower == null && _search_screen_controller.is_following != null ? 'Following' : ''))))),
                                                                                              style: TextStyle(color: (_search_screen_controller.is_follower != null && _search_screen_controller.is_following != null ? Colors.white : (_search_screen_controller.is_follower != null && _search_screen_controller.is_following == null ? Colors.black : (_search_screen_controller.is_follower == null && _search_screen_controller.is_following != null ? Colors.white : (_search_screen_controller.is_follower == null && _search_screen_controller.is_following == null ? Colors.black : Colors.white)))), fontFamily: 'PR', fontSize: 16),
                                                                                            )),
                                                                                      ),
                                                                                    ))),
                                                                              const SizedBox(
                                                                                width: 10,
                                                                              ),
                                                                              GestureDetector(
                                                                                onTap: () async {
                                                                                  // if (_search_screen_controller
                                                                                  //     .is_follower !=
                                                                                  //     null ||
                                                                                  //     _search_screen_controller
                                                                                  //         .is_following !=
                                                                                  //         null) {
                                                                                  // final QuerySnapshot result = await firebaseFirestore
                                                                                  //     .collection(FirestoreConstants.pathUserCollection)
                                                                                  //     .where(FirestoreConstants.id, isEqualTo: widget.search_user_data.id)
                                                                                  //     .get();
                                                                                  // final List<DocumentSnapshot> documents = result.docs;
                                                                                  // if (documents.isEmpty) {
                                                                                  //   // Writing data to server because here is a new user
                                                                                  //   firebaseFirestore
                                                                                  //       .collection(FirestoreConstants.pathUserCollection)
                                                                                  //       .doc(widget.search_user_data.id)
                                                                                  //       .set({
                                                                                  //     FirestoreConstants.nickname: widget.search_user_data.fullName,
                                                                                  //     FirestoreConstants.photoUrl:
                                                                                  //     "https://foxytechnologies.com/funky/images/${widget.search_user_data.image}",
                                                                                  //     FirestoreConstants.id: widget.search_user_data.id,
                                                                                  //     'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
                                                                                  //     FirestoreConstants.chattingWith: null
                                                                                  //   });
                                                                                  //   // Write data to local storage
                                                                                  //   // User? currentUser = firebaseUser;
                                                                                  //   SharedPreferences prefs = await SharedPreferences.getInstance();
                                                                                  //   await prefs.setString(
                                                                                  //       FirestoreConstants.id, widget.search_user_data.id!);
                                                                                  //   await prefs.setString(
                                                                                  //       FirestoreConstants.nickname, widget.search_user_data.fullName ?? "");
                                                                                  //   await prefs.setString(
                                                                                  //       FirestoreConstants.photoUrl,
                                                                                  //       widget.search_user_data.image ??
                                                                                  //           "");
                                                                                  // }
                                                                                  // else{
                                                                                  //   DocumentSnapshot documentSnapshot = documents[0];
                                                                                  //   UserChat userChat = UserChat.fromDocument(documentSnapshot);
                                                                                  //   // Write data to local
                                                                                  //   SharedPreferences prefs = await SharedPreferences.getInstance();
                                                                                  //   await prefs.setString(FirestoreConstants.id, userChat.id);
                                                                                  //   await prefs.setString(FirestoreConstants.nickname, userChat.nickname);
                                                                                  //   await prefs.setString(FirestoreConstants.photoUrl, userChat.photoUrl);
                                                                                  //   await prefs.setString(FirestoreConstants.aboutMe, userChat.aboutMe);
                                                                                  //
                                                                                  // }

                                                                                  // Navigator.push(
                                                                                  //   context,
                                                                                  //   MaterialPageRoute(
                                                                                  //     builder: (context) =>
                                                                                  //         ChatPage(
                                                                                  //           arguments: ChatPageArguments(
                                                                                  //             peerId: widget
                                                                                  //                 .search_user_data
                                                                                  //                 .id!,
                                                                                  //             peerAvatar: widget
                                                                                  //                 .search_user_data
                                                                                  //                 .image!,
                                                                                  //             peerNickname: widget
                                                                                  //                 .search_user_data
                                                                                  //                 .fullName!,
                                                                                  //           ),
                                                                                  //         ),
                                                                                  //   ),
                                                                                  // );
                                                                                  // Navigator.pushReplacement(
                                                                                  //     context,
                                                                                  //     MaterialPageRoute(
                                                                                  //         builder: (context) => DialogsScreen()));
                                                                                  // } else {
                                                                                  //   // CommonWidget().showToaster(msg: 'Need to follow the user');
                                                                                  // }
                                                                                  ///
                                                                                  // await Navigator.push(
                                                                                  //     context,
                                                                                  //     MaterialPageRoute(
                                                                                  //       builder: (context) => ChatScreen(
                                                                                  //           widget.quickBlox_id, false),
                                                                                  //     ));
                                                                                },
                                                                                child: Container(
                                                                                  margin: const EdgeInsets.symmetric(horizontal: 0),
                                                                                  // height: 45,
                                                                                  // width:(width ?? 300) ,
                                                                                  // decoration: BoxDecoration(
                                                                                  //     color: Colors.white,
                                                                                  //     borderRadius:
                                                                                  //     BorderRadius.circular(
                                                                                  //         25)),
                                                                                  child: Container(
                                                                                      // alignment: Alignment.center,
                                                                                      // margin: const EdgeInsets
                                                                                      //     .symmetric(
                                                                                      //     vertical: 8,
                                                                                      //     horizontal: 20),
                                                                                      child: Image.asset(
                                                                                    AssetUtils.chat_call_icon,
                                                                                    height: 45.0,
                                                                                    // color: Colors.black,
                                                                                    width: 45.0,
                                                                                    fit: BoxFit.contain,
                                                                                  )
                                                                                      // Text(
                                                                                      //   'Chat',
                                                                                      //   style: TextStyle(
                                                                                      //       color: Colors.black,
                                                                                      //       fontFamily: 'PR',
                                                                                      //       fontSize: 16),
                                                                                      // )
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      bottom:
                                                                          15,
                                                                      top: 10),
                                                              color: HexColor(
                                                                      CommonColor
                                                                          .pinkFont)
                                                                  .withOpacity(
                                                                      0.7),
                                                              height: 1,
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                            ),
                                                            Container(
                                                              child: Obx(() => (_profile_screen_controller
                                                                          .isStoryLoading
                                                                          .value ==
                                                                      true
                                                                  ? const LoaderPage()
                                                                  : (_profile_screen_controller
                                                                          .getStoryModel!
                                                                          .data!
                                                                          .isEmpty
                                                                      ? const SizedBox
                                                                          .shrink()
                                                                      : Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            Container(
                                                                              margin: const EdgeInsets.only(top: 0, right: 16, left: 0),
                                                                              child: Row(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: [
                                                                                  // Column(
                                                                                  //   children: [
                                                                                  //     Container(
                                                                                  //       margin: EdgeInsets.symmetric(
                                                                                  //           horizontal: 5),
                                                                                  //       height: 61,
                                                                                  //       width: 61,
                                                                                  //       decoration: BoxDecoration(
                                                                                  //           borderRadius:
                                                                                  //           BorderRadius.circular(50),
                                                                                  //           border: Border.all(
                                                                                  //               color: Colors.white,
                                                                                  //               width: 3)),
                                                                                  //       child: IconButton(
                                                                                  //         onPressed: () async {
                                                                                  //           // File editedFile = await Navigator
                                                                                  //           //     .of(context)
                                                                                  //           //     .push(MaterialPageRoute(
                                                                                  //           //     builder: (context) =>
                                                                                  //           //         StoriesEditor(
                                                                                  //           //           // fontFamilyList: font_family,
                                                                                  //           //           giphyKey: '',
                                                                                  //           //           onDone:
                                                                                  //           //               (String) {},
                                                                                  //           //           // filePath:
                                                                                  //           //           //     imgFile!.path,
                                                                                  //           //         )));
                                                                                  //           // if (editedFile != null) {
                                                                                  //           //   print(
                                                                                  //           //       'editedFile: ${editedFile.path}');
                                                                                  //           // }
                                                                                  //         },
                                                                                  //         icon: Icon(
                                                                                  //           Icons.add,
                                                                                  //           color: HexColor(
                                                                                  //               CommonColor.pinkFont),
                                                                                  //         ),
                                                                                  //       ),
                                                                                  //     ),
                                                                                  //     SizedBox(
                                                                                  //       height: 2,
                                                                                  //     ),
                                                                                  //     Text(
                                                                                  //       'Add Story',
                                                                                  //       style: TextStyle(
                                                                                  //           color: Colors.white,
                                                                                  //           fontFamily: 'PR',
                                                                                  //           fontSize: 12),
                                                                                  //     )
                                                                                  //   ],
                                                                                  // ),
                                                                                  (_profile_screen_controller.story_info.isNotEmpty
                                                                                      ? Expanded(
                                                                                          child: SizedBox(
                                                                                            height: 88,
                                                                                            child: ListView.builder(
                                                                                                itemCount: _profile_screen_controller.getStoryModel!.data!.length,
                                                                                                shrinkWrap: true,
                                                                                                scrollDirection: Axis.horizontal,
                                                                                                itemBuilder: (BuildContext context, int index) {
                                                                                                  return Padding(
                                                                                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                                                                    child: Column(
                                                                                                      children: [
                                                                                                        GestureDetector(
                                                                                                          onTap: () {
                                                                                                            print(index);
                                                                                                            // view_story(
                                                                                                            //     story_id: story_info[index]
                                                                                                            //         .stID!);
                                                                                                            print(index);
                                                                                                            _profile_screen_controller.story_info = _profile_screen_controller.getStoryModel!.data![index].storys!;

                                                                                                            Get.to(() => StoryScreen(
                                                                                                                  other_user: true,
                                                                                                                  title: _profile_screen_controller.story_[index].title!,
                                                                                                                  // thumbnail:
                                                                                                                  //     test_thumb[index],
                                                                                                                  stories: _profile_screen_controller.story_info,
                                                                                                                  mohit: _profile_screen_controller.getStoryModel!.data![index],
                                                                                                                  story_no: 0,
                                                                                                                  stories_title: _profile_screen_controller.story_,
                                                                                                                ));
                                                                                                            // Get.to(StoryScreen(stories: story_info));
                                                                                                          },
                                                                                                          child: SizedBox(
                                                                                                            height: 60,
                                                                                                            width: 60,
                                                                                                            child: ClipRRect(
                                                                                                              borderRadius: BorderRadius.circular(50),
                                                                                                              child: (_profile_screen_controller.story_[index].storys![0].storyPhoto!.isEmpty
                                                                                                                  ? Image.asset(
                                                                                                                      // test_thumb[
                                                                                                                      //     index]
                                                                                                                      'assets/images/Funky_App_Icon.png')
                                                                                                                  : (_profile_screen_controller.story_[index].storys![0].isVideo == 'false'
                                                                                                                      ? FadeInImage.assetNetwork(
                                                                                                                          fit: BoxFit.cover,
                                                                                                                          image: "${URLConstants.base_data_url}images/${_profile_screen_controller.story_[index].storys![0].storyPhoto!}",
                                                                                                                          placeholder: 'assets/images/Funky_App_Icon.png',
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
                                                                                                        // Text(
                                                                                                        //   '${story_info[index].title}',
                                                                                                        //   style: TextStyle(
                                                                                                        //       color:
                                                                                                        //       Colors.white,
                                                                                                        //       fontFamily: 'PR',
                                                                                                        //       fontSize: 14),
                                                                                                        // )
                                                                                                        (_profile_screen_controller.story_[index].title!.length >= 5
                                                                                                            ? SizedBox(
                                                                                                                height: 20,
                                                                                                                width: 40,
                                                                                                                child: Marquee(
                                                                                                                  text: '${_profile_screen_controller.story_[index].title}',
                                                                                                                  style: const TextStyle(color: Colors.white, fontFamily: 'PR', fontSize: 14),
                                                                                                                  scrollAxis: Axis.horizontal,
                                                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                  blankSpace: 20.0,
                                                                                                                  velocity: 30.0,
                                                                                                                  pauseAfterRound: const Duration(milliseconds: 100),
                                                                                                                  startPadding: 10.0,
                                                                                                                  accelerationDuration: const Duration(seconds: 1),
                                                                                                                  accelerationCurve: Curves.easeIn,
                                                                                                                  decelerationDuration: const Duration(microseconds: 500),
                                                                                                                  decelerationCurve: Curves.easeOut,
                                                                                                                ),
                                                                                                              )
                                                                                                            : Text(
                                                                                                                '${_profile_screen_controller.story_[index].title}',
                                                                                                                style: const TextStyle(color: Colors.white, fontFamily: 'PR', fontSize: 14),
                                                                                                              ))
                                                                                                      ],
                                                                                                    ),
                                                                                                  );
                                                                                                }),
                                                                                          ),
                                                                                        )
                                                                                      : Container(
                                                                                          alignment: Alignment.center,
                                                                                          margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                                                                                          child: const Text(
                                                                                            'No Stories available',
                                                                                            style: TextStyle(color: Colors.white, fontFamily: 'PR', fontSize: 16),
                                                                                          )))
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
                                                                        )))),
                                                            ),
                                                          ],
                                                        )
                                                      : Column(
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
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Container(
                                                                    margin: const EdgeInsets
                                                                        .only(
                                                                        left: 5,
                                                                        top: 0,
                                                                        bottom:
                                                                            0),
                                                                    child: IconButton(
                                                                        padding: EdgeInsets.zero,
                                                                        visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
                                                                        onPressed: () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        icon: const Icon(
                                                                          Icons
                                                                              .arrow_back,
                                                                          color:
                                                                              Colors.white,
                                                                        ))),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      '${_search_screen_controller.userInfoModel_email!.data![0].userName}',
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color: Colors
                                                                              .white,
                                                                          fontFamily:
                                                                              'PB'),
                                                                    ),
                                                                    (_search_screen_controller.userInfoModel_email!.data![0].verify ==
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
                                                                        : const SizedBox
                                                                            .shrink())
                                                                  ],
                                                                ),
                                                                // Container(
                                                                //   margin: EdgeInsets.only(right: 0),
                                                                //   child: IconButton(
                                                                //     visualDensity: VisualDensity(
                                                                //         vertical: 0, horizontal: -4),
                                                                //     icon: Icon(
                                                                //       Icons.more_vert,
                                                                //       color: Colors.white,
                                                                //       size: 25,
                                                                //     ),
                                                                //     onPressed: () {
                                                                //       showDialog(
                                                                //         context: context,
                                                                //         builder: (BuildContext context) {
                                                                //           double width =
                                                                //               MediaQuery
                                                                //                   .of(context)
                                                                //                   .size
                                                                //                   .width;
                                                                //           double height =
                                                                //               MediaQuery
                                                                //                   .of(context)
                                                                //                   .size
                                                                //                   .height;
                                                                //           return BackdropFilter(
                                                                //             filter: ImageFilter.blur(
                                                                //                 sigmaX: 10, sigmaY: 10),
                                                                //             child: AlertDialog(
                                                                //                 insetPadding:
                                                                //                 EdgeInsets.only(
                                                                //                     bottom: 500,
                                                                //                     left: 150),
                                                                //                 backgroundColor:
                                                                //                 Colors.transparent,
                                                                //                 contentPadding:
                                                                //                 EdgeInsets.zero,
                                                                //                 elevation: 0.0,
                                                                //                 // title: Center(child: Text("Evaluation our APP")),
                                                                //                 content: Column(
                                                                //                   mainAxisAlignment:
                                                                //                   MainAxisAlignment
                                                                //                       .end,
                                                                //                   children: [
                                                                //                     Container(
                                                                //                       margin: EdgeInsets
                                                                //                           .symmetric(
                                                                //                           vertical: 0,
                                                                //                           horizontal:
                                                                //                           0),
                                                                //                       // height: 122,
                                                                //                       width: 150,
                                                                //                       // padding: const EdgeInsets.all(8.0),
                                                                //                       decoration:
                                                                //                       BoxDecoration(
                                                                //                           gradient:
                                                                //                           LinearGradient(
                                                                //                             begin: Alignment(
                                                                //                                 -1.0,
                                                                //                                 0.0),
                                                                //                             end: Alignment(
                                                                //                                 1.0,
                                                                //                                 0.0),
                                                                //                             transform:
                                                                //                             GradientRotation(
                                                                //                                 0.7853982),
                                                                //                             // stops: [0.1, 0.5, 0.7, 0.9],
                                                                //                             colors: [
                                                                //                               HexColor(
                                                                //                                   "#000000"),
                                                                //                               HexColor(
                                                                //                                   "#000000"),
                                                                //                               HexColor(
                                                                //                                   "##E84F90"),
                                                                //                               // HexColor("#ffffff"),
                                                                //                               // HexColor("#FFFFFF").withOpacity(0.67),
                                                                //                             ],
                                                                //                           ),
                                                                //                           color: Colors
                                                                //                               .white,
                                                                //                           border: Border.all(
                                                                //                               color: Colors
                                                                //                                   .white,
                                                                //                               width:
                                                                //                               1),
                                                                //                           borderRadius:
                                                                //                           BorderRadius.all(
                                                                //                               Radius.circular(
                                                                //                                   26.0))),
                                                                //                       child: Padding(
                                                                //                         padding: const EdgeInsets
                                                                //                             .symmetric(
                                                                //                             vertical: 10,
                                                                //                             horizontal:
                                                                //                             5),
                                                                //                         child: Column(
                                                                //                           mainAxisAlignment:
                                                                //                           MainAxisAlignment
                                                                //                               .center,
                                                                //                           children: [
                                                                //                             Text(
                                                                //                               'Report',
                                                                //                               textAlign:
                                                                //                               TextAlign
                                                                //                                   .center,
                                                                //                               style: TextStyle(
                                                                //                                   fontSize:
                                                                //                                   15,
                                                                //                                   fontFamily:
                                                                //                                   'PR',
                                                                //                                   color: Colors
                                                                //                                       .white),
                                                                //                             ),
                                                                //                             Container(
                                                                //                               margin: EdgeInsets
                                                                //                                   .symmetric(
                                                                //                                   horizontal:
                                                                //                                   20),
                                                                //                               child:
                                                                //                               Divider(
                                                                //                                 color: Colors
                                                                //                                     .black,
                                                                //                                 height:
                                                                //                                 20,
                                                                //                               ),
                                                                //                             ),
                                                                //                             GestureDetector(
                                                                //                               onTap: () {
                                                                //                                 _settings_screen_controller
                                                                //                                     .Block_unblock_api(
                                                                //                                     context:
                                                                //                                     context,
                                                                //                                     user_id: _search_screen_controller
                                                                //                                         .userInfoModel_email!
                                                                //                                         .data![0]
                                                                //                                         .id!,
                                                                //                                     user_name: _search_screen_controller
                                                                //                                         .userInfoModel_email!
                                                                //                                         .data![0]
                                                                //                                         .userName!,
                                                                //                                     social_bloc_type: _search_screen_controller
                                                                //                                         .userInfoModel_email!
                                                                //                                         .data![0]
                                                                //                                         .socialType!,
                                                                //                                     block_unblock: (_search_screen_controller
                                                                //                                         .userInfoModel_email!
                                                                //                                         .data![0].userBlockUnblock == 'Block' ? 'Unblock' :
                                                                //                                     'Block'));
                                                                //                                 Navigator.pop(
                                                                //                                     context);
                                                                //                               },
                                                                //                               child:
                                                                //                               Container(
                                                                //                                 child:
                                                                //                                  Text(
                                                                //                                    (_search_screen_controller
                                                                //                                        .userInfoModel_email!
                                                                //                                        .data![0].userBlockUnblock == 'Block' ? 'Unblock' :
                                                                //                                   'Block'),
                                                                //                                   style: TextStyle(
                                                                //                                       fontSize:
                                                                //                                       15,
                                                                //                                       fontFamily:
                                                                //                                       'PR',
                                                                //                                       color:
                                                                //                                       Colors
                                                                //                                           .white),
                                                                //                                 ),
                                                                //                               ),
                                                                //                             ),
                                                                //
                                                                //                           ],
                                                                //                         ),
                                                                //                       ),
                                                                //                     ),
                                                                //                   ],
                                                                //                 )),
                                                                //           );
                                                                //         },
                                                                //       );
                                                                //     },
                                                                //   ),
                                                                // ),
                                                                DropdownButtonHideUnderline(
                                                                  child:
                                                                      DropdownButton2(
                                                                    // isExpanded: true,
                                                                    customButton:
                                                                        const Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          vertical:
                                                                              5.0),
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .more_vert,
                                                                        color: Colors
                                                                            .white,
                                                                        size:
                                                                            25,
                                                                      ),
                                                                    ),
                                                                    items: [
                                                                      DropdownMenuItem(
                                                                          value:
                                                                              "Apple",
                                                                          onTap:
                                                                              () {},
                                                                          child:
                                                                              GestureDetector(
                                                                            onTap:
                                                                                () async {},
                                                                            child:
                                                                                Container(
                                                                              alignment: Alignment.center,
                                                                              child: const Text("Report", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'PR')),
                                                                            ),
                                                                          )),
                                                                      DropdownMenuItem(
                                                                          value:
                                                                              "Apple1",
                                                                          onTap:
                                                                              () {},
                                                                          child:
                                                                              GestureDetector(
                                                                            onTap:
                                                                                () async {
                                                                              print("datssa");
                                                                              print("datssa");
                                                                              _settings_screen_controller.Block_unblock_api(context: context, user_id: _search_screen_controller.userInfoModel_email!.data![0].id!, user_name: _search_screen_controller.userInfoModel_email!.data![0].userName!, social_bloc_type: _search_screen_controller.userInfoModel_email!.data![0].socialType!, block_unblock: (_search_screen_controller.userInfoModel_email!.data![0].userBlockUnblock == 'Block' ? 'Unblock' : 'Block'));
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              alignment: Alignment.center,
                                                                              padding: const EdgeInsets.only(top: 5),
                                                                              child: const Text("Block", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'PR')),
                                                                            ),
                                                                          )),
                                                                    ],
                                                                    value:
                                                                        dropdownvalue,
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontFamily:
                                                                          'PR',
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    onChanged:
                                                                        (value) {},

                                                                    // iconSize: 25,
                                                                    // iconEnabledColor: Color(0xff007DEF),
                                                                    // iconDisabledColor: Color(0xff007DEF),
                                                                    // buttonHeight: 50,
                                                                    // buttonWidth: 100,
                                                                    // enableFeedback: true,
                                                                    // buttonPadding: const EdgeInsets.only(
                                                                    //     left: 15, right: 15),
                                                                    // buttonDecoration: BoxDecoration(
                                                                    //     borderRadius:
                                                                    //     BorderRadius.circular(10),
                                                                    //     color: Colors.transparent),
                                                                    // buttonElevation: 0,
                                                                    // itemHeight: 30,
                                                                    // itemPadding: const EdgeInsets.only(
                                                                    //     left: 14, right: 14),
                                                                    // dropdownMaxHeight: 200,
                                                                    // dropdownWidth: 150,
                                                                    // dropdownPadding: null,
                                                                    // dropdownDecoration: BoxDecoration(
                                                                    //   borderRadius:
                                                                    //   BorderRadius.circular(24),
                                                                    //   border: Border.all(
                                                                    //       width: 1, color: Colors.white),
                                                                    //   gradient: LinearGradient(
                                                                    //     begin: Alignment.topLeft,
                                                                    //     end: Alignment.bottomRight,
                                                                    //     // stops: [0.1, 0.5, 0.7, 0.9],
                                                                    //     colors: [
                                                                    //       HexColor("#000000"),
                                                                    //       HexColor("#C12265"),
                                                                    //       // HexColor("#FFFFFF"),
                                                                    //     ],
                                                                    //   ),
                                                                    // ),
                                                                    // dropdownElevation: 8,
                                                                    // scrollbarRadius:
                                                                    // const Radius.circular(40),
                                                                    // scrollbarThickness: 6,
                                                                    // scrollbarAlwaysShow: true,
                                                                    // offset: const Offset(-10, -8),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),

                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                      // color: HexColor(CommonColor.bloodRed),
                                                                      color: (widget.search_user_data.type ==
                                                                              'Advertiser'
                                                                          ? HexColor(CommonColor
                                                                              .bloodRed)
                                                                          : (widget.search_user_data.type == 'Kids'
                                                                              ? HexColor(
                                                                                  "#0b0f54")
                                                                              : Colors
                                                                                  .black)),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20)),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child: Column(
                                                                  children: [
                                                                    Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
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
                                                                                child: Container(
                                                                                  decoration: const BoxDecoration(),
                                                                                  child: (_search_screen_controller.isuserinfoLoading.value == true
                                                                                      ? CircularProgressIndicator(
                                                                                          color: HexColor(CommonColor.pinkFont),
                                                                                        )
                                                                                      : (_search_screen_controller.userInfoModel_email!.data![0].image!.isNotEmpty
                                                                                          ? Image.network(
                                                                                              "${URLConstants.base_data_url}images/${_search_screen_controller.userInfoModel_email!.data![0].image!}",
                                                                                              height: 80,
                                                                                              width: 80,
                                                                                              fit: BoxFit.cover,
                                                                                            )
                                                                                          : (_search_screen_controller.userInfoModel_email!.data![0].profileUrl!.isNotEmpty
                                                                                              ? FadeInImage.assetNetwork(
                                                                                                  height: 80,
                                                                                                  width: 80,
                                                                                                  fit: BoxFit.cover,
                                                                                                  image: _search_screen_controller.userInfoModel_email!.data![0].profileUrl!,
                                                                                                  placeholder: 'assets/images/Funky_App_Icon.png',
                                                                                                  imageErrorBuilder: (context, url, error) => Image.asset(
                                                                                                    "assets/images/Funky_App_Icon.png",
                                                                                                    height: 80,
                                                                                                    width: 80,
                                                                                                    fit: BoxFit.cover,
                                                                                                  ),
                                                                                                )
                                                                                              // Image.network(
                                                                                              //   _search_screen_controller
                                                                                              //       .userInfoModel_email!
                                                                                              //       .data![0]
                                                                                              //       .profileUrl!,
                                                                                              //   height: 80,
                                                                                              //   width: 80,
                                                                                              //   fit: BoxFit.cover,
                                                                                              // )
                                                                                              : Image.asset(
                                                                                                  AssetUtils.image1,
                                                                                                  height: 80,
                                                                                                  width: 80,
                                                                                                  fit: BoxFit.cover,
                                                                                                )))),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            (widget.search_user_data.type == 'Advertiser'
                                                                                ? const SizedBox.shrink()
                                                                                : Positioned(
                                                                                    bottom: 0,
                                                                                    right: 2,
                                                                                    child: Obx(
                                                                                      () => _settings_screen_controller.isRewardLoading.value == true
                                                                                          ? SizedBox(
                                                                                              height: 20,
                                                                                              width: 20,
                                                                                              child: CircularProgressIndicator(
                                                                                                strokeWidth: 2,
                                                                                                color: HexColor(CommonColor.pinkFont),
                                                                                              ))
                                                                                          : Container(
                                                                                              decoration: BoxDecoration(
                                                                                                  color: Colors.white,
                                                                                                  // color: (idUserType ==
                                                                                                  //     'Advertiser'
                                                                                                  //     ? HexColor(CommonColor
                                                                                                  //     .bloodRed)
                                                                                                  //     : (idUserType == 'Kids'
                                                                                                  //     ? HexColor(
                                                                                                  //     "#0b0f54")
                                                                                                  //     : Colors
                                                                                                  //     .black)),
                                                                                                  boxShadow: const [
                                                                                                    BoxShadow(
                                                                                                      color: Colors.grey,
                                                                                                      offset: Offset(0.0, 1.0),
                                                                                                      //(x,y)
                                                                                                      blurRadius: 6.0,
                                                                                                    ),
                                                                                                  ],
                                                                                                  // border: Border.all(
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
                                                                                                  borderRadius: BorderRadius.circular(100)),
                                                                                              child: Padding(
                                                                                                padding: const EdgeInsets.all(2.0),
                                                                                                child: (double.parse(_settings_screen_controller.getRewardModel!.totalReward!) <= 1000 ? Image.asset(AssetUtils.bronze_icon, height: 20, width: 20) : (double.parse(_settings_screen_controller.getRewardModel!.totalReward!) >= 1000 && double.parse(_settings_screen_controller.getRewardModel!.totalReward!) <= 5000 ? Image.asset(AssetUtils.silver_icon, height: 20, width: 20) : (double.parse(_settings_screen_controller.getRewardModel!.totalReward!) >= 5000 ? Image.asset(AssetUtils.gold_icon, height: 20, width: 20) : Image.asset(AssetUtils.silver_icon, height: 20, width: 20)))),
                                                                                              ),
                                                                                            ),
                                                                                    ))),
                                                                          ],
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              5,
                                                                        ),
                                                                        Expanded(
                                                                          flex:
                                                                              3,
                                                                          child:
                                                                              Container(
                                                                            margin:
                                                                                const EdgeInsets.only(left: 10),
                                                                            height:
                                                                                100,
                                                                            // alignment: FractionalOffset.center,
                                                                            child:
                                                                                Column(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  (_search_screen_controller.userInfoModel_email!.data![0].fullName!.isNotEmpty ? '${_search_screen_controller.userInfoModel_email!.data![0].fullName}' : 'Please update profile'),
                                                                                  style: TextStyle(fontSize: 14, color: HexColor(CommonColor.pinkFont)),
                                                                                ),
                                                                                const SizedBox(
                                                                                  height: 10,
                                                                                ),
                                                                                Text(
                                                                                  (_search_screen_controller.userInfoModel_email!.data![0].about!.isNotEmpty ? '${_search_screen_controller.userInfoModel_email!.data![0].about}' : ' '),
                                                                                  style: TextStyle(fontSize: 14, color: HexColor(CommonColor.subHeaderColor)),
                                                                                ),
                                                                                // Text(
                                                                                //   (widget.search_user_data.fullName!
                                                                                //           .isNotEmpty
                                                                                //       ? '${widget.search_user_data.fullName}'
                                                                                //       : 'Please update profile'),
                                                                                //   style: TextStyle(
                                                                                //       fontSize: 14,
                                                                                //       color: HexColor(CommonColor.pinkFont)),
                                                                                // ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Row(
                                                                              children: [
                                                                                IconButton(
                                                                                    visualDensity: const VisualDensity(vertical: -4),
                                                                                    padding: const EdgeInsets.only(left: 5.0),
                                                                                    icon: Image.asset(
                                                                                      AssetUtils.like_icon_filled,
                                                                                      color: HexColor(CommonColor.pinkFont),
                                                                                      height: 20,
                                                                                      width: 20,
                                                                                    ),
                                                                                    onPressed: () {}),
                                                                                Text(
                                                                                  '${_search_screen_controller.userInfoModel_email!.data![0].likeCount}',
                                                                                  style: const TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'PR'),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            Row(
                                                                              children: [
                                                                                IconButton(
                                                                                    padding: const EdgeInsets.only(left: 5.0),
                                                                                    visualDensity: const VisualDensity(vertical: -4),
                                                                                    icon: Image.asset(
                                                                                      AssetUtils.profile_filled,
                                                                                      color: HexColor(CommonColor.pinkFont),
                                                                                      height: 20,
                                                                                      width: 20,
                                                                                    ),
                                                                                    onPressed: () {
                                                                                      if (_search_screen_controller.userInfoModel_email!.data![0].followerFollowingShowStatus == "true") {
                                                                                        Get.to(FollowersList(
                                                                                          user_id: widget.search_user_data.id!,
                                                                                          // searchUserid: widget
                                                                                          //     .search_user_data
                                                                                          //     .id!,
                                                                                        ));
                                                                                      }
                                                                                    }),
                                                                                Text(
                                                                                  '${_search_screen_controller.userInfoModel_email!.data![0].followerNumber}',
                                                                                  style: const TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'PR'),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            Row(
                                                                              children: [
                                                                                IconButton(
                                                                                    visualDensity: const VisualDensity(vertical: -4),
                                                                                    padding: const EdgeInsets.only(left: 5.0),
                                                                                    icon: Image.asset(
                                                                                      AssetUtils.following_filled,
                                                                                      color: HexColor(CommonColor.pinkFont),
                                                                                      height: 20,
                                                                                      width: 20,
                                                                                    ),
                                                                                    onPressed: () {
                                                                                      if (_search_screen_controller.userInfoModel_email!.data![0].followerFollowingShowStatus == "true") {
                                                                                        Get.to(FollowingScreen(
                                                                                          user_id: widget.search_user_data.id!,
                                                                                        ));
                                                                                      }
                                                                                    }),
                                                                                Text(
                                                                                  '${_search_screen_controller.userInfoModel_email!.data![0].followingNumber}',
                                                                                  style: const TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'PR'),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Expanded(
                                                                          flex:
                                                                              2,
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Container(
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.circular(50),
                                                                                ),
                                                                                child: IconButton(
                                                                                  padding: EdgeInsets.zero,
                                                                                  visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
                                                                                  icon: Image.asset(
                                                                                    AssetUtils.facebook_icon,
                                                                                    height: 30,
                                                                                    width: 30,
                                                                                  ),
                                                                                  onPressed: () async {
                                                                                    if (_search_screen_controller.userInfoModel_email!.data![0].socialLinkShowStatus == "true") {
                                                                                      if (_search_screen_controller.userInfoModel_email!.data![0].facebookLinks!.isNotEmpty) {
                                                                                        if (await launchUrl(Uri.parse(_search_screen_controller.userInfoModel_email!.data![0].facebookLinks!))) {
                                                                                          throw 'Could not launch ${_search_screen_controller.userInfoModel_email!.data![0].facebookLinks!}';
                                                                                        }
                                                                                      }
                                                                                    }

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
                                                                                  visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
                                                                                  icon: Image.asset(
                                                                                    AssetUtils.instagram_icon,
                                                                                    height: 30,
                                                                                    width: 30,
                                                                                  ),
                                                                                  onPressed: () async {
                                                                                    if (_search_screen_controller.userInfoModel_email!.data![0].socialLinkShowStatus == "true") {
                                                                                      if (_search_screen_controller.userInfoModel_email!.data![0].instagramLinks!.isNotEmpty) {
                                                                                        if (await launchUrl(Uri.parse(_search_screen_controller.userInfoModel_email!.data![0].instagramLinks!))) {
                                                                                          throw 'Could not launch ${_search_screen_controller.userInfoModel_email!.data![0].instagramLinks!}';
                                                                                        }
                                                                                      }
                                                                                    }
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
                                                                                  visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
                                                                                  icon: Image.asset(
                                                                                    AssetUtils.twitter_icon,
                                                                                    height: 30,
                                                                                    width: 30,
                                                                                  ),
                                                                                  onPressed: () async {
                                                                                    if (_search_screen_controller.userInfoModel_email!.data![0].socialLinkShowStatus == "true") {
                                                                                      if (_search_screen_controller.userInfoModel_email!.data![0].twitterLinks!.isNotEmpty) {
                                                                                        if (await launchUrl(Uri.parse(_search_screen_controller.userInfoModel_email!.data![0].twitterLinks!))) {
                                                                                          throw 'Could not launch ${_search_screen_controller.userInfoModel_email!.data![0].twitterLinks!}';
                                                                                        }
                                                                                      }
                                                                                    }

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
                                                                                    // isExpanded: true,
                                                                                    customButton: const Icon(
                                                                                      Icons.keyboard_arrow_down,
                                                                                      color: Colors.white,
                                                                                      size: 20,
                                                                                    ),
                                                                                    items: [
                                                                                      DropdownMenuItem(
                                                                                        value: "Apple",
                                                                                        onTap: () async {
                                                                                          if (_search_screen_controller.userInfoModel_email!.data![0].socialLinkShowStatus == "true") {
                                                                                            if (_search_screen_controller.userInfoModel_email!.data![0].tiktokLinks!.isNotEmpty) {
                                                                                              if (await launchUrl(Uri.parse(_search_screen_controller.userInfoModel_email!.data![0].tiktokLinks!))) {
                                                                                                throw 'Could not launch ${_search_screen_controller.userInfoModel_email!.data![0].twitterLinks!}';
                                                                                              }
                                                                                            }
                                                                                          }
                                                                                        },
                                                                                        child: Row(
                                                                                          children: [
                                                                                            Image.asset(
                                                                                              AssetUtils.tiktok,
                                                                                              height: 32,
                                                                                              width: 32,
                                                                                            ),
                                                                                            const SizedBox(width: 15),
                                                                                            const Expanded(
                                                                                              child: Text("TikTok", overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'PR')),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      // Add other DropdownMenuItem entries here...
                                                                                    ],
                                                                                    value: dropdownvalue,
                                                                                    style: const TextStyle(
                                                                                      fontSize: 16,
                                                                                      fontFamily: 'PR',
                                                                                      color: Colors.white,
                                                                                    ),
                                                                                    alignment: Alignment.centerLeft,
                                                                                    onChanged: (value) {
                                                                                      setState(() {
                                                                                        dropdownvalue = value.toString();
                                                                                      });
                                                                                    },
                                                                                    iconStyleData: const IconStyleData(
                                                                                      iconSize: 25,
                                                                                      iconEnabledColor: Color(0xff007DEF),
                                                                                      iconDisabledColor: Color(0xff007DEF),
                                                                                    ),
                                                                                    buttonStyleData: ButtonStyleData(
                                                                                      decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius.circular(10),
                                                                                        color: Colors.transparent
                                                                                      ),
                                                                                      height: 50,
                                                                                      width: 100,
                                                                                      elevation: 0,
                                                                                      padding: const EdgeInsets.only(left: 14, right: 14),
                                                                                    ),
                                                                                    enableFeedback: true,
                                                                                    dropdownStyleData: DropdownStyleData(
                                                                                      padding: EdgeInsets.zero,
                                                                                      width: 150,
                                                                                      maxHeight: 200,
                                                                                      elevation: 8,
                                                                                      scrollbarTheme: const ScrollbarThemeData(
                                                                                        radius: Radius.circular(40),
                                                                                        thickness: WidgetStatePropertyAll(8),
                                                                                      ),
                                                                                      decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius.circular(24),
                                                                                        border: Border.all(width: 1, color: Colors.white),
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
                                                                          flex:
                                                                              2,
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.end,
                                                                            children: [
                                                                              Obx(() => (_search_screen_controller.comapre_loading.value == true
                                                                                  ? SizedBox(
                                                                                      height: 20,
                                                                                      width: 20,
                                                                                      child: CircularProgressIndicator(
                                                                                        color: HexColor(CommonColor.pinkFont),
                                                                                        strokeWidth: 2,
                                                                                      ))
                                                                                  : GestureDetector(
                                                                                      onTap: () async {
                                                                                        await _search_screen_controller.Follow_unfollow_api(context: context, user_id: widget.search_user_data.id, user_social: widget.search_user_data.socialType, follow_unfollow: (_search_screen_controller.is_follower != null && _search_screen_controller.is_following != null ? 'unfollow' : (_search_screen_controller.is_follower != null && _search_screen_controller.is_following == null ? 'follow' : (_search_screen_controller.is_follower == null && _search_screen_controller.is_following != null ? "unfollow" : (_search_screen_controller.is_follower == null && _search_screen_controller.is_following == null ? "follow" : 'follow'))))).then((value) => setState(() {}));
                                                                                      },
                                                                                      child: Container(
                                                                                        margin: const EdgeInsets.symmetric(horizontal: 0),
                                                                                        // height: 45,
                                                                                        // width:(width ?? 300) ,
                                                                                        decoration: BoxDecoration(color: (_search_screen_controller.is_follower != null && _search_screen_controller.is_following != null ? Colors.black : (_search_screen_controller.is_follower != null && _search_screen_controller.is_following == null ? Colors.white : (_search_screen_controller.is_follower == null && _search_screen_controller.is_following != null ? Colors.black : (_search_screen_controller.is_follower == null && _search_screen_controller.is_following == null ? Colors.white : Colors.white)))), border: Border.all(width: 1, color: (_search_screen_controller.is_follower != null && _search_screen_controller.is_following != null ? Colors.white : (_search_screen_controller.is_follower != null && _search_screen_controller.is_following == null ? HexColor(CommonColor.pinkFont) : (_search_screen_controller.is_follower == null && _search_screen_controller.is_following != null ? Colors.white : (_search_screen_controller.is_follower == null && _search_screen_controller.is_following == null ? HexColor("#ffffff") : Colors.white))))), borderRadius: BorderRadius.circular(25)),
                                                                                        child: Container(
                                                                                            alignment: Alignment.center,
                                                                                            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                                                                                            child: Text(
                                                                                              (_search_screen_controller.is_follower != null && _search_screen_controller.is_following != null ? 'Following' : (_search_screen_controller.is_follower != null && _search_screen_controller.is_following == null ? 'Follow' : (_search_screen_controller.is_follower == null && _search_screen_controller.is_following != null ? "Following" : (_search_screen_controller.is_follower == null && _search_screen_controller.is_following == null ? 'Follow' : (_search_screen_controller.is_follower == null && _search_screen_controller.is_following != null ? 'Following' : ''))))),
                                                                                              style: TextStyle(color: (_search_screen_controller.is_follower != null && _search_screen_controller.is_following != null ? Colors.white : (_search_screen_controller.is_follower != null && _search_screen_controller.is_following == null ? Colors.black : (_search_screen_controller.is_follower == null && _search_screen_controller.is_following != null ? Colors.white : (_search_screen_controller.is_follower == null && _search_screen_controller.is_following == null ? Colors.black : Colors.white)))), fontFamily: 'PR', fontSize: 16),
                                                                                            )),
                                                                                      ),
                                                                                    ))),
                                                                              const SizedBox(
                                                                                width: 10,
                                                                              ),
                                                                              GestureDetector(
                                                                                onTap: () async {
                                                                                  // if (_search_screen_controller
                                                                                  //     .is_follower !=
                                                                                  //     null ||
                                                                                  //     _search_screen_controller
                                                                                  //         .is_following !=
                                                                                  //         null) {
                                                                                  // final QuerySnapshot result = await firebaseFirestore
                                                                                  //     .collection(FirestoreConstants.pathUserCollection)
                                                                                  //     .where(FirestoreConstants.id, isEqualTo: widget.search_user_data.id)
                                                                                  //     .get();
                                                                                  // final List<DocumentSnapshot> documents = result.docs;
                                                                                  // if (documents.isEmpty) {
                                                                                  //   // Writing data to server because here is a new user
                                                                                  //   firebaseFirestore
                                                                                  //       .collection(FirestoreConstants.pathUserCollection)
                                                                                  //       .doc(widget.search_user_data.id)
                                                                                  //       .set({
                                                                                  //     FirestoreConstants.nickname: widget.search_user_data.fullName,
                                                                                  //     FirestoreConstants.photoUrl:
                                                                                  //     "https://foxytechnologies.com/funky/images/${widget.search_user_data.image}",
                                                                                  //     FirestoreConstants.id: widget.search_user_data.id,
                                                                                  //     'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
                                                                                  //     FirestoreConstants.chattingWith: null
                                                                                  //   });
                                                                                  //   // Write data to local storage
                                                                                  //   // User? currentUser = firebaseUser;
                                                                                  //   SharedPreferences prefs = await SharedPreferences.getInstance();
                                                                                  //   await prefs.setString(
                                                                                  //       FirestoreConstants.id, widget.search_user_data.id!);
                                                                                  //   await prefs.setString(
                                                                                  //       FirestoreConstants.nickname, widget.search_user_data.fullName ?? "");
                                                                                  //   await prefs.setString(
                                                                                  //       FirestoreConstants.photoUrl,
                                                                                  //       widget.search_user_data.image ??
                                                                                  //           "");
                                                                                  // }
                                                                                  // else{
                                                                                  //   DocumentSnapshot documentSnapshot = documents[0];
                                                                                  //   UserChat userChat = UserChat.fromDocument(documentSnapshot);
                                                                                  //   // Write data to local
                                                                                  //   SharedPreferences prefs = await SharedPreferences.getInstance();
                                                                                  //   await prefs.setString(FirestoreConstants.id, userChat.id);
                                                                                  //   await prefs.setString(FirestoreConstants.nickname, userChat.nickname);
                                                                                  //   await prefs.setString(FirestoreConstants.photoUrl, userChat.photoUrl);
                                                                                  //   await prefs.setString(FirestoreConstants.aboutMe, userChat.aboutMe);
                                                                                  //
                                                                                  // }

                                                                                  // Navigator.push(
                                                                                  //   context,
                                                                                  //   MaterialPageRoute(
                                                                                  //     builder: (context) =>
                                                                                  //         ChatPage(
                                                                                  //           arguments: ChatPageArguments(
                                                                                  //             peerId: widget
                                                                                  //                 .search_user_data
                                                                                  //                 .id!,
                                                                                  //             peerAvatar: widget
                                                                                  //                 .search_user_data
                                                                                  //                 .image!,
                                                                                  //             peerNickname: widget
                                                                                  //                 .search_user_data
                                                                                  //                 .fullName!,
                                                                                  //           ),
                                                                                  //         ),
                                                                                  //   ),
                                                                                  // );
                                                                                  // Navigator.pushReplacement(
                                                                                  //     context,
                                                                                  //     MaterialPageRoute(
                                                                                  //         builder: (context) => DialogsScreen()));
                                                                                  // } else {
                                                                                  //   // CommonWidget().showToaster(msg: 'Need to follow the user');
                                                                                  // }
                                                                                  ///
                                                                                  // await Navigator.push(
                                                                                  //     context,
                                                                                  //     MaterialPageRoute(
                                                                                  //       builder: (context) => ChatScreen(
                                                                                  //           widget.quickBlox_id, false),
                                                                                  //     ));
                                                                                },
                                                                                child: Container(
                                                                                  margin: const EdgeInsets.symmetric(horizontal: 0),
                                                                                  // height: 45,
                                                                                  // width:(width ?? 300) ,
                                                                                  // decoration: BoxDecoration(
                                                                                  //     color: Colors.white,
                                                                                  //     borderRadius:
                                                                                  //     BorderRadius.circular(
                                                                                  //         25)),
                                                                                  child: Container(
                                                                                      // alignment: Alignment.center,
                                                                                      // margin: const EdgeInsets
                                                                                      //     .symmetric(
                                                                                      //     vertical: 8,
                                                                                      //     horizontal: 20),
                                                                                      child: Image.asset(
                                                                                    AssetUtils.chat_call_icon,
                                                                                    height: 45.0,
                                                                                    // color: Colors.black,
                                                                                    width: 45.0,
                                                                                    fit: BoxFit.contain,
                                                                                  )
                                                                                      // Text(
                                                                                      //   'Chat',
                                                                                      //   style: TextStyle(
                                                                                      //       color: Colors.black,
                                                                                      //       fontFamily: 'PR',
                                                                                      //       fontSize: 16),
                                                                                      // )
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      bottom:
                                                                          15,
                                                                      top: 10),
                                                              color: HexColor(
                                                                      CommonColor
                                                                          .pinkFont)
                                                                  .withOpacity(
                                                                      0.7),
                                                              height: 1,
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                            ),
                                                            Container(
                                                              child: Obx(() => (_profile_screen_controller
                                                                          .isStoryLoading
                                                                          .value ==
                                                                      true
                                                                  ? const LoaderPage()
                                                                  : (_profile_screen_controller
                                                                          .getStoryModel!
                                                                          .data!
                                                                          .isEmpty
                                                                      ? const SizedBox
                                                                          .shrink()
                                                                      : Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            Container(
                                                                              margin: const EdgeInsets.only(top: 0, right: 16, left: 0),
                                                                              child: Row(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: [
                                                                                  // Column(
                                                                                  //   children: [
                                                                                  //     Container(
                                                                                  //       margin: EdgeInsets.symmetric(
                                                                                  //           horizontal: 5),
                                                                                  //       height: 61,
                                                                                  //       width: 61,
                                                                                  //       decoration: BoxDecoration(
                                                                                  //           borderRadius:
                                                                                  //           BorderRadius.circular(50),
                                                                                  //           border: Border.all(
                                                                                  //               color: Colors.white,
                                                                                  //               width: 3)),
                                                                                  //       child: IconButton(
                                                                                  //         onPressed: () async {
                                                                                  //           // File editedFile = await Navigator
                                                                                  //           //     .of(context)
                                                                                  //           //     .push(MaterialPageRoute(
                                                                                  //           //     builder: (context) =>
                                                                                  //           //         StoriesEditor(
                                                                                  //           //           // fontFamilyList: font_family,
                                                                                  //           //           giphyKey: '',
                                                                                  //           //           onDone:
                                                                                  //           //               (String) {},
                                                                                  //           //           // filePath:
                                                                                  //           //           //     imgFile!.path,
                                                                                  //           //         )));
                                                                                  //           // if (editedFile != null) {
                                                                                  //           //   print(
                                                                                  //           //       'editedFile: ${editedFile.path}');
                                                                                  //           // }
                                                                                  //         },
                                                                                  //         icon: Icon(
                                                                                  //           Icons.add,
                                                                                  //           color: HexColor(
                                                                                  //               CommonColor.pinkFont),
                                                                                  //         ),
                                                                                  //       ),
                                                                                  //     ),
                                                                                  //     SizedBox(
                                                                                  //       height: 2,
                                                                                  //     ),
                                                                                  //     Text(
                                                                                  //       'Add Story',
                                                                                  //       style: TextStyle(
                                                                                  //           color: Colors.white,
                                                                                  //           fontFamily: 'PR',
                                                                                  //           fontSize: 12),
                                                                                  //     )
                                                                                  //   ],
                                                                                  // ),
                                                                                  (_profile_screen_controller.story_info.isNotEmpty
                                                                                      ? Expanded(
                                                                                          child: SizedBox(
                                                                                            height: 88,
                                                                                            child: ListView.builder(
                                                                                                itemCount: _profile_screen_controller.getStoryModel!.data!.length,
                                                                                                shrinkWrap: true,
                                                                                                scrollDirection: Axis.horizontal,
                                                                                                itemBuilder: (BuildContext context, int index) {
                                                                                                  return Padding(
                                                                                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                                                                    child: Column(
                                                                                                      children: [
                                                                                                        GestureDetector(
                                                                                                          onTap: () {
                                                                                                            print(index);
                                                                                                            // view_story(
                                                                                                            //     story_id: story_info[index]
                                                                                                            //         .stID!);
                                                                                                            print(index);
                                                                                                            _profile_screen_controller.story_info = _profile_screen_controller.getStoryModel!.data![index].storys!;

                                                                                                            Get.to(() => StoryScreen(
                                                                                                                  other_user: true,
                                                                                                                  title: _profile_screen_controller.story_[index].title!,
                                                                                                                  // thumbnail:
                                                                                                                  //     test_thumb[index],
                                                                                                                  stories: _profile_screen_controller.story_info,
                                                                                                                  mohit: _profile_screen_controller.getStoryModel!.data![index],
                                                                                                                  story_no: 0,
                                                                                                                  stories_title: _profile_screen_controller.story_,
                                                                                                                ));
                                                                                                            // Get.to(StoryScreen(stories: story_info));
                                                                                                          },
                                                                                                          child: SizedBox(
                                                                                                            height: 60,
                                                                                                            width: 60,
                                                                                                            child: ClipRRect(
                                                                                                              borderRadius: BorderRadius.circular(50),
                                                                                                              child: (_profile_screen_controller.story_[index].storys![0].storyPhoto!.isEmpty
                                                                                                                  ? Image.asset(
                                                                                                                      // test_thumb[
                                                                                                                      //     index]
                                                                                                                      'assets/images/Funky_App_Icon.png')
                                                                                                                  : (_profile_screen_controller.story_[index].storys![0].isVideo == 'false'
                                                                                                                      ? FadeInImage.assetNetwork(
                                                                                                                          fit: BoxFit.cover,
                                                                                                                          image: "${URLConstants.base_data_url}images/${_profile_screen_controller.story_[index].storys![0].storyPhoto!}",
                                                                                                                          placeholder: 'assets/images/Funky_App_Icon.png',
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
                                                                                                        // Text(
                                                                                                        //   '${story_info[index].title}',
                                                                                                        //   style: TextStyle(
                                                                                                        //       color:
                                                                                                        //       Colors.white,
                                                                                                        //       fontFamily: 'PR',
                                                                                                        //       fontSize: 14),
                                                                                                        // )
                                                                                                        (_profile_screen_controller.story_[index].title!.length >= 5
                                                                                                            ? SizedBox(
                                                                                                                height: 20,
                                                                                                                width: 40,
                                                                                                                child: Marquee(
                                                                                                                  text: '${_profile_screen_controller.story_[index].title}',
                                                                                                                  style: const TextStyle(color: Colors.white, fontFamily: 'PR', fontSize: 14),
                                                                                                                  scrollAxis: Axis.horizontal,
                                                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                  blankSpace: 20.0,
                                                                                                                  velocity: 30.0,
                                                                                                                  pauseAfterRound: const Duration(milliseconds: 100),
                                                                                                                  startPadding: 10.0,
                                                                                                                  accelerationDuration: const Duration(seconds: 1),
                                                                                                                  accelerationCurve: Curves.easeIn,
                                                                                                                  decelerationDuration: const Duration(microseconds: 500),
                                                                                                                  decelerationCurve: Curves.easeOut,
                                                                                                                ),
                                                                                                              )
                                                                                                            : Text(
                                                                                                                '${_profile_screen_controller.story_[index].title}',
                                                                                                                style: const TextStyle(color: Colors.white, fontFamily: 'PR', fontSize: 14),
                                                                                                              ))
                                                                                                      ],
                                                                                                    ),
                                                                                                  );
                                                                                                }),
                                                                                          ),
                                                                                        )
                                                                                      : Container(
                                                                                          alignment: Alignment.center,
                                                                                          margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                                                                                          child: const Text(
                                                                                            'No Stories available',
                                                                                            style: TextStyle(color: Colors.white, fontFamily: 'PR', fontSize: 16),
                                                                                          )))
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
                                                                        )))),
                                                            ),
                                                          ],
                                                        )))),
                                )),
                            bottom: TabBar(
                              indicatorColor: Colors.transparent,
                              controller: _tabController,
                              tabs:
                                  (widget.search_user_data.type == 'Advertiser'
                                      ? _tabs2
                                      : _tabs),
                            )),
                      ];
                    },
                    body: TabBarView(
                      physics: const BouncingScrollPhysics(),
                      // Uncomment the line below and remove DefaultTabController if you want to use a custom TabController
                      controller: _tabController,
                      children: [
                        video_screen(),
                        (widget.search_user_data.type == 'Advertiser'
                            ? brand_logo_screen()
                            : gallery_screen()),
                        (widget.search_user_data.type == 'Advertiser'
                            ? brand_banner_screen()
                            : Rewards_screen()),
                        music_list(),
                        tagged_list(),
                      ],
                    ),
                  ))));
  }

  Widget video_screen() {
    return Container(
      margin: const EdgeInsets.only(top: 10, right: 16, left: 16),
      child: RefreshIndicator(
        color: HexColor(CommonColor.pinkFont),
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          String loginId = await PreferenceManager().getPref(URLConstants.id);

          (widget.search_user_data.socialType == ""
              ? await _search_screen_controller.CreatorgetUserInfo_Email(
                  UserId: widget.search_user_data.id!)
              : await _search_screen_controller.getUserInfo_social(
                  UserId: widget.search_user_data.id!));
          await _search_screen_controller.compare_data();
          await _profile_screen_controller.get_video_list(
              context: context,
              user_id: widget.search_user_data.id!,
              login_user_id: loginId);
        },
        child: SingleChildScrollView(
            child: Obx(() => (_profile_screen_controller.isvideoLoading.value ==
                    true
                ? const Center(child: LoaderPage())
                : (_profile_screen_controller.videoModelList!.error == false
                    ? StaggeredGridView.countBuilder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 4,
                        staggeredTileBuilder: (int index) =>
                            StaggeredTile.count(2, index.isEven ? 3 : 2),
                        mainAxisSpacing: 4.0,
                        crossAxisSpacing: 4.0,
                        //itemCount: imgFile_list.length,
                        itemCount: _profile_screen_controller
                            .videoModelList!.data!.length,
                        itemBuilder: (BuildContext context, int index) =>
                            ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: GestureDetector(
                            onTap: () {
                              print('data');
                              // Get.to(VideoViewer(
                              //   url: videoModelList!
                              //       .data![index]
                              //       .uploadVideo!,
                              // ));
                              Get.to(VideoPostScreen(
                                videomodel:
                                    _profile_screen_controller.videoModelList!,
                                index_: index,
                              ));
                            },
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
                                        videomodel: _profile_screen_controller
                                            .videoModelList!,
                                        index_: index,
                                      ));
                                    },
                                    child: (_profile_screen_controller
                                            .videoModelList!
                                            .data![index]
                                            .coverImage!
                                            .isEmpty
                                        ? Image.asset(
                                            "assets/images/Funky_App_Icon.png",
                                            fit: BoxFit.fill,
                                          )
                                        : Image.network(
                                            "${URLConstants.base_data_url}coverImage/${_profile_screen_controller.videoModelList!.data![index].coverImage}",
                                            fit: BoxFit.cover,
                                          )),
                                  ),
                                ),
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
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Container(
                            margin: const EdgeInsets.only(top: 50),
                            child: Text(
                                "${_profile_screen_controller.videoModelList!.message}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'PR')),
                          ),
                        ),
                      ))))),
      ),
    );
  }

  Widget brand_logo_screen() {
    return Container(
      margin: const EdgeInsets.only(top: 10, right: 16, left: 16),
      child: RefreshIndicator(
        color: HexColor(CommonColor.pinkFont),
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          String idUser = await PreferenceManager().getPref(URLConstants.id);

          await _profile_screen_controller.get_brand_logo(
              context: context, user_id: widget.search_user_data.id!);
        },
        child: SingleChildScrollView(
            child: Obx(() =>
                (_profile_screen_controller.isBrandLogoLoading.value == true
                    ? const Center(child: LoaderPage())
                    : (_profile_screen_controller.brandLogoList!.error == false
                        ? StaggeredGridView.countBuilder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 4,
                            staggeredTileBuilder: (int index) =>
                                StaggeredTile.count(2, index.isEven ? 3 : 2),
                            mainAxisSpacing: 4.0,
                            crossAxisSpacing: 4.0,
                            itemCount: _profile_screen_controller
                                .brandLogoList!.data!.length,
                            itemBuilder: (context, index) => ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: SizedBox(
                                height: 120.0,
                                // width: 120.0,
                                child: (_profile_screen_controller
                                            .isBrandLogoLoading.value ==
                                        true
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
                                                      .brandLogoList!
                                                      .data![index]
                                                      .logo!
                                                      .isEmpty
                                                  ? Image.asset(AssetUtils.logo)
                                                  : FadeInImage.assetNetwork(
                                                      fit: BoxFit.cover,
                                                      image:
                                                          "${URLConstants.base_data_url}images/${_profile_screen_controller.brandLogoList!.data![index].logo}",
                                                      placeholder:
                                                          'assets/images/Funky_App_Icon.png',
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
                                child: Text(
                                    "${_profile_screen_controller.brandLogoList!.message}",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'PR')),
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

          await _profile_screen_controller.get_banner_list(
              context: context, user_id: widget.search_user_data.id!);
        },
        child: SingleChildScrollView(
            child: Obx(
                () => (_profile_screen_controller.isBannerLoading.value == true
                    ? const Center(child: LoaderPage())
                    : (_profile_screen_controller.bannerGetList!.error == false
                        ? StaggeredGridView.countBuilder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 4,
                            staggeredTileBuilder: (int index) =>
                                StaggeredTile.count(2, index.isEven ? 3 : 2),
                            mainAxisSpacing: 4.0,
                            crossAxisSpacing: 4.0,
                            itemCount: _profile_screen_controller
                                .bannerGetList!.data!.length,
                            itemBuilder: (context, index) => ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: SizedBox(
                                height: 120.0,
                                // width: 120.0,
                                child: (_profile_screen_controller
                                            .isBannerLoading.value ==
                                        true
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
                                                      .bannerGetList!
                                                      .data![index]
                                                      .logo!
                                                      .isEmpty
                                                  ? Image.asset(
                                                      'assets/images/Funky_App_Icon.png',
                                                      fit: BoxFit.cover,
                                                    )
                                                  : FadeInImage.assetNetwork(
                                                      fit: BoxFit.cover,
                                                      image:
                                                          "${URLConstants.base_data_url}images/${_profile_screen_controller.bannerGetList!.data![index].logo}",
                                                      placeholder:
                                                          'assets/images/Funky_App_Icon.png',
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
                                child: Text(
                                    "${_profile_screen_controller.bannerGetList!.message}",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'PR')),
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
              context: context,
              user_id: widget.search_user_data.id!,
              login_user_id: idUser);
        },
        child: SingleChildScrollView(
            child: (_profile_screen_controller.ispostLoading.value == true
                ? const Center(child: LoaderPage())
                : (_profile_screen_controller.galleryModelList!.error == false
                    ? StaggeredGridView.countBuilder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 4,
                        staggeredTileBuilder: (int index) =>
                            StaggeredTile.count(2, index.isEven ? 3 : 2),
                        mainAxisSpacing: 4.0,
                        crossAxisSpacing: 4.0,
                        itemCount: _profile_screen_controller
                            .galleryModelList!.data!.length,
                        itemBuilder: (context, index) => ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: SizedBox(
                            height: 120.0,
                            // width: 120.0,
                            child: (_profile_screen_controller
                                        .ispostLoading.value ==
                                    true
                                ? CircularProgressIndicator(
                                    color: HexColor(CommonColor.pinkFont),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      Get.to(ImagePostScreen(
                                        imageListModel:
                                            _profile_screen_controller
                                                .galleryModelList!,
                                        index_: index,
                                      ));
                                    },
                                    child: Container(
                                      color: Colors.black,
                                      child: (_profile_screen_controller
                                                  .galleryModelList!
                                                  .data![index]
                                                  .postImage!
                                                  .isEmpty
                                              ? Image.asset(AssetUtils.logo)
                                              : FadeInImage.assetNetwork(
                                                  fit: BoxFit.cover,
                                                  image:
                                                      "${URLConstants.base_data_url}images/${_profile_screen_controller.galleryModelList!.data![index].postImage}",
                                                  placeholder:
                                                      'assets/images/Funky_App_Icon.png',
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
                            child: Text(
                                "${_profile_screen_controller.galleryModelList!.message}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'PR')),
                          ),
                        ),
                      )))),
      ),
    );
  }

  Widget tagged_list() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: (_profile_screen_controller.isTaggedLoading.value == true
            ? const LoaderPage()
            : (_profile_screen_controller.taggedListModel!.error == false
                ? ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    itemCount: _profile_screen_controller
                        .taggedListModel!.tagList!.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          print(_profile_screen_controller
                              .taggedListModel!.tagList![index].id);
                          Get.to(TaggedPostScreen(
                            tagged_id: _profile_screen_controller
                                .taggedListModel!.tagList![index].id,
                            tagged_username: _profile_screen_controller
                                .taggedListModel!.tagList![index].userName,
                            user_id: widget.search_user_data.id!,
                          ));
                        },
                        child: ListTile(
                          visualDensity:
                              const VisualDensity(vertical: 4, horizontal: 4),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: SizedBox(
                                height: 60,
                                width: 60,
                                child: (_profile_screen_controller
                                        .taggedListModel!
                                        .tagList![index]
                                        .image!
                                        .isNotEmpty
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
                              style: const TextStyle(
                                  fontFamily: 'PM',
                                  fontSize: 15,
                                  color: Colors.white),
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
                        child: Text(
                            "${_profile_screen_controller.taggedListModel!.message}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'PR')),
                      ),
                    ),
                  ))));
  }

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
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 25),
                      child: Text(
                        'Funky Music',
                        style: TextStyle(
                            fontFamily: 'PR',
                            fontSize: 18,
                            color: HexColor(CommonColor.pinkFont)),
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 25),
                      child: Text(
                        'Purchase Music',
                        style: TextStyle(
                            fontFamily: 'PR',
                            fontSize: 18,
                            color: HexColor(CommonColor.pinkFont)),
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
                              itemCount: _profile_screen_controller
                                  .musicList!.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Music_player2(
                                  music_url: _profile_screen_controller
                                      .musicList!.data![index].musicFile!,
                                  title: _profile_screen_controller
                                      .musicList!.data![index].songName!,
                                  artist_name: _profile_screen_controller
                                      .musicList!.data![index].artistName!,
                                );
                              },
                            )
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Container(
                                  margin: const EdgeInsets.only(top: 50),
                                  child: Text(
                                      "${_profile_screen_controller.musicList!.message}",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'PR')),
                                ),
                              ),
                            ))),
                )
              : Obx(
                  () => (_profile_screen_controller
                              .ispurchaseMusicLoading.value ==
                          true
                      ? const Center(
                          child: LoaderPage(),
                        )
                      : (_profile_screen_controller
                                  .getPurchaseMusicList!.error ==
                              false
                          ? ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(bottom: 100),
                              itemCount: _profile_screen_controller
                                  .getPurchaseMusicList!.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Music_player2(
                                  music_url: _profile_screen_controller
                                      .getPurchaseMusicList!
                                      .data![index]
                                      .musicFile!,
                                  title: _profile_screen_controller
                                      .getPurchaseMusicList!
                                      .data![index]
                                      .songName!,
                                  artist_name: _profile_screen_controller
                                      .getPurchaseMusicList!
                                      .data![index]
                                      .artistName!,
                                );
                              },
                            )
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Container(
                                  margin: const EdgeInsets.only(top: 50),
                                  child: Text(
                                      "${_profile_screen_controller.getPurchaseMusicList!.message}",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'PR')),
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
      child: (_settings_screen_controller.isRewardLoading.value == true
          ? const Center(
              child: LoaderPage(),
            )
          : (_settings_screen_controller.getRewardModel!.error == true
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 50),
                      child: Text(
                          "${_settings_screen_controller.getRewardModel!.message}",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'PR')),
                    ),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: _settings_screen_controller
                      .getRewardModel!.rewardList!.length,
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
                            style: const TextStyle(
                                fontSize: 14,
                                fontFamily: 'PR',
                                color: Colors.white),
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
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'PR',
                                    color: Colors.pink),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            // height: 1,
                            color:
                                HexColor(CommonColor.pinkFont).withOpacity(0.7),
                            height: 0.5,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ],
                      ),
                    );
                  },
                ))),
    );
  }
}
