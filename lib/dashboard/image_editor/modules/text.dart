import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';

import '../data/layer.dart';
import '../image_editor_plus.dart';
import 'colors_picker.dart';

class TextEditorImage extends StatefulWidget {
  const TextEditorImage({Key? key}) : super(key: key);

  @override
  _TextEditorImageState createState() => _TextEditorImageState();
}

class _TextEditorImageState extends State<TextEditorImage> {
  TextEditingController name = TextEditingController();
  Color currentColor = Colors.white;
  double slider = 32.0;
  TextAlign align = TextAlign.left;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Theme(
      data: ThemeData.dark(),
      child: Stack(
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
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              actions: <Widget>[
                IconButton(
                  icon: Icon(FontAwesomeIcons.alignLeft,
                      color: align == TextAlign.left ? Colors.white : Colors.white.withAlpha(80)),
                  onPressed: () {
                    setState(() {
                      align = TextAlign.left;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(FontAwesomeIcons.alignCenter,
                      color: align == TextAlign.center ? Colors.white : Colors.white.withAlpha(80)),
                  onPressed: () {
                    setState(() {
                      align = TextAlign.center;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(FontAwesomeIcons.alignRight,
                      color: align == TextAlign.right ? Colors.white : Colors.white.withAlpha(80)),
                  onPressed: () {
                    setState(() {
                      align = TextAlign.right;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () {
                    Navigator.pop(
                      context,
                      TextLayerData(
                        background: Colors.transparent,
                        text: name.text,
                        color: currentColor,
                        size: slider.toDouble(),
                        align: align,
                      ),
                    );
                  },
                  color: Colors.white,
                  padding: const EdgeInsets.all(15),
                )
              ],
            ),
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(children: [
                    SizedBox(
                      height: size.height / 2.2,
                      child: TextField(
                        controller: name,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(10),
                          hintText: 'Insert Your Message',
                          hintStyle: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'PR'),
                          alignLabelWithHint: true,
                        ),
                        scrollPadding: const EdgeInsets.all(20.0),
                        keyboardType: TextInputType.multiline,
                        minLines: 5,
                        maxLines: 99999,
                        style: TextStyle(
                          color: currentColor,
                        ),
                        autofocus: false,
                      ),
                    ),
                    Container(
                      color: Colors.transparent,
                      child: Column(
                        children: [
                          //   SizedBox(height: 20.0),
                          Text(
                            i18n('Slider Color'),
                            style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'PR'),
                          ),
                          //   SizedBox(height: 10.0),
                          Row(children: [
                            Expanded(
                              child: BarColorPicker(
                                width: 300,
                                thumbColor: Colors.white,
                                cornerRadius: 10,
                                // thumbRadius: 10,
                                pickMode: PickMode.color,
                                colorListener: (int value) {
                                  setState(() {
                                    currentColor = Color(value);
                                  });
                                },
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                i18n('Reset'),
                                style: TextStyle(color: Colors.blue, fontSize: 14, fontFamily: 'PM'),
                              ),
                            ),
                          ]),
                          //   SizedBox(height: 20.0),
                          Text(
                            i18n('Slider White Black Color'),
                            style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'PR'),
                          ),
                          //   SizedBox(height: 10.0),
                          Row(children: [
                            Expanded(
                              child: BarColorPicker(
                                width: 300,
                                thumbColor: Colors.white,
                                cornerRadius: 10,
                                pickMode: PickMode.grey,
                                colorListener: (int value) {
                                  setState(() {
                                    currentColor = Color(value);
                                  });
                                },
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                i18n('Reset'),
                                style: TextStyle(color: Colors.blue, fontSize: 14, fontFamily: 'PM'),
                              ),
                            )
                          ]),
                          Container(
                            // color: Colors.black,
                            child: Column(
                              children: [
                                const SizedBox(height: 10.0),
                                Center(
                                  child: Text(
                                    i18n('Size Adjust'),
                                    style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'PR'),
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                Slider(
                                    activeColor: Colors.white,
                                    inactiveColor: Colors.grey,
                                    value: slider,
                                    min: 0.0,
                                    max: 100.0,
                                    onChangeEnd: (v) {
                                      setState(() {
                                        slider = v;
                                      });
                                    },
                                    onChanged: (v) {
                                      setState(() {
                                        slider = v;
                                      });
                                    }),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
