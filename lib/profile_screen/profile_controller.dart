import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../Utils/App_utils.dart';
import '../Utils/toaster_widget.dart';
import '../homepage/model/getpurchaseMusicModel.dart';
import '../sharePreference.dart';
import 'model/galleryModel.dart';
import 'model/getStoryModel.dart';
import 'model/getbannerListModel.dart';
import 'model/getbrandlogoModel.dart';
import 'model/musicModelList.dart';
import 'model/postdeleteModel.dart';
import 'model/taggedListModel.dart';
import 'model/videoModelList.dart';

class Profile_screen_controller extends GetxController {
  RxBool isvideoLoading = true.obs;
  RxBool isthumbLoading = true.obs;
  VideoModelList? videoModelList;
  String? filePath;
  List<File> imgFile_list = [];

  Future<dynamic> get_video_list({
    required BuildContext context,
    required String user_id,
    required String login_user_id,
  }) async {
    isvideoLoading(true);
    // showLoader(context);

    // String idUser = await PreferenceManager().getPref(URLConstants.id);

    debugPrint('0-0-0-0-0-0-0 username');
    Map data = {
      'userId': user_id,
      'isVideo': 'true',
      'login_user_id': login_user_id
    };
    print("videoModelList request data: $data");
    // String body = json.encode(data);

    var url = ('${URLConstants.base_url}post-videoList.php');
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
      videoModelList = VideoModelList.fromJson(data);
      print('videoModelList  $videoModelList');
      if (videoModelList!.error == false) {
        CommonWidget().showToaster(msg: 'Succesful');
        // print(_videoModelList);

        print("_videoModelList!.data!.length");
        print(videoModelList!.data!.length);
        isvideoLoading(false);
        isthumbLoading(true);
        // for (int i = 0; i < videoModelList!.data!.length; i++) {
        //   final uint8list = await VideoThumbnail.thumbnailFile(
        //     video:
        //         ("http://foxyserver.com/funky/video/${videoModelList!.data![i].uploadVideo}"),
        //     thumbnailPath: (await getTemporaryDirectory()).path,
        //     imageFormat: ImageFormat.PNG,
        //     // maxHeight: 64,
        //     // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
        //     quality: 10,
        //   );
        //   print(uint8list);
        //
        //   imgFile_list.add(File(uint8list!));
        //   // print(test_thumb[i].path);
        //
        //   // hideLoader(context);
        //   // print("test----------${imgFile_list[i].path}");
        // }
        isthumbLoading(true);

        // print("thumbaaaa ;; $imgFile_list");
      } else {
        isvideoLoading(false);
        // hideLoader(context);

        print('Please try again');
      }
    } else {
      print('Please try again');
    }
  }

  RxBool ispostLoading = true.obs;
  GalleryModelList? galleryModelList;

  Future<dynamic> get_gallery_list({
    required BuildContext context,
    required String user_id,
    required String login_user_id,
  }) async {
    ispostLoading(true);
    // showLoader(context);

    // String idUser = await PreferenceManager().getPref(URLConstants.id);

    debugPrint('0-0-0-0-0-0-0 username');
    Map data = {
      'userId': user_id,
      'isVideo': 'false',
      'login_user_id': login_user_id
    };
    print(data);
    // String body = json.encode(data);

    var url = ('${URLConstants.base_url}galleryList.php');
    print("url : $url");
    print("body : $data");
    var response = await http.post(
      Uri.parse(url),
      body: data,
    );
    log('response.body =>${response.body}');
    print(response.request);
    print(response.statusCode);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      galleryModelList = GalleryModelList.fromJson(data);

      if (galleryModelList!.error == false) {
        CommonWidget().showToaster(msg: 'Successful');
        ispostLoading(false);
      } else {
        ispostLoading(false);
        print('Please try again');
      }
    } else {
      print('Please try again');
    }
  }

  RxBool isStoryLoading = true.obs;
  GetStoryModel? getStoryModel;
  List<Storys> story_info = [];
  List<Data_story> story_ = [];

  List<File> test_thumb = [];

  Future<dynamic> get_story_list({
    required BuildContext context,
    required String user_id,
    required String login_user_id,
  }) async {
    print('Inside Story get email');
    isStoryLoading(true);
    String idUser = await PreferenceManager().getPref(URLConstants.id);
    print("UserID $idUser");
    String url =
        ("${URLConstants.base_url}${URLConstants.StoryGetApi}?userId=$user_id&login_user_id=$login_user_id");
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
      // print('story response ${response.body}');
      var data = convert.jsonDecode(response.body);
      getStoryModel = GetStoryModel.fromJson(data);
      // getUSerModelList(userInfoModel_email);
      print("FFF ${getStoryModel!.data!.length}");
      if (getStoryModel!.error == false) {
        debugPrint(
            '2-2-2-2-2-2 Inside the Get UserInfo Controller Details ${getStoryModel!.data!}');
        story_ = getStoryModel!.data!;
        story_info = getStoryModel!.data![0].storys!;
        for (var story in story_) {
          print("story=> ${story.stID}");
        }
        // test = File(uint8list!);

        for (int i = 0; i < getStoryModel!.data!.length; i++) {
          // if (getStoryModel!.data![i].storys![0].isVideo == 'true') {
          // final uint8list = await VideoThumbnail.thumbnailFile(
          //   video:
          //   ("${URLConstants.base_data_url}images/${getStoryModel!.data![i].storys![0].storyPhoto}"),
          //   thumbnailPath: (await getTemporaryDirectory()).path,
          //   imageFormat: ImageFormat.PNG,
          //   maxHeight: 64,
          //   // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
          //   quality: 20,
          // );
          // test_thumb.add(File(uint8list!));
          // print(test_thumb[i].path);
          // } else if (getStoryModel!.data![i].storys![0].isVideo == 'false') {
          // test_thumb
          //     .add(File(getStoryModel!.data![i].storys![0].storyPhoto!));
          // print(story_info[i].image);
          // }

          // print("test----------${test_thumb[i].path}");
        }
        isStoryLoading(false);
        // CommonWidget().showToaster(msg: data["success"].toString());
        // await Get.to(Dashboard());

        return getStoryModel;
      } else {
        isStoryLoading(false);

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

  Future<dynamic> get_single_story({
    required BuildContext context,
    required String user_id,
    required String login_user_id,
    required String story_id,
  }) async {
    print('Inside Story get email');
    isStoryLoading(true);
    String idUser = await PreferenceManager().getPref(URLConstants.id);
    print("UserID $idUser");
    String url =
        ("${URLConstants.base_url}${URLConstants.SingleStoryGetApi}?userId=$user_id&login_user_id=$login_user_id&story_id=$story_id");
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
      getStoryModel = GetStoryModel.fromJson(data);
      // getUSerModelList(userInfoModel_email);
      print("FFF ${getStoryModel!.data!.length}");
      if (getStoryModel!.error == false) {
        debugPrint(
            '2-2-2-2-2-2 Inside the Get UserInfo Controller Details ${getStoryModel!.data!.length}');
        story_ = getStoryModel!.data!;
        story_info = getStoryModel!.data![0].storys!;

        // test = File(uint8list!);

        for (int i = 0; i < getStoryModel!.data!.length; i++) {
          // if (getStoryModel!.data![i].storys![0].isVideo == 'true') {
          // final uint8list = await VideoThumbnail.thumbnailFile(
          //   video:
          //   ("${URLConstants.base_data_url}images/${getStoryModel!.data![i].storys![0].storyPhoto}"),
          //   thumbnailPath: (await getTemporaryDirectory()).path,
          //   imageFormat: ImageFormat.PNG,
          //   maxHeight: 64,
          //   // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
          //   quality: 20,
          // );
          // test_thumb.add(File(uint8list!));
          // print(test_thumb[i].path);
          // } else if (getStoryModel!.data![i].storys![0].isVideo == 'false') {
          // test_thumb
          //     .add(File(getStoryModel!.data![i].storys![0].storyPhoto!));
          // print(story_info[i].image);
          // }

          // print("test----------${test_thumb[i].path}");
        }
        isStoryLoading(false);
        // CommonWidget().showToaster(msg: data["success"].toString());
        // await Get.to(Dashboard());

        return getStoryModel;
      } else {
        isStoryLoading(false);

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

  RxBool isTaggedLoading = true.obs;
  TaggedListModel? taggedListModel;

  Future<dynamic> get_tagged_list({
    required BuildContext context,
    required String user_id,
  }) async {
    isTaggedLoading(true);
    // showLoader(context);

    // String idUser = await PreferenceManager().getPref(URLConstants.id);
    // String body = json.encode(data);

    var url = ('${URLConstants.base_url}tagList.php?user_id=$user_id');
    // var url = ('${URLConstants.base_url}tagList.php?user_id=10000020');

    http.Response response = await http.get(Uri.parse(url));

    print(response.body);
    print(response.request);
    print(response.statusCode);
    // var final_data = jsonDecode(response.body);
    // print('final data $final_data');
    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = convert.jsonDecode(response.body);
      taggedListModel = TaggedListModel.fromJson(data);
      if (taggedListModel!.error == false) {
        debugPrint(
            '2-2-2-2-2-2 Inside the product Controller Details ${taggedListModel!.tagList!.length}');
        isTaggedLoading(false);
        return taggedListModel;
      } else {
        isTaggedLoading(false);
        // CommonWidget().showToaster(msg: msg.toString());
        return null;
      }
    } else if (response.statusCode == 422) {
      isTaggedLoading(false);
      // CommonWidget().showToaster(msg: msg.toString());
    } else if (response.statusCode == 401) {
      isTaggedLoading(false);
      // CommonService().unAuthorizedUser();
    } else {
      // CommonWidget().showToaster(msg: msg.toString());
    }
  }

  GetMusicList? musicList;
  RxBool isMusicLoading = true.obs;

  Future<dynamic> get_posted_music({
    required BuildContext context,
    required String user_id,
  }) async {
    print('Inside creator get email');
    isMusicLoading(true);
    String idUser = await PreferenceManager().getPref(URLConstants.id);

    String url =
        ("${URLConstants.base_url}${URLConstants.MusicGetApi}?user_id=$user_id&login_user_id=$idUser");
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
      musicList = GetMusicList.fromJson(data);
      // getUSerModelList(userInfoModel_email);
      if (musicList!.error == false) {
        debugPrint(
            '2-2-2-2-2-2 Inside the Get UserInfo Controller Details ${musicList!.data!.length}');
        // story_info = getStoryModel!.data!;
        // CommonWidget().showToaster(msg: data["success"].toString());
        // await Get.to(Dashboard());
        isMusicLoading(false);
        return musicList;
      } else {
        isMusicLoading(false);
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

  GetPurchaseMusicList? getPurchaseMusicList;
  RxBool ispurchaseMusicLoading = true.obs;

  Future<dynamic> get_purchase_music({
    required BuildContext context,
    required String user_id,
  }) async {
    print('Inside creator get email');
    ispurchaseMusicLoading(true);
    String idUser = await PreferenceManager().getPref(URLConstants.id);

    String url =
        ("${URLConstants.base_url}${URLConstants.MusicGetPurchaseApi}?user_id=$user_id&login_user_id=$idUser");
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
      getPurchaseMusicList = GetPurchaseMusicList.fromJson(data);
      // getUSerModelList(userInfoModel_email);
      if (getPurchaseMusicList!.error == false) {
        debugPrint(
            '2-2-2-2-2-2 Inside the Get UserInfo Controller Details ${getPurchaseMusicList!.data!.length}');
        // story_info = getStoryModel!.data!;
        // CommonWidget().showToaster(msg: data["success"].toString());
        // await Get.to(Dashboard());
        ispurchaseMusicLoading(false);
        return getPurchaseMusicList;
      } else {
        ispurchaseMusicLoading(false);
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

  RxBool isBrandLogoLoading = true.obs;
  BrandLogoList? brandLogoList;

  Future<dynamic> get_brand_logo({
    required BuildContext context,
    required String user_id,
  }) async {
    isBrandLogoLoading(true);
    // showLoader(context);

    String idUser = await PreferenceManager().getPref(URLConstants.id);
    // String body = json.encode(data);

    var url =
        ('${URLConstants.base_url}${URLConstants.BrandLogoGetApi}?user_id=$user_id');
    // var url = ('${URLConstants.base_url}tagList.php?user_id=10000020');

    http.Response response = await http.get(Uri.parse(url));

    print(response.body);
    print(response.request);
    print(response.statusCode);
    // var final_data = jsonDecode(response.body);
    // print('final data $final_data');
    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = convert.jsonDecode(response.body);
      brandLogoList = BrandLogoList.fromJson(data);
      if (brandLogoList!.error == false) {
        debugPrint(
            '2-2-2-2-2-2 Inside the product Controller Details ${brandLogoList!.data!.length}');
        isBrandLogoLoading(false);
        return brandLogoList;
      } else {
        isBrandLogoLoading(false);
        // CommonWidget().showToaster(msg: msg.toString());
        return null;
      }
    } else if (response.statusCode == 422) {
      isBrandLogoLoading(false);
      // CommonWidget().showToaster(msg: msg.toString());
    } else if (response.statusCode == 401) {
      isBrandLogoLoading(false);
      // CommonService().unAuthorizedUser();
    } else {
      // CommonWidget().showToaster(msg: msg.toString());
    }
  }

  RxBool isBannerLoading = true.obs;
  BannerGetList? bannerGetList;

  Future<dynamic> get_banner_list({
    required BuildContext context,
    required String user_id,
  }) async {
    isBannerLoading(true);
    // showLoader(context);

    String idUser = await PreferenceManager().getPref(URLConstants.id);
    // String body = json.encode(data);

    var url =
        ('${URLConstants.base_url}${URLConstants.BannerGetApi}?user_id=$user_id');
    // var url = ('${URLConstants.base_url}tagList.php?user_id=10000020');

    http.Response response = await http.get(Uri.parse(url));

    print(response.body);
    print(response.request);
    print(response.statusCode);
    // var final_data = jsonDecode(response.body);
    // print('final data $final_data');
    if (response.statusCode == 200 || response.statusCode == 201) {
      print('get banner List ${response.body}');

      var data = convert.jsonDecode(response.body);
      bannerGetList = BannerGetList.fromJson(data);
      if (bannerGetList!.error == false) {
        debugPrint(
            '2-2-2-2-2-2 Inside the product Controller Details ${bannerGetList!.data!.length}');
        isBannerLoading(false);
        return bannerGetList;
      } else {
        isBannerLoading(false);
        // CommonWidget().showToaster(msg: msg.toString());
        return null;
      }
    } else if (response.statusCode == 422) {
      isBannerLoading(false);
      // CommonWidget().showToaster(msg: msg.toString());
    } else if (response.statusCode == 401) {
      isBannerLoading(false);
      // CommonService().unAuthorizedUser();
    } else {
      // CommonWidget().showToaster(msg: msg.toString());
    }
  }

  RxBool isPostdeleteLoading = false.obs;
  PostDeleteModel? postDeleteModel;

  Future<dynamic> PostDeleteApi({
    required BuildContext context,
    required String post_id,
  }) async {
    debugPrint('0-0-0-0-0-0-0 PostLikeUnlike');

    isPostdeleteLoading(true);

    Map data = {
      'id': post_id,
    };
    print(data);
    // String body = json.encode(data);

    var url = (URLConstants.base_url + URLConstants.PostDeleteApi);
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
      // isLikeLoading(false);
      var data = jsonDecode(response.body);
      postDeleteModel = PostDeleteModel.fromJson(data);
      print(postDeleteModel);
      if (postDeleteModel!.error == false) {
        isPostdeleteLoading(false);
        CommonWidget().showToaster(msg: postDeleteModel!.message!);

        Navigator.pop(context);

        // await getAllNewsFeedList();
      } else {
        isPostdeleteLoading(false);
        print('Please try again');
        CommonWidget().showErrorToaster(msg: 'Enter valid Otp');
      }
    } else {
      isPostdeleteLoading(false);
      print('Please try again');
    }
  }
}
