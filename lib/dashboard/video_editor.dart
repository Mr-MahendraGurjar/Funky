import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:ffmpeg_kit_flutter_min_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_min_gpl/return_code.dart';
import 'package:ffmpeg_kit_flutter_min_gpl/statistics.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:funky_new/Utils/asset_utils.dart';
import 'package:funky_new/Utils/toaster_widget.dart';
import 'package:funky_new/custom_widget/loader_page.dart';
import 'package:funky_new/dashboard/post_video_preview.dart';
import 'package:funky_new/dashboard/story_/src/presentation/utils/constants/directory_path.dart';
import 'package:get/get.dart';
// import 'package:helpers/helpers.dart'
//     show OpacityTransition, SwipeTransition, AnimatedInteractiveViewer;
import 'package:hexcolor/hexcolor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_editor/video_editor.dart';
import 'package:video_player/video_player.dart';

import '../Utils/colorUtils.dart';
import '../custom_widget/common_buttons.dart';
import '../homepage/controller/homepage_controller.dart';
import '../profile_screen/music_player.dart';

class VideoEditor extends StatefulWidget {
  final bool creator;

  const VideoEditor({super.key, required this.file, required this.creator});

  final File file;

  @override
  State<VideoEditor> createState() => _VideoEditorState();
}

class _VideoEditorState extends State<VideoEditor> {
  final _exportingProgress = ValueNotifier<double>(0.0);
  final _isExporting = ValueNotifier<bool>(true);
  final double height = 60;

  bool _exported = false;
  String _exportText = "";
  late VideoEditorController _controller;

  final HomepageController homepageController =
      Get.put(HomepageController(), tag: HomepageController().toString());

  @override
  void initState() {
    _controller = VideoEditorController.file(widget.file,
        maxDuration: const Duration(seconds: 60))
      ..initialize().then((_) => setState(() {}));
    homepageController.getAllMusicList();

    super.initState();
  }

  @override
  void dispose() {
    _exportingProgress.dispose();
    _isExporting.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _openCropScreen() => Navigator.push(
      context,
      MaterialPageRoute<void>(
          builder: (BuildContext context) =>
              CropScreen(controller: _controller)));

  File? cover_image;

  void _exportVideo() async {
    _exportingProgress.value = 0;
    _isExporting.value = true;

    final config = VideoFFmpegVideoEditorConfig(
      _controller,
      // You can customize the export format and other parameters here
      // format: VideoExportFormat.gif,
      // commandBuilder: (config, videoPath, outputPath) {
      //   final List<String> filters = config.getExportFilters();
      //   filters.add('hflip'); // add horizontal flip
      //   return '-i $videoPath ${config.filtersCmd(filters)} -preset ultrafast $outputPath';
      // },
    );

    await _runFFmpegCommand(
      await config.getExecuteConfig(),
      onProgress: (stats) {
        _exportingProgress.value = config.getFFmpegProgress(int.parse(stats.getTime().toString()));
      },
      onError: (e, s) {
        print('Error on export video: $e');
        CommonWidget().showErrorToaster(msg: "Error on export video");
      },
      onCompleted: (file) async {
        _isExporting.value = false;
        if (!mounted) return;

        (widget.creator
            ? await Get.to(PostVideoPreviewScreen(
                videoFile: file,
                creator: true,
                cover_image: cover_image!,
              ))
            : await Get.to(PostVideoPreviewScreen(
                videoFile: file,
                creator: false,
                cover_image: cover_image!,
              )));
      },
    );
  }

  void _exportCover() async {
    final config = CoverFFmpegVideoEditorConfig(_controller);
    final execute = await config.getExecuteConfig();
    if (execute == null) {
      CommonWidget().showErrorToaster(msg: "Error on cover export initialization");
      return;
    }

    await _runFFmpegCommand(
      execute,
      onError: (e, s) {
        print('Error on cover export: $e');
        CommonWidget().showErrorToaster(msg: "Error on cover export");
      },
      onCompleted: (cover) {
        if (!mounted) return;

        setState(() {
          cover_image = File(cover.path);
        });
        print("cover_image!.path ${cover_image!.path}");
        setState(() => _exported = true);
        Future.delayed(const Duration(seconds: 2),
            () => setState(() => _exported = false));
      },
    );
  }

  Future<void> _runFFmpegCommand(
    FFmpegVideoEditorExecute execute, {
    required void Function(File file) onCompleted,
    void Function(Object, StackTrace)? onError,
    void Function(Statistics)? onProgress,
  }) async {
    print('FFmpeg start process with command = ${execute.command}');
    await FFmpegKit.executeAsync(
      execute.command,
      (session) async {
        final code = await session.getReturnCode();

        if (ReturnCode.isSuccess(code)) {
          onCompleted(File(execute.outputPath));
        } else {
          if (onError != null) {
            onError(
              Exception(
                  'FFmpeg process exited with return code $code.\n${await session.getOutput()}'),
              StackTrace.current,
            );
          }
          return;
        }
      },
      null,
      onProgress,
    );
  }

  String url_audio =
      "http://foxyserver.com/funky/music/1085760070_Maan%20Meri%20Jaan_64(PagalWorld.com.se).mp3";

  bool loading = false;

  urlToFile() async {
    // showLoader(context);
    setState(() {
      loading = true;
    });

    var path = await mergeIntoVideo();

    print(
        "path['outPath']path['outPath']path['outPath']path['outPath'] ${path['outPath']}");

    if (path['success']) {
      print('image urlllllllllllll ${widget.file}');
      // _controller = await VideoEditorController.file(File(dir!));
      //
      // _controller.video.setLooping(true);
      // _controller.video.initialize().then((_) {
      //   // setState(() {
      //   //   done = true;
      //   // });
      //   // hideLoader(context);
      // });
      // _controller.video.pause();
      setState(() {
        _controller = VideoEditorController.file(File(dir!),
            maxDuration: const Duration(seconds: 60));
        _controller.initialize().then((_) {
          setState(() {});
          // hideLoader(context);
        });
        loading = false;
      });
      // ..initialize().then((_) => setState(() {
      //       loading = false;
      //     }));
      // await GallerySaver.saveVideo(path['outPath']).then((value) {
      //   print(value);
      // });
    }
  }

  String? dir;
  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Future<Map<String, dynamic>> mergeIntoVideo() async {
    Directory appDocDirectory = await getTemporaryDirectory();
    setState(() {
      dir = "${appDocDirectory.path}/music_selected${getRandomString(5)}.mp4";
    });

    /// mp4 output
    String mp4Command = camera_selected
        ? '-y -i ${widget.file.path} -i $music_selected -map 0:v -map 1:a -c:v copy $dir'
        : '-y -i ${widget.file.path} -i ${Uri.parse("http://foxyserver.com/funky/music/$music_selected")} -map 0:v -map 1:a -c:v copy $dir';

    var response = await FFmpegKit.execute(mp4Command).then((rc) async {
      debugPrint('FFmpeg process exited with rc ==> ${await rc.getOutput()}');
      // debugPrint('FFmpeg process exited with rc ==> ${rc.getCommand()}');
      var res = await rc.getReturnCode();
      print("res!.getValue() ${res!.getValue()}");

      if (res.getValue() == 0) {
        return {
          'success': true,
          'msg': 'Widget was render successfully.',
          'outPath': FfmpegPaths.videoOutputPath
        };
      } else if (res.getValue() == 1) {
        return {'success': false, 'msg': 'Widget was render unsuccessfully.'};
      } else {
        return {'success': false, 'msg': 'Widget was render unsuccessfully.'};
      }
    });

    return response;
  }

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
                HexColor("#C12265").withOpacity(0.67),
                HexColor("#000000").withOpacity(0.67),
              ],
            ),
          ),
        ),
        Scaffold(
            backgroundColor: Colors.transparent,
            body: _controller.initialized
                ? Stack(children: [
                    Column(children: [
                      _topNavBar(),
                      Expanded(
                          child: DefaultTabController(
                              length: 2,
                              child: Column(children: [
                                Expanded(
                                    child: TabBarView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: [
                                    Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          CropGridViewer.preview(
                                              controller: _controller),
                                          // AnimatedBuilder(
                                          //   animation: _controller.video,
                                          //   builder: (_, __) =>
                                          //       OpacityTransition(
                                          //     visible: !_controller.isPlaying,
                                          //     child: GestureDetector(
                                          //       onTap: _controller.video.play,
                                          //       child: Container(
                                          //         width: 40,
                                          //         height: 40,
                                          //         decoration:
                                          //             const BoxDecoration(
                                          //           color: Colors.white,
                                          //           shape: BoxShape.circle,
                                          //         ),
                                          //         child: const Icon(
                                          //             Icons.play_arrow,
                                          //             color: Colors.black),
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),
                                          (loading
                                              ? const Center(
                                                  child: LoaderPage())
                                              : const SizedBox())
                                        ]),
                                    CoverViewer(controller: _controller)
                                  ],
                                )),
                                Container(
                                    height: 200,
                                    margin: const EdgeInsets.only(top: 10),
                                    child: Column(children: [
                                      TabBar(
                                        indicatorColor:
                                            HexColor(CommonColor.pinkFont),
                                        tabs: const [
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                    padding: EdgeInsets.all(5),
                                                    child: Icon(
                                                      Icons.content_cut,
                                                      color: Colors.white,
                                                    )),
                                                Text(
                                                  'Trim',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'PR',
                                                      fontSize: 14),
                                                )
                                              ]),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                    padding: EdgeInsets.all(5),
                                                    child: Icon(
                                                      Icons.video_label,
                                                      color: Colors.white,
                                                    )),
                                                Text(
                                                  'Cover',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'PR',
                                                      fontSize: 14),
                                                )
                                              ]),
                                        ],
                                      ),
                                      Expanded(
                                        child: TabBarView(
                                          children: [
                                            Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: _trimSlider()),
                                            Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [_coverSelection()]),
                                          ],
                                        ),
                                      )
                                    ])),
                                // _customSnackBar(),
                                // ValueListenableBuilder(
                                //   valueListenable: _isExporting,
                                //   builder: (_, bool export, __) =>
                                //       OpacityTransition(
                                //         visible: export,
                                //         child: Container(
                                //           margin: EdgeInsets.symmetric(vertical: 5),
                                //           child: ValueListenableBuilder(
                                //             valueListenable: _isExporting,
                                //             builder: (_, bool export, __) =>
                                //                 OpacityTransition(
                                //                   visible: export,
                                //                   child: Container(
                                //                     margin: EdgeInsets.symmetric(vertical: 5),
                                //                     child:
                                //                     AlertDialog(
                                //                       insetPadding: EdgeInsets.zero,
                                //                       contentPadding: EdgeInsets.zero,
                                //                       elevation: 10,
                                //                       backgroundColor: Colors.black,
                                //                       content: ValueListenableBuilder(
                                //                         valueListenable: _exportingProgress,
                                //                         builder: (BuildContext context,
                                //                             double value, Widget? child) {
                                //                           return Container(
                                //                             padding: EdgeInsets.zero,
                                //                             decoration: BoxDecoration(
                                //                                 gradient: LinearGradient(
                                //                                   begin: const Alignment(
                                //                                       -1.0, 0.0),
                                //                                   end:
                                //                                   const Alignment(1.0, 0.0),
                                //                                   transform:
                                //                                   const GradientRotation(
                                //                                       0.7853982),
                                //                                   // stops: [0.1, 0.5, 0.7, 0.9],
                                //                                   colors: [
                                //                                     HexColor("#000000"),
                                //                                     HexColor("#000000"),
                                //                                     HexColor(
                                //                                         CommonColor.pinkFont),
                                //                                     HexColor("#ffffff"),
                                //                                     // HexColor("#FFFFFF").withOpacity(0.67),
                                //                                   ],
                                //                                 ),
                                //                                 color: Colors.white,
                                //                                 border: Border.all(
                                //                                     color: Colors.white,
                                //                                     width: 1),
                                //                                 borderRadius:
                                //                                 const BorderRadius.all(
                                //                                     Radius.circular(26.0))),
                                //                             child: Padding(
                                //                               padding:
                                //                               const EdgeInsets.all(18.0),
                                //                               child: Row(
                                //                                 mainAxisAlignment: MainAxisAlignment.center,
                                //                                 mainAxisSize: MainAxisSize.min,
                                //                                 children: [
                                //                                   Container(
                                //                                     color: Colors.transparent,
                                //                                     child: Row(
                                //                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //                                       children:  [
                                //                                         CircularProgressIndicator(
                                //                                           // color: Colors.pink,
                                //                                           backgroundColor: HexColor(CommonColor.pinkFont),
                                //                                           valueColor: AlwaysStoppedAnimation<Color>(
                                //                                             Colors.white70, //<-- SEE HERE
                                //                                           ),
                                //                                         ),
                                //                                         SizedBox(width: 15,),
                                //                                         Text(
                                //                                           "${(value * 100).ceil()}% Exporting ",
                                //                                           style: const TextStyle(
                                //                                               fontSize: 14,
                                //                                               fontFamily: 'PB',
                                //                                               color: Colors.white),
                                //                                         ),
                                //
                                //                                         // Text('Loading...',style: TextStyle(color: Colors.white,fontSize: 18,fontFamily: 'PR'),)
                                //                                       ],
                                //                                     ),
                                //                                   ),
                                //                                 ],
                                //                               ),
                                //                             ),
                                //                           );
                                //                         },
                                //                       ),
                                //                       // title: ValueListenableBuilder(
                                //                       //   valueListenable: _exportingProgress,
                                //                       //   builder: (_, double value, __) => Text(
                                //                       //     "Exporting video ${(value * 100).ceil()}%",
                                //                       //     style: const TextStyle(fontSize: 12),
                                //                       //   ),
                                //                       // ),
                                //                     ),
                                //
                                //                   ),
                                //                 ),
                                //           ),
                                //         ),
                                //       ),
                                // )
                              ]))),
                    ])
                  ])
                : const Center(child: CircularProgressIndicator())),
      ],
    );
  }

  String dropdownvalue = 'Apple';

  Widget _topNavBar() {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.black12,
          shape: BoxShape.rectangle,
          //   boxShadow: [
          //     BoxShadow(blurRadius: 1),
          //   ],
        ),
        height: height,
        child: Row(
          children: [
            Expanded(
              child: IconButton(
                onPressed: () =>
                    _controller.rotate90Degrees(RotateDirection.left),
                icon: const Icon(
                  Icons.rotate_left,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: () =>
                    _controller.rotate90Degrees(RotateDirection.right),
                icon: const Icon(Icons.rotate_right, color: Colors.white),
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: _openCropScreen,
                icon: const Icon(Icons.crop, color: Colors.white),
              ),
            ),
            // Expanded(
            //   child: IconButton(
            //     onPressed: _exportCover,
            //     icon: const Icon(Icons.save_alt, color: Colors.white),
            //   ),
            // ),
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  // isExpanded: true,
                  customButton: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
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
                          pick_music();
                          // Navigator.pop(context);
                        },
                        child: GestureDetector(
                          onTap: () async {
                            pick_music();
                            // Navigator.pop(context);
                          },
                          child: const Text("Gallery",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'PR')),
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
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'PR')),
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
                  // iconSize: 25,
                  // iconEnabledColor: const Color(0xff007DEF),
                  // iconDisabledColor: const Color(0xff007DEF),
                  // buttonHeight: 50,
                  // buttonWidth: 100,
                  // enableFeedback: true,
                  // buttonPadding: const EdgeInsets.only(left: 15, right: 15),
                  // buttonDecoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.transparent),

                  // buttonElevation: 0,
                  // itemHeight: 30,
                  // itemPadding: const EdgeInsets.only(
                  //   left: 14,
                  //   right: 14,
                  // ),
                  // dropdownMaxHeight: 200,
                  // dropdownWidth: 150,
                  // dropdownPadding: null,
                  // dropdownDecoration: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(24),
                  //   border: Border.all(width: 1, color: Colors.white),
                  //   gradient: LinearGradient(
                  //     begin: Alignment.topLeft,
                  //     end: Alignment.bottomRight,
                  //     // stops: [0.1, 0.5, 0.7, 0.9],
                  //     colors: [
                  //       HexColor("#000000"),
                  //       HexColor("#C12265"),
                  //       // HexColor("#FFFFFF"),
                  //     ],
                  //   ),
                  // ),
                  // dropdownElevation: 8,
                  // scrollbarRadius: const Radius.circular(40),
                  // scrollbarThickness: 6,
                  // scrollbarAlwaysShow: true,
                  // offset: const Offset(-10, -8),
                ),
              ),

              // GestureDetector(
              //   onTap: () {
              //     selectTowerBottomSheet(context: context);
              //   },
              //   child: Image.asset(
              //     AssetUtils.music_icon,
              //     color: Colors.white,
              //     height: 20,
              //     width: 20,
              //   ),
              // ),
            ),

            Expanded(
              child: IconButton(
                onPressed: () async {
                  await _controller.video.pause();
                  _exportVideo();
                },
                // onPressed: popup_export,
                icon: const Icon(Icons.share, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatter(Duration duration) => [
        duration.inMinutes.remainder(60).toString().padLeft(2, '0'),
        duration.inSeconds.remainder(60).toString().padLeft(2, '0')
      ].join(":");

  List<Widget> _trimSlider() {
    return [
      AnimatedBuilder(
        animation: _controller.video,
        builder: (_, __) {
          final duration = _controller.video.value.duration.inSeconds;
          final pos = _controller.trimPosition * duration;
          final start = _controller.minTrim * duration;
          final end = _controller.maxTrim * duration;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: height / 4),
            child: Row(children: [
              Text(
                formatter(Duration(seconds: pos.toInt())),
                style: const TextStyle(color: Colors.white),
              ),
              const Expanded(child: SizedBox()),
              // OpacityTransition(
              //   visible: _controller.isTrimming,
              //   child: Row(mainAxisSize: MainAxisSize.min, children: [
              //     Text(
              //       formatter(Duration(seconds: start.toInt())),
              //       style: const TextStyle(color: Colors.red),
              //     ),
              //     const SizedBox(width: 10),
              //     Text(
              //       formatter(Duration(seconds: end.toInt())),
              //       style: const TextStyle(color: Colors.white),
              //     ),
              //   ]),
              // )
            ]),
          );
        },
      ),
      Container(
        // color: HexColor(CommonColor.pinkFont),
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(vertical: height / 4),
        child: TrimSlider(
            controller: _controller,
            height: height,
            horizontalMargin: height / 4,
            child: TrimTimeline(
              // secondGap: 5,
              controller: _controller,
              // margin: const EdgeInsets.only(top: 10),
            )),
      )
    ];
  }

  // popup_export() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return BackdropFilter(
  //           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
  //           child: ValueListenableBuilder(
  //             valueListenable: _isExporting,
  //             builder: (_, bool export, __) =>
  //                 OpacityTransition(
  //               visible: export,
  //               child: Container(
  //                 margin: const EdgeInsets.symmetric(vertical: 5),
  //                 child: WillPopScope(
  //                   onWillPop: () async => false,
  //                   child: AlertDialog(
  //                     insetPadding: EdgeInsets.zero,
  //                     contentPadding: EdgeInsets.zero,
  //                     elevation: 10,
  //                     backgroundColor: Colors.transparent,
  //                     content: ValueListenableBuilder(
  //                       valueListenable: _exportingProgress,
  //                       builder: (BuildContext context, double value,
  //                           Widget? child) {
  //                         return Container(
  //                           padding: EdgeInsets.zero,
  //                           decoration: BoxDecoration(
  //                               gradient: LinearGradient(
  //                                 begin: const Alignment(-1.0, 0.0),
  //                                 end: const Alignment(1.0, 0.0),
  //                                 transform: const GradientRotation(0.7853982),
  //                                 // stops: [0.1, 0.5, 0.7, 0.9],
  //                                 colors: [
  //                                   HexColor("#000000"),
  //                                   HexColor("#000000"),
  //                                   HexColor(CommonColor.pinkFont),
  //                                   HexColor("#ffffff"),
  //                                   // HexColor("#FFFFFF").withOpacity(0.67),
  //                                 ],
  //                               ),
  //                               color: Colors.white,
  //                               border:
  //                                   Border.all(color: Colors.white, width: 1),
  //                               borderRadius: const BorderRadius.all(
  //                                   Radius.circular(26.0))),
  //                           child: Padding(
  //                             padding: const EdgeInsets.all(18.0),
  //                             child: Row(
  //                               mainAxisAlignment: MainAxisAlignment.center,
  //                               mainAxisSize: MainAxisSize.min,
  //                               children: [
  //                                 Container(
  //                                   color: Colors.transparent,
  //                                   child: Row(
  //                                     mainAxisAlignment:
  //                                         MainAxisAlignment.spaceBetween,
  //                                     children: [
  //                                       Stack(
  //                                         alignment: Alignment.center,
  //                                         children: [
  //                                           SizedBox(
  //                                             height: 50,
  //                                             width: 50,
  //                                             child: CircularProgressIndicator(
  //                                               // strokeWidth: 3.5,
  //                                               // color: Colors.pink,
  //                                               backgroundColor: HexColor(
  //                                                   CommonColor.pinkFont),
  //                                               valueColor:
  //                                                   const AlwaysStoppedAnimation<
  //                                                       Color>(
  //                                                 Colors.white70, //<-- SEE HERE
  //                                               ),
  //                                             ),
  //                                           ),
  //                                           Text(
  //                                             "${(value * 100).ceil()}%",
  //                                             style: const TextStyle(
  //                                                 fontSize: 14,
  //                                                 fontFamily: 'PB',
  //                                                 color: Colors.white),
  //                                           ),
  //                                         ],
  //                                       ),
  //                                       const SizedBox(
  //                                         width: 15,
  //                                       ),
  //                                       const Text(
  //                                         "Exporting ",
  //                                         style: TextStyle(
  //                                             fontSize: 14,
  //                                             fontFamily: 'PB',
  //                                             color: Colors.white),
  //                                       ),
  //
  //                                       // Text('Loading...',style: TextStyle(color: Colors.white,fontSize: 18,fontFamily: 'PR'),)
  //                                     ],
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                         );
  //                       },
  //                     ),
  //                     // title: ValueListenableBuilder(
  //                     //   valueListenable: _exportingProgress,
  //                     //   builder: (_, double value, __) => Text(
  //                     //     "Exporting video ${(value * 100).ceil()}%",
  //                     //     style: const TextStyle(fontSize: 12),
  //                     //   ),
  //                     // ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ));
  //     },
  //   );
  // }

  Widget _coverSelection() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: height / 4),
        child: CoverSelection(
          controller: _controller,
          //height: height,
          quantity: 8,
        ));
  }

  String? music_selected;

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
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'PB',
                                fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Obx(
                        () => (homepageController.isallMusicLoading.value ==
                                true
                            ? const Center(
                                child: LoaderPage(),
                              )
                            : (homepageController.getAllMusicModel!.error ==
                                    false
                                ? Expanded(
                                    child: ListView.builder(
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.only(bottom: 0),
                                      itemCount: homepageController
                                          .getAllMusicModel!.data!.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return GestureDetector(
                                          onTap: () async {
                                            print(homepageController
                                                .getAllMusicModel!
                                                .data![index]
                                                .songName);
                                            CommonWidget().showToaster(
                                                msg:
                                                    "${homepageController.getAllMusicModel!.data![index].songName} selected");
                                            setState(() {
                                              music_selected =
                                                  homepageController
                                                      .getAllMusicModel!
                                                      .data![index]
                                                      .musicFile;
                                              camera_selected = false;
                                            });
                                            Navigator.pop(context);
                                            await urlToFile();
                                          },
                                          child: Music_player2(
                                            music_url: homepageController
                                                .getAllMusicModel!
                                                .data![index]
                                                .musicFile!,
                                            title: homepageController
                                                .getAllMusicModel!
                                                .data![index]
                                                .songName!,
                                            artist_name: homepageController
                                                .getAllMusicModel!
                                                .data![index]
                                                .artistName!,
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
                                        child: Text(
                                            "${homepageController.getAllMusicModel!.message}",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontFamily: 'PR')),
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

  bool camera_selected = false;

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

  // Widget _customSnackBar() {
  //   return Align(
  //     alignment: Alignment.bottomCenter,
  //     child: SwipeTransition(
  //       visible: _exported,
  //       axisAlignment: 1.0,
  //       child: Container(
  //         height: height,
  //         width: double.infinity,
  //         color: Colors.black.withOpacity(0.8),
  //         child: Center(
  //           child: Text(_exportText,
  //               style: const TextStyle(fontWeight: FontWeight.bold)),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

//-----------------//
//CROP VIDEO SCREEN//
//-----------------//
class CropScreen extends StatelessWidget {
  const CropScreen({super.key, required this.controller});

  final VideoEditorController controller;

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
                HexColor("#C12265").withOpacity(0.67),
                HexColor("#000000").withOpacity(0.67),
              ],
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(children: [
              Row(children: [
                Expanded(
                  child: IconButton(
                    onPressed: () =>
                        controller.rotate90Degrees(RotateDirection.left),
                    icon: const Icon(Icons.rotate_left, color: Colors.white),
                  ),
                ),
                Expanded(
                  child: IconButton(
                    onPressed: () =>
                        controller.rotate90Degrees(RotateDirection.right),
                    icon: const Icon(
                      Icons.rotate_right,
                      color: Colors.white,
                    ),
                  ),
                )
              ]),
              const SizedBox(height: 15),
              // Expanded(
              //   child: AnimatedInteractiveViewer(
              //     maxScale: 2.4,
              //     child: CropGridViewer.preview(controller: controller),
              //   ),
              // ),
              const SizedBox(height: 15),
              SizedBox(
                height: 50,
                // color: Colors.yellow,

                // width: MediaQuery.of(context).size.width,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: [
                    buildSplashTap(
                      "9:16",
                      9 / 16,
                    ),
                    buildSplashTap(
                      "16:9",
                      16 / 9,
                    ),
                    buildSplashTap("1:1", 1 / 1),
                    buildSplashTap(
                      "4:5",
                      4 / 5,
                    ),
                    buildSplashTap(
                      "NO",
                      null,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(children: [
                Expanded(
                  // flex: 2,
                  child: common_button(
                    onTap: () {
                      // 2 WAYS TO UPDATE CROP
                      //WAY 1:
                      // controller.updateCrop();
                      /*WAY 2:
                        controller.minCrop = controller.cacheMinCrop;
                        controller.maxCrop = controller.cacheMaxCrop;
                        */
                      Navigator.pop(context);
                      // Get.toNamed(BindingUtils.signupOption);
                    },
                    backgroud_color: Colors.white,
                    lable_text: 'Cancel',
                    lable_text_color: Colors.black,
                  ),
                  // IconButton(
                  //   onPressed: () => Navigator.pop(context),
                  //   icon: const Center(
                  //     child: Text(
                  //       "Cancle",
                  //       style: TextStyle(
                  //           fontSize: 12,
                  //           fontWeight: FontWeight.bold,
                  //           color: Colors.white),
                  //     ),
                  //   ),
                  // ),
                ),
                Expanded(
                  // flex: 2,
                  child: common_button(
                    onTap: () {
                      // 2 WAYS TO UPDATE CROP
                      //WAY 1:
                      controller.updateCrop(Offset.zero, Offset.zero);
                      /*WAY 2:
                        controller.minCrop = controller.cacheMinCrop;
                        controller.maxCrop = controller.cacheMaxCrop;
                        */
                      Navigator.pop(context);
                      // Get.toNamed(BindingUtils.signupOption);
                    },
                    backgroud_color: HexColor(CommonColor.pinkFont),
                    lable_text: 'Crop',
                    lable_text_color: Colors.white,
                  ),
                  // child: IconButton(
                  //   onPressed: () {
                  //     //2 WAYS TO UPDATE CROP
                  //     //WAY 1:
                  //     controller.updateCrop();
                  //     /*WAY 2:
                  //   controller.minCrop = controller.cacheMinCrop;
                  //   controller.maxCrop = controller.cacheMaxCrop;
                  //   */
                  //     Navigator.pop(context);
                  //   },
                  //   icon: const Center(
                  //     child: Text(
                  //       "OK",
                  //       style: TextStyle(
                  //           fontWeight: FontWeight.bold, color: Colors.white),
                  //     ),
                  //   ),
                  // ),
                ),
              ]),
            ]),
          ),
        ),
      ],
    );
  }

  Widget buildSplashTap(
    String title,
    double? aspectRatio, {
    EdgeInsetsGeometry? padding,
  }) {
    return InkWell(
      onTap: () => controller.preferredCropAspectRatio = aspectRatio,
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.aspect_ratio_rounded, color: Colors.white),
            const SizedBox(
              height: 5,
            ),
            Text(
              title,
              style: const TextStyle(
                  color: Colors.white, fontFamily: 'PB', fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
