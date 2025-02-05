import 'package:flutter/material.dart';

import 'Common/image.dart';
import 'model/galleryModel.dart';

class ImagePostScreen extends StatefulWidget {
  final int index_;
  final GalleryModelList imageListModel;

  const ImagePostScreen({Key? key, required this.index_, required this.imageListModel}) : super(key: key);

  @override
  State<ImagePostScreen> createState() => _ImagePostScreenState();
}

class _ImagePostScreenState extends State<ImagePostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.imageListModel.data!.length,
        controller: PageController(
          initialPage: widget.index_,
          keepPage: true,
        ),
        itemBuilder: (BuildContext context, int index) {
          return CommonImageP(
            user_id: widget.imageListModel.data![index].user!.id!,
            imageModel: widget.imageListModel.data![index],
            useerName: widget.imageListModel.data![index].fullName!,
            Imageurl: widget.imageListModel.data![index].postImage!,
            ProfileUrl: widget.imageListModel.data![index].user!.image!,
            description: widget.imageListModel.data![index].description!,
            SocialProfileUrl: widget.imageListModel.data![index].user!.profileUrl!,
            image_like_count: widget.imageListModel.data![index].likes!,
            image_id: widget.imageListModel.data![index].iD!,
            image_like_status: widget.imageListModel.data![index].likeStatus!,
            enable_download: widget.imageListModel.data![index].enableDownload!,
            enable_comment: widget.imageListModel.data![index].enableComment!,
            comment_count: widget.imageListModel.data![index].commentCount!,
          );
        },
      ),
    );
  }
}
