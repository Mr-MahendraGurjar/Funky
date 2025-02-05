import 'dart:async';
import 'dart:convert';
import 'dart:io' as Io;
import 'dart:io';

import 'package:camerawesome/camerawesome_plugin.dart';
// import 'package:camerawesome/models/orientations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:funky_new/Utils/asset_utils.dart';
import 'package:funky_new/dashboard/dashboard_screen.dart';
import 'package:funky_new/video_recorder/lib/widgets/bottom_bar.dart';
import 'package:funky_new/video_recorder/lib/widgets/preview_card.dart';
import 'package:funky_new/video_recorder/lib/widgets/top_bar.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image/image.dart' as imgUtils;
import 'package:path_provider/path_provider.dart';
import 'package:video_compress/video_compress.dart';

// import 'package:video_compress/video_compress.dart';

import '../../Utils/colorUtils.dart';
import '../../dashboard/image_editor/image_editor_plus.dart';
import '../../dashboard/image_music_screen.dart';
import '../../dashboard/story_/stories_editor.dart';
import '../../dashboard/story_/story_image_preview.dart';
import '../../dashboard/video_editor.dart';

class MyApp_video extends StatefulWidget {
  // just for E2E test. if true we create our images names from datetime.
  // Else it's just a name to assert image exists
  final bool randomPhotoName;
  final bool? story;

  const MyApp_video({super.key, this.randomPhotoName = true, this.story});

  @override
  _MyApp_videoState createState() => _MyApp_videoState();
}

class _MyApp_videoState extends State<MyApp_video>
    with TickerProviderStateMixin {
  String _lastPhotoPath = 'path';
  String _lastVideoPath = 'path';
  bool _focus = false, _fullscreen = true, _isRecordingVideo = false;

  final ValueNotifier<FlashMode> _switchFlash = ValueNotifier(FlashMode.none);
  final ValueNotifier<double> _zoomNotifier = ValueNotifier(0);
  final ValueNotifier<Size> _photoSize = ValueNotifier(Size.zero);
  final ValueNotifier<Sensor> _sensor = ValueNotifier(Sensor.position(SensorPosition.back));
  final ValueNotifier<CaptureMode> _captureMode =
      ValueNotifier(CaptureMode.photo);
  final ValueNotifier<bool> _enableAudio = ValueNotifier(true);
  final ValueNotifier<CameraOrientations> _orientation =
      ValueNotifier(CameraOrientations.portrait_up);

  /// use this to call a take picture
  //!final PictureController _pictureController = PictureController();

  /// use this to record a video
  //!final VideoController _videoController = VideoController();

  /// list of available sizes
  List<Size>? _availableSizes;

  AnimationController? _iconsAnimationController, _previewAnimationController;
  late Animation<Offset> _previewAnimation;
  Timer? _previewDismissTimer;

  // StreamSubscription<Uint8List> previewStreamSub;
  Stream<Uint8List>? previewStream;

  @override
  void initState() {
    super.initState();
    _iconsAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _previewAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1300),
      vsync: this,
    );
    _previewAnimation = Tween<Offset>(
      begin: const Offset(-2.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _previewAnimationController!,
        curve: Curves.elasticOut,
        reverseCurve: Curves.elasticIn,
      ),
    );
  }

  @override
  void dispose() {
    _iconsAnimationController!.dispose();
    _previewAnimationController!.dispose();
    // previewStreamSub.cancel();
    _photoSize.dispose();
    _captureMode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () {
            Get.to(Dashboard(page: 0));
            // Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            child: const Text('data'),
          ),
          _fullscreen ? buildFullscreenCamera() : buildSizedScreenCamera(),
          //  _buildInterface(),
          (!_isRecordingVideo)
              ? PreviewCardWidget(
                  lastPhotoPath: _lastPhotoPath,
                  orientation: _orientation,
                  previewAnimation: _previewAnimation,
                )
              : (instopvideo
                  ? Center(
                      child: Container(
                          height: 80,
                          width: 100,
                          color: Colors.transparent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CircularProgressIndicator(
                                color: HexColor(CommonColor.pinkFont),
                              ),
                            ],
                          )
                          // Material(
                          //   color: Colors.transparent,
                          //   child: LoadingIndicator(
                          //     backgroundColor: Colors.transparent,
                          //     indicatorType: Indicator.ballScale,
                          //     colors: _kDefaultRainbowColors,
                          //     strokeWidth: 4.0,
                          //     pathBackgroundColor: Colors.yellow,
                          //     // showPathBackground ? Colors.black45 : null,
                          //   ),
                          // ),
                          ),
                    )
                  : Container()),
        ],
      ),
    );
  }

  final List<int> data = <int>[
    15,
    60,
  ];
  bool seconds_15 = true;
  bool seconds_60 = false;
  int seconds_selected = 15;

  Widget _buildInterface() {
    final seconds15 = myDuration15.inSeconds.remainder(60);
    final seconds60 = myDuration60.inSeconds.remainder(60);

    return Stack(
      children: <Widget>[
        // Container(
        //   margin: EdgeInsets.only(left: 20, right: 20, top: 20),
        //   height: 50,
        //   color: Colors.black38,
        //   width: MediaQuery.of(context).size.width,
        //   child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: FormField<int>(
        //       builder: (FormFieldState<int> state) {
        //         return DropdownButtonHideUnderline(
        //           child: DropdownButton2(
        //             isExpanded: true,
        //             hint: Row(
        //               children: [
        //                 SizedBox(
        //                   width: 4,
        //                 ),
        //                 Expanded(
        //                   child: Text(
        //                     'Tax Type',
        //                     style: TextStyle(fontSize: 12, color: Colors.red),
        //                     overflow: TextOverflow.ellipsis,
        //                   ),
        //                 ),
        //               ],
        //             ),
        //             items: data
        //                 .map((item) => DropdownMenuItem<int>(
        //                       value: item,
        //                       child: Text(
        //                         "$item Seconds",
        //                         style: TextStyle(
        //                           fontSize: 14,
        //                           fontWeight: FontWeight.bold,
        //                           color: Colors.black,
        //                         ),
        //                         overflow: TextOverflow.ellipsis,
        //                       ),
        //                     ))
        //                 .toList(),
        //             value: selectedValue,
        //             onChanged: (value) {
        //               setState(() {
        //                 selectedValue = value as int;
        //               });
        //               debugPrint(selectedValue);
        //             },
        //             iconSize: 25,
        //             // icon: SvgPicture.asset(AssetUtils.drop_svg),
        //             iconEnabledColor: Color(0xff007DEF),
        //             iconDisabledColor: Color(0xff007DEF),
        //             buttonHeight: 50,
        //             buttonWidth: 160,
        //             buttonPadding: const EdgeInsets.only(left: 15, right: 15),
        //             buttonDecoration: BoxDecoration(
        //               borderRadius: BorderRadius.circular(10),
        //               color: Colors.white30,
        //             ),
        //             buttonElevation: 0,
        //             itemHeight: 40,
        //             itemPadding: const EdgeInsets.only(left: 14, right: 14),
        //             dropdownMaxHeight: 200,
        //             dropdownPadding: null,
        //             dropdownDecoration: BoxDecoration(
        //               borderRadius: BorderRadius.circular(10),
        //               color: Colors.white,
        //             ),
        //             dropdownElevation: 8,
        //             scrollbarRadius: const Radius.circular(40),
        //             scrollbarThickness: 6,
        //             scrollbarAlwaysShow: true,
        //             offset: const Offset(0, -10),
        //           ),
        //         );
        //       },
        //     ),
        //   ),
        // ),
        SafeArea(
          bottom: false,
          child: TopBarWidget(
              isFullscreen: _fullscreen,
              isRecording: _isRecordingVideo,
              enableAudio: _enableAudio,
              photoSize: _photoSize,
              captureMode: _captureMode,
              switchFlash: _switchFlash,
              orientation: _orientation,
              rotationController: _iconsAnimationController!,
              onFlashTap: () {
                switch (_switchFlash.value) {
                  case FlashMode.none:
                    _switchFlash.value = FlashMode.on;
                    break;
                  case FlashMode.on:
                    _switchFlash.value = FlashMode.auto;
                    break;
                  case FlashMode.auto:
                    _switchFlash.value = FlashMode.always;
                    break;
                  case FlashMode.always:
                    _switchFlash.value = FlashMode.none;
                    break;
                }
                setState(() {});
              },
              onAudioChange: () {
                _enableAudio.value = !_enableAudio.value;
                setState(() {});
              },
              onChangeSensorTap: () {
                _focus = !_focus;
                if (_sensor.value ==  Sensor.position(SensorPosition.front)) {
                  _sensor.value = Sensor.position(SensorPosition.back);
                } else {
                  _sensor.value = Sensor.position(SensorPosition.front);
                }
              },
              onResolutionTap: () => _buildChangeResolutionDialog(),
              onFullscreenTap: () {
                _fullscreen = !_fullscreen;
                setState(() {});
              }),
        ),
        Positioned(
          bottom: 200,
          left: 20,
          child: Container(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      seconds_15 = true;
                      seconds_60 = false;
                      seconds_selected = 15;
                    });
                    debugPrint(seconds_selected.toString());
                  },
                  child: Image.asset(
                    (seconds_15
                        ? AssetUtils.seconds_15_selected
                        : AssetUtils.seconds_15_unselected),
                    scale: 2,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      seconds_15 = false;
                      seconds_60 = true;
                      seconds_selected = 59;
                    });
                    debugPrint(seconds_60.toString());
                    debugPrint(seconds_selected.toString());
                  },
                  child: Image.asset(
                    (seconds_60
                        ? AssetUtils.seconds_60_selected
                        : AssetUtils.seconds_60_unselected),
                    scale: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
        (_captureMode.value == CaptureMode.photo
            ? const SizedBox()
            : Positioned(
                bottom: 170,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    (seconds_15
                        ? "00:$seconds15"
                        : (seconds_60 ? "00:$seconds60" : "00:$seconds15")),
                    style: const TextStyle(
                        fontSize: 16, fontFamily: 'PB', color: Colors.white),
                  ),
                ),
              )),
        BottomBarWidget(
          onZoomInTap: () {
            if (_zoomNotifier.value <= 0.9) {
              _zoomNotifier.value += 0.1;
            }
            setState(() {});
          },
          onZoomOutTap: () {
            if (_zoomNotifier.value >= 0.1) {
              _zoomNotifier.value -= 0.1;
            }
            setState(() {});
          },
          onCaptureModeSwitchChange: () {
            if (_captureMode.value == CaptureMode.photo) {
              _captureMode.value = CaptureMode.video;
            } else {
              _captureMode.value = CaptureMode.photo;
            }
            setState(() {});
          },
          onCaptureTap: (_captureMode.value == CaptureMode.photo)
              ? _takePhoto
              : (_isRecordingVideo ? _stopvideo : _recordVideo),
          rotationController: _iconsAnimationController!,
          orientation: _orientation,
          isRecording: _isRecordingVideo,
          captureMode: _captureMode,
          onChangeSensorTap: () {
            _focus = !_focus;
            if (_sensor.value == Sensor.position(SensorPosition.front)) {
              _sensor.value = Sensor.position(SensorPosition.back);
            } else {
              _sensor.value = Sensor.position(SensorPosition.front);
            }
          },
          switchFlash: _switchFlash,
          onFlashTap: () {
            switch (_switchFlash.value) {
              case FlashMode.none:
                _switchFlash.value = FlashMode.on;
                break;
              case FlashMode.on:
                _switchFlash.value = FlashMode.auto;
                break;
              case FlashMode.auto:
                _switchFlash.value = FlashMode.always;
                break;
              case FlashMode.always:
                _switchFlash.value = FlashMode.none;
                break;
            }
            setState(() {});
          },
        ),
      ],
    );
  }

  Uint8List? imageData;
  File? imgFile;

  _takePhoto() async {
    final Directory extDir = await getTemporaryDirectory();
    final testDir =
        await Directory('${extDir.path}/test').create(recursive: true);
    final String filePath = widget.randomPhotoName
        ? '${testDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg'
        : '${testDir.path}/photo_test.jpg';
    //!await _pictureController.takePicture(filePath);
    // lets just make our phone vibrate
    HapticFeedback.mediumImpact();
    _lastPhotoPath = filePath;
    setState(() {});
    if (_previewAnimationController!.status == AnimationStatus.completed) {
      _previewAnimationController!.reset();
    }
    _previewAnimationController!.forward();

    imgFile = File(filePath);
    imageData = imgFile!.readAsBytesSync();

    if (widget.story == false) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageEditor(
            image: imageData,
          ),
        ),
      ).then((editedImage) {
        if (editedImage != null) {
          setState(() async {
            // imgFile = editedImage;
            String base64String = base64Encode(editedImage);
            final decodedBytes = base64Decode(base64String);
            var file = Io.File(imgFile!.path);
            file.writeAsBytesSync(decodedBytes);
            debugPrint(file.path.split('/').last);
            imgFile = file;
            await Get.to(ImageMusicScreen(
              ImageData: imgFile!,
            ));
            // Get.to(PostImagePreviewScreen(
            //   ImageFile: editedImage!,
            // ));
            // Navigator.pop(context);
          });
        }
      }).catchError((er) {
        debugPrint(er);
      });
    } else {
      File editedFile = await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => StoriesEditor(
                // fontFamilyList: font_family,
                giphyKey:
                    'https://giphy.com/gifs/congratulations-congrats-xT0xezQGU5xCDJuCPe',
                imageData: imgFile,
                onDone: (String) {},
                // filePath:
                //     imgFile!.path,
              )));
      debugPrint('editedFile: ${editedFile.path}');
      await Get.to(Story_image_preview(
        single_image: editedFile,
        single: true,
      ));
    }
    debugPrint("----------------------------------");
    debugPrint("TAKE PHOTO CALLED");
    final file = File(filePath);
    debugPrint("==> hastakePhoto : ${file.exists()} | path : $filePath");
    final img = imgUtils.decodeImage(file.readAsBytesSync());
    debugPrint("==> img.width : ${img!.width} | img.height : ${img.height}");
    debugPrint("----------------------------------");
  }

  Timer? countdownTimer_15;
  Timer? countdownTimer_60;
  Duration myDuration15 = const Duration(seconds: 15);
  Duration myDuration60 = const Duration(seconds: 59);

  void startTimer_15() {
    countdownTimer_15 =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown_15());
  }

  void startTimer_60() {
    countdownTimer_60 =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown_60());
  }

  void setCountDown_15() {
    const reduceSecondsBy = 1;
    setState(() {
      final seconds15 = myDuration15.inSeconds - reduceSecondsBy;
      if (seconds15 < 0) {
        countdownTimer_15!.cancel();
        debugPrint('timesup');
      } else {
        myDuration15 = Duration(seconds: seconds15);
      }
    });
  }

  void setCountDown_60() {
    const reduceSecondsBy = 1;
    setState(() {
      final seconds60 = myDuration60.inSeconds - reduceSecondsBy;
      if (seconds60 < 0) {
        countdownTimer_60!.cancel();
        debugPrint('timesup');
        // _stopvideo();
      } else {
        myDuration60 = Duration(seconds: seconds60);
      }
    });
  }

  startWatch() {
    setState(() {
      watch.start();
      // startTimer();
      timer = Timer.periodic(const Duration(microseconds: 100), updateTime);
    });
  }

  stopWatch() {
    setState(() {
      watch.stop();
      _stopvideo();
      setTime();
    });
  }

  setTime() {
    var timeSoFar = watch.elapsedMilliseconds;
    setState(() {
      elapsedTime = transformMilliSeconds(timeSoFar);
    });
    debugPrint("elapsedTime $elapsedTime");
  }

  transformMilliSeconds(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();
    int hours = (minutes / 60).truncate();

    String hoursStr = (hours % 60).toString().padLeft(2, '0');
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    return "$minutesStr:$secondsStr";
  }

  Stopwatch watch = Stopwatch();
  Timer? timer;
  bool startStop = true;
  bool started = true;

  String elapsedTime = '00:00';

  updateTime(Timer timer) async {
    if (watch.isRunning) {
      if (mounted) {
        setState(() {
          // debugPrint("startstop Inside=$startStop");
          elapsedTime = transformMilliSeconds(watch.elapsedMilliseconds);
        });
        // if (elapsedTime == seconds_selected) {
        //   // stopWatch();
        //   // showLoader(context);
        //   // setState(() {
        //   //   _isRecordingVideo = true;
        //   // });
        //   // _recordVideo();
        //   debugPrint("15 seconds complete");
        //   debugPrint("inside stop video");
        //   await _videoController.stopRecordingVideo();
        //
        //   // setState(() {
        //   //   _isRecordingVideo = false;
        //   // });
        //   // setState(() {});
        //
        //   final file = File(_lastVideoPath);
        //   debugPrint("----------------------------------");
        //   debugPrint("VIDEO RECORDED");
        //   debugPrint(
        //       "==> has been recorded : ${file.exists()} | path : $_lastVideoPath");
        //   debugPrint("----------------------------------");
        //
        //   await Future.delayed(Duration(milliseconds: 300));
        //   MediaInfo? mediaInfo = await VideoCompress.compressVideo(
        //     _lastVideoPath,
        //     quality: VideoQuality.MediumQuality,
        //     deleteOrigin: false, // It's false by default
        //   );
        //   debugPrint("page navigation");
        //   // await hideLoader(context);
        //   await Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => VideoEditor(
        //               file: File(mediaInfo!.path!),
        //             )
        //         //     CameraPreview(
        //         //   videoPath: _lastVideoPath,
        //         // ),
        //         ),
        //   );
        //   // start_animation();
        // }
      }
    }
  }

  bool instopvideo = false;

  _stopvideo() async {
    debugPrint("inside stop video");
    //!await _videoController.stopRecordingVideo();

    setState(() {
      instopvideo = true;
      _isRecordingVideo = false;
    });
    setState(() {});

    final file = File(_lastVideoPath);
    debugPrint("----------------------------------");
    debugPrint("VIDEO RECORDED");
    debugPrint("==> has been recorded : ${file.exists()} | path : $_lastVideoPath");
    debugPrint("----------------------------------");

    Fluttertoast.showToast(
      msg: "Please Wait",
      timeInSecForIosWeb: 5,
      textColor: Colors.black,
      backgroundColor: Colors.white,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );
    MediaInfo? mediaInfo = await VideoCompress.compressVideo(
      _lastVideoPath,
      quality: VideoQuality.MediumQuality,
      deleteOrigin: false, // It's false by default
    );
    debugPrint("page navigation");
    setState(() {
      instopvideo = false;
    });
    (widget.story == false
        ? await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VideoEditor(
                      file: File(mediaInfo!.path!),
                      creator: true,
                    )
                //     CameraPreview(
                //   videoPath: _lastVideoPath,
                // ),
                ),
          )
        : await Get.to(Story_image_preview(
            single_image: File(mediaInfo!.path!),
            single: true,
          )));
  }

  _recordVideo() async {
    // lets just make our phone vibrate
    HapticFeedback.mediumImpact();

    // if (_isRecordingVideo) {
    //   // stopWatch();
    //   debugPrint("inside stop video");
    //   await _videoController.stopRecordingVideo();
    //
    //   setState(() {
    //     _isRecordingVideo = false;
    //   });
    //   setState(() {});
    //
    //   final file = File(_lastVideoPath);
    //   debugPrint("----------------------------------");
    //   debugPrint("VIDEO RECORDED");
    //   debugPrint(
    //       "==> has been recorded : ${file.exists()} | path : $_lastVideoPath");
    //   debugPrint("----------------------------------");
    //
    //   await Future.delayed(Duration(milliseconds: 300));
    //   MediaInfo? mediaInfo = await VideoCompress.compressVideo(
    //     _lastVideoPath,
    //     quality: VideoQuality.MediumQuality,
    //     deleteOrigin: false, // It's false by default
    //   );
    //   debugPrint("page navigation");
    //   await Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => VideoEditor(
    //               file: File(mediaInfo!.path!),
    //             )
    //         //     CameraPreview(
    //         //   videoPath: _lastVideoPath,
    //         // ),
    //         ),
    //   );
    // } else {
    //   final Directory extDir = await getTemporaryDirectory();
    //   final testDir =
    //       await Directory('${extDir.path}/test').create(recursive: true);
    //   final String filePath = widget.randomPhotoName
    //       ? '${testDir.path}/${DateTime.now().millisecondsSinceEpoch}.mp4'
    //       : '${testDir.path}/video_test.mp4';
    //   await _videoController.recordVideo(filePath);
    //   _isRecordingVideo = true;
    //   _lastVideoPath = filePath;
    //   setState(() {});
    //   // startTimer();
    //
    // }
    final Directory extDir = await getTemporaryDirectory();
    final testDir =
        await Directory('${extDir.path}/test').create(recursive: true);
    final String filePath = widget.randomPhotoName
        ? '${testDir.path}/${DateTime.now().millisecondsSinceEpoch}.mp4'
        : '${testDir.path}/video_test.mp4';
    // await VideoCompress.setLogLevel(0);
    // final mediaInfo = await VideoCompress.compressVideo(
    //   filePath,
    //   quality: VideoQuality.MediumQuality,
    //   deleteOrigin: false,
    //   includeAudio: true,// It's false by default
    // );
    //! await _videoController.recordVideo(filePath);
    _isRecordingVideo = true;
    _lastVideoPath = filePath;
    setState(() {});
    debugPrint("seconds_15 $seconds_15");
    debugPrint("seconds_60 $seconds_60");
    if (seconds_15) {
      startTimer_15();
      Future.delayed(const Duration(seconds: 17), () {
        _stopvideo();
      });
    } else if (seconds_60) {
      startTimer_60();
      Future.delayed(const Duration(seconds: 62), () {
        _stopvideo();
      });
    }

    // startWatch();
  }

  _buildChangeResolutionDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView.separated(
        itemBuilder: (context, index) => ListTile(
          key: const ValueKey("resOption"),
          onTap: () {
            _photoSize.value = _availableSizes![index];
            setState(() {});
            Navigator.of(context).pop();
          },
          leading: const Icon(Icons.aspect_ratio),
          title: Text(
              "${_availableSizes![index].width}/${_availableSizes![index].height}"),
        ),
        separatorBuilder: (context, index) => const Divider(),
        itemCount: _availableSizes!.length,
      ),
    );
  }

  _onOrientationChange(CameraOrientations? newOrientation) {
    _orientation.value = newOrientation!;
    if (_previewDismissTimer != null) {
      _previewDismissTimer!.cancel();
    }
  }

  _onPermissionsResult(bool? granted) {
    if (!granted!) {
      AlertDialog alert = AlertDialog(
        title: const Text('Error'),
        content: const Text(
            'It seems you doesn\'t authorized some permissions. Please check on your settings and try again.'),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    } else {
      setState(() {});
      debugPrint("granted");
    }
  }

  // /// this is just to preview images from stream
  // /// This use a bufferTime to take an image each 1500 ms
  // /// you cannot show every frame as flutter cannot draw them fast enough
  // /// [THIS IS JUST FOR DEMO PURPOSE]
  // Widget _buildPreviewStream() {
  //   if (previewStream == null) return Container();
  //   return Positioned(
  //     left: 32,
  //     bottom: 120,
  //     child: StreamBuilder(
  //       stream: previewStream.bufferTime(Duration(milliseconds: 1500)),
  //       builder: (context, snapshot) {
  //         debugPrint(snapshot);
  //         if (!snapshot.hasData || snapshot.data == null) return Container();
  //         List<Uint8List> data = snapshot.data;
  //         debugPrint(
  //             "...${DateTime.now()} new image received... ${data.last.lengthInBytes} bytes");
  //         return Image.memory(
  //           data.last,
  //           width: 120,
  //         );
  //       },
  //     ),
  //   );
  // }

  Widget buildFullscreenCamera() {
    return Positioned(
        top: 0,
        left: 0,
        bottom: 0,
        right: 0,
        child: Center(
          child: CameraAwesomeBuilder.awesome(
            saveConfig: SaveConfig.photoAndVideo(
              // photoPathBuilder: () => _path(CaptureMode.photo),
              // videoPathBuilder: () => _path(CaptureMode.video),
              initialCaptureMode: CaptureMode.photo,
            ),
            sensorConfig: SensorConfig.single(
              sensor: Sensor.position(SensorPosition.back),
              flashMode: FlashMode.auto,
              aspectRatio: CameraAspectRatios.ratio_16_9,
            ),
            previewFit: CameraPreviewFit.fitWidth,
            onMediaTap: (mediaCapture) {
              onMediaTap(mediaCapture);
              //OpenFile.open(mediaCapture.filePath);
            },
          ),
        ));
  }

  void onMediaTap(MediaCapture mediaCapture) async {
    HapticFeedback.mediumImpact();
    //_lastPhotoPath = filePath;
    setState(() {});
    if (_previewAnimationController!.status == AnimationStatus.completed) {
      _previewAnimationController!.reset();
    }
    _previewAnimationController!.forward();

    imgFile = File(mediaCapture.captureRequest.path!);
    imageData = imgFile!.readAsBytesSync();
    if (mediaCapture.isVideo) {
      // MediaInfo? mediaInfo = await VideoCompress.compressVideo(
      //   _lastVideoPath,
      //   quality: VideoQuality.MediumQuality,
      //   deleteOrigin: false, // It's false by default
      // );
      (widget.story == false
          ? await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VideoEditor(
                        file: File(mediaCapture.captureRequest.path!),
                        creator: true,
                      )
                  //     CameraPreview(
                  //   videoPath: _lastVideoPath,
                  // ),
                  ),
            )
          : await Get.to(Story_image_preview(
              single_image: File(mediaCapture.captureRequest.path!),
              single: true,
            )));
    }
    if (widget.story == false) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageEditor(
            image: imageData,
          ),
        ),
      ).then((editedImage) {
        if (editedImage != null) {
          setState(() async {
            // imgFile = editedImage;
            String base64String = base64Encode(editedImage);
            final decodedBytes = base64Decode(base64String);
            var file = Io.File(imgFile!.path);
            file.writeAsBytesSync(decodedBytes);
            debugPrint(file.path.split('/').last);
            imgFile = file;
            await Get.to(ImageMusicScreen(
              ImageData: imgFile!,
            ));
            // Get.to(PostImagePreviewScreen(
            //   ImageFile: editedImage!,
            // ));
            // Navigator.pop(context);
          });
        }
      }).catchError((er) {
        debugPrint(er);
      });
    } else {
      File editedFile = await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => StoriesEditor(
                // fontFamilyList: font_family,
                giphyKey:
                    'https://giphy.com/gifs/congratulations-congrats-xT0xezQGU5xCDJuCPe',
                imageData: imgFile,
                onDone: (String) {},
                // filePath:
                //     imgFile!.path,
              )));
      debugPrint('editedFile: ${editedFile.path}');
      await Get.to(Story_image_preview(
        single_image: editedFile,
        single: true,
      ));
    }
    debugPrint("----------------------------------");
    debugPrint("TAKE PHOTO CALLED");
    final file = File(mediaCapture.captureRequest.path!);
    debugPrint(
        "==> hastakePhoto : ${file.exists()} | path : ${mediaCapture.captureRequest.path!}");
    final img = imgUtils.decodeImage(file.readAsBytesSync());
    debugPrint("==> img.width : ${img!.width} | img.height : ${img.height}");
    debugPrint("----------------------------------");
  }

  Future<String> _path(CaptureMode captureMode) async {
    final Directory extDir = await getTemporaryDirectory();
    final testDir =
        await Directory('${extDir.path}/test').create(recursive: true);
    final String fileExtension =
        captureMode == CaptureMode.photo ? 'jpg' : 'mp4';
    final String filePath =
        '${testDir.path}/${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
    return filePath;
  }

  Widget buildSizedScreenCamera() {
    return Positioned(
        top: 0,
        left: 0,
        bottom: 0,
        right: 0,
        child: Container(
            color: Colors.black,
            child: Center(
              child: SizedBox(
                height: 300,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: CameraAwesomeBuilder.awesome(
                    saveConfig: SaveConfig.photoAndVideo(
                      // photoPathBuilder: () => _path(CaptureMode.photo),
                      // videoPathBuilder: () => _path(CaptureMode.video),
                      initialCaptureMode: CaptureMode.photo,
                    ),
                    // filter: AwesomeFilter.AddictiveRed,
                    // flashMode: FlashMode.auto,
                    // aspectRatio: CameraAspectRatios.ratio_16_9,
                    sensorConfig: SensorConfig.single(
                      sensor: Sensor.position(SensorPosition.back),
                      flashMode: FlashMode.auto,
                      aspectRatio: CameraAspectRatios.ratio_16_9,
                    ),
                    previewFit: CameraPreviewFit.fitWidth,
                    onMediaTap: (mediaCapture) {
                      onMediaTap(mediaCapture);
                      //OpenFile.open(mediaCapture.filePath);
                    },
                  ),
                  // CameraAwesome(
                  //   onPermissionsResult: _onPermissionsResult,
                  //   selectDefaultSize: (availableSizes) {
                  //     _availableSizes = availableSizes;
                  //     return availableSizes[0];
                  //   },
                  //   captureMode: _captureMode,
                  //   photoSize: _photoSize,
                  //   sensor: _sensor,
                  //   fitted: true,
                  //   switchFlashMode: _switchFlash,
                  //   zoom: _zoomNotifier,
                  //   onOrientationChanged: _onOrientationChange,
                  // ),
                ),
              ),
            )));
  }
}
