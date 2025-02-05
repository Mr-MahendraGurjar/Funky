import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:funky_new/settings/manage_accounts/post_setting/post_settings.dart';
import 'package:funky_new/settings/manage_accounts/privacy_screen.dart';
import 'package:funky_new/settings/manage_accounts/request_verification/request_verification.dart';
import 'package:funky_new/settings/manage_accounts/security_checkup/security_checkup_screen.dart';
import 'package:funky_new/settings/manage_accounts/terms_services.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../Utils/asset_utils.dart';
import '../../Authentication/authentication_screen.dart';
import '../../dashboard/dashboard_screen.dart';
import 'comment_settings/comment_settings.dart';
import 'delete_account/delete_account_otp_verify.dart';
import 'email_settings.dart';

class ManageAccount extends StatefulWidget {
  const ManageAccount({Key? key}) : super(key: key);

  @override
  State<ManageAccount> createState() => _ManageAccountState();
}

class _ManageAccountState extends State<ManageAccount> {
  List icon_list = [
    AssetUtils.manage_icon,
    AssetUtils.manage_icon,
    // AssetUtils.share_icon3,
    AssetUtils.share_icon3,
    AssetUtils.hand_holding,
    AssetUtils.security,
    AssetUtils.file_alt,
    AssetUtils.file_alt,
    // AssetUtils.file_alt,
    AssetUtils.file_alt,
    AssetUtils.file_alt,
  ];
  List icon_name = [
    "Privacy Settings",
    "Add account",
    // "Logout adult / kids account",
    "Logout all account",
    "Request verification",
    "Security checkup",
    "Post Setting",
    "Comment Setting",
    "Email from Funky",
    // "Email & SMS",
    "Privacy policy",
  ];

  Route _createQrRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => Dashboard(page: 0),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Manage Account',
          style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'PB'),
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
              // Navigator.of(context).push(_createQrRoute());
            },
            icon: Icon(Icons.arrow_back),
          )),
        ),
      ),
      body: Stack(
        children: [
          ListView.builder(
            physics: ClampingScrollPhysics(),
            itemCount: icon_list.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  print(index);
                  (index == 0
                          ? Get.to(PrivcacyScreen())
                          : (index == 1
                              ? Navigator.push(context, MaterialPageRoute(builder: (context) => AuthenticationScreen()))
                              // Get.to(AuthenticationScreen())
                              // : (index == 2
                              //     ? Navigator.of(context).pushAndRemoveUntil(
                              //         MaterialPageRoute(
                              //             builder: (context) =>
                              //                 AuthenticationScreen()),
                              //         (Route<dynamic> route) => false)
                              : (index == 2
                                  ? Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(builder: (context) => AuthenticationScreen()),
                                      (Route<dynamic> route) => false)
                                  : (index == 3
                                      ? Get.to(RequestVerification())
                                      : (index == 5
                                          ? Get.to(PostSettings())
                                          : (index == 6
                                              ? Get.to(CommentSettins())
                                              : (index == 7
                                                  ? Get.to(EmailSettings())
                                                  // : (index == 9
                                                  //     ? Get.to(
                                                  //         Email_sms_Screen())
                                                  : (index == 8
                                                      ? Get.to(Temrs_servicesScreen())
                                                      : (index == 4 ? Get.to(SecurityCheckup()) : null)))))))))
                      // ) )
                      ;
                },
                child: ListTile(
                  leading: IconButton(
                    onPressed: () {},
                    icon: Image.asset(
                      icon_list[index],
                      color: Colors.white,
                      height: 20,
                      width: 20,
                    ),
                  ),
                  title: Text(
                    icon_name[index],
                    style: const TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'PR'),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 15,
                    ),
                    onPressed: () {},
                  ),
                ),
              );
            },
          ),
          Positioned(
            child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Container(
                  height: 25,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey,
                  child: GestureDetector(
                    onTap: () {
                      selectTowerBottomSheet(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delete, color: Colors.red, size: 20),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Delete Account',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.red, fontFamily: 'PMB', fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
          )
        ],
      ),
    );
  }

  selectTowerBottomSheet(BuildContext context) {
    final screenheight = MediaQuery.of(context).size.height;
    final screenwidth = MediaQuery.of(context).size.width;
    showModalBottomSheet(
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
          child: StatefulBuilder(
            builder: (context, state) {
              return Container(
                height: screenheight * 0.4,
                width: screenwidth,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    // stops: [0.1, 0.5, 0.7, 0.9],
                    colors: [
                      HexColor("#C12265"),
                      HexColor("#000000"),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 23.9),
                  child: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.all(23),
                          child: Icon(
                            Icons.delete,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Are you sure want to delete your" + "\nAccount ?",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, fontFamily: 'PR', color: Colors.white),
                        ),
                        Align(
                          alignment: FractionalOffset.bottomCenter,
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 40, horizontal: 0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () async {
                                      Get.to(DeleteAccountOTP());
                                      // send_otp_account(context: context);
                                      // delete_account(context: context);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 30),
                                      // height: 45,
                                      // width:(width ?? 300) ,
                                      decoration:
                                          BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
                                      child: Container(
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          child: Text(
                                            'Yes',
                                            style: TextStyle(color: Colors.black, fontFamily: 'PR', fontSize: 16),
                                          )),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 30),
                                      // height: 45,
                                      // width:(width ?? 300) ,
                                      decoration:
                                          BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(25)),
                                      child: Container(
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          child: Text(
                                            'No',
                                            style: TextStyle(color: Colors.white, fontFamily: 'PR', fontSize: 16),
                                          )),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
