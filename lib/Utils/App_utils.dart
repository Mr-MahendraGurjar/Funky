import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';

class TxtUtils {
  static const Login_type_creator = 'creator';
  static const Login_type_kids = 'kids';
  static const Login_type_advertiser = 'advertiser';
  static const forgot_password = 'Forgot password?';
  static const otp_details = 'OTP has been sent to your email address';

  static const FullName = 'Full name';
  static const UserName = 'User name(unique)';
  static const Email = 'Email Address';
  static const phone = 'Phone';
  static const parents_email = 'Parents Email';
  static const Password = 'Password';
  static const Gender = 'Gender';
  static const Location = 'Location';
  static const ReffrelCode = 'Referral code (Optional)';
  static const CountryCode = 'Country code';
  static const AboutMe = 'About Me';

//drawer
  static const photos = 'Visit Website';
  static const settings = 'Settings';
  static const qr_code = 'My Qr';
  static const analytics = 'Anlytics';
  static const manage_ac = 'Manage Accounts';
  static const rewards = 'Rewards';
  static const t_c = 'Terms & Conditions';
  static const help = 'Help';
}

class URLConstants {
  static const String base_url = 'http://xlgo.in/funky/api/';

  static const String base_data_url = "http://xlgo.in/funky/";

  static const loginApi = "login.php";
  static const SignUpApi = "signup.php";
  static const socailsignUpApi = "social-signup.php";
  static const parentOtpVeri_Api = "parent-otp.php";
  static const creatorsend_Api = "send-otp.php";
  static const check_user_Api = "check-user.php";
  static const creatorverify_Api = "otp-verify.php";
  static const save_settings_Api = "setting.php";

  static const token_Api = "device.php";
  static const password_reset_Api = "forgot-password.php";
  static const password_verify_Api = "forgot-otp-verify.php";
  static const new_password_Api = "create-pssword.php";

  static const user_info_email_Api = "get-profile.php";
  static const user_info_social_Api = "get-socialprofile.php";

  static const VideoListApi = "videoList.php";
  static const GuestVideoListApi = "guestPost.php";
  static const ImagewListApi = "home-imageList.php";
  static const LikedPostListApi = "getLikedPost.php";
  static const FollowersListApi = "get-followUsers.php";
  static const followingListApi = "followingList";
  static const CountryListApi = "getCountry.php";
  static const searchListApi = "search_users.php";
  static const blockListApi = "user-block-list.php";

  static const randomPostListApi = "getRandomPost.php";

  static const NewsFeedApi = "news-feeds.php";
  static const NewsFeedLike_Unlike_Api = "feedsLike.php";
  static const NewsFeed_Comment_Api = "get-newsfeeds-comment.php";
  static const NewsFeed_Comment_like_Api = "news-feeds-comment-like.php";
  static const NewsFeed_Comment_reply_like_Api = "news-feeds-reply-like.php";
  static const NewsFeed_Comment_Post_Api = "news-feeds-comment.php";
  static const NewsFeed_reply_Comment_Post_Api = "news-feeds-reply.php";

  static const PostLike_Unlike_Api = "likeUnlike.php";
  static const Post_get_Comment_Api = "get-comments.php";
  static const Post_Comment_like_Api = "comment-like.php";
  static const Post_Comment_reply_like_Api = "post-reply-likeUnlike.php";
  static const Post_Comment_Post_Api = "comments.php";
  static const Post_reply_Comment_Post_Api = "reply.php";

  static const Discover_Search = "discover.php";
  static const friend_suggestion = "friendSuggestion.php";

  static const post_reward_coin = "postRewardCoin.php";

  static const postApi = "post.php";
  static const StoryPostApi = "newStoryPost.php";
  static const StoryGetApi = "get-storyList.php";

  static const SingleStoryGetApi = "getStory.php";

  static const StoryGetCountApi = "get-viewStory.php";
  static const BrandLogoGetApi = "getBrandLogo.php";
  static const BannerGetApi = "getBanner.php";
  static const StoryDeleteApi = "deleteStory.php";
  static const PostDeleteApi = "deletePost.php";
  static const StoryViewApi = "view-story.php";
  static const StoryEditApi = "editStory.php";

  static const SearchTag = "hashTag.php";
  static const SearchTagPosts = "search-posts.php";

  //searchHistory
  static const SearchHistoryGet = 'getSearchHistory.php';
  static const SearchHistoryPost = 'postSearchHistory.php';

  static const brand_logo_post = "brand-logo-advertiser.php";
  static const banner_image_post = "advertisement.php";
  static const commercial_video_post = "video-advertiser.php";

  //music_post_get
  static const music_post = "postMusic.php";
  static const music_all_get = "getAllMusic.php";
  static const MusicGetApi = "getMusic.php";
  static const MusicPurchaseApi = "purchaseMusic.php";
  static const MusicGetPurchaseApi = "getPurchaseMusic.php";

  //user_setting
  static const post_user_setting = "postUserSetting.php";
  static const get_user_setting = "getUserSetting.php";

  //Post Settings
  static const post_post_setting = "postSetting.php";
  static const get_post_setting = "getPostSetting.php";

  //Notification settings
  static const post_Notification_setting = "postNotificationSetting.php";
  static const get_Notification_setting = "getNotificationSetting.php";

  //Comment settings
  static const post_comment_setting = "postCommentSetting.php";
  static const get_comment_setting = "getCommentSetting.php";

  //
  //change_password
  static const change_password = "changePassword.php";

  //update Email_phone
  static const update_email_phpne = "postUpdateEmailPhone.php";
  static const verify_email_phpne = "postVerifyOtpEmailPhone.php";

  //Reward
  static const get_reward = "getReward.php";
  static const post_reward = "postReward.php";

  //getLikedVideoPhoto
  static const get_post_like_count = "getLikedVideoPhoto.php";

  //getNotications
  static const get_notifications = "getNotificationList.php";
  static const clear_notifications = "clearNotification.php";
  static const delete_notifications = "deleteNotification.php";

  //comment-action
  static const comment_action = "commentAction.php";

  //share-reward
  // static const share_reward = "postReward.php";
  //Report
  static const report_post = "reportProblem.php";
  static const report_get = "getReportProblem.php";

  //commentTagGetList
  static const commentTagGetList = "getUserListTagOnComment.php";

  //postViewCount
  static const postViewCount = "postViewCount.php";

  //postdetails
  static const getPostDetail = "getPostDetail.php";

  //comment block-
  static const searchBlockListApi = "searchUser.php";
  static const getUselistApi = "getBlockUserList.php";
  static const commentuserblock = "userBlockUnblock.php";

  //manualApprovetag
  static const menuallyApproveTag = "menuallyApproveTag.php";

  //deleteAccount
  static const DeleteAccount = "deleteAccount.php";
  static const send_otp_delete = "sendOtp.php";
  static const verify_otp_delete = "otpVerify.php";

  //requestverification
  static const Request_Verification = 'requestVerification.php';

  //draftList
  static const Draft_list = 'getDraftPost.php';

  static const termsOfService = 'termsOfService.php';
  static const privacy_policy = 'privacyPolicy.php';
  static const community_guide = 'communityGuidelines.php';

  //TFA_setting
  static const authentication_post = "postAuthentication";
  static const authentication_get = "getAuthentication.php";

  static String id = "id";
  static String login_user = "id";
  static String username = "user";
  static String type = "type";
  static String social_type = "";
  static String userName = "";
  static String token = "";
}

class CommonService {
  final box = GetStorage();

  void setStoreKey({required String setKey, required String setValue}) async {
    debugPrint(
        '********** Store Storage ${setKey.toString()} = ${setValue.toString()}');
    await box.write(setKey, setValue);
  }

  //
  // void setPermissions({required String setKey, required List setValue}) async {
  //   debugPrint(
  //       '********** Store Storage ${setKey.toString()} = ${setValue
  //           .toString()}');
  //   await box.write(setKey, setValue);
  // }

  String getStoreValue({required String keys}) {
    return box.read(keys).toString();
  }
}
