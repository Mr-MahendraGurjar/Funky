import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:funky_new/Utils/App_utils.dart';
import 'package:funky_new/homepage/ui/post_image_commet_scren.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:marquee/marquee.dart';
import 'package:path_provider/path_provider.dart';
import 'package:readmore/readmore.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

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

class VideoWidget extends StatefulWidget {
  final bool play;
  final bool liked_post;
  final String singerName;
  final String description;
  final String songName;
  final String url;
  final String image_url;
  final String profile_url;
  final String video_id;
  final String comment_count;
  var videoListModel;

  String video_like_count;
  String video_like_status;

  final VoidCallback? onDoubleTap;

  VideoWidget({
    super.key,
    required this.url,
    required this.play,
    required this.singerName,
    required this.songName,
    required this.image_url,
    required this.description,
    required this.video_id,
    required this.video_like_count,
    required this.video_like_status,
    this.onDoubleTap,
    required this.comment_count,
    this.videoListModel,
    required this.profile_url,
    required this.liked_post,
  });

  @override
  VideoWidgetState createState() => VideoWidgetState();
}

enum Coins { bronze, silver, gold, diamond, world, custom }

class VideoWidgetState extends State<VideoWidget> {
  final HomepageController homepageController =
      Get.put(HomepageController(), tag: HomepageController().toString());
  VideoPlayerController? controller_last;

  final bool _onTouch = false;
  Timer? _timer;
  bool isClicked = true; // boolean that states if the button is pressed or not

  @override
  void initState() {
    super.initState();
    print('image urlllllllllllll ${widget.url}');
    print('image video_id ${widget.video_id}');
    print('image video_like_count ${widget.video_like_count}');
    print('image video_like_status ${widget.video_like_status}');
    controller_last = VideoPlayerController.network(
        "${URLConstants.base_data_url}video/${widget.url}");
    print('Video url =>${URLConstants.base_data_url}video/${widget.url}');
    controller_last?.setLooping(true);
    controller_last?.initialize().then((_) {
      setState(() {
        homepageController.Post_view_count(
            context: context, post_id: widget.videoListModel!.iD!);
      });
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _visible = !_visible;
        });
      });
    });
    widget.play ? controller_last?.play() : controller_last?.pause();
  }

  @override
  void dispose() {
    // _timer?.cancel();
    super.dispose();
    controller_last?.pause();
    controller_last?.dispose();
  }

  final int _currentPage = 0;

  // an arbitrary value, this can be whatever you need it to be
  double videoContainerRatio = 0.5;

  double getScale() {
    double videoRatio = controller_last!.value.aspectRatio;

    if (videoRatio < videoContainerRatio) {
      ///for tall videos, we just return the inverse of the controller aspect ratio
      return videoContainerRatio / videoRatio;
    } else {
      ///for wide videos, divide the video AR by the fixed container AR
      ///so that the video does not over scale

      return videoRatio / videoContainerRatio;
    }
  }

  bool isLiked = false;
  bool isHeartAnimating = false;
  String dropdownvalue = 'Apple';
  bool _visible = true;

  final Settings_screen_controller _settings_screen_controller = Get.put(
      Settings_screen_controller(),
      tag: Settings_screen_controller().toString());
  final Search_screen_controller _search_screen_controller = Get.put(
      Search_screen_controller(),
      tag: Search_screen_controller().toString());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          onTap: () {
            setState(() {
              isClicked = isClicked ? false : true;
            });
          },
          onDoubleTap: () async {
            setState(() {
              isLiked = true;
              isHeartAnimating = true;
            });
            if (widget.video_like_status == 'false') {
              await homepageController.PostLikeUnlikeApi(
                  context: context,
                  post_id: widget.video_id,
                  post_id_type: 'liked',
                  post_likeStatus: 'true');

              if (homepageController.postLikeUnlikeModel!.error == false) {
                print("mmmmm${widget.video_like_count}");
                setState(() {
                  widget.video_like_count =
                      homepageController.postLikeUnlikeModel!.user![0].likes!;

                  widget.video_like_status = homepageController
                      .postLikeUnlikeModel!.user![0].likeStatus!;
                });
                print("mmmmm${widget.video_like_count}");
              }
            }
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  print('hello');
                  isClicked = isClicked ? false : true;
                  print(isClicked);
                },
                child: controller_last!.value.isInitialized
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                          child: AspectRatio(
                              aspectRatio: controller_last!.value.aspectRatio,
                              child: VideoPlayer(controller_last!)),
                        ),
                      )
                    : Container(),
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
                        left: 0),
                    child: SingleChildScrollView(
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
                                    bottom: 10, right: 8, left: 0.0),
                                alignment: Alignment.bottomRight,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    (widget.liked_post == false
                                        ? (widget.videoListModel!.user!.type ==
                                                "Advertiser"
                                            ? GestureDetector(
                                                onTap: () async {
                                                  controller_last!.pause();
                                                  await Get.to(
                                                      SearchUserProfile(
                                                    // quickBlox_id: qb_user!.id!,
                                                    quickBlox_id: "0",
                                                    // UserId: _search_screen_controller
                                                    //     .searchlistModel!.data![index].id!,
                                                    search_user_data: widget
                                                        .videoListModel!.user!,
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
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              24),
                                                      border: Border.all(
                                                          width: 1,
                                                          color: Colors.white),
                                                      gradient: LinearGradient(
                                                        begin:
                                                            Alignment.topLeft,
                                                        end: Alignment
                                                            .bottomRight,
                                                        // stops: [0.1, 0.5, 0.7, 0.9],
                                                        colors: [
                                                          HexColor("#000000"),
                                                          HexColor("#C12265"),
                                                          // HexColor("#FFFFFF"),
                                                        ],
                                                      ),
                                                    ),
                                                    // width: 20,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            80,
                                                    child: Row(
                                                      children: [
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Image.asset(
                                                          AssetUtils
                                                              .paper_plane,
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
                                                              color:
                                                                  Colors.white,
                                                              fontFamily: 'PR'),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : (widget
                                                    .videoListModel!
                                                    .advertiser!
                                                    .logo!
                                                    .isNotEmpty
                                                ? Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            5,
                                                    // color: Colors.white,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 0, bottom: 0),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            100,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: Image.network(
                                                        '${URLConstants.base_data_url}images/${widget.videoListModel!.advertiser!.logo}',
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                  )
                                                : const SizedBox.shrink()))
                                        : const SizedBox.shrink()),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        IconButton(
                                            visualDensity: const VisualDensity(
                                                vertical: -4),
                                            padding: const EdgeInsets.only(
                                                left: 0.0),
                                            icon: Image.asset(
                                              AssetUtils.like_icon_filled,
                                              color: (widget
                                                          .video_like_status ==
                                                      'false'
                                                  ? Colors.white
                                                  : HexColor(
                                                      CommonColor.pinkFont)),
                                              scale: 3,
                                            ),
                                            onPressed: () async {
                                              await homepageController
                                                  .PostLikeUnlikeApi(
                                                      context: context,
                                                      post_id: widget.video_id,
                                                      post_id_type:
                                                          (widget.video_like_status ==
                                                                  "true"
                                                              ? 'unliked'
                                                              : 'liked'),
                                                      post_likeStatus:
                                                          (widget.video_like_status ==
                                                                  "true"
                                                              ? 'false'
                                                              : 'true'));

                                              if (homepageController
                                                      .postLikeUnlikeModel!
                                                      .error ==
                                                  false) {
                                                print(
                                                    "mmmmm${widget.video_like_count}");
                                                if (widget.video_like_status ==
                                                    "false") {
                                                  setState(() {
                                                    widget.video_like_status =
                                                        homepageController
                                                            .postLikeUnlikeModel!
                                                            .user![0]
                                                            .likeStatus!;

                                                    widget.video_like_count =
                                                        homepageController
                                                            .postLikeUnlikeModel!
                                                            .user![0]
                                                            .likes!;
                                                  });
                                                } else {
                                                  setState(() {
                                                    widget.video_like_status =
                                                        'false';

                                                    widget.video_like_count =
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
                                                    "mmmmm${widget.video_like_count}");
                                              }
                                            }),
                                        GestureDetector(
                                          onTap: () async {
                                            await controller_last!.pause();

                                            await homepageController
                                                .get_post_like_count(
                                                    post_id: widget
                                                        .videoListModel!.iD!,
                                                    post_user_id: widget
                                                        .videoListModel!
                                                        .user!
                                                        .id!);

                                            await selectTowerBottomSheet(
                                                context: context,
                                                data_like_post:
                                                    homepageController
                                                        .getPostLikeCount!,
                                                like_numebers: widget
                                                    .videoListModel!.likes!);
                                          },
                                          child: Container(
                                            // color: Colors.pink,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 3.0,
                                                  left: 0,
                                                  right: 0,
                                                  bottom: 3),
                                              child: Text(
                                                  widget.video_like_count,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontFamily: 'PR')),
                                            ),
                                          ),
                                        ),

                                        (widget.videoListModel!.enableComment ==
                                                'true'
                                            ? Column(
                                                children: [
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
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
                                                      color:
                                                          HexColor('#8AFC8D'),
                                                      scale: 3,
                                                    ),
                                                    onPressed: () async {
                                                      await controller_last!
                                                          .pause();

                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  PostImageCommentScreen(
                                                                    PostID: widget
                                                                        .video_id,
                                                                    post_user_id:
                                                                        widget
                                                                            .videoListModel!
                                                                            .user!
                                                                            .id,
                                                                  )));
                                                      // setState(() {
                                                      //   // _myPage.jumpToPage(0);
                                                      // });
                                                    },
                                                  ),
                                                  Container(
                                                    child: Text(
                                                        widget.comment_count,
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
                                              ? (widget
                                                      .videoListModel!
                                                      .advertiser!
                                                      .logo!
                                                      .isNotEmpty
                                                  ? Image.asset(
                                                      AssetUtils
                                                          .share_icon_reward,
                                                      color:
                                                          HexColor('#66E4F2'),
                                                      scale: 2,
                                                    )
                                                  : Image.asset(
                                                      AssetUtils
                                                          .share_icon_simple,
                                                      color:
                                                          HexColor('#66E4F2'),
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
                                        // SizedBox(
                                        //   height: 10,
                                        // ),
                                        (widget.videoListModel!.user!.type ==
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
                                                      color:
                                                          HexColor('#F32E82'),
                                                      scale: 3,
                                                    ),
                                                    onPressed: () async {
                                                      controller_last!.pause();
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
                                                    height: 5,
                                                  ),
                                                  Container(
                                                    child: Text(
                                                        widget.videoListModel!
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
                                        PopupMenuButton(
                                          surfaceTintColor: Colors.black,
                                          color: HexColor("#C12265"),
                                          shape: RoundedRectangleBorder(
                                              side: const BorderSide(
                                                  color: Colors.white,
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(24)),
                                          // isExpanded: true,
                                          icon: const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5.0),
                                            child: Icon(
                                              Icons.more_vert,
                                              color: Colors.white,
                                              size: 25,
                                            ),
                                          ),
                                          itemBuilder: (BuildContext context) =>
                                              [
                                            PopupMenuItem(
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
                                                                    .videoListModel!
                                                                    .user!
                                                                    .id!,
                                                                type: 'post',
                                                                type_id: widget
                                                                    .video_id,
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
                                                    controller_last!.pause();
                                                    await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ReportProblem(
                                                                  receiver_id:
                                                                      widget
                                                                          .videoListModel!
                                                                          .user!
                                                                          .id!,
                                                                  type: 'post',
                                                                  type_id: widget
                                                                      .video_id,
                                                                )));
                                                  },
                                                  child: const Text(
                                                      "Report Video",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                          fontFamily: 'PR')),
                                                ))
                                          ],
                                          // value: dropdownvalue,
                                          // style: const TextStyle(
                                          //   fontSize: 16,
                                          //   fontFamily: 'PR',
                                          //   color: Colors.white,
                                          // ),
                                          // alignment: Alignment.centerLeft,
                                          onSelected: (value) {
                                            // setState(() {
                                            //   dropdownvalue = value.toString();
                                            // });
                                            if (kDebugMode) {
                                              print(value);
                                            }
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ReportProblem(
                                                        receiver_id: widget
                                                            .videoListModel!
                                                            .user!
                                                            .id!,
                                                        type: 'post',
                                                        type_id:
                                                            widget.video_id,
                                                      )),
                                            );
                                          },

                                          // iconSize: 25,
                                          // iconEnabledColor: const Color(0xff007DEF),
                                          // iconDisabledColor: const Color(0xff007DEF),
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
                                    left: 0.0, right: 15.0),
                                child: Divider(
                                  color: HexColor('#F32E82'),
                                  height: 0,
                                )),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            // color: Colors.white,
                            child: ListTile(
                              visualDensity: const VisualDensity(
                                  vertical: 4, horizontal: -4),
                              leading: GestureDetector(
                                onTap: () async {
                                  await controller_last!.pause();
                                  Get.to(SearchUserProfile(
                                    // quickBlox_id: qb_user!.id!,
                                    quickBlox_id: "0",
                                    // UserId: _search_screen_controller
                                    //     .searchlistModel!.data![index].id!,
                                    search_user_data:
                                        widget.videoListModel!.user!,
                                  ));
                                },
                                child: (widget.image_url.isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: SizedBox(
                                          height: 50,
                                          width: 50,
                                          child: Image.network(
                                            "${URLConstants.base_data_url}images/${widget.image_url}",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                    : (widget.profile_url.isNotEmpty
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Container(
                                              height: 50,
                                              width: 50,
                                              color: Colors.red,
                                              child: Image.network(
                                                widget.profile_url,
                                              ),
                                            ),
                                          )
                                        : SizedBox(
                                            height: 50,
                                            width: 50,
                                            child: IconButton(
                                              icon: Image.asset(
                                                AssetUtils.user_icon3,
                                                fit: BoxFit.cover,
                                              ),
                                              onPressed: () async {
                                                await controller_last!.pause();
                                                Get.to(SearchUserProfile(
                                                  // quickBlox_id: qb_user!.id!,
                                                  quickBlox_id: "0",
                                                  // UserId: _search_screen_controller
                                                  //     .searchlistModel!.data![index].id!,
                                                  search_user_data: widget
                                                      .videoListModel!.user!,
                                                ));
                                              },
                                            )))),
                              ),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: 120,
                                            child: Text(
                                              widget.singerName,
                                              overflow: TextOverflow.ellipsis,
                                              // maxLines: 2,
                                              style: TextStyle(
                                                  color: HexColor('#ffffff'),
                                                  fontFamily: "PR",
                                                  fontSize: 14),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              await _search_screen_controller.Follow_unfollow_api(
                                                  follow_unfollow: (widget
                                                              .videoListModel
                                                              .user
                                                              .userFollowUnfollow ==
                                                          'follow'
                                                      ? 'unfollow'
                                                      : (widget
                                                                  .videoListModel
                                                                  .user
                                                                  .userFollowUnfollow ==
                                                              'unfollow'
                                                          ? 'follow'
                                                          : (widget
                                                                      .videoListModel
                                                                      .user
                                                                      .userFollowUnfollow ==
                                                                  'followback'
                                                              ? 'follow'
                                                              : 'follow'))),
                                                  user_id: widget
                                                      .videoListModel.user.id,
                                                  user_social: widget
                                                      .videoListModel
                                                      .user
                                                      .socialType,
                                                  context: context);
                                              setState(() {
                                                homepageController
                                                    .getAllVideosList();
                                              });
                                            },
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 0),
                                              height: 30,
                                              width: 80,
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
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 0,
                                                      horizontal: 5),
                                                  child: Obx(() =>
                                                      (homepageController
                                                                  .isVideoLoading
                                                                  .value ==
                                                              true
                                                          ? const SizedBox(
                                                              height: 15,
                                                              width: 15,
                                                              child:
                                                                  CircularProgressIndicator(
                                                                strokeWidth: 2,
                                                                color: Colors
                                                                    .white,
                                                              ))
                                                          : Text(
                                                              (widget.videoListModel.user
                                                                          .userFollowUnfollow ==
                                                                      'follow'
                                                                  ? 'Following'
                                                                  : (widget.videoListModel.user
                                                                              .userFollowUnfollow ==
                                                                          'unfollow'
                                                                      ? 'Follow'
                                                                      : (widget.videoListModel.user.userFollowUnfollow ==
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
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                4,
                                        child: SingleChildScrollView(
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
                                      ),
                                      Text(
                                        'Original Audio',
                                        style: TextStyle(
                                            color:
                                                HexColor(CommonColor.pinkFont),
                                            fontFamily: "PR",
                                            fontSize: 10),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: SizedBox(
                                width: 50,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Image.asset(
                                      AssetUtils.music_icon,
                                      height: 15.0,
                                      width: 15.0,
                                      fit: BoxFit.cover,
                                    ),
                                    // const SizedBox(
                                    //   width: 4.75,
                                    // ),
                                    SizedBox(
                                      height: 20,
                                      width: 30,
                                      child: Marquee(
                                        text: widget.songName,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'PR',
                                            fontSize: 10),
                                        scrollAxis: Axis.horizontal,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        blankSpace: 20.0,
                                        velocity: 30.0,
                                        pauseAfterRound:
                                            const Duration(milliseconds: 100),
                                        startPadding: 10.0,
                                        accelerationDuration:
                                            const Duration(seconds: 1),
                                        accelerationCurve: Curves.easeIn,
                                        decelerationDuration:
                                            const Duration(microseconds: 500),
                                        decelerationCurve: Curves.easeOut,
                                      ),
                                    )
                                    // Text(
                                    //   widget.songName,
                                    //   style: TextStyle(
                                    //       color: HexColor(
                                    //           '#FFFFFF')
                                    //           .withOpacity(0.55),
                                    //       fontFamily: "PR",
                                    //       fontSize: 10),
                                    // ),
                                  ],
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
              Center(
                child: ButtonTheme(
                    height: 50.0,
                    minWidth: 50.0,
                    child: AnimatedOpacity(
                      opacity: isClicked ? 0.0 : 1.0,
                      duration: const Duration(milliseconds: 100),
                      // how much you want the animation to be long)
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isClicked = true;
                            if (controller_last!.value.isPlaying) {
                              controller_last!.pause();
                            } else {
                              controller_last!.play();
                            }
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(50)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              controller_last!.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              size: 30.0,
                              color: HexColor(CommonColor.pinkFont),
                            ),
                          ),
                        ),
                      ),
                    )),
              ),
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

  Coins? _coins;
  double _value = 10;
  bool world_select = false;
  bool custom_select = false;
  TextEditingController custom_coin_controller = TextEditingController();

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
                                                receiver_id: widget
                                                    .videoListModel!.user!.id!,
                                                post_id: widget.video_id,
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
                                                receiver_id: widget
                                                    .videoListModel!.user!.id!,
                                                post_id: widget.video_id,
                                                coin_value:
                                                    custom_coin_controller
                                                        .text);
                                          }
                                        } else {
                                          PostRewardCoinApi(
                                              context: context,
                                              receiver_id: widget
                                                  .videoListModel!.user!.id!,
                                              post_id: widget.video_id,
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
                                                              : '')))));
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
        CommonWidget().showErrorToaster(msg: 'Please select coin');
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
      if (widget.videoListModel!.advertiser!.logo!.isNotEmpty) {
        await homepageController.PostRewardGet(
            context: context,
            post_type: 'video',
            post_id: widget.videoListModel!.iD!);
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
