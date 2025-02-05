import 'dart:convert' as convert;
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../Utils/App_utils.dart';
import '../Utils/toaster_widget.dart';
import '../sharePreference.dart';
import 'model/GetRewardModel.dart';
import 'model/blockModelList.dart';

class Settings_screen_controller extends GetxController {
  RxBool isSearchLoading = false.obs;
  BlockListModel? blockListModel;
  var getBlockModelList = BlockListModel().obs;

  Future<dynamic> getBlockList() async {
    String idUser = await PreferenceManager().getPref(URLConstants.id);

    isSearchLoading(true);
    String url =
        ("${URLConstants.base_url}${URLConstants.blockListApi}?id=$idUser");
    String msg = '';

    // debugPrint('Get Sales Token ${tokens.toString()}');
    // try {
    // } catch (e) {
    //   print('1-1-1-1 Get Purchase ${e.toString()}');
    // }

    http.Response response = await http.get(Uri.parse(url));

    print('Response request: ${response.request}');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = convert.jsonDecode(response.body);
      blockListModel = BlockListModel.fromJson(data);
      getBlockModelList(blockListModel);
      if (blockListModel!.error == false) {
        debugPrint(
            '2-2-2-2-2-2 Inside the product Controller Details ${blockListModel!.data!.length}');
        isSearchLoading(false);
        CommonWidget().showToaster(msg: blockListModel!.message!);
        return blockListModel;
      } else {
        isSearchLoading(false);

        // CommonWidget().showToaster(msg: msg.toString());
        return null;
      }
    } else if (response.statusCode == 422) {
      isSearchLoading(false);

      // CommonWidget().showToaster(msg: msg.toString());
    } else if (response.statusCode == 401) {
      isSearchLoading(false);

      // CommonService().unAuthorizedUser();
    } else {
      // CommonWidget().showToaster(msg: msg.toString());
    }
  }

  RxBool block_unblockLoading = false.obs;

  Future<dynamic> Block_unblock_api({
    required BuildContext context,
    required String user_id,
    required String user_name,
    required String social_bloc_type,
    required String block_unblock,
  }) async {
    debugPrint('0-0-0-0-0-0-0 username');
    block_unblockLoading(true);
    String idUser = await PreferenceManager().getPref(URLConstants.id);
    String typeUser = await PreferenceManager().getPref(URLConstants.type);

    Map data = {
      'userId': user_id,
      'blocID': idUser,
      'type': typeUser,
      'social_type': social_bloc_type,
      'user_blockUnblock': block_unblock,
      'userName': user_name,
    };
    print(data);
    // String body = json.encode(data);

    var url = ("http://foxyserver.com/funky/api/blockUser.php");
    print("url : $url");
    print("body : $data");

    var response = await http.post(
      Uri.parse(url),
      body: data,
    );
    print(response.body);
    print(response.request);
    print(response.statusCode);
    // var final_data = jsonDecode(response.body);

    // print('final data $final_data');

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      // print("loginModel!.user![0].id! ${_followUnfolloemodel!.user![0].id!}");
      if (data["error"] == false) {
        block_unblockLoading(false);
        getBlockList();
        // await PreferenceManager()
        //     .setPref(URLConstants.id, _followUnfolloemodel!.user![0].id!);
        // CommonService().setStoreKey(
        //     setKey: 'type', setValue: loginModel!.user![0].type!.toString());
        print(CommonService().getStoreValue(keys: 'type').toString());
        // Get.to(kids_Email_verification());
      } else {
        print('Please try again');
      }
    } else {
      print('Please try again');
    }
  }

  GetRewardModel? getRewardModel;
  RxBool isRewardLoading = true.obs;
  double? coin_left;

  Future<dynamic> getRewardList({required String userId}) async {
    isRewardLoading(true);
    String url =
        ("${URLConstants.base_url}${URLConstants.get_reward}?user_id=$userId");
    String msg = '';

    http.Response response = await http.get(Uri.parse(url));

    print('Response request: ${response.request}');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = convert.jsonDecode(response.body);
      getRewardModel = GetRewardModel.fromJson(data);
      // getBlockModelList(blockListModel);
      if (getRewardModel!.error == false) {
        debugPrint(
            '2-2-2-2-2-2 Inside the product Controller Details ${getRewardModel!.rewardList!.length}');
        coin_left = double.parse(getRewardModel!.totalReward!);
        isRewardLoading(false);
        // CommonWidget().showToaster(msg: getRewardModel!.message!);
        return getRewardModel;
      } else {
        isRewardLoading(false);

        // CommonWidget().showToaster(msg: msg.toString());
        return null;
      }
    } else if (response.statusCode == 422) {
      isRewardLoading(false);

      // CommonWidget().showToaster(msg: msg.toString());
    } else if (response.statusCode == 401) {
      isRewardLoading(false);

      // CommonService().unAuthorizedUser();
    } else {
      // CommonWidget().showToaster(msg: msg.toString());
    }
  }
}
