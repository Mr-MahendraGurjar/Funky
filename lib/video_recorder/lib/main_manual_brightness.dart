import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:camerawesome/camerawesome_plugin.dart';

// import 'package:camerawesome/models/orientations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:funky_new/video_recorder/lib/utils/orientation_utils.dart';
import 'package:funky_new/video_recorder/lib/widgets/camera_buttons.dart';
import 'package:funky_new/video_recorder/lib/widgets/take_photo_button.dart';
import 'package:image/image.dart' as imgUtils;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatefulWidget {
  // just for E2E test. if true we create our images names from datetime.
  // Else it's just a name to assert image exists
  final bool randomPhotoName;

  const MyApp({super.key, this.randomPhotoName = true});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  double? bestSizeRatio;

  String? _lastPhotoPath;

  bool focus = false;

  bool fullscreen = true;

  ValueNotifier<FlashMode> switchFlash = ValueNotifier(FlashMode.none);

  ValueNotifier<double> zoomNotifier = ValueNotifier(0);
  ValueNotifier<Size> photoSize = ValueNotifier(Size.zero);
  ValueNotifier<Sensor> sensor = ValueNotifier(Sensor.position(SensorPosition.back));
  ValueNotifier<double> brightnessCorrection = ValueNotifier(0);

  // ValueNotifier<CaptureModes> captureMode = ValueNotifier(CaptureModes.PHOTO);
  ValueNotifier<bool> enableAudio = ValueNotifier(true);

  double sliderBrightnessValue = 0;

  /// use this to call a take picture
  // !final PictureController _pictureController = PictureController();

  /// list of available sizes
  List<Size> availableSizes = [];

  AnimationController? _iconsAnimationController;

  AnimationController? _previewAnimationController;

  Animation<Offset>? _previewAnimation;

  bool animationPlaying = false;

  Timer? _previewDismissTimer;

  final ValueNotifier<CameraOrientations> _orientation = ValueNotifier(CameraOrientations.portrait_up);

  // StreamSubscription<Uint8List> previewStreamSub;

  Stream<SensorData>? brightnessStream;

  @override
  void initState() {
    super.initState();
    _iconsAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animationPlaying = false;
        }
      });

    _previewAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1300),
      vsync: this,
    );
    _previewAnimation = Tween<Offset>(
      begin: const Offset(-2.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: _previewAnimationController!, curve: Curves.elasticOut, reverseCurve: Curves.elasticIn));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _iconsAnimationController!.dispose();
    _previewAnimationController!.dispose();
    brightnessCorrection.dispose();
    // previewStreamSub.cancel();
    photoSize.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Alignment alignment;
    bool mirror;
    switch (_orientation.value) {
      case CameraOrientations.portrait_up:
      case CameraOrientations.portrait_down:
        alignment =
            _orientation.value == CameraOrientations.portrait_up ? Alignment.bottomLeft : Alignment.topLeft;
        mirror = _orientation.value == CameraOrientations.portrait_down;
        break;
      case CameraOrientations.landscape_left:
      case CameraOrientations.landscape_right:
        alignment = Alignment.topLeft;
        mirror = _orientation.value == CameraOrientations.landscape_left;
        break;
    }

    return Scaffold(
        body: Stack(
      fit: StackFit.expand,
      children: <Widget>[
        fullscreen ? buildFullscreenCamera() : buildSizedScreenCamera(),
        _buildInterface(),
        Align(
          alignment: alignment,
          child: Padding(
            padding: OrientationUtils.isOnPortraitMode(_orientation.value)
                ? const EdgeInsets.symmetric(horizontal: 35.0, vertical: 140)
                : const EdgeInsets.symmetric(vertical: 65.0),
            child: Transform.rotate(
              angle: OrientationUtils.convertOrientationToRadian(
                _orientation.value,
              ),
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(mirror ? pi : 0.0),
                child: Dismissible(
                  onDismissed: (direction) {},
                  key: UniqueKey(),
                  child: SlideTransition(
                    position: _previewAnimation!,
                    child: _buildPreviewPicture(reverseImage: mirror),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ));
  }

  Widget _buildPreviewPicture({bool reverseImage = false}) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            offset: Offset(2, 2),
            blurRadius: 25,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(13.0),
          child: _lastPhotoPath != null
              ? Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(reverseImage ? pi : 0.0),
                  child: Image.file(
                    File(_lastPhotoPath!),
                    width: OrientationUtils.isOnPortraitMode(_orientation.value) ? 128 : 256,
                  ),
                )
              : Container(
                  width: OrientationUtils.isOnPortraitMode(_orientation.value) ? 128 : 256,
                  height: 228,
                  decoration: const BoxDecoration(
                    color: Colors.black38,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.photo,
                      color: Colors.white,
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildInterface() {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          _buildTopBar(),
          // _buildBottomBar(),
          _buildLeftManualBrightness(),
        ],
      ),
    );
  }

  Widget _buildLeftManualBrightness() {
    return Positioned(
      left: 32,
      bottom: 300,
      child: RotatedBox(
        quarterTurns: -1,
        child: Slider(
          value: brightnessCorrection.value,
          min: 0,
          max: 1,
          divisions: 10,
          label: brightnessCorrection.value.toStringAsFixed(2),
          onChanged: (double value) => setState(() => brightnessCorrection.value = value),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 24.0),
                child: IconButton(
                  icon: Icon(fullscreen ? Icons.fullscreen_exit : Icons.fullscreen, color: Colors.white),
                  onPressed: () => setState(() => fullscreen = !fullscreen),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ValueListenableBuilder(
                      valueListenable: photoSize,
                      builder: (context, value, child) => TextButton(
                        key: const ValueKey("resolutionButton"),
                        onPressed: _buildChangeResolutionDialog,
                        child: Text(
                          '${MediaQuery.of(context).size.width.toInt()} / ${MediaQuery.of(context).size.width.toInt()}',
                          key: const ValueKey("resolutionTxt"),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              OptionButton(
                icon: Icons.switch_camera,
                rotationController: _iconsAnimationController!,
                orientation: _orientation,
                onTapCallback: () async {
                  focus = !focus;
                  if (sensor.value == Sensor.position(SensorPosition.front)) {
                    sensor.value = Sensor.position(SensorPosition.back);
                  } else {
                    sensor.value = Sensor.position(SensorPosition.front);
                  }
                },
              ),
              const SizedBox(
                width: 20.0,
              ),
              OptionButton(
                rotationController: _iconsAnimationController!,
                icon: _getFlashIcon(),
                orientation: _orientation,
                onTapCallback: () {
                  switch (switchFlash.value) {
                    case FlashMode.none:
                      switchFlash.value = FlashMode.on;
                      break;
                    case FlashMode.on:
                      switchFlash.value = FlashMode.auto;
                      break;
                    case FlashMode.auto:
                      switchFlash.value = FlashMode.always;
                      break;
                    case FlashMode.always:
                      switchFlash.value = FlashMode.none;
                      break;
                  }
                  setState(() {});
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getFlashIcon() {
    switch (switchFlash.value) {
      case FlashMode.none:
        return Icons.flash_off;
      case FlashMode.on:
        return Icons.flash_on;
      case FlashMode.auto:
        return Icons.flash_auto;
      case FlashMode.always:
        return Icons.highlight;
      default:
        return Icons.flash_off;
    }
  }

  Widget _buildBottomBar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 32.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            OptionButton(
              icon: Icons.zoom_out,
              rotationController: _iconsAnimationController!,
              orientation: _orientation,
              onTapCallback: () {
                if (zoomNotifier.value >= 0.1) {
                  zoomNotifier.value -= 0.1;
                }
                setState(() {});
              },
            ),
            CameraButton(
              key: const ValueKey("cameraButton"),
              onTap: () async {
                final Directory extDir = await getTemporaryDirectory();
                var testDir = await Directory('${extDir.path}/test').create(recursive: true);
                final String filePath = widget.randomPhotoName
                    ? '${testDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg'
                    : '${testDir.path}/photo_test.jpg';
                //!await _pictureController.takePicture(filePath);
                // lets just make our phone vibrate
                HapticFeedback.mediumImpact();
                setState(() {
                  _lastPhotoPath = filePath;
                });
                if (_previewAnimationController!.status == AnimationStatus.completed) {
                  _previewAnimationController!.reset();
                }
                _previewAnimationController!.forward();
                print("----------------------------------");
                print("TAKE PHOTO CALLED");
                var file = File(filePath);
                print("==> hastakePhoto : ${file.exists()}");
                print("==> path : $filePath");
                var img = imgUtils.decodeImage(file.readAsBytesSync());
                print("==> img.width : ${img!.width}");
                print("==> img.height : ${img.height}");
                print("----------------------------------");
              },
            ),
            OptionButton(
              icon: Icons.zoom_in,
              rotationController: _iconsAnimationController!,
              orientation: _orientation,
              onTapCallback: () {
                if (zoomNotifier.value <= 0.9) {
                  zoomNotifier.value += 0.1;
                }
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }

  _buildChangeResolutionDialog() {
    showModalBottomSheet(
        context: context,
        builder: (context) => ListView.separated(
            itemBuilder: (context, index) => ListTile(
                  key: const ValueKey("resOption"),
                  onTap: () {
                    setState(() {
                      photoSize.value = availableSizes[index];
                      Navigator.of(context).pop();
                    });
                  },
                  leading: const Icon(Icons.aspect_ratio),
                  title: Text("${availableSizes[index].width}/${availableSizes[index].height}"),
                ),
            separatorBuilder: (context, index) => const Divider(),
            itemCount: availableSizes.length));
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
      print("granted");
    }
  }

  Widget buildFullscreenCamera() {
    return Positioned(
      top: 0,
      left: 0,
      bottom: 0,
      right: 0,
      child: Center(
        child: CameraAwesomeBuilder.awesome(
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
            OpenFile.open(mediaCapture.captureRequest.path);
          },
          saveConfig: SaveConfig.photoAndVideo(
            // photoPathBuilder: (sensors) {},
            // videoPathBuilder: (sensors) {},
            initialCaptureMode: CaptureMode.photo,
          ),
        ),
      ),
      // CameraAwesomeBuilder.awesome(
      //   saveConfig: SaveConfig.photoAndVideo(photoPathBuilder: () async {
      //     return '';
      //   }, videoPathBuilder: () async {
      //     return '';
      //   }),
      //   onMediaTap: (mediaCapture) {
      //     OpenFile.open(mediaCapture.filePath);
      //   },
      // ),
      //  CameraAwesome(
      //   onPermissionsResult: _onPermissionsResult,
      //   selectDefaultSize: (availableSizes) {
      //     this.availableSizes = availableSizes;
      //     return availableSizes[0];
      //   },
      //   captureMode: captureMode,
      //   photoSize: photoSize,
      //   sensor: sensor,
      //   brightness: brightnessCorrection,
      //   luminosityLevelStreamBuilder: (s) => brightnessStream = s,
      //   switchFlashMode: switchFlash,
      //   zoom: zoomNotifier,
      //   onOrientationChanged: _onOrientationChange,
      // ),
    );
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
            // filter: AwesomeFilter.AddictiveRed,
            // flashMode: FlashMode.auto,
            // aspectRatio: CameraAspectRatios.ratio_16_9,
            previewFit: CameraPreviewFit.fitWidth,
            onMediaTap: (mediaCapture) {
              OpenFile.open(mediaCapture.captureRequest.path);
            },
          ),
        )
            // CameraAwesomeBuilder.awesome(
            //   saveConfig:
            //       SaveConfig.photoAndVideo(photoPathBuilder: () async {
            //     return '';
            //   }, videoPathBuilder: () async {
            //     return '';
            //   }),
            //   onMediaTap: (mediaCapture) {
            //     OpenFile.open(mediaCapture.filePath);
            //   },
            // ),
            // CameraAwesome(
            //   onPermissionsResult: _onPermissionsResult,
            //   selectDefaultSize: (availableSizes) {
            //     this.availableSizes = availableSizes;
            //     return availableSizes[0];
            //   },
            //   captureMode: captureMode,
            //   photoSize: photoSize,
            //   brightness: brightnessCorrection,
            //   luminosityLevelStreamBuilder: (s) => brightnessStream = s,
            //   sensor: sensor,
            //   fitted: true,
            //   switchFlashMode: switchFlash,
            //   zoom: zoomNotifier,
            //   onOrientationChanged: _onOrientationChange,
            // ),
            ),
      ),
    );
  }
}
