// ignore_for_file: await_only_futures

import 'dart:convert' as convert;
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

import '../../Utils/App_utils.dart';
import '../../Utils/toaster_widget.dart';
import '../../sharePreference.dart';
import '../model/GetPostLikeCount.dart';
import '../model/ImageList_model.dart';
import '../model/PostViewCountModel.dart';
import '../model/Post_comment_like_model.dart';
import '../model/Postcomment_mdoel.dart';
import '../model/VideoList_model.dart';
import '../model/getAllMusicModel.dart';
import '../model/getLikedPostModel.dart';
import '../model/getcommentTagmodel.dart';
import '../model/guestvideoModel.dart';
import '../model/postShareReward.dart';
import '../model/post_comment_reply_like_unlike_model.dart';
import '../model/post_image_comment_post_model.dart';
import '../model/post_like_unlike_model.dart';
import '../model/post_reply_comment_post_model.dart';
import '../model/termsServiceModel.dart';

class HomepageController extends GetxController {
  bool isPasswordVisible = false;

  isPasswordVisibleUpdate(bool value) {
    isPasswordVisible = value;
    update();
  }

  VideoPlayerController? controller_last;

  RxBool isVideoLoading = false.obs;
  VideoListModel? videoListModel;
  var getVideoModelList = VideoListModel().obs;

  Future<dynamic> getAllVideosList() async {
    isVideoLoading(true);
    String idUser = await PreferenceManager().getPref(URLConstants.id);
    String url =
        ('${URLConstants.base_url}${URLConstants.VideoListApi}?isVideo=true&userId=$idUser');
    String msg = '';

    // 'http://foxyserver.com/funky/api/videoList.php?login_user_id=52'

    // debugPrint('Get Sales Token ${tokens.toString()}');
    // try {
    // } catch (e) {
    //   print('1-1-1-1 Get Purchase ${e.toString()}');
    // }

    http.Response response = await http.get(Uri.parse(url));

    print('Response request: ${response.request}');
    print('Response status: ${response.statusCode}');
    print('Response body => ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = convert.jsonDecode(response.body);
      videoListModel = VideoListModel.fromJson(data);
      getVideoModelList(videoListModel);
      if (videoListModel!.error == false) {
        debugPrint(
            '2-2-2-2-2-2 Inside the product Controller Details ${videoListModel!.data!.length}');
        isVideoLoading(false);
        // CommonWidget().showToaster(msg: data["success"].toString());
        return videoListModel;
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

  RxBool isimageLoading = false.obs;
  ImageListModel? imageListModel;
  var getimageModelList = ImageListModel().obs;

  Future<dynamic> getAllImagesList() async {
    isimageLoading(true);
    String idUser = await PreferenceManager().getPref(URLConstants.id);

    String url =
        ("${URLConstants.base_url}${URLConstants.ImagewListApi}?isVideo=false&userId=$idUser");
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
      imageListModel = ImageListModel.fromJson(data);
      getimageModelList(imageListModel);
      if (imageListModel!.error == false) {
        debugPrint(
            '2-2-2-2-2-2 Inside the product Controller Details ${imageListModel!.data!.length}');
        isimageLoading(false);
        // CommonWidget().showToaster(msg: data["success"].toString());
        return imageListModel;
      } else {
        isimageLoading(false);
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

  RxBool isLikedPostLoading = false.obs;
  GetLikedPostModel? likedPostModel;

  Future<dynamic> getAllLikedPostList() async {
    isLikedPostLoading(true);
    String idUser = await PreferenceManager().getPref(URLConstants.id);

    String url =
        ("${URLConstants.base_url}${URLConstants.LikedPostListApi}?user_id=$idUser");
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
      likedPostModel = GetLikedPostModel.fromJson(data);
      if (likedPostModel!.error == false) {
        debugPrint(
            '2-2-2-2-2-2 Inside the product Controller Details ${likedPostModel!.data!.length}');
        isLikedPostLoading(false);
        // CommonWidget().showToaster(msg: data["success"].toString());
        return likedPostModel;
      } else {
        isLikedPostLoading(false);
        // CommonWidget().showToaster(msg: msg.toString());
        return null;
      }
    } else if (response.statusCode == 422) {
      isLikedPostLoading(false);
      // CommonWidget().showToaster(msg: msg.toString());
    } else if (response.statusCode == 401) {
      isLikedPostLoading(false);
      // CommonService().unAuthorizedUser();
    } else {
      // CommonWidget().showToaster(msg: msg.toString());
    }
  }

  RxBool isLikeLoading = false.obs;
  PostLikeUnlikeModel? postLikeUnlikeModel;

  Future<dynamic> PostLikeUnlikeApi(
      {required BuildContext context,
      required String post_id,
      required String post_id_type,
      required String post_likeStatus}) async {
    debugPrint('0-0-0-0-0-0-0 PostLikeUnlike');

    String idUser = await PreferenceManager().getPref(URLConstants.id);

    isLikeLoading(true);

    Map data = {
      'userId': idUser,
      'postid': post_id,
      'type': post_id_type,
      'likeStatus': post_likeStatus,
      'userName': await PreferenceManager().getPref(URLConstants.userName)
    };
    print(data);
    // String body = json.encode(data);

    var url = (URLConstants.base_url + URLConstants.PostLike_Unlike_Api);
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
      postLikeUnlikeModel = PostLikeUnlikeModel.fromJson(data);
      print(postLikeUnlikeModel?.toJson().toString());
      if (postLikeUnlikeModel!.error == false) {
        CommonWidget().showToaster(msg: postLikeUnlikeModel!.message!);

        // await getAllNewsFeedList();
      } else {
        print('Please try again');
        CommonWidget().showErrorToaster(msg: 'Enter valid Otp');
      }
    } else {
      print('Please try again');
    }
  }

  RxBool iscommentsLoading = true.obs;
  PostCommnetModel? postcommentModel;

  Future<dynamic> getPostCommments(
      {required BuildContext context, required String newsfeedID}) async {
    String idUser = await PreferenceManager().getPref(URLConstants.id);

    iscommentsLoading(true);
    String url =
        ('${URLConstants.base_url}${URLConstants.Post_get_Comment_Api}?postid=$newsfeedID&login_user_id=$idUser');

    // " http://foxyserver.com/funky/api/get-comments.php?postid=628&login_user_id=52"
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
      postcommentModel = PostCommnetModel.fromJson(data);
      // getVideoModelList(newsfeedModel);
      if (postcommentModel!.error == false) {
        debugPrint(
            '2-2-2-2-2-2 Inside the product Controller Details ${postcommentModel!.data!.length}');
        iscommentsLoading(false);
        CommonWidget().showToaster(msg: postcommentModel!.message!.toString());

        return postcommentModel;
      } else {
        iscommentsLoading(false);

        CommonWidget().showToaster(msg: postcommentModel!.message!);
        return null;
      }
    } else if (response.statusCode == 422) {
      CommonWidget().showToaster(msg: postcommentModel!.message!);
    } else if (response.statusCode == 401) {
      // CommonService().unAuthorizedUser();
    } else {
      CommonWidget().showToaster(msg: postcommentModel!.message!);
    }
  }

  RxBool isCommentLikeLoading = true.obs;
  PostCommentLikeModel? postCommentLikeModel;

  Future<dynamic> CommentLikeUnlikeApi({
    required BuildContext context,
    required String comment_id,
    required String comment_type,
    required String comment_likeStatus,
    required String news_id,
  }) async {
    debugPrint('0-0-0-0-0-0-0 username');

    String idUser = await PreferenceManager().getPref(URLConstants.id);

    isCommentLikeLoading(true);

    Map data = {
      'userId': idUser,
      'likeID': comment_id,
      'comment_type': comment_type,
      'likeStatus': comment_likeStatus
    };
    print(data);
    // String body = json.encode(data);

    var url = (URLConstants.base_url + URLConstants.Post_Comment_like_Api);
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
      isCommentLikeLoading(false);
      var data = jsonDecode(response.body);
      postCommentLikeModel = PostCommentLikeModel.fromJson(data);
      print(postCommentLikeModel);
      if (postCommentLikeModel!.error == false) {
        CommonWidget().showToaster(msg: postCommentLikeModel!.message!);
        // await getNewsFeedCommnets(newsfeedID: news_id, context: context);
      } else {
        print('Please try again');
        CommonWidget().showErrorToaster(msg: 'Enter valid Otp');
      }
    } else {
      print('Please try again');
    }
  }

  RxBool isCommentReplyLikeLoading = true.obs;
  PostCommentReplyLikeModel? postCommentReplyLikeModel;

  Future<dynamic> CommentReplyLikeUnlikeApi({
    required BuildContext context,
    required String comment_id,
    required String comment_type,
    required String comment_likeStatus,
    required String news_id,
  }) async {
    debugPrint('0-0-0-0-0-0-0 username');

    String idUser = await PreferenceManager().getPref(URLConstants.id);

    isCommentReplyLikeLoading(true);

    Map data = {
      'userId': idUser,
      'likeID': comment_id,
      'comment_type': comment_type,
      'likeStatus': comment_likeStatus
    };
    print(data);
    // String body = json.encode(data);

    var url =
        (URLConstants.base_url + URLConstants.Post_Comment_reply_like_Api);
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
      isCommentReplyLikeLoading(false);
      var data = jsonDecode(response.body);
      postCommentReplyLikeModel = PostCommentReplyLikeModel.fromJson(data);
      print(postCommentReplyLikeModel);
      if (postCommentReplyLikeModel?.error == false) {
        CommonWidget().showToaster(msg: postCommentReplyLikeModel!.message!);
        // await getNewsFeedCommnets(newsfeedID: news_id, context: context);
      } else {
        print('Please try again');
        CommonWidget().showErrorToaster(msg: 'Enter valid Otp');
      }
    } else {
      print('Please try again');
    }
  }

  RxBool isCommentPostLoading = true.obs;
  postImageCommentPostModel? postcommentPostModel;
  TextEditingController comment_controller = TextEditingController();
  String Replyname_controller = '';
  String Replying_comment_id = '';

  Future<dynamic> CommentPostApi({
    required BuildContext context,
    required String post_id,
    required String news_id,
  }) async {
    debugPrint('0-0-0-0-0-0-0 username');

    String idUser = await PreferenceManager().getPref(URLConstants.id);

    isCommentPostLoading(true);

    Map data = {
      'postid': post_id,
      'userId': idUser,
      'message': comment_controller.text,
      'token': await PreferenceManager().getPref(URLConstants.token)
    };
    print(data);
    // String body = json.encode(data);

    var url = (URLConstants.base_url + URLConstants.Post_Comment_Post_Api);
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
      isCommentPostLoading(false);
      var data = jsonDecode(response.body);
      postcommentPostModel = postImageCommentPostModel.fromJson(data);
      print(postcommentPostModel);
      if (postcommentPostModel!.error == false) {
        CommonWidget().showToaster(msg: postcommentPostModel!.message!);
        await getPostCommments(newsfeedID: news_id, context: context);
        await clear();
      } else {
        print('Please try again');
        CommonWidget().showErrorToaster(msg: 'Enter valid Otp');
      }
    } else {
      print('Please try again');
    }
  }

  RxBool isReplyCommentPostLoading = true.obs;
  PostReplyCommentPostModel? postReplyCommentPostModel;

  Future<dynamic> ReplyCommentPostApi({
    required BuildContext context,
    required String news_id,
  }) async {
    debugPrint('0-0-0-0-0-0-0 username');

    String idUser = await PreferenceManager().getPref(URLConstants.id);

    isReplyCommentPostLoading(true);

    Map data = {
      'userId': idUser,
      'comId': Replying_comment_id,
      'comment': "@$Replyname_controller ${comment_controller.text}",
    };
    print(data);
    // String body = json.encode(data);

    var url =
        (URLConstants.base_url + URLConstants.Post_reply_Comment_Post_Api);
    print("url : $url");
    print("body : $data");

    var response = await http.post(
      Uri.parse(url),
      body: data,
    );
    print("Response ${response.body}");
    print(response.request);
    print(response.statusCode);
    // var final_data = jsonDecode(response.body);

    // print('final data $final_data');

    if (response.statusCode == 200) {
      isReplyCommentPostLoading(false);
      var data = jsonDecode(response.body);
      postReplyCommentPostModel = PostReplyCommentPostModel.fromJson(data);
      print(postReplyCommentPostModel);
      if (postReplyCommentPostModel!.error == false) {
        CommonWidget().showToaster(msg: postReplyCommentPostModel!.message!);
        await getPostCommments(newsfeedID: news_id, context: context);
        await clear();
      } else {
        print('Please try again');
        CommonWidget().showErrorToaster(msg: 'Enter valid');
      }
    } else {
      print('Please try again');
    }
  }

  clear() {
    comment_controller.clear();
  }

  GetPostLikeCount? getPostLikeCount;
  RxBool isStoryCountLoading = true.obs;

  Future<dynamic> get_post_like_count({
    required String post_id,
    required String post_user_id,
  }) async {
    print('Inside creator get email');
    isStoryCountLoading(true);
    String idUser = await PreferenceManager().getPref(URLConstants.id);

    String url =
        ("${URLConstants.base_url}${URLConstants.get_post_like_count}?post_id=$post_id&login_user_id=$idUser&user_id=$post_user_id");
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
      getPostLikeCount = GetPostLikeCount.fromJson(data);
      // getUSerModelList(userInfoModel_email);
      if (getPostLikeCount!.error == false) {
        debugPrint(
            '2-2-2-2-2-2 Inside the Get UserInfo Controller Details ${getPostLikeCount!.data!.length}');
        // story_info = getStoryModel!.data!;

        // CommonWidget().showToaster(msg: data["success"].toString());
        // await Get.to(Dashboard());

        isStoryCountLoading(false);
        return getPostLikeCount;
      } else {
        isStoryCountLoading(false);
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

  RxBool iscommentTagSearchLoading = false.obs;
  GetCommentTagModel? getCommentTagModel;

  Future<dynamic> getCommentTagList(
      {required BuildContext context,
      required String hashtag,
      required String login_id}) async {
    iscommentTagSearchLoading(true);
    // String result1 = hashtag.replaceAll(RegExp('[^A-Za-z]'), '');
    print(hashtag);
    String url =
        ("${URLConstants.base_url}${URLConstants.commentTagGetList}?search=$hashtag&login_user_id=$login_id");
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
      getCommentTagModel = GetCommentTagModel.fromJson(data);
      // getVideoModelList(searchlistModel);
      if (getCommentTagModel!.error == false) {
        debugPrint(
            '2-2-2-2-2-2 Inside the product Controller Details ${getCommentTagModel!.data!.length}');
        iscommentTagSearchLoading(false);
        // CommonWidget().showToaster(msg: data["success"].toString());
        return getCommentTagModel;
      } else {
        iscommentTagSearchLoading(false);

        // CommonWidget().showToaster(msg: msg.toString());
        return null;
      }
    } else if (response.statusCode == 422) {
      iscommentTagSearchLoading(false);

      // CommonWidget().showToaster(msg: msg.toString());
    } else if (response.statusCode == 401) {
      iscommentTagSearchLoading(false);

      // CommonService().unAuthorizedUser();
    } else {
      // CommonWidget().showToaster(msg: msg.toString());
    }
  }

  PostShareRewardModel? postShareRewardModel;

  Future<dynamic> PostRewardGet(
      {required BuildContext context,
      required String post_type,
      required String post_id}) async {
    debugPrint('0-0-0-0-0-0-0 PostLikeUnlike');

    String idUser = await PreferenceManager().getPref(URLConstants.id);

    Map data = {
      'user_id': idUser,
      'type': post_type,
      'type_id': post_id,
      // 'postid': post_id,
      // 'type': post_id_type,
      // 'likeStatus': post_likeStatus
    };
    print(data);
    // String body = json.encode(data);

    var url = (URLConstants.base_url + URLConstants.post_reward);
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
      postShareRewardModel = PostShareRewardModel.fromJson(data);
      print(postShareRewardModel);
      if (postShareRewardModel!.error == false) {
        CommonWidget().showToaster(msg: postShareRewardModel!.message!);

        // await getAllNewsFeedList();
      } else {
        print('Please try again');
        CommonWidget().showErrorToaster(msg: 'Enter valid Otp');
      }
    } else {
      print('Please try again');
    }
  }

  PostViewCountModel? postViewCountModel;

  // RxBool isRewardLoading = true.obs;

  Future<dynamic> Post_view_count({
    required BuildContext context,
    required String post_id,
  }) async {
    debugPrint('0-0-0-0-0-0-0 username');
    String idUser = await PreferenceManager().getPref(URLConstants.id);
    String typeUser = await PreferenceManager().getPref(URLConstants.type);

    Map data = {
      'post_id': post_id,
    };
    print(data);
    // String body = json.encode(data);

    String url = ("${URLConstants.base_url}${URLConstants.postViewCount}");
    // print("url : $url");
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

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = convert.jsonDecode(response.body);
      postViewCountModel = PostViewCountModel.fromJson(data);
      // getBlockModelList(blockListModel);
      if (postViewCountModel!.error == false) {
        debugPrint(
            '2-2-2-2-2-2 Inside the product Controller Details ${postViewCountModel!.message}');
        // CommonWidget().showToaster(msg: getRewardModel!.message!);
        return postViewCountModel;
      } else {
        // CommonWidget().showToaster(msg: msg.toString());
        return null;
      }
    } else if (response.statusCode == 422) {
      CommonWidget().showToaster(msg: postViewCountModel!.message!);
    } else if (response.statusCode == 401) {
      // CommonService().unAuthorizedUser();
    } else {
      CommonWidget().showToaster(msg: postViewCountModel!.message!.toString());
    }
  }

  RxBool isGuestVideoLoading = false.obs;
  GuestVideoModel? guestVideoModel;

  Future<dynamic> getGuestVideosList() async {
    isGuestVideoLoading(true);
    String idUser = await PreferenceManager().getPref(URLConstants.id);
    String url = ('${URLConstants.base_url}${URLConstants.GuestVideoListApi}');
    String msg = '';

    // 'http://foxyserver.com/funky/api/videoList.php?login_user_id=52'

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
      guestVideoModel = GuestVideoModel.fromJson(data);
      if (guestVideoModel!.error == false) {
        debugPrint(
            '2-2-2-2-2-2 Inside the product Controller Details ${guestVideoModel!.data!.length}');
        isGuestVideoLoading(false);
        // CommonWidget().showToaster(msg: data["success"].toString());
        return guestVideoModel;
      } else {
        isGuestVideoLoading(false);

        // CommonWidget().showToaster(msg: msg.toString());
        return null;
      }
    } else if (response.statusCode == 422) {
      isGuestVideoLoading(false);

      // CommonWidget().showToaster(msg: msg.toString());
    } else if (response.statusCode == 401) {
      isGuestVideoLoading(false);

      // CommonService().unAuthorizedUser();
    } else {
      // CommonWidget().showToaster(msg: msg.toString());
    }
  }

  RxBool isallMusicLoading = false.obs;
  GetAllMusicModel? getAllMusicModel;

  Future<dynamic> getAllMusicList() async {
    isallMusicLoading(true);
    String idUser = await PreferenceManager().getPref(URLConstants.id);
    String url =
        ('${URLConstants.base_url}${URLConstants.music_all_get}?login_user_id=$idUser');
    // ('${URLConstants.base_url}${URLConstants.music_all_get}?login_user_id=52');
    String msg = '';

    // 'http://foxyserver.com/funky/api/videoList.php?login_user_id=52'

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
      getAllMusicModel = GetAllMusicModel.fromJson(data);
      if (getAllMusicModel!.error == false) {
        debugPrint(
            '2-2-2-2-2-2 Inside the product Controller Details ${getAllMusicModel!.data!.length}');
        isallMusicLoading(false);
        // CommonWidget().showToaster(msg: data["success"].toString());
        return getAllMusicModel;
      } else {
        isallMusicLoading(false);
        // CommonWidget().showToaster(msg: msg.toString());
        return null;
      }
    } else if (response.statusCode == 422) {
      isallMusicLoading(false);
      // CommonWidget().showToaster(msg: msg.toString());
    } else if (response.statusCode == 401) {
      isallMusicLoading(false);
      // CommonService().unAuthorizedUser();
    } else {
      isallMusicLoading(false);
      // CommonWidget().showToaster(msg: msg.toString());
    }
  }

  RxBool istermsServiceLoading = true.obs;
  TermsServiceModel? termsServiceModel;

  Future<dynamic> getTermsService() async {
    istermsServiceLoading(true);
    String idUser = await PreferenceManager().getPref(URLConstants.id);
    String url = ('${URLConstants.base_url}${URLConstants.termsOfService}');
    // ('${URLConstants.base_url}${URLConstants.music_all_get}?login_user_id=52');
    String msg = '';

    http.Response response = await http.get(Uri.parse(url));

    print('Response request: ${response.request}');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = convert.jsonDecode(response.body);
      termsServiceModel = TermsServiceModel.fromJson(data);
      if (termsServiceModel!.error == 'false') {
        debugPrint(
            '2-2-2-2-2-2 Inside the product Controller Details ${termsServiceModel!.data!.content}');
        istermsServiceLoading(false);
        // CommonWidget().showToaster(msg: data["success"].toString());
        return termsServiceModel;
      } else {
        istermsServiceLoading(false);
        // CommonWidget().showToaster(msg: msg.toString());
        return null;
      }
    } else if (response.statusCode == 422) {
      istermsServiceLoading(false);
      // CommonWidget().showToaster(msg: msg.toString());
    } else if (response.statusCode == 401) {
      istermsServiceLoading(false);
      // CommonService().unAuthorizedUser();
    } else {
      istermsServiceLoading(false);
      // CommonWidget().showToaster(msg: msg.toString());
    }
  }

  Future<dynamic> getprivacyPolicy() async {
    istermsServiceLoading(true);
    String idUser = await PreferenceManager().getPref(URLConstants.id);
    String url = ('${URLConstants.base_url}${URLConstants.privacy_policy}');
    // ('${URLConstants.base_url}${URLConstants.music_all_get}?login_user_id=52');
    String msg = '';

    http.Response response = await http.get(Uri.parse(url));

    print('Response request: ${response.request}');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = convert.jsonDecode(response.body);
      termsServiceModel = TermsServiceModel.fromJson(data);
      if (termsServiceModel!.error == 'false') {
        // debugPrint(
        //     '2-2-2-2-2-2 Inside the product Controller Details ${termsServiceModel!.data!.content}');
        istermsServiceLoading(false);
        // CommonWidget().showToaster(msg: data["success"].toString());
        return termsServiceModel;
      } else {
        istermsServiceLoading(false);
        // CommonWidget().showToaster(msg: msg.toString());
        return null;
      }
    } else if (response.statusCode == 422) {
      istermsServiceLoading(false);
      // CommonWidget().showToaster(msg: msg.toString());
    } else if (response.statusCode == 401) {
      istermsServiceLoading(false);
      // CommonService().unAuthorizedUser();
    } else {
      istermsServiceLoading(false);
      // CommonWidget().showToaster(msg: msg.toString());
    }
  }

  Future<dynamic> getcommunityGuide() async {
    istermsServiceLoading(true);
    String idUser = await PreferenceManager().getPref(URLConstants.id);
    String url = ('${URLConstants.base_url}${URLConstants.community_guide}');
    // ('${URLConstants.base_url}${URLConstants.music_all_get}?login_user_id=52');
    String msg = '';

    http.Response response = await http.get(Uri.parse(url));

    print('Response request: ${response.request}');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = convert.jsonDecode(response.body);
      termsServiceModel = TermsServiceModel.fromJson(data);
      if (termsServiceModel!.error == 'false') {
        // debugPrint(
        //     '2-2-2-2-2-2 Inside the product Controller Details ${termsServiceModel!.data!.content}');
        istermsServiceLoading(false);
        // CommonWidget().showToaster(msg: data["success"].toString());
        return termsServiceModel;
      } else {
        istermsServiceLoading(false);
        // CommonWidget().showToaster(msg: msg.toString());
        return null;
      }
    } else if (response.statusCode == 422) {
      istermsServiceLoading(false);
      // CommonWidget().showToaster(msg: msg.toString());
    } else if (response.statusCode == 401) {
      istermsServiceLoading(false);
      // CommonService().unAuthorizedUser();
    } else {
      istermsServiceLoading(false);
      // CommonWidget().showToaster(msg: msg.toString());
    }
  }
}
