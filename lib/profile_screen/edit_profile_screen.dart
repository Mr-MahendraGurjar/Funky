import 'dart:convert';
import 'dart:io' as Io;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:funky_new/Utils/colorUtils.dart';
// import 'package:funky_project/Authentication/creator_signup/model/countryModelclass.dart';
// import 'package:funky_project/controller/controllers_class.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';

import '../../../Utils/App_utils.dart';
import '../../../Utils/asset_utils.dart';
import '../../../Utils/custom_textfeild.dart';
import '../../../custom_widget/common_buttons.dart';
import '../Authentication/creator_login/controller/creator_login_controller.dart';
import '../Authentication/creator_signup/controller/creator_signup_controller.dart';
import '../Authentication/creator_signup/model/CountryModel.dart';
import '../Authentication/creator_signup/model/countryModelclass.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final Creator_signup_controller _creator_signup_controller = Get.put(
      Creator_signup_controller(),
      tag: Creator_signup_controller().toString());
  final Creator_Login_screen_controller _creator_login_screen_controller =
      Get.put(Creator_Login_screen_controller(),
          tag: Creator_Login_screen_controller().toString());

  final List<String> data = <String>[
    'male',
    'Female',
  ];
  List<Data_country> data2 = <Data_country>[];
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    await _creator_signup_controller.getcountry();
    await user_info_setup();
  }

  user_info_setup() {
    setState(() {
      _creator_signup_controller.fullname_controller.text =
          _creator_login_screen_controller
              .userInfoModel_email.value.data![0].fullName
              .toString();
      _creator_signup_controller.username_controller.text =
          _creator_login_screen_controller
              .userInfoModel_email.value.data![0].userName
              .toString();
      _creator_signup_controller.email_controller.text =
          _creator_login_screen_controller
              .userInfoModel_email.value.data![0].email
              .toString();
      _creator_signup_controller.phone_controller.text =
          _creator_login_screen_controller
              .userInfoModel_email.value.data![0].phone
              .toString();
      _creator_signup_controller.reffralCode_controller.text =
          _creator_login_screen_controller
              .userInfoModel_email.value.data![0].referralCode
              .toString();
      _creator_signup_controller.aboutMe_controller.text =
          _creator_login_screen_controller
              .userInfoModel_email.value.data![0].about
              .toString();

      // _creator_login_screen_controller
      //     .userInfoModel_email.value.value.data![0].image = imgFile as String?;
      print(
          "imgFile ${_creator_login_screen_controller.userInfoModel_email.value.data![0].location}");

      CountryList getCountry = _creator_signup_controller.data_country
          .firstWhere((element) =>
              _creator_login_screen_controller
                  .userInfoModel_email.value.data![0].location ==
              element.name);
      _creator_signup_controller.query_followers.text = getCountry.name!;

      // _creator_signup_controller.query_followers.text = unit_new.name!;

      if (_creator_login_screen_controller
          .userInfoModel_email.value.data![0].gender!.isNotEmpty) {
        String getGender = data.firstWhere((element) =>
            element ==
            _creator_login_screen_controller
                .userInfoModel_email.value.data![0].gender);
        _creator_signup_controller.gender_controller.text = getGender;
      }
    });
  }

  File? imgFile;
  final imgPicker = ImagePicker();

  void openCamera() async {
    var imgCamera = await imgPicker.pickImage(source: ImageSource.camera);
    setState(() {
      imgFile = File(imgCamera!.path);
      _creator_signup_controller.photoBase64 =
          base64Encode(imgFile!.readAsBytesSync());
      print(_creator_signup_controller.photoBase64);
      _creator_signup_controller.imgFile = imgFile;
      final bytes = Io.File(imgCamera.path).readAsBytesSync();
      _creator_signup_controller.img64 = base64Encode(bytes);
      print(_creator_signup_controller.img64!.substring(0, 100));
    });
    Navigator.of(context).pop();
  }

  void openGallery() async {
    var imgGallery = await imgPicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imgFile = File(imgGallery!.path);
      _creator_signup_controller.imgFile = imgFile;
      _creator_signup_controller.photoBase64 =
          base64Encode(imgFile!.readAsBytesSync());
      print(_creator_signup_controller.photoBase64);

      final bytes = Io.File(imgGallery.path).readAsBytesSync();
      _creator_signup_controller.img64 = base64Encode(bytes);
      print(_creator_signup_controller.img64!.substring(0, 100));
    });
    Navigator.of(context).pop();
  }

  // Uint8List bytes = BASE64.decode(_base64);
  // Image.memory(bytes),
  bool valuefirst = false;
  bool location_tap = false;
  bool gender_tap = false;

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
                // decoration: BoxDecoration(
                //
                //   image: DecorationImage(
                //     image: AssetImage(AssetUtils.backgroundImage), // <-- BACKGROUND IMAGE
                //     fit: BoxFit.cover,
                //   ),
                // ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    // stops: [0.1, 0.5, 0.7, 0.9],

                    colors: [
                      HexColor("#000000").withOpacity(0.67),
                      HexColor("#000000").withOpacity(0.67),
                      HexColor("#C12265").withOpacity(0.67),
                      HexColor("#FFFFFF").withOpacity(0.67),
                    ],
                  ),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.2), BlendMode.dstATop),
                    image: const AssetImage(
                      AssetUtils.backgroundImage2,
                    ),
                  ),
                ),
              ),
              Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: const Text(
                    'Creator Edit Profile',
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
                          Stack(
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(500),
                                  child: (_creator_login_screen_controller
                                          .userInfoModel_email
                                          .value
                                          .data![0]
                                          .image!
                                          .isEmpty
                                      ? Image.asset(
                                          AssetUtils.user_icon,
                                          fit: BoxFit.fill,
                                          height: 80,
                                          width: 80,
                                        )
                                      : (imgFile == null
                                          ? Image.network(
                                              "${URLConstants.base_data_url}images/${_creator_login_screen_controller.userInfoModel_email.value.data![0].image!}",
                                              height: 80,
                                              width: 80,
                                              fit: BoxFit.fill,
                                            )
                                          : Image.file(
                                              imgFile!,
                                              height: 80,
                                              width: 80,
                                              fit: BoxFit.cover,
                                            )))),
                              Positioned(
                                bottom: 2,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text("Pick Image from"),
                                        actions: <Widget>[
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 10),
                                            child: common_button(
                                              onTap: () {
                                                openCamera();
                                                // Get.toNamed(BindingUtils.signupOption);
                                              },
                                              backgroud_color: Colors.black,
                                              lable_text: 'Camera',
                                              lable_text_color: Colors.white,
                                            ),
                                          ),
                                          common_button(
                                            onTap: () {
                                              openGallery();
                                              // Get.toNamed(BindingUtils.signupOption);
                                            },
                                            backgroud_color: Colors.black,
                                            lable_text: 'Gallery',
                                            lable_text_color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(50),
                                      gradient: LinearGradient(
                                        colors: [
                                          HexColor('#36393E'),
                                          HexColor('#020204'),
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: HexColor(CommonColor.pinkFont),
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          CommonTextFormField(
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Please enter name';
                              }
                              return null;
                            },
                            height: 45,
                            title: TxtUtils.FullName,
                            controller:
                                _creator_signup_controller.fullname_controller,
                            labelText: "Enter full name",
                            image_path: AssetUtils.human_icon,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          CommonTextFormField(
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Please enter username';
                              }
                              return null;
                            },
                            height: 45,
                            title: TxtUtils.UserName,
                            controller:
                                _creator_signup_controller.username_controller,
                            labelText: "Enter username",
                            image_path: AssetUtils.human_icon,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          CommonTextFormField(
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Please enter email';
                              }
                              return null;
                            },
                            height: 45,
                            title: TxtUtils.Email,
                            controller:
                                _creator_signup_controller.email_controller,
                            labelText: "Enter Email",
                            image_path: AssetUtils.msg_icon,
                          ),
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
                                  // margin: EdgeInsets.only(left: 45,right: 45.93),
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
                                      Container(
                                        child: TextFormField(
                                          validator: (value) {
                                            if (value?.isEmpty ?? true) {
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
                                            contentPadding:
                                                const EdgeInsets.only(
                                                    left: 20,
                                                    top: 14,
                                                    bottom: 14),
                                            alignLabelWithHint: false,
                                            isDense: true,
                                            hintText: 'Enter Location',
                                            filled: true,
                                            enabledBorder:
                                                const OutlineInputBorder(
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
                                            border: const OutlineInputBorder(
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
                          CommonTextFormField(
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Please enter phone number';
                              }
                              return null;
                            },
                            height: 45,
                            title: TxtUtils.phone,
                            controller:
                                _creator_signup_controller.phone_controller,
                            labelText: "Enter phone no",
                            image_path: AssetUtils.phone_icon,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          CommonTextFormField(
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Please enter gender';
                              }
                              return null;
                            },
                            height: 45,
                            title: "Gender",
                            controller:
                                _creator_signup_controller.gender_controller,
                            labelText: 'Select Gender',
                            image_path: AssetUtils.user_icon2,
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
                          CommonTextFormField_text(
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Please enter about yourself';
                              }
                              return null;
                            },
                            maxLines: 4,
                            title: TxtUtils.AboutMe,
                            controller:
                                _creator_signup_controller.aboutMe_controller,
                            labelText: "Enter about YourSelf(150 char)",
                            image_path: AssetUtils.human_icon,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          common_button(
                            onTap: () async {
                              if (!_formKey.currentState!.validate()) {
                                return;
                              } else {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) => const Center(
                                          child: CircularProgressIndicator(),
                                        ));

                                await _creator_signup_controller
                                    .Update_user_profile(
                                        context: context,
                                        usertype:
                                            _creator_login_screen_controller
                                                .userInfoModel_email
                                                .value
                                                .data![0]
                                                .type!,
                                        socialtype:
                                            _creator_login_screen_controller
                                                .userInfoModel_email
                                                .value
                                                .data![0]
                                                .socialType!);
                              }
                            },
                            backgroud_color: Colors.black,
                            lable_text: 'Done',
                            lable_text_color: Colors.white,
                          ),
                          const SizedBox(
                            height: 20,
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

  Future<dynamic> getAllFollowersList() async {
    final books = await _creator_signup_controller.getAllCountriesFromAPI(
        _creator_signup_controller.query_followers.text);

    setState(() => _creator_signup_controller.data_country = books);
    print(
        '_creator_signup_controller.data_country.length ${_creator_signup_controller.data_country.length}');
  }
}
