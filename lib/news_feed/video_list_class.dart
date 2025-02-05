import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:video_player/video_player.dart';

import '../Utils/App_utils.dart';
import '../Utils/colorUtils.dart';
import '../profile_screen/video_viewer.dart';

class Videonews extends StatefulWidget {
  final String url;
  final bool play;

  // final String logo;
  // final String title;
  // final String description;
  // final String likeCount;

  const Videonews({
    Key? key,
    required this.url,
    required this.play,
    // required this.logo,
    // required this.title,
    // required this.description,
    // required this.likeCount
  }) : super(key: key);

  @override
  State<Videonews> createState() => VideonewsState();
}

class VideonewsState extends State<Videonews> {
  bool isClicked = false; // boolean that states if the button is pressed or not
  VideoPlayerController? _controller;
  Future<void>? _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    // if(_controller!.value.isPlaying){
    //   _controller!.dispose();
    // }
    print(widget.url);
    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    String uri = Uri.parse("${URLConstants.base_data_url}video/${widget.url}").toString();
    print(uri);
    _controller = VideoPlayerController.network(uri
        // 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4'
        );
    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller!.initialize();
    // Use the controller to loop the video.
    _controller!.setLooping(true);
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      // Container(
      //   child: (_controller!.value.isInitialized ?
      //   Container(
      //     width: MediaQuery.of(context).size.width,
      //     height: MediaQuery.of(context).size.height,
      //     child: AspectRatio(
      //       aspectRatio: _controller!.value.aspectRatio,
      //       child: VideoPlayer(_controller!),
      //     ),
      //   ):  Image.asset(
      //     'assets/images/Funky_App_Icon.png',
      //   )),
      // ),
      FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the VideoPlayerController has finished initialization, use
            // the data it provides to limit the aspect ratio of the video.
            return AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              // Use the VideoPlayer widget to display the video.
              child: VideoPlayer(_controller!),
            );
          } else {
            // If the VideoPlayerController is still initializing, show a
            // loading spinner.
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.pink,
              ),
            );
          }
        },
      ),
      Center(
        child: ButtonTheme(
            height: 50.0,
            minWidth: 50.0,
            child: AnimatedOpacity(
              opacity: isClicked ? 0.0 : 1.0,
              duration: Duration(milliseconds: 100),
              // how much you want the animation to be long)
              child: GestureDetector(
                onTap: () {
                  // if(_controller!.value.isPlaying){
                  //   _controller!.dispose();
                  // }

                  Get.to(VideoViewer(
                    url: widget.url,
                  ));

                  // setState(() {
                  //   isClicked = true;
                  //   if (_controller!.value.isPlaying) {
                  //     _controller!.pause();
                  //   } else {
                  //     _controller!.play();
                  //   }
                  // });
                },
                child: Container(
                  decoration:
                      BoxDecoration(color: Colors.black.withOpacity(0.5), borderRadius: BorderRadius.circular(50)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 30.0,
                      color: HexColor(CommonColor.pinkFont),
                    ),
                  ),
                ),
              ),
            )),
      ),
    ]);
  }

  _playPause() {
    print('video Tapped');
    if (_controller!.value.isPlaying) {
      _controller!.pause();
    } else {
      _controller!.play();
    }
  }
}
