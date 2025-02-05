import 'dart:async';

import 'package:circle_list/circle_list.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:video_player/video_player.dart';

import '../../Utils/asset_utils.dart';
import '../../Utils/colorUtils.dart';
import '../../custom_widget/loader_page.dart';
import '../../dashboard/dashboard_screen.dart';
import '../../drawerScreen.dart';
import '../../profile_screen/following_screen.dart';
import '../controller/homepage_controller.dart';
import 'Liked_posts_screen.dart';
import 'common_image_class.dart';
import 'common_video_class.dart';
import 'music/music_all_list.dart';

class HomePageScreen extends StatefulWidget {
  final bool play;

  const HomePageScreen({super.key, required this.play});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final HomepageController homepageController =
      Get.put(HomepageController(), tag: HomepageController().toString());
  Timer? _timer;

  @override
  void initState() {
    init();
    // **d
    super.initState();
  }

  init() async {
    await homepageController.getAllVideosList();
    await homepageController.getAllImagesList();
    await video_method();
  }

  video_method() {
    FirebaseMessaging.instance.getToken().then((value) {
      String? token = value;
      print(token);
    });
  }

  VideoPlayerController? video_controller;

  @override
  void dispose() {
    _timer?.cancel();
    _animationController?.dispose();
    super.dispose();
  }

  List<String> wheel_icons = [
    AssetUtils.ball_icon_1,
    AssetUtils.ball_icon_2,
    AssetUtils.ball_icon_3,
    AssetUtils.ball_icon_4,
    AssetUtils.ball_icon_5,
  ];
  int selected_wheel = 1;

  // int _currentPage = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLiked = false;
  bool isHeartAnimating = false;

  String? post_id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        drawer: const DrawerScreen(),
        body: RefreshIndicator(
          color: HexColor(CommonColor.pinkFont),
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));
            await homepageController.getAllVideosList();
            await homepageController.getAllImagesList();
            setState(() {});
          },
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Obx(() => (homepageController.isVideoLoading.value ==
                              true &&
                          // homepageController.videoListModel != null &&
                          homepageController.isimageLoading.value == true
                      // && homepageController.imageListModel != null
                      )
                      ? const Center(child: LoaderPage())
                      : (homepageController.videoListModel!.error == false &&
                              homepageController.imageListModel!.error == false
                          ? (homepageController
                                      .videoListModel!.data!.isNotEmpty &&
                                  homepageController
                                      .imageListModel!.data!.isNotEmpty
                              ? Stack(
                                  children: [
                                    Center(
                                      child: PageView.builder(
                                          scrollDirection: Axis.vertical,
                                          itemCount: (selected_wheel == 0
                                              ? homepageController
                                                  .imageListModel!.data!.length
                                              : homepageController
                                                  .videoListModel!
                                                  .data!
                                                  .length),
                                          onPageChanged: (int page) {
                                            homepageController
                                                .getAllVideosList();
                                            setState(() {
                                              // _currentPage = page;
                                              post_id = (selected_wheel == 0
                                                  ? homepageController
                                                      .imageListModel!
                                                      .data![page]
                                                      .user!
                                                      .id!
                                                  : (selected_wheel == 1
                                                      ? homepageController
                                                          .videoListModel!
                                                          .data![page]
                                                          .user!
                                                          .id
                                                      : homepageController
                                                          .imageListModel!
                                                          .data![page]
                                                          .user!
                                                          .id!));
                                              print(
                                                  "possssssssssßśš : $post_id");
                                            });
                                          },
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            post_id = (selected_wheel ==
                                                    0 /*||
                                                        selected_wheel == 3*/
                                                ? homepageController
                                                    .imageListModel!
                                                    .data![index]
                                                    .user!
                                                    .id!
                                                : (selected_wheel ==
                                                        1 /*||
                                                            selected_wheel == 4*/
                                                    ? homepageController
                                                        .videoListModel!
                                                        .data![index]
                                                        .user!
                                                        .id
                                                    : homepageController
                                                        .imageListModel!
                                                        .data![index]
                                                        .user!
                                                        .id!));

                                            return (selected_wheel == 0
                                                ? (homepageController
                                                            .imageListModel!
                                                            .error ==
                                                        false
                                                    ? (homepageController
                                                            .imageListModel!
                                                            .data!
                                                            .isNotEmpty
                                                        ? ImageWidget(
                                                            liked_post: false,
                                                            useerName:
                                                                homepageController
                                                                    .imageListModel!
                                                                    .data![
                                                                        index]
                                                                    .fullName!,
                                                            Imageurl:
                                                                homepageController
                                                                    .imageListModel!
                                                                    .data![
                                                                        index]
                                                                    .postImage!,
                                                            ProfileUrl:
                                                                homepageController
                                                                    .imageListModel!
                                                                    .data![
                                                                        index]
                                                                    .user!
                                                                    .image!,
                                                            description:
                                                                homepageController
                                                                    .imageListModel!
                                                                    .data![
                                                                        index]
                                                                    .description!,
                                                            SocialProfileUrl:
                                                                homepageController
                                                                    .imageListModel!
                                                                    .data![
                                                                        index]
                                                                    .user!
                                                                    .profileUrl!,
                                                            image_like_count:
                                                                homepageController
                                                                    .imageListModel!
                                                                    .data![
                                                                        index]
                                                                    .likes!,
                                                            image_id:
                                                                homepageController
                                                                    .imageListModel!
                                                                    .data![
                                                                        index]
                                                                    .iD!,
                                                            image_like_status:
                                                                homepageController
                                                                    .imageListModel!
                                                                    .data![
                                                                        index]
                                                                    .likeStatus!,
                                                            imagemodel:
                                                                homepageController
                                                                    .imageListModel!
                                                                    .data![index],
                                                          )
                                                        : Container(
                                                            alignment: Alignment
                                                                .center,
                                                            color: Colors
                                                                .transparent,
                                                            height: 80,
                                                            width: 200,
                                                            child: Container(
                                                              color:
                                                                  Colors.black,
                                                              child: const Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceAround,
                                                                children: [
                                                                  CircularProgressIndicator(
                                                                    color: Colors
                                                                        .pink,
                                                                  ),
                                                                  Text(
                                                                    'Loading...',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            18,
                                                                        fontFamily:
                                                                            'PR'),
                                                                  )
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
                                                            ))
                                                    : const SizedBox())
                                                : (selected_wheel ==
                                                        1 /*||
                                                            selected_wheel == 4*/
                                                    ?
                                                    // VideoDetails(url: homepageController
                                                    //         .videoListModel!.data![index].videoUrl!,);
                                                    (homepageController
                                                                .videoListModel!
                                                                .error ==
                                                            false
                                                        ? (homepageController
                                                                .videoListModel!
                                                                .data!
                                                                .isNotEmpty
                                                            ? VideoWidget(
                                                                videoListModel:
                                                                    homepageController
                                                                        .videoListModel!
                                                                        .data![index],
                                                                url: homepageController
                                                                    .videoListModel!
                                                                    .data![
                                                                        index]
                                                                    .uploadVideo!,
                                                                comment_count:
                                                                    homepageController
                                                                        .videoListModel!
                                                                        .data![
                                                                            index]
                                                                        .commentCount!,
                                                                play: true,
                                                                description: homepageController
                                                                    .videoListModel!
                                                                    .data![
                                                                        index]
                                                                    .description!,
                                                                songName: homepageController
                                                                    .videoListModel!
                                                                    .data![
                                                                        index]
                                                                    .musicName!,
                                                                image_url:
                                                                    homepageController
                                                                        .videoListModel!
                                                                        .data![
                                                                            index]
                                                                        .user!
                                                                        .image!,
                                                                profile_url: homepageController
                                                                    .videoListModel!
                                                                    .data![
                                                                        index]
                                                                    .user!
                                                                    .profileUrl!,
                                                                singerName: (homepageController
                                                                            .videoListModel!
                                                                            .data![
                                                                                index]
                                                                            .userName ==
                                                                        null
                                                                    ? ''
                                                                    : homepageController
                                                                        .videoListModel!
                                                                        .data![
                                                                            index]
                                                                        .userName!),
                                                                video_id: homepageController
                                                                    .videoListModel!
                                                                    .data![
                                                                        index]
                                                                    .iD!,
                                                                video_like_count:
                                                                    homepageController
                                                                        .videoListModel!
                                                                        .data![
                                                                            index]
                                                                        .likes!,
                                                                video_like_status:
                                                                    homepageController
                                                                        .videoListModel!
                                                                        .data![
                                                                            index]
                                                                        .likeStatus!,
                                                                liked_post:
                                                                    false,
                                                              )
                                                            : Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                color: Colors
                                                                    .transparent,
                                                                height: 80,
                                                                width: 200,
                                                                child:
                                                                    Container(
                                                                  color: Colors
                                                                      .black,
                                                                  child:
                                                                      const Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceAround,
                                                                    children: [
                                                                      CircularProgressIndicator(
                                                                        color: Colors
                                                                            .pink,
                                                                      ),
                                                                      Text(
                                                                        'Loading...',
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .white,
                                                                            fontSize:
                                                                                18,
                                                                            fontFamily:
                                                                                'PR'),
                                                                      )
                                                                    ],
                                                                  ),
                                                                )))
                                                        : const SizedBox())
                                                    : const SizedBox()));
                                          }),
                                    ),
                                    Positioned(
                                        top:
                                            MediaQuery.of(context).size.height /
                                                3,
                                        child: Stack(
                                          children: [
                                            CustomPaint(
                                              painter: MyPainter2(),
                                              size: Size(
                                                  (animation_started
                                                      ? _animation!.value
                                                      : 35),
                                                  (animation_started
                                                      ? _animation!.value
                                                      : 35)),
                                              child: CircleList(
                                                onDragUpdate: (value) {
                                                  print(value);
                                                  print(
                                                      'drag updated :$selected_wheel');
                                                },
                                                outerRadius: (animation_started
                                                    ? _animation_wheel!.value
                                                    : 80),
                                                innerRadius: (animation_started
                                                    ? _animation_wheel2!.value
                                                    : 0),
                                                outerCircleColor:
                                                    (animation_started
                                                        ? Colors.black
                                                            .withOpacity(0.8)
                                                        : Colors.transparent),
                                                innerCircleColor:
                                                    (animation_started
                                                        ? Colors.black
                                                            .withOpacity(0.8)
                                                        : Colors.transparent),
                                                origin: const Offset(-60, 0),
                                                centerWidget: Container(
                                                  height: 35,
                                                  width: 35,
                                                  color: Colors.transparent,
                                                  alignment: Alignment.center,
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                          child: const MyArc3(
                                                              diameter: 100)),
                                                      IconButton(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 20),
                                                        visualDensity:
                                                            const VisualDensity(
                                                                horizontal: -4,
                                                                vertical: -4),
                                                        onPressed: () {
                                                          setState(() {
                                                            close_animation();

                                                            // (animation_started ? false : true);
                                                            print(
                                                                animation_started);
                                                          });
                                                          // start_animation();
                                                        },
                                                        icon: Icon(
                                                          Icons.arrow_back_ios,
                                                          color: Colors.white,
                                                          size:
                                                              (animation_started
                                                                  ? 15
                                                                  : 0),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                children:
                                                    List.generate(5, (index) {
                                                  return GestureDetector(
                                                    onTap: () async {
                                                      print(index);
                                                      setState(() {
                                                        selected_wheel = index;
                                                      });
                                                      if (selected_wheel ==
                                                              2 /*||
                                                              selected_wheel ==
                                                                  4*/
                                                          ) {
                                                        // Navigator.push(
                                                        //     context,
                                                        //     MaterialPageRoute(
                                                        //         builder:
                                                        //             (context) =>
                                                        //                 searchUserFollowing(
                                                        //                   searchUserid:
                                                        //                       post_id!,
                                                        //                 )));
                                                        await Navigator.of(
                                                                context)
                                                            .pushAndRemoveUntil(
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            FollowingScreen(
                                                                              user_id: post_id!,
                                                                            )
                                                                    // searchUserFollowing(
                                                                    //         searchUserid: post_id!,
                                                                    //       )
                                                                    ),
                                                                (route) =>
                                                                    false);
                                                        // Get.to(FollowersList());
                                                      } else if (selected_wheel ==
                                                          3) {
                                                        Navigator.of(context)
                                                            .pushAndRemoveUntil(
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            const LikedPostScreen()
                                                                    // searchUserFollowing(
                                                                    //         searchUserid: post_id!,
                                                                    //       )
                                                                    ),
                                                                (route) =>
                                                                    false);
                                                        // Get.to(LikedPostScreen());
                                                      } else if (selected_wheel ==
                                                          4) {
                                                        await Navigator.of(
                                                                context)
                                                            .pushAndRemoveUntil(
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            const MusicList()),
                                                                (route) =>
                                                                    false);

                                                        print("music all get");
                                                      }
                                                    },
                                                    child: Container(
                                                        height: (animation_started
                                                            ? _animation_circle!
                                                                .value
                                                            : 0),
                                                        width: (animation_started
                                                            ? _animation_circle!
                                                                .value
                                                            : 0),
                                                        // margin: EdgeInsets.only(
                                                        //     bottom: (animation_started
                                                        //         ? _animation_padding1!.value
                                                        //         : 0),
                                                        //     left: (animation_started
                                                        //         ? _animation_padding2!.value
                                                        //         : 0)),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(50),
                                                          // border: Border.all(
                                                          //     color:
                                                          //         (selected_wheel == index
                                                          //             ? Colors.pink
                                                          //             : Colors.white),
                                                          //     width: 1)
                                                        ),
                                                        child: Image.asset(
                                                          wheel_icons[index],
                                                          // color: (index == 0
                                                          //     ? Colors.pink
                                                          //     : (index == 1
                                                          //     ? Colors.blue
                                                          //     : (index == 2
                                                          //     ? Colors.purple
                                                          //     : Colors.white))),
                                                          height: (animation_started
                                                              ? _animation_icon!
                                                                  .value
                                                              : 0),
                                                          width: (animation_started
                                                              ? _animation_icon!
                                                                  .value
                                                              : 0),
                                                        )),
                                                  );
                                                }),
                                              ),
                                            ),
                                            Positioned.fill(
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Container(
                                                  height: (animation_started
                                                      ? 0
                                                      : 35),
                                                  width: (animation_started
                                                      ? 0
                                                      : 35),
                                                  color: Colors.transparent,
                                                  alignment: Alignment.center,
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                          child: MyArc3(
                                                              diameter:
                                                                  (animation_started
                                                                      ? _animation_arrow!
                                                                          .value
                                                                      : 80))),
                                                      IconButton(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 20),
                                                        visualDensity:
                                                            const VisualDensity(
                                                                horizontal: -4,
                                                                vertical: -4),
                                                        onPressed: () {
                                                          start_animation();
                                                          Future.delayed(
                                                              const Duration(
                                                                  seconds: 5),
                                                              () {
                                                            close_animation();
                                                          });

                                                          print(
                                                              animation_started);
                                                        },
                                                        icon: Icon(
                                                          Icons
                                                              .arrow_forward_ios,
                                                          color: Colors.white,
                                                          size:
                                                              (animation_started
                                                                  ? 0
                                                                  : 15),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ))
                                  ],
                                )
                              : Container(
                                  alignment: Alignment.center,
                                  color: Colors.transparent,
                                  height: 80,
                                  width: 200,
                                  child: Container(
                                    color: Colors.black,
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        CircularProgressIndicator(
                                          color: Colors.pink,
                                        ),
                                        Text(
                                          'Loading...',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontFamily: 'PR'),
                                        )
                                      ],
                                    ),
                                  )))
                          : const SizedBox())),
                ),
              ],
            ),
          ),
        ));
  }

  AnimationController? _animationController;
  Animation? _animation;
  Animation? _animation_wheel;
  Animation? _animation_wheel2;
  Animation? _animation_arrow;
  Animation? _animation_circle;
  Animation? _animation_icon;
  bool animation_started = false;

  start_animation() {
    setState(() {
      animation_started = true;
      print(animation_started);
    });
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    _animationController!.forward();
    _animation = Tween(begin: 40.0, end: 180.0).animate(_animationController!)
      ..addListener(() {
        setState(() {});
      });
    _animation_wheel =
        Tween(begin: 0.0, end: 80.0).animate(_animationController!)
          ..addListener(() {
            setState(() {});
          });
    _animation_wheel2 =
        Tween(begin: 0.0, end: 20.0).animate(_animationController!)
          ..addListener(() {
            setState(() {});
          });
    _animation_arrow =
        Tween(begin: 100.0, end: 00.0).animate(_animationController!)
          ..addListener(() {
            setState(() {});
          });
    _animation_circle =
        Tween(begin: 0.0, end: 35.0).animate(_animationController!)
          ..addListener(() {
            setState(() {});
          });
    _animation_icon =
        Tween(begin: 0.0, end: 30.0).animate(_animationController!)
          ..addListener(() {
            setState(() {});
          });
  }

  close_animation() {
    setState(() {
      animation_started = false;
    });
    _animationController!.repeat();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
