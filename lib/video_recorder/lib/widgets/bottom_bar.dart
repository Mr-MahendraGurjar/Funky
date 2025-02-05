// import 'package:camerawesome/models/capture_modes.dart';
// import 'package:camerawesome/models/flashmodes.dart';
// import 'package:camerawesome/models/orientations.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:funky_new/video_recorder/lib/widgets/take_photo_button.dart';

import 'camera_buttons.dart';

class BottomBarWidget extends StatelessWidget {
  final AnimationController rotationController;
  final ValueNotifier<CameraOrientations> orientation;
  final ValueNotifier<CaptureMode> captureMode;
  final ValueNotifier<FlashMode> switchFlash;

  final bool isRecording;
  final Function onZoomInTap;
  final Function onZoomOutTap;
  final Function onCaptureTap;
  final Function onCaptureModeSwitchChange;

  final Function onChangeSensorTap;
  final Function onFlashTap;

  const BottomBarWidget({
    super.key,
    required this.rotationController,
    required this.orientation,
    required this.isRecording,
    required this.captureMode,
    required this.onZoomOutTap,
    required this.onZoomInTap,
    required this.onCaptureTap,
    required this.onCaptureModeSwitchChange,
    required this.switchFlash,
    required this.onChangeSensorTap,
    required this.onFlashTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SizedBox(
        height: 200,
        child: Stack(
          children: [
            Container(
              color: Colors.transparent,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    // OptionButton(
                    //   icon: Icons.zoom_out,
                    //   rotationController: rotationController,
                    //   orientation: orientation,
                    //   onTapCallback: () => onZoomOutTap.call(),
                    // ),
                    OptionButton(
                      icon: Icons.switch_camera,
                      rotationController: rotationController,
                      orientation: orientation,
                      onTapCallback: () => onChangeSensorTap.call(),
                    ),
                    CameraButton(
                      key: const ValueKey('cameraButton'),
                      captureMode: captureMode.value,
                      isRecording: isRecording,
                      onTap: () => onCaptureTap.call(),
                    ),
                    OptionButton(
                      rotationController: rotationController,
                      icon: _getFlashIcon(),
                      orientation: orientation,
                      onTapCallback: () => onFlashTap.call(),
                    ),
                    // OptionButton(
                    //   icon: Icons.zoom_in,
                    //   rotationController: rotationController,
                    //   orientation: orientation,
                    //   onTapCallback: () => onZoomInTap.call(),
                    // ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.photo_camera,
                      color: Colors.white,
                    ),
                    Switch(
                      key: const ValueKey('captureModeSwitch'),
                      value: (captureMode.value == CaptureMode.video),
                      activeColor: const Color(0xFFC12265),
                      onChanged: !isRecording
                          ? (value) {
                              HapticFeedback.heavyImpact();
                              onCaptureModeSwitchChange.call();
                            }
                          : null,
                    ),
                    const Icon(
                      Icons.videocam,
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
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
}
