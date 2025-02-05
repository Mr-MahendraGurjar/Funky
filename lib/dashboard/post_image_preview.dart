import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:funky_new/dashboard/tag_people_search.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:video_editor/video_editor.dart';

// import 'package:video_editor/domain/bloc/controller.dart';

import '../../Utils/App_utils.dart';
import '../../Utils/asset_utils.dart';
import '../../custom_widget/common_buttons.dart';
import '../../sharePreference.dart';
import '../Utils/colorUtils.dart';
import '../custom_widget/page_loader.dart';
import 'dashboard_screen.dart';

class PostImagePreviewScreen extends StatefulWidget {
  final File ImageFile;

  const PostImagePreviewScreen({
    super.key,
    required this.ImageFile,
  });

  @override
  State<PostImagePreviewScreen> createState() => _PostImagePreviewScreenState();
}

class _PostImagePreviewScreenState extends State<PostImagePreviewScreen> {
  bool valuedownload = false;
  bool valuecomment = false;
  bool valueallowAds = false;
  TextEditingController description_controller = TextEditingController();

  share_icon() {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Pick Image from"),
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: common_button(
              onTap: () async {
                uploadImage();
                // Get.toNamed(BindingUtils.signupOption);
              },
              backgroud_color: Colors.black,
              lable_text: 'Share',
              lable_text_color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  List<String> tagged_users = [];
  VideoEditorController? _controller;
  bool isClicked = false; // boolean that states if the button is pressed or not

  @override
  void initState() {
    // TODO: implement initState
    print(widget.ImageFile.path);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              ],
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Text(
              'Edit Post',
              style: TextStyle(
                  fontSize: 16, color: Colors.white, fontFamily: 'PB'),
            ),
            centerTitle: true,
            // leadingWidth: 100,
            // leading: IconButton(
            //     padding: EdgeInsets.zero,
            //     onPressed: () {
            //       print('oject');
            //       Navigator.pop(context);
            //     },
            //     icon: Icon(
            //       Icons.arrow_back_outlined,
            //       color: Colors.white,
            //     )),
            actions: [
              InkWell(
                onTap: () {
                  // share_icon();
                  _scaleDialog(context: context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Image.asset(
                    AssetUtils.share_icon3,
                    fit: BoxFit.cover,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    // width: 300,
                    child: TextFormField(
                      maxLength: 150,
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.only(left: 20, top: 14, bottom: 14),
                        alignLabelWithHint: false,
                        isDense: true,
                        labelText: 'Add Description',
                        counterStyle: TextStyle(
                          height: double.minPositive,
                        ),
                        filled: true,
                        border: InputBorder.none,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffE84F90)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xffE84F90),
                          ),
                        ),
                        labelStyle: TextStyle(
                          fontSize: 14,
                          fontFamily: 'PR',
                          color: Color(0xffE84F90),
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'PR',
                        color: Colors.black,
                      ),
                      controller: description_controller,
                      // keyboardType: keyboardType ?? TextInputType.multiline,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (tagged_users.isEmpty) {
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const TagPeopleSearch()))
                            .then((editedImage) async {
                          if (kDebugMode) {
                            print(editedImage);
                          }
                          for (var i = 0; i < editedImage.length; i++) {
                            setState(() {
                              tagged_users.add("@${editedImage[i].username}");
                            });
                            print(tagged_users[i]);
                          }
                          print(tagged_users.length);
                        });
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: (tagged_users.isNotEmpty
                          ? Text(
                              tagged_users.join(','),
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'PR',
                                  color: Colors.white),
                            )
                          : const Text(
                              'Tag People',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'PR',
                                  color: Colors.white),
                            )),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Add Location',
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'PR',
                              color: HexColor(CommonColor.pinkFont)),
                        ),
                        Container(
                          child: const Icon(
                            Icons.gps_fixed,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Enable Download',
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'PR',
                              color: Colors.white),
                        ),
                        Theme(
                          data: ThemeData(unselectedWidgetColor: Colors.white),
                          child: Checkbox(
                            visualDensity: const VisualDensity(
                                vertical: -4, horizontal: -4),
                            checkColor: Colors.black,
                            activeColor: Colors.white,
                            value: valuedownload,
                            onChanged: (value) {
                              setState(() {
                                valuedownload = value!;
                              });
                              print(valuedownload);
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Enable Comments',
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'PR',
                              color: Colors.white),
                        ),
                        Theme(
                          data: ThemeData(unselectedWidgetColor: Colors.white),
                          child: Checkbox(
                            visualDensity: const VisualDensity(
                                vertical: -4, horizontal: -4),
                            checkColor: Colors.black,
                            activeColor: Colors.white,
                            value: valuecomment,
                            onChanged: (value) {
                              setState(() {
                                valuecomment = value!;
                              });
                              print(valuecomment);
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Allow or disallow ads on your post.',
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'PR',
                              color: Colors.white),
                        ),
                        Theme(
                          data: ThemeData(unselectedWidgetColor: Colors.white),
                          child: Checkbox(
                            visualDensity: const VisualDensity(
                                vertical: -4, horizontal: -4),
                            checkColor: Colors.black,
                            activeColor: Colors.white,
                            value: valueallowAds,
                            onChanged: (value) {
                              setState(() {
                                valueallowAds = value!;
                              });
                              print(valueallowAds);
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  // Container(
                  //   margin: EdgeInsets.symmetric(vertical: 10),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Text(
                  //         'Enable save to device',
                  //         style: TextStyle(
                  //             fontSize: 14,
                  //             fontFamily: 'PR',
                  //             color: Colors.white),
                  //       ),
                  //       Theme(
                  //         data: ThemeData(unselectedWidgetColor: Colors.white),
                  //         child: Checkbox(
                  //           visualDensity:
                  //               VisualDensity(vertical: -4, horizontal: -4),
                  //           checkColor: Colors.black,
                  //           activeColor: Colors.white,
                  //           value: valuefirst,
                  //           onChanged: (value) {
                  //             setState(() {
                  //               valuefirst = value!;
                  //             });
                  //           },
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                      child: Image.file(
                    widget.ImageFile,
                  ))
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // bool ispostLoading = false;
  // PostModelList? _postModelList;

  // Future<dynamic> Share_image_api(BuildContext context) async {
  //   setState(() {
  //     ispostLoading = true;
  //   });
  //   // showLoader(context);
  //
  //   String id_user = await PreferenceManager().getPref(URLConstants.id);
  //
  //   debugPrint('0-0-0-0-0-0-0 username');
  //   Map data = {
  //     'userId': id_user,
  //     'description': description_controller.text,
  //     'trending': '#image',
  //     'image': widget.ImageFile.readAsBytesSync(),
  //     'uploadVideo': '',
  //     'isVideo': 'false',
  //   };
  //   print(data);
  //   // String body = json.encode(data);
  //
  //   var url = (URLConstants.base_url + URLConstants.postApi);
  //   print("url : $url");
  //   print("body : $data");
  //
  //   var response = await http.post(
  //     Uri.parse(url),
  //     body: data,
  //   );
  //   print(response.body);
  //   print(response.request);
  //   print(response.statusCode);
  //   // var final_data = jsonDecode(response.body);
  //
  //   // print('final data $final_data');
  //
  //   if (response.statusCode == 200) {
  //     var data = jsonDecode(response.body);
  //     _postModelList = PostModelList.fromJson(data);
  //     print(_postModelList);
  //     if (_postModelList!.error == false) {
  //       CommonWidget().showToaster(msg: 'Posted Succesfully');
  //       setState(() {
  //         ispostLoading = false;
  //       });
  //       // hideLoader(context);
  //       // Get.to(Dashboard());
  //     } else {
  //       print('Please try again');
  //     }
  //   } else {
  //     print('Please try again');
  //   }
  // }
  bool draft = false;

  Future<dynamic> uploadImage() async {
    print('called');

    // showLoader(context);
    String idUser = await PreferenceManager().getPref(URLConstants.id);
    var url = (URLConstants.base_url + URLConstants.postApi);
    var request = http.MultipartRequest('POST', Uri.parse(url));
    List<int> imageBytes = widget.ImageFile.readAsBytesSync();
    String baseimage = base64Encode(imageBytes);

    var files = http.MultipartFile(
        'postImage',
        File(widget.ImageFile.path).readAsBytes().asStream(),
        File(widget.ImageFile.path).lengthSync(),
        filename: widget.ImageFile.path.split("/").last);
    request.files.add(files);
    request.fields['userId'] = idUser;
    request.fields['description'] = description_controller.text;
    request.fields['trending'] = '#image';
    request.fields['uploadVideo'] = '';
    request.fields['coverImage'] = '';
    request.fields['isVideo'] = 'false';
    request.fields['tagLine'] = tagged_users.join(',');
    request.fields['address'] = '';
    request.fields['draft'] = draft.toString();
    request.fields['postId'] = '';
    request.fields['enableDownload'] = valuedownload.toString();
    request.fields['enableComment'] = valuecomment.toString();
    request.fields['allowAds'] = valueallowAds.toString();

    //userId,tagLine,description,address,postImage,uploadVideo,isVideo
    // request.files.add(await http.MultipartFile.fromPath(
    //     "image", widget.ImageFile.path));
    var response = await request.send();
    print('called1');
    var responsed = await http.Response.fromStream(response);
    print('response body${responsed.body}');
    final responseData = json.decode(responsed.body);

    if (response.statusCode == 200) {
      print("SUCCESS");
      print(response.reasonPhrase);
      print(widget.ImageFile.path);
      print(responseData);
      // hideLoader(context);
      await Get.to(Dashboard(page: 3));
    } else {
      print("ERROR");
    }
  }

  Future<void> _scaleDialog({
    required BuildContext context,
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
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(26.0))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 20),
                            child: SizedBox(
                              // height: height / 4,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(23),
                                    child: Image.asset(
                                      AssetUtils.share_icon3,
                                      fit: BoxFit.cover,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Text(
                                    "Are you sure want to share this post ?",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'PR',
                                        color: Colors.white),
                                  ),
                                  Align(
                                    alignment: FractionalOffset.bottomCenter,
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 40, horizontal: 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () async {
                                                setState(() {
                                                  draft = true;
                                                });
                                                showLoader(context);
                                                await uploadImage();

                                                hideLoader(context);
                                              },
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 0),
                                                // height: 45,
                                                // width:(width ?? 300) ,
                                                decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25)),
                                                child: Container(
                                                    alignment: Alignment.center,
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 12,
                                                        horizontal: 10),
                                                    child: const Text(
                                                      'Save Draft',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: 'PR',
                                                          fontSize: 16),
                                                    )),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () async {
                                                print('Share');
                                                setState(() {
                                                  draft = false;
                                                });
                                                showLoader(context);
                                                await uploadImage();
                                                hideLoader(context);
                                              },
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 0),
                                                // height: 45,
                                                // width:(width ?? 300) ,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25)),
                                                child: Container(
                                                    alignment: Alignment.center,
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 12,
                                                        horizontal: 10),
                                                    child: const Text(
                                                      'Share',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontFamily: 'PR',
                                                          fontSize: 16),
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
      }),
    );
  }
}
