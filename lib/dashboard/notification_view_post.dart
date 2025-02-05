import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../custom_widget/loader_page.dart';
import '../profile_screen/Common/image.dart';
import '../profile_screen/Common/video.dart';
import 'controller/post_screen_controller.dart';

class NotificationViewPost extends StatefulWidget {
  final String isVideo;
  final String post_id;

  const NotificationViewPost({Key? key, required this.isVideo, required this.post_id}) : super(key: key);

  @override
  State<NotificationViewPost> createState() => _NotificationViewPostState();
}

class _NotificationViewPostState extends State<NotificationViewPost> {
  final DashboardScreenController _dashboardScreenController =
      Get.put(DashboardScreenController(), tag: DashboardScreenController().toString());

  @override
  void initState() {
    _dashboardScreenController.get_post_details(context: context, post_id: widget.post_id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        // appBar: AppBar(
        //   backgroundColor: Colors.red,
        // ),
        body: Obx(() => _dashboardScreenController.isPostDetailLoading.value
            ? Center(child: LoaderPage())
            : (widget.isVideo == 'true'
                ? CommonVideo(
                    user_id: _dashboardScreenController.postDetailModel!.data![0].user!.id!,
                    play: true,
                    singerName: _dashboardScreenController.postDetailModel!.data![0].user!.userName!,
                    description: _dashboardScreenController.postDetailModel!.data![0].description!,
                    songName: "",
                    url: _dashboardScreenController.postDetailModel!.data![0].uploadVideo!,
                    image_url: _dashboardScreenController.postDetailModel!.data![0].image!,
                    video_id: _dashboardScreenController.postDetailModel!.data![0].iD!,
                    comment_count: _dashboardScreenController.postDetailModel!.data![0].commentCount!,
                    video_like_count: _dashboardScreenController.postDetailModel!.data![0].likes!,
                    video_like_status: _dashboardScreenController.postDetailModel!.data![0].likeStatus!,
                    profile_url: "",
                    videomodel: null,
                    user_type: _dashboardScreenController.postDetailModel!.data![0].user!.type!,
                    enable_download: '',
                    enable_comment: '',
                  )
                : CommonImageP(
                    user_id: _dashboardScreenController.postDetailModel!.data![0].user!.id!,
                    imageModel: null,
                    useerName: _dashboardScreenController.postDetailModel!.data![0].user!.userName!,
                    Imageurl: _dashboardScreenController.postDetailModel!.data![0].postImage!,
                    SocialProfileUrl: '',
                    ProfileUrl: _dashboardScreenController.postDetailModel!.data![0].image!,
                    description: _dashboardScreenController.postDetailModel!.data![0].description!,
                    image_like_count: _dashboardScreenController.postDetailModel!.data![0].likes!,
                    image_like_status: _dashboardScreenController.postDetailModel!.data![0].likeStatus!,
                    image_id: _dashboardScreenController.postDetailModel!.data![0].iD!,
                    comment_count: _dashboardScreenController.postDetailModel!.data![0].commentCount!,
                    enable_download: '',
                    enable_comment: '',
                  ))));
  }
}
