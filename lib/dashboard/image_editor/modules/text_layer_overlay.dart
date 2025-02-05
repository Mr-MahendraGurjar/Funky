import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nb_utils/nb_utils.dart';

import '../data/layer.dart';
import '../image_editor_plus.dart';
import 'colors_picker.dart';

class TextLayerOverlay extends StatefulWidget {
  final int index;
  final TextLayerData layer;
  final Function onUpdate;

  const TextLayerOverlay({
    Key? key,
    required this.layer,
    required this.index,
    required this.onUpdate,
  }) : super(key: key);

  @override
  _TextLayerOverlayState createState() => _TextLayerOverlayState();
}

class _TextLayerOverlayState extends State<TextLayerOverlay> {
  double slider = 0.0;

  @override
  void initState() {
    //  slider = widget.sizevalue;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        // color: Colors.black.withOpacity(0.65),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          // stops: [0.1, 0.5, 0.7, 0.9],
          colors: [
            HexColor("#C12265"),
            HexColor("#000000"),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: HexColor('#04060F'),
            offset: Offset(10, 10),
            blurRadius: 20,
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Center(
              child: Text(
                i18n('Size Adjust').toUpperCase(),
                style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'PR'),
              ),
            ),
            const Divider(),
            Slider(
                activeColor: Colors.white,
                inactiveColor: Colors.grey,
                value: widget.layer.size,
                min: 0.0,
                max: 100.0,
                onChangeEnd: (v) {
                  setState(() {
                    widget.layer.size = v.toDouble();
                    widget.onUpdate();
                  });
                },
                onChanged: (v) {
                  setState(() {
                    slider = v;
                    // print(v.toDouble());
                    widget.layer.size = v.toDouble();
                    widget.onUpdate();
                  });
                }),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                // const SizedBox(height: 20),
                Text(
                  i18n('Color'),
                  style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'PR'),
                ).paddingLeft(16),
                Row(children: [
                  const SizedBox(width: 8),
                  Expanded(
                    child: BarColorPicker(
                      width: 300,
                      thumbColor: Colors.white,
                      initialColor: widget.layer.color,
                      cornerRadius: 10,
                      pickMode: PickMode.color,
                      colorListener: (int value) {
                        setState(() {
                          widget.layer.color = Color(value);
                          widget.onUpdate();
                        });
                      },
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        widget.layer.color = Colors.black;
                        widget.onUpdate();
                      });
                    },
                    child: Text(
                      i18n('Reset'),
                      style: TextStyle(color: Colors.blue, fontSize: 14, fontFamily: 'PR'),
                    ),
                  ),
                  const SizedBox(width: 16),
                ]),
                const SizedBox(height: 20),
                Text(
                  i18n('Background Color'),
                  style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'PR'),
                ).paddingLeft(16),
                Row(children: [
                  const SizedBox(width: 8),
                  Expanded(
                    child: BarColorPicker(
                      width: 300,
                      initialColor: widget.layer.background,
                      thumbColor: Colors.white,
                      cornerRadius: 10,
                      pickMode: PickMode.color,
                      colorListener: (int value) {
                        setState(() {
                          widget.layer.background = Color(value);
                          widget.onUpdate();
                        });
                      },
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        widget.layer.background = Colors.transparent;
                        widget.onUpdate();
                      });
                    },
                    child: Text(
                      i18n('Reset'),
                      style: TextStyle(color: Colors.blue, fontSize: 14, fontFamily: 'PR'),
                    ),
                  ),
                  const SizedBox(width: 16),
                ]),
                const SizedBox(height: 20),
                Text(
                  i18n('Background Opacity'),
                  style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'PR'),
                ).paddingLeft(16),
                Row(children: [
                  const SizedBox(width: 8),
                  Expanded(
                    child: Slider(
                      min: 0,
                      max: 255,
                      divisions: 255,
                      value: widget.layer.backgroundOpacity.toDouble(),
                      thumbColor: Colors.white,
                      onChanged: (double value) {
                        setState(() {
                          widget.layer.backgroundOpacity = value.toInt();
                          widget.onUpdate();
                        });
                      },
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        widget.layer.backgroundOpacity = 0;
                        widget.onUpdate();
                      });
                    },
                    child: Text(
                      i18n('Reset'),
                      style: TextStyle(color: Colors.blue, fontSize: 14, fontFamily: 'PR'),
                    ),
                  ),
                  const SizedBox(width: 16),
                ]),
              ]),
            ),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    removedLayers.add(layers.removeAt(widget.index));

                    Navigator.pop(context);
                    widget.onUpdate();
                    // back(context);
                    // setState(() {});
                  },
                  child: Text(
                    i18n('Remove'),
                    style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'PR'),
                  ),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
