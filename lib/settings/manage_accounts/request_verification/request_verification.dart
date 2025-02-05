import 'dart:convert';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:funky_new/settings/manage_accounts/request_verification/picker-image.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

import '../../../../Utils/colorUtils.dart';
import '../../../Authentication/creator_login/controller/creator_login_controller.dart';
import '../../../Authentication/creator_signup/controller/creator_signup_controller.dart';
import '../../../Authentication/creator_signup/model/CountryModel.dart';
import '../../../Utils/App_utils.dart';
import '../../../Utils/toaster_widget.dart';
import '../../../sharePreference.dart';
import 'model.dart';

class RequestVerification extends StatefulWidget {
  const RequestVerification({super.key});

  @override
  State<RequestVerification> createState() => _RequestVerificationState();
}

class _RequestVerificationState extends State<RequestVerification> {
  bool isSwitched = false;
  List<String> documents = [
    'Driver\'s licence',
    'Passport',
    'National identification card',
    'Tax filling',
    'Recent utility bill',
    'Articles of incorporation'
  ];

  List<String> category = [
    'News/media',
    'Sports',
    'Government and politics',
    'Music',
    'Fashion',
    'Entertainment',
    'Digital creator/influencer/blogger',
    'Gamer',
    'Global bussiness/brand/organization',
    'Other',
  ];
  List<String> type_link = [
    'Social media',
    'News Article',
    'Other',
  ];

  // List<Human> type_list = <Human>[];

  String? _selectedsocumenttype;
  String? _selectedcategory;
  CountryList? _selectedcountry;
  String country = '';
  String docs = '';
  String category_selected = '';

  String? type1;
  String? type2;
  String? type3;

  @override
  void initState() {
    init();
    // TODO: implement initState
    super.initState();
  }

  final Creator_Login_screen_controller _creator_login_screen_controller =
      Get.put(Creator_Login_screen_controller(),
          tag: Creator_Login_screen_controller().toString());

  TextEditingController UsernameController = TextEditingController();
  TextEditingController FullnameController = TextEditingController();
  TextEditingController audienController = TextEditingController();
  TextEditingController konwnAsController = TextEditingController();
  TextEditingController url1Controller = TextEditingController();
  TextEditingController url2Controller = TextEditingController();
  TextEditingController url3Controller = TextEditingController();

  final Creator_signup_controller _creator_signup_controller = Get.put(
      Creator_signup_controller(),
      tag: Creator_signup_controller().toString());

  init() async {
    String socialTypeUser =
        await PreferenceManager().getPref(URLConstants.social_type);
    String idUser = await PreferenceManager().getPref(URLConstants.id);
    await _creator_signup_controller.getcountry();

    (socialTypeUser == ""
        ? await _creator_login_screen_controller.CreatorgetUserInfo_Email(
            context: context, UserId: idUser)
        : await _creator_login_screen_controller.getUserInfo_social());
    if (_creator_login_screen_controller.userInfoModel_email.value.error ==
        false) {
      setState(() {
        UsernameController.text = _creator_login_screen_controller
            .userInfoModel_email.value.data![0].userName!;
        FullnameController.text = _creator_login_screen_controller
            .userInfoModel_email.value.data![0].fullName!;
      });
    }
  }

  File? selected_file;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text(
            'Request Verification',
            style:
                TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'PB'),
          ),
          centerTitle: true,
          leadingWidth: 100,
          leading: Padding(
            padding: const EdgeInsets.only(
              right: 20.0,
              top: 0.0,
              bottom: 5.0,
            ),
            child: ClipRRect(
                child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
            )),
          ),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Container(
                  child: Text(
                    'Apply for Funky Verirification',
                    style: TextStyle(
                        fontSize: 18,
                        color: HexColor(CommonColor.pinkFont),
                        fontFamily: 'PB'),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  child: Text(
                    'Verified accounts have blue checkmarks next to their names to show that Instagram has confirmed they\'re the real presence of the public figures, celebrities, and brands they represent.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontSize: 16,
                        color: HexColor(CommonColor.grey_dark),
                        fontFamily: 'PR'),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  child: const Text(
                    'Step 1: Confirm authenticity',
                    style: TextStyle(
                        fontSize: 18, color: Colors.white, fontFamily: 'PB'),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  child: Text(
                    'Add an official identification document for yourself or your business.',
                    // textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontSize: 16,
                        color: HexColor(CommonColor.grey_dark),
                        fontFamily: 'PR'),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  autofocus: false,
                  textAlign: TextAlign.start,
                  textInputAction: TextInputAction.done,
                  controller: UsernameController,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'PR',
                      fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    labelText: 'Username',
                    hintStyle: TextStyle(
                        color: HexColor(CommonColor.pinkFont),
                        fontSize: 16,
                        fontFamily: 'PR',
                        fontWeight: FontWeight.w500),
                    labelStyle: TextStyle(
                        color: HexColor(CommonColor.pinkFont),
                        fontSize: 16,
                        fontFamily: 'PR',
                        fontWeight: FontWeight.w500),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: HexColor(CommonColor.pinkFont), width: 0.5),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: HexColor(CommonColor.pinkFont), width: 0.5),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  autofocus: false,
                  textAlign: TextAlign.start,
                  textInputAction: TextInputAction.done,
                  controller: FullnameController,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'PR',
                      fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    labelText: 'Full name',
                    hintStyle: TextStyle(
                        color: HexColor(CommonColor.pinkFont),
                        fontSize: 16,
                        fontFamily: 'PR',
                        fontWeight: FontWeight.w500),
                    labelStyle: TextStyle(
                        color: HexColor(CommonColor.pinkFont),
                        fontSize: 16,
                        fontFamily: 'PR',
                        fontWeight: FontWeight.w500),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: HexColor(CommonColor.pinkFont), width: 0.5),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: HexColor(CommonColor.pinkFont), width: 0.5),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1, color: Colors.transparent),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      // stops: [0.1, 0.5, 0.7, 0.9],
                      colors: [
                        HexColor("#000000"),
                        HexColor("#C12265"),
                        // HexColor("#FFFFFF"),
                      ],
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          isExpanded: true,
                          hint: Row(
                            children: [
                              const SizedBox(
                                width: 4,
                              ),
                              Expanded(
                                child: Text(
                                  'Document type',
                                  style: TextStyle(
                                      color: HexColor(CommonColor.pinkFont),
                                      fontSize: 16,
                                      fontFamily: 'PR',
                                      fontWeight: FontWeight.w500),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          items: documents
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'PR',
                                          fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
                              .toList(),
                          value: _selectedsocumenttype,
                          onChanged: (value) {
                            setState(() {
                              _selectedsocumenttype = value as String;
                              docs = _selectedsocumenttype!;
                            });
                          },
                          iconStyleData: const IconStyleData(
                            iconSize: 25,
                            iconEnabledColor: Color(0xff007DEF),
                            iconDisabledColor: Color(0xff007DEF),
                          ),
                          buttonStyleData: ButtonStyleData(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.transparent
                            ),
                            height: 50,
                            width: 100,
                            elevation: 0,
                            padding: const EdgeInsets.only(left: 14, right: 14),
                          ),
                          enableFeedback: true,
                          dropdownStyleData: DropdownStyleData(
                            padding: EdgeInsets.zero,
                            width: 150,
                            maxHeight: 200,
                            elevation: 8,
                            scrollbarTheme: const ScrollbarThemeData(
                              radius: Radius.circular(40),
                              thickness: WidgetStatePropertyAll(8),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(width: 1, color: Colors.white),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  HexColor("#000000"),
                                  HexColor("#C12265"),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),

                (selected_file == null
                    ? GestureDetector(
                        onTap: () {
                          // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Post_screen()), (route) => false); // Pickvideo();
                          // Get.to(Image_gallery());
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const Image_gallery()))
                              .then((editedFile) async {
                            if (editedFile != null) {
                              print(editedFile);

                              setState(() {
                                selected_file = editedFile;
                              });
                            }
                          });
                          print('data');
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 0),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: HexColor(
                                    CommonColor.grey_dark,
                                  ),
                                  width: 1.5)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Choose File',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: HexColor(CommonColor.grey_dark),
                                  fontFamily: 'PR',
                                  fontSize: 16),
                            ),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          _scaleDialog(context: context);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 0),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: HexColor(
                                    CommonColor.grey_dark,
                                  ),
                                  width: 1.5)),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Image Selected',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'PR',
                                  fontSize: 16),
                            ),
                          ),
                        ),
                      )),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  child: const Text(
                    'Step 1: Confirm notability',
                    style: TextStyle(
                        fontSize: 18, color: Colors.white, fontFamily: 'PB'),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  child: Text(
                    'Show that the public figure, celebrity, or brand your account represents is in the public interest.',
                    // textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontSize: 16,
                        color: HexColor(CommonColor.grey_dark),
                        fontFamily: 'PR'),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1, color: Colors.transparent),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      // stops: [0.1, 0.5, 0.7, 0.9],
                      colors: [
                        HexColor("#000000"),
                        HexColor("#C12265"),
                        // HexColor("#FFFFFF"),
                      ],
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          isExpanded: true,
                          hint: Row(
                            children: [
                              const SizedBox(
                                width: 4,
                              ),
                              Expanded(
                                child: Text(
                                  'Category',
                                  style: TextStyle(
                                      color: HexColor(CommonColor.pinkFont),
                                      fontSize: 16,
                                      fontFamily: 'PR',
                                      fontWeight: FontWeight.w500),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          items: category
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'PR',
                                          fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
                              .toList(),
                          value: _selectedcategory,
                          onChanged: (value) {
                            setState(() {
                              _selectedcategory = value as String;
                              category_selected = _selectedcategory!;
                            });
                          },
                          iconStyleData: const IconStyleData(
                            iconSize: 25,
                            iconEnabledColor: Color(0xff007DEF),
                            iconDisabledColor: Color(0xff007DEF),
                          ),
                          buttonStyleData: ButtonStyleData(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.transparent
                            ),
                            height: 50,
                            width: 100,
                            elevation: 0,
                            padding: const EdgeInsets.only(left: 14, right: 14),
                          ),
                          enableFeedback: true,
                          dropdownStyleData: DropdownStyleData(
                            padding: EdgeInsets.zero,
                            width: 150,
                            maxHeight: 200,
                            elevation: 8,
                            scrollbarTheme: const ScrollbarThemeData(
                              radius: Radius.circular(40),
                              thickness: WidgetStatePropertyAll(8),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(width: 1, color: Colors.white),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  HexColor("#000000"),
                                  HexColor("#C12265"),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1, color: Colors.transparent),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      // stops: [0.1, 0.5, 0.7, 0.9],
                      colors: [
                        HexColor("#000000"),
                        HexColor("#C12265"),
                        // HexColor("#FFFFFF"),
                      ],
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          isExpanded: true,
                          hint: Row(
                            children: [
                              const SizedBox(
                                width: 4,
                              ),
                              Expanded(
                                child: Text(
                                  'Country/Region',
                                  style: TextStyle(
                                      color: HexColor(CommonColor.pinkFont),
                                      fontSize: 16,
                                      fontFamily: 'PR',
                                      fontWeight: FontWeight.w500),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          items: _creator_signup_controller.data_country
                              .map((item) => DropdownMenuItem<CountryList>(
                                    value: item,
                                    child: Text(
                                      item.name!,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'PR',
                                          fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
                              .toList(),
                          value: _selectedcountry,
                          onChanged: (value) {
                            setState(() {
                              _selectedcountry = value;
                              country = _selectedcountry!.name!;
                            });
                          },
                          iconStyleData: const IconStyleData(
                            iconSize: 25,
                            iconEnabledColor: Color(0xff007DEF),
                            iconDisabledColor: Color(0xff007DEF),
                          ),
                          buttonStyleData: ButtonStyleData(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.transparent
                            ),
                            height: 50,
                            width: 100,
                            elevation: 0,
                            padding: const EdgeInsets.only(left: 14, right: 14),
                          ),
                          enableFeedback: true,
                          dropdownStyleData: DropdownStyleData(
                            padding: EdgeInsets.zero,
                            width: 150,
                            maxHeight: 200,
                            elevation: 8,
                            scrollbarTheme: const ScrollbarThemeData(
                              radius: Radius.circular(40),
                              thickness: WidgetStatePropertyAll(8),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(width: 1, color: Colors.white),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  HexColor("#000000"),
                                  HexColor("#C12265"),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  autofocus: false,
                  textAlign: TextAlign.start,
                  textInputAction: TextInputAction.done,
                  controller: audienController,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    labelText: 'Audience(Optional)',
                    hintStyle: TextStyle(
                        color: HexColor(CommonColor.pinkFont),
                        fontSize: 16,
                        fontFamily: 'PR',
                        fontWeight: FontWeight.w500),
                    labelStyle: TextStyle(
                        color: HexColor(CommonColor.pinkFont),
                        fontSize: 16,
                        fontFamily: 'PR',
                        fontWeight: FontWeight.w500),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: HexColor(CommonColor.pinkFont), width: 0.5),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: HexColor(CommonColor.pinkFont), width: 0.5),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  child: Text(
                    'Describe the people who follow your account. Include who they are, what they\'re interested in and why they follow you.',
                    // textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontSize: 16,
                        color: HexColor(CommonColor.grey_dark),
                        fontFamily: 'PR'),
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  autofocus: false,
                  textAlign: TextAlign.start,
                  textInputAction: TextInputAction.done,
                  controller: konwnAsController,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    labelText: 'Also known as(Optional)',
                    hintStyle: TextStyle(
                        color: HexColor(CommonColor.pinkFont),
                        fontSize: 16,
                        fontFamily: 'PR',
                        fontWeight: FontWeight.w500),
                    labelStyle: TextStyle(
                        color: HexColor(CommonColor.pinkFont),
                        fontSize: 16,
                        fontFamily: 'PR',
                        fontWeight: FontWeight.w500),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: HexColor(CommonColor.pinkFont), width: 0.5),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: HexColor(CommonColor.pinkFont), width: 0.5),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  child: Text(
                    'List all the names the person or organization your account represents is known by. Include different names and the same name in other languages.',
                    // textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontSize: 16,
                        color: HexColor(CommonColor.grey_dark),
                        fontFamily: 'PM'),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  child: const Text(
                    'Links(Optional)',
                    style: TextStyle(
                        fontSize: 18, color: Colors.white, fontFamily: 'PB'),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  child: Text(
                    'Add articles, social media accounts, and other links that show your account is in the public interest. Paid or promotional content won\'t be considered.',
                    // textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontSize: 16,
                        color: HexColor(CommonColor.grey_dark),
                        fontFamily: 'PM'),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  child: const Text(
                    'Link 1',
                    style: TextStyle(
                        fontSize: 18, color: Colors.white, fontFamily: 'PR'),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1, color: Colors.transparent),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      // stops: [0.1, 0.5, 0.7, 0.9],
                      colors: [
                        HexColor("#000000"),
                        HexColor("#C12265"),
                        // HexColor("#FFFFFF"),
                      ],
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          isExpanded: true,
                          hint: Row(
                            children: [
                              const SizedBox(
                                width: 4,
                              ),
                              Expanded(
                                child: Text(
                                  'Type',
                                  style: TextStyle(
                                      color: HexColor(CommonColor.pinkFont),
                                      fontSize: 16,
                                      fontFamily: 'PR',
                                      fontWeight: FontWeight.w500),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          items: type_link
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'PR',
                                          fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
                              .toList(),
                          value: type1,
                          onChanged: (value) {
                            setState(() {
                              type1 = value as String;
                            });
                          },
                          iconStyleData: const IconStyleData(
                            iconSize: 25,
                            iconEnabledColor: Color(0xff007DEF),
                            iconDisabledColor: Color(0xff007DEF),
                          ),
                          buttonStyleData: ButtonStyleData(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.transparent
                            ),
                            height: 50,
                            width: 100,
                            elevation: 0,
                            padding: const EdgeInsets.only(left: 14, right: 14),
                          ),
                          enableFeedback: true,
                          dropdownStyleData: DropdownStyleData(
                            padding: EdgeInsets.zero,
                            width: 150,
                            maxHeight: 200,
                            elevation: 8,
                            scrollbarTheme: const ScrollbarThemeData(
                              radius: Radius.circular(40),
                              thickness: WidgetStatePropertyAll(8),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(width: 1, color: Colors.white),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  HexColor("#000000"),
                                  HexColor("#C12265"),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  autofocus: false,
                  textAlign: TextAlign.start,
                  textInputAction: TextInputAction.done,
                  controller: url1Controller,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    labelText: 'URL',
                    hintStyle: TextStyle(
                        color: HexColor(CommonColor.pinkFont),
                        fontSize: 16,
                        fontFamily: 'PR',
                        fontWeight: FontWeight.w500),
                    labelStyle: TextStyle(
                        color: HexColor(CommonColor.pinkFont),
                        fontSize: 16,
                        fontFamily: 'PR',
                        fontWeight: FontWeight.w500),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: HexColor(CommonColor.pinkFont), width: 0.5),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: HexColor(CommonColor.pinkFont), width: 0.5),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  child: const Text(
                    'Link2',
                    style: TextStyle(
                        fontSize: 18, color: Colors.white, fontFamily: 'PR'),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1, color: Colors.transparent),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      // stops: [0.1, 0.5, 0.7, 0.9],
                      colors: [
                        HexColor("#000000"),
                        HexColor("#C12265"),
                        // HexColor("#FFFFFF"),
                      ],
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          isExpanded: true,
                          hint: Row(
                            children: [
                              const SizedBox(
                                width: 4,
                              ),
                              Expanded(
                                child: Text(
                                  'Type',
                                  style: TextStyle(
                                      color: HexColor(CommonColor.pinkFont),
                                      fontSize: 16,
                                      fontFamily: 'PR',
                                      fontWeight: FontWeight.w500),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          items: type_link
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'PR',
                                          fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
                              .toList(),
                          value: type2,
                          onChanged: (value) {
                            setState(() {
                              type2 = value as String;
                            });
                          },
                          iconStyleData: const IconStyleData(
                            iconSize: 25,
                            iconEnabledColor: Color(0xff007DEF),
                            iconDisabledColor: Color(0xff007DEF),
                          ),
                          buttonStyleData: ButtonStyleData(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.transparent
                            ),
                            height: 50,
                            width: 100,
                            elevation: 0,
                            padding: const EdgeInsets.only(left: 14, right: 14),
                          ),
                          enableFeedback: true,
                          dropdownStyleData: DropdownStyleData(
                            padding: EdgeInsets.zero,
                            width: 150,
                            maxHeight: 200,
                            elevation: 8,
                            scrollbarTheme: const ScrollbarThemeData(
                              radius: Radius.circular(40),
                              thickness: WidgetStatePropertyAll(8),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(width: 1, color: Colors.white),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  HexColor("#000000"),
                                  HexColor("#C12265"),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  autofocus: false,
                  textAlign: TextAlign.start,
                  textInputAction: TextInputAction.done,
                  controller: url2Controller,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    labelText: 'URL',
                    hintStyle: TextStyle(
                        color: HexColor(CommonColor.pinkFont),
                        fontSize: 16,
                        fontFamily: 'PR',
                        fontWeight: FontWeight.w500),
                    labelStyle: TextStyle(
                        color: HexColor(CommonColor.pinkFont),
                        fontSize: 16,
                        fontFamily: 'PR',
                        fontWeight: FontWeight.w500),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: HexColor(CommonColor.pinkFont), width: 0.5),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: HexColor(CommonColor.pinkFont), width: 0.5),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  child: const Text(
                    'Link3',
                    style: TextStyle(
                        fontSize: 18, color: Colors.white, fontFamily: 'PR'),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1, color: Colors.transparent),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      // stops: [0.1, 0.5, 0.7, 0.9],
                      colors: [
                        HexColor("#000000"),
                        HexColor("#C12265"),
                        // HexColor("#FFFFFF"),
                      ],
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          isExpanded: true,
                          hint: Row(
                            children: [
                              const SizedBox(
                                width: 4,
                              ),
                              Expanded(
                                child: Text(
                                  'Type',
                                  style: TextStyle(
                                      color: HexColor(CommonColor.pinkFont),
                                      fontSize: 16,
                                      fontFamily: 'PR',
                                      fontWeight: FontWeight.w500),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          items: type_link
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'PR',
                                          fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
                              .toList(),
                          value: type3,
                          onChanged: (value) {
                            setState(() {
                              type3 = value as String;
                            });
                          },
                          iconStyleData: const IconStyleData(
                            iconSize: 25,
                            iconEnabledColor: Color(0xff007DEF),
                            iconDisabledColor: Color(0xff007DEF),
                          ),
                          buttonStyleData: ButtonStyleData(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.transparent
                            ),
                            height: 50,
                            width: 100,
                            elevation: 0,
                            padding: const EdgeInsets.only(left: 14, right: 14),
                          ),
                          enableFeedback: true,
                          dropdownStyleData: DropdownStyleData(
                            padding: EdgeInsets.zero,
                            width: 150,
                            maxHeight: 200,
                            elevation: 8,
                            scrollbarTheme: const ScrollbarThemeData(
                              radius: Radius.circular(40),
                              thickness: WidgetStatePropertyAll(8),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(width: 1, color: Colors.white),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  HexColor("#000000"),
                                  HexColor("#C12265"),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  autofocus: false,
                  textAlign: TextAlign.start,
                  textInputAction: TextInputAction.done,
                  controller: url3Controller,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    labelText: 'URL',
                    hintStyle: TextStyle(
                        color: HexColor(CommonColor.pinkFont),
                        fontSize: 16,
                        fontFamily: 'PR',
                        fontWeight: FontWeight.w500),
                    labelStyle: TextStyle(
                        color: HexColor(CommonColor.pinkFont),
                        fontSize: 16,
                        fontFamily: 'PR',
                        fontWeight: FontWeight.w500),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: HexColor(CommonColor.pinkFont), width: 0.5),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: HexColor(CommonColor.pinkFont), width: 0.5),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    if (docs.isEmpty) {
                      CommonWidget().showToaster(msg: "Select Document");
                    } else if (country.isEmpty) {
                      CommonWidget().showToaster(msg: "Select Country/Region");
                    } else if (category_selected.isEmpty) {
                      CommonWidget().showToaster(msg: "Select Category");
                    } else {
                      Request_verification_post(context: context);
                    }
                    // List<Human> type_list = <Human>[];
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        'Submit',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'PR',
                            fontSize: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _scaleDialog({required BuildContext context}) async {
    showGeneralDialog(
      context: context,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: GreetingsPopUp(context: context),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  Widget GreetingsPopUp({
    required BuildContext context,
  }) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return StatefulBuilder(// You need this, notice the parameters below:
        builder: (BuildContext context, StateSetter setState) {
      return AlertDialog(
          // insetPadding:
          // EdgeInsets.only(
          //     bottom:
          //     500,
          //     left:
          //     100),
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          elevation: 0.0,
          // title: Center(child: Text("Evaluation our APP")),
          content: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 0),
                        // height: 122,
                        width: width,
                        // height: height / 3.5,
                        // padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: const Alignment(-1.0, 0.0),
                              end: const Alignment(1.0, 0.0),
                              transform: const GradientRotation(0.7853982),
                              // stops: [0.1, 0.5, 0.7, 0.9],
                              colors: [
                                HexColor("#000000"),
                                // HexColor("#000000"),
                                HexColor(CommonColor.pinkFont),
                                // HexColor("#ffffff"),
                                // HexColor("#FFFFFF").withOpacity(0.67),
                              ],
                            ),
                            //   color: HexColor('#3b5998'),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(26.0))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 5),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Container(
                                //   margin: EdgeInsets.symmetric(vertical: 10),
                                //     child: Row(
                                //       mainAxisAlignment: MainAxisAlignment.center,
                                //       children: [
                                //         Text(
                                //           '$seconds',
                                //           style: TextStyle(
                                //               fontSize: 16,
                                //               fontFamily: 'PB',
                                //               color: Colors.white),
                                //         ),
                                //         SizedBox(
                                //           width: 10,
                                //         ),
                                //         Image.asset(
                                //           AssetUtils.timer_icon,
                                //           width: 22,
                                //           height: 22,
                                //           fit: BoxFit.fill,
                                //         ),
                                //       ],
                                //     )),

                                SizedBox(
                                    height: height / 3,
                                    child: Image.file(selected_file!)),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        // setState(() {
                                        //   selected_file = null;
                                        // });
                                        Navigator.pop(context);
                                        // setState((){});
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.white),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 20),
                                          child: Text(
                                            'Done',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'PR',
                                                color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 3, bottom: 3),
                        alignment: Alignment.topRight,
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.black,
                                //   gradient: LinearGradient(
                                //     begin: Alignment.centerLeft,
                                //     end: Alignment.centerRight,
                                //     // stops: [0.1, 0.5, 0.7, 0.9],
                                //     colors: [
                                //       HexColor("#36393E").withOpacity(1),
                                //       HexColor("#020204").withOpacity(1),
                                //     ],
                                //   ),
                                boxShadow: const [
                                  // BoxShadow(
                                  //     color: HexColor('#04060F'),
                                  //     offset: Offset(0, 3),
                                  //     blurRadius: 5)
                                ],
                                borderRadius: BorderRadius.circular(20)),
                            child: const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Icon(
                                Icons.cancel_outlined,
                                size: 20,
                                color: Colors.white,
                                // color: ColorUtils.primary_grey,
                              ),
                            )),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ));
    });
  }

  PostVerificationModel? postVerificationModel;

  Future<dynamic> Request_verification_post({
    required BuildContext context,
  }) async {
    // showLoader(context);
    var url = URLConstants.base_url + URLConstants.Request_Verification;
    var request = http.MultipartRequest('POST', Uri.parse(url));
    // List<int> imageBytes = imgFile!.readAsBytesSync();
    // String baseimage = base64Encode(imageBytes);
    String idUser = await PreferenceManager().getPref(URLConstants.id);

    //
    // print(selected_file!.path);
    // print(idUser);
    // print(UsernameController.text);
    // print(FullnameController.text);
    // print(_selectedsocumenttype);
    // print(_selectedcategory);
    // print(_selectedcountry!.name);
    // print(audienController.text);
    // print(konwnAsController.text);
    // print(type1);
    // print(type2);
    // print(type3);
    // print(url1Controller.text);
    // print(url2Controller.text);
    // print(url3Controller.text);

    if (selected_file != null) {
      var files = http.MultipartFile(
          'file[]',
          File(selected_file!.path).readAsBytes().asStream(),
          File(selected_file!.path).lengthSync(),
          filename: selected_file!.path.split("/").last);
      request.files.add(files);
    }

    request.fields['user_id'] = idUser;
    request.fields['user_name'] = UsernameController.text;
    request.fields['full_name'] = FullnameController.text;
    request.fields['doc_type'] = docs ??= "";
    request.fields['category'] = category_selected ??= "";
    request.fields['country'] = country ??= "";
    request.fields['audience'] = audienController.text;
    request.fields['known_as'] = konwnAsController.text;
    request.fields['type1'] = type1 ??= "";
    request.fields['url1'] = url1Controller.text;
    request.fields['type2'] = type2 ??= "";
    request.fields['url2'] = url2Controller.text;
    request.fields['type3'] = type3 ??= "";
    request.fields['url3'] = url3Controller.text;

    //userId,tagLine,description,address,postImage,uploadVideo,isVideo
    // request.files.add(await http.MultipartFile.fromPath(
    //     "image", widget.ImageFile.path));

    var response = await request.send();
    var responsed = await http.Response.fromStream(response);
    print(response.statusCode);
    print("response - ${response.statusCode}");

    if (response.statusCode == 200) {
      var data = jsonDecode(responsed.body);
      postVerificationModel = PostVerificationModel.fromJson(data);
      print(postVerificationModel!.error);
      print(postVerificationModel!.message);
      if (postVerificationModel!.error == false) {
        // hideLoader(context);
        CommonWidget().showToaster(msg: postVerificationModel!.message!);
        // Get.to(Dashboard());
      } else {
        CommonWidget().showToaster(msg: postVerificationModel!.message!);

        print('Please try again');
      }
    } else {
      CommonWidget().showToaster(msg: postVerificationModel!.message!);

      print('Please try again');
    }
  }
}
