import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:funky_project/Utils/asset_utils.dart';
// import 'package:funky_project/Utils/colorUtils.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Utils/asset_utils.dart';
import '../Utils/colorUtils.dart';
import '../custom_widget/common_buttons.dart';

class InviteFriends extends StatefulWidget {
  const InviteFriends({super.key});

  @override
  State<InviteFriends> createState() => _InviteFriendsState();
}

class _InviteFriendsState extends State<InviteFriends> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Invite friends',
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
            icon: const Icon(Icons.arrow_back),
          )),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 75),
            child: Image.asset(AssetUtils.friends_icon),
          ),
          const SizedBox(
            height: 41,
          ),
          SizedBox(
            width: 300,
            child: common_button(
              onTap: () async {
                const String url = 'http://palystoreUrl';
                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(Uri.parse(url));
                } else {
                  Fluttertoast.showToast(msg: 'cant not launch Url $url');
                }
              },
              backgroud_color: HexColor(CommonColor.pinkFont),
              lable_text: 'Invite friends by',
              lable_text_color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
