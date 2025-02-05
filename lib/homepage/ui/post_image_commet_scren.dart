import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

import '../../Utils/App_utils.dart';
import '../../Utils/asset_utils.dart';
import '../../Utils/colorUtils.dart';
import '../../Utils/toaster_widget.dart';
import '../../custom_widget/loader_page.dart';
import '../../settings/report_video/report_problem.dart';
import '../../sharePreference.dart';
import '../controller/homepage_controller.dart';
import '../model/commentactionModel.dart';

class PostImageCommentScreen extends StatefulWidget {
  final String PostID;
  final String? post_user_id;

  const PostImageCommentScreen(
      {super.key, required this.PostID, this.post_user_id});

  @override
  State<PostImageCommentScreen> createState() => _PostImageCommentScreenState();
}

class _PostImageCommentScreenState extends State<PostImageCommentScreen> {
  final HomepageController homepageController =
      Get.put(HomepageController(), tag: HomepageController().toString());
  FocusNode? focusNode;

  @override
  void initState() {
    init();
    focusNode = FocusNode();
    super.initState();
  }

  init() async {
    await data_compression();
    homepageController.Replyname_controller = '';
    await homepageController.getPostCommments(
        newsfeedID: widget.PostID, context: context);
  }

  String? id_user;
  String? comment_id;
  bool post_mine = false;
  bool comment_mine = false;
  bool comment_edit_bool = false;

  data_compression() async {
    id_user = await PreferenceManager().getPref(URLConstants.id);
    if (id_user == widget.post_user_id) {
      setState(() {
        post_mine = true;
      });
    } else {
      setState(() {
        post_mine = false;
      });
    }
  }

  // List<DropdownMenuItem<String>> items_report = [
  //   DropdownMenuItem(
  //       value: "Apple",
  //       child: Text("Report",
  //           style: TextStyle(
  //               color: Colors.white, fontSize: 16, fontFamily: 'PR'))),
  // ];
  // List<DropdownMenuItem<String>> edit_delete = [
  //   DropdownMenuItem(
  //       value: "Apple",
  //       child: Text("Edit",
  //           style: TextStyle(
  //               color: Colors.white, fontSize: 16, fontFamily: 'PR'))),
  //   DropdownMenuItem(
  //       value: "items2",
  //       child: Text("Delete",
  //           style: TextStyle(
  //               color: Colors.white, fontSize: 16, fontFamily: 'PR'))),
  // ];
  // static List<DropdownMenuItem<String>> report_delete = [
  //   DropdownMenuItem(
  //       value: "Apple",
  //       child: Text("Report",
  //           style: TextStyle(
  //               color: Colors.white, fontSize: 16, fontFamily: 'PR'))),
  //   DropdownMenuItem(
  //       value: "items2",
  //       onTap: () {
  //         comment_action_api(
  //             context: context,
  //             comment_id: comment_id,
  //             action: action,
  //             post_type: post_type,
  //             message: message);
  //       },
  //       child: Text("Delete",
  //           style: TextStyle(
  //               color: Colors.white, fontSize: 16, fontFamily: 'PR'))),
  // ];

  String dropdownvalue = 'Apple';
  bool location_tap = false;

  FocusNode Email_Focus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        setState(() {
          location_tap = false;
        });
        homepageController.Replyname_controller = '';
        homepageController.Replying_comment_id = '';
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text(
            "Comments",
            style:
                TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'PR'),
          ),
          backgroundColor: Colors.black,
        ),
        body: RefreshIndicator(
          color: HexColor(CommonColor.pinkFont),
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));
            // updateData();
            homepageController.getPostCommments(
                newsfeedID: widget.PostID, context: context);
            // news_feed_controller.getAllNewsFeedList();

            print("object");
          },
          child: Stack(
            children: [
              Obx(
                () => homepageController.iscommentsLoading.value != true
                    ? SizedBox(
                        height: double.maxFinite,
                        child: Stack(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(bottom: 80),
                              itemCount: homepageController
                                  .postcommentModel!.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Column(
                                  children: [
                                    ListTile(
                                      leading: SizedBox(
                                          height: 50,
                                          width: 50,
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: (homepageController
                                                      .postcommentModel!
                                                      .data![index]
                                                      .user!
                                                      .profileUrl!
                                                      .isNotEmpty
                                                  ? Image.network(
                                                      homepageController
                                                          .postcommentModel!
                                                          .data![index]
                                                          .user!
                                                          .profileUrl!,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : (homepageController
                                                          .postcommentModel!
                                                          .data![index]
                                                          .user!
                                                          .image!
                                                          .isNotEmpty
                                                      ? Image.network(
                                                          "${URLConstants.base_data_url}images/${homepageController.postcommentModel!.data![index].user!.image!}",
                                                          fit: BoxFit.cover,
                                                        )
                                                      : SizedBox(
                                                          height: 50,
                                                          width: 50,
                                                          child: IconButton(
                                                            icon: Image.asset(
                                                              AssetUtils
                                                                  .user_icon3,
                                                              fit: BoxFit.fill,
                                                            ),
                                                            onPressed: () {},
                                                          )))))),
                                      title: Text(
                                        homepageController.postcommentModel!
                                            .data![index].userName!,
                                        style: TextStyle(
                                            color: HexColor(
                                                CommonColor.subHeaderColor),
                                            fontSize: 14,
                                            fontFamily: 'PR'),
                                      ),
                                      subtitle: Text(
                                        homepageController.postcommentModel!
                                            .data![index].message!,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontFamily: 'PM'),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              await homepageController.CommentLikeUnlikeApi(
                                                  context: context,
                                                  comment_id: homepageController
                                                      .postcommentModel!
                                                      .data![index]
                                                      .cmID!,
                                                  comment_likeStatus:
                                                      (homepageController
                                                                  .postcommentModel!
                                                                  .data![index]
                                                                  .likeStatus ==
                                                              'true'
                                                          ? 'false'
                                                          : 'true'),
                                                  comment_type: (homepageController
                                                              .postcommentModel!
                                                              .data![index]
                                                              .likeStatus ==
                                                          'true'
                                                      ? 'unliked'
                                                      : 'liked'),
                                                  news_id: widget.PostID);

                                              if (homepageController
                                                      .postCommentLikeModel!
                                                      .error ==
                                                  false) {
                                                print(
                                                    "vvvv${homepageController.postcommentModel!.data![index].likeCount!}");

                                                setState(() {
                                                  homepageController
                                                          .postcommentModel!
                                                          .data![index]
                                                          .likeCount =
                                                      homepageController
                                                          .postCommentLikeModel!
                                                          .user![0]
                                                          .likeCount!;

                                                  homepageController
                                                          .postcommentModel!
                                                          .data![index]
                                                          .likeStatus =
                                                      homepageController
                                                          .postCommentLikeModel!
                                                          .user![0]
                                                          .likeStatus!;
                                                });
                                                print(
                                                    "mmmm${homepageController.postcommentModel!.data![index].likeCount!}");
                                              }
                                            },
                                            child: Image.asset(
                                              (homepageController
                                                          .postcommentModel!
                                                          .data![index]
                                                          .likeStatus! ==
                                                      'true'
                                                  ? AssetUtils.like_icon_filled
                                                  : AssetUtils.like_icon),
                                              color: HexColor(
                                                  CommonColor.pinkFont),
                                              height: 15,
                                              width: 15,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            homepageController.postcommentModel!
                                                .data![index].likeCount!,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontFamily: 'PR'),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              print(
                                                  "name : ${homepageController.Replyname_controller.length}");
                                              print(
                                                  "id : ${homepageController.Replying_comment_id.length}");
                                              setState(() {
                                                homepageController
                                                        .Replyname_controller =
                                                    homepageController
                                                        .postcommentModel!
                                                        .data![index]
                                                        .userName!;
                                                homepageController
                                                        .Replying_comment_id =
                                                    homepageController
                                                        .postcommentModel!
                                                        .data![index]
                                                        .cmID!;
                                              });
                                              print(
                                                  "name : ${homepageController.Replyname_controller}");
                                              print(
                                                  "id : ${homepageController.Replying_comment_id}");
                                              FocusScope.of(context)
                                                  .requestFocus(focusNode);
                                            },
                                            child: Text(
                                              'reply',
                                              style: TextStyle(
                                                  color: HexColor(CommonColor
                                                      .subHeaderColor),
                                                  fontSize: 14,
                                                  fontFamily: 'PR'),
                                            ),
                                          ),
                                          // IconButton(
                                          //   visualDensity: VisualDensity(vertical: -4,horizontal: -4),
                                          //   icon: Icon(
                                          //     Icons.more_vert,
                                          //     color: Colors.white,
                                          //     size: 20,
                                          //   ),
                                          //   onPressed: () {
                                          //     print('data');
                                          //
                                          //   },
                                          // ),
                                          // DropdownButtonHideUnderline(
                                          //   child: DropdownButton(
                                          //     elevation: 0,
                                          //     value: dropdownvalue,
                                          //     icon: Icon(Icons.keyboard_arrow_down),
                                          //     items: [
                                          //       DropdownMenuItem(
                                          //           value: "Apple",
                                          //           child: Text("items")),
                                          //       DropdownMenuItem(
                                          //           value: "items2",
                                          //           child: Text("items2")),
                                          //     ],
                                          //     onChanged: (String? newValue) {
                                          //       setState(() {
                                          //         dropdownvalue = newValue!;
                                          //       });
                                          //     },
                                          //   ),
                                          // ),

                                          Container(
                                            // color: Colors.pink,
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton(
                                                //isExpanded: true,
                                                icon: const Icon(
                                                  Icons.more_vert,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                                items: (post_mine
                                                    ? (comment_mine
                                                        ? [
                                                            DropdownMenuItem(
                                                                value: "Apple",
                                                                onTap: () {
                                                                  setState(() {
                                                                    comment_edit_bool =
                                                                        true;
                                                                    comment_id = homepageController
                                                                        .postcommentModel!
                                                                        .data![
                                                                            index]
                                                                        .cmID!;
                                                                    homepageController
                                                                            .comment_controller
                                                                            .text =
                                                                        homepageController
                                                                            .postcommentModel!
                                                                            .data![index]
                                                                            .message!;
                                                                  });
                                                                  print(
                                                                      "name : ${homepageController.Replyname_controller}");
                                                                  print(
                                                                      "id : ${homepageController.Replying_comment_id}");
                                                                  FocusScope.of(
                                                                          context)
                                                                      .requestFocus(
                                                                          focusNode);
                                                                },
                                                                child: const Text(
                                                                    "Edit",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            16,
                                                                        fontFamily:
                                                                            'PR'))),
                                                            DropdownMenuItem(
                                                                value: "items2",
                                                                onTap: () {
                                                                  comment_action_api(
                                                                      context:
                                                                          context,
                                                                      comment_id: homepageController
                                                                          .postcommentModel!
                                                                          .data![
                                                                              index]
                                                                          .cmID!,
                                                                      action:
                                                                          "delete",
                                                                      post_type:
                                                                          "post",
                                                                      message:
                                                                          "message");
                                                                },
                                                                child: const Text(
                                                                    "Delete",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            16,
                                                                        fontFamily:
                                                                            'PR'))),
                                                          ]
                                                        : [
                                                            DropdownMenuItem(
                                                                value: "Apple",
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () {
                                                                    print(
                                                                        "did");
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) => ReportProblem(
                                                                                  receiver_id: homepageController.postcommentModel!.data![index].user!.id!,
                                                                                  type: 'comment',
                                                                                  type_id: homepageController.postcommentModel!.data![index].cmID!,
                                                                                )));
                                                                  },
                                                                  child: const Text(
                                                                      "Report",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              16,
                                                                          fontFamily:
                                                                              'PR')),
                                                                )),
                                                            DropdownMenuItem(
                                                                value: "items2",
                                                                onTap: () {
                                                                  comment_action_api(
                                                                      context:
                                                                          context,
                                                                      comment_id: homepageController
                                                                          .postcommentModel!
                                                                          .data![
                                                                              index]
                                                                          .cmID!,
                                                                      action:
                                                                          "delete",
                                                                      post_type:
                                                                          "post",
                                                                      message:
                                                                          "message");
                                                                },
                                                                child: const Text(
                                                                    "Delete",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            16,
                                                                        fontFamily:
                                                                            'PR'))),
                                                          ])
                                                    : (comment_mine
                                                        ? [
                                                            DropdownMenuItem(
                                                                value: "Apple",
                                                                onTap: () {
                                                                  setState(() {
                                                                    comment_edit_bool =
                                                                        true;
                                                                    comment_id = homepageController
                                                                        .postcommentModel!
                                                                        .data![
                                                                            index]
                                                                        .cmID!;
                                                                    homepageController
                                                                            .comment_controller
                                                                            .text =
                                                                        homepageController
                                                                            .postcommentModel!
                                                                            .data![index]
                                                                            .message!;
                                                                  });
                                                                  print(
                                                                      "name : ${homepageController.Replyname_controller}");
                                                                  print(
                                                                      "id : ${homepageController.Replying_comment_id}");
                                                                  FocusScope.of(
                                                                          context)
                                                                      .requestFocus(
                                                                          focusNode);
                                                                },
                                                                child: const Text(
                                                                    "Edit",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            16,
                                                                        fontFamily:
                                                                            'PR'))),
                                                            DropdownMenuItem(
                                                                value: "items2",
                                                                onTap: () {
                                                                  comment_action_api(
                                                                      context:
                                                                          context,
                                                                      comment_id: homepageController
                                                                          .postcommentModel!
                                                                          .data![
                                                                              index]
                                                                          .cmID!,
                                                                      action:
                                                                          "delete",
                                                                      post_type:
                                                                          "post",
                                                                      message:
                                                                          "message");
                                                                },
                                                                child: const Text(
                                                                    "Delete",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            16,
                                                                        fontFamily:
                                                                            'PR'))),
                                                          ]
                                                        : [
                                                            DropdownMenuItem(
                                                                value: "Apple",
                                                                child:
                                                                    GestureDetector(
                                                                  onTap:
                                                                      () async {
                                                                    print(
                                                                        "did");
                                                                    await Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) => ReportProblem(
                                                                                  receiver_id: homepageController.postcommentModel!.data![index].user!.id!,
                                                                                  type: 'comment',
                                                                                  type_id: homepageController.postcommentModel!.data![index].cmID!,
                                                                                )));
                                                                  },
                                                                  child: const Text(
                                                                      "Report",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              16,
                                                                          fontFamily:
                                                                              'PR')),
                                                                )),
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
                                                    comment_id =
                                                        homepageController
                                                            .postcommentModel!
                                                            .data![index]
                                                            .cmID!;
                                                  });
                                                  print(
                                                      "commet_id $comment_id");
                                                  if (homepageController
                                                          .postcommentModel!
                                                          .data![index]
                                                          .user!
                                                          .id ==
                                                      id_user) {
                                                    setState(() {
                                                      comment_mine = true;
                                                    });

                                                    print(
                                                        "data------- ${homepageController.postcommentModel!.data![index].cmID!}");
                                                  } else {
                                                    setState(() {
                                                      comment_mine = false;
                                                    });
                                                    print(
                                                        "data------- ${homepageController.postcommentModel!.data![index].cmID}");
                                                  }
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

                                                // onMenuStateChange: (value) {
                                                //   setState(() {
                                                //     comment_id =
                                                //         homepageController
                                                //             .postcommentModel!
                                                //             .data![index]
                                                //             .cmID!;
                                                //   });
                                                //   print(
                                                //       "commet_id $comment_id");
                                                //   if (homepageController
                                                //           .postcommentModel!
                                                //           .data![index]
                                                //           .user!
                                                //           .id ==
                                                //       id_user) {
                                                //     setState(() {
                                                //       comment_mine = true;
                                                //     });

                                                //     print(
                                                //         "data------- ${homepageController.postcommentModel!.data![index].cmID!}");
                                                //   } else {
                                                //     setState(() {
                                                //       comment_mine = false;
                                                //     });
                                                //     print(
                                                //         "data------- ${homepageController.postcommentModel!.data![index].cmID}");
                                                //   }
                                                //   setState(() {});
                                                // },

                                                // buttonPadding: const EdgeInsets.only(left: 15, right: 15),
                                                // buttonDecoration: BoxDecoration(
                                                //     borderRadius: BorderRadius.circular(10), color: Colors.transparent),
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
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 40),
                                      alignment: Alignment.centerRight,
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: homepageController
                                              .postcommentModel!
                                              .data![index]
                                              .replies!
                                              .length,
                                          itemBuilder:
                                              (BuildContext context, int idx) {
                                            return ListTile(
                                              visualDensity:
                                                  const VisualDensity(
                                                      horizontal: -4,
                                                      vertical: 0),
                                              leading: SizedBox(
                                                  height: 40,
                                                  width: 40,
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      child: (homepageController
                                                              .postcommentModel!
                                                              .data![index]
                                                              .replies![idx]
                                                              .user!
                                                              .profileUrl!
                                                              .isNotEmpty
                                                          ? Image.network(
                                                              homepageController
                                                                  .postcommentModel!
                                                                  .data![index]
                                                                  .replies![idx]
                                                                  .user!
                                                                  .profileUrl!,
                                                              fit: BoxFit.fill,
                                                            )
                                                          : (homepageController
                                                                  .postcommentModel!
                                                                  .data![index]
                                                                  .replies![idx]
                                                                  .user!
                                                                  .image!
                                                                  .isNotEmpty
                                                              ? Image.network(
                                                                  "${URLConstants.base_data_url}images/${homepageController.postcommentModel!.data![index].replies![idx].user!.image!}",
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )
                                                              : SizedBox(
                                                                  height: 50,
                                                                  width: 50,
                                                                  child:
                                                                      IconButton(
                                                                    icon: Image
                                                                        .asset(
                                                                      AssetUtils
                                                                          .user_icon3,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                    onPressed:
                                                                        () {},
                                                                  )))))),
                                              title: Text(
                                                homepageController
                                                    .postcommentModel!
                                                    .data![index]
                                                    .replies![idx]
                                                    .user!
                                                    .userName!,
                                                style: TextStyle(
                                                    color: HexColor(CommonColor
                                                        .subHeaderColor),
                                                    fontSize: 14,
                                                    fontFamily: 'PR'),
                                              ),
                                              subtitle: Text(
                                                homepageController
                                                    .postcommentModel!
                                                    .data![index]
                                                    .replies![idx]
                                                    .comment!,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontFamily: 'PM'),
                                              ),
                                              trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () async {
                                                      await homepageController.CommentReplyLikeUnlikeApi(
                                                          context: context,
                                                          comment_id:
                                                              homepageController
                                                                  .postcommentModel!
                                                                  .data![index]
                                                                  .replies![idx]
                                                                  .comId!,
                                                          comment_likeStatus: (homepageController
                                                                      .postcommentModel!
                                                                      .data![
                                                                          index]
                                                                      .replies![
                                                                          idx]
                                                                      .likeStatus! ==
                                                                  'true'
                                                              ? 'false'
                                                              : 'true'),
                                                          comment_type: (homepageController
                                                                      .postcommentModel!
                                                                      .data![
                                                                          index]
                                                                      .replies![
                                                                          idx]
                                                                      .likeStatus! ==
                                                                  'true'
                                                              ? 'unliked'
                                                              : 'liked'),
                                                          news_id:
                                                              widget.PostID);

                                                      if (homepageController
                                                              .postCommentReplyLikeModel!
                                                              .error ==
                                                          false) {
                                                        print(
                                                            "vvvv${homepageController.postcommentModel!.data![index].replies![idx].likeStatus}");

                                                        setState(() {
                                                          homepageController
                                                                  .postcommentModel!
                                                                  .data![index]
                                                                  .replies![idx]
                                                                  .likecount =
                                                              homepageController
                                                                      .postCommentReplyLikeModel!
                                                                      .user![0]
                                                                      .likecount ??
                                                                  '';

                                                          homepageController
                                                                  .postcommentModel!
                                                                  .data![index]
                                                                  .replies![idx]
                                                                  .likeStatus =
                                                              homepageController
                                                                  .postCommentReplyLikeModel!
                                                                  .user![0]
                                                                  .likeStatus!;
                                                        });
                                                        print(
                                                            "mmmmm${homepageController.postcommentModel!.data![index].replies![idx].likeStatus}");
                                                      }
                                                    },
                                                    child: Image.asset(
                                                      (homepageController
                                                                  .postcommentModel!
                                                                  .data![index]
                                                                  .replies![idx]
                                                                  .likeStatus! ==
                                                              'true'
                                                          ? AssetUtils
                                                              .like_icon_filled
                                                          : AssetUtils
                                                              .like_icon),
                                                      color: HexColor(
                                                          CommonColor.pinkFont),
                                                      height: 15,
                                                      width: 15,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    homepageController
                                                        .postcommentModel!
                                                        .data![index]
                                                        .replies![idx]
                                                        .likecount!,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontFamily: 'PR'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    )
                                  ],
                                );
                              },
                            ),
                            Container(
                              child: Positioned(
                                  bottom: 0,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      (location_tap
                                          ? (homepageController
                                                      .iscommentTagSearchLoading
                                                      .value ==
                                                  true
                                              ? const LoaderPage()
                                              : Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      1.5,
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 30),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            24),
                                                    border: Border.all(
                                                        width: 1,
                                                        color: Colors.white),
                                                    gradient: LinearGradient(
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                      // stops: [0.1, 0.5, 0.7, 0.9],
                                                      colors: [
                                                        HexColor("#000000"),
                                                        HexColor("#C12265"),
                                                        HexColor("#C12265"),
                                                        HexColor("#FFFFFF"),
                                                      ],
                                                    ),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            24),
                                                    child: ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount:
                                                          homepageController
                                                              .getCommentTagModel!
                                                              .data!
                                                              .length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            print(homepageController
                                                                .comment_controller
                                                                .text
                                                                .split(" "));
                                                            print(homepageController
                                                                .comment_controller
                                                                .text
                                                                .split(" ")
                                                                .last);
                                                            print(homepageController
                                                                .comment_controller
                                                                .text
                                                                .split(" ")
                                                                .last
                                                                .startsWith(
                                                                    "@"));
                                                            // print(homepageController.comment_controller.text
                                                            //     .split(" ")
                                                            //     .last
                                                            //     .startsWith("@"));
                                                            if (homepageController
                                                                .comment_controller
                                                                .text
                                                                .split(" ")
                                                                .last
                                                                .startsWith(
                                                                    "@")) {
                                                              setState(() {
                                                                homepageController
                                                                    .comment_controller
                                                                    .text
                                                                    .split(" ")
                                                                    .removeAt(homepageController
                                                                            .comment_controller
                                                                            .text
                                                                            .split(" ")
                                                                            .length -
                                                                        1);

                                                                homepageController
                                                                        .comment_controller
                                                                        .text +=
                                                                    homepageController
                                                                        .getCommentTagModel!
                                                                        .data![
                                                                            index]
                                                                        .userName!;
                                                              });
                                                              print(
                                                                  "ghellpo : ${homepageController.comment_controller.text.split(" ").last}");
                                                              print(
                                                                  "ghellpo : ${homepageController.getCommentTagModel!.data![index].userName!}");
                                                              print(
                                                                  "ghellpo : ${homepageController.comment_controller.text}");
                                                            }
                                                            // setState(() {
                                                            //   homepageController
                                                            //           .comment_controller
                                                            //           .text +=
                                                            //       homepageController
                                                            //           .getCommentTagModel!
                                                            //           .data![
                                                            //               index]
                                                            //           .userName!;
                                                            // });
                                                            // FocusScope.of(
                                                            //         context)
                                                            //     .requestFocus(
                                                            //         focusNode);

                                                            setState(() {
                                                              location_tap =
                                                                  false;
                                                            });
                                                            FocusScope.of(
                                                                    context)
                                                                .requestFocus(
                                                                    focusNode);
                                                          },
                                                          child: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical: 8,
                                                                    horizontal:
                                                                        15),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              100),
                                                                  child: SizedBox(
                                                                      height: 40,
                                                                      width: 40,
                                                                      child: (homepageController.getCommentTagModel!.data![index].image!.isNotEmpty
                                                                          ?
                                                                          // Image.network(
                                                                          //         "${URLConstants.base_data_url}images/${_search_screen_controller.getFriendSuggestionModel!.data![index].image!}",
                                                                          //         height: 80,
                                                                          //         width: 80,
                                                                          //         fit: BoxFit.cover,
                                                                          //       )
                                                                          FadeInImage.assetNetwork(
                                                                              fit: BoxFit.cover,
                                                                              image: "${URLConstants.base_data_url}images/${homepageController.getCommentTagModel!.data![index].image!}",
                                                                              height: 40,
                                                                              width: 40,
                                                                              placeholder: 'assets/images/Funky_App_Icon.png',
                                                                              imageErrorBuilder: (context, url, error) => Image.asset(
                                                                                "assets/images/Funky_App_Icon.png",
                                                                                height: 40,
                                                                                width: 40,
                                                                                fit: BoxFit.cover,
                                                                              ),
                                                                              // color: HexColor(CommonColor.pinkFont),
                                                                            )
                                                                          : (homepageController.getCommentTagModel!.data![index].profileUrl!.isNotEmpty
                                                                              ?
                                                                              // Image.network(
                                                                              //             _search_screen_controller
                                                                              //                 .local_list[index]
                                                                              //                 .profileUrl!,
                                                                              //             height: 80,
                                                                              //             width: 80,
                                                                              //             fit: BoxFit.cover,
                                                                              //           )
                                                                              FadeInImage.assetNetwork(
                                                                                  fit: BoxFit.cover,
                                                                                  image: homepageController.getCommentTagModel!.data![index].profileUrl!,
                                                                                  height: 40,
                                                                                  width: 40,
                                                                                  placeholder: 'assets/images/Funky_App_Icon.png',
                                                                                  imageErrorBuilder: (context, url, error) => Image.asset(
                                                                                    "assets/images/Funky_App_Icon.png",
                                                                                    height: 40,
                                                                                    width: 40,
                                                                                    fit: BoxFit.cover,
                                                                                  ),
                                                                                  // color: HexColor(CommonColor.pinkFont),
                                                                                )
                                                                              : Image.asset(
                                                                                  AssetUtils.image1,
                                                                                  height: 40,
                                                                                  width: 40,
                                                                                  fit: BoxFit.cover,
                                                                                )))),
                                                                ),
                                                                const SizedBox(
                                                                  width: 15,
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                    '${homepageController.getCommentTagModel!.data![index].fullName}',
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontFamily:
                                                                          'PR',
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ))
                                          : const SizedBox.shrink()),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        color: Colors.black,
                                        child: Container(
                                          // height: 45,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.3,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: HexColor(
                                                          CommonColor.pinkFont),
                                                      width: 1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          24.0),
                                                ),
                                                child: TextFormField(
                                                  focusNode: focusNode,
                                                  // maxLines: 2,
                                                  onChanged: (value) async {
                                                    print(value);
                                                    print(value.split(" "));
                                                    print(
                                                        value.split(" ").last);

                                                    if (value
                                                            .split(" ")
                                                            .last
                                                            .endsWith("@") ||
                                                        value
                                                            .split(" ")
                                                            .last
                                                            .startsWith("@")) {
                                                      setState(() {
                                                        location_tap = true;
                                                      });
                                                    }

                                                    await homepageController
                                                        .getCommentTagList(
                                                            context: context,
                                                            hashtag: value
                                                                .split(" ")
                                                                .last,
                                                            login_id: id_user!);
                                                  },
                                                  // enabled: enabled,
                                                  // validator: validator,
                                                  // maxLines: maxLines,
                                                  // onTap: tap,
                                                  // obscureText: isObscure ?? false,
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets.only(
                                                            left: 20,
                                                            top: 14,
                                                            bottom: 14),
                                                    alignLabelWithHint: false,
                                                    isDense: true,
                                                    hintText:
                                                        'Write Comment...',
                                                    filled: true,
                                                    border: InputBorder.none,
                                                    // errorText: errorText,
                                                    enabledBorder:
                                                        const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .transparent,
                                                          width: 1),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                    ),

                                                    // focusedBorder: OutlineInputBorder(
                                                    //   borderSide:
                                                    //   BorderSide(color: ColorUtils.blueColor, width: 1),
                                                    //   borderRadius: BorderRadius.all(Radius.circular(10)),
                                                    // ),
                                                    prefixText: homepageController
                                                        .Replyname_controller,
                                                    hintStyle: const TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: 'PR',
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: 'PR',
                                                    color: Colors.black,
                                                  ),
                                                  controller: homepageController
                                                      .comment_controller,
                                                  keyboardType:
                                                      TextInputType.text,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  (comment_edit_bool
                                                      ? comment_action_api(
                                                          context: context,
                                                          comment_id:
                                                              comment_id!,
                                                          action: "edit",
                                                          post_type: "post",
                                                          message:
                                                              homepageController
                                                                  .comment_controller
                                                                  .text)
                                                      : (homepageController
                                                                  .Replyname_controller
                                                                  .isNotEmpty &&
                                                              homepageController
                                                                  .Replying_comment_id
                                                                  .isNotEmpty
                                                          ? homepageController
                                                              .ReplyCommentPostApi(
                                                              context: context,
                                                              news_id:
                                                                  widget.PostID,
                                                            )
                                                          : homepageController
                                                              .CommentPostApi(
                                                                  post_id: widget
                                                                      .PostID,
                                                                  news_id: widget
                                                                      .PostID,
                                                                  context:
                                                                      context)));
                                                },
                                                child: const Icon(
                                                  Icons.send,
                                                  color: Colors.white,
                                                  size: 30,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Center(
                            child: Container(
                              // color: Colors.red,
                              child: CircularProgressIndicator(
                                // color: Colors.pink,
                                backgroundColor: HexColor(CommonColor.pinkFont),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.white70, //<-- SEE HERE
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  CommentActionModel? commentActionModel;

  bool isclearing = false;

  comment_action_api(
      {required BuildContext context,
      required String comment_id,
      required String action,
      required String post_type,
      required String message}) async {
    setState(() {
      isclearing = true;
    });
    debugPrint('0-0-0-0-0-0-0 token');
    String idUser = await PreferenceManager().getPref(URLConstants.id);

    var url = (URLConstants.base_url + URLConstants.comment_action);

    Map data = {
      'id': comment_id,
      'action': action,
      'type': post_type,
      'message': message,
      // 'token': token,
    };
    print(data);
    // String body = json.encode(data);

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
      commentActionModel = CommentActionModel.fromJson(data);
      if (commentActionModel!.error == false) {
        await homepageController.getPostCommments(
            newsfeedID: widget.PostID, context: context);
        setState(() {
          isclearing = false;
          comment_edit_bool = false;
        });
        CommonWidget().showToaster(msg: commentActionModel!.message!);
      } else {
        setState(() {
          isclearing = false;
          comment_edit_bool = false;
        });
        CommonWidget().showErrorToaster(msg: "Invalid Details");
        print('Please try again');
        print('Please try again');
      }
    } else {}
  }
}
