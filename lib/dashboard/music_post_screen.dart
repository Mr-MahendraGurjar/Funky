import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:ffmpeg_kit_flutter_min_gpl/ffmpeg_kit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

import '../Utils/App_utils.dart';
import '../Utils/asset_utils.dart';
import '../Utils/colorUtils.dart';
import '../Utils/toaster_widget.dart';
import '../custom_widget/page_loader.dart';
import '../sharePreference.dart';
import 'dashboard_screen.dart';

class MusicPostScreen extends StatefulWidget {
  final PlatformFile musicFile;

  const MusicPostScreen({
    Key? key,
    required this.musicFile,
  }) : super(key: key);

  @override
  State<MusicPostScreen> createState() => _MusicPostScreenState();
}

class _MusicPostScreenState extends State<MusicPostScreen> {
  double _value = 1;
  double _value1 = 0;
  double? multiply;
  double? middle_ammount;
  double? final_ammount;
  TextEditingController songname_controller = new TextEditingController();
  TextEditingController artistname_controller = new TextEditingController();

  // VideoPlayerController? video_controller;

  bool _onTouch = false;

  // Timer? _timer;
  bool isClicked = false; // boolean that states if the button is pressed or not

  bool valueown = false;
  bool valueterms = false;

  @override
  void initState() {
    multiply = 2;
    middle_ammount = _value * multiply!;
    var tax = (middle_ammount! * 18) / 100;
    final_ammount = middle_ammount! + tax;

    // pick_music();
    cutAudio(widget.musicFile.path!);
    get();

    super.initState();
  }

  File inputFile = File('');
  File outputFile = File('');
  RangeValues cutValues = const RangeValues(0, 5);
  int timeFile = 10;
  final player = AudioPlayer();
  final outputPlayer = AudioPlayer();
  bool previewPlay = false;
  bool outputPlay = false;
  bool isCutting = false;
  bool isCut = false;

  // Future<void> pick_music() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: ['mp3'],
  //   );
  //   if (result != null) {
  //     PlatformFile file = result.files.first;
  //
  //     print(file.name);
  //     print(file.bytes);
  //     print(file.size);
  //     print(file.extension);
  //     print(file.path);
  //     await get(file_: File(file.path!));
  //
  //     await player.setFilePath(inputFile.path);
  //
  //     setState(() {
  //       inputFile = File(file.path!);
  //       songname_controller.text = file.name;
  //
  //       timeFile = player.duration!.inSeconds;
  //       cutValues = RangeValues(0, timeFile.toDouble());
  //       // inputFileView = inputFile.path;
  //     });
  //   } else {
  //     // User cancelled the picker
  //   }
  // }

  Metadata? music_data;

  get() async {
    MetadataRetriever.fromFile(
      File(widget.musicFile.path!),
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
  }

  // final Trimmer _trimmer = Trimmer();

  double _startValue = 0.0;
  double _endValue = 0.0;

  bool _isPlaying = false;
  bool _progressVisibility = false;
  bool isLoading = false;

  // void _loadAudio() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   await _trimmer.loadAudio(audioFile: File(widget.musicFile.path!));
  //   setState(() {
  //     isLoading = false;
  //   });
  // }
  //
  // _saveAudio() {
  //   setState(() {
  //     _progressVisibility = true;
  //   });
  //
  //   _trimmer.saveTrimmedAudio(
  //     startValue: _startValue,
  //     endValue: _endValue,
  //     audioFileName: DateTime.now().millisecondsSinceEpoch.toString(),
  //     onSave: (outputPath) {
  //       setState(() {
  //         _progressVisibility = false;
  //       });
  //       debugPrint('OUTPUT PATH: $outputPath');
  //     },
  //   );
  // }

  @override
  void dispose() {
    // _timer?.cancel();
    super.dispose();
  }

  String? outPath;

  Future<String> cutAudio(String path) async {
    final Directory dir = await getTemporaryDirectory();
    setState(() {
      outPath = "${dir.path}/output.mp3";
    });

    try {
      await File(outPath!).delete();
    } catch (e) {
      print("Delete Error");
    }

    var cmd = "-y -i \"$path\" -vn -ss 0 -to 30 -ar 16k -ac 2 -b:a 96k -acodec copy $outPath";
    log(cmd);

    FFmpegKit.executeAsync(cmd, (session) async {
      final returnCode = await session.getReturnCode();

      print("returnCode $returnCode");
    });

    return outPath!;
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
                  leading: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        print('oject');
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => Dashboard(
                        //               page: 0,
                        //             )));
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => Dashboard(
                                      page: 0,
                                    )),
                            (route) => false);
                      },
                      icon: Icon(
                        Icons.arrow_back_outlined,
                        color: Colors.white,
                      )),
                  centerTitle: true,
                  leadingWidth: 100,
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            flex: 2,
                            child: Text(
                              'Price',
                              style: TextStyle(fontSize: 14, color: Colors.white, fontFamily: 'PM'),
                            ),
                          ),
                          Theme(
                            data: ThemeData(
                                sliderTheme: SliderThemeData(
                              showValueIndicator: ShowValueIndicator.always,
                              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5.0),
                              valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                              valueIndicatorColor: Colors.white,
                              valueIndicatorTextStyle: TextStyle(color: Colors.white, fontFamily: 'PR'),
                            )),
                            child: Slider(
                              min: 1.0,
                              max: 100.0,
                              activeColor: HexColor(CommonColor.pinkFont),
                              inactiveColor: Colors.white,
                              thumbColor: Colors.pink,
                              label: '${_value.round()}',
                              value: _value,
                              onChanged: (value) {
                                setState(() {
                                  _value = value;
                                  // _value1 = _value;
                                  // middle_ammount = _value * multiply!;
                                  // var tax = (middle_ammount! * 18) / 100;
                                  // var tax = (_value * 18) / 100;
                                  // final_ammount = middle_ammount! + tax;
                                });
                                print("final_ammount ${final_ammount!.toStringAsFixed(2)}");
                              },
                            ),
                          )
                        ],
                      ),
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
                                // readOnly: true,
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
                                // keyboardType: TextInputType.number,
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
                                // readOnly: true,

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
                                  contentPadding: EdgeInsets.only(left: 20, top: 14, bottom: 14, right: 10),
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
                      GestureDetector(
                        onTap: () {
                          // cutAudio(widget.musicFile.path!);
                        },
                        child: Container(
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
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.centerRight,
                              child: Theme(
                                data: ThemeData(unselectedWidgetColor: Colors.white),
                                child: Checkbox(
                                  visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                                  checkColor: Colors.black,
                                  activeColor: Colors.white,
                                  value: valueown,
                                  onChanged: (value) {
                                    setState(() {
                                      valueown = value!;
                                    });
                                    if (valueown) {
                                      CommonWidget().showToaster(msg: 'Only 30 second audio will be posted');
                                    }
                                    print(valueown);
                                  },
                                ),
                              ),
                            ),
                            Text(
                              "I don't own this video",
                              style: TextStyle(fontSize: 14, color: Colors.white, fontFamily: 'PM'),
                            ),
                          ],
                        ),
                      ),

                      // isCutting
                      //     ? Column(
                      //         children: const [
                      //           CircularProgressIndicator(),
                      //           Text('Waitting...')
                      //         ],
                      //       )
                      //     : Column(
                      //         children: [
                      //           // Text(isCut ? 'Done!' : ''),
                      //           // Text(isCut ? outputFile.path : 'output file path'),
                      //           // Text(
                      //           //     'Time: ${outputPlayer.getDuration().inMinutes ?? 0}:${outputPlayer.duration?.inSeconds ?? 0}'),
                      //           Container(
                      //             decoration: BoxDecoration(
                      //                 borderRadius: BorderRadius.circular(100),
                      //                 border: Border.all(
                      //                     color: Colors.white, width: 1)),
                      //             child: IconButton(
                      //                 onPressed: _onOutputPlayPreview,
                      //                 icon: Icon(outputPlay
                      //                     ? Icons.stop_circle
                      //                     : Icons.play_arrow,color: Colors.white,)),
                      //           ),
                      //         ],
                      //       ),

                      // ElevatedButton(
                      //   onPressed:
                      //   _progressVisibility ? null : () => _saveAudio(),
                      //   child: const Text("SAVE"),
                      // ),

                      // AudioViewer(trimmer: _trimmer),
                      // Center(
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(8.0),
                      //     child: TrimViewer(
                      //       trimmer: _trimmer,
                      //       viewerHeight: 100,
                      //       viewerWidth: MediaQuery.of(context).size.width,
                      //       durationStyle: DurationStyle.FORMAT_MM_SS,
                      //       backgroundColor: Theme.of(context).primaryColor,
                      //       barColor: Colors.white,
                      //       durationTextStyle: TextStyle(
                      //           color: Theme.of(context).primaryColor),
                      //       allowAudioSelection: true,
                      //       editorProperties: TrimEditorProperties(
                      //         circleSize: 10,
                      //         borderPaintColor: Colors.pink,
                      //         borderWidth: 4,
                      //         borderRadius: 5,
                      //         circlePaintColor: Colors.pink.shade800,
                      //       ),
                      //       areaProperties:
                      //       TrimAreaProperties.edgeBlur(blurEdges: true),
                      //       onChangeStart: (value) => _startValue = value,
                      //       onChangeEnd: (value) => _endValue = value,
                      //       onChangePlaybackState: (value) {
                      //         if (mounted) {
                      //           setState(() => _isPlaying = value);
                      //         }
                      //       },
                      //     ),
                      //   ),
                      // ),
                      ///
                      // TextButton(
                      //   child: _isPlaying
                      //       ? Icon(
                      //     Icons.pause,
                      //     size: 80.0,
                      //     color: Theme.of(context).primaryColor,
                      //   )
                      //       : Icon(
                      //     Icons.play_arrow,
                      //     size: 80.0,
                      //     color: Theme.of(context).primaryColor,
                      //   ),
                      //   onPressed: () async {
                      //     bool playbackState =
                      //     await _trimmer.audioPlaybackControl(
                      //       startValue: _startValue,
                      //       endValue: _endValue,
                      //     );
                      //     setState(() => _isPlaying = playbackState);
                      //   },
                      // ),

                      Container(
                        margin: EdgeInsets.symmetric(vertical: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.centerRight,
                              child: Theme(
                                data: ThemeData(unselectedWidgetColor: Colors.white),
                                child: Checkbox(
                                  visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                                  checkColor: Colors.black,
                                  activeColor: Colors.white,
                                  value: valueterms,
                                  onChanged: (value) {
                                    setState(() {
                                      valueterms = value!;
                                    });
                                    print(valueterms);
                                  },
                                ),
                              ),
                            ),
                            Text(
                              'I agree to the terms and conditions',
                              style: TextStyle(fontSize: 14, color: Colors.white, fontFamily: 'PM'),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          uploadMusic();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: HexColor(CommonColor.pinkFont),
                              border: Border.all(color: HexColor(CommonColor.pinkFont), width: 1.5),
                              borderRadius: BorderRadius.circular(30)),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            child: Text(
                              'Post',
                              style: TextStyle(fontSize: 15, color: Colors.white, fontFamily: 'PM'),
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

  Future<dynamic> uploadMusic() async {
    showLoader(context);
    String id_user = await PreferenceManager().getPref(URLConstants.id);
    var url = (URLConstants.base_url + URLConstants.music_post);
    var request = http.MultipartRequest('POST', Uri.parse(url));

    print(widget.musicFile.path);
    print(id_user);
    print(songname_controller.text);
    print(artistname_controller.text);
    print(_value.ceil().toString());
    var files = valueown
        ? http.MultipartFile('music_file', File(outPath!).readAsBytes().asStream(), File(outPath!).lengthSync(),
            filename: outPath!.split("/").last)
        : http.MultipartFile('music_file', File(widget.musicFile.path!).readAsBytes().asStream(),
            File(widget.musicFile.path!).lengthSync(),
            filename: widget.musicFile.path!.split("/").last);

    request.files.add(files);
    request.fields['user_id'] = id_user;
    request.fields['song_name'] = songname_controller.text;
    request.fields['artist_name'] = artistname_controller.text;
    request.fields['price'] = _value.ceil().toString();

    //userId,tagLine,description,address,postImage,uploadVideo,isVideo
    // request.files.add(await http.MultipartFile.fromPath(
    //     "image", widget.ImageFile.path));

    var response = await request.send();
    var responsed = await http.Response.fromStream(response);
    final responseData = json.decode(responsed.body);
    print(responsed.statusCode);

    if (responsed.statusCode == 200) {
      print("SUCCESS");
      print(responseData);
      hideLoader(context);
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Dashboard(
                    page: 3,
                  )));
      // await Get.to(Profile_Screen());
    } else {
      print("ERROR");
    }
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
                height: 100,
                width: 100,
              ),
        SizedBox(
          height: 15,
        ),
        Container(
          child: Text(
            "metadata.trackName"!,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, color: Colors.white, fontFamily: 'PB'),
          ),
        )
      ],
    );
  }
}
