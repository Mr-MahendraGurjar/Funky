import 'dart:convert';
import 'dart:io' as Io;
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:funky_new/video_recorder/lib/main.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
// import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../Utils/App_utils.dart';
import '../Utils/asset_utils.dart';
import '../Utils/colorUtils.dart';
import '../agora/agora_live_streaming.dart';
import '../chat_with_firebase/chats_page.dart';
import '../drawerScreen.dart';
import '../homepage/controller/homepage_controller.dart';
import '../homepage/ui/homepage_screen.dart';
import '../news_feed/new_feed_screen.dart';
import '../profile_screen/profile_screen.dart';
import '../search_screen/search_screen.dart';
import '../settings/settings_screen.dart';
import '../sharePreference.dart';
import 'advertisor/Advertisor_front.dart';
import 'draft_screen.dart';
import 'image_editor/image_editor_plus.dart';
import 'image_music_screen.dart';
import 'music_post_screen.dart';
import 'notification_screen.dart';
import 'post_screen.dart';

class Dashboard extends StatefulWidget {
  int page;

  Dashboard({super.key, required this.page});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  final HomepageController homepageController =
      Get.put(HomepageController(), tag: HomepageController().toString());

  late double screenHeight, screenWidth;

  // int widget.page = 0;
  String? appbar_name;

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit an App'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              ElevatedButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  void initState() {
    init();
    // **
    super.initState();
  }

  String? type_user;

  init() async {
    // await homepageController.getAllVideosList();
    // await homepageController.getAllImagesList();
    type_user = await PreferenceManager().getPref(URLConstants.type);
    print("type_user $type_user");
  }

  bool playing = true;

  Widget? get getPage {
    if (widget.page == 0) {
      return HomePageScreen(
        play: playing,
      );
    } else if (widget.page == 1) {
      return const SearchScreen();
    } else if (widget.page == 2) {
      return const NewsFeedScreen();
    } else if (widget.page == 3) {
      return const Profile_Screen();
    }
    return null;
  }

  VideoPlayerController? controller_last;

  File? imgFile;
  Uint8List? imageData;

  final imgPicker = ImagePicker();

  void openGallery() async {
    var imgGallery = await imgPicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imgFile = File(imgGallery!.path);
      imageData = imgFile!.readAsBytesSync();
      print(imageData);
    });
    // editedImage();
    // showLoader(context);

    // await VideoWidgetState.controller_last!.dispose();

    if (mounted && imgFile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageEditor(
            image: imageData,
          ),
        ),
      ).then((editedImage) async {
        if (editedImage != null) {
          setState(() {
            // imgFile = editedImage;
            String base64String = base64Encode(editedImage);
            final decodedBytes = base64Decode(base64String);
            var file = Io.File(imgFile!.path);
            file.writeAsBytesSync(decodedBytes);
            print(file.path.split('/').last);
            imgFile = file;
          });

          // Get.to(PostImagePreviewScreen(
          //   ImageFile: imgFile!,
          // ));
        }
      }).catchError((er) {
        print(er);
      });
    }
  }

  void openCamera() async {
    var imgCamera = await imgPicker.pickImage(source: ImageSource.camera);
    setState(() {
      imgFile = File(imgCamera!.path);

      imageData = imgFile!.readAsBytesSync();
      print(imageData);
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageEditor(
          image: imageData,
        ),
      ),
    ).then((editedImage) {
      if (editedImage != null) {
        setState(() {
          // imgFile = editedImage;
          String base64String = base64Encode(editedImage);
          final decodedBytes = base64Decode(base64String);
          var file = Io.File(imgFile!.path);
          file.writeAsBytesSync(decodedBytes);
          print(file.path.split('/').last);
          imgFile = file;
          Get.to(ImageMusicScreen(
            ImageData: imgFile!,
          ));
          // Get.to(PostImagePreviewScreen(
          //   ImageFile: imgFile!,
          // ));

          Navigator.pop(context);
        });
      }
    }).catchError((er) {
      print(er);
    });
  }

  videoRecorder() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => const SettingScreen()));
  }

  Future<void> pick_music() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3'],
    );
    if (result != null) {
      PlatformFile file = result.files.first;

      print(file.name);
      print(file.bytes);
      print(file.size);
      print(file.extension);
      print(file.path);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => MusicPostScreen(
                    musicFile: file,
                  )),
          (route) => false);
    } else {
      // User cancelled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    bool showFab = MediaQuery.of(context).viewInsets.bottom != 0;

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _globalKey,
      drawer: const DrawerScreen(),
      backgroundColor: HexColor(CommonColor.appBackColor),
      extendBodyBehindAppBar: true,
      appBar: (widget.page == 0 || widget.page == 1 || widget.page == 2)
          ? PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: AppBar(
                backgroundColor: Colors.transparent,
                title: (widget.page == 0
                    ? Image.asset(
                        AssetUtils.textLogo,
                        height: 15,
                      )
                    : (widget.page == 1
                        ? const Text(
                            'Discover',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontFamily: 'PB'),
                          )
                        : widget.page == 2
                            ? const Text(
                                "News Feed",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontFamily: 'PB'),
                              )
                            : const Text(
                                " ",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontFamily: 'PB'),
                              ))),
                centerTitle: true,
                actions: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const Notifications_screen()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 20.0, top: 0.0, bottom: 5.0),
                          child: ClipRRect(
                            child: Image.asset(
                              AssetUtils.noti_icon,
                              height: 20.0,
                              width: 20.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ChatsPage(),
                          ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 20.0, top: 0.0, bottom: 5.0),
                          child: ClipRRect(
                            child: Image.asset(
                              AssetUtils.chat_icon,
                              height: 20.0,
                              width: 20.0,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
                leadingWidth: 100,
                leading: Row(
                  children: [
                    Container(
                      margin:
                          const EdgeInsets.only(left: 16, top: 0, bottom: 0),
                      child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            _globalKey.currentState!.openDrawer();
                          },
                          icon: (Image.asset(
                            AssetUtils.drawer_icon,
                            color: Colors.white,
                            height: 12.0,
                            width: 19.0,
                            fit: BoxFit.contain,
                          ))),
                    ),
                    Expanded(
                      child: Container(
                        margin:
                            const EdgeInsets.only(left: 18, top: 0, bottom: 0),
                        child: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {},
                            icon: (Image.asset(
                              AssetUtils.logo_trans,
                              color: Colors.pinkAccent,
                              height: 20.0,
                              width: 20.0,
                              fit: BoxFit.contain,
                            ))),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   title: Text(
      //     "appbar_name",
      //     style:
      //     TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'PB'),
      //   ),
      //   centerTitle: true,
      //   actions: [
      //     Row(
      //       children: [
      //         InkWell(
      //           child: Padding(
      //             padding: const EdgeInsets.only(
      //                 right: 20.0, top: 0.0, bottom: 5.0),
      //             child: ClipRRect(
      //               child: Image.asset(
      //                 AssetUtils.noti_icon,
      //                 height: 20.0,
      //                 width: 20.0,
      //                 fit: BoxFit.cover,
      //               ),
      //             ),
      //           ),
      //         ),
      //         InkWell(
      //           child: Padding(
      //             padding: const EdgeInsets.only(
      //                 right: 20.0, top: 0.0, bottom: 5.0),
      //             child: ClipRRect(
      //               child: Image.asset(
      //                 AssetUtils.chat_icon,
      //                 height: 20.0,
      //                 width: 20.0,
      //                 fit: BoxFit.contain,
      //               ),
      //             ),
      //           ),
      //         ),
      //       ],
      //     )
      //   ],
      //   leadingWidth: 100,
      //   leading: Row(
      //     children: [
      //       Container(
      //         margin: EdgeInsets.only(left: 16, top: 0, bottom: 0),
      //         child: IconButton(
      //             padding: EdgeInsets.zero,
      //             onPressed: () {
      //               print('oject');
      //               _globalKey!.currentState!.openDrawer();
      //             },
      //             icon: (Image.asset(
      //               AssetUtils.drawer_icon,
      //               color: Colors.white,
      //               height: 12.0,
      //               width: 19.0,
      //               fit: BoxFit.contain,
      //             ))),
      //       ),
      //       Expanded(
      //         child: Container(
      //           margin: EdgeInsets.only(left: 18, top: 0, bottom: 0),
      //           child: IconButton(
      //               padding: EdgeInsets.zero,
      //               onPressed: () {},
      //               icon: (Image.asset(
      //                 AssetUtils.user_icon,
      //                 color: Colors.white,
      //                 height: 20.0,
      //                 width: 20.0,
      //                 fit: BoxFit.contain,
      //               ))),
      //         ),
      //       ),
      //     ],
      //   ),
      // )   ,
      // drawer: DrawerScreen(),

      bottomNavigationBar: Container(
        color: Colors.black,
        child: SizedBox(
          height: 80,
          child: BottomAppBar(
            padding: EdgeInsets.zero,
            child: Container(
              decoration: BoxDecoration(
                // color: Colors.red,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  // stops: [0.1, 0.5, 0.7, 0.9],
                  colors: [
                    HexColor("#C12265"),
                    HexColor("#000000"),
                    HexColor("#000000"),
                    // HexColor("#FFFFFF").withOpacity(0.67),
                  ],
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(left: 28.0),
                    decoration: BoxDecoration(
                        color: (widget.page == 0
                            ? Colors.white
                            : Colors.transparent),
                        borderRadius: BorderRadius.circular(50)),
                    child: IconButton(
                      visualDensity:
                          const VisualDensity(vertical: -4, horizontal: -4),
                      iconSize: 25.0,
                      icon: Image.asset(
                        AssetUtils.home_icon,
                        color: (widget.page == 0 ? Colors.black : Colors.white),
                        height: 20,
                        width: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          widget.page = 0;
                          // _myPage.jumpToPage(0);
                        });
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 28.0),
                    decoration: BoxDecoration(
                        color: (widget.page == 1
                            ? Colors.white
                            : Colors.transparent),
                        borderRadius: BorderRadius.circular(50)),
                    child: IconButton(
                      visualDensity:
                          const VisualDensity(vertical: -4, horizontal: -4),
                      iconSize: 25.0,
                      icon: Image.asset(
                        AssetUtils.search_icon,
                        color: (widget.page == 1 ? Colors.black : Colors.white),
                        height: 20,
                        width: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          widget.page = 1;
                          // _myPage.jumpToPage(1);
                        });
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 28.0),
                    decoration: BoxDecoration(
                        color: (widget.page == 2
                            ? Colors.white
                            : Colors.transparent),
                        borderRadius: BorderRadius.circular(50)),
                    child: IconButton(
                      visualDensity:
                          const VisualDensity(vertical: -4, horizontal: -4),
                      iconSize: 25.0,
                      icon: Image.asset(
                        AssetUtils.news_icon,
                        color: (widget.page == 2 ? Colors.black : Colors.white),
                        height: 20,
                        width: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          widget.page = 2;
                          // _myPage.jumpToPage(2);
                        });
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 28.0),
                    decoration: BoxDecoration(
                        color: (widget.page == 3
                            ? Colors.white
                            : Colors.transparent),
                        borderRadius: BorderRadius.circular(50)),
                    child: IconButton(
                      visualDensity:
                          const VisualDensity(vertical: -4, horizontal: -4),
                      iconSize: 25.0,
                      icon: Image.asset(
                        AssetUtils.user_icon2,
                        color: (widget.page == 3 ? Colors.black : Colors.white),
                        height: 20,
                        width: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          widget.page = 3;

                          // _myPage.jumpToPage(3);
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Visibility(
        visible: !showFab,
        child: Material(
          type: MaterialType.transparency,
          borderOnForeground: true,
          child: SizedBox(
            height: 70,
            width: 70,
            child: Stack(
              children: [
                const MyArc(diameter: 80),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 60.79,
                    width: 60.79,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.white.withOpacity(0.2), width: 10),
                      borderRadius: BorderRadius.circular(50),
                      // color: Colors.grey
                    ),
                    child: SizedBox(
                      height: 45.79,
                      width: 45.79,
                      child: FittedBox(
                        child: FloatingActionButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          backgroundColor: Colors.white,
                          onPressed: () async {
                            // VideoWidgetState.controller_last!.pause();
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                double width =
                                    MediaQuery.of(context).size.width;
                                double height =
                                    MediaQuery.of(context).size.height;
                                return BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: AlertDialog(
                                      backgroundColor: Colors.transparent,
                                      contentPadding: EdgeInsets.zero,
                                      elevation: 0.0,
                                      // title: Center(child: Text("Evaluation our APP")),
                                      content: Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 110, horizontal: 70),
                                        // color: Colors.yellow,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          // mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              // height: 115,
                                              // width: 133,
                                              // padding: const EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin: const Alignment(
                                                        -1.0, 0.0),
                                                    end: const Alignment(
                                                        1.0, 0.0),
                                                    transform:
                                                        const GradientRotation(
                                                            0.7853982),
                                                    // stops: [0.1, 0.5, 0.7, 0.9],
                                                    colors: [
                                                      HexColor("#000000"),
                                                      HexColor("#000000"),
                                                      HexColor(
                                                          CommonColor.pinkFont),
                                                      HexColor("#ffffff"),
                                                      // HexColor("#FFFFFF").withOpacity(0.67),
                                                    ],
                                                  ),
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      color: Colors.white,
                                                      width: 1),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(
                                                              26.0))),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 15.0,
                                                        horizontal: 25),
                                                child:
                                                    (type_user == 'Advertiser'
                                                        ? Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () {
                                                                  print('name');

                                                                  Navigator.pushAndRemoveUntil(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              const Draft_screen()),
                                                                      (route) =>
                                                                          false); // Pickvideo();

                                                                  // Get.to(Advertisor_front());
                                                                },
                                                                child:
                                                                    const Text(
                                                                  'Draft',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontFamily:
                                                                          'PR',
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                              Container(
                                                                margin: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        20),
                                                                child:
                                                                    const Divider(
                                                                  color: Colors
                                                                      .black,
                                                                  height: 20,
                                                                ),
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  print('name');

                                                                  Navigator.of(context).pushAndRemoveUntil(
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              const Advertisor_front()),
                                                                      (route) =>
                                                                          false);

                                                                  // Get.to(Advertisor_front());
                                                                },
                                                                child:
                                                                    const Text(
                                                                  'Advertise',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontFamily:
                                                                          'PR',
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        : Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () {
                                                                  print('name');
                                                                  // Get.to(PostScreen());
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (ctx) =>
                                                                            BackdropFilter(
                                                                      filter: ImageFilter.blur(
                                                                          sigmaX:
                                                                              10,
                                                                          sigmaY:
                                                                              10),
                                                                      child:
                                                                          AlertDialog(
                                                                        backgroundColor:
                                                                            Colors.transparent,
                                                                        contentPadding:
                                                                            EdgeInsets.zero,
                                                                        elevation:
                                                                            0.0,
                                                                        content:
                                                                            Container(
                                                                          margin: const EdgeInsets
                                                                              .symmetric(
                                                                              vertical: 10,
                                                                              horizontal: 0),
                                                                          // height:
                                                                          //     screenHeight /
                                                                          //         5,
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
                                                                                  HexColor(CommonColor.pinkFont),
                                                                                  HexColor("#ffffff"),
                                                                                  // HexColor("#FFFFFF").withOpacity(0.67),
                                                                                ],
                                                                              ),
                                                                              color: Colors.white,
                                                                              border: Border.all(color: Colors.white, width: 1),
                                                                              borderRadius: const BorderRadius.all(Radius.circular(26.0))),
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            children: [
                                                                              Container(
                                                                                margin: const EdgeInsets.symmetric(vertical: 10),
                                                                                child: Column(
                                                                                  children: [
                                                                                    SizedBox(
                                                                                      width: MediaQuery.of(context).size.width / 2,
                                                                                      child: Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                        children: [
                                                                                          Column(
                                                                                            children: [
                                                                                              IconButton(
                                                                                                icon: const Icon(
                                                                                                  Icons.camera_alt,
                                                                                                  size: 30,
                                                                                                  color: Colors.white,
                                                                                                ),
                                                                                                onPressed: () {
                                                                                                  Navigator.of(context).pushAndRemoveUntil(
                                                                                                      MaterialPageRoute(
                                                                                                          builder: (context) => const MyApp_video(
                                                                                                                story: false,
                                                                                                              )),
                                                                                                      (Route<dynamic> route) => false);
                                                                                                },
                                                                                              ),
                                                                                              Container(
                                                                                                child: const Padding(
                                                                                                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                                                                                                  child: Text(
                                                                                                    'Camera',
                                                                                                    style: TextStyle(fontSize: 15, fontFamily: 'PR', color: Colors.white),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                          Column(
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
                                                                                                  setState(() {
                                                                                                    playing = false;
                                                                                                  });
                                                                                                  print(playing);

                                                                                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const Post_screen()), (route) => false); // Pickvideo();
                                                                                                },
                                                                                              ),
                                                                                              Container(
                                                                                                // decoration: BoxDecoration(
                                                                                                //     borderRadius: BorderRadius.circular(20),
                                                                                                //   border: Border.all(color: Colors.white,width: 1),
                                                                                                // ),
                                                                                                child: const Padding(
                                                                                                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                                                                                                  child: Text(
                                                                                                    'Gallery',
                                                                                                    style: TextStyle(fontSize: 15, fontFamily: 'PR', color: Colors.white),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    const SizedBox(
                                                                                      height: 10,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: MediaQuery.of(context).size.width / 2,
                                                                                      child: Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                        children: [
                                                                                          Column(
                                                                                            children: [
                                                                                              IconButton(
                                                                                                icon: const Icon(
                                                                                                  Icons.drafts,
                                                                                                  size: 30,
                                                                                                  color: Colors.white,
                                                                                                ),
                                                                                                onPressed: () {
                                                                                                  Navigator.pop(context);

                                                                                                  // image_Gallery();
                                                                                                  setState(() {
                                                                                                    playing = false;
                                                                                                  });
                                                                                                  print(playing);

                                                                                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const Draft_screen()), (route) => false); // Pickvideo();
                                                                                                },
                                                                                              ),
                                                                                              Container(
                                                                                                // decoration: BoxDecoration(
                                                                                                //     borderRadius: BorderRadius.circular(20),
                                                                                                //   border: Border.all(color: Colors.white,width: 1),
                                                                                                // ),
                                                                                                child: const Padding(
                                                                                                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                                                                                                  child: Text(
                                                                                                    'Draft',
                                                                                                    style: TextStyle(fontSize: 15, fontFamily: 'PR', color: Colors.white),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                          Column(
                                                                                            children: [
                                                                                              IconButton(
                                                                                                icon: const Icon(
                                                                                                  Icons.library_music_sharp,
                                                                                                  size: 30,
                                                                                                  color: Colors.white,
                                                                                                ),
                                                                                                onPressed: () {
                                                                                                  pick_music();
                                                                                                  // Navigator.pushAndRemoveUntil(
                                                                                                  //     context,
                                                                                                  //     MaterialPageRoute(builder: (context) => MusicPostScreen(
                                                                                                  //       // musicFile: file,
                                                                                                  //     )),
                                                                                                  //         (route) => false);
                                                                                                  Navigator.pop(context);

                                                                                                  // image_Gallery();
                                                                                                  setState(() {
                                                                                                    playing = false;
                                                                                                  });
                                                                                                  print(playing);
                                                                                                },
                                                                                              ),
                                                                                              Container(
                                                                                                // decoration: BoxDecoration(
                                                                                                //     borderRadius: BorderRadius.circular(20),
                                                                                                //     border: Border.all(color: Colors.white,width: 1),
                                                                                                // ),
                                                                                                child: const Padding(
                                                                                                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                                                                                                  child: Text(
                                                                                                    'Music',
                                                                                                    style: TextStyle(fontSize: 15, fontFamily: 'PR', color: Colors.white),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ],
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
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                                child:
                                                                    const Text(
                                                                  'Post',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontFamily:
                                                                          'PR',
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                              Container(
                                                                margin: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        20),
                                                                child:
                                                                    const Divider(
                                                                  color: Colors
                                                                      .black,
                                                                  height: 20,
                                                                ),
                                                              ),
                                                              GestureDetector(
                                                                onTap:
                                                                    () async {
                                                                  Get.to(() =>
                                                                      const LiveStreamPage());
                                                                },
                                                                child:
                                                                    const Text(
                                                                  'Live',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontFamily:
                                                                          'PR',
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            ],
                                                          )),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                );
                              },
                            );
                          },
                          tooltip: 'Increment',
                          elevation: 0.0,
                          child: const Icon(
                            Icons.add_rounded,
                            color: Colors.black,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                child: getPage!,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> font_family = [
    'Alegreya',
    'B612',
    'TitilliumWeb',
    'Varela',
    'Vollkorn',
    'Rakkas',
    'ConcertOne',
    'YatraOne',
    'OldStandardTT',
    'Neonderthaw',
    'DancingScript',
    'SedgwickAve',
    'IndieFlower',
    'Sacramento',
    'PressStart2P',
    'FrederickatheGreat',
    'ReenieBeanie',
    'BungeeShade',
    'UnifrakturMaguntia',
  ];
}

class MyArc extends StatelessWidget {
  final double diameter;

  const MyArc({super.key, this.diameter = 200});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MyPainter(),
      size: Size(diameter, diameter),
    );
  }
}

// This is the Painter class
class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = HexColor('#C12265');
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.height / 2, size.width / 2),
        height: size.height,
        width: size.width,
      ),
      math.pi,
      math.pi,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class MyArc2 extends StatelessWidget {
  final double diameter;

  const MyArc2({super.key, this.diameter = 450});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MyPainter2(),
      size: Size(diameter, diameter),
    );
  }
}

// This is the Painter class
class MyPainter2 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.transparent;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.height / 10, size.width / 2),
        height: size.height,
        width: size.width,
      ),
      math.pi * 1.5,
      math.pi * 2.5,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class MyArc3 extends StatelessWidget {
  final double diameter;

  const MyArc3({super.key, this.diameter = 550});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MyPainter3(),
      size: Size(diameter, diameter),
    );
  }
}

class MyPainter3 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..shader = RadialGradient(
        colors: [
          HexColor('#C12265').withOpacity(0.8),
          HexColor('#000000').withOpacity(0.5),
        ],
      ).createShader(Rect.fromCircle(
        center: const Offset(1, 0),
        radius: 100,
      ));
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.height / 10, size.width / 2),
        height: size.height,
        width: size.width,
      ),
      math.pi * 1.5,
      math.pi * 2.5,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
