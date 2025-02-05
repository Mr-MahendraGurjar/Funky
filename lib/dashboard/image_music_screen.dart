import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:ffmpeg_kit_flutter_min_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_min_gpl/return_code.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:funky_new/dashboard/dashboard_screen.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path_provider/path_provider.dart';
import 'package:video_editor/video_editor.dart';

// import 'package:video_editor/domain/bloc/controller.dart';
// import 'package:video_editor/ui/cover/cover_viewer.dart';

import '../Utils/App_utils.dart';
import '../Utils/asset_utils.dart';
import '../Utils/toaster_widget.dart';
import '../custom_widget/loader_page.dart';
import '../homepage/controller/homepage_controller.dart';
import '../profile_screen/music_player.dart';
import 'post_image_preview.dart';
import 'post_video_preview.dart';

class ImageMusicScreen extends StatefulWidget {
  File ImageData;

  ImageMusicScreen({super.key, required this.ImageData});

  @override
  State<ImageMusicScreen> createState() => _ImageMusicScreenState();
}

class _ImageMusicScreenState extends State<ImageMusicScreen> {
  String dropdownvalue = 'Apple';
  bool isClicked = false; // boolean that states if the button is pressed or not

  final HomepageController homepageController =
      Get.put(HomepageController(), tag: HomepageController().toString());

  // 2. compress file and get file.
  Future<XFile?> testCompressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path, targetPath,
      quality: 88,
      // rotate: 90,
    );

    print(file.lengthSync());

    return result;
  }

  void getFileImage() async {
    // final img = AssetImage('img/img.jpg');
    // print('pre compress');
    // final config = ImageConfiguration();
    // final AssetBundleImageKey key = await img.obtainKey(config);
    // final ByteData data = await key.bundle.load(key.name);
    final dir = await path_provider.getTemporaryDirectory();
    // final File file = createFile('${dir.absolute.path}/test.png');
    // file.writeAsBytesSync(data.buffer.asUint8List());
    final targetPath = '${dir.absolute.path}/${widget.ImageData.path.split('.').last}.jpg';
    final imgFile = await testCompressAndGetFile(widget.ImageData, targetPath);
    setState(() {
      widget.ImageData = File(imgFile!.path);
    });
    setState(() {
      // provider = FileImage(imgFile);
    });
  }

  File createFile(String path) {
    final file = File(path);
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }
    return file;
  }

  File? compressed_image;

  @override
  void initState() {
    homepageController.getAllMusicList();
    getFileImage();
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
            leading: BackButton(
              onPressed: () {
                Get.to(() => Dashboard(page: 0));
              },
            ),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.black,
            title: const Text(
              'Add Music',
              style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'PB'),
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
              DropdownButtonHideUnderline(
                child: DropdownButton2(
                  isExpanded: true,
                  customButton: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
                    child: Image.asset(
                      AssetUtils.music_icon,
                      color: Colors.white,
                      height: 20,
                      width: 20,
                    ),
                  ),
                  items: [
                    DropdownMenuItem(
                        value: "Apple",
                        onTap: () {
                          // pick_music();
                          // Navigator.pop(context);
                        },
                        child: GestureDetector(
                          onTap: () async {
                            pick_music();
                            // Navigator.pop(context);
                          },
                          child: const Text("Gallery",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'PR')),
                        )),
                    DropdownMenuItem(
                        value: "Apple2",
                        onTap: () {
                          // selectTowerBottomSheet(context: context);
                        },
                        child: GestureDetector(
                          onTap: () async {
                            Navigator.pop(context);
                            selectTowerBottomSheet(context: context);
                          },
                          child: const Text("Funky Music",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'PR')),
                        )),
                  ],
                  value: dropdownvalue,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'PR',
                    color: Colors.white,
                  ),
                  alignment: Alignment.centerLeft,
                  onChanged: (value) {
                    setState(() {
                      dropdownvalue = value.toString();
                    });
                  },
                  iconStyleData: const IconStyleData(
                    iconSize: 25,
                    iconEnabledColor: Color(0xff007DEF),
                    iconDisabledColor: Color(0xff007DEF),
                  ),
                  buttonStyleData: ButtonStyleData(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.transparent),
                    height: 50,
                    width: 100,
                    elevation: 0,
                    padding: const EdgeInsets.only(
                      left: 14,
                      right: 14,
                    ),
                  ),
                  enableFeedback: true,
                  dropdownStyleData: DropdownStyleData(
                    padding: EdgeInsets.zero,
                    width: 150,
                    maxHeight: 200,
                    elevation: 8,
                    scrollbarTheme: const ScrollbarThemeData(
                      radius: Radius.circular(40),
                      thickness: WidgetStatePropertyAll(8),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(width: 1, color: Colors.white),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        // stops: [0.1, 0.5, 0.7, 0.9],
                        colors: [
                          HexColor("#000000"),
                          HexColor("#C12265"),
                          // HexColor("#FFFFFF"),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    if (video_now) {
                      _controller!.video.pause();
                      await Get.to(PostVideoPreviewScreen(
                        videoFile: File(dir!),
                        creator: true,
                        cover_image: widget.ImageData,
                      ));
                    } else {
                      Get.to(PostImagePreviewScreen(
                        ImageFile: widget.ImageData,
                      ));
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 20),
                    child: Container(
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                        child: Text(
                          'Next',
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'PM',
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  (video_now
                      ? Container(
                          color: Colors.white,
                          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                          width: MediaQuery.of(context).size.width,
                          // height: MediaQuery.of(context).size.height / 1.2,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Center(
                                child: AspectRatio(
                                    aspectRatio: _controller!.video.value.aspectRatio,
                                    child: CoverViewer(
                                      controller: _controller!,
                                    )),
                              ),
                              Center(
                                child: GestureDetector(
                                  onTap: () {
                                    print('hello');
                                    isClicked = isClicked ? false : true;
                                    print(isClicked);
                                    if (_controller!.video.value.isPlaying) {
                                      setState(() {
                                        _controller!.video.pause();
                                      });
                                    } else {
                                      setState(() {
                                        _controller!.video.play();
                                      });
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.black54, borderRadius: BorderRadius.circular(100)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Icon(
                                        (_controller!.video.value.isPlaying ? Icons.pause : Icons.play_arrow),
                                        color: Colors.pink,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height / 1.5,
                          width: MediaQuery.of(context).size.width,
                          child: Image.file(
                            widget.ImageData,
                          ),
                        )),
                  (loading ? const Center(child: LoaderPage()) : const SizedBox())
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String? music_selected;

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

      print(file.name);

      CommonWidget().showToaster(msg: "${file.name} selected");
      setState(() {
        music_selected = file.path;
        camera_selected = true;
      });
      urlToFile();
    } else {
      // User cancelled the picker
    }
  }

  selectTowerBottomSheet({
    required BuildContext context,
  }) {
    final screenheight = MediaQuery.of(context).size.height;
    final screenwidth = MediaQuery.of(context).size.width;
    showModalBottomSheet(
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, state) {
            return GestureDetector(
              onTap: () {},
              child: Container(
                height: screenheight * 0.8,
                width: screenwidth,
                decoration: BoxDecoration(
                  // color: Colors.black.withOpacity(0.65),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    // stops: [0.1, 0.5, 0.7, 0.9],
                    colors: [
                      HexColor("#C12265").withOpacity(0.67),
                      HexColor("#000000").withOpacity(0.67),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: HexColor('#04060F'),
                      offset: const Offset(10, 10),
                      blurRadius: 20,
                    ),
                  ],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.9),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Funky Music',
                            style: TextStyle(color: Colors.white, fontFamily: 'PB', fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Obx(
                        () => (homepageController.isallMusicLoading.value == true
                            ? const Center(
                                child: LoaderPage(),
                              )
                            : (homepageController.getAllMusicModel?.error == false
                                ? Expanded(
                                    child: ListView.builder(
                                      physics: const AlwaysScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.only(bottom: 0),
                                      itemCount: homepageController.getAllMusicModel!.data!.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return GestureDetector(
                                          onTap: () async {
                                            print(homepageController.getAllMusicModel!.data![index].songName);
                                            CommonWidget().showToaster(
                                                msg:
                                                    "${homepageController.getAllMusicModel!.data![index].songName} selected");
                                            setState(() {
                                              music_selected =
                                                  homepageController.getAllMusicModel!.data![index].musicFile;
                                              camera_selected = false;
                                            });
                                            Navigator.pop(context);
                                            await urlToFile();
                                            print(
                                                'url==>${homepageController.getAllMusicModel!.data![index].musicFile!}');
                                          },
                                          child: Music_player2(
                                            music_url:
                                                homepageController.getAllMusicModel?.data?[index].musicFile ??
                                                    "",
                                            // homepageController
                                            //     .getAllMusicModel!
                                            //     .data![index]
                                            //     .musicFile!,
                                            title:
                                                homepageController.getAllMusicModel?.data?[index].songName ??
                                                    "",
                                            artist_name: homepageController
                                                    .getAllMusicModel?.data?[index].artistName ??
                                                '',
                                            // music: homepageController
                                            //     .getAllMusicModel!.data![index],
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Container(
                                        margin: const EdgeInsets.only(top: 50),
                                        child: Text("${homepageController.getAllMusicModel!.message}",
                                            style: const TextStyle(
                                                color: Colors.white, fontSize: 16, fontFamily: 'PR')),
                                      ),
                                    ),
                                  ))),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  VideoEditorController? _controller;

  bool video_now = false;
  bool loading = false;

  urlToFile() async {
    try {
      setState(() {
        loading = true;
      });

      var path = await mergeIntoVideo();
      print('path==>$path');
      print("path['outPath']path['outPath']path['outPath']path['outPath'] ${path['outPath']}");

      print('url==>${URLConstants.base_data_url}music/$music_selected');
      if (path['success']) {
        setState(() {
          _controller = VideoEditorController.file(File(dir!), maxDuration: const Duration(seconds: 80));
          _controller!.initialize().then((_) {
            setState(() {
              video_now = true;
              loading = false;
            });
          });
        });
      } else {
        setState(() {
          loading = false;
        });
        CommonWidget().showErrorToaster(msg: 'fail');
        print('fail');
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      print("Error during set music=>$e");
    }
  }

  String? dir;
  bool camera_selected = false;
  dynamic limit = 10;
  late double startTime = 0, endTime = 10;

  void setTimeLimit(dynamic value) async {
    limit = value;
    // notifyListeners();
  }

  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  String getRandomString(int length) =>
      String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Future<String> downloadFile(String url, String filename) async {
    Dio dio = Dio();
    var dir = await getTemporaryDirectory();
    String filePath = "${dir.path}/$filename";
    await dio.download(url, filePath);
    return filePath;
  }

  String quotePath(String path) {
    return '"$path"';
  }

  Future<Map<String, dynamic>> mergeIntoVideo() async {
    try {
      Directory appDocDirectory = await getTemporaryDirectory();
      setState(() {
        dir = "${appDocDirectory.path}/music_selected${getRandomString(5)}.mp4";
      });

      String timeLimit = '00:00:';
      if (limit < 10) {
        timeLimit = '${timeLimit}0$limit';
      } else {
        timeLimit = timeLimit + limit.toString();
      }

      String audioPath = music_selected ?? "";
      print('Camera Selected $camera_selected');
      print('Camera audioPath $audioPath');

      // Check if the audio file exists
      bool fileExists = File(audioPath).existsSync();
      print('File exists: $fileExists');
      // Download the audio file if it's not local

      if (!camera_selected) {
        audioPath =
            await downloadFile("${URLConstants.base_data_url}music/$music_selected", "music_selected.mp3");
      }

      print('Music Selected in video convert $music_selected');

      // to avoid spaces in audio path
      String quotedAudioPath = quotePath(audioPath);
      String quotedImagePath = quotePath(widget.ImageData.path);

      String mp4Command =
          "-loop 1 -i $quotedImagePath -i $quotedAudioPath -c:v libx264 -tune stillimage -preset ultrafast -crf 27 -c:a aac -b:a 192k -vf scale=1280:-2,format=yuv420p -t 30 -movflags +faststart $dir";

      print('FFmpeg Command: $mp4Command');
      var response = await FFmpegKit.execute(mp4Command).then((session) async {
        final output = await session.getOutput();
        debugPrint('FFmpeg process exited with output: $output');
        final returnCode = await session.getReturnCode();
        if (ReturnCode.isSuccess(returnCode)) {
          return {'success': true, 'msg': 'Widget was rendered successfully.', 'outPath': dir};
        } else {
          return {'success': false, 'msg': 'Widget was rendered unsuccessfully.'};
        }
      });

      return response;
    } catch (e) {
      print('mergeIntoVideo Error :$e');
      return {'success': false, 'msg': 'Widget was rendered unsuccessfully.'};
    }
  }
}
