import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../Utils/App_utils.dart';
import '../Utils/asset_utils.dart';
import '../Utils/colorUtils.dart';
import '../homepage/controller/homepage_controller.dart';
import '../homepage/ui/post_image_commet_scren.dart';
import '../news_feed/heart_animation_widget.dart';

class DiscoverImageClass extends StatefulWidget {
  final bool play;
  final String Image_id;
  final String imageName;
  final String ProfileUrl;
  final String imageUrl;
  final String Fullname;
  final String description;
  final String commentCount;
  String likeCount;
  String likestatus;

  DiscoverImageClass(
      {super.key,
      required this.play,
      required this.imageName,
      required this.ProfileUrl,
      required this.imageUrl,
      required this.Fullname,
      required this.description,
      required this.commentCount,
      required this.likeCount,
      required this.likestatus,
      required this.Image_id});

  @override
  State<DiscoverImageClass> createState() => _DiscoverImageClassState();
}

class _DiscoverImageClassState extends State<DiscoverImageClass> {
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
            Stack(
              alignment: Alignment.center,
              children: [
                GestureDetector(
                  onDoubleTap: () async {
                    setState(() {
                      isLiked = true;
                      isHeartAnimating = true;
                    });
                    await homepageController.PostLikeUnlikeApi(
                        context: context,
                        post_id: widget.Image_id,
                        post_id_type:
                            (widget.likestatus == "true" ? 'unliked' : 'liked'),
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
                  child: AspectRatio(
                    aspectRatio: 5 / 5,
                    child: Container(
                      color: Colors.black,
                      child: FadeInImage.assetNetwork(
                        fit: BoxFit.contain,
                        image:
                            "${URLConstants.base_data_url}images/${widget.imageName}",
                        placeholder: 'assets/images/Funky_App_Icon.png',
                      ),
                    ),
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
                                      PostID: widget.Image_id,
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
                            post_id: widget.Image_id,
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
