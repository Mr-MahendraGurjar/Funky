import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

import '../../Utils/App_utils.dart';
import '../../sharePreference.dart';
import '../Utils/asset_utils.dart';
import '../Utils/colorUtils.dart';
import 'advertisor/commercial_video/commercial_video_screen.dart';
import 'dashboard_screen.dart';
import 'tag_people_search.dart';

class PostVideoPreviewScreen extends StatefulWidget {
  final File videoFile;
  final bool creator;
  final File cover_image;

  // final String? music_name;
  // final bool? camera;

  const PostVideoPreviewScreen({
    super.key,
    required this.videoFile,
    required this.creator,
    required this.cover_image,
    // this.music_name,
    // this.camera
  });

  @override
  State<PostVideoPreviewScreen> createState() => _PostVideoPreviewScreenState();
}

class _PostVideoPreviewScreenState extends State<PostVideoPreviewScreen> {
  bool valuedownload = false;
  bool valuecomment = false;
  bool valueallowAds = false;

  TextEditingController description_controller = TextEditingController();

  VideoPlayerController? video_controller;

  final bool _onTouch = false;
  Timer? _timer;
  bool isClicked = false; // boolean that states if the button is pressed or not

  @override
  void initState() {
    print(widget.cover_image.path);
    video_controller = VideoPlayerController.file(widget.videoFile);

    video_controller!.setLooping(true);
    video_controller!.initialize().then((_) {
      setState(() {
        // done = true;
      });
      // hideLoader(context);
    });
    video_controller!.pause();
    super.initState();
    // urlToFile();
  }

  @override
  void dispose() {
    // _timer?.cancel();
    super.dispose();
    video_controller!.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // share_icon() {
  //   return showDialog(
  //     context: context,
  //     builder: (ctx) => AlertDialog(
  //       title: Text("Post Video",
  //           style:
  //               TextStyle(fontSize: 18, color: Colors.black, fontFamily: 'PM')),
  //       actions: <Widget>[
  //         Container(
  //           margin: EdgeInsets.only(bottom: 10),
  //           child: common_button(
  //             onTap: () {
  //               // (widget.creator ? uploadImage() : uploadCommercial());
  //               (widget.creator
  //                   ? uploadImage()
  //                   : Get.to(CommercialVideoScreen(
  //                       videoFile: widget.videoFile,
  //                       description: description_controller.text,
  //                       tagged_users: tagged_users.join(','),
  //                       enable_download: valuedownload.toString(),
  //                       enable_comment: valuecomment.toString(),
  //                     )));
  //               // Get.toNamed(BindingUtils.signupOption);
  //             },
  //             backgroud_color: Colors.black,
  //             lable_text: 'Share',
  //             lable_text_color: Colors.white,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  List<String> tagged_users = [];

  String url_audio =
      "http://foxyserver.com/funky/music/1085760070_Maan%20Meri%20Jaan_64(PagalWorld.com.se).mp3";

  bool done = false;

  Future<File> urlToFile() async {
    // showLoader(context);
    var rng = Random();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = File('$tempPath${rng.nextInt(100)}.mp3');
    http.Response response = await http.get(Uri.parse(url_audio));
    await file.writeAsBytes(response.bodyBytes);
    print(file);

    var path;
    // await mergeIntoVideo(path: file.path);

    print(
        "path['outPath']path['outPath']path['outPath']path['outPath'] ${path['outPath']}");

    if (path['success']) {
      print('image urlllllllllllll ${widget.videoFile}');
      video_controller = VideoPlayerController.file(File(dir!));

      video_controller!.setLooping(true);
      video_controller!.initialize().then((_) {
        setState(() {
          done = true;
        });
        // hideLoader(context);
      });
      video_controller!.pause();
      await GallerySaver.saveVideo(path['outPath']).then((value) {
        print(value);
      });
    }

    return file;
  }

  String? dir;

  // Future<Map<String, dynamic>> mergeIntoVideo({required String path}) async {
  //   Directory appDocDirectory = await getTemporaryDirectory();
  //   setState(() {
  //     dir = "${appDocDirectory.path}/output.mp4";
  //   });
  //
  //   /// mp4 output
  //   String mp4Command = widget.camera!
  //       ? '-y -i ${widget.videoFile.path} -i ${widget.music_name} -map 0:v -map 1:a -c:v copy -shortest $dir'
  //       : '-y -i ${widget.videoFile.path} -i ${Uri.parse("http://foxyserver.com/funky/music/${widget.music_name}")} -map 0:v -map 1:a -c:v copy -shortest $dir';
  //
  //   var response = await FFmpegKit.execute(mp4Command).then((rc) async {
  //     debugPrint('FFmpeg process exited with rc ==> ${await rc.getOutput()}');
  //     // debugPrint('FFmpeg process exited with rc ==> ${rc.getCommand()}');
  //     var res = await rc.getReturnCode();
  //     print("res!.getValue() ${res!.getValue()}");
  //
  //     if (res.getValue() == 0) {
  //       return {
  //         'success': true,
  //         'msg': 'Widget was render successfully.',
  //         'outPath': FfmpegPaths.videoOutputPath
  //       };
  //     } else if (res.getValue() == 1) {
  //       return {'success': false, 'msg': 'Widget was render unsuccessfully.'};
  //     } else {
  //       return {'success': false, 'msg': 'Widget was render unsuccessfully.'};
  //     }
  //   });
  //
  //   return response;
  // }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.black,
        ),
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
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Text(
              'Post Preview',
              style: TextStyle(
                  fontSize: 16, color: Colors.white, fontFamily: 'PB'),
            ),
            centerTitle: true,
            // leadingWidth: 100,
            leading: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  print('oject');
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => Dashboard(
                  //               page: 0,
                  //             )));
                  video_controller!.pause();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => Dashboard(
                                page: 0,
                              )),
                      (route) => false);
                },
                icon: const Icon(
                  Icons.arrow_back_outlined,
                  color: Colors.white,
                )),
            actions: [
              InkWell(
                onTap: () {
                  // urlToFile();

                  video_controller!.pause();

                  ///
                  setState(() {
                    fileInByte = widget.cover_image.readAsBytesSync();
                    fileInBase64 = base64Encode(fileInByte!);
                  });

                  // print(fileInBase64);

                  (widget.creator
                      ? _scaleDialog(context: context)
                      : Get.to(CommercialVideoScreen(
                          videoFile: widget.videoFile,
                          description: description_controller.text,
                          tagged_users: tagged_users.join(','),
                          enable_download: valuedownload.toString(),
                          enable_comment: valuecomment.toString(),
                          cover_image: fileInBase64!,
                        )));
                  // selectTowerBottomSheet(context);
                  // _scaleDialog(context: context);
                  ///
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
                        color: Colors.white,
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
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  (widget.creator
                      ? Container(
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
                                data: ThemeData(
                                    unselectedWidgetColor: Colors.white),
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
                                  },
                                ),
                              )
                            ],
                          ),
                        )
                      : const SizedBox.shrink()),
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
                    color: Colors.white,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    width: MediaQuery.of(context).size.width,
                    // height: MediaQuery.of(context).size.height / 1.2,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Center(
                          child: AspectRatio(
                              aspectRatio: video_controller!.value.aspectRatio,
                              child: VideoPlayer(video_controller!)),
                        ),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              print('hello');
                              isClicked = isClicked ? false : true;
                              print(isClicked);
                              if (video_controller!.value.isPlaying) {
                                setState(() {
                                  video_controller!.pause();
                                });
                              } else {
                                setState(() {
                                  video_controller!.play();
                                });
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(100)),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Icon(
                                  (video_controller!.value.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow),
                                  color: Colors.pink,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Container(
                  //   child: Image.file(
                  //     widget.ImageFile,
                  //   ),
                  // )
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
  Uint8List? fileInByte;
  String? fileInBase64;
  bool isLoading = false;
  Future<dynamic> uploadImage() async {
    setState(() {
      isLoading = true;
    });
    print('showLoader');
    String idUser = await PreferenceManager().getPref(URLConstants.id);
    var url = (URLConstants.base_url + URLConstants.postApi);
    var request = http.MultipartRequest('POST', Uri.parse(url));
    setState(() {
      fileInByte = widget.cover_image.readAsBytesSync();
      fileInBase64 = base64Encode(fileInByte!);
    });

    // print(fileInBase64);

    var files = http.MultipartFile(
        'uploadVideo',
        File(widget.videoFile.path).readAsBytes().asStream(),
        File(widget.videoFile.path).lengthSync(),
        filename: widget.videoFile.path.split("/").last);

    request.files.add(files);
    // request.files.add(files2);
    request.fields['userId'] = idUser;
    request.fields['coverImage'] = fileInBase64!;
    request.fields['description'] = description_controller.text;
    request.fields['trending'] = '#image';
    request.fields['postImage'] = '';
    request.fields['isVideo'] = 'true';
    request.fields['tagLine'] = tagged_users.join(',');
    request.fields['address'] = '';
    request.fields['draft'] = draft.toString();
    request.fields['postId'] = '';
    request.fields['enableDownload'] = valuedownload.toString();
    request.fields['enableComment'] = valuecomment.toString();
    request.fields['allowAds'] = valueallowAds.toString();

    var response = await request.send();

    var responsed = await http.Response.fromStream(response);

    print('response  ${responsed.body}');
    final responseData = json.decode(responsed.body);

    if (response.statusCode == 200) {
      print("SUCCESS");
      print(response.reasonPhrase);
      print(widget.videoFile.path);
      print(responseData);
      print('hideLoader');
      setState(() {
        isLoading = false;
      });
      // Get.back();
      Get.to(() => Dashboard(page: 3));
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => Dashboard(
      //               page: 3,
      //             )));
    } else {
      print("ERROR");
    }
  }

  // selectTowerBottomSheet(BuildContext context) {
  //   final screenheight = MediaQuery.of(context).size.height;
  //   final screenwidth = MediaQuery.of(context).size.width;
  //   showModalBottomSheet(
  //     backgroundColor: Colors.black,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(30.0),
  //         topRight: Radius.circular(30.0),
  //       ),
  //     ),
  //     isScrollControlled: true,
  //     context: context,
  //     builder: (BuildContext context) {
  //       return BackdropFilter(
  //         filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
  //         child: StatefulBuilder(
  //           builder: (context, state) {
  //             return Container(
  //               height: screenheight * 0.4,
  //               width: screenwidth,
  //               decoration: BoxDecoration(
  //                 gradient: LinearGradient(
  //                   begin: Alignment.topCenter,
  //                   end: Alignment.bottomCenter,
  //                   // stops: [0.1, 0.5, 0.7, 0.9],
  //                   colors: [
  //                     HexColor("#C12265"),
  //                     HexColor("#000000"),
  //                   ],
  //                 ),
  //                 borderRadius: BorderRadius.only(
  //                   topLeft: Radius.circular(30.0),
  //                   topRight: Radius.circular(30.0),
  //                 ),
  //               ),
  //               child: Padding(
  //                 padding: const EdgeInsets.symmetric(horizontal: 23.9),
  //                 child: SingleChildScrollView(
  //                   physics: NeverScrollableScrollPhysics(),
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Container(
  //                         margin: EdgeInsets.all(23),
  //                         child:  Image.asset(
  //                           AssetUtils.share_icon3,
  //                           fit: BoxFit.cover,
  //                           color: Colors.white,
  //                         ),
  //                       ),
  //                       Text(
  //                         "Are you sure want to share this post ?",
  //                         textAlign: TextAlign.center,
  //                         style: TextStyle(
  //                             fontSize: 16,
  //                             fontFamily: 'PR',
  //                             color: Colors.white),
  //                       ),
  //                       Align(
  //                         alignment: FractionalOffset.bottomCenter,
  //                         child: Container(
  //                           margin: EdgeInsets.symmetric(
  //                               vertical: 40, horizontal: 0),
  //                           child: Row(
  //                             children: [
  //                               Expanded(
  //                                 child: GestureDetector(
  //                                   onTap: () {
  //                                     setState(() {
  //                                       draft = true;
  //                                     });
  //                                     (widget.creator
  //                                         ? uploadImage()
  //                                         : Get.to(CommercialVideoScreen(
  //                                       videoFile: widget.videoFile,
  //                                       description: description_controller.text,
  //                                       tagged_users: tagged_users.join(','),
  //                                       enable_download: valuedownload.toString(),
  //                                       enable_comment: valuecomment.toString(),
  //                                     )));
  //                                     Navigator.pop(context);
  //                                   },
  //                                   child: Container(
  //                                     margin: const EdgeInsets.symmetric(
  //                                         horizontal: 30),
  //                                     // height: 45,
  //                                     // width:(width ?? 300) ,
  //                                     decoration: BoxDecoration(
  //                                         color: Colors.red,
  //                                         borderRadius:
  //                                         BorderRadius.circular(25)),
  //                                     child: Container(
  //                                         alignment: Alignment.center,
  //                                         margin: EdgeInsets.symmetric(
  //                                           vertical: 12,
  //                                         ),
  //                                         child: Text(
  //                                           'Save Draft',
  //                                           style: TextStyle(
  //                                               color: Colors.white,
  //                                               fontFamily: 'PR',
  //                                               fontSize: 16),
  //                                         )),
  //                                   ),
  //                                 ),
  //                               ),
  //
  //                               Expanded(
  //                                 child: GestureDetector(
  //                                   onTap: () async {
  //                                     setState(() {
  //                                       draft = false;
  //                                     });
  //                                     (widget.creator
  //                                         ? uploadImage()
  //                                         : Get.to(CommercialVideoScreen(
  //                                       videoFile: widget.videoFile,
  //                                       description: description_controller.text,
  //                                       tagged_users: tagged_users.join(','),
  //                                       enable_download: valuedownload.toString(),
  //                                       enable_comment: valuecomment.toString(),
  //                                     )));
  //                                     // Navigator.pop(context);
  //                                     // send_otp_account(context: context);
  //                                     // delete_account(context: context);
  //                                   },
  //                                   child: Container(
  //                                     margin: const EdgeInsets.symmetric(
  //                                         horizontal: 30),
  //                                     // height: 45,
  //                                     // width:(width ?? 300) ,
  //                                     decoration: BoxDecoration(
  //                                         color: Colors.white,
  //                                         borderRadius:
  //                                         BorderRadius.circular(25)),
  //                                     child: Container(
  //                                         alignment: Alignment.center,
  //                                         margin: const EdgeInsets.symmetric(
  //                                           vertical: 12,
  //                                         ),
  //                                         child: Text(
  //                                           'Share',
  //                                           style: TextStyle(
  //                                               color: Colors.black,
  //                                               fontFamily: 'PR',
  //                                               fontSize: 16),
  //                                         )),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             );
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }

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
                                                // showLoader(context);
                                                print("video share");
                                                setState(() {
                                                  draft = true;
                                                });

                                                await uploadImage();
                                                // hideLoader(context);
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
                                                print("video share");
                                                setState(() {
                                                  draft = false;
                                                });
                                                //showLoader(context);

                                                await uploadImage();
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
                                                    child: isLoading
                                                        ? const CircularProgressIndicator()
                                                        : const Text(
                                                            'Share',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    'PR',
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
