import 'dart:async';

import 'package:flutter/material.dart';
import 'package:funky_new/Utils/App_utils.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:readmore/readmore.dart';
import 'package:video_player/video_player.dart';

import '../../Authentication/age_verificationScreen.dart';
import '../../Utils/asset_utils.dart';
import '../../Utils/colorUtils.dart';
import '../../news_feed/heart_animation_widget.dart';
import '../../search_screen/search_screen_user_profile.dart';
import '../../settings/controller.dart';
import '../controller/bottom_drawer.dart';
import '../controller/homepage_controller.dart';
import '../model/GetPostLikeCount.dart';
import '../model/guestvideoModel.dart';

class CommonVideoGuest extends StatefulWidget {
  final bool play;
  final String singerName;
  final String description;
  final String songName;
  final String url;
  final String image_url;
  final String profile_url;
  final String video_id;
  final String comment_count;
  final Data_guest? videoListModel;

  String video_like_count;
  String video_like_status;

  final VoidCallback? onDoubleTap;

  CommonVideoGuest(
      {Key? key,
      required this.play,
      required this.singerName,
      required this.description,
      required this.songName,
      required this.url,
      required this.image_url,
      required this.profile_url,
      required this.video_id,
      required this.comment_count,
      required this.video_like_count,
      required this.video_like_status,
      this.videoListModel,
      this.onDoubleTap})
      : super(key: key);

  @override
  State<CommonVideoGuest> createState() => _CommonVideoGuestState();
}

class _CommonVideoGuestState extends State<CommonVideoGuest> {
  final HomepageController homepageController = Get.put(HomepageController(), tag: HomepageController().toString());
  VideoPlayerController? controller_last;

  bool _onTouch = false;
  Timer? _timer;
  bool isClicked = true; // boolean that states if the button is pressed or not

  @override
  void initState() {
    super.initState();
    print('image urlllllllllllll ${widget.url}');
    print('image video_id ${widget.video_id}');
    print('image video_like_count ${widget.video_like_count}');
    print('image video_like_status ${widget.video_like_status}');
    controller_last = VideoPlayerController.network("${URLConstants.base_data_url}video/${widget.url}");

    controller_last!.setLooping(true);
    controller_last!.initialize().then((_) {
      setState(() {
        homepageController.Post_view_count(context: context, post_id: widget.videoListModel!.iD!);
      });
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          _visible = !_visible;
        });
      });
    });
    (widget.play ? controller_last!.play() : controller_last!.pause());
  }

  @override
  void dispose() {
    // _timer?.cancel();
    super.dispose();
    controller_last!.pause();
    controller_last!.dispose();
  }

  int _currentPage = 0;

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

  final Settings_screen_controller _settings_screen_controller =
      Get.put(Settings_screen_controller(), tag: Settings_screen_controller().toString());

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
                  context: context, post_id: widget.video_id, post_id_type: 'liked', post_likeStatus: 'true');

              if (homepageController.postLikeUnlikeModel!.error == false) {
                print("mmmmm${widget.video_like_count}");
                setState(() {
                  widget.video_like_count = homepageController.postLikeUnlikeModel!.user![0].likes!;

                  widget.video_like_status = homepageController.postLikeUnlikeModel!.user![0].likeStatus!;
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
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                          child: AspectRatio(
                              aspectRatio: controller_last!.value.aspectRatio, child: VideoPlayer(controller_last!)),
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
                    margin: const EdgeInsets.only(bottom: 20, left: 21),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Align(
                          alignment: Alignment.bottomRight,
                          child: SizedBox(
                            child: Container(
                              color: Colors.transparent,
                              // width: 50,
                              margin: const EdgeInsets.only(bottom: 10, right: 8, left: 0.0),
                              alignment: Alignment.bottomRight,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                      visualDensity: const VisualDensity(vertical: -4),
                                      padding: const EdgeInsets.only(left: 0.0),
                                      icon: Image.asset(
                                        AssetUtils.like_icon_filled,
                                        color: (widget.video_like_status == 'false'
                                            ? Colors.white
                                            : HexColor(CommonColor.pinkFont)),
                                        scale: 3,
                                      ),
                                      onPressed: () async {
                                        await controller_last!.pause();
                                        _scaleDialog(context: context);
                                      }),
                                  GestureDetector(
                                    onTap: () async {},
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 3.0, left: 0, right: 0, bottom: 3),
                                      child: Text(widget.video_like_count,
                                          style: const TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'PR')),
                                    ),
                                  ),

                                  Column(
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      IconButton(
                                        visualDensity: const VisualDensity(vertical: -4),
                                        iconSize: 30.0,
                                        padding: const EdgeInsets.only(left: 0.0),
                                        icon: Image.asset(
                                          AssetUtils.comment_icon,
                                          color: HexColor('#8AFC8D'),
                                          scale: 3,
                                        ),
                                        onPressed: () async {
                                          await controller_last!.pause();

                                          _scaleDialog(context: context);
                                          // setState(() {
                                          //   // _myPage.jumpToPage(0);
                                          // });
                                        },
                                      ),
                                      Container(
                                        child: Text('${widget.comment_count}',
                                            style:
                                                const TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'PR')),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),

                                  IconButton(
                                    visualDensity: const VisualDensity(vertical: 0),
                                    padding: const EdgeInsets.only(left: 0.0),
                                    icon: Image.asset(
                                      AssetUtils.share_icon_simple,
                                      color: HexColor('#66E4F2'),
                                      scale: 2,
                                    ),
                                    onPressed: () async {
                                      await controller_last!.pause();
                                      _scaleDialog(context: context);
                                    },
                                  ),
                                  // SizedBox(
                                  //   height: 10,
                                  // ),
                                  Column(
                                    children: [
                                      IconButton(
                                        visualDensity: const VisualDensity(vertical: -4),
                                        iconSize: 30.0,
                                        padding: const EdgeInsets.only(left: 0.0),
                                        icon: Image.asset(
                                          AssetUtils.reward_icon,
                                          color: HexColor('#F32E82'),
                                          scale: 3,
                                        ),
                                        onPressed: () async {
                                          controller_last!.pause();
                                          _scaleDialog(context: context);
                                        },
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        child: Text(widget.videoListModel!.rewardCount!,
                                            style:
                                                const TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'PR')),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    visualDensity: const VisualDensity(vertical: 0),
                                    padding: const EdgeInsets.only(left: 0.0),
                                    icon: Image.asset(
                                      AssetUtils.music_icon,
                                      color: HexColor('#F5C93A'),
                                      scale: 3,
                                    ),
                                    onPressed: () async {
                                      await controller_last!.pause();
                                      _scaleDialog(context: context);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Container(
                              margin: const EdgeInsets.only(left: 0.0, right: 15.0),
                              child: Divider(
                                color: HexColor('#F32E82'),
                                height: 0,
                              )),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        ListTile(
                          visualDensity: const VisualDensity(vertical: 4, horizontal: -4),
                          // tileColor: Colors.white,
                          leading: GestureDetector(
                            onTap: () async {
                              await controller_last!.pause();
                              Get.to(SearchUserProfile(
                                // quickBlox_id: qb_user!.id!,
                                quickBlox_id: "0",
                                // UserId: _search_screen_controller
                                //     .searchlistModel!.data![index].id!,
                                search_user_data: widget.videoListModel!.user!,
                              ));
                            },
                            child: (widget.image_url.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Container(
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
                                        borderRadius: BorderRadius.circular(50),
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          color: Colors.red,
                                          child: Image.network(
                                            widget.profile_url,
                                          ),
                                        ),
                                      )
                                    : Container(
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
                                              search_user_data: widget.videoListModel!.user!,
                                            ));
                                          },
                                        )))),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    constraints: const BoxConstraints(minWidth: 100, maxWidth: 220),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 120,
                                          child: Text(
                                            widget.singerName,
                                            overflow: TextOverflow.ellipsis,
                                            // maxLines: 2,
                                            style:
                                                TextStyle(color: HexColor('#ffffff'), fontFamily: "PR", fontSize: 14),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Image.asset(
                                              AssetUtils.music_icon,
                                              height: 15.0,
                                              width: 15.0,
                                              fit: BoxFit.cover,
                                            ),
                                            const SizedBox(
                                              width: 4.75,
                                            ),
                                            Text(
                                              widget.songName,
                                              style: TextStyle(
                                                  color: HexColor('#FFFFFF').withOpacity(0.55),
                                                  fontFamily: "PR",
                                                  fontSize: 10),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 4,
                                    child: ReadMoreText(
                                      widget.description,
                                      trimLines: 2,
                                      colorClickableText: Colors.grey,
                                      trimMode: TrimMode.Line,
                                      trimCollapsedText: 'Show more',
                                      trimExpandedText: 'Show less',
                                      style: const TextStyle(color: Colors.white, fontFamily: "PR", fontSize: 12),
                                      moreStyle: const TextStyle(color: Colors.grey, fontFamily: "PR", fontSize: 10),
                                    ),
                                  ),
                                  Text(
                                    'Original Audio',
                                    style: TextStyle(
                                        color: HexColor(CommonColor.pinkFont), fontFamily: "PR", fontSize: 10),
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
                              color: Colors.black.withOpacity(0.5), borderRadius: BorderRadius.circular(50)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              controller_last!.value.isPlaying ? Icons.pause : Icons.play_arrow,
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
      {required BuildContext context, required GetPostLikeCount data_like_post, required String like_numebers}) {
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
