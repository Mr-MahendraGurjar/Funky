import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../Utils/App_utils.dart';
import '../../custom_widget/page_loader.dart';
import '../../dashboard/dashboard_screen.dart';
import '../../sharePreference.dart';
import '../model/GetReportModel.dart';

class Report_problem_Controller extends GetxController {
  RxBool isGetReportLoading = true.obs;
  GetReportProblem? getReportProblem;

  Future<dynamic> get_report_list({
    required BuildContext context,
    required String user_id,
    required String type,
  }) async {
    isGetReportLoading(true);
    // showLoader(context);

    String idUser = await PreferenceManager().getPref(URLConstants.id);
    // String body = json.encode(data);

    var url =
        ('${URLConstants.base_url}${URLConstants.report_get}?user_id=$user_id&type=$type');
    // var url = ('${URLConstants.base_url}tagList.php?user_id=10000020');

    http.Response response = await http.get(Uri.parse(url));

    print(response.body);
    print(response.request);
    print(response.statusCode);
    // var final_data = jsonDecode(response.body);
    // print('final data $final_data');
    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = convert.jsonDecode(response.body);
      getReportProblem = GetReportProblem.fromJson(data);
      if (getReportProblem!.error == false) {
        debugPrint(
            '2-2-2-2-2-2 Inside the product Controller Details ${getReportProblem!.data!.length}');
        isGetReportLoading(false);
        return getReportProblem;
      } else {
        isGetReportLoading(false);
        // CommonWidget().showToaster(msg: msg.toString());
        return null;
      }
    } else if (response.statusCode == 422) {
      isGetReportLoading(false);
      // CommonWidget().showToaster(msg: msg.toString());
    } else if (response.statusCode == 401) {
      isGetReportLoading(false);
      // CommonService().unAuthorizedUser();
    } else {
      // CommonWidget().showToaster(msg: msg.toString());
    }
  }

  Map<String, String>? data;
  String? hireID;

  TextEditingController title_controller = TextEditingController();
  TextEditingController description_controller = TextEditingController();
  List<File> selected_files = [];

  Future<dynamic> uploadReport(
      {required BuildContext context,
      required String receiver_id,
      required String type,
      required String type_id}) async {
    try {
      showLoader(context);
      String idUser = await PreferenceManager().getPref(URLConstants.id);
      var url = (URLConstants.base_url + URLConstants.report_post);
      var request = http.MultipartRequest('POST', Uri.parse(url));

      for (var i = 0; i < selected_files.length; i++) {
        var fileFormat = selected_files[i]
            .path
            .substring(selected_files[i].path.lastIndexOf('.'));
        print(fileFormat);
        print("widget.ImageFile![i].path ${selected_files[i].path}");
        // if(file_format == '.png' || file_format ==  '.jpg'){
        print("inside image path");
        var files = await http.MultipartFile.fromPath(
            'image[]', selected_files[i].path);
        request.files.add(files);
      }
      // request.files.add(files);
      // request.fields['uploadVideo'] = '';
      request.fields['user_id'] = idUser;
      request.fields['receiver_user_id'] = receiver_id;
      request.fields['type_id'] = type_id;
      request.fields['type'] = type;
      request.fields['title'] = title_controller.text;
      request.fields['description'] = description_controller.text;
      // request.fields['isVideo'] = '';

      //userId,tagLine,description,address,postImage,uploadVideo,isVideo
      // request.files.add(await http.MultipartFile.fromPath(
      //     "image", widget.ImageFile!.path));

      var response = await request.send();
      var responsed = await http.Response.fromStream(response);
      debugPrint('Report Response ${responsed.body}');

      final responseData = json.decode(responsed.body);
      debugPrint("response.statusCode");
      debugPrint(response.statusCode.toString());
      debugPrint(response.statusCode.toString());

      if (response.statusCode == 200) {
        debugPrint("SUCCESS");
        debugPrint(response.reasonPhrase);
        // print(widget.ImageFile!.path);
        clear();
        if (kDebugMode) {
          print(responseData);
        }
        hideLoader(context);
        await Get.to(Dashboard(
          page: 0,
        ));
      } else {
        print("ERROR");
      }
    } catch (e) {
      hideLoader(context);
    }
  }

  clear() {
    title_controller.clear();
    description_controller.clear();
    selected_files.clear();
  }
}
