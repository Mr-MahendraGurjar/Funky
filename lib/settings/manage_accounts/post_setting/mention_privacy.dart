import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

import '../../../../Utils/colorUtils.dart';
import '../../../Utils/App_utils.dart';
import '../../../sharePreference.dart';
import '../controller/manage_account_controller.dart';
import '../model/getPostSettingModel.dart';

class Mention_privacy extends StatefulWidget {
  const Mention_privacy({Key? key}) : super(key: key);

  @override
  State<Mention_privacy> createState() => _Mention_privacyState();
}

enum OS { Everyone, Peopleyoufollow, Noone }

class _Mention_privacyState extends State<Mention_privacy> {
  OS? _os = OS.Everyone;

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
          'Mentions',
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
              Container(
                margin: EdgeInsets.symmetric(vertical: 31),
                child: Text(
                  'Allow @ mention from',
                  style: TextStyle(fontSize: 16, color: HexColor(CommonColor.pinkFont), fontFamily: 'PR'),
                ),
              ),
              Column(
                children: [
                  ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 17),
                      visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                      title: Text('Everyone', style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'PR')),
                      trailing: Theme(
                        data: ThemeData(unselectedWidgetColor: Colors.white),
                        child: Radio<OS>(
                          activeColor: HexColor(CommonColor.pinkFont),
                          value: OS.Everyone,
                          groupValue: _os,
                          onChanged: (OS? value) async {
                            setState(() {
                              _os = value;
                            });
                            await _manage_account_controller.PostPostSetting(privacy: "0", title: 'mention');
                          },
                        ),
                      )),
                  ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 17),
                      visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                      title: Text('People you follow',
                          style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'PR')),
                      trailing: Theme(
                          data: ThemeData(unselectedWidgetColor: Colors.white),
                          child: Radio<OS>(
                            activeColor: HexColor(CommonColor.pinkFont),
                            value: OS.Peopleyoufollow,
                            groupValue: _os,
                            onChanged: (OS? value) async {
                              setState(() {
                                _os = value;
                              });
                              await _manage_account_controller.PostPostSetting(privacy: "1", title: 'mention');
                            },
                          ))),
                  ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 17),
                      visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                      title: Text('No one', style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'PR')),
                      trailing: Theme(
                          data: ThemeData(unselectedWidgetColor: Colors.white),
                          child: Radio<OS>(
                            activeColor: HexColor(CommonColor.pinkFont),
                            value: OS.Noone,
                            groupValue: _os,
                            onChanged: (OS? value) async {
                              setState(() {
                                _os = value;
                              });
                              await _manage_account_controller.PostPostSetting(privacy: "2", title: 'mention');
                            },
                          ))),
                ],
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
                  "When users try to @mention you, they'll see if you don't allow @mention.",
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
          (getPostSettingModel!.postSetting![0].mention == '0'
              ? _os = OS.Everyone
              : (getPostSettingModel!.postSetting![0].allowTagsFrom == '1'
                  ? _os = OS.Peopleyoufollow
                  : (getPostSettingModel!.postSetting![0].allowTagsFrom == '2' ? _os = OS.Noone : _os = OS.Noone)));
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
