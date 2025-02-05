import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class SeekBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final Duration bufferedPosition;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;

  const SeekBar({
    Key? key,
    required this.duration,
    required this.position,
    required this.bufferedPosition,
    this.onChanged,
    this.onChangeEnd,
  }) : super(key: key);

  @override
  SeekBarState createState() => SeekBarState();
}

class SeekBarState extends State<SeekBar> {
  double? _dragValue;
  late SliderThemeData _sliderThemeData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _sliderThemeData = SliderTheme.of(context).copyWith(
      trackHeight: 2.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // SliderTheme(
      //   data: _sliderThemeData.copyWith(
      //     thumbShape: RoundSliderOverlayShape(),
      //     activeTrackColor: Colors.blue.shade100,
      //     inactiveTrackColor: Colors.grey.shade300,
      //   ),
      //   child: ExcludeSemantics(
      //     child: Slider(
      //       min: 0.0,
      //       max: widget.duration.inMilliseconds.toDouble(),
      //       value: min(widget.bufferedPosition.inMilliseconds.toDouble(),
      //           widget.duration.inMilliseconds.toDouble()),
      //       onChanged: (value) {
      //         setState(() {
      //           _dragValue = value;
      //         });
      //         if (widget.onChanged != null) {
      //           widget.onChanged!(Duration(milliseconds: value.round()));
      //         }
      //       },
      //       onChangeEnd: (value) {
      //         if (widget.onChangeEnd != null) {
      //           widget.onChangeEnd!(Duration(milliseconds: value.round()));
      //         }
      //         _dragValue = null;
      //       },
      //     ),
      //   ),
      // ),
      // SliderTheme(
      //   data: _sliderThemeData.copyWith(
      //     inactiveTrackColor: Colors.transparent,
      //   ),
      //   child: Slider(
      //     min: 0.0,
      //     max: widget.duration.inMilliseconds.toDouble(),
      //     value: min(_dragValue ?? widget.position.inMilliseconds.toDouble(),
      //         widget.duration.inMilliseconds.toDouble()),
      //     onChanged: (value) {
      //       setState(() {
      //         _dragValue = value;
      //       });
      //       if (widget.onChanged != null) {
      //         widget.onChanged!(Duration(milliseconds: value.round()));
      //       }
      //     },
      //     onChangeEnd: (value) {
      //       if (widget.onChangeEnd != null) {
      //         widget.onChangeEnd!(Duration(milliseconds: value.round()));
      //       }
      //       _dragValue = null;
      //     },
      //   ),
      // ),
      // right: 16.0,
      //   bottom: 0.0,
      child: Text(RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$').firstMatch("$_remaining")?.group(1) ?? '$_remaining',
          style: TextStyle(fontSize: 14, color: HexColor('#A7A7A7'))),
    );
  }

  Duration get _remaining => widget.duration - widget.position;
}
