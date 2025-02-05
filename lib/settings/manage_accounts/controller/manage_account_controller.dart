import 'dart:convert' as convert;

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../Utils/App_utils.dart';
import '../../../search_screen/model/searchModel.dart';
import '../../../sharePreference.dart';
import '../model/CommentUserblockunblock.dart';
import '../model/PostSettingModel.dart';
import '../model/PrivacySettingModel.dart';
import '../model/getBlockListModel.dart';

class Manage_account_controller extends GetxController {
  RxBool isHashSearchLoading = false.obs;
  PrivacySettingModel? privacySettingModel;

  TextEditingController blocksearchquery = TextEditingController();
  RxBool taxfeildTapped = false.obs;

  Future<dynamic> PostUserSetting(
      {required String privacy, required String title}) async {
    isHashSearchLoading(true);
    String idUser = await PreferenceManager().getPref(URLConstants.id);
    String userType = await PreferenceManager().getPref(URLConstants.type);

    String url = ("${URLConstants.base_url}${URLConstants.post_user_setting}");
    // "?privacySetting=$privacy&title=$title&userId=$id_user"

    Map data = {
      'privacySetting': privacy,
      'title': title,
      'userId': idUser,
      'type': userType
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
      privacySettingModel = PrivacySettingModel.fromJson(data);
      // getVideoModelList(searchlistModel);
      if (privacySettingModel!.error == false) {
        debugPrint(
            '2-2-2-2-2-2 Inside the product Controller Details ${privacySettingModel!.message}');
        isHashSearchLoading(false);
        // CommonWidget().showToaster(msg: data["success"].toString());
        return privacySettingModel;
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

  PostSettingModel? postSettingModel;

  Future<dynamic> PostPostSetting(
      {required String privacy, required String title}) async {
    String idUser = await PreferenceManager().getPref(URLConstants.id);

    String url = ("${URLConstants.base_url}${URLConstants.post_post_setting}");
    // "?privacySetting=$privacy&title=$title&userId=$id_user"

    Map data = {
      'user_id': idUser,
      'post_setting': privacy,
      'title': title,
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
        debugPrint(
            '2-2-2-2-2-2 Inside the product Controller Details ${postSettingModel!.message}');
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

  SearchApiModel? searchlistModel;
  RxBool isSearchLoading = false.obs;

  RxBool isgetLoading = false.obs;

  Future<dynamic> getUserListBlock({required String search}) async {
    isSearchLoading(true);

    // debugPrint('Get Sales Token ${tokens.toString()}');
    // try {
    // } catch (e) {
    //   print('1-1-1-1 Get Purchase ${e.toString()}');
    // }
    String idUser = await PreferenceManager().getPref(URLConstants.id);
    String url =
        ("${URLConstants.base_url}${URLConstants.searchBlockListApi}?search=$search&user_id=$idUser");
    // debugPrint('Get Sales Token ${tokens.toString()}');
    // try {
    // } catch (e) {
    //   print('1-1-1-1 Get Purchase ${e.toString()}');
    // }

    // String body = json.encode(data);

    http.Response response = await http.get(Uri.parse(url));

    print('Response request: ${response.request}');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = convert.jsonDecode(response.body);
      searchlistModel = SearchApiModel.fromJson(data);
      if (searchlistModel!.error == false) {
        debugPrint(
            '2-2-2-2-2-2 Inside the product Controller Details ${searchlistModel!.data!.length}');
        isSearchLoading(false);
        // CommonWidget().showToaster(msg: data["success"].toString());
        return searchlistModel;
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

  GetBlockListModel? getBlockListModel;

  Future<dynamic> getList({required BuildContext context}) async {
    isgetLoading(true);

    // debugPrint('Get Sales Token ${tokens.toString()}');
    // try {
    // } catch (e) {
    //   print('1-1-1-1 Get Purchase ${e.toString()}');
    // }
    String idUser = await PreferenceManager().getPref(URLConstants.id);
    String url =
        ("${URLConstants.base_url}${URLConstants.getUselistApi}?user_id=$idUser");
    // debugPrint('Get Sales Token ${tokens.toString()}');
    // try {
    // } catch (e) {
    //   print('1-1-1-1 Get Purchase ${e.toString()}');
    // }

    // String body = json.encode(data);

    http.Response response = await http.get(Uri.parse(url));

    print('Response request: ${response.request}');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = convert.jsonDecode(response.body);
      getBlockListModel = GetBlockListModel.fromJson(data);
      if (getBlockListModel!.error == false) {
        debugPrint(
            '2-2-2-2-2-2 Inside the product Controller Details ${getBlockListModel!.data!.length}');
        isgetLoading(false);
        // CommonWidget().showToaster(msg: data["success"].toString());
        return getBlockListModel;
      } else {
        isgetLoading(false);
        // CommonWidget().showToaster(msg: msg.toString());
        return null;
      }
    } else if (response.statusCode == 422) {
      isgetLoading(false);

      // CommonWidget().showToaster(msg: msg.toString());
    } else if (response.statusCode == 401) {
      isgetLoading(false);

      // CommonService().unAuthorizedUser();
    } else {
      // CommonWidget().showToaster(msg: msg.toString());
    }
  }

  CommentUserBlockUnblock? commentUserBlockUnblock;

  Future<dynamic> commentBlockUnblock(
      {required BuildContext context,
      required String block_id,
      required String action,
      required String block_unblock}) async {
    String url = (URLConstants.base_url + URLConstants.commentuserblock);

    // debugPrint('Get Sales Token ${tokens.toString()}');
    // try {
    // } catch (e) {
    //   print('1-1-1-1 Get Purchase ${e.toString()}');
    // }
    String idUser = await PreferenceManager().getPref(URLConstants.id);

    Map data = {
      'user_id': idUser,
      'blocked_user_id': block_id,
      'action_type': action,
      'user_comment_blockUnblock': block_unblock
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
      commentUserBlockUnblock = CommentUserBlockUnblock.fromJson(data);
      if (commentUserBlockUnblock!.error == false) {
        debugPrint(
            '2-2-2-2-2-2 Inside the product Controller Details ${commentUserBlockUnblock!.message}');
        isSearchLoading(false);
        // CommonWidget().showToaster(msg: data["success"].toString());
        return commentUserBlockUnblock;
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
