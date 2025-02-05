import 'dart:convert' as convert;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

import '../../../../Utils/colorUtils.dart';
import '../../../Utils/App_utils.dart';
import '../../../sharePreference.dart';
import '../controller/manage_account_controller.dart';
import '../model/getPostSettingModel.dart';

class Live_settings extends StatefulWidget {
  const Live_settings({Key? key}) : super(key: key);

  @override
  State<Live_settings> createState() => _Live_settingsState();
}

class _Live_settingsState extends State<Live_settings> {
  bool save_live = false;

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
          'Live',
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
                  'Saving',
                  style: TextStyle(fontSize: 16, color: HexColor(CommonColor.pinkFont), fontFamily: 'PR'),
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 200,
                      child: Text('Save live to draft',
                          maxLines: 2, style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'PR')),
                    ),
                    Transform.scale(
                      scale: 0.7,
                      child: Theme(
                        data: ThemeData(
                          unselectedWidgetColor: HexColor(CommonColor.pinkFont),
                        ),
                        child: CupertinoSwitch(
                          value: save_live,
                          onChanged: (value) async {
                            setState(() {
                              save_live = value;
                              print(save_live);
                            });
                            await _manage_account_controller.PostPostSetting(
                                privacy: save_live.toString(), title: 'save_live_to_draft');
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
                margin: EdgeInsets.symmetric(vertical: 40),
                color: HexColor(CommonColor.pinkFont).withOpacity(0.5),
                height: 0.5,
                width: MediaQuery.of(context).size.width,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 33),
                child: Text(
                  "Automatically save your video to your draft, Only you can see them after your live ends.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: HexColor(CommonColor.grey_light), fontFamily: 'PR'),
                ),
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
          (getPostSettingModel!.postSetting![0].saveLiveToDraft == 'true' ? save_live = true : save_live = false);
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
