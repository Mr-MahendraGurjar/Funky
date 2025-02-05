import 'dart:convert' as convert;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:funky_new/settings/settings_controller.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

import '../../../Utils/colorUtils.dart';
import '../../Utils/App_utils.dart';
import '../../sharePreference.dart';
import 'model/notificationGetModel.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({Key? key}) : super(key: key);

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  bool pause_all = false;
  bool post_story = false;
  bool following_followers = false;
  bool message = false;
  bool live_video = false;
  bool funky = false;

  final Settings_controller _settings_controller =
      Get.put(Settings_controller(), tag: Settings_controller().toString());

  @override
  void initState() {
    getNotificationSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Notification setting',
          style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'PB'),
        ),
        centerTitle: true,
        leadingWidth: 100,
        leading: Padding(
          padding: const EdgeInsets.only(
            right: 20.0,
            top: 0.0,
            bottom: 5.0,
          ),
          child: ClipRRect(
              child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          )),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              Container(
                child: Text(
                  'Push Notification',
                  style: TextStyle(fontSize: 16, color: HexColor(CommonColor.pinkFont), fontFamily: 'PB'),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text('Pause all', style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'PR  ')),
                    ),
                    Transform.scale(
                      scale: 0.7,
                      child: Theme(
                        data: ThemeData(
                          unselectedWidgetColor: HexColor(CommonColor.pinkFont),
                        ),
                        child: CupertinoSwitch(
                          value: pause_all,
                          onChanged: (value) async {
                            setState(() {
                              pause_all = value;
                              print(pause_all);
                            });
                            await _settings_controller.PostNotificationSetting(
                                privacy: pause_all.toString(), title: 'pause_all');
                          },
                          thumbColor: Colors.black,
                          activeColor: HexColor(CommonColor.pinkFont),
                          trackColor: HexColor(CommonColor.pinkFont_light),
                          // activeColor: HexColor(CommonColor.pinkFont),
                          // inactiveTrackColor: Colors.red[100],
                          // inactiveThumbColor: HexColor(CommonColor.pinkFont),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                color: HexColor(CommonColor.pinkFont).withOpacity(0.15),
                height: 0.5,
                width: MediaQuery.of(context).size.width,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text('Stories and Comments',
                          maxLines: 2, style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'PR  ')),
                    ),
                    Transform.scale(
                      scale: 0.7,
                      child: Theme(
                        data: ThemeData(
                          unselectedWidgetColor: HexColor(CommonColor.pinkFont),
                        ),
                        child: CupertinoSwitch(
                          value: post_story,
                          onChanged: (value) async {
                            setState(() {
                              post_story = value;
                              print(post_story);
                            });
                            await _settings_controller.PostNotificationSetting(
                                privacy: post_story.toString(), title: 'post_story_comment');
                          },
                          thumbColor: Colors.black,
                          activeColor: HexColor(CommonColor.pinkFont),
                          trackColor: HexColor(CommonColor.pinkFont_light),
                          // activeColor: HexColor(CommonColor.pinkFont),
                          // inactiveTrackColor: Colors.red[100],
                          // inactiveThumbColor: HexColor(CommonColor.pinkFont),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                color: HexColor(CommonColor.pinkFont).withOpacity(0.15),
                height: 0.5,
                width: MediaQuery.of(context).size.width,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text('Following and followers',
                          maxLines: 2, style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'PR  ')),
                    ),
                    Transform.scale(
                      scale: 0.7,
                      child: Theme(
                        data: ThemeData(
                          unselectedWidgetColor: HexColor(CommonColor.pinkFont),
                        ),
                        child: CupertinoSwitch(
                          value: following_followers,
                          onChanged: (value) async {
                            setState(() {
                              following_followers = value;
                              print(following_followers);
                            });
                            await _settings_controller.PostNotificationSetting(
                                privacy: following_followers.toString(), title: 'following_followers');
                          },
                          thumbColor: Colors.black,
                          activeColor: HexColor(CommonColor.pinkFont),
                          trackColor: HexColor(CommonColor.pinkFont_light),
                          // activeColor: HexColor(CommonColor.pinkFont),
                          // inactiveTrackColor: Colors.red[100],
                          // inactiveThumbColor: HexColor(CommonColor.pinkFont),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                color: HexColor(CommonColor.pinkFont).withOpacity(0.15),
                height: 0.5,
                width: MediaQuery.of(context).size.width,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text('Messages',
                          maxLines: 2, style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'PR  ')),
                    ),
                    Transform.scale(
                      scale: 0.7,
                      child: Theme(
                        data: ThemeData(
                          unselectedWidgetColor: HexColor(CommonColor.pinkFont),
                        ),
                        child: CupertinoSwitch(
                          value: message,
                          onChanged: (value) async {
                            setState(() {
                              message = value;
                              print(message);
                            });
                            await _settings_controller.PostNotificationSetting(
                                privacy: message.toString(), title: 'message_call');
                          },
                          thumbColor: Colors.black,
                          activeColor: HexColor(CommonColor.pinkFont),
                          trackColor: HexColor(CommonColor.pinkFont_light),
                          // activeColor: HexColor(CommonColor.pinkFont),
                          // inactiveTrackColor: Colors.red[100],
                          // inactiveThumbColor: HexColor(CommonColor.pinkFont),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                color: HexColor(CommonColor.pinkFont).withOpacity(0.15),
                height: 0.5,
                width: MediaQuery.of(context).size.width,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text('Live',
                          maxLines: 2, style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'PR  ')),
                    ),
                    Transform.scale(
                      scale: 0.7,
                      child: Theme(
                        data: ThemeData(
                          unselectedWidgetColor: HexColor(CommonColor.pinkFont),
                        ),
                        child: CupertinoSwitch(
                          value: live_video,
                          onChanged: (value) async {
                            setState(() {
                              live_video = value;
                              print(live_video);
                            });
                            await _settings_controller.PostNotificationSetting(
                                privacy: live_video.toString(), title: 'live_video');
                          },
                          thumbColor: Colors.black,
                          activeColor: HexColor(CommonColor.pinkFont),
                          trackColor: HexColor(CommonColor.pinkFont_light),
                          // activeColor: HexColor(CommonColor.pinkFont),
                          // inactiveTrackColor: Colors.red[100],
                          // inactiveThumbColor: HexColor(CommonColor.pinkFont),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                color: HexColor(CommonColor.pinkFont).withOpacity(0.15),
                height: 0.5,
                width: MediaQuery.of(context).size.width,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text('From Funky',
                          maxLines: 2, style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'PR  ')),
                    ),
                    Transform.scale(
                      scale: 0.7,
                      child: Theme(
                        data: ThemeData(
                          unselectedWidgetColor: HexColor(CommonColor.pinkFont),
                        ),
                        child: CupertinoSwitch(
                          value: funky,
                          onChanged: (value) async {
                            setState(() {
                              funky = value;
                              print(funky);
                            });
                            await _settings_controller.PostNotificationSetting(
                                privacy: funky.toString(), title: 'from_funky');
                          },
                          thumbColor: Colors.black,
                          activeColor: HexColor(CommonColor.pinkFont),
                          trackColor: HexColor(CommonColor.pinkFont_light),
                          // activeColor: HexColor(CommonColor.pinkFont),
                          // inactiveTrackColor: Colors.red[100],
                          // inactiveThumbColor: HexColor(CommonColor.pinkFont),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              // Container(
              //   child: Text(
              //     'Other Notification Type',
              //     style: TextStyle(
              //         fontSize: 16,
              //         color: HexColor(CommonColor.pinkFont),
              //         fontFamily: 'PB'),
              //   ),
              // ),
              // SizedBox(
              //   height: 20,
              // ),
              // Container(
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Container(
              //         width: 200,
              //         child: Text('Email and SMS',
              //             maxLines: 2,
              //             style: TextStyle(
              //                 fontSize: 16,
              //                 color: Colors.white,
              //                 fontFamily: 'PR  ')),
              //       ),
              //       // Container(
              //       //   child: Theme(
              //       //     data: ThemeData(
              //       //         unselectedWidgetColor: HexColor(CommonColor.pinkFont)
              //       //     ),
              //       //     child: Switch(
              //       //
              //       //       value: isSwitched,
              //       //       onChanged: (value) {
              //       //         setState(() {
              //       //           isSwitched = value;
              //       //           print(isSwitched);
              //       //         });
              //       //       },
              //       //       activeColor: HexColor(CommonColor.pinkFont),
              //       //       inactiveTrackColor: Colors.red[100],
              //       //       inactiveThumbColor: HexColor(CommonColor.pinkFont),
              //       //     ),
              //       //   ),
              //       // )
              //     ],
              //   ),
              // ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }

  GetNotificationSettingModel? getNotificationSettingModel;

  Future<dynamic> getNotificationSettings() async {
    String id_user = await PreferenceManager().getPref(URLConstants.id);

    String url = ("${URLConstants.base_url}${URLConstants.get_Notification_setting}?user_id=$id_user");

    http.Response response = await http.get(Uri.parse(url));

    print('Response request: ${response.request}');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = convert.jsonDecode(response.body);
      getNotificationSettingModel = GetNotificationSettingModel.fromJson(data);
      // getVideoModelList(searchlistModel);
      if (getNotificationSettingModel!.error == false) {
        debugPrint(
            '2-2-2-2-2-2 Inside the product Controller Details ${getNotificationSettingModel!.notificationSetting!.length}');

        setState(() {
          (getNotificationSettingModel!.notificationSetting![0].pauseAll == "true"
              ? pause_all = true
              : pause_all = false);
          (getNotificationSettingModel!.notificationSetting![0].postStoryComment == "true"
              ? post_story = true
              : post_story = false);
          (getNotificationSettingModel!.notificationSetting![0].followingFollowers == "true"
              ? following_followers = true
              : following_followers = false);
          (getNotificationSettingModel!.notificationSetting![0].messageCall == "true"
              ? message = true
              : message = false);
          (getNotificationSettingModel!.notificationSetting![0].liveVideo == "true"
              ? live_video = true
              : live_video = false);
          (getNotificationSettingModel!.notificationSetting![0].fromFunky == "true" ? funky = true : funky = false);
        });

        // CommonWidget().showToaster(msg: data["success"].toString());
        return getNotificationSettingModel;
      } else {
        // CommonWidget().showToaster(msg: msg.toString());
        return null;
      }
    } else if (response.statusCode == 422) {
      // CommonWidget().showToaster(msg: msg.toString());
    } else if (response.statusCode == 401) {
      // CommonService().unAuthorizedUser();
    } else {
      // CommonWidget().showToaster(msg: msg.toString());
    }
  }
}
