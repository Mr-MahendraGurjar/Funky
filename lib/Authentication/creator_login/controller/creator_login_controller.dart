import 'dart:convert' as convert;
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:funky_new/Utils/toaster_widget.dart';
import 'package:funky_new/custom_widget/page_loader.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:twitter_login/twitter_login.dart';

import '../../../Utils/App_utils.dart';
import '../../../agora/presentaion/cubit/Auth/auth_cubit.dart';
import '../../../dashboard/dashboard_screen.dart';
import '../../../homepage/controller/homepage_controller.dart';
import '../../../homepage/model/UserInfoModel.dart';
import '../../../news_feed/controller/news_feed_controller.dart';
import '../../../search_screen/search__screen_controller.dart';
import '../../../sharePreference.dart';
import '../../../shared/network/cache_helper.dart';
import '../../verify_otp_auth_screen.dart';
import '../model/creator_loginModel.dart';
import '../model/tokenModel.dart';

class Creator_Login_screen_controller extends GetxController {
  // RxBool isLoading = false.obs;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  TextEditingController twitter_link_controller = TextEditingController();
  TextEditingController facebook_link_controller = TextEditingController();
  TextEditingController instagram_link_controller = TextEditingController();

  TextEditingController tiktok_links_controller = TextEditingController();
  TextEditingController snapchat_links_controller = TextEditingController();
  TextEditingController linkedin_links_controller = TextEditingController();

  TextEditingController gmail_links_controller = TextEditingController();
  TextEditingController whatsapp_links_controller = TextEditingController();
  TextEditingController skype_links_controller = TextEditingController();

  TextEditingController youtube_links_controller = TextEditingController();
  TextEditingController pinterest_links_controller = TextEditingController();
  TextEditingController reddit_links_controller = TextEditingController();
  TextEditingController telegram_links_controller = TextEditingController();

  LoginModel? loginModel;

  // final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<dynamic> checkLogin(
      {required BuildContext context, required String login_type}) async {
    debugPrint('0-0-0-0-0-0-0 username');
    try {
      // isLoading(true);
      showLoader(context);
      Map data = {
        'userName': usernameController.text,
        'password': passwordController.text,
        'type': login_type,
      };
      print(data);
      // String body = json.encode(data);

      var url = (URLConstants.base_url + URLConstants.loginApi);
      print("url : $url");
      print("body : $data");

      var response = await http.post(
        Uri.parse(url),
        body: data,
      );
      print(response.body);
      print(response.request);
      print(response.statusCode);

      if (response.statusCode == 200) {
        // isLoading(false);
        var data = jsonDecode(response.body);
        loginModel = LoginModel.fromJson(data);
        print('loginModel==>${loginModel?.toJson()}');
        if (loginModel!.error == false) {
          await PreferenceManager()
              .setPref(URLConstants.id, loginModel!.user![0].id!);

          await PreferenceManager()
              .setPref(URLConstants.type, loginModel!.user![0].type!);

          await PreferenceManager().setPref(URLConstants.social_type, "");

          if (loginModel!.user![0].textMessage == 'true') {
            await Get.to(const VerifyOtpAuth());
          } else {
            await clear();

            String idUser = await PreferenceManager().getPref(URLConstants.id);
            String socialTypeUser =
                await PreferenceManager().getPref(URLConstants.social_type);
            await homepageController.getAllVideosList();
            await homepageController.getAllImagesList();
            await _search_screen_controller.getDiscoverFeed(context: context);
            await news_feed_controller.getAllNewsFeedList();

            await PreferenceManager().getPref(URLConstants.social_type);
            // print("id----- $idUser");
            print("id----- $socialTypeUser");
            (socialTypeUser == ""
                ? await CreatorgetUserInfo_Email(
                    context: context, UserId: idUser)
                : await getUserInfo_social());
            // await _creator_login_screen_controller.PostToken(context: context, token: token!, userid: id_user);

            hideLoader(context);
            CacheHelper.saveData(key: "uId", value: loginModel!.user![0].id!);
            CacheHelper.saveData(
                key: "userName", value: loginModel!.user![0].userName!);

            //! for agora
            AuthCubit.get(context).checkUserExistInFirebase(uId: idUser);
            await Get.to(Dashboard(
              page: 0,
            ));
          }

          hideLoader(context);
        } else {
          hideLoader(context);
          CommonWidget().showErrorToaster(msg: "Invalid Details");
          print('Please try again');
          print('Please try again');
        }
      } else {}
    } catch (e) {
      hideLoader(context);
      print('SignIn Error :- ${e.toString()}');
    }
  }

  clear() {
    usernameController.clear();
    passwordController.clear();
  }

  RxBool isuserinfoLoading = true.obs;
  Rx<UserInfoModel> userInfoModel_email = UserInfoModel().obs;
  var getUSerModelList = UserInfoModel().obs;

  Future<dynamic> CreatorgetUserInfo_Email(
      {required String UserId, required BuildContext context}) async {
    print('Inside creator get email');
    isuserinfoLoading(true);
    showLoader(context);
    String idUser = await PreferenceManager().getPref(URLConstants.id);
    print("UserID $idUser");
    String url =
        ("${URLConstants.base_url}${URLConstants.user_info_email_Api}?id=$idUser&login_user_id=$idUser");

    http.Response response = await http.get(Uri.parse(url));

    print('Response request: ${response.request}');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = convert.jsonDecode(response.body);
      userInfoModel_email.value = UserInfoModel.fromJson(data);

      getUSerModelList(userInfoModel_email.value);
      if (userInfoModel_email.value.error == false) {
        debugPrint(
            '2-2-2-2-2-2 Inside the Get UserInfo Controller Details ${userInfoModel_email.value.data!.length}');
        facebook_link_controller.text =
            userInfoModel_email.value.data![0].facebookLinks!;
        twitter_link_controller.text =
            userInfoModel_email.value.data![0].twitterLinks!;
        instagram_link_controller.text =
            userInfoModel_email.value.data![0].instagramLinks!;
        tiktok_links_controller.text =
            userInfoModel_email.value.data![0].tiktokLinks!;
        snapchat_links_controller.text =
            userInfoModel_email.value.data![0].snapchatLinks!;
        linkedin_links_controller.text =
            userInfoModel_email.value.data![0].linkedinLinks!;
        gmail_links_controller.text =
            userInfoModel_email.value.data![0].gmailLinks!;
        whatsapp_links_controller.text =
            userInfoModel_email.value.data![0].whatsappLinks!;
        skype_links_controller.text =
            userInfoModel_email.value.data![0].skypeLinks!;
        youtube_links_controller.text =
            userInfoModel_email.value.data![0].youtubeLinks!;
        pinterest_links_controller.text =
            userInfoModel_email.value.data![0].pinterestLinks!;
        reddit_links_controller.text =
            userInfoModel_email.value.data![0].redditLinks!;
        telegram_links_controller.text =
            userInfoModel_email.value.data![0].telegramLinks!;
        isuserinfoLoading(false);

        hideLoader(context);

        return userInfoModel_email.value;
      } else {
        hideLoader(context);
        isuserinfoLoading(false);

        // CommonWidget().showToaster(msg: msg.toString());
        return null;
      }
    } else if (response.statusCode == 422) {
      hideLoader(context);
      isuserinfoLoading(false);

      // CommonWidget().showToaster(msg: msg.toString());
    } else if (response.statusCode == 401) {
      hideLoader(context);
      isuserinfoLoading(false);

      // CommonService().unAuthorizedUser();
    } else {
      // CommonWidget().showToaster(msg: msg.toString());
    }
  }

  Future<dynamic> getUserInfo_social() async {
    isuserinfoLoading(true);
    String idUser = await PreferenceManager().getPref(URLConstants.id);

    print("UserID $idUser");
    String url =
        ("${URLConstants.base_url}${URLConstants.user_info_social_Api}?id=$idUser&login_user_id=$idUser");

    http.Response response = await http.get(Uri.parse(url));

    print('Response request: ${response.request}');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = convert.jsonDecode(response.body);
      userInfoModel_email.value = UserInfoModel.fromJson(data);
      getUSerModelList(userInfoModel_email.value);
      if (userInfoModel_email.value.error == false) {
        debugPrint(
            '2-2-2-2-2-2 Inside the product Controller Details ${userInfoModel_email.value.data!.length}');
        facebook_link_controller.text =
            userInfoModel_email.value.data![0].facebookLinks!;
        twitter_link_controller.text =
            userInfoModel_email.value.data![0].twitterLinks!;
        instagram_link_controller.text =
            userInfoModel_email.value.data![0].instagramLinks!;
        tiktok_links_controller.text =
            userInfoModel_email.value.data![0].tiktokLinks!;
        snapchat_links_controller.text =
            userInfoModel_email.value.data![0].snapchatLinks!;
        linkedin_links_controller.text =
            userInfoModel_email.value.data![0].linkedinLinks!;
        gmail_links_controller.text =
            userInfoModel_email.value.data![0].gmailLinks!;
        whatsapp_links_controller.text =
            userInfoModel_email.value.data![0].whatsappLinks!;
        skype_links_controller.text =
            userInfoModel_email.value.data![0].skypeLinks!;
        youtube_links_controller.text =
            userInfoModel_email.value.data![0].youtubeLinks!;
        pinterest_links_controller.text =
            userInfoModel_email.value.data![0].pinterestLinks!;
        reddit_links_controller.text =
            userInfoModel_email.value.data![0].redditLinks!;
        telegram_links_controller.text =
            userInfoModel_email.value.data![0].telegramLinks!;

        isuserinfoLoading(false);

        return userInfoModel_email.value;
      } else {
        isuserinfoLoading(false);

        return null;
      }
    } else if (response.statusCode == 422) {
      isuserinfoLoading(false);
    } else if (response.statusCode == 401) {
      isuserinfoLoading(false);
    } else {}
  }

  TokenModel? tokenModel;

  Future<dynamic> PostToken(
      {required BuildContext context,
      required String token,
      required String userid}) async {
    debugPrint('0-0-0-0-0-0-0 token');

    Map data = {
      'userId': userid,
      'token': token,
    };
    print(data);

    var url = (URLConstants.base_url + URLConstants.token_Api);
    print("url : $url");
    print("body : $data");

    var response = await http.post(
      Uri.parse(url),
      body: data,
    );
    print(response.body);
    print(response.request);
    print(response.statusCode);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      tokenModel = TokenModel.fromJson(data);
      print(tokenModel);
      if (tokenModel!.error == false) {
      } else {
        CommonWidget().showErrorToaster(msg: "Invalid Details");
        print('Please try again');
        print('Please try again');
      }
    } else {}
  }

  UserCredential? userCredential;

  Future<Resource?> signInWithFacebook(
      {required BuildContext context, required String login_type}) async {
    final LoginResult result = await FacebookAuth.instance
        .login(permissions: ["public_profile", "email"]);

    switch (result.status) {
      case LoginStatus.success:
        final AuthCredential facebookCredential =
            FacebookAuthProvider.credential(result.accessToken!.tokenString);
        userCredential = await FirebaseAuth.instance
            .signInWithCredential(facebookCredential);

        await social_group_login(
            login_type: login_type, context: context, socail_type: 'facebook');

        Fluttertoast.showToast(
          msg: "login successfully",
          textColor: Colors.white,
          backgroundColor: Colors.black,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );

        print(userCredential!.user!.displayName);
        return Resource(status: Status.Success);
      case LoginStatus.cancelled:
        return Resource(status: Status.Cancelled);
      case LoginStatus.failed:
        return Resource(status: Status.Error);
      default:
        return null;
    }
  }

//   final fb = FacebookLogin();
//
//   Future SignInFacebook(
//       {required BuildContext context, required String login_type}) async {
// // Create an instance of FacebookLogin
//
// // Log in
//     final res = await fb.logIn(permissions: [
//       FacebookPermission.publicProfile,
//       FacebookPermission.email,
//     ]);
//
// // Check result status
//     switch (res.status) {
//       case FacebookLoginStatus.success:
//         // Logged in
//
//         // Send access token to server for validation and auth
//         final FacebookAccessToken? accessToken = res.accessToken;
//         print('Access token: ${accessToken!.token}');
//
//         // Get profile data
//         final profile = await fb.getUserProfile();
//         print('Hello, ${profile!.name}! You ID: ${profile.userId}');
//         // Get user profile image url
//         final imageUrl = await fb.getProfileImageUrl(width: 100);
//         print('Your profile image: $imageUrl');
//
//         // Get email (since we request email permission)
//         final email = await fb.getUserEmail();
//         // But user can decline permission
//         if (email != null) print('And your email is $email');
//
//         // print(
//         //     "userCredential!.user!.displayName ${userCredential!.user!.displayName}");
//
//         await social_fb_login(
//             login_type: login_type,
//             context: context,
//             socail_type: 'facebook',
//             profileUrl: imageUrl!,
//             socialId: '',
//             username: profile.name!);
//
//         Fluttertoast.showToast(
//           msg: "login successfully",
//           textColor: Colors.white,
//           backgroundColor: Colors.black,
//           toastLength: Toast.LENGTH_LONG,
//           gravity: ToastGravity.BOTTOM,
//         );
//         break;
//       case FacebookLoginStatus.cancel:
//         // User cancel log in
//         break;
//       case FacebookLoginStatus.error:
//         // Log in failed
//         print('Error while log in: ${res.error}');
//         break;
//     }
//   }

  // fullName,userName,email,phone,parent_email,password,gender,location,referral_code,image,type,profileUrl,socialId,social_type

  final HomepageController homepageController =
      Get.put(HomepageController(), tag: HomepageController().toString());

  final Search_screen_controller _search_screen_controller = Get.put(
      Search_screen_controller(),
      tag: Search_screen_controller().toString());

  final NewsFeed_screen_controller news_feed_controller = Get.put(
      NewsFeed_screen_controller(),
      tag: NewsFeed_screen_controller().toString());

  Future social_group_login(
      {required BuildContext context,
      required String login_type,
      required String socail_type}) async {
    debugPrint('0-0-0-0-0-0-0 username');
    showLoader(context);
    // try {
    //
    // } catch (e) {
    //   print('0-0-0-0-0-0- SignIn Error :- ${e.toString()}');
    // }
    try {
      // isLoading(true);
      Map data = {
        'fullName': userCredential!.user!.displayName,
        'userName': userCredential!.user!.displayName,
        'email': "",
        'phone': "",
        'parent_email': "",
        'password': "",
        'gender': "",
        'location': "",
        'referral_code': "",
        'image': "",
        'profileUrl': userCredential!.user!.photoURL,
        'socialId': userCredential!.user!.uid,
        'social_type': socail_type,
        'type': login_type,
      };
      print(data);
      // String body = json.encode(data);

      var url = (URLConstants.base_url + URLConstants.socailsignUpApi);
      print("url : $url");
      print("body : $data");

      var response = await http.post(
        Uri.parse(url),
        body: data,
      );
      print("response.body ${response.body}");
      print("response.request ${response.request}");
      print("response.statusCode ${response.statusCode}");
      // var final_data = jsonDecode(response.body);

      // print('final data $final_data');

      if (response.statusCode == 200) {
        // isLoading(false);
        var data = jsonDecode(response.body);
        loginModel = LoginModel.fromJson(data);
        print("loginModel");
        if (loginModel!.error == false) {
          CommonService().setStoreKey(
              setKey: 'id', setValue: loginModel!.user![0].id!.toString());
          await PreferenceManager()
              .setPref(URLConstants.id, loginModel!.user![0].id!);
          await PreferenceManager()
              .setPref(URLConstants.type, loginModel!.user![0].type!);
          await PreferenceManager()
              .setPref(URLConstants.social_type, socail_type);
          await PreferenceManager()
              .setPref(URLConstants.token, loginModel!.user![0].token ?? '');

          CommonWidget().showToaster(msg: loginModel!.message!);

          /// Firebase database messaging method
          // final QuerySnapshot result = await firebaseFirestore
          //     .collection(FirestoreConstants.pathUserCollection)
          //     .where(FirestoreConstants.id, isEqualTo: loginModel!.user![0].id)
          //     .get();
          // final List<DocumentSnapshot> documents = result.docs;
          // if (documents.isEmpty) {
          //   print("new user created");
          //   // Writing data to server because here is a new user
          //   firebaseFirestore
          //       .collection(FirestoreConstants.pathUserCollection)
          //       .doc(loginModel!.user![0].id)
          //       .set({
          //     FirestoreConstants.nickname: userCredential!.user!.displayName,
          //     FirestoreConstants.photoUrl: userCredential!.user!.photoURL,
          //     FirestoreConstants.id: loginModel!.user![0].id,
          //     'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
          //     FirestoreConstants.chattingWith: null
          //   });
          //
          //   // Write data to local storage
          //   // User? currentUser = firebaseUser;
          //   SharedPreferences prefs = await SharedPreferences.getInstance();
          //   await prefs.setString(
          //       FirestoreConstants.id, loginModel!.user![0].id!);
          //   await prefs.setString(FirestoreConstants.nickname,
          //       userCredential!.user!.displayName ?? "");
          //   await prefs.setString(FirestoreConstants.photoUrl,
          //       userCredential!.user!.photoURL ?? "");
          // } else {
          //   print("user existed");
          //   DocumentSnapshot documentSnapshot = documents[0];
          //   UserChat userChat = UserChat.fromDocument(documentSnapshot);
          //   // Write data to local
          //   SharedPreferences prefs = await SharedPreferences.getInstance();
          //   await prefs.setString(FirestoreConstants.id, userChat.id);
          //   await prefs.setString(
          //       FirestoreConstants.nickname, userChat.nickname);
          //   await prefs.setString(
          //       FirestoreConstants.photoUrl, userChat.photoUrl);
          //   await prefs.setString(FirestoreConstants.aboutMe, userChat.aboutMe);
          // }

          ///

          String idUser = await PreferenceManager().getPref(URLConstants.id);
          String socialTypeUser =
              await PreferenceManager().getPref(URLConstants.social_type);
          await homepageController.getAllVideosList();
          await homepageController.getAllImagesList();
          await _search_screen_controller.getDiscoverFeed(context: context);
          await news_feed_controller.getAllNewsFeedList();

          await PreferenceManager().getPref(URLConstants.social_type);
          // print("id----- $idUser");
          print("id----- $socialTypeUser");
          (socialTypeUser == ""
              ? await CreatorgetUserInfo_Email(context: context, UserId: idUser)
              : await getUserInfo_social());

          await Get.to(Dashboard(
            page: 0,
          ));

          await getUserInfo_social();

          // Fluttertoast.showToast(
          //   msg: "login successfully",
          //   textColor: Colors.white,
          //   backgroundColor: Colors.black,
          //   toastLength: Toast.LENGTH_LONG,
          //   gravity: ToastGravity.BOTTOM,
          // );
          hideLoader(context);
          // await Get.to(Dashboard(page: 0,));
        } else {
          print('Please try again');
        }
      } else {
        print('Please try again');
      }
    } on Exception catch (e) {
      print('0-0-0-0-0-0- SignIn Error :- ${e.toString()}');
    }
  }

  Future social_fb_login(
      {required BuildContext context,
      required String username,
      required String profileUrl,
      required String socialId,
      required String login_type,
      required String socail_type}) async {
    debugPrint('0-0-0-0-0-0-0 username');
    showLoader(context);

    try {
      // isLoading(true);
      Map data = {
        'fullName': username,
        'userName': username,
        'email': "",
        'phone': "",
        'parent_email': "",
        'password': "",
        'gender': "",
        'location': "",
        'referral_code': "",
        'image': "",
        'profileUrl': profileUrl,
        'socialId': socialId,
        'social_type': socail_type,
        'type': login_type,
      };
      print(data);
      // String body = json.encode(data);

      var url = (URLConstants.base_url + URLConstants.socailsignUpApi);
      print("url : $url");
      print("body : $data");

      var response = await http.post(
        Uri.parse(url),
        body: data,
      );
      print("response.body ${response.body}");
      print("response.request ${response.request}");
      print("response.statusCode ${response.statusCode}");
      // var final_data = jsonDecode(response.body);

      // print('final data $final_data');

      if (response.statusCode == 200) {
        // isLoading(false);
        var data = jsonDecode(response.body);
        loginModel = LoginModel.fromJson(data);
        print("loginModel");
        if (loginModel!.error == false) {
          CommonService().setStoreKey(
              setKey: 'id', setValue: loginModel!.user![0].id!.toString());
          await PreferenceManager()
              .setPref(URLConstants.id, loginModel!.user![0].id!);
          await PreferenceManager()
              .setPref(URLConstants.type, loginModel!.user![0].type!);
          await PreferenceManager()
              .setPref(URLConstants.social_type, socail_type);
          await getUserInfo_social();

          Fluttertoast.showToast(
            msg: "login successfully",
            textColor: Colors.white,
            backgroundColor: Colors.black,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
          );
          hideLoader(context);
          await Get.to(Dashboard(
            page: 0,
          ));
        } else {
          print('Please try again');
        }
      } else {
        print('Please try again');
      }
    } on Exception catch (e) {
      print('0-0-0-0-0-0- SignIn Error :- ${e.toString()}');
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  //
  Future<String?> signInwithGoogle(
      {required BuildContext context, required String login_type}) async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential != null) {
        await social_group_login(
            login_type: login_type, context: context, socail_type: 'google');

        // Get.to(Dashboard());
      }
      // User user = result.user;
      await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print("e.message");
        print(e.message);
      }
      rethrow;
    }
    return null;
  }

  //
  RxBool twitterloading = false.obs;

  Future<Resource?> signInWithTwitter(
      {required BuildContext context, required String login_type}) async {
    twitterloading(true);
    print('inside');
    try {
      final twitterLogin = TwitterLogin(
        // apiKey: "2vEtlVAfmb6J8r4qFpIgjxWEt",
        // apiSecretKey: "4WU6EQQ569gkBU9E4GwCiB5FhQz1vsupzFYGMT2vqEzpBE8l9J",
        // redirectURI: "flutter-twitter-practice://",
        apiKey: "SHLsCQTEIj81TXQKdMEbzu7up",
        apiSecretKey: "IVNTDMACkv2r6218Ctf7nj38moKzKRGvdhfr00iZns0YzLG4JZ",
        redirectURI: "twittersdk://",
      );
      final authResult = await twitterLogin.login();
      // // Trigger the sign-in flow
      // final authResult = await twitterLogin.login();
      // print("authResult.authToken! ${authResult.authToken!}");
      // // Create a credential from the access token
      // final twitterAuthCredential = TwitterAuthProvider.credential(
      //   accessToken: authResult.authToken!,
      //   secret: authResult.authTokenSecret!,
      // );
      //
      // // Once signed in, return the UserCredential
      // return await FirebaseAuth.instance.signInWithCredential(twitterAuthCredential);
      switch (authResult.status) {
        case TwitterLoginStatus.loggedIn:
          final AuthCredential twitterAuthCredential =
              TwitterAuthProvider.credential(
                  accessToken: authResult.authToken!,
                  secret: authResult.authTokenSecret!);
          twitterloading(false);

          userCredential =
              await _auth.signInWithCredential(twitterAuthCredential);
          print("userCredential : ${userCredential!.user!.displayName!}");
          await social_group_login(
              login_type: login_type, context: context, socail_type: 'twitter');
          // print(userCredential!.user!.email!);

          Fluttertoast.showToast(
            msg: "login successfully",
            textColor: Colors.white,
            backgroundColor: Colors.black,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
          );
          return Resource(status: Status.Success);
        case TwitterLoginStatus.cancelledByUser:
          print('erorrrrrccccccccccc');
          return Resource(status: Status.Success);
        case TwitterLoginStatus.error:
          print("Status.Error Status.Error");
          return Resource(status: Status.Error);
        default:
          return null;
      }
    } on FirebaseAuthException catch (e) {
      rethrow;
    }
  }

// void signInWithTwitter() async {
//   // Create a TwitterLogin instance
//   final twitterLogin = new TwitterLogin(
//     apiKey: "eT1D5ufcCT0HbHQ6MG3jn2Lbw",
//     apiSecretKey: "TnK8pyuSmt5wVsn8d5RKPgsHEkQsI25EZMQi2fd85Y6jv6cZhN",
//     // redirectURI: "flutter-twitter-practice://",
//     redirectURI: "twittersdk://",
//   );
//
//   // Trigger the sign-in flow
//   await twitterLogin.login().then((value) async {
//     final authToken = value.authToken;
//     final authTokenSecret = value.authTokenSecret;
//     if (authToken != null && authTokenSecret != null) {
//       final twitterAuthCredentials = TwitterAuthProvider.credential(
//           accessToken: authToken, secret: authTokenSecret);
//       await FirebaseAuth.instance
//           .signInWithCredential(twitterAuthCredentials);
//     }
//     else{
//       print('token missing');
//     }
//   });
// }
}

class Resource {
  final Status status;

  Resource({required this.status});
}

enum Status { Success, Error, Cancelled }
