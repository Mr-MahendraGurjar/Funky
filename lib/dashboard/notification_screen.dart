import 'dart:convert';
import 'dart:convert' as convert;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

import '../Utils/App_utils.dart';
import '../Utils/colorUtils.dart';
import '../Utils/toaster_widget.dart';
import '../profile_screen/profile_controller.dart';
import '../profile_screen/story_view/storyView.dart';
import '../search_screen/search_screen_user_profile.dart';
import '../settings/reward_screen.dart';
import '../sharePreference.dart';
import 'dashboard_screen.dart';
import 'model/clearNotificationModel.dart';
import 'model/manuallyapproveModel.dart';
import 'model/notificationModel.dart';
import 'notification_view_post.dart';

class Notifications_screen extends StatefulWidget {
  const Notifications_screen({Key? key}) : super(key: key);

  @override
  State<Notifications_screen> createState() => _Notifications_screenState();
}

class _Notifications_screenState extends State<Notifications_screen> {
  var _listItems = <Widget>[];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await get_notifications_list(context);
    await _loadItems();
  }

  Future<void> _loadItems() async {
    // fetching data from web api, db...
    final fetchedList = [
      ListTile(
        title: Text('Economy'),
        trailing: Icon(Icons.directions_car),
      ),
      ListTile(
        title: Text('Comfort'),
        trailing: Icon(Icons.motorcycle),
      ),
      ListTile(
        title: Text('Business'),
        trailing: Icon(Icons.flight),
      ),
    ];

    var future = Future(() {});
    for (var i = 0; i < mohit.length; i++) {
      future = future.then((_) {
        return Future.delayed(Duration(milliseconds: 100), () {
          _listItems.add(mohit[i]);
          _listKey.currentState!.insertItem(_listItems.length - 1);
        });
      });
    }
  }

  void _unloadItems() {
    var future = Future(() {});
    for (var i = _listItems.length - 1; i >= 0; i--) {
      future = future.then((_) {
        return Future.delayed(Duration(milliseconds: 100), () {
          final deletedItem = _listItems.removeAt(i);
          _listKey.currentState!.removeItem(i, (BuildContext context, Animation<double> animation) {
            return SlideTransition(
              position: CurvedAnimation(
                curve: Curves.easeOut,
                parent: animation,
              ).drive((Tween<Offset>(
                begin: Offset(1, 0),
                end: Offset(0, 0),
              ))),
              child: deletedItem,
            );
          });
        });
      });
    }
  }

  List<String> _data = ['Horse', 'Cow', 'Camel', 'Sheep', 'Goat'];
  late double screenHeight, screenWidth;

  manual_tag_popup({
    required BuildContext context,
    required String username,
    required String image,
    required String user_id,
    required String type,
    required String type_id,
    required String notification_id,
  }) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        double width = MediaQuery.of(context).size.width;
        double height = MediaQuery.of(context).size.height;
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AlertDialog(
              backgroundColor: Colors.transparent,
              contentPadding: EdgeInsets.zero,
              elevation: 0.0,
              // title: Center(child: Text("Evaluation our APP")),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    // margin: const EdgeInsets.symmetric(
                    //     vertical: 110, horizontal: 70),
                    // height: 115,
                    // width: 133,
                    // padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: const Alignment(-1.0, 0.0),
                          end: const Alignment(1.0, 0.0),
                          transform: const GradientRotation(0.7853982),
                          // stops: [0.1, 0.5, 0.7, 0.9],
                          colors: [
                            HexColor("#000000"),
                            HexColor(CommonColor.pinkFont),
                            HexColor("#ffffff"),
                            // HexColor("#FFFFFF").withOpacity(0.67),
                          ],
                        ),
                        color: Colors.white,
                        border: Border.all(color: Colors.white, width: 1),
                        borderRadius: const BorderRadius.all(Radius.circular(26.0))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: (image.isEmpty
                                ? Container(
                                    height: 70,
                                    width: 70,
                                    child: Image.asset(
                                      'assets/images/Funky_App_Icon.png',
                                      height: 80,
                                      width: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Container(
                                    height: 70,
                                    width: 70,
                                    child: FadeInImage.assetNetwork(
                                      height: 80,
                                      width: 80,
                                      fit: BoxFit.cover,
                                      image: "${URLConstants.base_data_url}images/${image}",
                                      placeholder: 'assets/images/Funky_App_Icon.png',
                                    ))),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            username,
                            style: const TextStyle(fontSize: 16, fontFamily: 'PB', color: Colors.white),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Wants to tag you in the post",
                            style: const TextStyle(fontSize: 16, fontFamily: 'PR', color: Colors.white),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: const Divider(
                              color: Colors.black,
                              height: 20,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(vertical: 10),
                                    child: Row(
                                      // mainAxisAlignment:
                                      // MainAxisAlignment
                                      //     .center,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            Navigator.pop(context);
                                            await manually_approve_tag(
                                                context: context,
                                                user_id: user_id,
                                                type: type,
                                                type_id: type_id,
                                                manual_tag: 'true',
                                                notification_id: notification_id);
                                            // video_upload();
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 0),
                                            // height: 45,
                                            // width:(width ?? 300) ,
                                            decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: const Alignment(-1.0, 0.0),
                                                  end: const Alignment(1.0, 0.0),
                                                  transform: const GradientRotation(0.7853982),
                                                  // stops: [0.1, 0.5, 0.7, 0.9],
                                                  colors: [
                                                    HexColor(CommonColor.pinkFont),
                                                    HexColor("#000000"),
                                                  ],
                                                ),
                                                border: Border.all(color: Colors.white, width: 1),
                                                borderRadius: BorderRadius.circular(25)),
                                            child: Container(
                                                alignment: Alignment.center,
                                                margin: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                                                child: Text(
                                                  'Approve',
                                                  style: TextStyle(color: Colors.white, fontFamily: 'PR', fontSize: 16),
                                                )),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            // image_upload();
                                            // Navigator.pop(context);
                                            // Get.to(Post_screen());
                                            Navigator.pop(context);
                                            await manually_approve_tag(
                                                context: context,
                                                user_id: user_id,
                                                type: type,
                                                type_id: type_id,
                                                manual_tag: 'true',
                                                notification_id: notification_id);
                                            // image_Gallery();
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 0),
                                            // height: 45,
                                            // width:(width ?? 300),

                                            decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: const Alignment(-1.0, 0.0),
                                                  end: const Alignment(1.0, 0.0),
                                                  transform: const GradientRotation(0.7853982),
                                                  // stops: [0.1, 0.5, 0.7, 0.9],
                                                  colors: [
                                                    HexColor(CommonColor.pinkFont),
                                                    HexColor("#000000"),
                                                  ],
                                                ),
                                                border: Border.all(color: Colors.white, width: 1),
                                                borderRadius: BorderRadius.circular(25)),
                                            child: Container(
                                                alignment: Alignment.center,
                                                margin: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                                                child: Text(
                                                  'Refuse',
                                                  style: TextStyle(color: Colors.white, fontFamily: 'PR', fontSize: 16),
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )

                                  // const SizedBox(
                                  //   height: 10,
                                  // ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        );
      },
    );
  }

  final Profile_screen_controller _profile_screen_controller =
      Get.put(Profile_screen_controller(), tag: Profile_screen_controller().toString());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text(
              'Notifications',
              style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'PB'),
            ),
            centerTitle: true,
            leadingWidth: 100,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Get.to(Dashboard(page: 0));
                // Navigator.pop(context);
              },
            ),
            actions: <Widget>[
              // IconButton(icon: Icon(Icons.add), onPressed: _loadItems),
              // IconButton(
              //     icon: Icon(
              //       Icons.delete,
              //       color: HexColor(CommonColor.pinkFont),
              //     ),
              //     onPressed: () {
              //       clear_notifications_list(context);
              //     }),
              GestureDetector(
                onTap: () {
                  clearall_popup(context: context);
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    "Clear All",
                    style: TextStyle(color: Colors.white, fontFamily: 'PB', fontSize: 14),
                  ),
                ),
              )
            ],
          ),
          body: RefreshIndicator(
            color: HexColor(CommonColor.pinkFont),
            onRefresh: () async {
              await Future.delayed(Duration(seconds: 1));
              // updateData();
              await get_notifications_list(context);

              // news_feed_controller.getAllNewsFeedList();

              print("object");
            },
            child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: (isLoading == true || isclearing == true
                    ? Column(
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Center(
                            child: Container(
                                // color: Colors.red,
                                height: MediaQuery.of(context).size.height - 50,
                                width: 200,
                                child: Container(
                                  color: Colors.transparent,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(
                                        // color: Colors.pink,
                                        backgroundColor: HexColor(CommonColor.pinkFont),
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white70, //<-- SEE HERE
                                        ),
                                      ),
                                      // Text('Loading...',style: TextStyle(color: Colors.white,fontSize: 18,fontFamily: 'PR'),)
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
                                ),
                          ),
                        ],
                      )
                    : (notificationModel!.error == true
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                // color: Colors.yellow,
                                height: MediaQuery.of(context).size.height - 50,
                                child: Center(
                                  child: Text(
                                    "No new notifications!",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 16, color: HexColor(CommonColor.pinkFont), fontFamily: 'PB'),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            itemCount: notificationModel!.data!.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(top: 10.0, right: 20, left: 20, bottom: 50),
                            itemBuilder: (BuildContext context, int i) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    // color: Colors.white,
                                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 0, top: 20),
                                    child: Text(
                                      notificationModel!.data![i].title!,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 16, color: HexColor(CommonColor.pinkFont), fontFamily: 'PR'),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  ListView.builder(
                                    itemCount: notificationModel!.data![i].notification!.length,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (BuildContext conttext, int index) {
                                      return Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                                            child: ListTile(
                                              onTap: () async {
                                                print(notificationModel!.data![i].notification![index].type!);

                                                if (notificationModel!.data![i].notification![index].type ==
                                                    'getreward') {
                                                  await Get.to(RewardScreen());
                                                } else if (notificationModel!.data![i].notification![index].type ==
                                                        'comment' ||
                                                    notificationModel!.data![i].notification![index].type == 'like') {
                                                  Get.to(NotificationViewPost(
                                                      isVideo:
                                                          notificationModel!.data![i].notification![index].isVideo!,
                                                      post_id:
                                                          notificationModel!.data![i].notification![index].typeId!));
                                                } else if (notificationModel!.data![i].notification![index].type ==
                                                    'follow') {
                                                  Get.to(SearchUserProfile(
                                                    // quickBlox_id: qb_user!.id!,
                                                    quickBlox_id: "0",
                                                    // UserId: _search_screen_controller
                                                    //     .searchlistModel!.data![index].id!,
                                                    search_user_data:
                                                        notificationModel!.data![i].notification![index].user,
                                                  ));
                                                } else if (notificationModel!.data![i].notification![index].type ==
                                                    'tag') {
                                                  if (notificationModel!
                                                          .data![i].notification![index].manuallyApproveTag ==
                                                      'true') {
                                                    if (notificationModel!.data![i].notification![index].approved ==
                                                        'true') {
                                                      manual_tag_popup(
                                                        context: context,
                                                        username: notificationModel!
                                                            .data![i].notification![index].user!.userName!,
                                                        image: notificationModel!.data![i].notification![index].image!,
                                                        user_id:
                                                            notificationModel!.data![i].notification![index].userId!,
                                                        type: notificationModel!.data![i].notification![index].type!,
                                                        type_id:
                                                            notificationModel!.data![i].notification![index].typeId!,
                                                        notification_id:
                                                            notificationModel!.data![i].notification![index].id!,
                                                      );
                                                    } else {
                                                      Get.to(NotificationViewPost(
                                                          isVideo:
                                                              notificationModel!.data![i].notification![index].isVideo!,
                                                          post_id: notificationModel!
                                                              .data![i].notification![index].typeId!));
                                                    }
                                                  } else {}
                                                } else if (notificationModel!.data![i].notification![index].type ==
                                                    'story') {
                                                  String idUser = await PreferenceManager().getPref(URLConstants.id);

                                                  await _profile_screen_controller.get_single_story(
                                                      context: context,
                                                      login_user_id: idUser,
                                                      user_id:
                                                          notificationModel!.data![i].notification![index].user!.id!,
                                                      story_id:
                                                          notificationModel!.data![i].notification![index].typeId!);

                                                  if (_profile_screen_controller.getStoryModel!.error == false) {
                                                    Get.to(() => StoryScreen(
                                                          other_user: true,
                                                          title: _profile_screen_controller.story_[index].title!,
                                                          mohit: _profile_screen_controller.getStoryModel!.data![index],
                                                          // thumbnail:
                                                          //     test_thumb[index],
                                                          stories: _profile_screen_controller.story_info,
                                                          story_no: 0,
                                                          stories_title: _profile_screen_controller.story_,
                                                        ));
                                                  }
                                                }
                                              },
                                              visualDensity: VisualDensity(vertical: 4, horizontal: -2),
                                              leading: ClipRRect(
                                                borderRadius: BorderRadius.circular(100),
                                                child: (notificationModel!.data![i].notification![index].image!.isEmpty
                                                        ? Container(
                                                            height: 50,
                                                            width: 50,
                                                            child: Image.asset(
                                                              'assets/images/Funky_App_Icon.png',
                                                              height: 80,
                                                              width: 80,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          )
                                                        : Container(
                                                            height: 50,
                                                            width: 50,
                                                            child: FadeInImage.assetNetwork(
                                                              height: 80,
                                                              width: 80,
                                                              fit: BoxFit.cover,
                                                              image:
                                                                  "${URLConstants.base_data_url}images/${notificationModel!.data![i].notification![index].image}",
                                                              placeholder: 'assets/images/Funky_App_Icon.png',
                                                            ))

                                                    // (FollowersData[index]
                                                    //     .image!
                                                    //     .isNotEmpty
                                                    //     ? Image.network(
                                                    //   "${URLConstants.base_data_url}images/${FollowersData[index].image!}",
                                                    //   height: 80,
                                                    //   width: 80,
                                                    //   fit: BoxFit.cover,
                                                    // )
                                                    //     : (FollowersData[index]
                                                    //     .profileUrl!
                                                    //     .isNotEmpty
                                                    //     ? Image.network(
                                                    //   FollowersData[index]
                                                    //       .profileUrl!,
                                                    //   height: 80,
                                                    //   width: 80,
                                                    //   fit: BoxFit.cover,
                                                    // )
                                                    //     : Image.asset(
                                                    //   AssetUtils.image1,
                                                    //   height: 80,
                                                    //   width: 80,
                                                    //   fit: BoxFit.cover,
                                                    // )))
                                                    ),
                                              ),
                                              title: Text(notificationModel!.data![i].notification![index].messageTime!,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: HexColor(CommonColor.grey_light2).withOpacity(0.5),
                                                      fontFamily: 'PR')),
                                              subtitle: Padding(
                                                padding: EdgeInsets.symmetric(vertical: 10),
                                                child: RichText(
                                                  text: TextSpan(
                                                      text:
                                                          '${notificationModel!.data![i].notification![index].userName}',
                                                      style: TextStyle(
                                                          color: Colors.white, fontSize: 15, fontFamily: 'PR'),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                          text:
                                                              ' ${notificationModel!.data![i].notification![index].status}',
                                                          style: TextStyle(
                                                              color: HexColor(CommonColor.pinkFont),
                                                              fontSize: 14,
                                                              fontFamily: 'PR'),
                                                        )
                                                      ]),
                                                ),
                                              ),
                                              trailing: GestureDetector(
                                                  onTap: () async {
                                                    // print('${FollowersData[index].id}');
                                                    // await _search_screen_controller
                                                    //     .Follow_unfollow_api(
                                                    //     follow_unfollow: (FollowersData[
                                                    //     index]
                                                    //         .userFollowUnfollow ==
                                                    //         'unfollow'
                                                    //         ? 'follow'
                                                    //         : 'unfollow'),
                                                    //     user_id:
                                                    //     FollowersData[index].id,
                                                    //     user_social:
                                                    //     FollowersData[index]
                                                    //         .socialType,
                                                    //     context: context);
                                                    // setState(() {
                                                    //   getAllFollowersList();
                                                    // });
                                                    print(notificationModel!.data![i].notification![index].id);
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        double width = MediaQuery.of(context).size.width;
                                                        double height = MediaQuery.of(context).size.height;
                                                        return BackdropFilter(
                                                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                                          child: AlertDialog(
                                                            title: Text("Delete Notification"),
                                                            content: Text(
                                                                "Are you sure want to delete this notificaitions?"),
                                                            actions: [
                                                              TextButton(
                                                                child: Text("No"),
                                                                onPressed: () {
                                                                  Navigator.pop(context);
                                                                },
                                                              ),
                                                              TextButton(
                                                                child: Text("Yes"),
                                                                onPressed: () async {
                                                                  Navigator.pop(context);

                                                                  await delete_notification(
                                                                      context: context,
                                                                      noti_id: notificationModel!
                                                                          .data![i].notification![index].id!);
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Container(
                                                    child: Icon(
                                                      Icons.delete,
                                                      color: HexColor(CommonColor.pinkFont),
                                                    ),
                                                  )),
                                            ),
                                          ),
                                          // Container(
                                          //   margin:
                                          //   EdgeInsets.symmetric(vertical: 5),
                                          //   color: HexColor(CommonColor.pinkFont)
                                          //       .withOpacity(0.5),
                                          //   height: 0.5,
                                          //   width:
                                          //   MediaQuery.of(context).size.width,
                                          // ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          )))),
          )),
    );
  }

  clearall_popup({
    required BuildContext context,
  }) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        double width = MediaQuery.of(context).size.width;
        double height = MediaQuery.of(context).size.height;
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AlertDialog(
            title: Text("Clear Notification"),
            content: Text("Are you sure want to clear all notificaitions?"),
            actions: [
              TextButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text("Yes"),
                onPressed: () {
                  Navigator.pop(context);

                  clear_notifications_list(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  NotificationModel? notificationModel;
  bool isLoading = true;

  List<Widget> mohit = [];
  dynamic data_;

  Future<dynamic> get_notifications_list(BuildContext context) async {
    String idUser = await PreferenceManager().getPref(URLConstants.id);
    // String body = json.encode(data);

    // var url =
    //     ('${URLConstants.base_url + URLConstants.get_notifications}?user_id=52');
    var url = ('${URLConstants.base_url + URLConstants.get_notifications}?user_id=$idUser');
    // var url = ('${URLConstants.base_url}tagList.php?user_id=10000020');

    http.Response response = await http.get(Uri.parse(url));

    print(response.body);
    print(response.request);
    print(response.statusCode);
    // var final_data = jsonDecode(response.body);
    // print('final data $final_data');
    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = convert.jsonDecode(response.body);
      notificationModel = NotificationModel.fromJson(data);
      if (notificationModel!.error == false) {
        debugPrint('2-2-2-2-2-2 Inside the product Controller Details ${notificationModel!.data!.length}');
        setState(() {
          isLoading = false;
        });

        // for (var i = 0; i < notificationModel!.data!.length; i++) {
        //   for (var j = 0;
        //       j < notificationModel!.data![i].notification!.length;
        //       j++) {
        //     dynamic title = Container(
        //       child: Container(
        //         // color: Colors.white,
        //         padding:
        //             EdgeInsets.only(left: 10, right: 10, bottom: 0, top: 20),
        //         child: Text(
        //           notificationModel!.data![i].title!,
        //           textAlign: TextAlign.left,
        //           style: TextStyle(
        //               fontSize: 16,
        //               color: HexColor(CommonColor.pinkFont),
        //               fontFamily: 'PR'),
        //         ),
        //       ),
        //     );
        //     dynamic list = Container(
        //       child: SingleChildScrollView(
        //         physics: NeverScrollableScrollPhysics(),
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             Column(
        //               children: [
        //                 Padding(
        //                   padding: const EdgeInsets.symmetric(vertical: 5.0),
        //                   child: ListTile(
        //                     visualDensity:
        //                         VisualDensity(vertical: 4, horizontal: -2),
        //                     leading: ClipRRect(
        //                       borderRadius: BorderRadius.circular(100),
        //                       child: Container(
        //                           height: 50,
        //                           width: 50,
        //                           child: FadeInImage.assetNetwork(
        //                             height: 80,
        //                             width: 80,
        //                             fit: BoxFit.cover,
        //                             image:
        //                                 "${URLConstants.base_data_url}images/${notificationModel!.data![i].notification![j].image}",
        //                             placeholder:
        //                                 'assets/images/Funky_App_Icon.png',
        //                           )
        //
        //                           // (FollowersData[index]
        //                           //     .image!
        //                           //     .isNotEmpty
        //                           //     ? Image.network(
        //                           //   "${URLConstants.base_data_url}images/${FollowersData[index].image!}",
        //                           //   height: 80,
        //                           //   width: 80,
        //                           //   fit: BoxFit.cover,
        //                           // )
        //                           //     : (FollowersData[index]
        //                           //     .profileUrl!
        //                           //     .isNotEmpty
        //                           //     ? Image.network(
        //                           //   FollowersData[index]
        //                           //       .profileUrl!,
        //                           //   height: 80,
        //                           //   width: 80,
        //                           //   fit: BoxFit.cover,
        //                           // )
        //                           //     : Image.asset(
        //                           //   AssetUtils.image1,
        //                           //   height: 80,
        //                           //   width: 80,
        //                           //   fit: BoxFit.cover,
        //                           // )))
        //                           ),
        //                     ),
        //                     title: Text("1 min Ago",
        //                         style: TextStyle(
        //                             fontSize: 12,
        //                             color: HexColor(CommonColor.grey_light2)
        //                                 .withOpacity(0.5),
        //                             fontFamily: 'PR')),
        //                     subtitle: Padding(
        //                       padding: EdgeInsets.symmetric(vertical: 10),
        //                       child: RichText(
        //                         text: TextSpan(
        //                             text:
        //                                 '${notificationModel!.data![i].notification![j].userName}',
        //                             style: TextStyle(
        //                                 color: Colors.white,
        //                                 fontSize: 15,
        //                                 fontFamily: 'PR'),
        //                             children: <TextSpan>[
        //                               TextSpan(
        //                                 text:
        //                                     ' ${notificationModel!.data![i].notification![j].status}',
        //                                 style: TextStyle(
        //                                     color:
        //                                         HexColor(CommonColor.pinkFont),
        //                                     fontSize: 14,
        //                                     fontFamily: 'PR'),
        //                               )
        //                             ]),
        //                       ),
        //                     ),
        //                     trailing: GestureDetector(
        //                         onTap: () async {
        //                           // print('${FollowersData[index].id}');
        //                           // await _search_screen_controller
        //                           //     .Follow_unfollow_api(
        //                           //     follow_unfollow: (FollowersData[
        //                           //     index]
        //                           //         .userFollowUnfollow ==
        //                           //         'unfollow'
        //                           //         ? 'follow'
        //                           //         : 'unfollow'),
        //                           //     user_id:
        //                           //     FollowersData[index].id,
        //                           //     user_social:
        //                           //     FollowersData[index]
        //                           //         .socialType,
        //                           //     context: context);
        //                           // setState(() {
        //                           //   getAllFollowersList();
        //                           // });
        //                         },
        //                         child: Container(
        //                           child: Icon(
        //                             Icons.delete,
        //                             color: HexColor(CommonColor.pinkFont),
        //                           ),
        //                         )),
        //                   ),
        //                 ),
        //                 // Container(
        //                 //   margin:
        //                 //   EdgeInsets.symmetric(vertical: 5),
        //                 //   color: HexColor(CommonColor.pinkFont)
        //                 //       .withOpacity(0.5),
        //                 //   height: 0.5,
        //                 //   width:
        //                 //   MediaQuery.of(context).size.width,
        //                 // ),
        //               ],
        //             ),
        //           ],
        //         ),
        //       ),
        //     );
        //     data_ = Container(
        //       child: SingleChildScrollView(
        //         physics: NeverScrollableScrollPhysics(),
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             Container(
        //               child: Container(
        //                 // color: Colors.white,
        //                 padding: EdgeInsets.only(
        //                     left: 10, right: 10, bottom: 0, top: 20),
        //                 child: Text(
        //                   notificationModel!.data![i].title!,
        //                   textAlign: TextAlign.left,
        //                   style: TextStyle(
        //                       fontSize: 16,
        //                       color: HexColor(CommonColor.pinkFont),
        //                       fontFamily: 'PR'),
        //                 ),
        //               ),
        //             ),
        //             Container(
        //               child: ListView.builder(
        //                 itemCount: notificationModel!.data![i].notification!.length,
        //                 itemBuilder: (BuildContext context ,int index){
        //                   return Padding(
        //                     padding: const EdgeInsets.symmetric(vertical: 5.0),
        //                     child: ListTile(
        //                       visualDensity:
        //                       VisualDensity(vertical: 4, horizontal: -2),
        //                       leading: ClipRRect(
        //                         borderRadius: BorderRadius.circular(100),
        //                         child: Container(
        //                             height: 50,
        //                             width: 50,
        //                             child: FadeInImage.assetNetwork(
        //                               height: 80,
        //                               width: 80,
        //                               fit: BoxFit.cover,
        //                               image:
        //                               "${URLConstants.base_data_url}images/${notificationModel!.data![i].notification![j].image}",
        //                               placeholder:
        //                               'assets/images/Funky_App_Icon.png',
        //                             )
        //
        //                           // (FollowersData[index]
        //                           //     .image!
        //                           //     .isNotEmpty
        //                           //     ? Image.network(
        //                           //   "${URLConstants.base_data_url}images/${FollowersData[index].image!}",
        //                           //   height: 80,
        //                           //   width: 80,
        //                           //   fit: BoxFit.cover,
        //                           // )
        //                           //     : (FollowersData[index]
        //                           //     .profileUrl!
        //                           //     .isNotEmpty
        //                           //     ? Image.network(
        //                           //   FollowersData[index]
        //                           //       .profileUrl!,
        //                           //   height: 80,
        //                           //   width: 80,
        //                           //   fit: BoxFit.cover,
        //                           // )
        //                           //     : Image.asset(
        //                           //   AssetUtils.image1,
        //                           //   height: 80,
        //                           //   width: 80,
        //                           //   fit: BoxFit.cover,
        //                           // )))
        //                         ),
        //                       ),
        //                       title: Text("1 min Ago",
        //                           style: TextStyle(
        //                               fontSize: 12,
        //                               color: HexColor(CommonColor.grey_light2)
        //                                   .withOpacity(0.5),
        //                               fontFamily: 'PR')),
        //                       subtitle: Padding(
        //                         padding: EdgeInsets.symmetric(vertical: 10),
        //                         child: RichText(
        //                           text: TextSpan(
        //                               text:
        //                               '${notificationModel!.data![i].notification![j].userName}',
        //                               style: TextStyle(
        //                                   color: Colors.white,
        //                                   fontSize: 15,
        //                                   fontFamily: 'PR'),
        //                               children: <TextSpan>[
        //                                 TextSpan(
        //                                   text:
        //                                   ' ${notificationModel!.data![i].notification![j].status}',
        //                                   style: TextStyle(
        //                                       color:
        //                                       HexColor(CommonColor.pinkFont),
        //                                       fontSize: 14,
        //                                       fontFamily: 'PR'),
        //                                 )
        //                               ]),
        //                         ),
        //                       ),
        //                       trailing: GestureDetector(
        //                           onTap: () async {
        //                             // print('${FollowersData[index].id}');
        //                             // await _search_screen_controller
        //                             //     .Follow_unfollow_api(
        //                             //     follow_unfollow: (FollowersData[
        //                             //     index]
        //                             //         .userFollowUnfollow ==
        //                             //         'unfollow'
        //                             //         ? 'follow'
        //                             //         : 'unfollow'),
        //                             //     user_id:
        //                             //     FollowersData[index].id,
        //                             //     user_social:
        //                             //     FollowersData[index]
        //                             //         .socialType,
        //                             //     context: context);
        //                             // setState(() {
        //                             //   getAllFollowersList();
        //                             // });
        //                           },
        //                           child: Container(
        //                             child: Icon(
        //                               Icons.delete,
        //                               color: HexColor(CommonColor.pinkFont),
        //                             ),
        //                           )),
        //                     ),
        //                   ),
        //
        //                 },
        //               ),
        //             ),
        //             // Column(
        //             //   children: [
        //             //     Padding(
        //             //       padding: const EdgeInsets.symmetric(vertical: 5.0),
        //             //       child: ListTile(
        //             //         visualDensity:
        //             //             VisualDensity(vertical: 4, horizontal: -2),
        //             //         leading: ClipRRect(
        //             //           borderRadius: BorderRadius.circular(100),
        //             //           child: Container(
        //             //               height: 50,
        //             //               width: 50,
        //             //               child: FadeInImage.assetNetwork(
        //             //                 height: 80,
        //             //                 width: 80,
        //             //                 fit: BoxFit.cover,
        //             //                 image:
        //             //                     "${URLConstants.base_data_url}images/${notificationModel!.data![i].notification![j].image}",
        //             //                 placeholder:
        //             //                     'assets/images/Funky_App_Icon.png',
        //             //               )
        //             //
        //             //               // (FollowersData[index]
        //             //               //     .image!
        //             //               //     .isNotEmpty
        //             //               //     ? Image.network(
        //             //               //   "${URLConstants.base_data_url}images/${FollowersData[index].image!}",
        //             //               //   height: 80,
        //             //               //   width: 80,
        //             //               //   fit: BoxFit.cover,
        //             //               // )
        //             //               //     : (FollowersData[index]
        //             //               //     .profileUrl!
        //             //               //     .isNotEmpty
        //             //               //     ? Image.network(
        //             //               //   FollowersData[index]
        //             //               //       .profileUrl!,
        //             //               //   height: 80,
        //             //               //   width: 80,
        //             //               //   fit: BoxFit.cover,
        //             //               // )
        //             //               //     : Image.asset(
        //             //               //   AssetUtils.image1,
        //             //               //   height: 80,
        //             //               //   width: 80,
        //             //               //   fit: BoxFit.cover,
        //             //               // )))
        //             //               ),
        //             //         ),
        //             //         title: Text("1 min Ago",
        //             //             style: TextStyle(
        //             //                 fontSize: 12,
        //             //                 color: HexColor(CommonColor.grey_light2)
        //             //                     .withOpacity(0.5),
        //             //                 fontFamily: 'PR')),
        //             //         subtitle: Padding(
        //             //           padding: EdgeInsets.symmetric(vertical: 10),
        //             //           child: RichText(
        //             //             text: TextSpan(
        //             //                 text:
        //             //                     '${notificationModel!.data![i].notification![j].userName}',
        //             //                 style: TextStyle(
        //             //                     color: Colors.white,
        //             //                     fontSize: 15,
        //             //                     fontFamily: 'PR'),
        //             //                 children: <TextSpan>[
        //             //                   TextSpan(
        //             //                     text:
        //             //                         ' ${notificationModel!.data![i].notification![j].status}',
        //             //                     style: TextStyle(
        //             //                         color:
        //             //                             HexColor(CommonColor.pinkFont),
        //             //                         fontSize: 14,
        //             //                         fontFamily: 'PR'),
        //             //                   )
        //             //                 ]),
        //             //           ),
        //             //         ),
        //             //         trailing: GestureDetector(
        //             //             onTap: () async {
        //             //               // print('${FollowersData[index].id}');
        //             //               // await _search_screen_controller
        //             //               //     .Follow_unfollow_api(
        //             //               //     follow_unfollow: (FollowersData[
        //             //               //     index]
        //             //               //         .userFollowUnfollow ==
        //             //               //         'unfollow'
        //             //               //         ? 'follow'
        //             //               //         : 'unfollow'),
        //             //               //     user_id:
        //             //               //     FollowersData[index].id,
        //             //               //     user_social:
        //             //               //     FollowersData[index]
        //             //               //         .socialType,
        //             //               //     context: context);
        //             //               // setState(() {
        //             //               //   getAllFollowersList();
        //             //               // });
        //             //             },
        //             //             child: Container(
        //             //               child: Icon(
        //             //                 Icons.delete,
        //             //                 color: HexColor(CommonColor.pinkFont),
        //             //               ),
        //             //             )),
        //             //       ),
        //             //     ),
        //             //     // Container(
        //             //     //   margin:
        //             //     //   EdgeInsets.symmetric(vertical: 5),
        //             //     //   color: HexColor(CommonColor.pinkFont)
        //             //     //       .withOpacity(0.5),
        //             //     //   height: 0.5,
        //             //     //   width:
        //             //     //   MediaQuery.of(context).size.width,
        //             //     // ),
        //             //   ],
        //             // ),
        //           ],
        //         ),
        //       ),
        //     );
        //     setState(() {
        //       mohit.add(data_);
        //     });
        //   }

        print("mohit.length${mohit.length}");

        return notificationModel;
      } else {
        setState(() {
          isLoading = false;
        });
        // CommonWidget().showToaster(msg: msg.toString());
        return null;
      }
    } else if (response.statusCode == 422) {
      setState(() {
        isLoading = false;
      }); // CommonWidget().showToaster(msg: msg.toString());
    } else if (response.statusCode == 401) {
      setState(() {
        isLoading = false;
      });
      // CommonService().unAuthorizedUser();
    } else {
      // CommonWidget().showToaster(msg: msg.toString());
    }
  }

  ClearNotificationModel? clearNotificationModel;

  bool isclearing = false;

  Future<dynamic> clear_notifications_list(BuildContext context) async {
    setState(() {
      isclearing = true;
    });
    debugPrint('0-0-0-0-0-0-0 token');
    String idUser = await PreferenceManager().getPref(URLConstants.id);

    var url = (URLConstants.base_url + URLConstants.clear_notifications);

    Map data = {
      'user_id': idUser,
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
      clearNotificationModel = ClearNotificationModel.fromJson(data);
      if (clearNotificationModel!.error == false) {
        await get_notifications_list(context);
        setState(() {
          isclearing = false;
        });
        CommonWidget().showToaster(msg: clearNotificationModel!.message!);
      } else {
        setState(() {
          isclearing = false;
        });
        CommonWidget().showErrorToaster(msg: "Invalid Details");
        print('Please try again');
        print('Please try again');
      }
    } else {}
  }

  DeleteNotificationModel? deleteNotificationModel;

  Future<dynamic> delete_notification({required BuildContext context, required String noti_id}) async {
    // setState(() {
    //   isclearing = true;
    // });
    debugPrint('0-0-0-0-0-0-0 token');
    String idUser = await PreferenceManager().getPref(URLConstants.id);

    var url = (URLConstants.base_url + URLConstants.delete_notifications);

    Map data = {
      'id': noti_id,
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
      deleteNotificationModel = DeleteNotificationModel.fromJson(data);
      if (deleteNotificationModel!.error == false) {
        await get_notifications_list(context);
        // setState(() {
        //   isclearing =false;
        // });
        CommonWidget().showToaster(msg: deleteNotificationModel!.message!);
      } else {
        // setState(() {
        //   isclearing =false;
        // });
        CommonWidget().showErrorToaster(msg: "Invalid Details");
        print('Please try again');
        print('Please try again');
      }
    } else {}
  }

  ManualApproveTagModel? manualApproveTagModel;
  bool isApproveLoading = true;

  Future<dynamic> manually_approve_tag({
    required BuildContext context,
    required String user_id,
    required String type,
    required String type_id,
    required String notification_id,
    required String manual_tag,
  }) async {
    String idUser = await PreferenceManager().getPref(URLConstants.id);
    // String body = json.encode(data);

    // var url =
    //     ('${URLConstants.base_url + URLConstants.get_notifications}?user_id=52');
    var url = (URLConstants.base_url + URLConstants.menuallyApproveTag);
    // var url = ('${URLConstants.base_url}tagList.php?user_id=10000020');

    Map data = {
      'user_id': user_id,
      'type': type,
      'type_id': type_id,
      'menually_tag': manual_tag,
      'id': notification_id,
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
    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = convert.jsonDecode(response.body);
      manualApproveTagModel = ManualApproveTagModel.fromJson(data);
      if (manualApproveTagModel!.error == false) {
        debugPrint('2-2-2-2-2-2 Inside the product Controller Details ${manualApproveTagModel!}');
        setState(() {
          isLoading = false;
        });

        await get_notifications_list(context);

        // for (var i = 0; i < notificationModel!.data!.length; i++) {
        //   for (var j = 0;
        //       j < notificationModel!.data![i].notification!.length;
        //       j++) {
        //     dynamic title = Container(
        //       child: Container(
        //         // color: Colors.white,
        //         padding:
        //             EdgeInsets.only(left: 10, right: 10, bottom: 0, top: 20),
        //         child: Text(
        //           notificationModel!.data![i].title!,
        //           textAlign: TextAlign.left,
        //           style: TextStyle(
        //               fontSize: 16,
        //               color: HexColor(CommonColor.pinkFont),
        //               fontFamily: 'PR'),
        //         ),
        //       ),
        //     );
        //     dynamic list = Container(
        //       child: SingleChildScrollView(
        //         physics: NeverScrollableScrollPhysics(),
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             Column(
        //               children: [
        //                 Padding(
        //                   padding: const EdgeInsets.symmetric(vertical: 5.0),
        //                   child: ListTile(
        //                     visualDensity:
        //                         VisualDensity(vertical: 4, horizontal: -2),
        //                     leading: ClipRRect(
        //                       borderRadius: BorderRadius.circular(100),
        //                       child: Container(
        //                           height: 50,
        //                           width: 50,
        //                           child: FadeInImage.assetNetwork(
        //                             height: 80,
        //                             width: 80,
        //                             fit: BoxFit.cover,
        //                             image:
        //                                 "${URLConstants.base_data_url}images/${notificationModel!.data![i].notification![j].image}",
        //                             placeholder:
        //                                 'assets/images/Funky_App_Icon.png',
        //                           )
        //
        //                           // (FollowersData[index]
        //                           //     .image!
        //                           //     .isNotEmpty
        //                           //     ? Image.network(
        //                           //   "${URLConstants.base_data_url}images/${FollowersData[index].image!}",
        //                           //   height: 80,
        //                           //   width: 80,
        //                           //   fit: BoxFit.cover,
        //                           // )
        //                           //     : (FollowersData[index]
        //                           //     .profileUrl!
        //                           //     .isNotEmpty
        //                           //     ? Image.network(
        //                           //   FollowersData[index]
        //                           //       .profileUrl!,
        //                           //   height: 80,
        //                           //   width: 80,
        //                           //   fit: BoxFit.cover,
        //                           // )
        //                           //     : Image.asset(
        //                           //   AssetUtils.image1,
        //                           //   height: 80,
        //                           //   width: 80,
        //                           //   fit: BoxFit.cover,
        //                           // )))
        //                           ),
        //                     ),
        //                     title: Text("1 min Ago",
        //                         style: TextStyle(
        //                             fontSize: 12,
        //                             color: HexColor(CommonColor.grey_light2)
        //                                 .withOpacity(0.5),
        //                             fontFamily: 'PR')),
        //                     subtitle: Padding(
        //                       padding: EdgeInsets.symmetric(vertical: 10),
        //                       child: RichText(
        //                         text: TextSpan(
        //                             text:
        //                                 '${notificationModel!.data![i].notification![j].userName}',
        //                             style: TextStyle(
        //                                 color: Colors.white,
        //                                 fontSize: 15,
        //                                 fontFamily: 'PR'),
        //                             children: <TextSpan>[
        //                               TextSpan(
        //                                 text:
        //                                     ' ${notificationModel!.data![i].notification![j].status}',
        //                                 style: TextStyle(
        //                                     color:
        //                                         HexColor(CommonColor.pinkFont),
        //                                     fontSize: 14,
        //                                     fontFamily: 'PR'),
        //                               )
        //                             ]),
        //                       ),
        //                     ),
        //                     trailing: GestureDetector(
        //                         onTap: () async {
        //                           // print('${FollowersData[index].id}');
        //                           // await _search_screen_controller
        //                           //     .Follow_unfollow_api(
        //                           //     follow_unfollow: (FollowersData[
        //                           //     index]
        //                           //         .userFollowUnfollow ==
        //                           //         'unfollow'
        //                           //         ? 'follow'
        //                           //         : 'unfollow'),
        //                           //     user_id:
        //                           //     FollowersData[index].id,
        //                           //     user_social:
        //                           //     FollowersData[index]
        //                           //         .socialType,
        //                           //     context: context);
        //                           // setState(() {
        //                           //   getAllFollowersList();
        //                           // });
        //                         },
        //                         child: Container(
        //                           child: Icon(
        //                             Icons.delete,
        //                             color: HexColor(CommonColor.pinkFont),
        //                           ),
        //                         )),
        //                   ),
        //                 ),
        //                 // Container(
        //                 //   margin:
        //                 //   EdgeInsets.symmetric(vertical: 5),
        //                 //   color: HexColor(CommonColor.pinkFont)
        //                 //       .withOpacity(0.5),
        //                 //   height: 0.5,
        //                 //   width:
        //                 //   MediaQuery.of(context).size.width,
        //                 // ),
        //               ],
        //             ),
        //           ],
        //         ),
        //       ),
        //     );
        //     data_ = Container(
        //       child: SingleChildScrollView(
        //         physics: NeverScrollableScrollPhysics(),
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             Container(
        //               child: Container(
        //                 // color: Colors.white,
        //                 padding: EdgeInsets.only(
        //                     left: 10, right: 10, bottom: 0, top: 20),
        //                 child: Text(
        //                   notificationModel!.data![i].title!,
        //                   textAlign: TextAlign.left,
        //                   style: TextStyle(
        //                       fontSize: 16,
        //                       color: HexColor(CommonColor.pinkFont),
        //                       fontFamily: 'PR'),
        //                 ),
        //               ),
        //             ),
        //             Container(
        //               child: ListView.builder(
        //                 itemCount: notificationModel!.data![i].notification!.length,
        //                 itemBuilder: (BuildContext context ,int index){
        //                   return Padding(
        //                     padding: const EdgeInsets.symmetric(vertical: 5.0),
        //                     child: ListTile(
        //                       visualDensity:
        //                       VisualDensity(vertical: 4, horizontal: -2),
        //                       leading: ClipRRect(
        //                         borderRadius: BorderRadius.circular(100),
        //                         child: Container(
        //                             height: 50,
        //                             width: 50,
        //                             child: FadeInImage.assetNetwork(
        //                               height: 80,
        //                               width: 80,
        //                               fit: BoxFit.cover,
        //                               image:
        //                               "${URLConstants.base_data_url}images/${notificationModel!.data![i].notification![j].image}",
        //                               placeholder:
        //                               'assets/images/Funky_App_Icon.png',
        //                             )
        //
        //                           // (FollowersData[index]
        //                           //     .image!
        //                           //     .isNotEmpty
        //                           //     ? Image.network(
        //                           //   "${URLConstants.base_data_url}images/${FollowersData[index].image!}",
        //                           //   height: 80,
        //                           //   width: 80,
        //                           //   fit: BoxFit.cover,
        //                           // )
        //                           //     : (FollowersData[index]
        //                           //     .profileUrl!
        //                           //     .isNotEmpty
        //                           //     ? Image.network(
        //                           //   FollowersData[index]
        //                           //       .profileUrl!,
        //                           //   height: 80,
        //                           //   width: 80,
        //                           //   fit: BoxFit.cover,
        //                           // )
        //                           //     : Image.asset(
        //                           //   AssetUtils.image1,
        //                           //   height: 80,
        //                           //   width: 80,
        //                           //   fit: BoxFit.cover,
        //                           // )))
        //                         ),
        //                       ),
        //                       title: Text("1 min Ago",
        //                           style: TextStyle(
        //                               fontSize: 12,
        //                               color: HexColor(CommonColor.grey_light2)
        //                                   .withOpacity(0.5),
        //                               fontFamily: 'PR')),
        //                       subtitle: Padding(
        //                         padding: EdgeInsets.symmetric(vertical: 10),
        //                         child: RichText(
        //                           text: TextSpan(
        //                               text:
        //                               '${notificationModel!.data![i].notification![j].userName}',
        //                               style: TextStyle(
        //                                   color: Colors.white,
        //                                   fontSize: 15,
        //                                   fontFamily: 'PR'),
        //                               children: <TextSpan>[
        //                                 TextSpan(
        //                                   text:
        //                                   ' ${notificationModel!.data![i].notification![j].status}',
        //                                   style: TextStyle(
        //                                       color:
        //                                       HexColor(CommonColor.pinkFont),
        //                                       fontSize: 14,
        //                                       fontFamily: 'PR'),
        //                                 )
        //                               ]),
        //                         ),
        //                       ),
        //                       trailing: GestureDetector(
        //                           onTap: () async {
        //                             // print('${FollowersData[index].id}');
        //                             // await _search_screen_controller
        //                             //     .Follow_unfollow_api(
        //                             //     follow_unfollow: (FollowersData[
        //                             //     index]
        //                             //         .userFollowUnfollow ==
        //                             //         'unfollow'
        //                             //         ? 'follow'
        //                             //         : 'unfollow'),
        //                             //     user_id:
        //                             //     FollowersData[index].id,
        //                             //     user_social:
        //                             //     FollowersData[index]
        //                             //         .socialType,
        //                             //     context: context);
        //                             // setState(() {
        //                             //   getAllFollowersList();
        //                             // });
        //                           },
        //                           child: Container(
        //                             child: Icon(
        //                               Icons.delete,
        //                               color: HexColor(CommonColor.pinkFont),
        //                             ),
        //                           )),
        //                     ),
        //                   ),
        //
        //                 },
        //               ),
        //             ),
        //             // Column(
        //             //   children: [
        //             //     Padding(
        //             //       padding: const EdgeInsets.symmetric(vertical: 5.0),
        //             //       child: ListTile(
        //             //         visualDensity:
        //             //             VisualDensity(vertical: 4, horizontal: -2),
        //             //         leading: ClipRRect(
        //             //           borderRadius: BorderRadius.circular(100),
        //             //           child: Container(
        //             //               height: 50,
        //             //               width: 50,
        //             //               child: FadeInImage.assetNetwork(
        //             //                 height: 80,
        //             //                 width: 80,
        //             //                 fit: BoxFit.cover,
        //             //                 image:
        //             //                     "${URLConstants.base_data_url}images/${notificationModel!.data![i].notification![j].image}",
        //             //                 placeholder:
        //             //                     'assets/images/Funky_App_Icon.png',
        //             //               )
        //             //
        //             //               // (FollowersData[index]
        //             //               //     .image!
        //             //               //     .isNotEmpty
        //             //               //     ? Image.network(
        //             //               //   "${URLConstants.base_data_url}images/${FollowersData[index].image!}",
        //             //               //   height: 80,
        //             //               //   width: 80,
        //             //               //   fit: BoxFit.cover,
        //             //               // )
        //             //               //     : (FollowersData[index]
        //             //               //     .profileUrl!
        //             //               //     .isNotEmpty
        //             //               //     ? Image.network(
        //             //               //   FollowersData[index]
        //             //               //       .profileUrl!,
        //             //               //   height: 80,
        //             //               //   width: 80,
        //             //               //   fit: BoxFit.cover,
        //             //               // )
        //             //               //     : Image.asset(
        //             //               //   AssetUtils.image1,
        //             //               //   height: 80,
        //             //               //   width: 80,
        //             //               //   fit: BoxFit.cover,
        //             //               // )))
        //             //               ),
        //             //         ),
        //             //         title: Text("1 min Ago",
        //             //             style: TextStyle(
        //             //                 fontSize: 12,
        //             //                 color: HexColor(CommonColor.grey_light2)
        //             //                     .withOpacity(0.5),
        //             //                 fontFamily: 'PR')),
        //             //         subtitle: Padding(
        //             //           padding: EdgeInsets.symmetric(vertical: 10),
        //             //           child: RichText(
        //             //             text: TextSpan(
        //             //                 text:
        //             //                     '${notificationModel!.data![i].notification![j].userName}',
        //             //                 style: TextStyle(
        //             //                     color: Colors.white,
        //             //                     fontSize: 15,
        //             //                     fontFamily: 'PR'),
        //             //                 children: <TextSpan>[
        //             //                   TextSpan(
        //             //                     text:
        //             //                         ' ${notificationModel!.data![i].notification![j].status}',
        //             //                     style: TextStyle(
        //             //                         color:
        //             //                             HexColor(CommonColor.pinkFont),
        //             //                         fontSize: 14,
        //             //                         fontFamily: 'PR'),
        //             //                   )
        //             //                 ]),
        //             //           ),
        //             //         ),
        //             //         trailing: GestureDetector(
        //             //             onTap: () async {
        //             //               // print('${FollowersData[index].id}');
        //             //               // await _search_screen_controller
        //             //               //     .Follow_unfollow_api(
        //             //               //     follow_unfollow: (FollowersData[
        //             //               //     index]
        //             //               //         .userFollowUnfollow ==
        //             //               //         'unfollow'
        //             //               //         ? 'follow'
        //             //               //         : 'unfollow'),
        //             //               //     user_id:
        //             //               //     FollowersData[index].id,
        //             //               //     user_social:
        //             //               //     FollowersData[index]
        //             //               //         .socialType,
        //             //               //     context: context);
        //             //               // setState(() {
        //             //               //   getAllFollowersList();
        //             //               // });
        //             //             },
        //             //             child: Container(
        //             //               child: Icon(
        //             //                 Icons.delete,
        //             //                 color: HexColor(CommonColor.pinkFont),
        //             //               ),
        //             //             )),
        //             //       ),
        //             //     ),
        //             //     // Container(
        //             //     //   margin:
        //             //     //   EdgeInsets.symmetric(vertical: 5),
        //             //     //   color: HexColor(CommonColor.pinkFont)
        //             //     //       .withOpacity(0.5),
        //             //     //   height: 0.5,
        //             //     //   width:
        //             //     //   MediaQuery.of(context).size.width,
        //             //     // ),
        //             //   ],
        //             // ),
        //           ],
        //         ),
        //       ),
        //     );
        //     setState(() {
        //       mohit.add(data_);
        //     });
        //   }

        print("mohit.length${mohit.length}");

        return manualApproveTagModel;
      } else {
        setState(() {
          isLoading = false;
        });
        // CommonWidget().showToaster(msg: msg.toString());
        return null;
      }
    } else if (response.statusCode == 422) {
      setState(() {
        isLoading = false;
      }); // CommonWidget().showToaster(msg: msg.toString());
    } else if (response.statusCode == 401) {
      setState(() {
        isLoading = false;
      });
      // CommonService().unAuthorizedUser();
    } else {
      // CommonWidget().showToaster(msg: msg.toString());
    }
  }
}
