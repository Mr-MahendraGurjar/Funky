import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:funky_new/homepage/ui/post_image_commet_scren.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:readmore/readmore.dart';
import 'package:share_plus/share_plus.dart';

import '../../Utils/App_utils.dart';
import '../../Utils/asset_utils.dart';
import '../../Utils/colorUtils.dart';
import '../../Utils/toaster_widget.dart';
import '../../news_feed/heart_animation_widget.dart';
import '../../search_screen/search__screen_controller.dart';
import '../../search_screen/search_screen_user_profile.dart';
import '../../settings/controller.dart';
import '../../settings/report_video/report_problem.dart';
import '../../sharePreference.dart';
import '../controller/bottom_drawer.dart';
import '../controller/homepage_controller.dart';
import '../model/GetPostLikeCount.dart';
import '../model/PostRewardCoinModel.dart';
import 'common_video_class.dart';

class ImageWidget extends StatefulWidget {
  final String useerName;
  final String Imageurl;
  final bool liked_post;
  final String SocialProfileUrl;
  final String ProfileUrl;
  final String description;
  var imagemodel;
  final String image_id;
  String image_like_count;
  String image_like_status;

  ImageWidget(
      {super.key,
      required this.useerName,
      required this.Imageurl,
      required this.ProfileUrl,
      required this.description,
      required this.SocialProfileUrl,
      required this.image_id,
      required this.image_like_count,
      required this.image_like_status,
      required this.imagemodel,
      required this.liked_post});

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  final bool _onTouch = false;
  Timer? _timer;
  bool isClicked = false; // boolean that states if the button is pressed or not

  bool isLiked = false;
  bool isHeartAnimating = false;

  final HomepageController homepageController =
      Get.put(HomepageController(), tag: HomepageController().toString());

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _visible = !_visible;
      });
    });
    super.initState();
  }

  final int _currentPage = 0;
  String dropdownvalue = 'Apple';

  final Settings_screen_controller _settings_screen_controller = Get.put(
      Settings_screen_controller(),
      tag: Settings_screen_controller().toString());

  final Search_screen_controller _search_screen_controller = Get.put(
      Search_screen_controller(),
      tag: Search_screen_controller().toString());

  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        // extendBodyBehindAppBar: true,

        body: GestureDetector(
          onDoubleTap: () async {
            setState(() {
              isLiked = true;
              isHeartAnimating = true;
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                // margin: const EdgeInsets.symmetric(vertical: 100),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: (widget.Imageurl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl:
                            'http://foxyserver.com/funky/images/${widget.Imageurl}',
                        placeholder: (context, url) => Center(
                          child: Container(
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
                                      backgroundColor:
                                          HexColor(CommonColor.pinkFont),
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
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
                              ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        fit: BoxFit.fitWidth,
                      )
                    : Image.asset(AssetUtils.logo)),
              ),

              Opacity(
                opacity: isHeartAnimating ? 1 : 0,
                child: HeartAnimationWidget(
                  isAnimating: isHeartAnimating,
                  duration: const Duration(milliseconds: 900),
                  onEnd: () {
                    setState(() {
                      isHeartAnimating = false;
                    });
                  },
                  child: Icon(
                    Icons.favorite,
                    color: HexColor(CommonColor.pinkFont),
                    size: 100,
                  ),
                ),
              ),

              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      HexColor("#000000").withOpacity(0.9),
                      HexColor("#000000").withOpacity(0.3),
                      HexColor("#000000").withOpacity(0),
                      HexColor("#000000").withOpacity(0),
                      HexColor("#000000").withOpacity(0),
                      HexColor("#000000").withOpacity(0),
                      HexColor("#000000").withOpacity(0),
                      HexColor("#000000").withOpacity(0),
                      HexColor("#000000").withOpacity(0),
                      HexColor("#000000").withOpacity(0),
                      HexColor("#000000").withOpacity(0.3),
                      HexColor("#000000").withOpacity(0.9),
                    ],
                  ),
                ),
              ),

              // Container(
              //   decoration: BoxDecoration(
              //     color: Colors.red,
              //     gradient: LinearGradient(
              //       begin: Alignment.topCenter,
              //       end: Alignment.bottomCenter,
              //       // stops: [0.1, 0.5, 0.7, 0.9],
              //       colors: [
              //         HexColor("#000000"),
              //         HexColor("#000000").withOpacity(0.7),
              //         HexColor("#000000").withOpacity(0.3),
              //         Colors.transparent
              //       ],
              //     ),
              //   ),
              //   alignment: Alignment.topCenter,
              //   height: MediaQuery.of(context).size.height/5,
              // ),
              Align(
                alignment: Alignment.bottomLeft,
                child: SizedBox(
                  child: Container(
                    // color: Colors.red,
                    margin: EdgeInsets.only(
                        bottom: (widget.liked_post == false ? 100 : 20),
                        left: 21),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Align(
                          alignment: Alignment.bottomRight,
                          child: SizedBox(
                            child: Container(
                              color: Colors.transparent,
                              // width: 50,
                              margin: const EdgeInsets.only(
                                  bottom: 0, right: 21, left: 0.0),
                              alignment: Alignment.bottomRight,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  (widget.liked_post == false
                                      ? (widget.imagemodel.user!.type ==
                                              "Advertiser"
                                          ? GestureDetector(
                                              onTap: () {
                                                Get.to(SearchUserProfile(
                                                  // quickBlox_id: qb_user!.id!,
                                                  quickBlox_id: "0",
                                                  // UserId: _search_screen_controller
                                                  //     .searchlistModel!.data![index].id!,
                                                  search_user_data:
                                                      widget.imagemodel.user!,
                                                ));
                                              },
                                              child: AnimatedOpacity(
                                                opacity: _visible ? 0.0 : 1.0,
                                                duration: const Duration(
                                                    milliseconds: 500),
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                      color: HexColor(
                                                              CommonColor
                                                                  .bloodRed)
                                                          .withOpacity(0.85),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  // width: 20,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      80,
                                                  child: Row(
                                                    children: [
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Image.asset(
                                                        AssetUtils.paper_plane,
                                                        color: Colors.white,
                                                        height: 20,
                                                        width: 20,
                                                      ),
                                                      const SizedBox(
                                                        width: 20,
                                                      ),
                                                      const Text(
                                                        'View Profile',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.white,
                                                            fontFamily: 'PR'),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          : (widget.imagemodel.advertiser!.logo!
                                                  .isNotEmpty
                                              ? Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      5,
                                                  // color: Colors.white,
                                                  margin: const EdgeInsets.only(
                                                      left: 0, bottom: 0),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      100,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Image.network(
                                                      '${URLConstants.base_data_url}images/${widget.imagemodel.advertiser!.logo}',
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox.shrink()))
                                      : const SizedBox.shrink()),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      IconButton(
                                          visualDensity:
                                              const VisualDensity(vertical: -4),
                                          padding:
                                              const EdgeInsets.only(left: 0.0),
                                          icon: Image.asset(
                                            AssetUtils.like_icon_filled,
                                            color: (widget.image_like_status ==
                                                    'false'
                                                ? Colors.white
                                                : HexColor(
                                                    CommonColor.pinkFont)),
                                            scale: 3,
                                          ),
                                          onPressed: () async {
                                            await homepageController.PostLikeUnlikeApi(
                                                context: context,
                                                post_id: widget.image_id,
                                                post_id_type:
                                                    (widget.image_like_status ==
                                                            "true"
                                                        ? 'unliked'
                                                        : 'liked'),
                                                post_likeStatus:
                                                    (widget.image_like_status ==
                                                            "true"
                                                        ? 'false'
                                                        : 'true'));

                                            if (homepageController
                                                    .postLikeUnlikeModel!
                                                    .error ==
                                                false) {
                                              print(
                                                  "mmmmm${widget.image_like_count}");
                                              if (widget.image_like_status ==
                                                  "false") {
                                                setState(() {
                                                  widget.image_like_status =
                                                      homepageController
                                                          .postLikeUnlikeModel!
                                                          .user![0]
                                                          .likeStatus!;

                                                  widget.image_like_count =
                                                      homepageController
                                                          .postLikeUnlikeModel!
                                                          .user![0]
                                                          .likes!;
                                                });
                                              } else {
                                                setState(() {
                                                  widget.image_like_status =
                                                      'false';

                                                  widget.image_like_count =
                                                      homepageController
                                                          .postLikeUnlikeModel!
                                                          .user![0]
                                                          .likes!;
                                                });
                                              }
                                              // setState(() {
                                              //   widget.video_like_count =
                                              //       homepageController
                                              //           .postLikeUnlikeModel!
                                              //           .user![0]
                                              //           .likes!;
                                              //
                                              //   widget.video_like_status =
                                              //       homepageController
                                              //           .postLikeUnlikeModel!
                                              //           .user![0]
                                              //           .likeStatus!;
                                              // });
                                              print(
                                                  "mmmmm${widget.image_like_count}");
                                            }
                                          }),
                                      GestureDetector(
                                        onTap: () async {
                                          await homepageController
                                              .get_post_like_count(
                                                  post_id:
                                                      widget.imagemodel.iD!,
                                                  post_user_id: widget
                                                      .imagemodel.user!.id!);

                                          await selectTowerBottomSheet(
                                              context: context,
                                              data_like_post: homepageController
                                                  .getPostLikeCount!,
                                              like_numebers:
                                                  widget.imagemodel.likes!);
                                        },
                                        child: Container(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 3.0,
                                                left: 12,
                                                right: 12,
                                                bottom: 12),
                                            child: Text(widget.image_like_count,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontFamily: 'PR')),
                                          ),
                                        ),
                                      ),
                                      (widget.imagemodel.enableComment == 'true'
                                          ? Column(
                                              children: [
                                                IconButton(
                                                  visualDensity:
                                                      const VisualDensity(
                                                          vertical: -4),
                                                  iconSize: 30.0,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 0.0),
                                                  icon: Image.asset(
                                                    AssetUtils.comment_icon,
                                                    color: HexColor('#8AFC8D'),
                                                    scale: 3,
                                                  ),
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                PostImageCommentScreen(
                                                                  PostID: widget
                                                                      .image_id,
                                                                )));
                                                    // setState(() {
                                                    //   // _myPage.jumpToPage(0);
                                                    // });
                                                  },
                                                ),
                                                Container(
                                                  child: Text(
                                                      widget.imagemodel
                                                          .commentCount!,
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12,
                                                          fontFamily: 'PR')),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            )
                                          : const SizedBox.shrink()),
                                      IconButton(
                                        visualDensity:
                                            const VisualDensity(vertical: 0),
                                        padding:
                                            const EdgeInsets.only(left: 0.0),
                                        icon: (widget.liked_post == false
                                            ? (widget.imagemodel.advertiser!
                                                    .logo!.isNotEmpty
                                                ? Image.asset(
                                                    AssetUtils
                                                        .share_icon_reward,
                                                    color: HexColor('#66E4F2'),
                                                    scale: 2,
                                                  )
                                                : Image.asset(
                                                    AssetUtils
                                                        .share_icon_simple,
                                                    color: HexColor('#66E4F2'),
                                                    scale: 2,
                                                  ))
                                            : Image.asset(
                                                AssetUtils.share_icon_simple,
                                                color: HexColor('#66E4F2'),
                                                scale: 2,
                                              )),
                                        onPressed: () {
                                          urlFileShare();
                                          setState(() {
                                            // _myPage.jumpToPage(0);
                                          });
                                        },
                                      ),
                                      (widget.imagemodel.user!.type ==
                                              "Advertiser"
                                          ? const SizedBox.shrink()
                                          : Column(
                                              children: [
                                                IconButton(
                                                  visualDensity:
                                                      const VisualDensity(
                                                          vertical: -4),
                                                  iconSize: 30.0,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 0.0),
                                                  icon: Image.asset(
                                                    AssetUtils.reward_icon,
                                                    color: HexColor('#F32E82'),
                                                    scale: 3,
                                                  ),
                                                  onPressed: () async {
                                                    String idUser =
                                                        await PreferenceManager()
                                                            .getPref(
                                                                URLConstants
                                                                    .id);

                                                    await _settings_screen_controller
                                                        .getRewardList(
                                                            userId: idUser);

                                                    _scaleDialog(
                                                        context: context);
                                                    setState(() {
                                                      // _myPage.jumpToPage(0);
                                                    });
                                                  },
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  child: Text(
                                                      widget.imagemodel
                                                          .rewardCount!,
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12,
                                                          fontFamily: 'PR')),
                                                ),
                                              ],
                                            )),
                                      IconButton(
                                        visualDensity:
                                            const VisualDensity(vertical: 0),
                                        padding:
                                            const EdgeInsets.only(left: 0.0),
                                        icon: Image.asset(
                                          AssetUtils.music_icon,
                                          color: HexColor('#F5C93A'),
                                          scale: 3,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            // _myPage.jumpToPage(0);
                                          });
                                        },
                                      ),
                                      DropdownButtonHideUnderline(
                                        child: DropdownButton2(
                                          // isExpanded: true,

                                          customButton: const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5.0),
                                            child: Icon(
                                              Icons.more_vert,
                                              color: Colors.white,
                                              size: 25,
                                            ),
                                          ),
                                          items: [
                                            DropdownMenuItem(
                                                value: "Apple",
                                                onTap: () {
                                                  // PostID: widget.video_id,
                                                  // post_user_id: widget
                                                  //     .videoListModel!
                                                  //     .user!
                                                  //     .id,
                                                  // print("data");
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ReportProblem(
                                                                receiver_id: widget
                                                                    .imagemodel
                                                                    .user!
                                                                    .id!,
                                                                type: 'post',
                                                                type_id: widget
                                                                    .image_id,
                                                              )));
                                                  // Get.to(ReportProblem(
                                                  //   receiver_id: widget
                                                  //       .videoListModel!
                                                  //       .user!
                                                  //       .id!,
                                                  //   type: 'post',
                                                  //   type_id: widget.video_id,
                                                  // ));
                                                },
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    print("datssa");
                                                    await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ReportProblem(
                                                                  receiver_id:
                                                                      widget
                                                                          .imagemodel
                                                                          .user!
                                                                          .id!,
                                                                  type: 'post',
                                                                  type_id: widget
                                                                      .image_id,
                                                                )));
                                                  },
                                                  child: const Text(
                                                      "Report image",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                          fontFamily: 'PR')),
                                                ))
                                          ],
                                          value: dropdownvalue,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'PR',
                                            color: Colors.white,
                                          ),
                                          alignment: Alignment.centerLeft,
                                          onChanged: (value) {},

                                          // iconSize: 25,
                                          // iconEnabledColor: Color(0xff007DEF),
                                          // iconDisabledColor: Color(0xff007DEF),
                                          // buttonHeight: 50,
                                          // buttonWidth: 100,
                                          // enableFeedback: true,
                                          // buttonPadding: const EdgeInsets.only(left: 15, right: 15),
                                          // buttonDecoration: BoxDecoration(
                                          //     borderRadius: BorderRadius.circular(10), color: Colors.transparent),
                                          // buttonElevation: 0,
                                          // itemHeight: 30,
                                          // itemPadding: const EdgeInsets.only(left: 14, right: 14),
                                          // dropdownMaxHeight: 200,
                                          // dropdownWidth: 150,
                                          // dropdownPadding: null,
                                          // dropdownDecoration: BoxDecoration(
                                          //   borderRadius: BorderRadius.circular(24),
                                          //   border: Border.all(width: 1, color: Colors.white),
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
                                          // scrollbarRadius: const Radius.circular(40),
                                          // scrollbarThickness: 6,
                                          // scrollbarAlwaysShow: true,
                                          // offset: const Offset(-10, -8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Container(
                              margin: const EdgeInsets.only(
                                  left: 15.0, right: 15.0),
                              child: Divider(
                                color: HexColor('#F32E82'),
                                height: 10,
                              )),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        ListTile(
                          visualDensity:
                              const VisualDensity(vertical: 4, horizontal: -4),
                          // tileColor: Colors.white,
                          leading: GestureDetector(
                            onTap: () {
                              Get.to(SearchUserProfile(
                                // quickBlox_id: qb_user!.id!,
                                quickBlox_id: "0",
                                // UserId: _search_screen_controller
                                //     .searchlistModel!.data![index].id!,
                                search_user_data: widget.imagemodel.user!,
                              ));
                            },
                            child: (widget.ProfileUrl.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: SizedBox(
                                      height: 50,
                                      width: 50,
                                      child: Image.network(
                                        "http://foxyserver.com/funky/images/${widget.ProfileUrl}",
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  )
                                : (widget.SocialProfileUrl.isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          color: Colors.red,
                                          child: Image.network(
                                            widget.SocialProfileUrl,
                                          ),
                                        ),
                                      )
                                    : SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: IconButton(
                                          icon: Image.asset(
                                            AssetUtils.user_icon3,
                                            fit: BoxFit.fill,
                                          ),
                                          onPressed: () {},
                                        )))),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 120,
                                        child: Text(
                                          widget.useerName,
                                          style: TextStyle(
                                              color: HexColor('#D4D4D4'),
                                              fontFamily: "PB",
                                              fontSize: 14),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          await _search_screen_controller.Follow_unfollow_api(
                                              follow_unfollow: (widget
                                                          .imagemodel
                                                          .user
                                                          .userFollowUnfollow ==
                                                      'follow'
                                                  ? 'unfollow'
                                                  : (widget.imagemodel.user
                                                              .userFollowUnfollow ==
                                                          'unfollow'
                                                      ? 'follow'
                                                      : (widget.imagemodel.user
                                                                  .userFollowUnfollow ==
                                                              'followback'
                                                          ? 'follow'
                                                          : 'follow'))),
                                              user_id:
                                                  widget.imagemodel.user.id,
                                              user_social: widget
                                                  .imagemodel.user.socialType,
                                              context: context);
                                          setState(() {
                                            homepageController
                                                .getAllVideosList();
                                          });
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 0),
                                          height: 30,
                                          width: 90,
                                          decoration: BoxDecoration(
                                              color: HexColor(
                                                  CommonColor.pinkFont),
                                              //   color: (widget
                                              //       .videoListModel
                                              //       .user
                                              //       .userFollowUnfollow ==
                                              //       'follow'
                                              //       ? Colors.white
                                              //       : (widget
                                              //       .videoListModel
                                              //       .user
                                              //       .userFollowUnfollow ==
                                              //       'unfollow'
                                              //       ? HexColor(
                                              //       CommonColor
                                              //           .pinkFont)
                                              //       : (widget
                                              //       .videoListModel
                                              //       .user
                                              //       .userFollowUnfollow ==
                                              //       'followback'
                                              //       ? HexColor(
                                              //       CommonColor
                                              //           .pinkFont)
                                              //       : Colors
                                              //       .white))),
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: Container(
                                              alignment: Alignment.center,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 0,
                                                      horizontal: 5),
                                              child: Obx(() => (homepageController
                                                          .isVideoLoading
                                                          .value ==
                                                      true
                                                  ? const SizedBox(
                                                      height: 15,
                                                      width: 15,
                                                      child:
                                                          CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        color: Colors.white,
                                                      ))
                                                  : Text(
                                                      (widget.imagemodel.user
                                                                  .userFollowUnfollow ==
                                                              'follow'
                                                          ? 'Following'
                                                          : (widget
                                                                      .imagemodel
                                                                      .user
                                                                      .userFollowUnfollow ==
                                                                  'unfollow'
                                                              ? 'Follow'
                                                              : (widget
                                                                          .imagemodel
                                                                          .user
                                                                          .userFollowUnfollow ==
                                                                      'followback'
                                                                  ? 'Follow back'
                                                                  : 'Follow'))),
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          //   color: (widget.videoListModel.user.userFollowUnfollow ==
                                                          //       'follow'
                                                          //       ? HexColor(CommonColor
                                                          //       .pinkFont)
                                                          //       : (widget.videoListModel.user.userFollowUnfollow == 'unfollow'
                                                          //       ? Colors.white
                                                          //       : (widget.videoListModel.user.userFollowUnfollow == 'followback' ? Colors.white : Colors.white))),
                                                          fontFamily: 'PR',
                                                          fontSize: 14),
                                                    )))),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: ReadMoreText(
                                      widget.description,
                                      trimLines: 2,
                                      colorClickableText: Colors.grey,
                                      trimMode: TrimMode.Line,
                                      trimCollapsedText: 'Show more',
                                      trimExpandedText: 'Show less',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontFamily: "PR",
                                          fontSize: 12),
                                      moreStyle: const TextStyle(
                                          color: Colors.grey,
                                          fontFamily: "PR",
                                          fontSize: 10),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(5),
                          bottomLeft: Radius.circular(5)),
                      color: HexColor('#C12265')),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 10),
                    child: Text(
                      'I AM here',
                      style: TextStyle(
                          color: HexColor('#D4D4D4'),
                          fontFamily: "PR",
                          fontSize: 14),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  selectTowerBottomSheet(
      {required BuildContext context,
      required GetPostLikeCount data_like_post,
      required String like_numebers}) {
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
        return Bottom_Drawer(
          number_like: like_numebers,
          data_like_post: data_like_post,
        );
      },
    );
  }

  Coins? _coins = Coins.bronze;
  double _value = 10;
  bool world_select = false;
  bool custom_select = false;
  TextEditingController custom_coin_controller = TextEditingController();

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
                                (_settings_screen_controller
                                            .isRewardLoading.value ==
                                        true
                                    ? SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: HexColor(CommonColor.pinkFont),
                                        ))
                                    : Text(
                                        "${_settings_screen_controller.coin_left} Funky coins",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'PB',
                                            color: Colors.white),
                                      )),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 5),
                                  color: HexColor(CommonColor.pinkFont)
                                      .withOpacity(0.7),
                                  height: 1,
                                  width: MediaQuery.of(context).size.width,
                                ),
                                Container(
                                  margin: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    // gradient: LinearGradient(
                                    //   begin: Alignment.centerLeft,
                                    //   end: Alignment.centerRight,
                                    //   colors: [
                                    //     HexColor("#36393E").withOpacity(1),
                                    //     HexColor("#020204").withOpacity(1),
                                    //   ],
                                    // ),
                                    border: Border.all(
                                        color: HexColor(
                                            CommonColor.pinkFont_light),
                                        width: 0.5),
                                  ),
                                  child: ExpansionTile(
                                    iconColor:
                                        HexColor(CommonColor.pinkFont_light),
                                    collapsedIconColor:
                                        HexColor(CommonColor.pinkFont_light),
                                    // initiallyExpanded: true,
                                    title: Container(
                                      child: const Padding(
                                        padding: EdgeInsets.only(
                                            left: 0,
                                            top: 15,
                                            right: 15,
                                            bottom: 15),
                                        child: Text('Select Coin',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontFamily: 'PR')),
                                      ),
                                    ),
                                    children: <Widget>[
                                      ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          visualDensity: const VisualDensity(
                                              vertical: -4, horizontal: -4),
                                          title: const Text('Bronze = 0.5 FC',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontFamily: 'PR')),
                                          leading: Theme(
                                              data: ThemeData(
                                                  unselectedWidgetColor:
                                                      Colors.white),
                                              child: Radio<Coins>(
                                                activeColor: HexColor(
                                                    CommonColor.pinkFont),
                                                value: Coins.bronze,
                                                groupValue: _coins,
                                                onChanged:
                                                    (Coins? value) async {
                                                  _settings_screen_controller
                                                      .coin_left = double.parse(
                                                          _settings_screen_controller
                                                              .getRewardModel!
                                                              .totalReward!) -
                                                      0.5;
                                                  print(
                                                      _settings_screen_controller
                                                          .coin_left);
                                                  if (_settings_screen_controller
                                                      .coin_left!.isNegative) {
                                                    CommonWidget().showToaster(
                                                        msg:
                                                            'Not Enough coins');
                                                  } else {
                                                    setState(() {
                                                      world_select = false;
                                                      custom_select = false;
                                                      _coins = value;
                                                    });
                                                    print(_coins.toString());
                                                  }

                                                  // await _manage_account_controller
                                                  //     .PostUserSetting(
                                                  //     privacy: "false",
                                                  //     title: 'change_account');
                                                },
                                              ))),
                                      ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          visualDensity: const VisualDensity(
                                              vertical: -4, horizontal: -4),
                                          title: const Text('Silver = 1 FC',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontFamily: 'PR')),
                                          leading: Theme(
                                              data: ThemeData(
                                                  unselectedWidgetColor:
                                                      Colors.white),
                                              child: Radio<Coins>(
                                                activeColor: HexColor(
                                                    CommonColor.pinkFont),
                                                value: Coins.silver,
                                                groupValue: _coins,
                                                onChanged:
                                                    (Coins? value) async {
                                                  _settings_screen_controller
                                                      .coin_left = double.parse(
                                                          _settings_screen_controller
                                                              .getRewardModel!
                                                              .totalReward!) -
                                                      1;
                                                  print(
                                                      _settings_screen_controller
                                                          .coin_left);
                                                  if (_settings_screen_controller
                                                      .coin_left!.isNegative) {
                                                    CommonWidget().showToaster(
                                                        msg:
                                                            'Not Enough coins');
                                                  } else {
                                                    setState(() {
                                                      world_select = false;
                                                      custom_select = false;
                                                      _coins = value;
                                                    });
                                                    print(_coins.toString());
                                                  }
                                                  // await _manage_account_controller
                                                  //     .PostUserSetting(
                                                  //     privacy: "false",
                                                  //     title: 'change_account');
                                                },
                                              ))),
                                      ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          visualDensity: const VisualDensity(
                                              vertical: -4, horizontal: -4),
                                          title: const Text('Gold = 2 FC',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontFamily: 'PR')),
                                          leading: Theme(
                                              data: ThemeData(
                                                  unselectedWidgetColor:
                                                      Colors.white),
                                              child: Radio<Coins>(
                                                activeColor: HexColor(
                                                    CommonColor.pinkFont),
                                                value: Coins.gold,
                                                groupValue: _coins,
                                                onChanged:
                                                    (Coins? value) async {
                                                  _settings_screen_controller
                                                      .coin_left = double.parse(
                                                          _settings_screen_controller
                                                              .getRewardModel!
                                                              .totalReward!) -
                                                      2;
                                                  print(
                                                      _settings_screen_controller
                                                          .coin_left);
                                                  if (_settings_screen_controller
                                                      .coin_left!.isNegative) {
                                                    CommonWidget().showToaster(
                                                        msg:
                                                            'Not Enough coins');
                                                  } else {
                                                    setState(() {
                                                      world_select = false;
                                                      custom_select = false;
                                                      _coins = value;
                                                    });
                                                    print(_coins.toString());
                                                  }
                                                  // await _manage_account_controller
                                                  //     .PostUserSetting(
                                                  //     privacy: "false",
                                                  //     title: 'change_account');
                                                },
                                              ))),
                                      ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          visualDensity: const VisualDensity(
                                              vertical: -4, horizontal: -4),
                                          title: const Text('Diamond = 5 FC',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontFamily: 'PR')),
                                          leading: Theme(
                                              data: ThemeData(
                                                  unselectedWidgetColor:
                                                      Colors.white),
                                              child: Radio<Coins>(
                                                activeColor: HexColor(
                                                    CommonColor.pinkFont),
                                                value: Coins.diamond,
                                                groupValue: _coins,
                                                onChanged:
                                                    (Coins? value) async {
                                                  _settings_screen_controller
                                                      .coin_left = double.parse(
                                                          _settings_screen_controller
                                                              .getRewardModel!
                                                              .totalReward!) -
                                                      5;
                                                  print(
                                                      _settings_screen_controller
                                                          .coin_left);
                                                  if (_settings_screen_controller
                                                      .coin_left!.isNegative) {
                                                    CommonWidget().showToaster(
                                                        msg:
                                                            'Not Enough coins');
                                                  } else {
                                                    setState(() {
                                                      world_select = false;
                                                      custom_select = false;
                                                      _coins = value;
                                                    });
                                                    print(_coins.toString());
                                                  }
                                                  // await _manage_account_controller
                                                  //     .PostUserSetting(
                                                  //     privacy: "false",
                                                  //     title: 'change_account');
                                                },
                                              ))),
                                      ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          visualDensity: const VisualDensity(
                                              vertical: -4, horizontal: -4),
                                          title: const Text(
                                              'World Coin = 10 - 100 FC',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontFamily: 'PR')),
                                          leading: Theme(
                                              data: ThemeData(
                                                  unselectedWidgetColor:
                                                      Colors.white),
                                              child: Radio<Coins>(
                                                activeColor: HexColor(
                                                    CommonColor.pinkFont),
                                                value: Coins.world,
                                                groupValue: _coins,
                                                onChanged:
                                                    (Coins? value) async {
                                                  setState(() {
                                                    _coins = value;
                                                    _settings_screen_controller
                                                            .coin_left =
                                                        double.parse(
                                                            _settings_screen_controller
                                                                .getRewardModel!
                                                                .totalReward!);
                                                    world_select = true;
                                                    custom_select = false;
                                                  });
                                                  print(_coins.toString());

                                                  // await _manage_account_controller
                                                  //     .PostUserSetting(
                                                  //     privacy: "false",
                                                  //     title: 'change_account');
                                                },
                                              ))),
                                      (world_select
                                          ? Theme(
                                              data: ThemeData(
                                                  sliderTheme:
                                                      const SliderThemeData(
                                                showValueIndicator:
                                                    ShowValueIndicator.always,
                                                thumbShape:
                                                    RoundSliderThumbShape(
                                                        enabledThumbRadius:
                                                            5.0),
                                                valueIndicatorShape:
                                                    PaddleSliderValueIndicatorShape(),
                                                valueIndicatorColor:
                                                    Colors.white,
                                                valueIndicatorTextStyle:
                                                    TextStyle(
                                                        color: Colors.white,
                                                        fontFamily: 'PR'),
                                              )),
                                              child: Slider(
                                                min: 10.0,
                                                max: 100.0,
                                                activeColor: HexColor(
                                                    CommonColor.pinkFont),
                                                inactiveColor: Colors.white,
                                                thumbColor: Colors.white,
                                                label: '${_value.round()}',
                                                value: _value,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _value = value;
                                                  });
                                                  print(_value
                                                      .toStringAsFixed(1));
                                                },
                                              ),
                                            )
                                          : const SizedBox.shrink()),
                                      ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          visualDensity: const VisualDensity(
                                              vertical: -4, horizontal: -4),
                                          title: const Text('Custom Coin',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontFamily: 'PR')),
                                          leading: Theme(
                                              data: ThemeData(
                                                  unselectedWidgetColor:
                                                      Colors.white),
                                              child: Radio<Coins>(
                                                activeColor: HexColor(
                                                    CommonColor.pinkFont),
                                                value: Coins.custom,
                                                groupValue: _coins,
                                                onChanged:
                                                    (Coins? value) async {
                                                  setState(() {
                                                    _coins = value;
                                                    _settings_screen_controller
                                                            .coin_left =
                                                        double.parse(
                                                            _settings_screen_controller
                                                                .getRewardModel!
                                                                .totalReward!);
                                                    world_select = false;
                                                    custom_select = true;
                                                  });
                                                  print(_coins.toString());

                                                  // await _manage_account_controller
                                                  //     .PostUserSetting(
                                                  //     privacy: "false",
                                                  //     title: 'change_account');
                                                },
                                              ))),
                                      (custom_select
                                          ? Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 20),
                                              height: 45,
                                              child: TextField(
                                                controller:
                                                    custom_coin_controller,
                                                // controsink_controller,
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontFamily: 'PR',
                                                    color: Colors.white),
                                                decoration:
                                                    const InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 20),
                                                  hintText:
                                                      'Enter Custom coins',
                                                  hintStyle: TextStyle(
                                                      fontSize: 15,
                                                      fontFamily: 'PR',
                                                      color: Colors.white),
                                                  fillColor: Colors.white,
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.white,
                                                        width: 1),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.white,
                                                        width: 1),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
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
                                              ))
                                          : const SizedBox()),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        // update_link_facebook(
                                        //     context: context,
                                        //     facebook_link:
                                        //     _creator_login_screen_controller
                                        //         .facebook_link_controller.text,
                                        //     index: 0);
                                        if (_coins.toString() ==
                                            'Coins.world') {
                                          _settings_screen_controller
                                              .coin_left = double.parse(
                                                  _settings_screen_controller
                                                      .getRewardModel!
                                                      .totalReward!) -
                                              (_value.toDouble());
                                          if (_settings_screen_controller
                                              .coin_left!.isNegative) {
                                            CommonWidget().showToaster(
                                                msg: 'Not Enough coins');
                                          } else {
                                            PostRewardCoinApi(
                                                context: context,
                                                receiver_id:
                                                    widget.imagemodel.user!.id!,
                                                post_id: widget.image_id,
                                                coin_value:
                                                    _value.toStringAsFixed(1));
                                          }
                                        } else if (_coins.toString() ==
                                            'Coins.custom') {
                                          _settings_screen_controller
                                              .coin_left = double.parse(
                                                  _settings_screen_controller
                                                      .getRewardModel!
                                                      .totalReward!) -
                                              double.parse(
                                                  custom_coin_controller.text);
                                          if (_settings_screen_controller
                                              .coin_left!.isNegative) {
                                            CommonWidget().showToaster(
                                                msg: 'Not Enough coins');
                                          } else {
                                            PostRewardCoinApi(
                                                context: context,
                                                receiver_id:
                                                    widget.imagemodel.user!.id!,
                                                post_id: widget.image_id,
                                                coin_value:
                                                    custom_coin_controller
                                                        .text);
                                          }
                                        } else {
                                          PostRewardCoinApi(
                                              context: context,
                                              receiver_id:
                                                  widget.imagemodel.user!.id!,
                                              post_id: widget.image_id,
                                              coin_value: (_coins.toString() ==
                                                      'Coins.bronze'
                                                  ? '0.5'
                                                  : (_coins.toString() ==
                                                          'Coins.silver'
                                                      ? '1'
                                                      : (_coins.toString() ==
                                                              'Coins.gold'
                                                          ? '2'
                                                          : (_coins.toString() ==
                                                                  'Coins.diamond'
                                                              ? '5'
                                                              : (_coins.toString() ==
                                                                      'Coins.world'
                                                                  ? '0.5'
                                                                  : (_coins.toString() ==
                                                                          'Coins.custom'
                                                                      ? '0.5'
                                                                      : '')))))));
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
                                            'Send Coins',
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
                                boxShadow: const [],
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

  RxBool ispostRewardCoinLoading = true.obs;
  postRewardCoinModel? _postRewardCoinModel;

  Future<dynamic> PostRewardCoinApi({
    required BuildContext context,
    required String receiver_id,
    required String post_id,
    required String coin_value,
  }) async {
    debugPrint('0-0-0-0-0-0-0 username');

    String idUser = await PreferenceManager().getPref(URLConstants.id);

    ispostRewardCoinLoading(true);

    Map data = {
      'user_id': idUser,
      'receiver_id': receiver_id,
      'coin_value': coin_value,
      'post_id': post_id
    };
    print(data);
    // String body = json.encode(data);

    var url = (URLConstants.base_url + URLConstants.post_reward_coin);
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
      _postRewardCoinModel = postRewardCoinModel.fromJson(data);
      print(_postRewardCoinModel);
      if (_postRewardCoinModel!.error == false) {
        ispostRewardCoinLoading(false);
        Navigator.pop(context);
        CommonWidget().showToaster(msg: _postRewardCoinModel!.message!);

        // await getNewsFeedCommnets(newsfeedID: news_id, context: context);
      } else {
        ispostRewardCoinLoading(false);
        print('Please try again');
        CommonWidget().showErrorToaster(msg: 'Select Coin first');
      }
    } else {
      print('Please try again');
    }
  }

  Future<void> urlFileShare() async {
    final RenderObject? box = context.findRenderObject();
    if (Platform.isIOS) {
      // var url = 'http://foxyserver.com/funky/images/Funky-logo.png';
      // http.Response response = await http.get(Uri.parse(url));
      //
      // final directory = await getTemporaryDirectory();
      // final path = directory.path;
      // final file = File('$path/image.jpeg');
      // file.writeAsBytes(response.bodyBytes);
      //
      final bytes = await rootBundle.load('assets/images/Funky_app logo.jpg');
      final list = bytes.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/image.jpg').create();
      file.writeAsBytesSync(list);
      await Share.shareFiles(
        [(file.path)],
        mimeTypes: ["image/png"],
        text: "Share and get reward",
      );
      if (widget.imagemodel.advertiser!.logo!.isNotEmpty) {
        await homepageController.PostRewardGet(
            context: context,
            post_type: 'image',
            post_id: widget.imagemodel.iD!);
      }
      // Share.shareFiles[File('$documentDirectory/flutter.png').path,
      //     subject: 'URL File Share',
      //     text: 'Hello, check your share files!',
      //     sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size)];
    } else {
      // Share.share('Hello, check your share files!',
      //     subject: 'URL File Share',
      //     sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }
  }
}
