// import 'package:camera/camera.dart';
// import 'package:camerawesome/camerawesome_plugin.dart';
// import 'package:camerawesome/models/capture_modes.dart';
// import 'package:camerawesome/models/flashmodes.dart';
// import 'package:camerawesome/models/orientations.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';

import 'camera_buttons.dart';

class TopBarWidget extends StatelessWidget {
  final bool isFullscreen;
  final bool isRecording;
  final ValueNotifier<Size> photoSize;
  final AnimationController rotationController;
  final ValueNotifier<CameraOrientations> orientation;
  final ValueNotifier<CaptureMode> captureMode;
  final ValueNotifier<bool> enableAudio;
  final ValueNotifier<FlashMode> switchFlash;
  final Function onFullscreenTap;

  // final String SelectedValue;
  final Function onResolutionTap;

  // final List data;
  final Function onChangeSensorTap;
  final Function onFlashTap;
  final Function onAudioChange;

  const TopBarWidget({
    super.key,
    required this.isFullscreen,
    required this.isRecording,
    required this.captureMode,
    required this.enableAudio,
    required this.photoSize,
    required this.orientation,
    required this.rotationController,
    required this.switchFlash,
    required this.onFullscreenTap,
    required this.onAudioChange,
    required this.onFlashTap,
    required this.onChangeSensorTap,
    required this.onResolutionTap,
    // equired this.SelectedValue, required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
      child: Column(
        children: <Widget>[
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              // Padding(
              //   padding: const EdgeInsets.only(right: 24.0),
              //   child: Opacity(
              //     opacity: isRecording ? 0.3 : 1.0,
              //     child: IconButton(
              //       icon: Icon(
              //         isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
              //         color: Colors.white,
              //       ),
              //       onPressed:
              //           isRecording ? null : () => onFullscreenTap.call(),
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(right: 24),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: <Widget>[
              //       IgnorePointer(
              //         ignoring: isRecording,
              //         child: Opacity(
              //           opacity: isRecording ? 0.3 : 1.0,
              //           child: ValueListenableBuilder(
              //             valueListenable: photoSize,
              //             builder: (context, value, child) => TextButton(
              //               key: ValueKey("resolutionButton"),
              //               onPressed: () {
              //                 HapticFeedback.selectionClick();
              //
              //                 onResolutionTap.call();
              //               },
              //               child: Text(
              //                 '${MediaQuery.of(context).size.width.toInt()} / ${MediaQuery.of(context).size.width.toInt()}',
              //                 key: ValueKey("resolutionTxt"),
              //                 style: TextStyle(color: Colors.white),
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // OptionButton(
              //   icon: Icons.switch_camera,
              //   rotationController: rotationController,
              //   orientation: orientation,
              //   onTapCallback: () => onChangeSensorTap.call(),
              // ),
              // SizedBox(width: 20.0),
              // OptionButton(
              //   rotationController: rotationController,
              //   icon: _getFlashIcon(),
              //   orientation: orientation,
              //   onTapCallback: () => onFlashTap.call(),
              // ),
            ],
          ),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              captureMode.value == CaptureMode.video
                  ? OptionButton(
                      icon: enableAudio.value ? Icons.mic : Icons.mic_off,
                      rotationController: rotationController,
                      orientation: orientation,
                      isEnabled: !isRecording,
                      onTapCallback: () => onAudioChange.call(),
                    )
                  : Container(),
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
}
