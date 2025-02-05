import 'package:flutter/material.dart';

import 'Common/video.dart';
import 'model/videoModelList.dart';

class VideoPostScreen extends StatefulWidget {
  final int index_;
  final VideoModelList videomodel;

  const VideoPostScreen({Key? key, required this.videomodel, required this.index_}) : super(key: key);

  @override
  State<VideoPostScreen> createState() => _VideoPostScreenState();
}

class _VideoPostScreenState extends State<VideoPostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.videomodel.data!.length,
        controller: PageController(
          initialPage: widget.index_,
          keepPage: true,
        ),
        itemBuilder: (BuildContext context, int index) {
          return CommonVideo(
            videomodel: widget.videomodel.data![index],
            user_type: widget.videomodel.data![index].user!.type!,
            url: widget.videomodel.data![index].uploadVideo!,
            comment_count: widget.videomodel.data![index].commentCount!,
            play: true,
            description: widget.videomodel.data![index].description!,
            songName: widget.videomodel.data![index].musicName!,
            image_url: widget.videomodel.data![index].user!.image!,
            profile_url: widget.videomodel.data![index].user!.profileUrl!,
            singerName:
                (widget.videomodel.data![index].userName == null ? '' : widget.videomodel.data![index].userName!),
            video_id: widget.videomodel.data![index].iD!,
            video_like_count: widget.videomodel.data![index].likes!,
            video_like_status: widget.videomodel.data![index].likeStatus!,
            enable_download: widget.videomodel.data![index].enableDownload!,
            enable_comment: widget.videomodel.data![index].enableComment!,
            user_id: widget.videomodel.data![index].user!.id!,
          );
        },
      ),
    );
  }
}
