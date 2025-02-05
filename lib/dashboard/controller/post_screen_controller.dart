import 'dart:convert' as convert;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../Utils/App_utils.dart';
import '../../sharePreference.dart';
import '../model/getdraftModel.dart';
import '../model/postDetailModel.dart';

class DashboardScreenController extends GetxController {
  RxString file_selected_image = '_'.obs;
  RxString file_selected_video = '_'.obs;
  RxString selected_item = '_'.obs;

  Uint8List? image;

  String pageIndex = '01';

  pageIndexUpdate(String? value) {
    pageIndex = value!;
    update();
  }

  RxBool isPostDetailLoading = true.obs;
  PostDetailModel? postDetailModel;

  Future<dynamic> get_post_details({
    required BuildContext context,
    required String post_id,
  }) async {
    isPostDetailLoading(true);
    // showLoader(context);

    String idUser = await PreferenceManager().getPref(URLConstants.id);
    // String body = json.encode(data);

    var url = ('${URLConstants.base_url}${URLConstants.getPostDetail}?user_id=$idUser&post_id=$post_id');
    // var url = ('${URLConstants.base_url}tagList.php?user_id=10000020');

    http.Response response = await http.get(Uri.parse(url));

    print(response.body);
    print(response.request);
    print(response.statusCode);
    // var final_data = jsonDecode(response.body);
    // print('final data $final_data');
    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = convert.jsonDecode(response.body);
      postDetailModel = PostDetailModel.fromJson(data);
      if (postDetailModel!.error == false) {
        debugPrint('2-2-2-2-2-2 Inside the product Controller Details ${postDetailModel!.message}');
        isPostDetailLoading(false);
        return postDetailModel;
      } else {
        isPostDetailLoading(false);
        // CommonWidget().showToaster(msg: msg.toString());
        return null;
      }
    } else if (response.statusCode == 422) {
      isPostDetailLoading(false);
      // CommonWidget().showToaster(msg: msg.toString());
    } else if (response.statusCode == 401) {
      isPostDetailLoading(false);
      // CommonService().unAuthorizedUser();
    } else {
      // CommonWidget().showToaster(msg: msg.toString());
    }
  }

  RxBool isDraftlistLoading = true.obs;
  GetDraftListModel? getDraftListModel;

  Future<dynamic> Get_draftList_Api({
    required BuildContext context,
  }) async {
    isDraftlistLoading(true);
    // showLoader(context);

    String idUser = await PreferenceManager().getPref(URLConstants.id);
    // String body = json.encode(data);

    var url = ('${URLConstants.base_url}${URLConstants.Draft_list}?user_id=$idUser');
    // var url = ('${URLConstants.base_url}tagList.php?user_id=10000020');

    http.Response response = await http.get(Uri.parse(url));

    print(response.body);
    print(response.request);
    print(response.statusCode);
    // var final_data = jsonDecode(response.body);
    // print('final data $final_data');
    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = convert.jsonDecode(response.body);
      getDraftListModel = GetDraftListModel.fromJson(data);
      if (getDraftListModel!.error == false) {
        debugPrint('2-2-2-2-2-2 Inside the product Controller Details ${getDraftListModel!.message}');
        isDraftlistLoading(false);
        return getDraftListModel;
      } else {
        isDraftlistLoading(false);
        // CommonWidget().showToaster(msg: msg.toString());
        return null;
      }
    } else if (response.statusCode == 422) {
      isDraftlistLoading(false);
      // CommonWidget().showToaster(msg: msg.toString());
    } else if (response.statusCode == 401) {
      isDraftlistLoading(false);
      // CommonService().unAuthorizedUser();
    } else {
      // CommonWidget().showToaster(msg: msg.toString());
    }
  }
}
