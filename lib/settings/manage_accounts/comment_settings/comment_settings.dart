import 'dart:convert' as convert;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

import '../../../Utils/App_utils.dart';
import '../../../Utils/asset_utils.dart';
import '../../../Utils/colorUtils.dart';
import '../../../sharePreference.dart';
import '../controller/manage_account_controller.dart';
import '../model/GetCommentSettingModel.dart';
import '../model/PostCommentSettingModel.dart';
import 'comment_blockunbloack_screen.dart';

class CommentSettins extends StatefulWidget {
  const CommentSettins({Key? key}) : super(key: key);

  @override
  State<CommentSettins> createState() => _CommentSettinsState();
}

class _CommentSettinsState extends State<CommentSettins> {
  bool isSwitched = false;
  final Manage_account_controller _manage_account_controller =
      Get.put(Manage_account_controller(), tag: Manage_account_controller().toString());

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    await GetCommentSettings();
    // await _manage_account_controller.getList(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Comments',
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
                  'Change Account',
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
                    Text(
                      'Block comment',
                      style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'PR'),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(CommentBlockUnblockScreen());
                      },
                      child: Row(
                        children: [
                          Container(
                            child: Image.asset(
                              AssetUtils.block_icon,
                              height: 25,
                              width: 25,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          (isloading
                              ? Container(
                                  color: Colors.transparent,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          // color: Colors.pink,
                                          backgroundColor: HexColor(CommonColor.pinkFont),
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            Colors.white70, //<-- SEE HERE
                                          ),
                                        ),
                                      ),
                                      // Text('Loading...',style: TextStyle(color: Colors.white,fontSize: 18,fontFamily: 'PR'),)
                                    ],
                                  ),
                                )
                              : Text(
                                  '${getCommentSettingModel!.data!.blockCommentCount} people',
                                  style: TextStyle(fontSize: 16, color: HexColor('#878787'), fontFamily: 'PR'),
                                )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 60),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 200,
                      child: Text('Request to Download their Data, collected by Funky',
                          maxLines: 2, style: TextStyle(fontSize: 14, color: Colors.white, fontFamily: 'PR  ')),
                    ),
                    Container(
                        child: Transform.scale(
                      scale: 0.7,
                      child: Theme(
                        data: ThemeData(
                          unselectedWidgetColor: HexColor(CommonColor.pinkFont),
                        ),
                        child: CupertinoSwitch(
                          value: isSwitched,
                          onChanged: (value) async {
                            setState(() {
                              isSwitched = value;
                              print(isSwitched);
                            });
                            await PostCommentSetting(
                              privacy: isSwitched.toString(),
                            );
                          },
                          thumbColor: Colors.black,
                          activeColor: HexColor(CommonColor.pinkFont),
                          trackColor: HexColor(CommonColor.pinkFont_light),
                          // activeColor: HexColor(CommonColor.pinkFont),
                          // inactiveTrackColor: Colors.red[100],
                          // inactiveThumbColor: HexColor(CommonColor.pinkFont),
                        ),
                      ),
                    ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PostCommentSettingModel? postCommentSettingModel;

  Future<dynamic> PostCommentSetting({required String privacy}) async {
    String id_user = await PreferenceManager().getPref(URLConstants.id);

    String url = ("${URLConstants.base_url}${URLConstants.post_comment_setting}");
    // "?privacySetting=$privacy&title=$title&userId=$id_user"

    Map data = {
      'block_comment': privacy,
      'user_id': id_user,
      // 'id': '105',
      // 'userId': '105',
    };
    print(data);
    // String body = json.encode(data);

    var response = await http.post(
      Uri.parse(url),
      body: data,
    );
    print('Response request: ${response.request}');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = convert.jsonDecode(response.body);
      postCommentSettingModel = PostCommentSettingModel.fromJson(data);
      // getVideoModelList(searchlistModel);
      if (postCommentSettingModel!.error == false) {
        debugPrint('2-2-2-2-2-2 Inside the product Controller Details ${postCommentSettingModel!.message}');
        // CommonWidget().showToaster(msg: data["success"].toString());
        return postCommentSettingModel;
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

  GetCommentSettingModel? getCommentSettingModel;
  bool isloading = true;

  Future<dynamic> GetCommentSettings() async {
    String id_user = await PreferenceManager().getPref(URLConstants.id);

    String url = ("${URLConstants.base_url}${URLConstants.get_comment_setting}?user_id=$id_user");

    http.Response response = await http.get(Uri.parse(url));

    print('Response request: ${response.request}');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = convert.jsonDecode(response.body);
      getCommentSettingModel = GetCommentSettingModel.fromJson(data);
      // getVideoModelList(searchlistModel);
      if (getCommentSettingModel!.error == false) {
        debugPrint('2-2-2-2-2-2 Inside the product Controller Details ${getCommentSettingModel!.data!}');
        setState(() {
          isloading = false;
        });
        setState(() {
          (getCommentSettingModel!.data!.blockComment == "true" ? isSwitched = true : isSwitched = false);
        });

        // CommonWidget().showToaster(msg: data["success"].toString());
        return getCommentSettingModel;
      } else {
        setState(() {
          isloading = false;
        });
        // CommonWidget().showToaster(msg: msg.toString());
        return null;
      }
    } else if (response.statusCode == 422) {
      setState(() {
        isloading = false;
      });
      // CommonWidget().showToaster(msg: msg.toString());
    } else if (response.statusCode == 401) {
      setState(() {
        isloading = false;
      });
      // CommonService().unAuthorizedUser();
    } else {
      // CommonWidget().showToaster(msg: msg.toString());
    }
  }
}
