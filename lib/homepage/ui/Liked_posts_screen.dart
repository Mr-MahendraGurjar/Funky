import 'package:flutter/material.dart';
import 'package:funky_new/custom_widget/loader_page.dart';
import 'package:funky_new/homepage/ui/common_image_class.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../Utils/colorUtils.dart';
import '../../dashboard/dashboard_screen.dart';
import '../controller/homepage_controller.dart';
import 'common_video_class.dart';

class LikedPostScreen extends StatefulWidget {
  const LikedPostScreen({Key? key}) : super(key: key);

  @override
  State<LikedPostScreen> createState() => _LikedPostScreenState();
}

class _LikedPostScreenState extends State<LikedPostScreen> {
  final HomepageController homepageController = Get.put(HomepageController(), tag: HomepageController().toString());

  @override
  void initState() {
    homepageController.getAllLikedPostList();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        // drawer: DrawerScreen(),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: GestureDetector(
            onTap: () {
              Get.to(Dashboard(page: 0));
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
        body: RefreshIndicator(
          color: HexColor(CommonColor.pinkFont),
          onRefresh: () async {
            setState(() {});
          },
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height - 0,
                  child: Obx(() => (homepageController.isLikedPostLoading.value == true
                          // && homepageController.likedPostModel != null
                          )
                          ? Center(child: LoaderPage())
                          : (homepageController.likedPostModel!.error == false
                              ? (homepageController.likedPostModel!.data!.isNotEmpty
                                  ? Stack(
                                      children: [
                                        Center(
                                          child: PageView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: homepageController.likedPostModel!.data!.length,
                                              onPageChanged: (int page) {
                                                // if(homepageController.controller_last!.value.isPlaying){
                                                //   setState(() {
                                                //     homepageController.controller_last!.pause();
                                                //     // homepageController.controller_last!.removeListener();
                                                //     homepageController.controller_last = null;
                                                //   });
                                                // }else{
                                                //   print("notplaying");
                                                // }
                                                setState(() {});
                                              },
                                              itemBuilder: (BuildContext context, int index) {
                                                return (homepageController.likedPostModel!.data![index].isVideo ==
                                                        'true'
                                                    ? VideoWidget(
                                                        liked_post: true,
                                                        videoListModel: homepageController.likedPostModel!.data![index],
                                                        url: homepageController
                                                            .likedPostModel!.data![index].uploadVideo!,
                                                        comment_count: homepageController
                                                            .likedPostModel!.data![index].commentCount!,
                                                        play: true,
                                                        description: homepageController
                                                            .likedPostModel!.data![index].description!,
                                                        songName:
                                                            homepageController.likedPostModel!.data![index].musicName!,
                                                        image_url: homepageController
                                                            .likedPostModel!.data![index].user!.image!,
                                                        profile_url: homepageController
                                                            .likedPostModel!.data![index].user!.profileUrl!,
                                                        singerName:
                                                            (homepageController.likedPostModel!.data![index].userName ==
                                                                    null
                                                                ? ''
                                                                : homepageController
                                                                    .likedPostModel!.data![index].userName!),
                                                        video_id: homepageController.likedPostModel!.data![index].iD!,
                                                        video_like_count:
                                                            homepageController.likedPostModel!.data![index].likes!,
                                                        video_like_status:
                                                            homepageController.likedPostModel!.data![index].likeStatus!,
                                                      )
                                                    : ImageWidget(
                                                        liked_post: true,
                                                        useerName:
                                                            homepageController.likedPostModel!.data![index].fullName!,
                                                        Imageurl:
                                                            homepageController.likedPostModel!.data![index].postImage!,
                                                        ProfileUrl: homepageController
                                                            .likedPostModel!.data![index].user!.image!,
                                                        description: homepageController
                                                            .likedPostModel!.data![index].description!,
                                                        SocialProfileUrl: homepageController
                                                            .likedPostModel!.data![index].user!.profileUrl!,
                                                        image_like_count:
                                                            homepageController.likedPostModel!.data![index].likes!,
                                                        image_id: homepageController.likedPostModel!.data![index].iD!,
                                                        image_like_status:
                                                            homepageController.likedPostModel!.data![index].likeStatus!,
                                                        imagemodel: homepageController.likedPostModel!.data![index],
                                                      ));
                                              }),
                                        ),
                                      ],
                                    )
                                  : Container(
                                      alignment: Alignment.center,
                                      color: Colors.transparent,
                                      height: 80,
                                      width: 200,
                                      child: Container(
                                        color: Colors.black,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            CircularProgressIndicator(
                                              color: Colors.pink,
                                            ),
                                            Text(
                                              'Loading...',
                                              style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'PR'),
                                            )
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
                                      ))
                              : SizedBox())

                      // Center(
                      //         child: Container(
                      //           child:CircularProgressIndicator(color: HexColor(CommonColor.pinkFont)),
                      //         ),
                      //       )
                      ),
                ),
              ],
            ),
          ),
        ));
  }
}
