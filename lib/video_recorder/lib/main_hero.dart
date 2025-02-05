import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';

var globalCameraKey = GlobalKey();
var globalCameraKey2 = GlobalKey();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/': (context) => const MyHomePage(title: 'CameraAwesome'),
        '/full': (context) => Scaffold(
              body: Hero(
                tag: 'camera',
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Scaffold(
                    appBar: AppBar(),
                    body: const CameraView(fit: false),
                  ),
                ),
              ),
            ),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Hero(
        tag: 'camera',
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed('/full');
          },
          child: const Center(
            child: SizedBox(height: 400, child: CameraView()),
          ),
        ),
      ),
    );
  }
}

class CameraView extends StatelessWidget {
  // final _switchFlash = ValueNotifier(CameraFlashes.NONE);
  // final _sensor = ValueNotifier(Sensors.BACK);
  // final _photoSize = ValueNotifier<Size>(Size.zero);
  // final _captureMode = ValueNotifier(CaptureModes.PHOTO);
  final cameraKey = const ValueKey("camera");
  final bool fit;

  const CameraView({super.key, this.fit = true});

  @override
  Widget build(BuildContext context) {
    return CameraAwesomeBuilder.awesome(
        sensorConfig:
            SensorConfig.single(sensor: Sensor.position(SensorPosition.back), flashMode: FlashMode.none),
        saveConfig: SaveConfig.photoAndVideo()

        //! builder: (state, previewSize, previewRect) {
        //   // create your interface here
        // },
        // key: cameraKey,
        // testMode: false,
        // captureMode: _captureMode,
        // onPermissionsResult: (result) {},
        // selectDefaultSize: (availableSizes) => availableSizes.first,
        // onCameraStarted: () {},
        // onOrientationChanged: (newOrientation) {},
        // sensor: _sensor,
        // photoSize: _photoSize,
        // switchFlashMode: _switchFlash,
        // fitted: fit,
        );
  }
}
