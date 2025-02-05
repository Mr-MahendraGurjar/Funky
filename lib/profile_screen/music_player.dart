import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:funky_new/homepage/ui/music/music_buy_screnn.dart';
import 'package:funky_new/profile_screen/seek_bar.dart';
// import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

import '../Utils/App_utils.dart';
import '../Utils/colorUtils.dart';
import '../homepage/model/getAllMusicModel.dart';

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}

class Music_player extends StatefulWidget {
  final String music_url;
  final String title;
  final String artist_name;
  final Data_music music;

  const Music_player(
      {super.key,
      required this.music_url,
      required this.title,
      required this.artist_name,
      required this.music});

  @override
  State<Music_player> createState() => _Music_playerState();
}

class _Music_playerState extends State<Music_player>
    with WidgetsBindingObserver {
  int? maxduration;
  int currentpos = 0;
  String currentpostlabel = "00:00";
  String audioasset = "assets/audio/red-indian-music.mp3";
  bool isplaying = false;
  bool audioplayed = false;
  String? duration;

  AudioPlayer player = AudioPlayer();

  Animation<double>? animation;
  AnimationController? animController;

  music_set() async {
    //convert ByteData to Uint8List
    // duration = await player.setUrl(widget.music_url).toString();
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    // Try to load audio from a source and catch any errors.
    try {
      // AAC example: https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.aac
      await player.setAudioSource(AudioSource.uri(
          Uri.parse("${URLConstants.base_data_url}music/${widget.music_url}")));
    } catch (e) {
      print("Error loading audio source: $e");
    }
    // setState(() {
    //   player.onDurationChanged.listen((Duration d) {
    //     //get the duration of audio
    //     maxduration = d.inMilliseconds;
    //   });
    // });
    // setState(() {
    //   player.onAudioPositionChanged.listen((Duration p) {
    //     currentpos =
    //         p.inMilliseconds; //get the current position of playing audio
    //
    //     //generating the duration label
    //     int shours = Duration(milliseconds: currentpos).inHours;
    //     int sminutes = Duration(milliseconds: currentpos).inMinutes;
    //     int sseconds = Duration(milliseconds: currentpos).inSeconds;
    //
    //     int rhours = shours;
    //     int rminutes = sminutes - (shours * 60);
    //     int rseconds = sseconds - (sminutes * 60 + shours * 60 * 60);
    //
    //     currentpostlabel = "$rhours:$rminutes:$rseconds";
    //   });
    // });
    //
    // animController = AnimationController(
    //     duration: Duration(milliseconds: 1000), vsync: this);
    // final curvedAnimation =
    //     CurvedAnimation(parent: animController!, curve: Curves.easeInOutSine);
    //
    // animation = Tween<double>(begin: 0, end: 100).animate(curvedAnimation)
    //   ..addListener(() {
    //     setState(() {});
    //   });
  }

  @override
  void initState() {
    music_set();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Release decoders and buffers back to the operating system making them
    // available for other apps to use.
    player.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      player.stop();
    }
  }

  int? current;

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          player.positionStream,
          player.bufferedPositionStream,
          player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    // player.onAudioPositionChanged.listen((Duration p) {
    //   currentpos = p.inMilliseconds; //get the current position of playing audio
    //
    //   //generating the duration label
    //   int shours = Duration(milliseconds: currentpos).inHours;
    //   int sminutes = Duration(milliseconds: currentpos).inMinutes;
    //   int sseconds = Duration(milliseconds: currentpos).inSeconds;
    //
    //   int rhours = shours;
    //   int rminutes = sminutes - (shours * 60);
    //   int rseconds = sseconds - (sminutes * 60 + shours * 60 * 60);
    //
    //   setState(() {
    //     current = Duration(milliseconds: currentpos).inSeconds;
    //     currentpostlabel = "0$rminutes:0$rseconds";
    //   });
    //   print(currentpostlabel);
    // });
    return Container(
      // height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  // color: Colors.white,
                  child: Text(
                    widget.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ),
              // Expanded(
              //   flex: 2,
              //   child: Container(
              //       child: Slider(
              //     value: double.parse(currentpos.toString()),
              //     min: 0,
              //     max: double.parse(maxduration.toString()),
              //     divisions: maxduration,
              //     label: currentpostlabel,
              //     onChanged: (double value) async {
              //       int seekval = value.round();
              //       int result = await player.seek(Duration(milliseconds: seekval));
              //       if (result == 1) {
              //         //seek successful
              //         currentpos = seekval;
              //       } else {
              //         print("Seek unsuccessful.");
              //       }
              //     },
              //   )),
              // ),
              // Container(
              //   width: 100,
              //   decoration: BoxDecoration(
              //       color: Colors.white, borderRadius: BorderRadius.circular(3)),
              //   height: animation!.value,
              // ),

              Expanded(
                flex: 2,
                child: Text(
                  widget.artist_name,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(fontSize: 14, color: HexColor('#A7A7A7')),
                ),
              ),
              // PolygonWaveform(
              //   samples: [],
              //   height: 50,
              //   width: 50,
              //   maxDuration: Duration(seconds: 100),
              //   elapsedDuration: Duration(milliseconds: currentpos),
              // ),
              StreamBuilder<PlayerState>(
                stream: player.playerStateStream,
                builder: (context, snapshot) {
                  final playerState = snapshot.data;
                  final processingState = playerState?.processingState;
                  final playing = playerState?.playing;
                  if (processingState == ProcessingState.loading ||
                      processingState == ProcessingState.buffering) {
                    return Container(
                      margin: const EdgeInsets.all(8.0),
                      width: 24.0,
                      height: 24.0,
                      child: CircularProgressIndicator(
                        color: HexColor(
                          CommonColor.pinkFont,
                        ),
                        strokeWidth: 2,
                      ),
                    );
                  } else if (playing != true) {
                    return IconButton(
                      icon: Icon(Icons.play_arrow,
                          color: HexColor(CommonColor.pinkFont)),
                      iconSize: 24.0,
                      onPressed: player.play,
                    );
                  } else if (processingState != ProcessingState.completed) {
                    return IconButton(
                      icon: Icon(Icons.pause,
                          color: HexColor(CommonColor.pinkFont)),
                      iconSize: 24.0,
                      onPressed: player.pause,
                    );
                  } else {
                    return IconButton(
                      icon: const Icon(Icons.replay),
                      iconSize: 24.0,
                      onPressed: () => player.seek(Duration.zero),
                    );
                  }
                },
              ),

              // Expanded(
              //   flex: 2,
              //   child: Container(
              //     color: Colors.red,
              //     height: 50,
              //     child: Wrap(
              //       spacing: 10,
              //       children: [
              //         // ElevatedButton.icon(
              //         //     onPressed: () async {
              //         //       if (!isplaying && !audioplayed) {
              //         //         int result = await player.play(
              //         //             widget.music_url);
              //         //         if (result == 1) {
              //         //           //play success
              //         //           setState(() {
              //         //             isplaying = true;
              //         //             audioplayed = true;
              //         //           });
              //         //         } else {
              //         //           print("Error while playing audio.");
              //         //         }
              //         //       } else if (audioplayed && !isplaying) {
              //         //         int result = await player.resume();
              //         //         if (result == 1) {
              //         //           //resume success
              //         //           setState(() {
              //         //             isplaying = true;
              //         //             audioplayed = true;
              //         //           });
              //         //         } else {
              //         //           print("Error on resume audio.");
              //         //         }
              //         //       } else {
              //         //         int result = await player.pause();
              //         //         if (result == 1) {
              //         //           //pause success
              //         //           setState(() {
              //         //             isplaying = false;
              //         //           });
              //         //         } else {
              //         //           print("Error on pause audio.");
              //         //         }
              //         //       }
              //         //     },
              //         //     icon: Icon(isplaying ? Icons.pause : Icons.play_arrow),
              //         //     label: Text(isplaying ? "" : "")),
              //         // ElevatedButton.icon(
              //         //     onPressed: () async {
              //         //       int result = await player.stop();
              //         //       if (result == 1) {
              //         //         //stop success
              //         //         setState(() {
              //         //           isplaying = false;
              //         //           audioplayed = false;
              //         //           currentpos = 0;
              //         //         });
              //         //       } else {
              //         //         print("Error on stop audio.");
              //         //       }
              //         //     },
              //         //     icon: Icon(Icons.stop),
              //         //     label: Text("Stop")),
              //       ],
              //     ),
              //   ),
              // ),

              // Expanded(
              //   flex : 2,child:  (isplaying ? Container(
              //   height: 50,
              //   child: Wrap(
              //     spacing: 10,
              //     children: [
              //       GestureDetector(
              //         onTap: () async {
              //           if (!isplaying && !audioplayed) {
              //             int result = await player.play(widget.music_url);
              //             if (result == 1) {
              //               //play success
              //               setState(() {
              //                 isplaying = true;
              //                 audioplayed = true;
              //               });
              //             } else {
              //               print("Error while playing audio.");
              //             }
              //           } else if (audioplayed && !isplaying) {
              //             int result = await player.resume();
              //             if (result == 1) {
              //               //resume success
              //               setState(() {
              //                 isplaying = true;
              //                 audioplayed = true;
              //               });
              //             } else {
              //               print("Error on resume audio.");
              //             }
              //           } else {
              //             int result = await player.pause();
              //             if (result == 1) {
              //               //pause success
              //               setState(() {
              //                 isplaying = false;
              //               });
              //             } else {
              //               print("Error on pause audio.");
              //             }
              //           }
              //         },
              //         child: Container(
              //             decoration: BoxDecoration(
              //                 color: Colors.pink,
              //                 borderRadius: BorderRadius.circular(100)),
              //             child: Padding(
              //               padding: const EdgeInsets.all(5.0),
              //               child: Icon(
              //                 isplaying ? Icons.pause : Icons.play_arrow,
              //                 color: Colors.white,
              //               ),
              //             )),
              //       ),
              //       // ElevatedButton.icon(
              //       //     onPressed: () async {
              //       //       if (!isplaying && !audioplayed) {
              //       //         int result = await player.play(
              //       //             widget.music_url);
              //       //         if (result == 1) {
              //       //           //play success
              //       //           setState(() {
              //       //             isplaying = true;
              //       //             audioplayed = true;
              //       //           });
              //       //         } else {
              //       //           print("Error while playing audio.");
              //       //         }
              //       //       } else if (audioplayed && !isplaying) {
              //       //         int result = await player.resume();
              //       //         if (result == 1) {
              //       //           //resume success
              //       //           setState(() {
              //       //             isplaying = true;
              //       //             audioplayed = true;
              //       //           });
              //       //         } else {
              //       //           print("Error on resume audio.");
              //       //         }
              //       //       } else {
              //       //         int result = await player.pause();
              //       //         if (result == 1) {
              //       //           //pause success
              //       //           setState(() {
              //       //             isplaying = false;
              //       //           });
              //       //         } else {
              //       //           print("Error on pause audio.");
              //       //         }
              //       //       }
              //       //     },
              //       //     icon: Icon(isplaying ? Icons.pause : Icons.play_arrow),
              //       //     label: Text(isplaying ? "" : "")),
              //       // ElevatedButton.icon(
              //       //     onPressed: () async {
              //       //       int result = await player.stop();
              //       //       if (result == 1) {
              //       //         //stop success
              //       //         setState(() {
              //       //           isplaying = false;
              //       //           audioplayed = false;
              //       //           currentpos = 0;
              //       //         });
              //       //       } else {
              //       //         print("Error on stop audio.");
              //       //       }
              //       //     },
              //       //     icon: Icon(Icons.stop),
              //       //     label: Text("Stop")),
              //     ],
              //   ),
              // ) :  Text(
              //   widget.artist_name,
              //   overflow: TextOverflow.ellipsis,
              //   maxLines: 1,
              //   style: TextStyle(fontSize: 12, color: Colors.red),
              // )),),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    ///
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MusicBuyScreen(
                                song_name: widget.music.songName!,
                                artist_name: widget.music.artistName!,
                                price: widget.music.price!,
                                file_name: widget.music.songName!,
                                music_id: widget.music.id!)));
                    // Get.to(MusicBuyScreen(
                    //     song_name: widget.music.songName!,
                    //     artist_name: widget.music.artistName!,
                    //     price: widget.music.price!,
                    //     file_name: widget.music.songName!,
                    //     music_id: widget.music.id!));
                  },
                  child: const Icon(
                    Icons.download,
                    color: Colors.white,
                  ),
                  // Text(
                  //   currentpostlabel,
                  //   overflow: TextOverflow.ellipsis,
                  //   maxLines: 1,
                  //   style: TextStyle(fontSize: 14, color: HexColor('#E84F90')),
                  // ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            // height: 1,
            color: HexColor(CommonColor.pinkFont).withOpacity(0.7),
            height: 0.5,
            width: MediaQuery.of(context).size.width,
          )
        ],
      ),
    );
  }
}

class Music_player2 extends StatefulWidget {
  final String music_url;
  final String title;
  final String artist_name;

  const Music_player2(
      {super.key,
      required this.music_url,
      required this.title,
      required this.artist_name});

  @override
  State<Music_player2> createState() => _Music_player2State();
}

class _Music_player2State extends State<Music_player2>
    with WidgetsBindingObserver {
  int? maxduration;
  int currentpos = 0;
  String currentpostlabel = "00:00";
  String audioasset = "assets/audio/red-indian-music.mp3";
  bool isplaying = false;
  bool audioplayed = false;
  String? duration;

  AudioPlayer player = AudioPlayer();

  Animation<double>? animation;
  AnimationController? animController;

  music_set() async {
    // Ensure proper setup of the audio session
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());

    // Listen for errors during playback
    player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });

    // Try to load audio from the specified URL and catch any errors
    try {
      final audioSourceUrl =
          "${URLConstants.base_data_url}music/${widget.music_url}";
      print('Audio source URL: $audioSourceUrl'); // Log the URL for debugging
      await player.setAudioSource(AudioSource.uri(Uri.parse(audioSourceUrl)));
    } catch (e) {
      print("Error loading audio source: $e");
    }

    // Listen to duration changes if needed
    player.durationStream.listen((Duration? d) {
      setState(() {
        maxduration = d?.inMilliseconds ?? 0;
      });
    });

    // Listen to position changes if needed
    player.positionStream.listen((Duration p) {
      setState(() {
        currentpos = p.inMilliseconds;

        // Generating the duration label
        int shours = Duration(milliseconds: currentpos).inHours;
        int sminutes = Duration(milliseconds: currentpos).inMinutes;
        int sseconds = Duration(milliseconds: currentpos).inSeconds;

        int rhours = shours;
        int rminutes = sminutes - (shours * 60);
        int rseconds = sseconds - (sminutes * 60 + shours * 60 * 60);

        currentpostlabel = "$rhours:$rminutes:$rseconds";
      });
    });
  }
  // music_set() async {
  //   //convert ByteData to Uint8List
  //   // duration = await player.setUrl(widget.music_url).toString();
  //   final session = await AudioSession.instance;
  //   await session.configure(const AudioSessionConfiguration.speech());
  //   // Listen to errors during playback.
  //   player.playbackEventStream.listen((event) {}, onError: (Object e, StackTrace stackTrace) {
  //     print('A stream error occurred: $e');
  //   });
  //   // Try to load audio from a source and catch any errors.
  //   try {
  //     // AAC example: https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.aac
  //     await player.setAudioSource(AudioSource.uri(Uri.parse("${URLConstants.base_data_url}music/${widget.music_url}")));
  //   } catch (e) {
  //     print("Error loading audio source: $e");
  //   }
  //   // setState(() {
  //   //   player.onDurationChanged.listen((Duration d) {
  //   //     //get the duration of audio
  //   //     maxduration = d.inMilliseconds;
  //   //   });
  //   // });
  //   // setState(() {
  //   //   player.onAudioPositionChanged.listen((Duration p) {
  //   //     currentpos =
  //   //         p.inMilliseconds; //get the current position of playing audio
  //   //
  //   //     //generating the duration label
  //   //     int shours = Duration(milliseconds: currentpos).inHours;
  //   //     int sminutes = Duration(milliseconds: currentpos).inMinutes;
  //   //     int sseconds = Duration(milliseconds: currentpos).inSeconds;
  //   //
  //   //     int rhours = shours;
  //   //     int rminutes = sminutes - (shours * 60);
  //   //     int rseconds = sseconds - (sminutes * 60 + shours * 60 * 60);
  //   //
  //   //     currentpostlabel = "$rhours:$rminutes:$rseconds";
  //   //   });
  //   // });
  //   //
  //   // animController = AnimationController(
  //   //     duration: Duration(milliseconds: 1000), vsync: this);
  //   // final curvedAnimation =
  //   //     CurvedAnimation(parent: animController!, curve: Curves.easeInOutSine);
  //   //
  //   // animation = Tween<double>(begin: 0, end: 100).animate(curvedAnimation)
  //   //   ..addListener(() {
  //   //     setState(() {});
  //   //   });

  // }

  @override
  void initState() {
    music_set();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Release decoders and buffers back to the operating system making them
    // available for other apps to use.
    player.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      player.stop();
    }
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          player.positionStream,
          player.bufferedPositionStream,
          player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  static const _backgroundColor = Color(0xFFF15BB5);

  static const _colors = [
    Color(0xFFFEE440),
    Color(0xFF00BBF9),
  ];

  static const _durations = [
    5000,
    4000,
  ];

  static const _heightPercentages = [
    0.65,
    0.66,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  // color: Colors.white,
                  child: Text(
                    widget.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  widget.artist_name,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(fontSize: 14, color: HexColor('#A7A7A7')),
                ),
              ),
              // PolygonWaveform(
              //   samples: [],
              //   height: 50,
              //   width: 50,
              //   maxDuration: Duration(seconds: 100),
              //   elapsedDuration: Duration(milliseconds: currentpos),
              // ),
              StreamBuilder<PlayerState>(
                stream: player.playerStateStream,
                builder: (context, snapshot) {
                  final playerState = snapshot.data;
                  final processingState = playerState?.processingState;
                  final playing = playerState?.playing;
                  if (processingState == ProcessingState.loading ||
                      processingState == ProcessingState.buffering) {
                    return Container(
                      margin: const EdgeInsets.all(8.0),
                      width: 24.0,
                      height: 24.0,
                      child: CircularProgressIndicator(
                        color: HexColor(
                          CommonColor.pinkFont,
                        ),
                        strokeWidth: 2,
                      ),
                    );
                  } else if (playing != true) {
                    return IconButton(
                      icon: Icon(Icons.play_arrow,
                          color: HexColor(CommonColor.pinkFont)),
                      iconSize: 24.0,
                      onPressed: player.play,
                    );
                  } else if (processingState != ProcessingState.completed) {
                    return IconButton(
                      icon: Icon(Icons.pause,
                          color: HexColor(CommonColor.pinkFont)),
                      iconSize: 24.0,
                      onPressed: player.pause,
                    );
                  } else {
                    return IconButton(
                      icon: const Icon(Icons.replay),
                      iconSize: 24.0,
                      onPressed: () => player.seek(Duration.zero),
                    );
                  }
                },
              ),
              // Expanded(
              //   flex: 2,
              //   child: Container(
              //     color: Colors.red,
              //     height: 50,
              //     child: Wrap(
              //       spacing: 10,
              //       children: [
              //         // ElevatedButton.icon(
              //         //     onPressed: () async {
              //         //       if (!isplaying && !audioplayed) {
              //         //         int result = await player.play(
              //         //             widget.music_url);
              //         //         if (result == 1) {
              //         //           //play success
              //         //           setState(() {
              //         //             isplaying = true;
              //         //             audioplayed = true;
              //         //           });
              //         //         } else {
              //         //           print("Error while playing audio.");
              //         //         }
              //         //       } else if (audioplayed && !isplaying) {
              //         //         int result = await player.resume();
              //         //         if (result == 1) {
              //         //           //resume success
              //         //           setState(() {
              //         //             isplaying = true;
              //         //             audioplayed = true;
              //         //           });
              //         //         } else {
              //         //           print("Error on resume audio.");
              //         //         }
              //         //       } else {
              //         //         int result = await player.pause();
              //         //         if (result == 1) {
              //         //           //pause success
              //         //           setState(() {
              //         //             isplaying = false;
              //         //           });
              //         //         } else {
              //         //           print("Error on pause audio.");
              //         //         }
              //         //       }
              //         //     },
              //         //     icon: Icon(isplaying ? Icons.pause : Icons.play_arrow),
              //         //     label: Text(isplaying ? "" : "")),
              //         // ElevatedButton.icon(
              //         //     onPressed: () async {
              //         //       int result = await player.stop();
              //         //       if (result == 1) {
              //         //         //stop success
              //         //         setState(() {
              //         //           isplaying = false;
              //         //           audioplayed = false;
              //         //           currentpos = 0;
              //         //         });
              //         //       } else {
              //         //         print("Error on stop audio.");
              //         //       }
              //         //     },
              //         //     icon: Icon(Icons.stop),
              //         //     label: Text("Stop")),
              //       ],
              //     ),
              //   ),
              // ),

              // Expanded(
              //   flex : 2,child:  (isplaying ? Container(
              //   height: 50,
              //   child: Wrap(
              //     spacing: 10,
              //     children: [
              //       GestureDetector(
              //         onTap: () async {
              //           if (!isplaying && !audioplayed) {
              //             int result = await player.play(widget.music_url);
              //             if (result == 1) {
              //               //play success
              //               setState(() {
              //                 isplaying = true;
              //                 audioplayed = true;
              //               });
              //             } else {
              //               print("Error while playing audio.");
              //             }
              //           } else if (audioplayed && !isplaying) {
              //             int result = await player.resume();
              //             if (result == 1) {
              //               //resume success
              //               setState(() {
              //                 isplaying = true;
              //                 audioplayed = true;
              //               });
              //             } else {
              //               print("Error on resume audio.");
              //             }
              //           } else {
              //             int result = await player.pause();
              //             if (result == 1) {
              //               //pause success
              //               setState(() {
              //                 isplaying = false;
              //               });
              //             } else {
              //               print("Error on pause audio.");
              //             }
              //           }
              //         },
              //         child: Container(
              //             decoration: BoxDecoration(
              //                 color: Colors.pink,
              //                 borderRadius: BorderRadius.circular(100)),
              //             child: Padding(
              //               padding: const EdgeInsets.all(5.0),
              //               child: Icon(
              //                 isplaying ? Icons.pause : Icons.play_arrow,
              //                 color: Colors.white,
              //               ),
              //             )),
              //       ),
              //       // ElevatedButton.icon(
              //       //     onPressed: () async {
              //       //       if (!isplaying && !audioplayed) {
              //       //         int result = await player.play(
              //       //             widget.music_url);
              //       //         if (result == 1) {
              //       //           //play success
              //       //           setState(() {
              //       //             isplaying = true;
              //       //             audioplayed = true;
              //       //           });
              //       //         } else {
              //       //           print("Error while playing audio.");
              //       //         }
              //       //       } else if (audioplayed && !isplaying) {
              //       //         int result = await player.resume();
              //       //         if (result == 1) {
              //       //           //resume success
              //       //           setState(() {
              //       //             isplaying = true;
              //       //             audioplayed = true;
              //       //           });
              //       //         } else {
              //       //           print("Error on resume audio.");
              //       //         }
              //       //       } else {
              //       //         int result = await player.pause();
              //       //         if (result == 1) {
              //       //           //pause success
              //       //           setState(() {
              //       //             isplaying = false;
              //       //           });
              //       //         } else {
              //       //           print("Error on pause audio.");
              //       //         }
              //       //       }
              //       //     },
              //       //     icon: Icon(isplaying ? Icons.pause : Icons.play_arrow),
              //       //     label: Text(isplaying ? "" : "")),
              //       // ElevatedButton.icon(
              //       //     onPressed: () async {
              //       //       int result = await player.stop();
              //       //       if (result == 1) {
              //       //         //stop success
              //       //         setState(() {
              //       //           isplaying = false;
              //       //           audioplayed = false;
              //       //           currentpos = 0;
              //       //         });
              //       //       } else {
              //       //         print("Error on stop audio.");
              //       //       }
              //       //     },
              //       //     icon: Icon(Icons.stop),
              //       //     label: Text("Stop")),
              //     ],
              //   ),
              // ) :  Text(
              //   widget.artist_name,
              //   overflow: TextOverflow.ellipsis,
              //   maxLines: 1,
              //   style: TextStyle(fontSize: 12, color: Colors.red),
              // )),),
              Expanded(
                child: StreamBuilder<PositionData>(
                  stream: _positionDataStream,
                  builder: (context, snapshot) {
                    final positionData = snapshot.data;
                    return SeekBar(
                      duration: positionData?.duration ?? Duration.zero,
                      position: positionData?.position ?? Duration.zero,
                      bufferedPosition:
                          positionData?.bufferedPosition ?? Duration.zero,
                      onChangeEnd: player.seek,
                    );
                  },
                ),

                // Container(
                //  child:
                //   Text(
                //     currentpostlabel,
                //     overflow: TextOverflow.ellipsis,
                //     maxLines: 1,
                //     style: TextStyle(fontSize: 14, color: HexColor('#E84F90')),
                //   ),
                // ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            // height: 1,
            color: HexColor(CommonColor.pinkFont).withOpacity(0.7),
            height: 0.5,
            width: MediaQuery.of(context).size.width,
          )
        ],
      ),
    );
  }
}
