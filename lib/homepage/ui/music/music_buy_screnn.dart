import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:funky_new/Utils/asset_utils.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../../../Utils/App_utils.dart';
import '../../../Utils/colorUtils.dart';
import '../../../Utils/toaster_widget.dart';
import '../../../custom_widget/page_loader.dart';
import '../../../dashboard/dashboard_screen.dart';
import '../../../sharePreference.dart';
import '../../model/musicpurchasePostModel.dart';

class MusicBuyScreen extends StatefulWidget {
  final String song_name;
  final String artist_name;
  final String price;
  final String file_name;
  final String music_id;

  const MusicBuyScreen(
      {Key? key,
      required this.song_name,
      required this.artist_name,
      required this.price,
      required this.file_name,
      required this.music_id})
      : super(key: key);

  @override
  State<MusicBuyScreen> createState() => _MusicBuyScreenState();
}

class _MusicBuyScreenState extends State<MusicBuyScreen> {
  TextEditingController songname_controller = new TextEditingController();
  TextEditingController artistname_controller = new TextEditingController();
  double _value = 1;

  @override
  void initState() {
    setState(() {
      songname_controller.text = widget.song_name;
      artistname_controller.text = widget.artist_name;
      _value = double.parse(widget.price);
    });
    if (mounted) {
      get();
    }
    super.initState();
  }

  Metadata? music_data;
  static var httpClient = new HttpClient();

  get() async {
    var request = await httpClient.getUrl(Uri.parse("http://foxyserver.com/funky/music/${widget.file_name}"));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/xyz.mp3');
    await file.writeAsBytes(bytes);

    print(file.path);
    print(file.path);
    MetadataRetriever.fromFile(
      File(file.path),
    )
      ..then(
        (metadata) {
          setState(() {
            music_data = metadata;
            songname_controller.text = metadata.trackName!;
            artistname_controller.text = metadata.trackArtistNames![0];
          });
          // showData(metadata);
        },
      )
      ..catchError((_) {
        setState(() {
          print('Couldn\'t extract metadata');
        });
      });
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  // stops: [0.1, 0.5, 0.7, 0.9],
                  colors: [
                    HexColor("#000000"),
                    HexColor("#000000"),
                    Color(0xFF941414),
                  ],
                ),
              ),
            ),
            Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.transparent,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  title: const Text(
                    "Funky Music",
                    style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'PB'),
                  ),
                  centerTitle: true,
                  leadingWidth: 100,
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     const Expanded(
                      //       flex: 2,
                      //       child: Text(
                      //         'Price',
                      //         style: TextStyle(
                      //             fontSize: 14,
                      //             color: Colors.white,
                      //             fontFamily: 'PM'),
                      //       ),
                      //     ),
                      //     // Theme(
                      //     //   data: ThemeData(
                      //     //       sliderTheme: SliderThemeData(
                      //     //         showValueIndicator: ShowValueIndicator.always,
                      //     //         thumbShape: RoundSliderThumbShape(
                      //     //             enabledThumbRadius: 5.0),
                      //     //         valueIndicatorShape:
                      //     //         PaddleSliderValueIndicatorShape(),
                      //     //         valueIndicatorColor: Colors.white,
                      //     //         valueIndicatorTextStyle: TextStyle(
                      //     //             color: Colors.white, fontFamily: 'PR'),
                      //     //       )),
                      //     //   child: Slider(
                      //     //     min: 1.0,
                      //     //     max: 100.0,
                      //     //     activeColor: HexColor(CommonColor.pinkFont),
                      //     //     inactiveColor: Colors.white,
                      //     //     thumbColor: Colors.pink,
                      //     //     label: '${_value.round()}',
                      //     //     value: _value,
                      //     //     onChanged: (value) {
                      //     //       setState(() {
                      //     //         _value = value;
                      //     //         // _value1 = _value;
                      //     //         // middle_ammount = _value * multiply!;
                      //     //         // var tax = (middle_ammount! * 18) / 100;
                      //     //         // var tax = (_value * 18) / 100;
                      //     //         // final_ammount = middle_ammount! + tax;
                      //     //       });
                      //     //       print(
                      //     //           "final_ammount ${final_ammount!.toStringAsFixed(2)}");
                      //     //     },
                      //     //   ),
                      //     // )
                      //   ],
                      // ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          const Expanded(
                            flex: 2,
                            child: Text(
                              'Song name',
                              style: TextStyle(fontSize: 14, color: Colors.white, fontFamily: 'PM'),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              // width: 300,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black, width: 1),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 5,
                                    offset: Offset(0, 0),
                                    spreadRadius: -5,
                                  ),
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              child: TextFormField(
                                maxLength: 150,
                                controller: songname_controller,
                                readOnly: true,
                                onChanged: (value) {
                                  // setState(() {
                                  //   var value1 = double.parse(value);
                                  //   // var tax = (_value1 * 18) / 100;
                                  //   _value1 = value1;
                                  //   // middle_ammount = value1 * multiply!;
                                  //   // var tax = (middle_ammount! * 18) / 100;
                                  //   // final_ammount = middle_ammount! + tax;
                                  //
                                  //   // final_ammount = _value1 + tax;
                                  // });
                                  // print(middle_ammount);
                                  // print(final_ammount);
                                },
                                // enabled: enabled,
                                // validator: validator,
                                maxLines: 1,
                                // onTap: tap,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 20, top: 14, bottom: 14, right: 10),
                                  alignLabelWithHint: false,
                                  isDense: true,
                                  hintText: 'Enter Song name',
                                  counterStyle: TextStyle(
                                    height: double.minPositive,
                                  ),
                                  counterText: "",
                                  filled: true,
                                  border: InputBorder.none,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.transparent, width: 1),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                  // focusedBorder: OutlineInputBorder(
                                  //   borderSide:
                                  //   BorderSide(color: ColorUtils.blueColor, width: 1),
                                  //   borderRadius: BorderRadius.all(Radius.circular(10)),
                                  // ),
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'PR',
                                    color: Colors.grey,
                                  ),
                                ),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'PR',
                                  color: Colors.black,
                                ),
                                // controller: controller,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          const Expanded(
                            flex: 2,
                            child: Text(
                              'Artist name',
                              style: TextStyle(fontSize: 14, color: Colors.white, fontFamily: 'PM'),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              // width: 300,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black, width: 1),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 5,
                                    offset: Offset(0, 0),
                                    spreadRadius: -5,
                                  ),
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              child: TextFormField(
                                maxLength: 150,
                                controller: artistname_controller,
                                readOnly: true,
                                onChanged: (value) {
                                  // setState(() {
                                  //   var value1 = double.parse(value);
                                  // var tax = (_value1 * 18) / 100;
                                  // _value1 = value1;
                                  // middle_ammount = value1 * multiply!;
                                  // var tax = (middle_ammount! * 18) / 100;
                                  // final_ammount = middle_ammount! + tax;

                                  // final_ammount = _value1 + tax;
                                  // });
                                  // print(middle_ammount);
                                  // print(final_ammount);
                                },
                                // enabled: enabled,
                                // validator: validator,
                                maxLines: 1,
                                // onTap: tap,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 20, top: 14, bottom: 14),
                                  alignLabelWithHint: false,
                                  isDense: true,
                                  hintText: "Enter artist's name",
                                  counterStyle: TextStyle(
                                    height: double.minPositive,
                                  ),
                                  counterText: "",
                                  filled: true,
                                  border: InputBorder.none,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.transparent, width: 1),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                  // focusedBorder: OutlineInputBorder(
                                  //   borderSide:
                                  //   BorderSide(color: ColorUtils.blueColor, width: 1),
                                  //   borderRadius: BorderRadius.all(Radius.circular(10)),
                                  // ),
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'PR',
                                    color: Colors.grey,
                                  ),
                                ),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'PR',
                                  color: Colors.black,
                                ),
                                // controller: controller,
                                // keyboardType: TextInputType.number,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Row(
                      //   children: [
                      //     Expanded(
                      //       flex: 2,
                      //       child: Text(
                      //         '${_value1.toStringAsFixed(2)} Head counts',
                      //         style: TextStyle(
                      //             fontSize: 14,
                      //             color: Colors.pink,
                      //             fontFamily: 'PB'),
                      //       ),
                      //     ),
                      //     Expanded(
                      //       flex: 3,
                      //       child: Row(
                      //         children: [
                      //           Text(
                      //             '${middle_ammount!.toStringAsFixed(2)} USD+',
                      //             style: TextStyle(
                      //                 fontSize: 14,
                      //                 color: Colors.white,
                      //                 fontFamily: 'PB'),
                      //           ),
                      //           const SizedBox(
                      //             width: 5,
                      //           ),
                      //           Expanded(
                      //             flex: 3,
                      //             child: Text(
                      //               '18% tax and service charges',
                      //               maxLines: 2,
                      //               textAlign: TextAlign.center,
                      //               style: TextStyle(
                      //                   fontSize: 14,
                      //                   color: HexColor(
                      //                       CommonColor.subHeaderColor),
                      //                   fontFamily: 'PB'),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Total price to pay',
                        style: TextStyle(fontSize: 16, color: HexColor(CommonColor.orange), fontFamily: 'PB'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 1.5),
                            borderRadius: BorderRadius.circular(30)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          child: Text(
                            '${_value.ceil()} USD',
                            style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'PB'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          PurchaseMusic(music_id: widget.music_id);
                          // uploadMusic();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: HexColor(CommonColor.pinkFont),
                              border: Border.all(color: HexColor(CommonColor.pinkFont), width: 1.5),
                              borderRadius: BorderRadius.circular(30)),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                            child: Text(
                              'Buy',
                              style: TextStyle(fontSize: 15, color: Colors.white, fontFamily: 'PR'),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      // ClipRRect(
                      //     borderRadius: BorderRadius.circular(20),
                      //     child: Image.file(widget.imageFile)),
                      // Container(
                      //   color: Colors.white,
                      //   margin: EdgeInsets.symmetric(
                      //       horizontal: 20, vertical: 0),
                      //   width: MediaQuery.of(context).size.width,
                      //   // height: MediaQuery.of(context).size.height / 1.2,
                      //   child: Stack(
                      //     alignment: Alignment.center,
                      //     children: [
                      //       Center(
                      //         child: AspectRatio(
                      //             aspectRatio:
                      //             video_controller!.value.aspectRatio,
                      //             child: VideoPlayer(video_controller!)),
                      //       ),
                      //       Center(
                      //         child: GestureDetector(
                      //           onTap: () {
                      //             print('hello');
                      //             isClicked = isClicked ? false : true;
                      //             print(isClicked);
                      //             if (video_controller!.value.isPlaying) {
                      //               setState(() {
                      //                 video_controller!.pause();
                      //               });
                      //             } else {
                      //               setState(() {
                      //                 video_controller!.play();
                      //               });
                      //             }
                      //           },
                      //           child: Container(
                      //             decoration: BoxDecoration(
                      //                 color: Colors.black54,
                      //                 borderRadius:
                      //                 BorderRadius.circular(100)),
                      //             child: Padding(
                      //               padding: const EdgeInsets.all(10.0),
                      //               child: Icon(
                      //                 (video_controller!.value.isPlaying
                      //                     ? Icons.pause
                      //                     : Icons.play_arrow),
                      //                 color: Colors.pink,
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      Container(
                        // height: 100,
                        width: 200,

                        child: Column(
                          children: [
                            (music_data == null
                                ? Text(
                                    "No data Found",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 15, color: Colors.white, fontFamily: 'PB'),
                                  )
                                : showData(music_data!)),
                            // Container(
                            //   child: Text(
                            //     widget.musicFile.name,
                            //     textAlign: TextAlign.center,
                            //     style: const TextStyle(
                            //         fontSize: 15,
                            //         color: Colors.white,
                            //         fontFamily: 'PB'),
                            //   ),
                            // ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Widget showData(Metadata metadata) {
    return Column(
      children: [
        metadata.albumArt == null
            ? Image.asset(
                AssetUtils.music_file_icon,
                color: Colors.white,
                height: 80,
              )
            : Image.memory(
                metadata.albumArt!,
                height: 80,
                width: 80,
              ),
        SizedBox(
          height: 15,
        ),
        Container(
          child: Text(
            metadata.trackName!,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, color: Colors.white, fontFamily: 'PB'),
          ),
        )
      ],
    );
  }

  MusicPurchasePostModel? _musicPurchasePostModel;

  Future<dynamic> PurchaseMusic({required String music_id}) async {
    showLoader(context);

    String idUser = await PreferenceManager().getPref(URLConstants.id);

    debugPrint('0-0-0-0-0-0-0 username');
    Map data = {
      'login_user_id': idUser,
      'music_id': music_id,
    };
    print(data);
    // String body = json.encode(data);

    var url = (URLConstants.base_url + URLConstants.MusicPurchaseApi);
    print("url : $url");
    print("body : $data");
    var response = await http.post(
      Uri.parse(url),
      body: data,
    );
    print(response.body);
    print(response.request);
    print(response.statusCode);
    // var final_data = jsonDecode(response.body);
    // print('final data $final_data');
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      _musicPurchasePostModel = MusicPurchasePostModel.fromJson(data);

      if (_musicPurchasePostModel!.error == false) {
        CommonWidget().showToaster(msg: 'Succesful');
        // print(_galleryModelList);
        // print(_galleryModelList!.data![0].postImage);
        // print(_galleryModelList!.data![1].postImage);
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Dashboard(
                      page: 3,
                    )));
        hideLoader(context);
        // Get.to(Dashboard());
      } else {
        hideLoader(context);

        print('Please try again');
      }
    } else {
      hideLoader(context);

      print('Please try again');
    }
  }
}
