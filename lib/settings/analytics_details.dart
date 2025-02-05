import 'package:flutter/material.dart';
import 'package:funky_new/dashboard/dashboard_screen.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:video_player/video_player.dart';

import '../Utils/App_utils.dart';
import '../Utils/colorUtils.dart';

class AnalyticsDetails extends StatefulWidget {
  final String data;
  final String likes;
  final String shares;
  final String comments;
  final String view_count;
  final bool image;

  const AnalyticsDetails(
      {Key? key,
      required this.data,
      required this.likes,
      required this.shares,
      required this.comments,
      required this.image,
      required this.view_count})
      : super(key: key);

  @override
  State<AnalyticsDetails> createState() => _AnalyticsDetailsState();
}

class _AnalyticsDetailsState extends State<AnalyticsDetails> {
  bool isClicked = false; // boolean that states if the button is pressed or not
  VideoPlayerController? _controller;
  Future<void>? _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    if (widget.image == false) {
      String uri = Uri.parse("${URLConstants.base_data_url}video/${widget.data}").toString();
      print(uri);
      _controller = VideoPlayerController.network(uri
          // 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4'
          );
      // Initialize the controller and store the Future for later use.
      _initializeVideoPlayerFuture = _controller!.initialize().then((value) {
        setState(() {
          _controller!.play();
        });
      });
      // Use the controller to loop the video.
      _controller!.setLooping(true);
      // _controller!.pause();
    }
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    if (widget.image == false) {
      _controller!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Analytics',
          style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'PB'),
        ),
        centerTitle: true,
        leadingWidth: 100,
        leading: Padding(
          padding: const EdgeInsets.only(
            right: 20.0,
            top: 0.0,
            bottom: 5.0,
          ),
          child: ClipRRect(
              child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          )),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(Dashboard(page: 3));
                },
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.black,
                  child: Text(
                    'View on post',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontFamily: 'PB', color: Colors.pink),
                  ),
                ),
              ),
              (widget.image
                  ? Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          "${URLConstants.base_data_url}images/${widget.data}",
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        setState(() {
                          isClicked = isClicked ? false : true;
                        });
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
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
                                      setState(() {
                                        isClicked = true;
                                        if (_controller!.value.isPlaying) {
                                          _controller!.pause();
                                        } else {
                                          _controller!.play();
                                        }
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.5),
                                          borderRadius: BorderRadius.circular(50)),
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
                        ],
                      ),
                    )),
              SizedBox(
                height: 30,
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 30),
                leading: Icon(
                  Icons.remove_red_eye,
                  color: Colors.white,
                ),
                title: Text(
                  'Number of Views',
                  style: TextStyle(fontSize: 16, fontFamily: 'PM', color: Colors.white),
                ),
                trailing: Text(
                  widget.view_count,
                  style: TextStyle(fontSize: 16, fontFamily: 'PM', color: Colors.pink),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 30),
                leading: Icon(
                  Icons.favorite,
                  color: Colors.white,
                ),
                title: Text(
                  'Likes',
                  style: TextStyle(fontSize: 16, fontFamily: 'PM', color: Colors.white),
                ),
                trailing: Text(
                  widget.likes,
                  style: TextStyle(fontSize: 16, fontFamily: 'PM', color: Colors.pink),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 30),
                leading: Icon(
                  Icons.share,
                  color: Colors.white,
                ),
                title: Text(
                  'Shares',
                  style: TextStyle(fontSize: 16, fontFamily: 'PM', color: Colors.white),
                ),
                trailing: Text(
                  widget.shares,
                  style: TextStyle(fontSize: 16, fontFamily: 'PM', color: Colors.pink),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 30),
                leading: Icon(
                  Icons.message,
                  color: Colors.white,
                ),
                title: Text(
                  'Comments',
                  style: TextStyle(fontSize: 16, fontFamily: 'PM', color: Colors.white),
                ),
                trailing: Text(
                  widget.comments,
                  style: TextStyle(fontSize: 16, fontFamily: 'PM', color: Colors.pink),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
