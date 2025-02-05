import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../Authentication/creator_login/controller/creator_login_controller.dart';
import '../../Utils/colorUtils.dart';

class SaveLoginInfo extends StatefulWidget {
  const SaveLoginInfo({Key? key}) : super(key: key);

  @override
  State<SaveLoginInfo> createState() => _SaveLoginInfoState();
}

class _SaveLoginInfoState extends State<SaveLoginInfo> {
  bool isSwitched = false;

  final Creator_Login_screen_controller _loginScreenController =
      Get.put(Creator_Login_screen_controller(), tag: Creator_Login_screen_controller().toString());

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
            HexColor(CommonColor.bloodRed),
            HexColor("#000000"),
            HexColor("#000000"),
            HexColor("#000000"),
          ])),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(
              'Saved login info',
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
                },
                icon: Icon(Icons.arrow_back),
              )),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text('Save Login',
                              style: TextStyle(fontSize: 16, color: HexColor('#E84F90'), fontFamily: 'PR')),
                        ),
                        // Container(
                        //   child: Theme(
                        //     data: ThemeData(
                        //         unselectedWidgetColor:
                        //         HexColor(CommonColor.pinkFont)),
                        //     child: Switch(
                        //       value: isSwitched,
                        //       onChanged: (value) {
                        //         setState(() {
                        //           isSwitched = value;
                        //           print(isSwitched);
                        //         });
                        //       },
                        //       activeColor: HexColor(CommonColor.pinkFont),
                        //       inactiveTrackColor: Colors.red[100],
                        //       inactiveThumbColor: HexColor(CommonColor.pinkFont),
                        //     ),
                        //   ),
                        // ),
                        Transform.scale(
                          scale: 0.7,
                          child: Theme(
                            data: ThemeData(
                              unselectedWidgetColor: HexColor(CommonColor.pinkFont),
                            ),
                            child: CupertinoSwitch(
                              value: isSwitched,
                              onChanged: (value) {
                                isSwitched = value;
                                setState(
                                  () {
                                    isSwitched = value;
                                    print(isSwitched);
                                  },
                                );
                              },
                              thumbColor: Colors.black,
                              activeColor: HexColor(CommonColor.pinkFont),
                              trackColor: HexColor(CommonColor.pinkFont_light),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 45),
                      child: Text(
                          "We will remember your account info for you on this device. You won't need to enter it when you login again.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: HexColor(CommonColor.grey_light), fontFamily: 'PR  ')),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
