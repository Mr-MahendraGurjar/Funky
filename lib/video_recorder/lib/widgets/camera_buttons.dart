import 'dart:math';

import 'package:camerawesome/camerawesome_plugin.dart';
// import 'package:camerawesome/models/orientations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/orientation_utils.dart';

class OptionButton extends StatefulWidget {
  final IconData icon;
  final Function onTapCallback;
  final AnimationController rotationController;
  final ValueNotifier<CameraOrientations> orientation;
  final bool isEnabled;

  const OptionButton({
    super.key,
    required this.icon,
    required this.onTapCallback,
    required this.rotationController,
    required this.orientation,
    this.isEnabled = true,
  });

  @override
  _OptionButtonState createState() => _OptionButtonState();
}

class _OptionButtonState extends State<OptionButton>
    with SingleTickerProviderStateMixin {
  double _angle = 0.0;
  CameraOrientations _oldOrientation = CameraOrientations.portrait_up;

  @override
  void initState() {
    super.initState();

    Tween(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: Curves.ease))
        .animate(widget.rotationController)
        .addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _oldOrientation = OrientationUtils.convertRadianToOrientation(_angle);
      }
    });

    widget.orientation.addListener(() {
      _angle =
          OrientationUtils.convertOrientationToRadian(widget.orientation.value);

      if (widget.orientation.value == CameraOrientations.portrait_up) {
        widget.rotationController.reverse();
      } else if (_oldOrientation == CameraOrientations.landscape_left ||
          _oldOrientation == CameraOrientations.landscape_right) {
        widget.rotationController.reset();

        if ((widget.orientation.value == CameraOrientations.landscape_left ||
            widget.orientation.value == CameraOrientations.landscape_right)) {
          widget.rotationController.forward();
        } else if ((widget.orientation.value ==
            CameraOrientations.portrait_down)) {
          if (_oldOrientation == CameraOrientations.landscape_right) {
            widget.rotationController.forward(from: 0.5);
          } else {
            widget.rotationController.reverse(from: 0.5);
          }
        }
      } else if (widget.orientation.value == CameraOrientations.portrait_down) {
        widget.rotationController.reverse(from: 0.5);
      } else {
        widget.rotationController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.rotationController,
      builder: (context, child) {
        double? newAngle;

        if (_oldOrientation == CameraOrientations.landscape_left) {
          if (widget.orientation.value == CameraOrientations.portrait_up) {
            newAngle = -widget.rotationController.value;
          }
        }

        if (_oldOrientation == CameraOrientations.landscape_right) {
          if (widget.orientation.value == CameraOrientations.portrait_up) {
            newAngle = widget.rotationController.value;
          }
        }

        if (_oldOrientation == CameraOrientations.portrait_down) {
          if (widget.orientation.value == CameraOrientations.portrait_up) {
            newAngle = widget.rotationController.value * -pi;
          }
        }

        return IgnorePointer(
          ignoring: !widget.isEnabled,
          child: Opacity(
            opacity: widget.isEnabled ? 1.0 : 0.3,
            child: Transform.rotate(
              angle: newAngle ?? widget.rotationController.value * _angle,
              child: ClipOval(
                child: Material(
                  color: Colors.white30,
                  child: InkWell(
                    child: SizedBox(
                      width: 48,
                      height: 48,
                      child: Icon(
                        widget.icon,
                        color: Colors.white,
                        size: 24.0,
                      ),
                    ),
                    onTap: () {
                      // Trigger short vibration
                      HapticFeedback.selectionClick();

                      widget.onTapCallback();
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
