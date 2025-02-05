import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

import '../Utils/App_utils.dart';
import '../Utils/asset_utils.dart';
import '../Utils/colorUtils.dart';
import '../custom_widget/loader_page.dart';
import '../profile_screen/profile_controller.dart';
import '../sharePreference.dart';
import 'advertisor/commercial_video/commercial_video_screen.dart';
import 'controller/post_screen_controller.dart';
import 'dashboard_screen.dart';
import 'model/getdraftModel.dart';

class Draft_screen extends StatefulWidget {
  const Draft_screen({Key? key}) : super(key: key);

  @override
  State<Draft_screen> createState() => _Draft_screenState();
}

class _Draft_screenState extends State<Draft_screen> {
  final DashboardScreenController _dashboardScreenController =
      Get.put(DashboardScreenController(), tag: DashboardScreenController().toString());

  final Profile_screen_controller _profile_screen_controller =
      Get.put(Profile_screen_controller(), tag: Profile_screen_controller().toString());

  @override
  void initState() {
    _dashboardScreenController.Get_draftList_Api(context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black,
        // flexibleSpace: Container(
        //   decoration: const BoxDecoration(
        //    color: Colors.black
        //   ),
        // ),
        leadingWidth: 400,
        elevation: 0.0,
        leading: Center(
          // margin: EdgeInsets.only(left: 20,top: 30),
          child: GestureDetector(
            onTap: () {
              // Navigator.pop(context);
              // Get.to(Dashboard(page: 0,));
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Dashboard(
                            page: 0,
                          )),
                  (route) => false);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          'Draft',
          style: TextStyle(fontSize: 16, fontFamily: 'PR'),
        ),
        actions: [
          Center(
            child: GestureDetector(
              onTap: () async {},
              child: Container(
                margin: EdgeInsets.only(right: 20),
                child: Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                    child: Text(
                      'Next',
                      style:
                          TextStyle(fontSize: 14, fontFamily: 'PM', fontWeight: FontWeight.w600, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        child: Obx(() => _dashboardScreenController.isDraftlistLoading.value == true
            ? Center(child: LoaderPage())
            : (_dashboardScreenController.getDraftListModel!.error == true
                ? Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 0),
                          child: Text("${_dashboardScreenController.getDraftListModel!.message}",
                              style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'PM')),
                        ),
                      ),
                    ),
                  )
                : GridView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    padding: EdgeInsets.all(5),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      // A grid view with 3 items per row
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      crossAxisCount: 3,
                      // childAspectRatio: 5/4
                    ),
                    itemCount: _dashboardScreenController.getDraftListModel!.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          _scaleDialog(
                              context: context, draft_: _dashboardScreenController.getDraftListModel!.data![index]);
                        },
                        child: Container(
                          child: (_dashboardScreenController.getDraftListModel!.data![index].isVideo == 'true'
                              ? Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Positioned.fill(
                                      child: _dashboardScreenController
                                              .getDraftListModel!.data![index].coverImage!.isNotEmpty
                                          ? FadeInImage.assetNetwork(
                                              fit: BoxFit.cover,
                                              image:
                                                  "${URLConstants.base_data_url}coverImage/${_dashboardScreenController.getDraftListModel!.data![index].coverImage}",
                                              placeholder: 'assets/images/Funky_App_Icon.png',
                                              // color: HexColor(CommonColor.pinkFont),
                                            )
                                          : Positioned.fill(
                                              child: FadeInImage.assetNetwork(
                                              fit: BoxFit.cover,
                                              image: "${URLConstants.base_data_url}images/Funky-logo.png",
                                              placeholder: 'assets/images/Funky_App_Icon.png',
                                              // color: HexColor(CommonColor.pinkFont),
                                            )),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.black54, borderRadius: BorderRadius.circular(100)),
                                      child: const Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Icon(
                                          Icons.play_arrow,
                                          color: Colors.pink,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              // Stack(
                              //   alignment: Alignment.center,
                              //   children: [
                              //     Image.network(
                              //       "${URLConstants.base_data_url}coverImage/${_dashboardScreenController.getDraftListModel!.data![index].coverImage}",
                              //       fit: BoxFit.cover,
                              //     ),
                              //   ],
                              //     )
                              : FadeInImage.assetNetwork(
                                  fit: BoxFit.cover,
                                  image:
                                      "${URLConstants.base_data_url}images/${_dashboardScreenController.getDraftListModel!.data![index].postImage}",
                                  placeholder: 'assets/images/Funky_App_Icon.png',
                                  // color: HexColor(CommonColor.pinkFont),
                                )),
                        ),
                      );
                    },
                  ))),
      ),
    );
  }

  Future<void> _scaleDialog({
    required BuildContext context,
    required Data_draft draft_,
  }) async {
    showGeneralDialog(
      context: context,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: GreetingsPopUp(context: context, draft_data: draft_),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  Widget GreetingsPopUp({required BuildContext context, required Data_draft draft_data}) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
      child: StatefulBuilder(// You need this, notice the parameters below:

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
                          margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
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
                              borderRadius: const BorderRadius.all(Radius.circular(26.0))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                            child: SizedBox(
                              // height: height / 4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(23),
                                    child: Image.asset(
                                      AssetUtils.share_icon3,
                                      fit: BoxFit.cover,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "Are you sure want to share this post ?",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 16, fontFamily: 'PR', color: Colors.white),
                                  ),
                                  Align(
                                    alignment: FractionalOffset.bottomCenter,
                                    child: Container(
                                      margin: EdgeInsets.symmetric(vertical: 40, horizontal: 0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () async {
                                                // showLoader(context);
                                                // (draft_data.isCommercial =='false'
                                                //     ? uploadImage()
                                                //     : Get.to(CommercialVideoScreen(
                                                //   videoFile: File('') ,
                                                //   description: '',
                                                //   tagged_users: '',
                                                //   enable_download: '',
                                                //   enable_comment: '',
                                                // )));
                                                await _profile_screen_controller.PostDeleteApi(
                                                    context: context, post_id: draft_data.postId!);
                                                if (_profile_screen_controller.postDeleteModel!.error == false) {
                                                  _dashboardScreenController.Get_draftList_Api(context: context);
                                                }
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.symmetric(horizontal: 0),
                                                // height: 45,
                                                // width:(width ?? 300) ,
                                                decoration: BoxDecoration(
                                                    color: Colors.red, borderRadius: BorderRadius.circular(25)),
                                                child: Container(
                                                    alignment: Alignment.center,
                                                    margin: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                                                    child: Text(
                                                      'Delete',
                                                      style: TextStyle(
                                                          color: Colors.white, fontFamily: 'PR', fontSize: 16),
                                                    )),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () async {
                                                (draft_data.isCommercial == 'false'
                                                    ? uploadImage(data: draft_data)
                                                    : Get.to(CommercialVideoScreen(
                                                        videoFile: File(''),
                                                        description: '',
                                                        tagged_users: '',
                                                        enable_download: '',
                                                        enable_comment: '',
                                                        cover_image: '',
                                                      )));
                                                // Navigator.pop(context);
                                                // send_otp_account(context: context);
                                                // delete_account(context: context);
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.symmetric(horizontal: 0),
                                                // height: 45,
                                                // width:(width ?? 300) ,
                                                decoration: BoxDecoration(
                                                    color: Colors.white, borderRadius: BorderRadius.circular(25)),
                                                child: Container(
                                                    alignment: Alignment.center,
                                                    margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                                                    child: Text(
                                                      'Share',
                                                      style: TextStyle(
                                                          color: Colors.black, fontFamily: 'PR', fontSize: 16),
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
                                  boxShadow: [
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
      }),
    );
  }

  bool draft = false;

  Future<dynamic> uploadImage({required Data_draft data}) async {
    String id_user = await PreferenceManager().getPref(URLConstants.id);
    var url = (URLConstants.base_url + URLConstants.postApi);
    var request = http.MultipartRequest('POST', Uri.parse(url));
    // setState(() {
    //   fileInByte = widget.cover_image.readAsBytesSync();
    //   fileInBase64 = base64Encode(fileInByte!);
    // });
    //
    // print(fileInBase64);

    // var files = http.MultipartFile(
    //     'uploadVideo',
    //     File(widget.videoFile.path).readAsBytes().asStream(),
    //     File(widget.videoFile.path).lengthSync (),
    //     filename: widget.videoFile.path.split("/").last );
    // var files2 = http.MultipartFile(
    //     'coverImage',
    //     File(widget.cover_image.path).readAsBytes().asStream(),
    //     File(widget.cover_image.path).lengthSync (),
    //     filename: widget.cover_image.path.split("/").last);

    // request.files.add(files);
    // request.files.add(files2);
    request.fields['userId'] = id_user;
    request.fields['coverImage'] = '';
    request.fields['description'] = data.description!;
    request.fields['trending'] = '#image';
    request.fields['postImage'] = '';
    request.fields['uploadVideo'] = '';
    request.fields['isVideo'] = data.isVideo!;
    request.fields['tagLine'] = data.tagLine!;
    request.fields['address'] = data.address!;
    request.fields['draft'] = draft.toString();
    request.fields['postId'] = data.postId!;
    request.fields['enableDownload'] = data.enableDownload!;
    request.fields['enableComment'] = data.enableDownload!;
    request.fields['allowAds'] = data.allowAds!;

    //userId,tagLine,description,address,postImage,uploadVideo,isVideo
    // request.files.add(await http.MultipartFile.fromPath(
    //     "image", widget.ImageFile.path));

    var response = await request.send();
    var responsed = await http.Response.fromStream(response);
    final responseData = json.decode(responsed.body);

    if (response.statusCode == 200) {
      print("SUCCESS");
      print(response.reasonPhrase);
      // print(widget.videoFile.path);
      print(responseData);
      // hideLoader(context);

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Dashboard(
                    page: 3,
                  )));

      // await Get.to(Profile_Screen());
    } else {
      print("ERROR");
    }
  }
}
