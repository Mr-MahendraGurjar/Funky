import 'dart:convert';
import 'dart:io' as Io;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../Utils/App_utils.dart';
import '../../../Utils/asset_utils.dart';
import '../../../Utils/custom_textfeild.dart';
import '../../../Utils/toaster_widget.dart';
import '../../../custom_widget/common_buttons.dart';
import '../../creator_login/model/creator_loginModel.dart';
import '../controller/creator_signup_controller.dart';
import '../model/countryModelclass.dart';

class Creator_signup extends StatefulWidget {
  const Creator_signup({super.key});

  @override
  State<Creator_signup> createState() => _Creator_signupState();
}

class _Creator_signupState extends State<Creator_signup> {
  final Creator_signup_controller _creator_signup_controller = Get.put(
      Creator_signup_controller(),
      tag: Creator_signup_controller().toString());
  final List<String> data = <String>[
    'Male',
    'Female',
  ];
  List<Data_country> data2 = <Data_country>[];
  final TextEditingController textEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  var reg2 = RegExp(r'^[a-zA-Z0-9]*$');

  @override
  void initState() {
    init();
    super.initState();
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

  init() async {
    getAllFollowersList();
  }

  bool location_tap = false;
  bool gender_tap = false;
  final imgPicker = ImagePicker();

  void openCamera() async {
    var imgCamera = await imgPicker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
    );
    setState(() {
      _creator_signup_controller.imgFile = File(imgCamera!.path);
      _creator_signup_controller.photoBase64 =
          base64Encode(_creator_signup_controller.imgFile!.readAsBytesSync());
      print("imgFile! ${_creator_signup_controller.imgFile}");

      final bytes = Io.File(imgCamera.path).readAsBytesSync();
      _creator_signup_controller.img64 = base64Encode(bytes);
      print(_creator_signup_controller.img64!.substring(0, 100));
    });
    Navigator.of(context).pop();
  }

  void openGallery() async {
    var imgGallery = await imgPicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _creator_signup_controller.imgFile = File(imgGallery!.path);
      _creator_signup_controller.photoBase64 =
          base64Encode(_creator_signup_controller.imgFile!.readAsBytesSync());
      print(_creator_signup_controller.photoBase64);

      final bytes = Io.File(imgGallery.path).readAsBytesSync();
      _creator_signup_controller.img64 = base64Encode(bytes);
      print(_creator_signup_controller.img64!.substring(0, 100));
    });
    Navigator.of(context).pop();
  }

  bool valuefirst = false;

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: GetBuilder<Creator_signup_controller>(
        init: _creator_signup_controller,
        builder: (GetxController controller) {
          return Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
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
                    'Creator Signup',
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
                    physics: const ClampingScrollPhysics(),
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
                                  child: (_creator_signup_controller.imgFile ==
                                          null
                                      ? IconButton(
                                          icon: Image.asset(
                                            AssetUtils.user_icon,
                                            fit: BoxFit.fill,
                                          ),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (ctx) => AlertDialog(
                                                title: const Text(
                                                    "Pick Image from"),
                                                actions: <Widget>[
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            bottom: 10),
                                                    child: common_button(
                                                      onTap: () {
                                                        openCamera();
                                                      },
                                                      backgroud_color:
                                                          Colors.black,
                                                      lable_text: 'Camera',
                                                      lable_text_color:
                                                          Colors.white,
                                                    ),
                                                  ),
                                                  common_button(
                                                    onTap: () {
                                                      openGallery();
                                                    },
                                                    backgroud_color:
                                                        Colors.black,
                                                    lable_text: 'Gallery',
                                                    lable_text_color:
                                                        Colors.white,
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (ctx) => AlertDialog(
                                                title: const Text(
                                                    "Pick Image from"),
                                                actions: <Widget>[
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            bottom: 10),
                                                    child: common_button(
                                                      onTap: () {
                                                        openCamera();
                                                      },
                                                      backgroud_color:
                                                          Colors.black,
                                                      lable_text: 'Camera',
                                                      lable_text_color:
                                                          Colors.white,
                                                    ),
                                                  ),
                                                  common_button(
                                                    onTap: () {
                                                      openGallery();
                                                    },
                                                    backgroud_color:
                                                        Colors.black,
                                                    lable_text: 'Gallery',
                                                    lable_text_color:
                                                        Colors.white,
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          child: Image.file(
                                            _creator_signup_controller.imgFile!,
                                            fit: BoxFit.cover,
                                          ),
                                        ))),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          CommonTextFormField(
                            height: 45,
                            title: TxtUtils.FullName,
                            controller:
                                _creator_signup_controller.fullname_controller,
                            labelText: "Enter full name",
                            image_path: AssetUtils.human_icon,
                            validator: (val) {
                              if (val?.isEmpty ?? true) {
                                return 'Please enter name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          CommonTextFormField(
                            controller:
                                _creator_signup_controller.username_controller,
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
                            controller:
                                _creator_signup_controller.email_controller,
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
                                                Radius.circular(20)),
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
                                                _creator_signup_controller
                                                        .selected_country =
                                                    _creator_signup_controller
                                                        .data_country[index]
                                                        .name!;
                                                _creator_signup_controller
                                                        .selected_country_code =
                                                    _creator_signup_controller
                                                        .data_country[index]
                                                        .dialCode!;
                                                print(_creator_signup_controller
                                                    .selected_country);
                                                print(_creator_signup_controller
                                                    .selected_country_code);

                                                _creator_signup_controller
                                                        .query_followers.text =
                                                    _creator_signup_controller
                                                        .data_country[index]
                                                        .name!;

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
                                  maxLength: 10,
                                  decoration: InputDecoration(
                                    counter: const Text(''),
                                    contentPadding: const EdgeInsets.only(
                                        left: 14, top: 14, bottom: 14),
                                    alignLabelWithHint: false,
                                    isDense: true,
                                    hintText: "Enter phone no",
                                    filled: true,
                                    fillColor: Colors.white,
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
                                    prefixText: _creator_signup_controller
                                        .selected_country_code,
                                    prefixStyle: const TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'PR',
                                      color: Colors.black,
                                    ),
                                  ),
                                  onChanged: (value) {
                                    value = _creator_signup_controller
                                        .phone_controller.text;

                                    setState(() {});
                                  },
                                  validator: (val) {
                                    if (val?.isEmpty ?? true) {
                                      return 'Please enter phone number';
                                    }
                                    return null;
                                  },
                                  onTap: () {
                                    CheckPhoneName(context);
                                  },
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'PR',
                                    color: Colors.black,
                                  ),
                                  controller: _creator_signup_controller
                                      .phone_controller,
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
                          CommonTextFormField(
                              height: 45,
                              title: TxtUtils.Password,
                              controller: _creator_signup_controller
                                  .password_controller,
                              labelText: 'Enter password',
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
                            height: 12,
                          ),
                          CommonTextFormField(
                              validator: (val) {
                                if (val?.isEmpty ?? true) {
                                  return 'Please enter password';
                                } else if (_creator_signup_controller
                                        .confirm_password_controller.text !=
                                    _creator_signup_controller
                                        .password_controller.text) {
                                  return "Password doesn't match";
                                }
                                return null;
                              },
                              title: TxtUtils.Password,
                              controller: _creator_signup_controller
                                  .confirm_password_controller,
                              labelText: "Confirm password",
                              isObscure: _obscureText1,
                              maxLines: 1,
                              image_path: (_obscureText1
                                  ? AssetUtils.eye_open_icon
                                  : AssetUtils.eye_close_icon),
                              onpasswordTap: () {
                                setState(() {
                                  _obscureText1 = !_obscureText1; //_toggle();
                                });
                              }),
                          const SizedBox(
                            height: 12,
                          ),
                          CommonTextFormField(
                            height: 45,
                            title: "Gender",
                            controller:
                                _creator_signup_controller.gender_controller,
                            labelText: 'Select Gender',
                            image_path: AssetUtils.user_icon2,
                            validator: (val) {
                              if (val?.isEmpty ?? true) {
                                return 'Please select gender';
                              }
                              return null;
                            },
                            tap: () {
                              setState(() {
                                gender_tap = true;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          (gender_tap
                              ? Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
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
                                    itemCount: data.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            gender_tap = false;
                                            _creator_signup_controller
                                                .gender_controller
                                                .text = data[index];
                                          });
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 8),
                                          child: Text(
                                            data[index],
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
                          const SizedBox(
                            height: 12,
                          ),
                          CommonTextFormField(
                            height: 45,
                            title: TxtUtils.ReffrelCode,
                            controller: _creator_signup_controller
                                .reffralCode_controller,
                            labelText: "Enter Referral code",
                            image_path: AssetUtils.human_icon,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          CommonTextFormField_text(
                            maxLines: 4,
                            title: TxtUtils.AboutMe,
                            controller:
                                _creator_signup_controller.aboutMe_controller,
                            labelText: "Enter about YourSelf(150 char)",
                            image_path: AssetUtils.human_icon,
                            validator: (val) {
                              if (val?.isEmpty ?? true) {
                                return 'Please enter about yourself';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Theme(
                                data: ThemeData(
                                    unselectedWidgetColor: Colors.white),
                                child: Checkbox(
                                  checkColor: Colors.black,
                                  activeColor: Colors.white,
                                  value: valuefirst,
                                  onChanged: (value) {
                                    setState(() {
                                      valuefirst = value!;
                                    });
                                  },
                                ),
                              ),
                              Container(
                                child: const Text(
                                  'I agree Terms & Conditions',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'PR',
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                              onTap: () async {
                                print(' inside login');
                                final bool isValid =
                                    _formKey.currentState!.validate();
                                if (!isValid) {
                                  return;
                                } else {
                                  if (valuefirst) {
                                    if (!reg2.hasMatch(
                                        _creator_signup_controller
                                            .username_controller.text)) {
                                      CommonWidget().showErrorToaster(
                                          msg:
                                              "No spaces are allowed in username");
                                      return;
                                    }
                                    if (_creator_signup_controller.imgFile ==
                                        null) {
                                      CommonWidget().showErrorToaster(
                                          msg: "Please take a selfie");
                                      return;
                                    }
                                    await checkLogin();
                                  } else {
                                    CommonWidget().showErrorToaster(
                                        msg: "Please agree Terms & Conditions");
                                  }
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

  Future checkLogin() async {
    await _creator_signup_controller.CreatorsendOtp(context);
  }

  Future<dynamic> getAllFollowersList() async {
    final books = await _creator_signup_controller.getAllCountriesFromAPI(
        _creator_signup_controller.query_followers.text);

    setState(() => _creator_signup_controller.data_country = books);
    print(
        '_creator_signup_controller.data_country.length ${_creator_signup_controller.data_country.length}');
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
      'userName': _creator_signup_controller.username_controller.text,
      'type': TxtUtils.Login_type_creator,
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
      'email': _creator_signup_controller.email_controller.text,
      'type': TxtUtils.Login_type_creator,
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
      'phone': _creator_signup_controller.phone_controller.text,
      'type': TxtUtils.Login_type_creator,
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
}

class MenuItem {
  final String text;

  const MenuItem({
    required this.text,
  });
}
