import 'dart:convert' as convert;

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../Utils/App_utils.dart';
import '../../../sharePreference.dart';
import '../model/PostSettingModel.dart';

class Security_checkup_controller extends GetxController {
  PostSettingModel? postSettingModel;
  RxBool isHashSearchLoading = false.obs;

  Future<dynamic> PostSecuritySetting({required String privacy, required String title}) async {
    isHashSearchLoading(true);
    String id_user = await PreferenceManager().getPref(URLConstants.id);

    String url = ("${URLConstants.base_url}${URLConstants.authentication_post}");
    // "?privacySetting=$privacy&title=$title&userId=$id_user"

    Map data = {
      'status': privacy,
      'title': title,
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
      postSettingModel = PostSettingModel.fromJson(data);
      // getVideoModelList(searchlistModel);
      if (postSettingModel!.error == false) {
        debugPrint('2-2-2-2-2-2 Inside the product Controller Details ${postSettingModel!.message}');
        isHashSearchLoading(false);
        // CommonWidget().showToaster(msg: data["success"].toString());
        return postSettingModel;
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
