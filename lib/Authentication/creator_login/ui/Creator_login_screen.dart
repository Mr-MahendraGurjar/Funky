// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:funky_project/dashboard/dashboard_screen.dart';
import 'package:get/get.dart';

import '../../../Utils/App_utils.dart';
import '../../../Utils/asset_utils.dart';
import '../../../Utils/custom_textfeild.dart';
import '../../../getx_pagination/binding_utils.dart';
import '../../../homepage/controller/homepage_controller.dart';
import '../../../news_feed/controller/news_feed_controller.dart';
import '../../../search_screen/search__screen_controller.dart';
import '../../instagram/instagram_view.dart';
import '../../password_reset/ui/email_send.dart';
import '../controller/creator_login_controller.dart';

class CreatorLoginScreen extends StatefulWidget {
  const CreatorLoginScreen({super.key});

  @override
  State<CreatorLoginScreen> createState() => _CreatorLoginScreenState();
}

class _CreatorLoginScreenState extends State<CreatorLoginScreen> {
  final Creator_Login_screen_controller _loginScreenController = Get.put(
      Creator_Login_screen_controller(),
      tag: Creator_Login_screen_controller().toString());

  String? _errorMsg;
  Map? _userData;
  final _formKey = GlobalKey<FormState>();
  // Initially password is obscure
  bool _obscureText = true;

  String? _password;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    pushFCMtoken();
    // SimpleAuthFlutter.init(context);
    super.initState();
  }

  final HomepageController homepageController =
      Get.put(HomepageController(), tag: HomepageController().toString());

  final Search_screen_controller _search_screen_controller = Get.put(
      Search_screen_controller(),
      tag: Search_screen_controller().toString());

  final NewsFeed_screen_controller news_feed_controller = Get.put(
      NewsFeed_screen_controller(),
      tag: NewsFeed_screen_controller().toString());

  final Creator_Login_screen_controller _creator_login_screen_controller =
      Get.put(Creator_Login_screen_controller(),
          tag: Creator_Login_screen_controller().toString());

  String? token;

  void pushFCMtoken() async {
    FirebaseMessaging.instance.getToken().then((value) {
      setState(() {
        token = value;
      });
      print("TOKEN :$token");
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: GetBuilder<Creator_Login_screen_controller>(
        init: _loginScreenController,
        builder: (GetxController controller) {
          return Stack(
            children: [
              Container(
                color: Colors.black,
                height: MediaQuery.of(context).size.height,
              ),
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      AssetUtils.backgroundImage1,
                    ),
                  ),
                ),
              ),
              Scaffold(
                  resizeToAvoidBottomInset: false,
                  backgroundColor: Colors.transparent,
                  body: NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        const SliverAppBar(
                          backgroundColor: Colors.transparent,
                          automaticallyImplyLeading: true,
                        ),
                      ];
                    },
                    body: SizedBox(
                      width: screenwidth,
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 86, right: 86, top: 0, bottom: 20),
                                child: Image.asset(
                                  AssetUtils.logo,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                child: const Text(
                                  'LogIn ${TxtUtils.Login_type_creator}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'PB',
                                      color: Colors.white),
                                ),
                              ),
                              const SizedBox(
                                height: 41,
                              ),

                              CommonTextFormField(
                                controller:
                                    _loginScreenController.usernameController,
                                title: 'Username',
                                labelText: 'Username',
                                image_path: AssetUtils.msg_icon,
                                validator: (val) {
                                  if (val?.isEmpty ?? true) {
                                    return 'Please enter username';
                                  }
                                  return null;
                                },
                                onChanged: (login) {},
                              ),
                              const SizedBox(
                                height: 21,
                              ),
                              CommonTextFormField(
                                  controller:
                                      _loginScreenController.passwordController,
                                  title: 'Password',
                                  labelText: 'Password',
                                  isObscure: _obscureText,
                                  maxLines: 1,
                                  image_path: (_obscureText
                                      ? AssetUtils.eye_open_icon
                                      : AssetUtils.eye_close_icon),
                                  validator: (val) {
                                    if (val?.isEmpty ?? true) {
                                      return 'Please enter password';
                                    }
                                    return null;
                                  },
                                  onpasswordTap: () {
                                    _toggle();
                                  }),

                              const SizedBox(
                                height: 22,
                              ),

                              GestureDetector(
                                  onTap: () async {
                                    print('object');
                                    bool isValid =
                                        _formKey.currentState!.validate();
                                    if (!isValid) {
                                      return;
                                    } else {
                                      await checkLogin();
                                    }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    // height: 45,
                                    // width:(width ?? 300) ,
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    child: Container(
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      child: const Text(
                                        'Login',
                                        style: TextStyle(
                                            fontSize: 17, color: Colors.white),
                                      ),
                                    ),
                                  )),

                              const SizedBox(
                                height: 22,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.to(const sendEmail(
                                      type: TxtUtils.Login_type_creator));
                                },
                                child: Container(
                                  child: const Text('Forgot Password ?',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'PB',
                                          color: Colors.white)),
                                ),
                              ),
                              const SizedBox(
                                height: 22,
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black, width: 1),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(24)),
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 7),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          visualDensity: const VisualDensity(
                                              vertical: -4, horizontal: -4),
                                          icon: Image.asset(
                                            AssetUtils.facebook_icon,
                                            height: 32,
                                            width: 32,
                                          ),
                                          onPressed: () {
                                            // _loginScreenController.signInWithFacebook(
                                            //     login_type: 'creator', context: context);
                                            //
                                            _loginScreenController
                                                .signInWithFacebook(
                                                    login_type: TxtUtils
                                                        .Login_type_creator,
                                                    context: context);
                                          },
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        color: Colors.grey,
                                        height: 18,
                                        width: 1,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          visualDensity: const VisualDensity(
                                              vertical: -4, horizontal: -4),
                                          icon: Image.asset(
                                            AssetUtils.instagram_icon,
                                            height: 32,
                                            width: 32,
                                          ),
                                          onPressed: () {
                                            // _loginAndGetData();
                                            Get.to(InstagramView(
                                              context: context,
                                              login_type:
                                                  TxtUtils.Login_type_creator,
                                            ));
                                          },
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        color: Colors.grey,
                                        height: 18,
                                        width: 1,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          visualDensity: const VisualDensity(
                                              vertical: -4, horizontal: -4),
                                          icon: Image.asset(
                                            AssetUtils.email_icon,
                                            height: 32,
                                            width: 32,
                                          ),
                                          onPressed: () async {
                                            try {
                                              await _loginScreenController
                                                  .signInwithGoogle(
                                                      context: context,
                                                      login_type: TxtUtils
                                                          .Login_type_creator);
                                              // Get.to(Dashboard());
                                            } catch (e) {
                                              if (e is FirebaseAuthException) {
                                                Fluttertoast.showToast(
                                                  msg: "login unsuccessful",
                                                  textColor: Colors.white,
                                                  backgroundColor: Colors.black,
                                                  toastLength:
                                                      Toast.LENGTH_LONG,
                                                  gravity: ToastGravity.BOTTOM,
                                                );
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        color: Colors.grey,
                                        height: 18,
                                        width: 1,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          visualDensity: const VisualDensity(
                                              vertical: -4, horizontal: -4),
                                          icon: Image.asset(
                                            AssetUtils.twitter_icon,
                                            height: 32,
                                            width: 32,
                                          ),
                                          onPressed: () {
                                            _loginScreenController
                                                .signInWithTwitter(
                                                    context: context,
                                                    login_type: 'Creator');
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Obx(() =>
                              //     (_loginScreenController.twitterloading.value == true)
                              //         ? CircularProgressIndicator(
                              //             backgroundColor: Colors.grey,
                              //             color: Colors.purple,
                              //           )
                              //         : SizedBox.shrink()),
                              const SizedBox(
                                height: 22,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(BindingUtils.creator_signup);

                                  // Get.toNamed(BindingUtils.ageVerification);
                                },
                                child: Container(
                                  child: const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'PB',
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 22,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ))
            ],
          );
        },
      ),
    );
  }

  // LoginModel? loginModel;

  Future checkLogin() async {
    await _loginScreenController.checkLogin(
        context: context, login_type: TxtUtils.Login_type_creator);
  }
}
