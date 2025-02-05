import 'package:flutter/material.dart';
import 'package:funky_new/Utils/colorUtils.dart';
import 'package:hexcolor/hexcolor.dart';

class LoaderPage extends StatefulWidget {
  const LoaderPage({super.key});

  @override
  AddPromptPageState createState() => AddPromptPageState();
}

class AddPromptPageState extends State<LoaderPage> {
  TextEditingController nameAlbumController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  final List<Color> _kDefaultRainbowColors = [HexColor(CommonColor.pinkFont)];

  @override
  Widget build(BuildContext context) {
    return animatedDialogueWithTextFieldAndButton(context);
  }

  animatedDialogueWithTextFieldAndButton(context) {
    var mediaQuery = MediaQuery.of(context);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              color: Colors.transparent,
              height: 80,
              width: 200,
              child: Container(
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      // color: Colors.pink,
                      backgroundColor: HexColor(CommonColor.pinkFont),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.white70, //<-- SEE HERE
                      ),
                    ),
                    // Text('Loading...',style: TextStyle(color: Colors.white,fontSize: 18,fontFamily: 'PR'),)
                  ],
                ),
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
        ],
      ),
    );
  }
}
