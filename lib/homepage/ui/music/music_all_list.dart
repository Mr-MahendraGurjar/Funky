import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../custom_widget/loader_page.dart';
import '../../../dashboard/dashboard_screen.dart';
import '../../../profile_screen/music_player.dart';
import '../../controller/homepage_controller.dart';

class MusicList extends StatefulWidget {
  const MusicList({Key? key}) : super(key: key);

  @override
  State<MusicList> createState() => _MusicListState();
}

class _MusicListState extends State<MusicList> {
  final HomepageController homepageController = Get.put(HomepageController(), tag: HomepageController().toString());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homepageController.getAllMusicList();

      // Add Your Code here.
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // extendBodyBehindAppBar: true,
      // drawer: DrawerScreen(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "Select Music",
          style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'PR'),
        ),
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
      body: Container(
        child: SingleChildScrollView(
            child: Obx(
          () => (homepageController.isallMusicLoading.value == true
              ? Center(
                  child: LoaderPage(),
                )
              : (homepageController.getAllMusicModel!.error == false
                  ? ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.only(bottom: 100),
                      itemCount: homepageController.getAllMusicModel!.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Music_player(
                          music_url: homepageController.getAllMusicModel!.data![index].musicFile!,
                          title: homepageController.getAllMusicModel!.data![index].songName!,
                          artist_name: homepageController.getAllMusicModel!.data![index].artistName!,
                          music: homepageController.getAllMusicModel!.data![index],
                        );
                      },
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 50),
                          child: Text("${homepageController.getAllMusicModel!.message}",
                              style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'PR')),
                        ),
                      ),
                    ))),
        )),
      ),
    );
  }
}
