import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../Utils/App_utils.dart';
import '../../../Utils/asset_utils.dart';
import '../../../Utils/custom_textfeild.dart';
import '../../../getx_pagination/binding_utils.dart';
import '../../../homepage/controller/homepage_controller.dart';
import '../../../news_feed/controller/news_feed_controller.dart';
import '../../../search_screen/search__screen_controller.dart';
import '../../creator_login/controller/creator_login_controller.dart';
import '../../instagram/instagram_view.dart';
import '../../password_reset/ui/email_send.dart';
import '../controller/kids_login_controller.dart';

class KidsLoginScreen extends StatefulWidget {
  const KidsLoginScreen({super.key});

  @override
  State<KidsLoginScreen> createState() => _KidsLoginScreenState();
}

class _KidsLoginScreenState extends State<KidsLoginScreen> {
  // final Kids_Login_screen_controller _kids_loginScreenController =
  // Get.put(Kids_Login_screen_controller(), tag: Kids_Login_screen_controller().toString());

  final _kids_loginScreenController = Kids_Login_screen_controller();

  final Creator_Login_screen_controller _creator_login_screen_controller =
      Get.put(Creator_Login_screen_controller(),
          tag: Creator_Login_screen_controller().toString());
  bool _obscureText = true;

  String? _password;
  final _formKey = GlobalKey<FormState>();
  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  final HomepageController homepageController =
      Get.put(HomepageController(), tag: HomepageController().toString());

  final Search_screen_controller _search_screen_controller = Get.put(
      Search_screen_controller(),
      tag: Search_screen_controller().toString());

  final NewsFeed_screen_controller news_feed_controller = Get.put(
      NewsFeed_screen_controller(),
      tag: NewsFeed_screen_controller().toString());
  String? token;

  void pushFCMtoken() async {
    FirebaseMessaging.instance.getToken().then((value) {
      setState(() {
        token = value;
      });
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
      child: Stack(
        children: [
          Container(
            color: Colors.black,
            height: MediaQuery.of(context).size.height,
          ),
          Container(
            // decoration: BoxDecoration(
            //
            //   image: DecorationImage(
            //     image: AssetImage(AssetUtils.backgroundImage), // <-- BACKGROUND IMAGE
            //     fit: BoxFit.cover,
            //   ),
            // ),
            decoration: const BoxDecoration(
              // gradient: LinearGradient(
              //   begin: Alignment.topCenter,
              //   end: Alignment.bottomCenter,
              //   // stops: [0.1, 0.5, 0.7, 0.9],
              //   colors: [
              //     HexColor("#000000"),
              //     HexColor("#000000").withOpacity(0.97),
              //     HexColor("#C12265").withOpacity(0.5),
              //     HexColor("#C12265").withOpacity(0.5),
              //     HexColor("#C12265").withOpacity(0.8),
              //     HexColor("#FFFFFF").withOpacity(0.97),
              //   ],
              // ),
              image: DecorationImage(
                fit: BoxFit.cover,
                // colorFilter: new ColorFilter.mode(
                //     Colors.black.withOpacity(0.25), BlendMode.dstATop),
                image: AssetImage(
                  AssetUtils.backgroundImage2,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.transparent,
              // appBar: AppBar(
              //   backgroundColor: Colors.transparent,
              // ),
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
                              'LogIn ${TxtUtils.Login_type_kids}',
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
                                _kids_loginScreenController.usernameController,
                            title: 'Username',
                            labelText: 'Username',
                            image_path: AssetUtils.msg_icon,
                            validator: (val) {
                              if (val?.isEmpty ?? true) {
                                return 'Please enter username';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 21,
                          ),
                          CommonTextFormField(
                              controller: _kids_loginScreenController
                                  .passwordController,
                              title: 'Password',
                              labelText: 'Password',
                              isObscure: _obscureText,
                              maxLines: 1,
                              image_path: (_obscureText
                                  ? AssetUtils.eye_open_icon
                                  : AssetUtils.eye_close_icon),
                              validator: (val) {
                                if (val?.isEmpty ?? true) {
                                  return 'Please enter Password';
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
                                bool isValid =
                                    _formKey.currentState!.validate();
                                if (!isValid) {
                                  return;
                                } else {
                                  await checkLogin();
                                }
                              },
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(25)),
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
                                type: TxtUtils.Login_type_kids,
                              ));
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
                            margin: const EdgeInsets.symmetric(horizontal: 30),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 1),
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
                                      borderRadius: BorderRadius.circular(50),
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
                                        _creator_login_screen_controller
                                            .signInWithFacebook(
                                                login_type: 'creator',
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
                                      borderRadius: BorderRadius.circular(50),
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
                                        Get.to(InstagramView(
                                          context: context,
                                          login_type: 'Kids',
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
                                      borderRadius: BorderRadius.circular(50),
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
                                          await _creator_login_screen_controller
                                              .signInwithGoogle(
                                                  context: context,
                                                  login_type: 'Kids');
                                        } catch (e) {
                                          if (e is FirebaseAuthException) {
                                            Fluttertoast.showToast(
                                              msg: "login usuccessfull",
                                              textColor: Colors.white,
                                              backgroundColor: Colors.black,
                                              toastLength: Toast.LENGTH_LONG,
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
                                      borderRadius: BorderRadius.circular(50),
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
                                        _creator_login_screen_controller
                                            .signInWithTwitter(
                                                context: context,
                                                login_type: 'kids');
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 22,
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(BindingUtils.kids_signup);
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
              ),
            ),
          )
        ],
      ),
    );
  }

  Future checkLogin() async {
    await _kids_loginScreenController.checkLogin(
        context: context, login_type: TxtUtils.Login_type_kids);
  }
}
