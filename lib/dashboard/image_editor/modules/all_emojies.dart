import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../data/data.dart';
import '../data/layer.dart';
import '../image_editor_plus.dart';

class Emojies extends StatefulWidget {
  const Emojies({Key? key}) : super(key: key);

  @override
  _EmojiesState createState() => _EmojiesState();
}

class _EmojiesState extends State<Emojies> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(0.0),
        height: 400,
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
        child: Column(
          children: [
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                i18n('Select Emoji'),
                style: const TextStyle(color: Colors.white, fontFamily: 'PB', fontSize: 16),
              ),
            ]),
            const Divider(height: 1),
            const SizedBox(height: 16),
            Container(
              height: 315,
              // width: 100,
              padding: const EdgeInsets.only(left: 10.0),
              child: GridView(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  mainAxisSpacing: 0.0,
                  maxCrossAxisExtent: 60.0,
                ),
                children: emojis.map((String emoji) {
                  return GridTile(
                      child: GestureDetector(
                    onTap: () {
                      Navigator.pop(
                        context,
                        EmojiLayerData(
                          text: emoji,
                          size: 32.0,
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.zero,
                      child: Text(
                        emoji,
                        style: const TextStyle(fontSize: 35),
                      ),
                    ),
                  ));
                }).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
