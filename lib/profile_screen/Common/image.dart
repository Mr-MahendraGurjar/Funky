import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:funky_new/Utils/toaster_widget.dart';
import 'package:funky_new/homepage/ui/post_image_commet_scren.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
// import 'package:funky_project/Utils/colorUtils.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:readmore/readmore.dart';

import '../../Utils/App_utils.dart';
import '../../Utils/asset_utils.dart';
import '../../Utils/colorUtils.dart';
import '../../homepage/controller/homepage_controller.dart';
import '../../news_feed/heart_animation_widget.dart';
import '../../settings/report_video/report_problem.dart';
import '../../sharePreference.dart';
import '../model/galleryModel.dart';
import '../model/postdeleteModel.dart';
import '../profile_controller.dart';

class CommonImageP extends StatefulWidget {
  final String useerName;
  final String Imageurl;

  final String SocialProfileUrl;
  final String ProfileUrl;
  final String description;

  final String enable_download;
  final String enable_comment;
  final String comment_count;
  final String user_id;
  final Data_profile_image? imageModel;

  final String image_id;
  String image_like_count;
  String image_like_status;

  CommonImageP(
      {super.key,
      required this.useerName,
      required this.Imageurl,
      required this.SocialProfileUrl,
      required this.ProfileUrl,
      required this.description,
      required this.image_like_count,
      required this.image_like_status,
      required this.image_id,
      required this.enable_download,
      required this.enable_comment,
      required this.comment_count,
      required this.imageModel,
      required this.user_id});

  @override
  State<CommonImageP> createState() => _CommonImagePState();
}

class _CommonImagePState extends State<CommonImageP> {
  final bool _onTouch = false;
  Timer? _timer;
  bool isClicked = false; // boolean that states if the button is pressed or not

  bool isLiked = false;
  bool isHeartAnimating = false;

  final HomepageController homepageController =
      Get.put(HomepageController(), tag: HomepageController().toString());

  @override
  void initState() {
    init();
    super.initState();
  }

  String dropdownvalue = 'Apple';

  final int _currentPage = 0;

  bool download_bool = false;

  String? id_User;

  init() async {
    String idUser = await PreferenceManager().getPref(URLConstants.id);
    print(idUser);
    print(widget.user_id);
    setState(() {
      id_User = idUser;
    });
  }

  download() async {
    setState(() {
      download_bool = true;
    });
    String url = '${URLConstants.base_data_url}images/${widget.Imageurl}';
    final tempDir = await getTemporaryDirectory();
    final path = '${tempDir.path}/funkyImage.jpg';
    await Dio().download(url, path);
    await GallerySaver.saveImage(path);
    setState(() {
      download_bool = false;
    });
    CommonWidget().showToaster(msg: "Image Downloaded");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          actions: [
            Container(
              width: 50,
              margin: const EdgeInsets.only(right: 0),
              // color: Colors.pink,
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  // isExpanded: true,
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
                                        post_id: widget.image_id);
                                  },
                                  child: const Text("Delete",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'PR'))),
                              DropdownMenuItem(
                                  value: "items2",
                                  onTap: () {
                                    print('');
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
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ReportProblem(
                                                  receiver_id: widget.user_id,
                                                  type: 'post',
                                                  type_id: widget.image_id,
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
                                    print('');
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
                                        post_id: widget.image_id);
                                  },
                                  child: const Text("Delete",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'PR'))),
                              // DropdownMenuItem(
                              //     value: "items2",
                              //     onTap: () {},
                              //     child: Text("Download",
                              //         style: TextStyle(
                              //             color: Colors.white,
                              //             fontSize: 16,
                              //             fontFamily: 'PR'))),
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
                                                  type_id: widget.image_id,
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
                    setState(() {});
                  },
                  // iconSize: 25,
                  // icon: IconButton(
                  //   icon: Icon(
                  //     Icons.more_vert,
                  //     color: Colors.white,
                  //     size: 20,
                  //   ),
                  //   onPressed: () {
                  //     print("Dadadadada");
                  //   },
                  // ),

                  // iconEnabledColor: Color(0xff007DEF),
                  // iconDisabledColor: Color(0xff007DEF),
                  // buttonHeight: 50,
                  // buttonWidth: 100,
                  enableFeedback: true,
                  // buttonPadding: const EdgeInsets.only(left: 15, right: 15),
                  // buttonDecoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.transparent),
                  // buttonElevation: 0,
                  // itemHeight: 40,
                  // itemPadding: const EdgeInsets.only(left: 14, right: 14),
                  // dropdownMaxHeight: 200,
                  // dropdownWidth: 100,
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
            ),
          ],
        ),
        body: Stack(
          children: [
            GestureDetector(
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
                              child: SizedBox(
                                height: 80,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      color: HexColor(CommonColor.pinkFont),
                                      strokeWidth: 4,
                                    ),
                                  ],
                                ),
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
                        margin: const EdgeInsets.only(bottom: 30, left: 21),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Align(
                              alignment: Alignment.bottomRight,
                              child: SizedBox(
                                child: Container(
                                  color: Colors.transparent,
                                  width: 50,
                                  margin: const EdgeInsets.only(
                                      bottom: 0, right: 21, left: 20.0),
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
                                      Container(
                                        child: Text(widget.image_like_count,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontFamily: 'PR')),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      (widget.enable_comment == 'true'
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
                                                      widget.comment_count,
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12,
                                                          fontFamily: 'PR')),
                                                ),
                                              ],
                                            )
                                          : const SizedBox.shrink()),
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
                                      IconButton(
                                        visualDensity:
                                            const VisualDensity(vertical: -4),
                                        iconSize: 30.0,
                                        padding:
                                            const EdgeInsets.only(left: 0.0),
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
                              visualDensity: const VisualDensity(
                                  vertical: 4, horizontal: -4),
                              // tileColor: Colors.white,
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      (widget.ProfileUrl.isNotEmpty
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
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
                                                  borderRadius:
                                                      BorderRadius.circular(50),
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
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.useerName,
                                            style: TextStyle(
                                                color: HexColor('#D4D4D4'),
                                                fontFamily: "PB",
                                                fontSize: 14),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
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
        await _profile_screen_controller.get_gallery_list(
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
