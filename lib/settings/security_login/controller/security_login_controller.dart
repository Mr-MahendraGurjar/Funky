import 'dart:convert' as convert;

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../Utils/App_utils.dart';
import '../../../Utils/toaster_widget.dart';
import '../../../sharePreference.dart';
import '../model/ChangepasswordModel.dart';

class Security_login_controller extends GetxController {
  TextEditingController current_password_controller = new TextEditingController();
  TextEditingController new_password_controller = new TextEditingController();
  TextEditingController confirm_password_controller = new TextEditingController();

  ChangePasswordModel? changePasswordModel;

  Future<dynamic> ChangePasswordAPI(BuildContext context) async {
    String id_user = await PreferenceManager().getPref(URLConstants.id);

    String url = ("${URLConstants.base_url}${URLConstants.change_password}");
    // "?privacySetting=$privacy&title=$title&userId=$id_user"

    Map data = {
      'user_id': id_user,
      'current_pass': current_password_controller.text,
      'new_pass': new_password_controller.text,
      'confirm_pass': confirm_password_controller.text,
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
      changePasswordModel = ChangePasswordModel.fromJson(data);
      // getVideoModelList(searchlistModel);
      if (changePasswordModel!.error == false) {
        debugPrint('2-2-2-2-2-2 Inside the product Controller Details ${changePasswordModel!.message}');
        return changePasswordModel;
      } else {
        CommonWidget().showErrorToaster(msg: changePasswordModel!.message!.toString());
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
