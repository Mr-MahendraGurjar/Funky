import 'dart:convert' as convert;
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

import '../../../Utils/colorUtils.dart';
import '../../Utils/App_utils.dart';
import '../../custom_widget/common_buttons.dart';
import '../../sharePreference.dart';
import 'controller/manage_account_controller.dart';
import 'model/getuserSettingModel.dart';

class PrivcacyScreen extends StatefulWidget {
  const PrivcacyScreen({Key? key}) : super(key: key);

  @override
  State<PrivcacyScreen> createState() => _PrivcacyScreenState();
}

enum Change_account { public, private }

enum Suggest_account { contactonly, everyone }

enum Liked_video { onlyme, friends, everyone }

enum Social_media { onlyme, friends, everyone }

enum Comment_video_photo { contactonly, everyone }

enum View_video_photo { contactonly, everyone }

enum View_story { contactonly, everyone }

enum Group_chat { contactonly, everyone }

enum View_live { contactonly, everyone }

enum Comment_live { contactonly, everyone }

enum Request_join { contactonly, everyone }

class _PrivcacyScreenState extends State<PrivcacyScreen> {
  Change_account? _os = Change_account.private;
  Suggest_account? _os2 = Suggest_account.contactonly;
  Liked_video? _os3 = Liked_video.everyone;
  Social_media? _os4 = Social_media.everyone;
  Comment_video_photo? _comment_video_photo = Comment_video_photo.everyone;
  View_video_photo? _view_video_photo = View_video_photo.everyone;
  View_story? _view_story = View_story.everyone;
  Group_chat? _group_chat = Group_chat.everyone;
  View_live? _view_live = View_live.everyone;
  Comment_live? _comment_live = Comment_live.everyone;
  Request_join? _request_join = Request_join.everyone;

  bool ad_pers = false;
  bool download_req = false;

  final Manage_account_controller _manage_account_controller =
      Get.put(Manage_account_controller(), tag: Manage_account_controller().toString());

  @override
  void initState() {
    getUserSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    print("screenHeight $screenHeight");
    print("screenWidth $screenWidth");
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Privacy Settings',
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
        physics: ClampingScrollPhysics(),
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
                  'Change account',
                  style: TextStyle(fontSize: 16, color: HexColor(CommonColor.pinkFont), fontFamily: 'PB'),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Flexible(
                    child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                        title: Text('Public', style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'PR  ')),
                        leading: Theme(
                          data: ThemeData(unselectedWidgetColor: Colors.white),
                          child: Radio<Change_account>(
                            activeColor: HexColor(CommonColor.pinkFont),
                            value: Change_account.public,
                            groupValue: _os,
                            onChanged: (Change_account? value) async {
                              setState(() {
                                _os = value;
                              });
                              await _manage_account_controller.PostUserSetting(
                                  privacy: "true", title: 'change_account');
                            },
                          ),
                        )),
                  ),
                  Flexible(
                    child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                        title: Text('Private', style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'PR  ')),
                        leading: Theme(
                            data: ThemeData(unselectedWidgetColor: Colors.white),
                            child: Radio<Change_account>(
                              activeColor: HexColor(CommonColor.pinkFont),
                              value: Change_account.private,
                              groupValue: _os,
                              onChanged: (Change_account? value) async {
                                setState(() {
                                  _os = value;
                                });
                                await _manage_account_controller.PostUserSetting(
                                    privacy: "false", title: 'change_account');
                              },
                            ))),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                color: HexColor(CommonColor.pinkFont).withOpacity(0.5),
                height: 0.5,
                width: MediaQuery.of(context).size.width,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Text(
                  'Suggest Account',
                  style: TextStyle(fontSize: 16, color: HexColor(CommonColor.pinkFont), fontFamily: 'PB'),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Flexible(
                    child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                        title: Text('Contact only',
                            style: TextStyle(fontSize: 14, color: Colors.white, fontFamily: 'PR  ')),
                        leading: Theme(
                            data: ThemeData(unselectedWidgetColor: Colors.white),
                            child: Radio<Suggest_account>(
                              activeColor: HexColor(CommonColor.pinkFont),
                              value: Suggest_account.contactonly,
                              groupValue: _os2,
                              onChanged: (Suggest_account? value) async {
                                setState(() {
                                  _os2 = value;
                                });
                                await _manage_account_controller.PostUserSetting(
                                    privacy: "true", title: 'suggested_account');
                              },
                            ))),
                  ),
                  Flexible(
                    child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                        title:
                            Text('Everyone', style: TextStyle(fontSize: 14, color: Colors.white, fontFamily: 'PR  ')),
                        leading: Theme(
                            data: ThemeData(
                              unselectedWidgetColor: Colors.white,
                            ),
                            child: Radio<Suggest_account>(
                              activeColor: HexColor(CommonColor.pinkFont),
                              value: Suggest_account.everyone,
                              groupValue: _os2,
                              onChanged: (Suggest_account? value) async {
                                setState(() {
                                  _os2 = value;
                                });
                                await _manage_account_controller.PostUserSetting(
                                    privacy: "false", title: 'suggested_account');
                              },
                            ))),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                color: HexColor(CommonColor.pinkFont).withOpacity(0.5),
                height: 0.5,
                width: MediaQuery.of(context).size.width,
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Text('Sync phone contatcs',
                    style: TextStyle(fontSize: 16, color: HexColor('#878787'), fontFamily: 'PR  ')),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text('Ads personalization',
                          style: TextStyle(fontSize: 14, color: Colors.white, fontFamily: 'PR  ')),
                    ),
                    Transform.scale(
                      scale: 0.7,
                      child: Theme(
                        data: ThemeData(unselectedWidgetColor: HexColor(CommonColor.pinkFont)),
                        child: CupertinoSwitch(
                          value: ad_pers,
                          onChanged: (value) async {
                            setState(() {
                              ad_pers = value;
                              print(ad_pers);
                            });
                            await _manage_account_controller.PostUserSetting(
                                privacy: ad_pers.toString(), title: 'ads_personalization');
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
                margin: EdgeInsets.symmetric(vertical: 20),
                color: HexColor(CommonColor.pinkFont).withOpacity(0.5),
                height: 0.5,
                width: MediaQuery.of(context).size.width,
              ),
              GestureDetector(
                onTap: () {
                  selectTowerBottomSheet(context);
                },
                child: Container(
                  // width: 200,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(15), color: HexColor(CommonColor.pinkFont)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12),
                    child: Text('Download your data',
                        maxLines: 2, style: TextStyle(fontSize: 14, color: Colors.white, fontFamily: 'PR  ')),
                  ),
                ),
              ),
              // Transform.scale(
              //   scale: 0.7,
              //   child: Theme(
              //     data: ThemeData(
              //         unselectedWidgetColor:
              //             HexColor(CommonColor.pinkFont)),
              //     child: CupertinoSwitch(
              //       value: download_req,
              //       onChanged: (value) async {
              //         setState(() {
              //           download_req = value;
              //           print(download_req);
              //         });
              //         await _manage_account_controller.PostUserSetting(
              //             privacy: download_req.toString(),
              //             title: 'download_data');
              //       },
              //       thumbColor: Colors.black,
              //       activeColor: HexColor(CommonColor.pinkFont),
              //       trackColor: HexColor(CommonColor.pinkFont_light),
              //       // activeColor: HexColor(CommonColor.pinkFont),
              //       // inactiveTrackColor: Colors.red[100],
              //       // inactiveThumbColor: HexColor(CommonColor.pinkFont),
              //     ),
              //   ),
              // )

              Container(
                margin: EdgeInsets.symmetric(vertical: 25),
                child: Text('Who can view their liked videos',
                    style: TextStyle(fontSize: 16, color: HexColor(CommonColor.pinkFont), fontFamily: 'PB')),
              ),
              (screenWidth <= 400
                  ? Column(
                      children: [
                        ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                            title: Transform(
                                transform: Matrix4.translationValues(-16, 0.0, 0.0),
                                child: Text('Only me',
                                    style: TextStyle(fontSize: 14, color: Colors.white, fontFamily: 'PR  '))),
                            leading: Theme(
                                data: ThemeData(unselectedWidgetColor: Colors.white),
                                child: Radio<Liked_video>(
                                  activeColor: HexColor(CommonColor.pinkFont),
                                  value: Liked_video.onlyme,
                                  groupValue: _os3,
                                  onChanged: (Liked_video? value) async {
                                    setState(() {
                                      _os3 = value;
                                    });
                                    await _manage_account_controller.PostUserSetting(
                                        privacy: "0", title: 'liked_video');
                                  },
                                ))),
                        ListTile(
                            contentPadding: EdgeInsets.zero,
                            visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                            title: Transform(
                                transform: Matrix4.translationValues(-16, 0.0, 0.0),
                                child: Text('Friends',
                                    style: TextStyle(fontSize: 14, color: Colors.white, fontFamily: 'PR  '))),
                            leading: Theme(
                                data: ThemeData(
                                  unselectedWidgetColor: Colors.white,
                                ),
                                child: Radio<Liked_video>(
                                  activeColor: HexColor(CommonColor.pinkFont),
                                  value: Liked_video.friends,
                                  groupValue: _os3,
                                  onChanged: (Liked_video? value) async {
                                    setState(() {
                                      _os3 = value;
                                    });
                                    await _manage_account_controller.PostUserSetting(
                                        privacy: "1", title: 'liked_video');
                                  },
                                ))),
                        ListTile(
                            contentPadding: EdgeInsets.zero,
                            visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                            title: Transform(
                                transform: Matrix4.translationValues(-16, 0.0, 0.0),
                                child: Text('Everyone',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 14, color: Colors.white, fontFamily: 'PR  '))),
                            leading: Theme(
                                data: ThemeData(
                                  unselectedWidgetColor: Colors.white,
                                ),
                                child: Radio<Liked_video>(
                                  activeColor: HexColor(CommonColor.pinkFont),
                                  value: Liked_video.everyone,
                                  groupValue: _os3,
                                  onChanged: (Liked_video? value) async {
                                    setState(() {
                                      _os3 = value;
                                    });
                                    await _manage_account_controller.PostUserSetting(
                                        privacy: "2", title: 'liked_video');
                                  },
                                ))),
                      ],
                    )
                  : Row(
                      children: [
                        Flexible(
                          child: ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                              title: Transform(
                                  transform: Matrix4.translationValues(-16, 0.0, 0.0),
                                  child: Text('Only me',
                                      style: TextStyle(fontSize: 12, color: Colors.white, fontFamily: 'PR  '))),
                              leading: Theme(
                                  data: ThemeData(unselectedWidgetColor: Colors.white),
                                  child: Radio<Liked_video>(
                                    activeColor: HexColor(CommonColor.pinkFont),
                                    value: Liked_video.onlyme,
                                    groupValue: _os3,
                                    onChanged: (Liked_video? value) async {
                                      setState(() {
                                        _os3 = value;
                                      });
                                      await _manage_account_controller.PostUserSetting(
                                          privacy: "0", title: 'liked_video');
                                    },
                                  ))),
                        ),
                        Flexible(
                          child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                              title: Transform(
                                  transform: Matrix4.translationValues(-16, 0.0, 0.0),
                                  child: Text('Friends',
                                      style: TextStyle(fontSize: 12, color: Colors.white, fontFamily: 'PR  '))),
                              leading: Theme(
                                  data: ThemeData(
                                    unselectedWidgetColor: Colors.white,
                                  ),
                                  child: Radio<Liked_video>(
                                    activeColor: HexColor(CommonColor.pinkFont),
                                    value: Liked_video.friends,
                                    groupValue: _os3,
                                    onChanged: (Liked_video? value) async {
                                      setState(() {
                                        _os3 = value;
                                      });
                                      await _manage_account_controller.PostUserSetting(
                                          privacy: "1", title: 'liked_video');
                                    },
                                  ))),
                        ),
                        Flexible(
                          child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                              title: Transform(
                                  transform: Matrix4.translationValues(-16, 0.0, 0.0),
                                  child: Text('Everyone',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 12, color: Colors.white, fontFamily: 'PR  '))),
                              leading: Theme(
                                  data: ThemeData(
                                    unselectedWidgetColor: Colors.white,
                                  ),
                                  child: Radio<Liked_video>(
                                    activeColor: HexColor(CommonColor.pinkFont),
                                    value: Liked_video.everyone,
                                    groupValue: _os3,
                                    onChanged: (Liked_video? value) async {
                                      setState(() {
                                        _os3 = value;
                                      });
                                      await _manage_account_controller.PostUserSetting(
                                          privacy: "2", title: 'liked_video');
                                    },
                                  ))),
                        ),
                      ],
                    )),

              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                color: HexColor(CommonColor.pinkFont).withOpacity(0.5),
                height: 0.5,
                width: MediaQuery.of(context).size.width,
              ),
              Container(
                // margin: EdgeInsets.symmetric(vertical: 25),
                child: Text('Who can view social media links',
                    style: TextStyle(fontSize: 16, color: HexColor(CommonColor.pinkFont), fontFamily: 'PB')),
              ),
              SizedBox(
                height: 25,
              ),

              (screenWidth <= 400
                  ? Column(
                      children: [
                        ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                            title: Transform(
                                transform: Matrix4.translationValues(-16, 0.0, 0.0),
                                child: Text('Only me',
                                    style: TextStyle(fontSize: 14, color: Colors.white, fontFamily: 'PR  '))),
                            leading: Theme(
                                data: ThemeData(unselectedWidgetColor: Colors.white),
                                child: Radio<Social_media>(
                                  activeColor: HexColor(CommonColor.pinkFont),
                                  value: Social_media.onlyme,
                                  groupValue: _os4,
                                  onChanged: (Social_media? value) async {
                                    setState(() {
                                      _os4 = value;
                                    });
                                    await _manage_account_controller.PostUserSetting(
                                        privacy: "0", title: 'social_media_links');
                                  },
                                ))),
                        ListTile(
                            contentPadding: EdgeInsets.zero,
                            visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                            title: Transform(
                                transform: Matrix4.translationValues(-16, 0.0, 0.0),
                                child: Text('Friends',
                                    style: TextStyle(fontSize: 14, color: Colors.white, fontFamily: 'PR  '))),
                            leading: Theme(
                                data: ThemeData(
                                  unselectedWidgetColor: Colors.white,
                                ),
                                child: Radio<Social_media>(
                                  activeColor: HexColor(CommonColor.pinkFont),
                                  value: Social_media.friends,
                                  groupValue: _os4,
                                  onChanged: (Social_media? value) async {
                                    setState(() {
                                      _os4 = value;
                                    });
                                    await _manage_account_controller.PostUserSetting(
                                        privacy: "1", title: 'social_media_links');
                                  },
                                ))),
                        ListTile(
                            contentPadding: EdgeInsets.zero,
                            visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                            title: Transform(
                                transform: Matrix4.translationValues(-16, 0.0, 0.0),
                                child: Text('Everyone',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 14, color: Colors.white, fontFamily: 'PR  '))),
                            leading: Theme(
                                data: ThemeData(
                                  unselectedWidgetColor: Colors.white,
                                ),
                                child: Radio<Social_media>(
                                  activeColor: HexColor(CommonColor.pinkFont),
                                  value: Social_media.everyone,
                                  groupValue: _os4,
                                  onChanged: (Social_media? value) async {
                                    setState(() {
                                      _os4 = value;
                                    });
                                    await _manage_account_controller.PostUserSetting(
                                        privacy: "2", title: 'social_media_links');
                                  },
                                ))),
                      ],
                    )
                  : Row(
                      children: [
                        Flexible(
                          child: ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                              title: Transform(
                                  transform: Matrix4.translationValues(-16, 0.0, 0.0),
                                  child: Text('Only me',
                                      style: TextStyle(fontSize: 12, color: Colors.white, fontFamily: 'PR  '))),
                              leading: Theme(
                                  data: ThemeData(unselectedWidgetColor: Colors.white),
                                  child: Radio<Social_media>(
                                    activeColor: HexColor(CommonColor.pinkFont),
                                    value: Social_media.onlyme,
                                    groupValue: _os4,
                                    onChanged: (Social_media? value) async {
                                      setState(() {
                                        _os4 = value;
                                      });
                                      await _manage_account_controller.PostUserSetting(
                                          privacy: "0", title: 'social_media_links');
                                    },
                                  ))),
                        ),
                        Flexible(
                          child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                              title: Transform(
                                  transform: Matrix4.translationValues(-16, 0.0, 0.0),
                                  child: Text('Friends',
                                      style: TextStyle(fontSize: 12, color: Colors.white, fontFamily: 'PR  '))),
                              leading: Theme(
                                  data: ThemeData(
                                    unselectedWidgetColor: Colors.white,
                                  ),
                                  child: Radio<Social_media>(
                                    activeColor: HexColor(CommonColor.pinkFont),
                                    value: Social_media.friends,
                                    groupValue: _os4,
                                    onChanged: (Social_media? value) async {
                                      setState(() {
                                        _os4 = value;
                                      });
                                      await _manage_account_controller.PostUserSetting(
                                          privacy: "1", title: 'social_media_links');
                                    },
                                  ))),
                        ),
                        Flexible(
                          child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                              title: Transform(
                                  transform: Matrix4.translationValues(-16, 0.0, 0.0),
                                  child: Text('Everyone',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 12, color: Colors.white, fontFamily: 'PR  '))),
                              leading: Theme(
                                  data: ThemeData(
                                    unselectedWidgetColor: Colors.white,
                                  ),
                                  child: Radio<Social_media>(
                                    activeColor: HexColor(CommonColor.pinkFont),
                                    value: Social_media.everyone,
                                    groupValue: _os4,
                                    onChanged: (Social_media? value) async {
                                      setState(() {
                                        _os4 = value;
                                      });
                                      await _manage_account_controller.PostUserSetting(
                                          privacy: "2", title: 'social_media_links');
                                    },
                                  ))),
                        ),
                      ],
                    )),

              /// ------------------------who can comment on your videos/photos
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                color: HexColor(CommonColor.pinkFont).withOpacity(0.5),
                height: 0.5,
                width: MediaQuery.of(context).size.width,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Text(
                  'Who can comment on your videos and photos',
                  style: TextStyle(fontSize: 16, color: HexColor(CommonColor.pinkFont), fontFamily: 'PB'),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Flexible(
                    child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                        title:
                            Text('Following', style: TextStyle(fontSize: 14, color: Colors.white, fontFamily: 'PR  ')),
                        leading: Theme(
                            data: ThemeData(unselectedWidgetColor: Colors.white),
                            child: Radio<Comment_video_photo>(
                              activeColor: HexColor(CommonColor.pinkFont),
                              value: Comment_video_photo.contactonly,
                              groupValue: _comment_video_photo,
                              onChanged: (Comment_video_photo? value) async {
                                setState(() {
                                  _comment_video_photo = value;
                                });
                                await _manage_account_controller.PostUserSetting(
                                    privacy: "true", title: 'commnent_video_photo');
                              },
                            ))),
                  ),
                  Flexible(
                    child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                        title:
                            Text('Everyone', style: TextStyle(fontSize: 14, color: Colors.white, fontFamily: 'PR  ')),
                        leading: Theme(
                            data: ThemeData(
                              unselectedWidgetColor: Colors.white,
                            ),
                            child: Radio<Comment_video_photo>(
                              activeColor: HexColor(CommonColor.pinkFont),
                              value: Comment_video_photo.everyone,
                              groupValue: _comment_video_photo,
                              onChanged: (Comment_video_photo? value) async {
                                setState(() {
                                  _comment_video_photo = value;
                                });
                                await _manage_account_controller.PostUserSetting(
                                    privacy: "false", title: 'commnent_video_photo');
                              },
                            ))),
                  ),
                ],
              ),

              /// ------------------------Who can view your photos and videos
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                color: HexColor(CommonColor.pinkFont).withOpacity(0.5),
                height: 0.5,
                width: MediaQuery.of(context).size.width,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Text(
                  'Who can view your photos and videos',
                  style: TextStyle(fontSize: 16, color: HexColor(CommonColor.pinkFont), fontFamily: 'PB'),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Flexible(
                    child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                        title:
                            Text('Following', style: TextStyle(fontSize: 14, color: Colors.white, fontFamily: 'PR  ')),
                        leading: Theme(
                            data: ThemeData(unselectedWidgetColor: Colors.white),
                            child: Radio<View_video_photo>(
                              activeColor: HexColor(CommonColor.pinkFont),
                              value: View_video_photo.contactonly,
                              groupValue: _view_video_photo,
                              onChanged: (View_video_photo? value) async {
                                setState(() {
                                  _view_video_photo = value;
                                });
                                await _manage_account_controller.PostUserSetting(
                                    privacy: "true", title: 'view_photo_video');
                              },
                            ))),
                  ),
                  Flexible(
                    child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                        title:
                            Text('Everyone', style: TextStyle(fontSize: 14, color: Colors.white, fontFamily: 'PR  ')),
                        leading: Theme(
                            data: ThemeData(
                              unselectedWidgetColor: Colors.white,
                            ),
                            child: Radio<View_video_photo>(
                              activeColor: HexColor(CommonColor.pinkFont),
                              value: View_video_photo.everyone,
                              groupValue: _view_video_photo,
                              onChanged: (View_video_photo? value) async {
                                setState(() {
                                  _view_video_photo = value;
                                });
                                await _manage_account_controller.PostUserSetting(
                                    privacy: "false", title: 'view_photo_video');
                              },
                            ))),
                  ),
                ],
              ),

              /// ------------------------Who can view your story
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                color: HexColor(CommonColor.pinkFont).withOpacity(0.5),
                height: 0.5,
                width: MediaQuery.of(context).size.width,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Text(
                  'Who can view your story',
                  style: TextStyle(fontSize: 16, color: HexColor(CommonColor.pinkFont), fontFamily: 'PB'),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Flexible(
                    child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                        title:
                            Text('Following', style: TextStyle(fontSize: 14, color: Colors.white, fontFamily: 'PR  ')),
                        leading: Theme(
                            data: ThemeData(unselectedWidgetColor: Colors.white),
                            child: Radio<View_story>(
                              activeColor: HexColor(CommonColor.pinkFont),
                              value: View_story.contactonly,
                              groupValue: _view_story,
                              onChanged: (View_story? value) async {
                                setState(() {
                                  _view_story = value;
                                });
                                await _manage_account_controller.PostUserSetting(privacy: "true", title: 'view_story');
                              },
                            ))),
                  ),
                  Flexible(
                    child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                        title:
                            Text('Everyone', style: TextStyle(fontSize: 14, color: Colors.white, fontFamily: 'PR  ')),
                        leading: Theme(
                            data: ThemeData(
                              unselectedWidgetColor: Colors.white,
                            ),
                            child: Radio<View_story>(
                              activeColor: HexColor(CommonColor.pinkFont),
                              value: View_story.everyone,
                              groupValue: _view_story,
                              onChanged: (View_story? value) async {
                                setState(() {
                                  _view_story = value;
                                });
                                await _manage_account_controller.PostUserSetting(privacy: "false", title: 'view_story');
                              },
                            ))),
                  ),
                ],
              ),

              /// ------------------------Who can do a group chat
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                color: HexColor(CommonColor.pinkFont).withOpacity(0.5),
                height: 0.5,
                width: MediaQuery.of(context).size.width,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Text(
                  'Who can do a group chat',
                  style: TextStyle(fontSize: 16, color: HexColor(CommonColor.pinkFont), fontFamily: 'PB'),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Flexible(
                    child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                        title:
                            Text('Following', style: TextStyle(fontSize: 14, color: Colors.white, fontFamily: 'PR  ')),
                        leading: Theme(
                            data: ThemeData(unselectedWidgetColor: Colors.white),
                            child: Radio<Group_chat>(
                              activeColor: HexColor(CommonColor.pinkFont),
                              value: Group_chat.contactonly,
                              groupValue: _group_chat,
                              onChanged: (Group_chat? value) async {
                                setState(() {
                                  _group_chat = value;
                                });
                                await _manage_account_controller.PostUserSetting(privacy: "true", title: 'group_chat');
                              },
                            ))),
                  ),
                  Flexible(
                    child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                        title:
                            Text('Everyone', style: TextStyle(fontSize: 14, color: Colors.white, fontFamily: 'PR  ')),
                        leading: Theme(
                            data: ThemeData(
                              unselectedWidgetColor: Colors.white,
                            ),
                            child: Radio<Group_chat>(
                              activeColor: HexColor(CommonColor.pinkFont),
                              value: Group_chat.everyone,
                              groupValue: _group_chat,
                              onChanged: (Group_chat? value) async {
                                setState(() {
                                  _group_chat = value;
                                });
                                await _manage_account_controller.PostUserSetting(privacy: "false", title: 'group_chat');
                              },
                            ))),
                  ),
                ],
              ),

              /// ------------------------Who can view live
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                color: HexColor(CommonColor.pinkFont).withOpacity(0.5),
                height: 0.5,
                width: MediaQuery.of(context).size.width,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Text(
                  'Who can view live',
                  style: TextStyle(fontSize: 16, color: HexColor(CommonColor.pinkFont), fontFamily: 'PB'),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Flexible(
                    child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                        title:
                            Text('Following', style: TextStyle(fontSize: 14, color: Colors.white, fontFamily: 'PR  ')),
                        leading: Theme(
                            data: ThemeData(unselectedWidgetColor: Colors.white),
                            child: Radio<View_live>(
                              activeColor: HexColor(CommonColor.pinkFont),
                              value: View_live.contactonly,
                              groupValue: _view_live,
                              onChanged: (View_live? value) async {
                                setState(() {
                                  _view_live = value;
                                });
                                await _manage_account_controller.PostUserSetting(privacy: "true", title: 'view_live');
                              },
                            ))),
                  ),
                  Flexible(
                    child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                        title:
                            Text('Everyone', style: TextStyle(fontSize: 14, color: Colors.white, fontFamily: 'PR  ')),
                        leading: Theme(
                            data: ThemeData(
                              unselectedWidgetColor: Colors.white,
                            ),
                            child: Radio<View_live>(
                              activeColor: HexColor(CommonColor.pinkFont),
                              value: View_live.everyone,
                              groupValue: _view_live,
                              onChanged: (View_live? value) async {
                                setState(() {
                                  _view_live = value;
                                });
                                await _manage_account_controller.PostUserSetting(privacy: "false", title: 'view_live');
                              },
                            ))),
                  ),
                ],
              ),

              /// ------------------------Who can request to join
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                color: HexColor(CommonColor.pinkFont).withOpacity(0.5),
                height: 0.5,
                width: MediaQuery.of(context).size.width,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Text(
                  'Who can Comment on live',
                  style: TextStyle(fontSize: 16, color: HexColor(CommonColor.pinkFont), fontFamily: 'PB'),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Flexible(
                    child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                        title:
                            Text('Following', style: TextStyle(fontSize: 14, color: Colors.white, fontFamily: 'PR  ')),
                        leading: Theme(
                            data: ThemeData(unselectedWidgetColor: Colors.white),
                            child: Radio<Comment_live>(
                              activeColor: HexColor(CommonColor.pinkFont),
                              value: Comment_live.contactonly,
                              groupValue: _comment_live,
                              onChanged: (Comment_live? value) async {
                                setState(() {
                                  _comment_live = value;
                                });
                                await _manage_account_controller.PostUserSetting(
                                    privacy: "true", title: 'comment_on_live');
                              },
                            ))),
                  ),
                  Flexible(
                    child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                        title:
                            Text('Everyone', style: TextStyle(fontSize: 14, color: Colors.white, fontFamily: 'PR  ')),
                        leading: Theme(
                            data: ThemeData(
                              unselectedWidgetColor: Colors.white,
                            ),
                            child: Radio<Comment_live>(
                              activeColor: HexColor(CommonColor.pinkFont),
                              value: Comment_live.everyone,
                              groupValue: _comment_live,
                              onChanged: (Comment_live? value) async {
                                setState(() {
                                  _comment_live = value;
                                });
                                await _manage_account_controller.PostUserSetting(
                                    privacy: "false", title: 'comment_on_live');
                              },
                            ))),
                  ),
                ],
              ),

              /// ------------------------Who can request to join
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                color: HexColor(CommonColor.pinkFont).withOpacity(0.5),
                height: 0.5,
                width: MediaQuery.of(context).size.width,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Text(
                  'Who can request to join',
                  style: TextStyle(fontSize: 16, color: HexColor(CommonColor.pinkFont), fontFamily: 'PB'),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Flexible(
                    child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                        title:
                            Text('Following', style: TextStyle(fontSize: 14, color: Colors.white, fontFamily: 'PR  ')),
                        leading: Theme(
                            data: ThemeData(unselectedWidgetColor: Colors.white),
                            child: Radio<Request_join>(
                              activeColor: HexColor(CommonColor.pinkFont),
                              value: Request_join.contactonly,
                              groupValue: _request_join,
                              onChanged: (Request_join? value) async {
                                setState(() {
                                  _request_join = value;
                                });
                                await _manage_account_controller.PostUserSetting(privacy: "true", title: 'join_live');
                              },
                            ))),
                  ),
                  Flexible(
                    child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
                        title: const Text('Everyone',
                            style: TextStyle(fontSize: 14, color: Colors.white, fontFamily: 'PR  ')),
                        leading: Theme(
                            data: ThemeData(
                              unselectedWidgetColor: Colors.white,
                            ),
                            child: Radio<Request_join>(
                              activeColor: HexColor(CommonColor.pinkFont),
                              value: Request_join.everyone,
                              groupValue: _request_join,
                              onChanged: (Request_join? value) async {
                                setState(() {
                                  _request_join = value;
                                });
                                await _manage_account_controller.PostUserSetting(privacy: "false", title: 'join_live');
                              },
                            ))),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  selectTowerBottomSheet(BuildContext context) {
    final screenheight = MediaQuery.of(context).size.height;
    final screenwidth = MediaQuery.of(context).size.width;
    showModalBottomSheet(
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
          child: StatefulBuilder(
            builder: (context, state) {
              return Container(
                height: screenheight * 0.5,
                width: screenwidth,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    // stops: [0.1, 0.5, 0.7, 0.9],
                    colors: [
                      HexColor("#C12265"),
                      HexColor("#000000"),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 23.9),
                  child: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.all(23),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Icon(
                              Icons.check,
                              size: 40,
                            ),
                          ),
                        ),
                        Text(
                          "Your data is being compiled and will be sent to your email once it is ready for download." +
                              "\n\nAll data collected by Funky will be compiled and send to your email to be downloaded within 7 days.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, fontFamily: 'PR', color: Colors.white),
                        ),
                        Align(
                          alignment: FractionalOffset.bottomCenter,
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 40, horizontal: 60),
                            child: common_button(
                              onTap: () {
                                // Get.to(Security_Login());
                                Navigator.pop(context);
                                // selectTowerBottomSheet(context);
                                // _kids_loginScreenController.ParentEmailVerification(context);
                              },
                              backgroud_color: Colors.white,
                              lable_text: 'OK',
                              lable_text_color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  GetUserSettingModel? getUserSettingModel;

  Future<dynamic> getUserSettings() async {
    String id_user = await PreferenceManager().getPref(URLConstants.id);

    String url = ("${URLConstants.base_url}${URLConstants.get_user_setting}?userId=$id_user");

    http.Response response = await http.get(Uri.parse(url));

    print('Response request: ${response.request}');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = convert.jsonDecode(response.body);
      getUserSettingModel = GetUserSettingModel.fromJson(data);
      // getVideoModelList(searchlistModel);
      if (getUserSettingModel!.error == false) {
        debugPrint('2-2-2-2-2-2 Inside the product Controller Details ${getUserSettingModel!.user!}');

        setState(() {
          (getUserSettingModel!.user!.changeAccount == "true"
              ? _os = Change_account.public
              : _os = Change_account.private);

          (getUserSettingModel!.user!.suggestedAccount == "true"
              ? _os2 = Suggest_account.contactonly
              : _os2 = Suggest_account.everyone);

          (getUserSettingModel!.user!.adsPersonalization == "true" ? ad_pers = true : ad_pers = false);

          (getUserSettingModel!.user!.downloadData == "true" ? download_req = true : download_req = false);

          (getUserSettingModel!.user!.likedVideo == "0"
              ? _os3 = Liked_video.onlyme
              : (getUserSettingModel!.user!.likedVideo == "1"
                  ? _os3 = Liked_video.friends
                  : (getUserSettingModel!.user!.likedVideo == "2"
                      ? _os3 = Liked_video.everyone
                      : _os3 = Liked_video.everyone)));

          (getUserSettingModel!.user!.socialMediaLinks == "0"
              ? _os4 = Social_media.onlyme
              : (getUserSettingModel!.user!.socialMediaLinks == "1"
                  ? _os4 = Social_media.friends
                  : (getUserSettingModel!.user!.socialMediaLinks == "2"
                      ? _os4 = Social_media.everyone
                      : _os4 = Social_media.everyone)));

          (getUserSettingModel!.user!.commentVideoPhoto == "true"
              ? _comment_video_photo = Comment_video_photo.contactonly
              : _comment_video_photo = Comment_video_photo.everyone);

          (getUserSettingModel!.user!.viewPhotoVideo == "true"
              ? _view_video_photo = View_video_photo.contactonly
              : _view_video_photo = View_video_photo.everyone);

          (getUserSettingModel!.user!.viewStory == "true"
              ? _view_story = View_story.contactonly
              : _view_story = View_story.everyone);

          (getUserSettingModel!.user!.groupChat == "true"
              ? _group_chat = Group_chat.contactonly
              : _group_chat = Group_chat.everyone);

          (getUserSettingModel!.user!.viewLive == "true"
              ? _view_live = View_live.contactonly
              : _view_live = View_live.everyone);

          (getUserSettingModel!.user!.commentOnLive == "true"
              ? _comment_live = Comment_live.contactonly
              : _comment_live = Comment_live.everyone);

          (getUserSettingModel!.user!.joinLive == "true"
              ? _request_join = Request_join.contactonly
              : _request_join = Request_join.everyone);
        });

        // CommonWidget().showToaster(msg: data["success"].toString());
        return getUserSettingModel;
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
