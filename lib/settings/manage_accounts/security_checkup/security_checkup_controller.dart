import 'dart:convert' as convert;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../Utils/App_utils.dart';
import '../../../Utils/toaster_widget.dart';
import '../../../sharePreference.dart';
import 'model/EmailPhoneVerifyModel.dart';
import 'model/EmailPhoneupdateModel.dart';

class Security_checkup_screen_controller extends GetxController {
  String pageIndex_email = '01';

  pageIndexUpdateEmail(String? value) {
    pageIndex_email = value!;
    update();
  }

  String pageIndex_mobile = '01';

  pageIndexUpdatephone(String? value) {
    pageIndex_mobile = value!;
    update();
  }

  TextEditingController email_controller = new TextEditingController();
  TextEditingController mobile_controller = new TextEditingController();

  UpdateEmailPhoneModel? updateEmailPhoneModel;

  Future<dynamic> UpdateEmailPhone(
      {required BuildContext context, required String email_phone, required String type}) async {
    String id_user = await PreferenceManager().getPref(URLConstants.id);
    String url = ("${URLConstants.base_url}${URLConstants.update_email_phpne}");
    // "?privacySetting=$privacy&title=$title&userId=$id_user"
    Map data = {
      'user_id': id_user,
      'email_phone': email_phone,
      'type': type,
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
      updateEmailPhoneModel = UpdateEmailPhoneModel.fromJson(data);
      // getVideoModelList(searchlistModel);
      if (updateEmailPhoneModel!.error == false) {
        debugPrint('2-2-2-2-2-2 Inside the product Controller Details ${updateEmailPhoneModel!.message}');
        return updateEmailPhoneModel;
      } else {
        CommonWidget().showErrorToaster(msg: updateEmailPhoneModel!.message!.toString());
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

  VerifyEmailPhoneModel? verifyEmailPhoneModel;

  Future<dynamic> VerifyEmailPhone(
      {required BuildContext context, required String email_phone, required String otp, required String type}) async {
    String id_user = await PreferenceManager().getPref(URLConstants.id);
    String url = ("${URLConstants.base_url}${URLConstants.verify_email_phpne}");
    // "?privacySetting=$privacy&title=$title&userId=$id_user"
    Map data = {
      'user_id': id_user,
      'email_phone': email_phone,
      'otp': otp,
      'type': type,
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
      verifyEmailPhoneModel = VerifyEmailPhoneModel.fromJson(data);
      // getVideoModelList(searchlistModel);
      if (verifyEmailPhoneModel!.error == false) {
        debugPrint('2-2-2-2-2-2 Inside the product Controller Details ${verifyEmailPhoneModel!.message}');
        return verifyEmailPhoneModel;
      } else {
        CommonWidget().showErrorToaster(msg: verifyEmailPhoneModel!.message!.toString());
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
