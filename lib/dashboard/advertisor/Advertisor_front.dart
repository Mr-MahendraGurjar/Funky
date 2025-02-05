import 'dart:io';

import 'package:flutter/material.dart';
import 'package:funky_new/dashboard/advertisor/brand_logo/brand_logo_screen.dart';
import 'package:funky_new/dashboard/dashboard_screen.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../Utils/asset_utils.dart';
import 'banner_image/banner_image_screen.dart';
import 'commercial_video/video_post.dart';

class Advertisor_front extends StatefulWidget {
  const Advertisor_front({Key? key}) : super(key: key);

  @override
  State<Advertisor_front> createState() => _Advertisor_frontState();
}

class _Advertisor_frontState extends State<Advertisor_front> {
  late double screenHeight, screenWidth;
  File? imgFile;
  final imgPicker = ImagePicker();
  bool isLogo = false;

  void openGallery() async {
    var imgGallery = await imgPicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imgFile = File(imgGallery!.path);
    });
    (isLogo ? await _cropImage_logo() : await _cropImage_banner());
    // await _cropImage_logo();
  }

  void openCamera() async {
    var imgGallery = await imgPicker.pickImage(source: ImageSource.camera);
    setState(() {
      imgFile = File(imgGallery!.path);
    });
    (isLogo ? await _cropImage_logo() : await _cropImage_banner());

    // await _cropImage_logo();
  }

  Future<void> _cropImage_logo() async {
    var croppedFile = await ImageCropper().cropImage(
      sourcePath: imgFile!.path,
      // aspectRatioPresets: Platform.isAndroid
      //     ? [
      //   CropAspectRatioPreset.square,
      //   CropAspectRatioPreset.ratio3x2,
      //   CropAspectRatioPreset.original,
      //   CropAspectRatioPreset.ratio4x3,
      //   CropAspectRatioPreset.ratio16x9
      // ]
      //     : [
      //   CropAspectRatioPreset.original,
      //   CropAspectRatioPreset.square,
      //   CropAspectRatioPreset.ratio3x2,
      //   CropAspectRatioPreset.ratio4x3,
      //   CropAspectRatioPreset.ratio5x3,
      //   CropAspectRatioPreset.ratio5x4,
      //   CropAspectRatioPreset.ratio7x5,
      //   CropAspectRatioPreset.ratio16x9
      // ],
      // cropStyle: CropStyle,

      aspectRatio: CropAspectRatio(ratioX: 32, ratioY: 9),
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
          resetButtonHidden: false,
          // rotateButtonsHidden: true,
          aspectRatioLockEnabled: true,
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );

    if (croppedFile != null) {
      setState(() {
        imgFile = File(croppedFile.path);
        // state = AppState.cropped;
      });

      Get.to(BrandLogoScreen(imageFile: File(croppedFile.path)));

      print(imgFile!.path);
    }
  }

  Future<void> _cropImage_banner() async {
    var croppedFile = await ImageCropper().cropImage(
      sourcePath: imgFile!.path,
      aspectRatio: CropAspectRatio(ratioX: 16, ratioY: 9),
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
            title: 'Cropper',
            resetButtonHidden: false,
            // rotateButtonsHidden: true,
            aspectRatioLockEnabled: true),
        WebUiSettings(
          context: context,
        ),
      ],
    );

    if (croppedFile != null) {
      setState(() {
        imgFile = File(croppedFile.path);
        // state = AppState.cropped;
      });
      await Get.to(BannerScreen(imageFile: File(croppedFile.path)));
      print(imgFile!.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                AssetUtils.backgroundImage3,
              ),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: AppBar(
              backgroundColor: Colors.transparent,
              title: Text(
                "Advertise your brand",
                style: const TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'PB'),
              ),
              centerTitle: true,
              // leadingWidth: 100,
              leading: Container(
                margin: const EdgeInsets.only(left: 15, top: 0, bottom: 0),
                child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Get.to(Dashboard(page: 0));
                      // Navigator.pop(context);
                      setState(() {});
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    )),
              ),
            ),
          ),
          body: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(children: [
                  Image.asset(AssetUtils.advertisor_logo_f),
                  SizedBox(
                    height: 40,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isLogo = true;
                      });
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          backgroundColor: Colors.transparent,
                          contentPadding: EdgeInsets.zero,
                          elevation: 0.0,
                          content: Container(
                            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                            height: screenHeight / 5,
                            // width: 133,
                            // padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: const Alignment(-1.0, 0.0),
                                  end: const Alignment(1.0, 0.0),
                                  transform: const GradientRotation(0.7853982),
                                  // stops: [0.1, 0.5, 0.7, 0.9],
                                  colors: [
                                    HexColor("#000000"),
                                    HexColor("#000000"),
                                    HexColor("##E84F90"),
                                    HexColor("#ffffff"),
                                    // HexColor("#FFFFFF").withOpacity(0.67),
                                  ],
                                ),
                                color: Colors.white,
                                border: Border.all(color: Colors.white, width: 1),
                                borderRadius: const BorderRadius.all(Radius.circular(26.0))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(vertical: 10),
                                      child: Row(
                                        // mainAxisAlignment:
                                        // MainAxisAlignment
                                        //     .center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              openCamera();
                                              Navigator.pop(context);
                                              // video_upload();
                                            },
                                            child: Column(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.camera_alt,
                                                    size: 30,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () {
                                                    openCamera();
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.symmetric(horizontal: 0),
                                                  // height: 45,
                                                  // width:(width ?? 300) ,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(color: Colors.white, width: 1),
                                                      borderRadius: BorderRadius.circular(25)),
                                                  child: Container(
                                                      alignment: Alignment.center,
                                                      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                                                      child: Text(
                                                        'Camera',
                                                        style: TextStyle(
                                                            color: Colors.white, fontFamily: 'PR', fontSize: 16),
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              openGallery();
                                              // image_upload();
                                              // Navigator.pop(context);
                                              // Get.to(Post_screen());
                                              // image_Gallery();
                                            },
                                            child: Column(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.photo_library_sharp,
                                                    size: 30,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () {
                                                    openGallery();
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.symmetric(horizontal: 0),
                                                  // height: 45,
                                                  // width:(width ?? 300) ,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(color: Colors.white, width: 1),
                                                      borderRadius: BorderRadius.circular(25)),
                                                  child: Container(
                                                      alignment: Alignment.center,
                                                      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                                                      child: Text(
                                                        'Gallery',
                                                        style: TextStyle(
                                                            color: Colors.white, fontFamily: 'PR', fontSize: 16),
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),

                                          // IconButton(
                                          //   icon: const Icon(
                                          //     Icons
                                          //         .video_call,
                                          //     size: 40,
                                          //     color: Colors
                                          //         .grey,
                                          //   ),
                                          //   onPressed:
                                          //       () {
                                          //         video_upload();
                                          //       },
                                          // ),
                                        ],
                                      ),
                                    )

                                    // const SizedBox(
                                    //   height: 10,
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 17),
                        child: Text(
                          "UPLOAD BRAND LOGO",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15, color: Colors.black, fontFamily: 'PB'),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    child: Text(
                      'Logo size should be 370*90 px',
                      style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'PM'),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isLogo = false;
                      });
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          backgroundColor: Colors.transparent,
                          contentPadding: EdgeInsets.zero,
                          elevation: 0.0,
                          content: Container(
                            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                            height: screenHeight / 5,
                            // width: 133,
                            // padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: const Alignment(-1.0, 0.0),
                                  end: const Alignment(1.0, 0.0),
                                  transform: const GradientRotation(0.7853982),
                                  // stops: [0.1, 0.5, 0.7, 0.9],
                                  colors: [
                                    HexColor("#000000"),
                                    HexColor("#000000"),
                                    HexColor("##E84F90"),
                                    HexColor("#ffffff"),
                                    // HexColor("#FFFFFF").withOpacity(0.67),
                                  ],
                                ),
                                color: Colors.white,
                                border: Border.all(color: Colors.white, width: 1),
                                borderRadius: const BorderRadius.all(Radius.circular(26.0))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(vertical: 10),
                                      child: Row(
                                        // mainAxisAlignment:
                                        // MainAxisAlignment
                                        //     .center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              openCamera();
                                              Navigator.pop(context);
                                              // video_upload();
                                            },
                                            child: Column(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.camera_alt,
                                                    size: 30,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () {
                                                    openCamera();
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.symmetric(horizontal: 0),
                                                  // height: 45,
                                                  // width:(width ?? 300) ,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(color: Colors.white, width: 1),
                                                      borderRadius: BorderRadius.circular(25)),
                                                  child: Container(
                                                      alignment: Alignment.center,
                                                      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                                                      child: Text(
                                                        'Camera',
                                                        style: TextStyle(
                                                            color: Colors.white, fontFamily: 'PR', fontSize: 16),
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              openGallery();
                                              // image_upload();
                                              // Navigator.pop(context);
                                              // Get.to(Post_screen());
                                              // image_Gallery();
                                            },
                                            child: Column(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.photo_library_sharp,
                                                    size: 30,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () {
                                                    openGallery();
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.symmetric(horizontal: 0),
                                                  // height: 45,
                                                  // width:(width ?? 300) ,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(color: Colors.white, width: 1),
                                                      borderRadius: BorderRadius.circular(25)),
                                                  child: Container(
                                                      alignment: Alignment.center,
                                                      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                                                      child: Text(
                                                        'Gallery',
                                                        style: TextStyle(
                                                            color: Colors.white, fontFamily: 'PR', fontSize: 16),
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),

                                          // IconButton(
                                          //   icon: const Icon(
                                          //     Icons
                                          //         .video_call,
                                          //     size: 40,
                                          //     color: Colors
                                          //         .grey,
                                          //   ),
                                          //   onPressed:
                                          //       () {
                                          //         video_upload();
                                          //       },
                                          // ),
                                        ],
                                      ),
                                    )

                                    // const SizedBox(
                                    //   height: 10,
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white, width: 1.5),
                          color: HexColor("#3d3a57")),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 17),
                        child: Text(
                          "SELECT YOUR BANNER",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15, color: Colors.white, fontFamily: 'PB'),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    child: Text(
                      'Banner size should be 370*180 px',
                      style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'PM'),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          backgroundColor: Colors.transparent,
                          contentPadding: EdgeInsets.zero,
                          elevation: 0.0,
                          content: Container(
                            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                            height: screenHeight / 5,
                            // width: 133,
                            // padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: const Alignment(-1.0, 0.0),
                                  end: const Alignment(1.0, 0.0),
                                  transform: const GradientRotation(0.7853982),
                                  // stops: [0.1, 0.5, 0.7, 0.9],
                                  colors: [
                                    HexColor("#000000"),
                                    HexColor("#000000"),
                                    HexColor("##E84F90"),
                                    HexColor("#ffffff"),
                                    // HexColor("#FFFFFF").withOpacity(0.67),
                                  ],
                                ),
                                color: Colors.white,
                                border: Border.all(color: Colors.white, width: 1),
                                borderRadius: const BorderRadius.all(Radius.circular(26.0))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(vertical: 10),
                                      child: Row(
                                        // mainAxisAlignment:
                                        // MainAxisAlignment
                                        //     .center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              // video_upload();
                                              // Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //       builder: (context) => MyApp_video(
                                              //         story: false,
                                              //       )),
                                              // );
                                            },
                                            child: Column(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.camera_alt,
                                                    size: 30,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () {
                                                    // video_upload();
                                                    // Navigator.push(
                                                    //   context,
                                                    //   MaterialPageRoute(
                                                    //       builder: (context) => MyApp_video(
                                                    //             story: false,
                                                    //           )),
                                                    // );
                                                    // Navigator.of(context).pushAndRemoveUntil(
                                                    //     MaterialPageRoute(
                                                    //         builder: (context) => MyApp_video(
                                                    //           story: false,
                                                    //         )),
                                                    //         (Route<dynamic> route) => false);
                                                  },
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.symmetric(horizontal: 0),
                                                  // height: 45,
                                                  // width:(width ?? 300) ,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(color: Colors.white, width: 1),
                                                      borderRadius: BorderRadius.circular(25)),
                                                  child: Container(
                                                      alignment: Alignment.center,
                                                      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                                                      child: Text(
                                                        'Camera',
                                                        style: TextStyle(
                                                            color: Colors.white, fontFamily: 'PR', fontSize: 16),
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              // image_upload();
                                              // Navigator.pop(context);
                                              // Get.to(Post_screen());
                                              // setState(() {
                                              //   playing = false;
                                              // });
                                              // print(playing);
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => CommercialVideoPost()),
                                                  (route) => false);

                                              // image_Gallery();
                                            },
                                            child: Column(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.photo_library_sharp,
                                                    size: 30,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);

                                                    // image_Gallery();
                                                    // setState(() {
                                                    //   playing = false;
                                                    // });
                                                    // print(playing);

                                                    Navigator.pushAndRemoveUntil(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => CommercialVideoPost()),
                                                        (route) => false); // Pickvideo();
                                                  },
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.symmetric(horizontal: 0),
                                                  // height: 45,
                                                  // width:(width ?? 300) ,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(color: Colors.white, width: 1),
                                                      borderRadius: BorderRadius.circular(25)),
                                                  child: Container(
                                                      alignment: Alignment.center,
                                                      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                                                      child: Text(
                                                        'Gallery',
                                                        style: TextStyle(
                                                            color: Colors.white, fontFamily: 'PR', fontSize: 16),
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),

                                          // IconButton(
                                          //   icon: const Icon(
                                          //     Icons
                                          //         .video_call,
                                          //     size: 40,
                                          //     color: Colors
                                          //         .grey,
                                          //   ),
                                          //   onPressed:
                                          //       () {
                                          //         video_upload();
                                          //       },
                                          // ),
                                        ],
                                      ),
                                    )

                                    // const SizedBox(
                                    //   height: 10,
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white, width: 1.5),
                          color: HexColor("#121c33")),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 17),
                        child: Text(
                          "COMMERCIAL VIDEO",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15, color: Colors.white, fontFamily: 'PB'),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    child: Text(
                      '60S and below = 2 USD/FC',
                      style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'PM'),
                    ),
                  ),
                  Container(
                    child: Text(
                      '60S to 120S = 3.5 USD/FC',
                      style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'PM'),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ]),
              )),
        ),
      ],
    );
  }
}
