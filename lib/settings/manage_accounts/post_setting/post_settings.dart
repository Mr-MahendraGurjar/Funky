import 'dart:convert' as convert;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:funky_new/settings/manage_accounts/post_setting/mention_privacy.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

import '../../../../Utils/colorUtils.dart';
import '../../../Utils/App_utils.dart';
import '../../../sharePreference.dart';
import '../controller/manage_account_controller.dart';
import '../model/getPostSettingModel.dart';
import 'guide_control_privacy.dart';

class PostSettings extends StatefulWidget {
  const PostSettings({Key? key}) : super(key: key);

  @override
  State<PostSettings> createState() => _PostSettingsState();
}

enum OS { Everyone, Peopleyoufollow, Noone }

class _PostSettingsState extends State<PostSettings> {
  OS? _os = OS.Everyone;
  bool approve_tag = false;
  bool like_view = false;
  bool hide_like = false;
  bool hide_comm_count = false;

  final Manage_account_controller _manage_account_controller =
      Get.put(Manage_account_controller(), tag: Manage_account_controller().toString());

  @override
  void initState() {
    getPostSettings();
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
          'Post Settings',
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
                height: 20,
              ),
              Container(
                margin: EdgeInsets.only(bottom: 31),
                child: Text(
                  'Allow tags from',
                  style: TextStyle(fontSize: 16, color: HexColor(CommonColor.pinkFont), fontFamily: 'PB'),
                ),
              ),
              Column(
                children: [
                  ListTile(
                      contentPadding: EdgeInsets.zero,
                      visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                      title: Text('Everyone', style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'PR')),
                      leading: Theme(
                        data: ThemeData(unselectedWidgetColor: Colors.white),
                        child: Radio<OS>(
                          activeColor: HexColor(CommonColor.pinkFont),
                          value: OS.Everyone,
                          groupValue: _os,
                          onChanged: (OS? value) async {
                            setState(() {
                              _os = value;
                            });
                            await _manage_account_controller.PostPostSetting(privacy: "0", title: 'allow_tags_from');
                          },
                        ),
                      )),
                  ListTile(
                      contentPadding: EdgeInsets.zero,
                      visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                      title: Text('People you follow',
                          style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'PR')),
                      leading: Theme(
                          data: ThemeData(unselectedWidgetColor: Colors.white),
                          child: Radio<OS>(
                            activeColor: HexColor(CommonColor.pinkFont),
                            value: OS.Peopleyoufollow,
                            groupValue: _os,
                            onChanged: (OS? value) async {
                              setState(() {
                                _os = value;
                              });
                              await _manage_account_controller.PostPostSetting(privacy: "1", title: 'allow_tags_from');
                            },
                          ))),
                  ListTile(
                      contentPadding: EdgeInsets.zero,
                      visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                      title: Text('No one', style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'PR')),
                      leading: Theme(
                          data: ThemeData(unselectedWidgetColor: Colors.white),
                          child: Radio<OS>(
                            activeColor: HexColor(CommonColor.pinkFont),
                            value: OS.Noone,
                            groupValue: _os,
                            onChanged: (OS? value) async {
                              setState(() {
                                _os = value;
                              });
                              await _manage_account_controller.PostPostSetting(privacy: "2", title: 'allow_tags_from');
                            },
                          ))),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 31),
                child: Text(
                  'Tagged posts',
                  style: TextStyle(fontSize: 16, color: HexColor(CommonColor.pinkFont), fontFamily: 'PB'),
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text('Manually approve tags',
                          style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'PR')),
                    ),
                    Transform.scale(
                      scale: 0.7,
                      child: Theme(
                        data: ThemeData(
                          unselectedWidgetColor: HexColor(CommonColor.pinkFont),
                        ),
                        child: CupertinoSwitch(
                          value: approve_tag,
                          onChanged: (value) async {
                            setState(() {
                              approve_tag = value;
                              print(approve_tag);
                            });
                            await _manage_account_controller.PostPostSetting(
                                privacy: approve_tag.toString(), title: 'manually_approve_tag');
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
                margin: EdgeInsets.symmetric(vertical: 10),
                color: HexColor(CommonColor.pinkFont).withOpacity(0.5),
                height: 0.5,
                width: MediaQuery.of(context).size.width,
              ),
              // Container(
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Container(
              //         width: 200,
              //         child: Text('Likes and views',
              //             maxLines: 2,
              //             style: TextStyle(
              //                 fontSize: 16,
              //                 color: Colors.white,
              //                 fontFamily: 'PR')),
              //       ),
              //       Transform.scale(
              //         scale: 0.7,
              //         child: Theme(
              //           data: ThemeData(
              //             unselectedWidgetColor:
              //             HexColor(CommonColor.pinkFont),
              //           ),
              //           child: CupertinoSwitch(
              //             value: like_view,
              //             onChanged: (value) async {
              //               setState(() {
              //                 like_view = value;
              //                 print(like_view);
              //               });
              //               await _manage_account_controller.PostPostSetting(
              //                   privacy: like_view.toString(),
              //                   title: 'like_view');
              //             },
              //             thumbColor: Colors.black,
              //             activeColor: HexColor(CommonColor.pinkFont),
              //             trackColor: HexColor(CommonColor.pinkFont_light),
              //             // activeColor: HexColor(CommonColor.pinkFont),
              //             // inactiveTrackColor: Colors.red[100],
              //             // inactiveThumbColor: HexColor(CommonColor.pinkFont),
              //           ),
              //         ),
              //       )
              //     ],
              //   ),
              // ),
              // Container(
              //   margin: EdgeInsets.symmetric(vertical: 10),
              //   color: HexColor(CommonColor.pinkFont).withOpacity(0.5),
              //   height: 0.5,
              //   width: MediaQuery.of(context).size.width,
              // ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 200,
                      child: Text('Hide like counts',
                          maxLines: 2, style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'PR')),
                    ),
                    Transform.scale(
                      scale: 0.7,
                      child: Theme(
                        data: ThemeData(
                          unselectedWidgetColor: HexColor(CommonColor.pinkFont),
                        ),
                        child: CupertinoSwitch(
                          value: hide_like,
                          onChanged: (value) async {
                            setState(() {
                              hide_like = value;
                              print(hide_like);
                            });
                            await _manage_account_controller.PostPostSetting(
                                privacy: hide_like.toString(), title: 'hide_like_count');
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
                margin: EdgeInsets.symmetric(vertical: 10),
                color: HexColor(CommonColor.pinkFont).withOpacity(0.5),
                height: 0.5,
                width: MediaQuery.of(context).size.width,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 200,
                      child: Text('Hide comment counts',
                          maxLines: 2, style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'PR')),
                    ),
                    Transform.scale(
                      scale: 0.7,
                      child: Theme(
                        data: ThemeData(
                          unselectedWidgetColor: HexColor(CommonColor.pinkFont),
                        ),
                        child: CupertinoSwitch(
                          value: hide_comm_count,
                          onChanged: (value) async {
                            setState(() {
                              hide_comm_count = value;
                              print(hide_comm_count);
                            });
                            await _manage_account_controller.PostPostSetting(
                                privacy: hide_comm_count.toString(), title: 'hide_comment_count');
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
                height: 31,
              ),
              // Container(
              //   child: Text('Tagged post',
              //       style: TextStyle(
              //           fontSize: 16,
              //           color: HexColor(CommonColor.pinkFont),
              //           fontFamily: 'PR')),
              // ),
              // SizedBox(
              //   height: 31,
              // ),
              GestureDetector(
                onTap: () {
                  Get.to(Mention_privacy());
                },
                child: Text('Mentions',
                    style: TextStyle(fontSize: 16, color: HexColor(CommonColor.pinkFont), fontFamily: 'PB')),
              ),
              SizedBox(
                height: 31,
              ),
              GestureDetector(
                onTap: () {
                  Get.to(GuideControlPrivacy());
                },
                child: Text('Guide controls',
                    style: TextStyle(fontSize: 16, color: HexColor(CommonColor.pinkFont), fontFamily: 'PB')),
              ),
              // SizedBox(
              //   height: 31,
              // ),
              // GestureDetector(
              //   onTap: () {
              //     Get.to(Live_settings());
              //   },
              //   child: Text('Live',
              //       style: TextStyle(
              //           fontSize: 16,
              //           color: HexColor(CommonColor.pinkFont),
              //           fontFamily: 'PB')),
              // ),
              SizedBox(
                height: 51,
              ),
            ],
          ),
        ),
      ),
    );
  }

  GetPostSettingModel? getPostSettingModel;

  Future<dynamic> getPostSettings() async {
    String id_user = await PreferenceManager().getPref(URLConstants.id);

    String url = "${URLConstants.base_url}${URLConstants.get_post_setting}?user_id=$id_user";

    http.Response response = await http.get(Uri.parse(url));

    print('Response request: ${response.request}');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = convert.jsonDecode(response.body);
      getPostSettingModel = GetPostSettingModel.fromJson(data);
      // getVideoModelList(searchlistModel);
      if (getPostSettingModel!.error == "false") {
        debugPrint('2-2-2-2-2-2 Inside the product Controller Details ${getPostSettingModel!.postSetting!.length}');

        setState(() {
          (getPostSettingModel!.postSetting![0].allowTagsFrom == '0'
              ? _os = OS.Everyone
              : (getPostSettingModel!.postSetting![0].allowTagsFrom == '1'
                  ? _os = OS.Peopleyoufollow
                  : (getPostSettingModel!.postSetting![0].allowTagsFrom == '2' ? _os = OS.Noone : _os = OS.Noone)));

          (getPostSettingModel!.postSetting![0].manuallyApproveTag == 'true'
              ? approve_tag = true
              : approve_tag = false);
          (getPostSettingModel!.postSetting![0].likeView == 'true' ? like_view = true : like_view = false);
          (getPostSettingModel!.postSetting![0].hideLikeCount == 'true' ? hide_like = true : hide_like = false);
          (getPostSettingModel!.postSetting![0].hideCommentCount == 'true'
              ? hide_comm_count = true
              : hide_comm_count = false);
        });

        // CommonWidget().showToaster(msg: data["success"].toString());
        return getPostSettingModel;
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
