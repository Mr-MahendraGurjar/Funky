import 'dart:io';

import 'package:flutter/material.dart';
import 'package:funky_new/Utils/colorUtils.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'banner_image_payment.dart';

class BannerScreen extends StatefulWidget {
  File imageFile;

  BannerScreen({Key? key, required this.imageFile}) : super(key: key);

  @override
  State<BannerScreen> createState() => _BannerScreenState();
}

class _BannerScreenState extends State<BannerScreen> {
  bool discovery = false;
  bool live = false;
  bool news_feed = false;
  bool aid = false;
  File? imgFile;
  final imgPicker = ImagePicker();

  void openGallery() async {
    var imgGallery = await imgPicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imgFile = File(imgGallery!.path);
    });
    await _cropImage_banner();
    // await _cropImage_logo();
  }

  void openCamera() async {
    var imgGallery = await imgPicker.pickImage(source: ImageSource.camera);
    setState(() {
      imgFile = File(imgGallery!.path);
    });
    await _cropImage_banner();

    // await _cropImage_logo();
  }

  Future<void> _cropImage_banner() async {
    var croppedFile = await ImageCropper().cropImage(
      sourcePath: imgFile!.path,
      aspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 9),
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
        widget.imageFile = File(croppedFile.path);
        // imgFile = File(croppedFile.path);
        // state = AppState.cropped;
      });
      print(imgFile!.path);
    }
  }

  late double screenHeight, screenWidth;

  TextEditingController month_controller = TextEditingController();
  int data_ = 0;
  double? final_ammount;

  @override
  void initState() {
    month_controller.text = '5';
    calculate();
    super.initState();
  }

  Future<void> calculate() async {
    var _value =
        (data_ * double.parse(month_controller.text.toString())) * 2000;
    var tax = (_value * 18) / 100;
    setState(() {
      final_ammount = _value + tax;
    });
  }

  List locations = [];

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              // stops: [0.1, 0.5, 0.7, 0.9],
              colors: [
                HexColor("#000000"),
                HexColor("#000000"),
                const Color(0xFF941414),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: AppBar(
                backgroundColor: Colors.transparent,
                title: const Text(
                  "Your Banner",
                  style: TextStyle(
                      fontSize: 16, color: Colors.white, fontFamily: 'PB'),
                ),
                centerTitle: true,
                leadingWidth: 100,
              ),
            ),
            body: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Column(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.file(widget.imageFile)),
                    const SizedBox(
                      height: 20,
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
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 0),
                              height: screenHeight / 5,
                              // width: 133,
                              // padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: const Alignment(-1.0, 0.0),
                                    end: const Alignment(1.0, 0.0),
                                    transform:
                                        const GradientRotation(0.7853982),
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
                                  border:
                                      Border.all(color: Colors.white, width: 1),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(26.0))),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 10),
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
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 0),
                                                    // height: 45,
                                                    // width:(width ?? 300) ,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.white,
                                                            width: 1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25)),
                                                    child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                            vertical: 12,
                                                            horizontal: 20),
                                                        child: const Text(
                                                          'Camera',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily: 'PR',
                                                              fontSize: 16),
                                                        )),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
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
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 0),
                                                    // height: 45,
                                                    // width:(width ?? 300) ,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.white,
                                                            width: 1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25)),
                                                    child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                            vertical: 12,
                                                            horizontal: 20),
                                                        child: const Text(
                                                          'Gallery',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily: 'PR',
                                                              fontSize: 16),
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
                      child: const Text(
                        'Change banner',
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontFamily: 'PB'),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 25),
                      child: Text(
                        'Choose Location',
                        style: TextStyle(
                            fontSize: 16,
                            color: HexColor(CommonColor.orange),
                            fontFamily: 'PB'),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 50),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Theme(
                                  data: ThemeData(
                                    unselectedWidgetColor: Colors.white,
                                    //accentColor: Colors.white,
                                  ),
                                  child: Checkbox(
                                    visualDensity: const VisualDensity(
                                      vertical: -4,
                                    ),
                                    checkColor: Colors.black,
                                    value: discovery,
                                    onChanged: (value) async {
                                      setState(() {
                                        discovery = value!;
                                      });
                                      if (discovery) {
                                        data_++;
                                        print(data_);
                                        await calculate();
                                        locations.add("Discover section");
                                        print(locations);
                                      } else {
                                        data_--;
                                        print(data_);
                                        await calculate();
                                        if (locations
                                            .contains("Discover section")) {
                                          locations.remove("Discover section");
                                          print(locations);
                                        }
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ), //SizedBox
                                const Text(
                                  'Discover section',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontFamily: 'PM'),
                                ),
                                //Checkbox
                              ], //<Widget>[]
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Theme(
                                  data: ThemeData(
                                    unselectedWidgetColor: Colors.white,
                                    //accentColor: Colors.white,
                                  ),
                                  child: Checkbox(
                                    visualDensity: const VisualDensity(
                                      vertical: -4,
                                    ),
                                    checkColor: Colors.black,
                                    value: live,
                                    onChanged: (value) async {
                                      setState(() {
                                        live = value!;
                                      });
                                      if (live) {
                                        data_++;
                                        print(data_);
                                        await calculate();
                                        locations.add("Live section");
                                        print(locations);
                                      } else {
                                        data_--;
                                        print(data_);
                                        await calculate();
                                        if (locations
                                            .contains("Live section")) {
                                          locations.remove("Live section");
                                          print(locations);
                                        }
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ), //SizedBox
                                const Text(
                                  'Live section',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontFamily: 'PM'),
                                ),
                                //Checkbox
                              ], //<Widget>[]
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,

                              children: <Widget>[
                                Theme(
                                  data: ThemeData(
                                    unselectedWidgetColor: Colors.white,
                                    // accentColor: Colors.white,
                                  ),
                                  child: Checkbox(
                                    visualDensity: const VisualDensity(
                                      vertical: -4,
                                    ),
                                    checkColor: Colors.black,
                                    value: news_feed,
                                    onChanged: (value) async {
                                      setState(() {
                                        news_feed = value!;
                                      });
                                      if (news_feed) {
                                        data_++;
                                        print(data_);
                                        await calculate();
                                        locations.add("News Feed section");
                                        print(locations);
                                      } else {
                                        data_--;
                                        print(data_);
                                        await calculate();
                                        if (locations
                                            .contains("News Feed section")) {
                                          locations.remove("News Feed section");
                                          print(locations);
                                        }
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ), //SizedBox
                                const Text(
                                  'News Feed section',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontFamily: 'PM'),
                                ),
                                //Checkbox
                              ], //<Widget>[]
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,

                              children: <Widget>[
                                Theme(
                                  data: ThemeData(
                                    unselectedWidgetColor: Colors.white,
                                    //accentColor: Colors.white,
                                  ),
                                  child: Checkbox(
                                    visualDensity: const VisualDensity(
                                      vertical: -4,
                                    ),
                                    checkColor: Colors.black,
                                    value: aid,
                                    onChanged: (value) async {
                                      setState(() {
                                        aid = value!;
                                      });
                                      if (aid) {
                                        data_++;
                                        print(data_);
                                        await calculate();
                                        locations.add("Ad section");
                                        print(locations);
                                      } else {
                                        data_--;
                                        print(data_);
                                        await calculate();
                                        if (locations.contains("Ad section")) {
                                          locations.remove("Ad section");
                                          print(locations);
                                        }
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ), //SizedBox
                                const Text(
                                  'Ad section',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontFamily: 'PM'),
                                ),
                                //Checkbox
                              ], //<Widget>[]
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      child: Text(
                        'Enter the duration in months',
                        style: TextStyle(
                            fontSize: 16,
                            color: HexColor(CommonColor.orange),
                            fontFamily: 'PB'),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white, width: 1)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                  color: Colors.transparent),
                              width: 50,
                              child: TextFormField(
                                maxLength: 1,
                                onChanged: (value) {
                                  calculate();
                                },
                                // enabled: enabled,
                                // validator: validator,
                                maxLines: 1,
                                // onTap: tap,
                                decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 0),
                                  // <-- SEE HERE
                                  // alignLabelWithHint: false,
                                  // isDense: true,

                                  // hintText: '5',
                                  counterStyle: TextStyle(
                                    height: double.minPositive,
                                  ),
                                  counterText: "",
                                  // filled: true,
                                  border: InputBorder.none,
                                  // focusedBorder: OutlineInputBorder(
                                  //   borderSide:
                                  //   BorderSide(color: ColorUtils.blueColor, width: 1),
                                  //   borderRadius: BorderRadius.all(Radius.circular(10)),
                                  // ),
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'PB',
                                    color: Colors.grey,
                                  ),
                                ),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'PR',
                                  color: Colors.white,
                                ),
                                controller: month_controller,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            Container(
                              color: Colors.white,
                              width: 1.5,
                              height: 30,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                'months',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: HexColor(CommonColor.pinkFont),
                                    fontFamily: 'PB'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: const Text(
                        '1 month = 2000 USD +',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontFamily: 'PB'),
                      ),
                    ),
                    Container(
                      child: const Text(
                        '18% tax and service charges',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontFamily: 'PB'),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white, width: 1)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 20),
                        child: Text(
                          '$final_ammount USD',
                          style: TextStyle(
                              fontSize: 16,
                              color: HexColor(CommonColor.pinkFont),
                              fontFamily: 'PB'),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        print(locations.join(','));
                        Get.to(Banner_payment(
                          banner_image: widget.imageFile,
                          location: locations.join(','),
                          // location:  locations.toString().replaceAll('[','').replaceAll(']',''),
                          price: final_ammount!.toStringAsFixed(2),
                          currency: 'USD',
                          month: month_controller.text,
                          place_location: 'Ahmedabad',
                        ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: HexColor(CommonColor.pinkFont),
                            border: Border.all(
                                color: HexColor(CommonColor.pinkFont),
                                width: 1.5),
                            borderRadius: BorderRadius.circular(30)),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                          child: Text(
                            'Make a payment',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontFamily: 'PM'),
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
        ),
      ],
    );
  }
}
