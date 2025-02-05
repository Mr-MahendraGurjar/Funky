import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:video_player/video_player.dart';

import '../Utils/App_utils.dart';
import '../Utils/asset_utils.dart';
import '../Utils/colorUtils.dart';
import '../homepage/controller/homepage_controller.dart';
import '../homepage/ui/post_image_commet_scren.dart';
import '../news_feed/heart_animation_widget.dart';

class DiscoverVideoClass extends StatefulWidget {
  final bool play;
  final String Video_id;
  final String videoUrl;
  final String ProfileUrl;
  final String imageUrl;
  final String Fullname;
  final String description;
  final String commentCount;
  String likeCount;
  String likestatus;

  DiscoverVideoClass(
      {super.key,
      required this.play,
      required this.videoUrl,
      required this.ProfileUrl,
      required this.imageUrl,
      required this.Fullname,
      required this.description,
      required this.commentCount,
      required this.likeCount,
      required this.likestatus,
      required this.Video_id});

  @override
  State<DiscoverVideoClass> createState() => DiscoverVideoClassState();
}

class DiscoverVideoClassState extends State<DiscoverVideoClass> {
  bool isClicked = false; // boolean that states if the button is pressed or not
  static VideoPlayerController? controller;
  Future<void>? _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    controller = VideoPlayerController.network(
      "${URLConstants.base_data_url}video/${widget.videoUrl}",
    );

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = controller!.initialize();

    // Use the controller to loop the video.
    controller!.setLooping(true);
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    controller!.dispose();
    super.dispose();
  }

  final int _currentPage = 0;

  // an arbitrary value, this can be whatever you need it to be
  double videoContainerRatio = 0.5;

  double getScale() {
    double videoRatio = controller!.value.aspectRatio;

    if (videoRatio < videoContainerRatio) {
      ///for tall videos, we just return the inverse of the controller aspect ratio
      return videoContainerRatio / videoRatio;
    } else {
      ///for wide videos, divide the video AR by the fixed container AR
      ///so that the video does not over scale

      return videoRatio / videoContainerRatio;
    }
  }

  final HomepageController homepageController =
      Get.put(HomepageController(), tag: HomepageController().toString());
  bool isLiked = false;
  bool isHeartAnimating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        body: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              child: ListTile(
                visualDensity: const VisualDensity(vertical: 0, horizontal: -4),
                dense: true,
                leading: SizedBox(
                  width: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: (widget.ProfileUrl.isNotEmpty
                        ? Image.network(widget.ProfileUrl)
                        // FadeInImage.assetNetwork(
                        //         height: 80,
                        //         width: 80,
                        //         fit: BoxFit.cover,
                        //         placeholder:
                        //             'assets/images/Funky_App_Icon.png',
                        //         image: _search_screen_controller
                        //             .searchlistModel!
                        //             .data![index]
                        //             .profileUrl!,
                        //       )
                        :
                        // Container(
                        //   height: 50,
                        //   width: 50,
                        //   child: ClipRRect(
                        //     borderRadius: BorderRadius.circular(50),
                        //     child: Image.network(
                        //       _search_screen_controller
                        //           .searchlistModel!
                        //           .data![index]
                        //           .profileUrl!, fit: BoxFit.fill,),
                        //   ),
                        // )
                        (widget.imageUrl.isNotEmpty
                            ? FadeInImage.assetNetwork(
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                                image:
                                    "${URLConstants.base_data_url}images/${widget.imageUrl}",
                                placeholder: 'assets/images/Funky_App_Icon.png',
                              )
                            : Container(
                                child: Image.asset(
                                    'assets/images/Funky_App_Icon.png')))),
                  ),
                ),
                //
                // Container(
                //     height: 50,
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(50),
                //       color: Colors.white,
                //     ),
                //     child: ClipRRect(
                //       borderRadius: BorderRadius.circular(50),
                //       child: IconButton(
                //         onPressed: () {},
                //         icon: Image.asset(
                //           AssetUtils.image1,
                //           fit: BoxFit.fill,
                //         ),
                //       ),
                //     )),
                title: Text(
                  widget.Fullname,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 14, fontFamily: 'PB'),
                ),
                // trailing: IconButton(
                //   icon: Icon(
                //     Icons.more_vert,
                //     color: Colors.white,
                //     size: 20,
                //   ),
                //   onPressed: () {},
                // ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Flexible(
              fit: FlexFit.tight,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isClicked = false;
                      });
                    },
                    onDoubleTap: () async {
                      setState(() {
                        isLiked = true;
                        isHeartAnimating = true;
                      });
                      await homepageController.PostLikeUnlikeApi(
                          context: context,
                          post_id: widget.Video_id,
                          post_id_type: (widget.likestatus == "true"
                              ? 'unliked'
                              : 'liked'),
                          post_likeStatus:
                              (widget.likestatus == "true" ? 'false' : 'true'));

                      if (homepageController.postLikeUnlikeModel!.error ==
                          false) {
                        print("mmmmm${widget.likeCount}");
                        if (widget.likestatus == "false") {
                          setState(() {
                            widget.likestatus = homepageController
                                .postLikeUnlikeModel!.user![0].likeStatus!;

                            widget.likeCount = homepageController
                                .postLikeUnlikeModel!.user![0].likes!;
                          });
                        } else {
                          setState(() {
                            widget.likestatus = 'false';

                            widget.likeCount = homepageController
                                .postLikeUnlikeModel!.user![0].likes!;
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
                        print("mmmmm${widget.likeCount}");
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
                          child: FutureBuilder(
                            future: _initializeVideoPlayerFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                // If the VideoPlayerController has finished initialization, use
                                // the data it provides to limit the aspect ratio of the video.
                                return AspectRatio(
                                  aspectRatio: controller!.value.aspectRatio,
                                  // Use the VideoPlayer widget to display the video.
                                  child: VideoPlayer(controller!),
                                );
                              } else {
                                // If the VideoPlayerController is still initializing, show a
                                // loading spinner.
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.pink,
                                    strokeWidth: 2,
                                  ),
                                );
                              }
                            },
                          ),
                          // controller_last!.value.isInitialized
                          //     ? SizedBox(
                          //   // height: MediaQuery.of(context).size.height,
                          //   // width: MediaQuery.of(context).size.width,
                          //   child: AspectRatio(
                          //       aspectRatio: controller_last!.value.aspectRatio,
                          //       child: VideoPlayer(controller_last!)),
                          // )
                          //     : Container(),
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
                                      if (controller!.value.isPlaying) {
                                        controller!.pause();
                                      } else {
                                        controller!.play();
                                      }
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        controller!.value.isPlaying
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
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 10.0),
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 5),
              child: Text(
                widget.description,
                textAlign: TextAlign.left,
                style: const TextStyle(
                    color: Colors.white, fontFamily: "PR", fontSize: 14),
              ),
            ),
            Container(
              child: Row(
                children: [
                  IconButton(
                      padding: const EdgeInsets.only(left: 5.0),
                      icon: const Icon(
                        Icons.message,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PostImageCommentScreen(
                                      PostID: widget.Video_id,
                                    )));
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //             NewsFeedCommantScreen(
                        //               newsID:
                        //                   news_feed_controller
                        //                       .newsfeedModel!
                        //                       .data![index]
                        //                       .newsID!,
                        //             )));
                      }),
                  Text(
                    widget.commentCount,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 12, fontFamily: 'PR'),
                  ),
                  IconButton(
                      padding: const EdgeInsets.only(left: 5.0),
                      icon: Image.asset(
                        AssetUtils.like_icon_filled,
                        color: (widget.likestatus == 'false'
                            ? Colors.white
                            : HexColor(CommonColor.pinkFont)),
                        height: 20,
                        width: 20,
                      ),
                      onPressed: () async {
                        await homepageController.PostLikeUnlikeApi(
                            context: context,
                            post_id: widget.Video_id,
                            post_id_type: (widget.likestatus == "true"
                                ? 'unliked'
                                : 'liked'),
                            post_likeStatus: (widget.likestatus == "true"
                                ? 'false'
                                : 'true'));

                        if (homepageController.postLikeUnlikeModel!.error ==
                            false) {
                          print("mmmmm${widget.likeCount}");
                          if (widget.likestatus == "false") {
                            setState(() {
                              widget.likestatus = homepageController
                                  .postLikeUnlikeModel!.user![0].likeStatus!;

                              widget.likeCount = homepageController
                                  .postLikeUnlikeModel!.user![0].likes!;
                            });
                          } else {
                            setState(() {
                              widget.likestatus = 'false';

                              widget.likeCount = homepageController
                                  .postLikeUnlikeModel!.user![0].likes!;
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
                          print("mmmmm${widget.likeCount}");
                        }
                      }),
                  Text(
                    widget.likeCount,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 12, fontFamily: 'PR'),
                  ),
                  IconButton(
                      padding: const EdgeInsets.only(left: 5.0),
                      icon: Image.asset(
                        AssetUtils.share_icon2,
                        color: Colors.white,
                        height: 20,
                        width: 20,
                      ),
                      onPressed: () {
                        // _onShare(
                        //     context: context,
                        //     link:
                        //     "${URLConstants.base_data_url}images/${widget.getDiscoverModel!.data![index].postImage}");
                      }),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ));
  }
}
