import 'package:flutter/material.dart';
import 'package:funky_new/dashboard/dashboard_screen.dart';
import 'package:funky_new/settings/report_video/report_problem.dart';
import 'package:funky_new/settings/security_login/security_login.dart';
// import 'package:funky_project/settings/privacy_setting_screen.dart';
// import 'package:funky_project/settings/report_problem.dart';
// import 'package:funky_project/settings/security_login/security_login.dart';
import 'package:get/get.dart';

import '../Authentication/authentication_screen.dart';
import '../Utils/App_utils.dart';
import '../Utils/asset_utils.dart';
import '../Utils/toaster_widget.dart';
import '../sharePreference.dart';
import 'blockList_screen.dart';
import 'community_guide.dart';
import 'copyright_policy.dart';
import 'help_center.dart';
import 'invite_friends.dart';
import 'manage_accounts/manage_account_screen.dart';
import 'manage_accounts/terms_services.dart';
import 'notification_settings.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  // List icon_list = [
  //   AssetUtils.manage_icon,
  //   AssetUtils.privacy_icon,
  //   AssetUtils.security_icon,
  //   AssetUtils.rewards_icon,
  //   AssetUtils.kidsaccount_icon,
  //   AssetUtils.invite_icon,
  //   AssetUtils.notification_icon,
  //   AssetUtils.report_icon,
  //   AssetUtils.help_icon,
  //   AssetUtils.community_icon,
  //   AssetUtils.terms_service_icon,
  //   AssetUtils.copyright_icon,
  //   AssetUtils.copyright_icon,
  //   AssetUtils.logout_icon,
  // ];
  List icon_list = [
    AssetUtils.manage_icon,
    // AssetUtils.file_alt,
    AssetUtils.security,
    // AssetUtils.rewardsIcons,
    // AssetUtils.hand_holding,
    AssetUtils.share_icon3,
    AssetUtils.noti_icon,
    AssetUtils.report_icon,
    AssetUtils.help_icon,
    AssetUtils.community_icon,
    AssetUtils.file_alt,
    AssetUtils.file_alt,
    AssetUtils.file_alt,
    AssetUtils.logout_icon,
  ];

  List icon_name = [
    "Manage accounts",
    // "Privacy",
    "Security and login",
    // "Rewards",
    // "Kids accocunt",
    "Invite friends",
    "Notifications",
    "Report a problem",
    "Help center",
    "Community guidelines",
    "Terms of service",
    "Copyright policy",
    "Blocked user",
    "Logout",
  ];

  Route _createQrRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          Dashboard(page: 0),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

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
        title: const Text(
          'Settings',
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
              Navigator.of(context).push(_createQrRoute());

              // Get.to(Dashboard(page: 0));
              // Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          )),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              physics: const ClampingScrollPhysics(),
              // padding: EdgeInsets.only(bottom: 50),
              itemCount: icon_list.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    (index == 0
                        ? Get.to(const ManageAccount())
                        : (index == 1
                            ? Get.to(const Security_Login())
                            : (index == 2
                                ? Get.to(const InviteFriends())
                                // Get.to(KidsAccount())
                                : (index == 3
                                    ? Get.to(const NotificationSettings())
                                    : (index == 4
                                        ? Get.to(const ReportProblem(
                                            receiver_id: '',
                                            type: '',
                                            type_id: '',
                                          ))
                                        : (index == 5
                                            ? Get.to(const HelpCenterScreen())
                                            : (index == 6
                                                ? Get.to(const CommunityGuide())
                                                : (index == 7
                                                    ? Get.to(
                                                        const Temrs_servicesScreen())
                                                    : (index == 8
                                                        ? Get.to(
                                                            const CopyRightPolicy())
                                                        : (index == 9
                                                            ? Get.to(
                                                                const BlockListScreen())
                                                            : (index == 10
                                                                ? logOut_function()
                                                                : null)))))))))));
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
                      style: const TextStyle(
                          fontSize: 16, color: Colors.white, fontFamily: 'PR'),
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.arrow_forward_ios_sharp,
                        color: Colors.pink,
                        size: 18,
                      ),
                      onPressed: () {},
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  logOut_function() async {
    await PreferenceManager().setPref(URLConstants.id, '');
    await PreferenceManager().setPref(URLConstants.type, '');
    await Get.offAll(const AuthenticationScreen());
    setState(() {});
    CommonWidget().showToaster(msg: 'User LoggedOut');
  }
}
