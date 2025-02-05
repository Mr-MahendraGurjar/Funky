import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:funky_new/custom_widget/page_loader.dart';
import 'package:funky_new/news_feed/heart_animation_widget.dart';
import 'package:funky_new/news_feed/video_list_class.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:readmore/readmore.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Utils/App_utils.dart';
import '../Utils/asset_utils.dart';
import '../Utils/colorUtils.dart';
import '../drawerScreen.dart';
import 'controller/news_feed_controller.dart';
import 'news_feed_cpmment_screen.dart';

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({super.key});

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  final NewsFeed_screen_controller news_feed_controller = Get.put(
      NewsFeed_screen_controller(),
      tag: NewsFeed_screen_controller().toString());

  bool isLiked = false;
  bool isHeartAnimating = false;

  @override
  void initState() {
    // news_feed_controller.getAllNewsFeedList();
    if (mounted) {
      _incrementCounter();
    }
    super.initState();
  }

  init() {
    // setState(() {
    //   liked = (news_feed_controller
    //                   .newsfeedModel!
    //                   .data![index]
    //                   .feedlikeStatus! == "true" ? true : false);
    // });
    // print("liked -----$liked");
  }

  int _counter = 0;

  _incrementCounter() async {
    for (var i = 0;
        i <= news_feed_controller.newsfeedModel!.advertisers!.length;
        i++) {
      //Loop 100 times
      await Future.delayed(const Duration(seconds: 10), () {
        // Delay 500 milliseconds
        setState(() {
          _counter++; //Increment Counter
        });
        // print(_counter);
      });
      print(i);
      print("i ${news_feed_controller.newsfeedModel!.advertisers!.length}");
      if (i == news_feed_controller.newsfeedModel!.advertisers!.length - 1) {
        print("sie");
        setState(() {
          i = 0;
          _counter = 0;
        });
      }
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        drawer: const DrawerScreen(),
        // appBar: CustomAppbar(
        //   lable_tex: 'News Feed',
        //   // ondrawertap: () {
        //   //   _scaffoldKey.currentState!.openDrawer();
        //   // },
        // ),
        body: RefreshIndicator(
          color: HexColor(CommonColor.pinkFont),
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));
            // updateData();
            news_feed_controller.getAllNewsFeedList();

            print("object");
          },
          child: Container(
            // margin: const EdgeInsets.only(
            //   top: 100,
            // ),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 9,
                ),
                Container(
                  color: Colors.red,
                ),
                Expanded(
                  child: Obx(() => news_feed_controller.isVideoLoading.value !=
                          true
                      ? SingleChildScrollView(
                          child: Column(
                            children: [
                              news_feed_controller
                                      .newsfeedModel!.advertisers!.isEmpty
                                  ? const SizedBox()
                                  : Padding(
                                      padding: const EdgeInsets.only(
                                          left: 13, right: 13),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          color: Colors.white,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              4,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: FadeInImage.assetNetwork(
                                            fit: BoxFit.fill,
                                            image: news_feed_controller
                                                    .newsfeedModel!
                                                    .advertisers!
                                                    .isEmpty
                                                ? ''
                                                : "${URLConstants.base_data_url}images/${news_feed_controller.newsfeedModel?.advertisers?[_counter].bannerImg}",
                                            placeholder:
                                                'assets/images/Funky_App_Icon.png',
                                            imageErrorBuilder: (context, error,
                                                    stackTrace) =>
                                                const Center(
                                                    child:
                                                        Text('No Image Found')),
                                            // color: HexColor(CommonColor.pinkFont),
                                          ),
                                          // Image.network(
                                          //   '${URLConstants
                                          //       .base_data_url}images/${news_feed_controller
                                          //       .newsfeedModel!.advertisers![_counter].bannerImg}',
                                          //   fit: BoxFit.fill,),
                                        ),
                                      ),
                                    ),
                              const SizedBox(
                                height: 10,
                              ),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                padding:
                                    const EdgeInsets.only(bottom: 0, top: 00),
                                shrinkWrap: true,
                                itemCount: news_feed_controller
                                    .newsfeedModel!.data!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Center(
                                    child: Column(
                                      children: [
                                        Container(
                                          child: ListTile(
                                            visualDensity: const VisualDensity(
                                                vertical: 0, horizontal: -4),
                                            dense: true,
                                            leading: SizedBox(
                                              width: 50,
                                              child: CircleAvatar(
                                                radius: 48, // Image radius
                                                backgroundImage: NetworkImage(
                                                  "${URLConstants.base_data_url}images/${news_feed_controller.newsfeedModel!.data![index].logo!}",
                                                ),
                                              ),
                                            ),
                                            title: Text(
                                              news_feed_controller
                                                  .newsfeedModel!
                                                  .data![index]
                                                  .title!,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontFamily: 'PB'),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            final String uri =
                                                news_feed_controller
                                                        .newsfeedModel!
                                                        .data![index]
                                                        .newsFeedUrl ??
                                                    "";
                                            if (await canLaunchUrl(
                                                Uri.parse(uri))) {
                                              await launchUrl(Uri.parse(uri));
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      'cant not launch the url $uri');
                                            }
                                          },
                                          onDoubleTap: () async {
                                            setState(() {
                                              isLiked = true;
                                              isHeartAnimating = true;
                                            });
                                            await news_feed_controller
                                                .FeedLikeUnlikeApi(
                                                    context: context,
                                                    news_post_feedlikeStatus:
                                                        'true',
                                                    news_post_id_type: 'liked',
                                                    news_post_id:
                                                        news_feed_controller
                                                            .newsfeedModel!
                                                            .data![index]
                                                            .newsID!);

                                            if (news_feed_controller
                                                    .feedLikeUnlikeModel!
                                                    .error ==
                                                false) {
                                              setState(() {
                                                news_feed_controller
                                                        .newsfeedModel!
                                                        .data![index]
                                                        .feedLikeCount =
                                                    news_feed_controller
                                                            .feedLikeUnlikeModel
                                                            ?.user?[0]
                                                            .feedLikeCount ??
                                                        '0';

                                                news_feed_controller
                                                        .newsfeedModel!
                                                        .data![index]
                                                        .feedlikeStatus =
                                                    news_feed_controller
                                                            .feedLikeUnlikeModel
                                                            ?.user?[0]
                                                            .feedlikeStatus ??
                                                        "false";
                                              });
                                            }
                                          },
                                          child: Container(
                                            color: Colors.white,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  (news_feed_controller
                                                          .newsfeedModel!
                                                          .data![index]
                                                          .postImage!
                                                          .isNotEmpty
                                                      ? AspectRatio(
                                                          aspectRatio: 5 / 4,
                                                          child: FadeInImage
                                                              .assetNetwork(
                                                            fit: BoxFit.contain,
                                                            image:
                                                                "${URLConstants.base_data_url}images/${news_feed_controller.newsfeedModel!.data![index].postImage}",
                                                            placeholder:
                                                                'assets/images/Funky_App_Icon.png',
                                                          ),
                                                        )
                                                      : (news_feed_controller
                                                              .newsfeedModel!
                                                              .data![index]
                                                              .uploadVideo!
                                                              .isNotEmpty
                                                          ? Videonews(
                                                              play: true,
                                                              url: news_feed_controller
                                                                  .newsfeedModel!
                                                                  .data![index]
                                                                  .uploadVideo!,
                                                            )
                                                          : Center(
                                                              child: GestureDetector(
                                                                  // onTap: _playPause,
                                                                  child: const Icon(
                                                              Icons.play_circle,
                                                              color:
                                                                  Colors.white,
                                                              size: 50,
                                                            ))))),
                                                  Opacity(
                                                    opacity: isHeartAnimating
                                                        ? 1
                                                        : 0,
                                                    child: HeartAnimationWidget(
                                                      isAnimating:
                                                          isHeartAnimating,
                                                      duration: const Duration(
                                                          milliseconds: 900),
                                                      onEnd: () {
                                                        setState(() {
                                                          isHeartAnimating =
                                                              false;
                                                        });
                                                      },
                                                      child: Icon(
                                                        Icons.favorite,
                                                        color: HexColor(
                                                            CommonColor
                                                                .pinkFont),
                                                        size: 100,
                                                      ),
                                                    ),
                                                  )
                                                ]),
                                          ),
                                        ),
                                        Container(
                                            margin: const EdgeInsets.only(
                                                left: 16, top: 13),
                                            alignment: Alignment.centerLeft,
                                            child: ReadMoreText(
                                              news_feed_controller
                                                  .newsfeedModel!
                                                  .data![index]
                                                  .description!,
                                              trimMode: TrimMode.Line,
                                              trimLines: 2,
                                              colorClickableText: Colors.pink,
                                              trimCollapsedText: 'Show more',
                                              trimExpandedText: 'Show less',
                                              moreStyle: const TextStyle(
                                                  color: Colors.pink,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontFamily: 'PR'),
                                            )
                                            // Text(
                                            // news_feed_controller.newsfeedModel!
                                            //     .data![index].description!,
                                            // style: const TextStyle(
                                            //     color: Colors.white,
                                            //     fontSize: 16,
                                            //     fontFamily: 'PR'),
                                            // ),
                                            ),
                                        Container(
                                          child: Row(
                                            children: [
                                              IconButton(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5.0),
                                                  icon: const Icon(
                                                    Icons.message,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                NewsFeedCommantScreen(
                                                                  newsID: news_feed_controller
                                                                      .newsfeedModel!
                                                                      .data![
                                                                          index]
                                                                      .newsID!,
                                                                )));
                                                  }),
                                              Text(
                                                news_feed_controller
                                                    .newsfeedModel!
                                                    .data![index]
                                                    .feedCount!,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontFamily: 'PR'),
                                              ),
                                              IconButton(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5.0),
                                                  icon: Image.asset(
                                                    AssetUtils.like_icon_filled,
                                                    color: (news_feed_controller
                                                                .newsfeedModel!
                                                                .data![index]
                                                                .feedlikeStatus ==
                                                            'false'
                                                        ? Colors.white
                                                        : HexColor(CommonColor
                                                            .pinkFont)),
                                                    height: 20,
                                                    width: 20,
                                                  ),
                                                  onPressed: () async {
                                                    await news_feed_controller.FeedLikeUnlikeApi(
                                                        context: context,
                                                        news_post_feedlikeStatus:
                                                            (news_feed_controller
                                                                        .newsfeedModel!
                                                                        .data![
                                                                            index]
                                                                        .feedlikeStatus! ==
                                                                    "true"
                                                                ? 'false'
                                                                : 'true'),
                                                        news_post_id_type:
                                                            (news_feed_controller
                                                                        .newsfeedModel!
                                                                        .data![
                                                                            index]
                                                                        .feedlikeStatus! ==
                                                                    "true"
                                                                ? 'unliked'
                                                                : 'liked'),
                                                        news_post_id:
                                                            news_feed_controller
                                                                .newsfeedModel!
                                                                .data![index]
                                                                .newsID!);

                                                    if (news_feed_controller
                                                            .feedLikeUnlikeModel!
                                                            .error ==
                                                        false) {
                                                      // if (news_feed_controller
                                                      //         .feedLikeUnlikeModel!
                                                      //         .user![0]
                                                      //         .feedlikeStatus ==
                                                      //     'false') {
                                                      //   setState(() {
                                                      //     liked = false;
                                                      //   });
                                                      // } else {
                                                      //   setState(() {
                                                      //     liked = true;
                                                      //   });
                                                      // }

                                                      setState(() {
                                                        news_feed_controller
                                                                .newsfeedModel!
                                                                .data![index]
                                                                .feedLikeCount =
                                                            news_feed_controller
                                                                    .feedLikeUnlikeModel
                                                                    ?.user?[0]
                                                                    .feedLikeCount ??
                                                                '0';

                                                        news_feed_controller
                                                                .newsfeedModel!
                                                                .data![index]
                                                                .feedlikeStatus =
                                                            news_feed_controller
                                                                    .feedLikeUnlikeModel
                                                                    ?.user?[0]
                                                                    .feedlikeStatus ??
                                                                'false';
                                                      });
                                                    }
                                                  }),
                                              Text(
                                                news_feed_controller
                                                        .newsfeedModel
                                                        ?.data?[index]
                                                        .feedLikeCount ??
                                                    '0',
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontFamily: 'PR'),
                                              ),
                                              IconButton(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5.0),
                                                  icon: Image.asset(
                                                    AssetUtils.share_icon2,
                                                    color: Colors.white,
                                                    height: 20,
                                                    width: 20,
                                                  ),
                                                  onPressed: () {
                                                    _onShare(
                                                        context: context,
                                                        link:
                                                            "${URLConstants.base_data_url}images/${news_feed_controller.newsfeedModel!.data![index].postImage}",
                                                        description:
                                                            '${news_feed_controller.newsfeedModel!.data![index].description}');
                                                  }),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        )
                      : Center(
                          child: Container(
                              height: 80,
                              width: 100,
                              color: Colors.transparent,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  CircularProgressIndicator(
                                    color: HexColor(CommonColor.pinkFont),
                                  ),
                                ],
                              )
                              // Material(
                              //   c``olor: Colors.transparent,
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
                        )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onShare(
      {required BuildContext context,
      required String link,
      required String description}) async {
    try {
      showLoader(context);
      // Initialize Dio
      Dio dio = Dio();
      // Get the temporary directory
      final tempDir = await getTemporaryDirectory();
      // Create a temporary file path
      final filePath = '${tempDir.path}/downloaded_image.jpg';
      // Download the image and save it to the file
      await dio.download(link, filePath);
      final xFile = XFile(filePath);
      Share.shareXFiles([xFile], text: description);
      hideLoader(context);
    } catch (e) {
      throw Exception('Failed to download image: $e');
    }
  }
}
