import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:funky_new/search_screen/search__screen_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

import '../Utils/App_utils.dart';
import '../custom_widget/loader_page.dart';
import '../sharePreference.dart';
import 'discoverImageClass.dart';
import 'discoverVideoClass.dart';
import 'model/getDiscoverModel.dart';
import 'model/randomPostsModel.dart';

class DiscoverFeedScreen extends StatefulWidget {
  final int index_;
  final bool hash;
  final String post_id;
  final GetDiscoverModel? getDiscoverModel;

  const DiscoverFeedScreen(
      {Key? key, this.getDiscoverModel, required this.index_, required this.post_id, required this.hash})
      : super(key: key);

  @override
  State<DiscoverFeedScreen> createState() => _DiscoverFeedScreenState();
}

class _DiscoverFeedScreenState extends State<DiscoverFeedScreen> {
  ScrollController scrollController = ScrollController(
    initialScrollOffset: 10, // or whatever offset you wish
    keepScrollOffset: true,
  );

  final Search_screen_controller _search_screen_controller =
      Get.put(Search_screen_controller(), tag: Search_screen_controller().toString());

  @override
  void initState() {
    // TODO: implement initState
    getUserList(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text(
            'Explore',
            style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'PB'),
          ),
          centerTitle: true,
          leadingWidth: 100,
        ),
      ),
      body: (isSearchLoading
          ? Center(child: LoaderPage())
          : PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: randomPostsModel!.data!.length,
              // pageSnapping: false,
              allowImplicitScrolling: true,
              onPageChanged: (value) {
                DiscoverVideoClassState.controller!.pause();
                setState(() {});
              },
              // controller: PageController(
              //   initialPage: widget.index_,
              //   keepPage: true,
              // ),
              itemBuilder: (BuildContext context, int index) {
                return (widget.hash
                    ? (widget.getDiscoverModel!.data![index].postImage!.isNotEmpty
                        ? DiscoverImageClass(
                            Image_id: widget.getDiscoverModel!.data![index].iD!,
                            play: true,
                            imageName: widget.getDiscoverModel!.data![index].postImage!,
                            imageUrl: widget.getDiscoverModel!.data![index].user!.image!,
                            likeCount: widget.getDiscoverModel!.data![index].likes!,
                            Fullname: widget.getDiscoverModel!.data![index].user!.fullName!,
                            likestatus: widget.getDiscoverModel!.data![index].likeStatus!,
                            ProfileUrl: widget.getDiscoverModel!.data![index].user!.profileUrl!,
                            commentCount: widget.getDiscoverModel!.data![index].commentCount!,
                            description: widget.getDiscoverModel!.data![index].description!,
                          )
                        : DiscoverVideoClass(
                            Video_id: widget.getDiscoverModel!.data![index].iD!,
                            play: false,
                            videoUrl: widget.getDiscoverModel!.data![index].uploadVideo!,
                            imageUrl: widget.getDiscoverModel!.data![index].user!.image!,
                            likeCount: widget.getDiscoverModel!.data![index].likes!,
                            Fullname: widget.getDiscoverModel!.data![index].user!.fullName!,
                            likestatus: widget.getDiscoverModel!.data![index].likeStatus!,
                            ProfileUrl: widget.getDiscoverModel!.data![index].user!.profileUrl!,
                            commentCount: widget.getDiscoverModel!.data![index].commentCount!,
                            description: widget.getDiscoverModel!.data![index].description!,
                          ))
                    : (randomPostsModel!.data![index].postImage!.isNotEmpty
                        ? DiscoverImageClass(
                            Image_id: randomPostsModel!.data![index].iD!,
                            play: true,
                            imageName: randomPostsModel!.data![index].postImage!,
                            imageUrl: randomPostsModel!.data![index].user!.image!,
                            likeCount: randomPostsModel!.data![index].likes!,
                            Fullname: randomPostsModel!.data![index].user!.fullName!,
                            likestatus: randomPostsModel!.data![index].likeStatus!,
                            ProfileUrl: randomPostsModel!.data![index].user!.profileUrl!,
                            commentCount: randomPostsModel!.data![index].commentCount!,
                            description: randomPostsModel!.data![index].description!,
                          )
                        : DiscoverVideoClass(
                            Video_id: randomPostsModel!.data![index].iD!,
                            play: false,
                            videoUrl: randomPostsModel!.data![index].uploadVideo!,
                            imageUrl: randomPostsModel!.data![index].user!.image!,
                            likeCount: randomPostsModel!.data![index].likes!,
                            Fullname: randomPostsModel!.data![index].user!.fullName!,
                            likestatus: randomPostsModel!.data![index].likeStatus!,
                            ProfileUrl: randomPostsModel!.data![index].user!.profileUrl!,
                            commentCount: randomPostsModel!.data![index].commentCount!,
                            description: randomPostsModel!.data![index].description!,
                          )));
                //   Column(
                //   mainAxisSize: MainAxisSize.min,
                //   children: [
                //     SizedBox(
                //       height: 10,
                //     ),
                //     Container(
                //       child: ListTile(
                //         visualDensity: VisualDensity(vertical: 0, horizontal: -4),
                //         dense: true,
                //         leading: Container(
                //           width: 50,
                //           child: ClipRRect(
                //             borderRadius: BorderRadius.circular(50),
                //             child: (randomPostsModel!.data![index].user!
                //                 .profileUrl!.isNotEmpty
                //                 ? Image.network(widget
                //                 .getDiscoverModel!.data![index].user!.profileUrl!)
                //             // FadeInImage.assetNetwork(
                //             //         height: 80,
                //             //         width: 80,
                //             //         fit: BoxFit.cover,
                //             //         placeholder:
                //             //             'assets/images/Funky_App_Icon.png',
                //             //         image: _search_screen_controller
                //             //             .searchlistModel!
                //             //             .data![index]
                //             //             .profileUrl!,
                //             //       )
                //                 :
                //             // Container(
                //             //   height: 50,
                //             //   width: 50,
                //             //   child: ClipRRect(
                //             //     borderRadius: BorderRadius.circular(50),
                //             //     child: Image.network(
                //             //       _search_screen_controller
                //             //           .searchlistModel!
                //             //           .data![index]
                //             //           .profileUrl!, fit: BoxFit.fill,),
                //             //   ),
                //             // )
                //             (randomPostsModel!.data![index].user!.image!
                //                 .isNotEmpty
                //                 ? FadeInImage.assetNetwork(
                //               height: 80,
                //               width: 80,
                //               fit: BoxFit.cover,
                //               image:
                //               "${URLConstants.base_data_url}images/${widget
                //                   .getDiscoverModel!.data![index].user!.image}",
                //               placeholder:
                //               'assets/images/Funky_App_Icon.png',
                //             )
                //                 : Container(
                //                 child: Image.asset(
                //                     'assets/images/Funky_App_Icon.png')))),
                //           ),
                //         ),
                //         //
                //         // Container(
                //         //     height: 50,
                //         //     decoration: BoxDecoration(
                //         //       borderRadius: BorderRadius.circular(50),
                //         //       color: Colors.white,
                //         //     ),
                //         //     child: ClipRRect(
                //         //       borderRadius: BorderRadius.circular(50),
                //         //       child: IconButton(
                //         //         onPressed: () {},
                //         //         icon: Image.asset(
                //         //           AssetUtils.image1,
                //         //           fit: BoxFit.fill,
                //         //         ),
                //         //       ),
                //         //     )),
                //         title: Text(
                //           randomPostsModel!.data![index].user!.fullName!,
                //           style: TextStyle(
                //               color: Colors.white, fontSize: 14, fontFamily: 'PB'),
                //         ),
                //         // trailing: IconButton(
                //         //   icon: Icon(
                //         //     Icons.more_vert,
                //         //     color: Colors.white,
                //         //     size: 20,
                //         //   ),
                //         //   onPressed: () {},
                //         // ),
                //       ),
                //     ),
                //     const SizedBox(
                //       height: 10,
                //     ),
                //     (randomPostsModel!.data![index].postImage!.isNotEmpty
                //         ? GestureDetector(
                //       // onDoubleTap: () async {
                //       //   setState(() {
                //       //     isLiked = true;
                //       //     isHeartAnimating = true;
                //       //   });
                //       //   await news_feed_controller.FeedLikeUnlikeApi(
                //       //       context: context,
                //       //       news_post_feedlikeStatus: 'true',
                //       //       news_post_id_type: 'liked',
                //       //       news_post_id: news_feed_controller
                //       //           .newsfeedModel!.data![index].newsID!);
                //       //
                //       //   if (news_feed_controller
                //       //           .feedLikeUnlikeModel!.error ==
                //       //       false) {
                //       //     print(
                //       //         "vvvv${news_feed_controller.newsfeedModel!.data![index].feedLikeCount}");
                //       //
                //       //     setState(() {
                //       //       news_feed_controller.newsfeedModel!
                //       //               .data![index].feedLikeCount =
                //       //           news_feed_controller
                //       //               .feedLikeUnlikeModel!
                //       //               .user![0]
                //       //               .feedLikeCount;
                //       //
                //       //       news_feed_controller.newsfeedModel!
                //       //               .data![index].feedlikeStatus =
                //       //           news_feed_controller
                //       //               .feedLikeUnlikeModel!
                //       //               .user![0]
                //       //               .feedlikeStatus!;
                //       //     });
                //       //
                //       //     print(
                //       //         "mmmm${news_feed_controller.newsfeedModel!.data![index].feedLikeCount}");
                //       //   }
                //       //   // setState(() {
                //       //   //   liked = true;
                //       //   // });
                //       // },
                //       child: AspectRatio(
                //         aspectRatio: 5 / 5,
                //         child: Container(
                //           color: Colors.black,
                //           child: FadeInImage.assetNetwork(
                //             fit: BoxFit.contain,
                //             image:
                //             "${URLConstants.base_data_url}images/${widget
                //                 .getDiscoverModel!.data![index].postImage}",
                //             placeholder:
                //             'assets/images/Funky_App_Icon.png',
                //           ),
                //         ),
                //       ),
                //     )
                //         : (randomPostsModel!.data![index].uploadVideo!
                //         .isNotEmpty
                //         ? GestureDetector(
                //       // onDoubleTap: () async {
                //       //   setState(() {
                //       //     isLiked = true;
                //       //     isHeartAnimating = true;
                //       //   });
                //       //   await news_feed_controller.FeedLikeUnlikeApi(
                //       //       context: context,
                //       //       news_post_feedlikeStatus: 'true',
                //       //       news_post_id_type: 'liked',
                //       //       news_post_id: news_feed_controller
                //       //           .newsfeedModel!.data![index].newsID!);
                //       //
                //       //   if (news_feed_controller
                //       //           .feedLikeUnlikeModel!.error ==
                //       //       false) {
                //       //     print(
                //       //         "vvvv${news_feed_controller.newsfeedModel!.data![index].feedLikeCount}");
                //       //
                //       //     setState(() {
                //       //       news_feed_controller.newsfeedModel!
                //       //               .data![index].feedLikeCount =
                //       //           news_feed_controller
                //       //               .feedLikeUnlikeModel!
                //       //               .user![0]
                //       //               .feedLikeCount;
                //       //
                //       //       news_feed_controller.newsfeedModel!
                //       //               .data![index].feedlikeStatus =
                //       //           news_feed_controller
                //       //               .feedLikeUnlikeModel!
                //       //               .user![0]
                //       //               .feedlikeStatus!;
                //       //     });
                //       //
                //       //     print(
                //       //         "mmmm${news_feed_controller.newsfeedModel!.data![index].feedLikeCount}");
                //       //   }
                //       //   // setState(() {
                //       //   //   liked = true;
                //       //   // });
                //       // },
                //       child: AspectRatio(
                //         aspectRatio: 5 / 5,
                //         child: Container(
                //           color: Colors.white,
                //           child:
                //           DiscoverVideoClass(
                //             play: true,
                //             videoUrl: randomPostsModel!
                //                 .data![index].uploadVideo!,
                //             imageUrl:  randomPostsModel!
                //                 .data![index].user!.image!,
                //             likeCount: randomPostsModel!
                //                 .data![index].likes!,
                //             Fullname: randomPostsModel!
                //                 .data![index].user!.fullName!,
                //             likestatus: randomPostsModel!
                //                 .data![index].likeStatus!,
                //             ProfileUrl: randomPostsModel!
                //                 .data![index].user!.profileUrl!,
                //             commentCount: randomPostsModel!
                //                 .data![index].commentCount!,
                //             description: randomPostsModel!
                //                 .data![index].description!,
                //           ),
                //         ),
                //       ),
                //     )
                //         : GestureDetector(
                //       // onDoubleTap: () async {
                //       //   setState(() {
                //       //     isLiked = true;
                //       //     isHeartAnimating = true;
                //       //   });
                //       //   await news_feed_controller.FeedLikeUnlikeApi(
                //       //       context: context,
                //       //       news_post_feedlikeStatus: 'true',
                //       //       news_post_id_type: 'liked',
                //       //       news_post_id: news_feed_controller
                //       //           .newsfeedModel!.data![index].newsID!);
                //       //
                //       //   if (news_feed_controller
                //       //           .feedLikeUnlikeModel!.error ==
                //       //       false) {
                //       //     print(
                //       //         "vvvv${news_feed_controller.newsfeedModel!.data![index].feedLikeCount}");
                //       //
                //       //     setState(() {
                //       //       news_feed_controller.newsfeedModel!
                //       //               .data![index].feedLikeCount =
                //       //           news_feed_controller
                //       //               .feedLikeUnlikeModel!
                //       //               .user![0]
                //       //               .feedLikeCount;
                //       //
                //       //       news_feed_controller.newsfeedModel!
                //       //               .data![index].feedlikeStatus =
                //       //           news_feed_controller
                //       //               .feedLikeUnlikeModel!
                //       //               .user![0]
                //       //               .feedlikeStatus!;
                //       //     });
                //       //
                //       //     print(
                //       //         "mmmm${news_feed_controller.newsfeedModel!.data![index].feedLikeCount}");
                //       //   }
                //       //   // setState(() {
                //       //   //   liked = true;
                //       //   // });
                //       // },
                //       child: AspectRatio(
                //         aspectRatio: 5 / 5,
                //         child: Container(
                //           color: Colors.black,
                //           child:
                //           Stack(alignment: Alignment.center, children: [
                //             Center(
                //                 child: GestureDetector(
                //                   // onTap: _playPause,
                //                     child: Icon(
                //                       Icons.play_circle,
                //                       color: Colors.white,
                //                       size: 50,
                //                     )))
                //             // Opacity(
                //             //   opacity: isHeartAnimating ? 1 : 0,
                //             //   child: HeartAnimationWidget(
                //             //     isAnimating: isHeartAnimating,
                //             //     duration: Duration(milliseconds: 900),
                //             //     onEnd: () {
                //             //       setState(() {
                //             //         isHeartAnimating = false;
                //             //       });
                //             //     },
                //             //     child: Icon(
                //             //       Icons.favorite,
                //             //       color:
                //             //           HexColor(CommonColor.pinkFont),
                //             //       size: 100,
                //             //     ),
                //             //   ),
                //             // )
                //           ]),
                //         ),
                //       ),
                //     ))),
                //     Container(
                //       margin: EdgeInsets.only(left: 16, top: 13),
                //       alignment: Alignment.centerLeft,
                //       child: Text(
                //         randomPostsModel!.data![index].description!,
                //         style: TextStyle(
                //             color: Colors.white, fontSize: 16, fontFamily: 'PR'),
                //       ),
                //     ),
                //     Container(
                //       child: Row(
                //         children: [
                //           IconButton(
                //               padding: EdgeInsets.only(left: 5.0),
                //               icon: Icon(
                //                 Icons.message,
                //                 color: Colors.white,
                //               ),
                //               onPressed: () {
                //                 // Navigator.push(
                //                 //     context,
                //                 //     MaterialPageRoute(
                //                 //         builder: (context) =>
                //                 //             NewsFeedCommantScreen(
                //                 //               newsID:
                //                 //                   news_feed_controller
                //                 //                       .newsfeedModel!
                //                 //                       .data![index]
                //                 //                       .newsID!,
                //                 //             )));
                //               }),
                //           Text(
                //             randomPostsModel!.data![index].commentCount!,
                //             style: TextStyle(
                //                 color: Colors.white, fontSize: 12, fontFamily: 'PR'),
                //           ),
                //           IconButton(
                //               padding: EdgeInsets.only(left: 5.0),
                //               icon: Image.asset(
                //                 AssetUtils.like_icon_filled,
                //                 color: (randomPostsModel!.data![index]
                //                     .likeStatus ==
                //                     'false'
                //                     ? Colors.white
                //                     : HexColor(CommonColor.pinkFont)),
                //                 height: 20,
                //                 width: 20,
                //               ),
                //               onPressed: () async {
                //                 // await news_feed_controller.FeedLikeUnlikeApi(
                //                 //     context: context,
                //                 //     news_post_feedlikeStatus:
                //                 //         (news_feed_controller
                //                 //                     .newsfeedModel!
                //                 //                     .data![index]
                //                 //                     .feedlikeStatus! ==
                //                 //                 "true"
                //                 //             ? 'false'
                //                 //             : 'true'),
                //                 //     news_post_id_type:
                //                 //         (news_feed_controller
                //                 //                     .newsfeedModel!
                //                 //                     .data![index]
                //                 //                     .feedlikeStatus! ==
                //                 //                 "true"
                //                 //             ? 'unliked'
                //                 //             : 'liked'),
                //                 //     news_post_id: news_feed_controller
                //                 //         .newsfeedModel!
                //                 //         .data![index]
                //                 //         .newsID!);
                //                 //
                //                 // if (news_feed_controller
                //                 //         .feedLikeUnlikeModel!.error ==
                //                 //     false) {
                //                 //   // if (news_feed_controller
                //                 //   //         .feedLikeUnlikeModel!
                //                 //   //         .user![0]
                //                 //   //         .feedlikeStatus ==
                //                 //   //     'false') {
                //                 //   //   setState(() {
                //                 //   //     liked = false;
                //                 //   //   });
                //                 //   // } else {
                //                 //   //   setState(() {
                //                 //   //     liked = true;
                //                 //   //   });
                //                 //   // }
                //                 //
                //                 //   print(
                //                 //       "vvvv${news_feed_controller.newsfeedModel!.data![index].feedLikeCount}");
                //                 //
                //                 //   setState(() {
                //                 //     news_feed_controller
                //                 //             .newsfeedModel!
                //                 //             .data![index]
                //                 //             .feedLikeCount =
                //                 //         news_feed_controller
                //                 //             .feedLikeUnlikeModel!
                //                 //             .user![0]
                //                 //             .feedLikeCount;
                //                 //
                //                 //     news_feed_controller
                //                 //             .newsfeedModel!
                //                 //             .data![index]
                //                 //             .feedlikeStatus =
                //                 //         news_feed_controller
                //                 //             .feedLikeUnlikeModel!
                //                 //             .user![0]
                //                 //             .feedlikeStatus!;
                //                 //   });
                //                 //
                //                 //   print(
                //                 //       "mmmm${news_feed_controller.newsfeedModel!.data![index].feedLikeCount}");
                //                 // }
                //               }),
                //           Text(
                //             randomPostsModel!.data![index].likes!,
                //             style: TextStyle(
                //                 color: Colors.white, fontSize: 12, fontFamily: 'PR'),
                //           ),
                //           IconButton(
                //               padding: EdgeInsets.only(left: 5.0),
                //               icon: Image.asset(
                //                 AssetUtils.share_icon2,
                //                 color: Colors.white,
                //                 height: 20,
                //                 width: 20,
                //               ),
                //               onPressed: () {
                //                 _onShare(
                //                     context: context,
                //                     link:
                //                     "${URLConstants.base_data_url}images/${widget
                //                         .getDiscoverModel!.data![index].postImage}");
                //               }),
                //         ],
                //       ),
                //     ),
                //     SizedBox(
                //       height: 10,
                //     )
                //   ],
                // );
              },
            )),
    );
  }

  RandomPostsModel? randomPostsModel;
  bool isSearchLoading = false;

  Future<dynamic> getUserList(BuildContext context) async {
    setState(() {
      isSearchLoading = true;
    });
    String id_user = await PreferenceManager().getPref(URLConstants.id);

    String url =
        "${URLConstants.base_url + URLConstants.randomPostListApi}?post_id=${widget.post_id}&userId=${id_user}";

    // debugPrint('Get Sales Token ${tokens.toString()}');
    // try {
    // } catch (e) {
    //   print('1-1-1-1 Get Purchase ${e.toString()}');
    // }

    http.Response response = await http.get(Uri.parse(url));

    print('Response request: ${response.request}');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = convert.jsonDecode(response.body);
      randomPostsModel = RandomPostsModel.fromJson(data);
      // getVideoModelList(searchlistModel);
      if (randomPostsModel!.error == false) {
        debugPrint('2-2-2-2-2-2 Inside the product Controller Details ${randomPostsModel!.data!.length}');
        setState(() {
          isSearchLoading = false;
        }); // CommonWidget().showToaster(msg: data["success"].toString());
        return randomPostsModel;
      } else {
        setState(() {
          isSearchLoading = false;
        });
        // CommonWidget().showToaster(msg: msg.toString());
        return null;
      }
    } else if (response.statusCode == 422) {
      setState(() {
        isSearchLoading = false;
      });
      // CommonWidget().showToaster(msg: msg.toString());
    } else if (response.statusCode == 401) {
      setState(() {
        isSearchLoading = false;
      });
      // CommonService().unAuthorizedUser();
    } else {
      setState(() {
        isSearchLoading = false;
      });
      // CommonWidget().showToaster(msg: msg.toString());
    }
  }

  void _onShare({required BuildContext context, required String link}) async {
    Share.share(link, subject: 'Share App');
  }
}
