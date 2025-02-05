import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:funky_new/Utils/App_utils.dart';
import 'package:funky_new/homepage/ui/post_image_commet_scren.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
// import 'package:funky_project/Utils/colorUtils.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:readmore/readmore.dart';
import 'package:video_player/video_player.dart';

import '../../Utils/asset_utils.dart';
import '../../Utils/colorUtils.dart';
import '../../Utils/toaster_widget.dart';
import '../../homepage/controller/homepage_controller.dart';
import '../../news_feed/heart_animation_widget.dart';
import '../../settings/report_video/report_problem.dart';
import '../../sharePreference.dart';
import '../model/postdeleteModel.dart';
import '../model/videoModelList.dart';
import '../profile_controller.dart';

class CommonVideo extends StatefulWidget {
  final bool play;
  final String singerName;
  final String description;
  final String songName;
  final String url;
  final String image_url;
  final String profile_url;
  final String video_id;
  final String comment_count;
  final String user_type;
  final String user_id;

  final String enable_download;
  final String enable_comment;

  final Data_profile_video? videomodel;

  String video_like_count;
  String video_like_status;

  final VoidCallback? onDoubleTap;

  CommonVideo(
      {super.key,
      required this.play,
      required this.singerName,
      required this.description,
      required this.songName,
      required this.url,
      required this.image_url,
      required this.video_id,
      required this.comment_count,
      required this.video_like_count,
      required this.video_like_status,
      this.onDoubleTap,
      required this.profile_url,
      required this.videomodel,
      required this.user_type,
      required this.enable_download,
      required this.enable_comment,
      required this.user_id});

  @override
  State<CommonVideo> createState() => _CommonVideoState();
}

class _CommonVideoState extends State<CommonVideo> {
  final HomepageController homepageController =
      Get.put(HomepageController(), tag: HomepageController().toString());
  VideoPlayerController? controller_last;

  final bool _onTouch = false;
  Timer? _timer;
  bool isClicked = true; // boolean that states if the button is pressed or not

  @override
  void initState() {
    super.initState();
    init();
    print('image urlllllllllllll ${widget.url}');
    print('image video_id ${widget.video_id}');
    print('image video_like_count ${widget.video_like_count}');
    print('image video_like_status ${widget.video_like_status}');
    controller_last = VideoPlayerController.network(
        "${URLConstants.base_data_url}video/${widget.url}");

    controller_last!.setLooping(true);
    controller_last!.initialize().then((_) {
      setState(() {
        homepageController.Post_view_count(
            context: context, post_id: widget.video_id);
      });
    });
    (widget.play ? controller_last!.play() : controller_last!.pause());
  }

  String? id_User;

  init() async {
    String idUser = await PreferenceManager().getPref(URLConstants.id);
    print(idUser);
    print(widget.user_id);
    setState(() {
      id_User = idUser;
    });
  }

  @override
  void dispose() {
    // _timer?.cancel();
    super.dispose();
    controller_last!.pause();
    controller_last!.dispose();
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

  bool download_bool = false;

  download() async {
    // showLoader(context);
    setState(() {
      download_bool = true;
    });
    String url = '${URLConstants.base_data_url}video/${widget.url}';
    final tempDir = await getTemporaryDirectory();
    final path = '${tempDir.path}/funkyVideo.mp4';
    await Dio().download(url, path);
    await GallerySaver.saveVideo(path);
    setState(() {
      download_bool = false;
    });
    CommonWidget().showToaster(msg: "Video Downloaded");
  }

  bool isLiked = false;
  bool isHeartAnimating = false;
  String dropdownvalue = 'Apple';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Colors.transparent,
          actions: [
            SizedBox(
              width: 50,
              // margin: EdgeInsets.only(right: 20),
              // color: Colors.pink,
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  customButton: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                    size: 20,
                  ),
                  items: (widget.enable_download == 'true'
                      ? (widget.user_id == id_User
                          ? [
                              DropdownMenuItem(
                                  value: "Apple",
                                  onTap: () {
                                    PostDeleteApi(
                                        context: context,
                                        post_id: widget.video_id);
                                  },
                                  child: const Text("Delete",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'PR'))),
                              DropdownMenuItem(
                                  value: "items2",
                                  onTap: () {
                                    download();
                                  },
                                  child: const Text("Download",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'PR'))),
                            ]
                          : [
                              DropdownMenuItem(
                                  value: "Apple",
                                  onTap: () {
                                    controller_last!.pause();

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ReportProblem(
                                                  receiver_id: widget.user_id,
                                                  type: 'post',
                                                  type_id: widget.video_id,
                                                )));
                                  },
                                  child: const Text("Report",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'PR'))),
                              DropdownMenuItem(
                                  value: "items2",
                                  onTap: () {
                                    download();
                                  },
                                  child: const Text("Download",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'PR'))),
                            ])
                      : (widget.user_id == id_User
                          ? [
                              DropdownMenuItem(
                                  value: "Apple",
                                  onTap: () {
                                    PostDeleteApi(
                                        context: context,
                                        post_id: widget.video_id);
                                  },
                                  child: const Text("Delete",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'PR'))),
                            ]
                          : [
                              DropdownMenuItem(
                                  value: "Apple",
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ReportProblem(
                                                  receiver_id: widget.user_id,
                                                  type: 'post',
                                                  type_id: widget.video_id,
                                                )));
                                  },
                                  child: const Text("Report",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'PR'))),
                            ])),
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
                    padding: const EdgeInsets.only(left: 15, right: 15),
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
        body: Stack(
          children: [
            GestureDetector(
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
                      widget.video_like_count = homepageController
                          .postLikeUnlikeModel!.user![0].likes!;

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
                                  aspectRatio:
                                      controller_last!.value.aspectRatio,
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
                        margin: const EdgeInsets.only(bottom: 30, left: 21),
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
                                      bottom: 10, right: 21, left: 0.0),
                                  alignment: Alignment.bottomRight,
                                  child: Column(
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
                                            color: (widget.video_like_status ==
                                                    'false'
                                                ? Colors.white
                                                : HexColor(
                                                    CommonColor.pinkFont)),
                                            scale: 3,
                                          ),
                                          onPressed: () async {
                                            await homepageController.PostLikeUnlikeApi(
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
                                      Container(
                                        child: Text(widget.video_like_count,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontFamily: 'PR')),
                                      ),

                                      (widget.enable_comment == 'true'
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
                                                                      .video_id,
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
                                              ],
                                            )
                                          : const SizedBox.shrink()),
                                      // Container(
                                      //   child: Text('${widget.comment_count}',
                                      //       style: TextStyle(
                                      //           color: Colors.white,
                                      //           fontSize: 12,
                                      //           fontFamily: 'PR')),
                                      // ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      IconButton(
                                        visualDensity:
                                            const VisualDensity(vertical: -4),
                                        padding:
                                            const EdgeInsets.only(left: 0.0),
                                        icon: Image.asset(
                                          AssetUtils.share_icon_reward,
                                          color: HexColor('#66E4F2'),
                                          scale: 2,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            // _myPage.jumpToPage(0);
                                          });
                                        },
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      (widget.user_type == "Advertiser"
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
                                                  onPressed: () {
                                                    setState(() {
                                                      // _myPage.jumpToPage(0);
                                                    });
                                                  },
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            )),
                                      IconButton(
                                        visualDensity:
                                            const VisualDensity(vertical: -4),
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
                            ListTile(
                              visualDensity: const VisualDensity(
                                  vertical: 4, horizontal: -4),
                              // tileColor: Colors.white,
                              leading: (widget.image_url.isNotEmpty
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
                                              fit: BoxFit.fill,
                                            ),
                                            onPressed: () {},
                                          )))),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        // constraints: const BoxConstraints(
                                        //     minWidth: 100, maxWidth: 220),
                                        child: Row(
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
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
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
                                                      color: HexColor('#FFFFFF')
                                                          .withOpacity(0.55),
                                                      fontFamily: "PR",
                                                      fontSize: 10),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                4,
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
            ),
            (download_bool
                ? Center(
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
                                backgroundColor: HexColor(CommonColor.pinkFont),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.white70, //<-- SEE HERE
                                ),
                              ),
                              // Text('Loading...',style: TextStyle(color: Colors.white,fontSize: 18,fontFamily: 'PR'),)
                            ],
                          ),
                        )),
                  )
                : const SizedBox.shrink())
          ],
        ));
  }

  bool isPostdeleteLoading = false;
  PostDeleteModel? postDeleteModel;

  final Profile_screen_controller _profile_screen_controller = Get.put(
      Profile_screen_controller(),
      tag: Profile_screen_controller().toString());

  Future<dynamic> PostDeleteApi({
    required BuildContext context,
    required String post_id,
  }) async {
    debugPrint('0-0-0-0-0-0-0 PostLikeUnlike');

    setState(() {
      isPostdeleteLoading = true;
    });

    Map data = {
      'id': post_id,
    };
    print(data);
    // String body = json.encode(data);

    var url = (URLConstants.base_url + URLConstants.PostDeleteApi);
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
      // isLikeLoading(false);
      var data = jsonDecode(response.body);
      postDeleteModel = PostDeleteModel.fromJson(data);
      print(postDeleteModel);
      if (postDeleteModel!.error == false) {
        setState(() {
          isPostdeleteLoading = false;
        });
        CommonWidget().showToaster(msg: postDeleteModel!.message!);
        await _profile_screen_controller.get_video_list(
            context: context, user_id: id_User!, login_user_id: id_User!);

        Navigator.pop(context);

        // await getAllNewsFeedList();
      } else {
        setState(() {
          isPostdeleteLoading = false;
        });
        print('Please try again');
        CommonWidget().showErrorToaster(msg: 'Enter valid Otp');
      }
    } else {
      setState(() {
        isPostdeleteLoading = false;
      });
      print('Please try again');
    }
  }
}
