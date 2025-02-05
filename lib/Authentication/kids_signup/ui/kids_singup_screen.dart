import 'dart:convert';
import 'dart:io' as Io;
import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:funky_project/Authentication/creator_signup/model/countryModelclass.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../Utils/App_utils.dart';
import '../../../Utils/asset_utils.dart';
import '../../../Utils/custom_textfeild.dart';
import '../../../Utils/toaster_widget.dart';
import '../../creator_login/model/creator_loginModel.dart';
import '../../creator_signup/controller/creator_signup_controller.dart';
import '../../creator_signup/model/countryModelclass.dart';
import '../controller/kids_signup_controller.dart';

class KidSignupScreen extends StatefulWidget {
  const KidSignupScreen({super.key});

  @override
  State<KidSignupScreen> createState() => _KidSignupScreenState();
}

class _KidSignupScreenState extends State<KidSignupScreen> {
  final Kids_signup_controller _kids_signup_controller = Get.put(
      Kids_signup_controller(),
      tag: Kids_signup_controller().toString());

  final Creator_signup_controller _creator_signup_controller = Get.put(
      Creator_signup_controller(),
      tag: Creator_signup_controller().toString());

  final List<String> data = <String>[
    'male',
    'female',
  ];
  List<Data_country> data2 = <Data_country>[];
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    // await _kids_signup_controller.getAllCountriesFromAPI();
    // await _creator_signup_controller.getAllCountriesFromAPI();
    getAllFollowersList();
  }

  bool _obscureText = true;
  bool _obscureText1 = true;

  String? _password;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _toggle1() {
    setState(() {
      _obscureText1 = !_obscureText1;
    });
  }

  final imgPicker = ImagePicker();

  void openCamera() async {
    var imgCamera = await imgPicker.pickImage(source: ImageSource.camera);
    setState(() {
      _kids_signup_controller.imgFile = File(imgCamera!.path);
      _kids_signup_controller.photoBase64 =
          base64Encode(_kids_signup_controller.imgFile!.readAsBytesSync());
      print(_kids_signup_controller.photoBase64);

      final bytes = Io.File(imgCamera.path).readAsBytesSync();
      _kids_signup_controller.img64 = base64Encode(bytes);
      print(_kids_signup_controller.img64!.substring(0, 100));
    });
    // Navigator.of(context).pop();
  }

  void openGallery() async {
    var imgGallery = await imgPicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _kids_signup_controller.imgFile = File(imgGallery!.path);
      _kids_signup_controller.photoBase64 =
          base64Encode(_kids_signup_controller.imgFile!.readAsBytesSync());
      print(_kids_signup_controller.photoBase64);

      final bytes = Io.File(imgGallery.path).readAsBytesSync();
      _kids_signup_controller.img64 = base64Encode(bytes);
      print(_kids_signup_controller.img64!.substring(0, 100));
    });
    Navigator.of(context).pop();
  }

  bool location_tap = false;

  // Uint8List bytes = BASE64.decode(_base64);
  // Image.memory(bytes),

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        // setState((){
        //   location_tap = false;
        // });
      },
      child: GetBuilder<Kids_signup_controller>(
        init: _kids_signup_controller,
        builder: (GetxController controller) {
          return Stack(
            children: [
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
                  //
                  //   colors: [
                  //     HexColor("#000000").withOpacity(0.67),
                  //     HexColor("#000000").withOpacity(0.67),
                  //     HexColor("#C12265").withOpacity(0.67),
                  //     HexColor("#FFFFFF").withOpacity(0.67),
                  //   ],
                  // ),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    // colorFilter: ColorFilter.mode(
                    //     Colors.black.withOpacity(0.2), BlendMode.dstATop),
                    image: AssetImage(
                      AssetUtils.backgroundImage5,
                    ),
                  ),
                ),
              ),
              Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: const Text(
                    'Kids Signup',
                    style: TextStyle(
                        fontSize: 16, fontFamily: 'PB', color: Colors.white),
                  ),
                  backgroundColor: Colors.transparent,
                ),
                backgroundColor: Colors.transparent,
                // <-- SCAFFOLD WITH TRANSPARENT BG
                body: SizedBox(
                  width: screenwidth,
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 1),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: SizedBox(
                              height: 80,
                              width: 80,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(500),
                                  child:
                                      (_kids_signup_controller.imgFile == null
                                          ? IconButton(
                                              icon: Image.asset(
                                                AssetUtils.user_icon,
                                                fit: BoxFit.fill,
                                              ),
                                              onPressed: () {
                                                openCamera();
                                                // showDialog(
                                                //   context: context,
                                                //   builder: (ctx) => AlertDialog(
                                                //     title: Text("Pick Image from"),
                                                //     actions: <Widget>[
                                                //       Container(
                                                //         margin: EdgeInsets.only(
                                                //             bottom: 10),
                                                //         child: common_button(
                                                //           onTap: () {
                                                //             openCamera();
                                                //             // Get.toNamed(BindingUtils.signupOption);
                                                //           },
                                                //           backgroud_color:
                                                //               Colors.black,
                                                //           lable_text: 'Camera',
                                                //           lable_text_color:
                                                //               Colors.white,
                                                //         ),
                                                //       ),
                                                //       common_button(
                                                //         onTap: () {
                                                //           openGallery();
                                                //           // Get.toNamed(BindingUtils.signupOption);
                                                //         },
                                                //         backgroud_color: Colors.black,
                                                //         lable_text: 'Gallery',
                                                //         lable_text_color:
                                                //             Colors.white,
                                                //       ),
                                                //     ],
                                                //   ),
                                                // );
                                              },
                                            )
                                          : Image.file(
                                              _kids_signup_controller.imgFile!,
                                              fit: BoxFit.fill,
                                            ))),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          //! Container(
                          //   child: _userNameTextField,
                          // ),
                          CommonTextFormField(
                            title: TxtUtils.UserName,
                            controller:
                                _kids_signup_controller.username_controller,
                            labelText: "Enter username",
                            image_path: AssetUtils.human_icon,
                            onChanged: (value) {
                              value = _kids_signup_controller
                                  .username_controller.text;
                              CheckUserName(context);
                              setState(() {});
                            },
                            // errorText: checkUserModel!.message,
                            tap: () {
                              CheckUserName(context);
                            },
                          ),
                          (username_error == false
                              ? Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 0),
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 1.0, horizontal: 5),
                                    child: Text(
                                      checkUserModel!.message!,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink()),
                          const SizedBox(
                            height: 12,
                          ),
                          CommonTextFormField(
                            title: TxtUtils.FullName,
                            controller:
                                _kids_signup_controller.fullname_controller,
                            labelText: "Enter Fullname",
                            image_path: AssetUtils.human_icon,
                          ),

                          CommonTextFormField(
                            controller:
                                _kids_signup_controller.email_controller,
                            title: 'Email',
                            labelText: 'Email',
                            image_path: AssetUtils.msg_icon,
                            validator: (val) {
                              if (val?.isEmpty ?? true) {
                                return 'Please enter email';
                              }
                              return null;
                            },
                            onChanged: (login) {},
                          ),
                          (email_error == false
                              ? Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 0),
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 1.0, horizontal: 5),
                                    child: Text(
                                      checkEmailModel!.message!,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink()),

                          CommonTextFormField(
                              validator: (val) {
                                if (val?.isEmpty ?? true) {
                                  return 'Please enter password';
                                }
                                return null;
                              },
                              title: TxtUtils.Password,
                              controller:
                                  _kids_signup_controller.password_controller,
                              labelText: 'Enter password',
                              isObscure: _obscureText,
                              maxLines: 1,
                              image_path: (_obscureText
                                  ? AssetUtils.eye_open_icon
                                  : AssetUtils.eye_close_icon),
                              onpasswordTap: () {
                                _toggle();
                              }),
                          const SizedBox(
                            height: 12,
                          ),
                          CommonTextFormField(
                              validator: (val) {
                                if (val?.isEmpty ?? true) {
                                  return 'Please enter password';
                                } else if (_kids_signup_controller
                                        .confirm_password_controller.text !=
                                    _kids_signup_controller
                                        .password_controller.text) {
                                  return "Password doesn't match";
                                }
                                return null;
                              },
                              title: TxtUtils.Password,
                              controller: _kids_signup_controller
                                  .confirm_password_controller,
                              labelText: "Confirm password",
                              isObscure: _obscureText1,
                              maxLines: 1,
                              image_path: (_obscureText1
                                  ? AssetUtils.eye_open_icon
                                  : AssetUtils.eye_close_icon),
                              onpasswordTap: () {
                                _toggle1();
                              }),
                          const SizedBox(
                            height: 12,
                          ),
                          Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(left: 18),
                                        child: const Text(
                                          'Location',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'PR',
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 11,
                                      ),
                                      TextFormField(
                                        validator: (val) {
                                          if (val?.isEmpty ?? true) {
                                            return 'Please enter location';
                                          }
                                          return null;
                                        },
                                        onTap: () {
                                          setState(() {
                                            location_tap = true;
                                          });
                                        },
                                        onChanged: (value) {
                                          getAllFollowersList();
                                        },
                                        decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.only(
                                              left: 20, top: 14, bottom: 14),
                                          alignLabelWithHint: false,
                                          isDense: true,
                                          hintText: 'Enter Location',
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.transparent,
                                                width: 1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30)),
                                          ),
                                          focusedBorder:
                                              const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.transparent,
                                                width: 1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30)),
                                          ),
                                          enabledBorder:
                                              const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.transparent,
                                                width: 1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30)),
                                          ),
                                          hintStyle: const TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'PR',
                                            color: Colors.grey,
                                          ),
                                          suffixIcon: Container(
                                            child: IconButton(
                                              icon: Image.asset(
                                                AssetUtils.downArrow_icon,
                                                color: Colors.black,
                                                height: 10,
                                                width: 10,
                                              ),
                                              onPressed: () {},
                                            ),
                                          ),
                                        ),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'PR',
                                          color: Colors.black,
                                        ),
                                        controller: _creator_signup_controller
                                            .query_followers,
                                        keyboardType: TextInputType.text,
                                      ),
                                    ],
                                  ),
                                ),
                                (location_tap
                                    ? Container(
                                        height: 100,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 30),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(24),
                                          border: Border.all(
                                              width: 1, color: Colors.white),
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            // stops: [0.1, 0.5, 0.7, 0.9],
                                            colors: [
                                              HexColor("#000000"),
                                              HexColor("#C12265"),
                                              HexColor("#C12265"),
                                              HexColor("#FFFFFF"),
                                            ],
                                          ),
                                        ),
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: _creator_signup_controller
                                              .data_country.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return GestureDetector(
                                              onTap: () {
                                                _kids_signup_controller
                                                        .selected_country =
                                                    _creator_signup_controller
                                                        .data_country[index]
                                                        .name!;
                                                _kids_signup_controller
                                                        .selected_country_code =
                                                    _creator_signup_controller
                                                        .data_country[index]
                                                        .dialCode!;

                                                _creator_signup_controller
                                                        .query_followers.text =
                                                    _creator_signup_controller
                                                        .data_country[index]
                                                        .name!;

                                                print(_kids_signup_controller
                                                    .selected_country_code);

                                                setState(() {
                                                  location_tap = false;
                                                });
                                              },
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8),
                                                child: Text(
                                                  '${_creator_signup_controller.data_country[index].name}',
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: 'PR',
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    : const SizedBox.shrink()),
                              ],
                            ),
                          ),

                          const SizedBox(
                            height: 12,
                          ),
                          Container(
                            // margin: EdgeInsets.only(left: 45,right: 45.93),
                            margin: const EdgeInsets.symmetric(horizontal: 30),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(left: 18),
                                  child: const Text(
                                    TxtUtils.phone,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'PR',
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 11,
                                ),
                                TextFormField(
                                  validator: (val) {
                                    if (val?.isEmpty ?? true) {
                                      return 'Please enter phone number';
                                    }
                                    return null;
                                  },
                                  maxLength: 10,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(
                                        left: 20, top: 14, bottom: 14),
                                    alignLabelWithHint: false,
                                    isDense: true,
                                    hintText: "Enter phone no",
                                    filled: true,
                                    fillColor: Colors.white,
                                    counter: const Text(''),
                                    border: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.transparent, width: 1),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.transparent, width: 1),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.transparent, width: 1),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                    ),
                                    hintStyle: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'PR',
                                      color: Colors.grey,
                                    ),
                                    suffixIcon: Container(
                                      child: IconButton(
                                        icon: Image.asset(
                                          AssetUtils.phone_icon,
                                          color: Colors.black,
                                          height: 20,
                                          width: 20,
                                        ),
                                        onPressed: () {},
                                      ),
                                    ),
                                    prefixText: _kids_signup_controller
                                        .selected_country_code,
                                    prefixStyle: const TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'PR',
                                      color: Colors.black,
                                    ),
                                  ),
                                  onChanged: (value) {
                                    value = _kids_signup_controller
                                        .phone_controller.text;

                                    setState(() {});
                                  },
                                  onTap: () {
                                    CheckPhoneName(context);
                                  },
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'PR',
                                    color: Colors.black,
                                  ),
                                  controller:
                                      _kids_signup_controller.phone_controller,
                                  keyboardType: TextInputType.number,
                                ),
                              ],
                            ),
                          ),
                          (phone_error == false
                              ? Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 0),
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 1.0, horizontal: 5),
                                    child: Text(
                                      checkPhoneModel!.message!,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink()),
                          const SizedBox(
                            height: 12,
                          ),
                          CommonTextFormField_text(
                            validator: (val) {
                              if (val?.isEmpty ?? true) {
                                return 'Please enter about yourself';
                              }
                              return null;
                            },
                            maxLines: 4,
                            title: TxtUtils.AboutMe,
                            controller:
                                _kids_signup_controller.aboutMe_controller,
                            labelText: "Enter about YourSelf(150 char)",
                            image_path: AssetUtils.human_icon,
                          ),
                          const SizedBox(
                            height: 21,
                          ),

                          GestureDetector(
                              onTap: () async {
                                print('inside login');

                                final bool isValid =
                                    _formKey.currentState!.validate();
                                if (!isValid) {
                                  return;
                                } else {
                                  if (_kids_signup_controller.imgFile == null) {
                                    CommonWidget().showErrorToaster(
                                        msg: "Please take a selfie");
                                    return;
                                  }
                                  await _kids_signup_controller.KidsSendOtp(
                                      context);
                                }
                              },
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                // height: 45,
                                // width:(width ?? 300) ,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(25)),
                                child: Container(
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  child: const Text(
                                    'Next',
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.white),
                                  ),
                                ),
                              )),

                          const SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  CheckUserModel? checkUserModel;
  CheckUserModel? checkEmailModel;
  CheckUserModel? checkPhoneModel;
  bool username_error = true;
  bool email_error = true;
  bool phone_error = true;

  Future<dynamic> CheckUserName(BuildContext context) async {
    debugPrint('0-0-0-0-0-0-0 username');
    Map data = {
      'userName': _kids_signup_controller.username_controller.text,
      'type': TxtUtils.Login_type_kids,
    };
    print(data);
    // String body = json.encode(data);

    var url = (URLConstants.base_url + URLConstants.check_user_Api);
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
      checkUserModel = CheckUserModel.fromJson(data);
      print(checkUserModel);
      setState(() {
        username_error = checkUserModel!.error!;
      });
      if (checkUserModel!.error == false) {
        setState(() {});
        // Get.to(CreatorOtpVerification());
        // Get.to(OtpScreen(received_otp: otpModel!.user![0].body!,));
      } else {
        print('Please try again');
      }
    } else {
      print('Please try again');
    }
  }

  Future<dynamic> CheckEmailName(BuildContext context) async {
    debugPrint('0-0-0-0-0-0-0 username');
    Map data = {
      'email': _kids_signup_controller.email_controller.text,
      'type': TxtUtils.Login_type_kids,
    };
    print(data);
    // String body = json.encode(data);

    var url = (URLConstants.base_url + URLConstants.check_user_Api);
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
      checkEmailModel = CheckUserModel.fromJson(data);
      print(checkEmailModel);
      setState(() {
        email_error = checkEmailModel!.error!;
      });
      if (checkEmailModel!.error == false) {
        setState(() {});
        // Get.to(CreatorOtpVerification());
        // Get.to(OtpScreen(received_otp: otpModel!.user![0].body!,));
      } else {
        print('Please try again');
      }
    } else {
      print('Please try again');
    }
  }

  Future<dynamic> CheckPhoneName(BuildContext context) async {
    debugPrint('0-0-0-0-0-0-0 username');
    Map data = {
      'phone': _kids_signup_controller.phone_controller.text,
      'type': TxtUtils.Login_type_kids,
    };
    print(data);
    // String body = json.encode(data);

    var url = (URLConstants.base_url + URLConstants.check_user_Api);
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
      checkPhoneModel = CheckUserModel.fromJson(data);
      print(checkPhoneModel);
      setState(() {
        phone_error = checkPhoneModel!.error!;
      });
      if (checkPhoneModel!.error == false) {
        setState(() {});
        // Get.to(CreatorOtpVerification());
        // Get.to(OtpScreen(received_otp: otpModel!.user![0].body!,));
      } else {
        print('Please try again');
      }
    } else {
      print('Please try again');
    }
  }

  Future<dynamic> getAllFollowersList() async {
    final books = await _creator_signup_controller.getAllCountriesFromAPI(
        _creator_signup_controller.query_followers.text);

    setState(() => _creator_signup_controller.data_country = books);
    print(
        '_creator_signup_controller.data_country.length ${_creator_signup_controller.data_country.length}');
  }
}
