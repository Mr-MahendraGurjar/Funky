import 'package:flutter/material.dart';
import 'package:funky_new/chat_with_firebase/chat_screen/firebase_chat_screen.dart';
import 'package:funky_new/custom_widget/loader_page.dart';
import 'package:funky_new/search_screen/model/searchModel.dart';
import 'package:funky_new/search_screen/search__screen_controller.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../Utils/App_utils.dart';
import '../Utils/asset_utils.dart';
import '../Utils/colorUtils.dart';
import '../Utils/custom_textfeild.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({super.key});

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  List image_list = [
    AssetUtils.image1,
    AssetUtils.image2,
    AssetUtils.image3,
    AssetUtils.image4,
    AssetUtils.image5,
  ];
  final Search_screen_controller _search_screen_controller = Get.put(
      Search_screen_controller(),
      tag: Search_screen_controller().toString());

  @override
  void initState() {
    init();
    _incrementCounter();

    // bloc?.events?.add(ModeDeleteChatsEvent());
    super.initState();
  }

  init() {
    // _search_screen_controller.getDiscoverFeed(context: context);
    _search_screen_controller.getSearchHistoryList(context);
  }

  int _counter = 0;

  _incrementCounter() async {
    if (_search_screen_controller.getDiscoverModel != null &&
        _search_screen_controller.getDiscoverModel?.advertisers != null) {
      for (var i = 0;
          i <= _search_screen_controller.getDiscoverModel!.advertisers!.length;
          i++) {
        //Loop 100 times
        await Future.delayed(const Duration(seconds: 10), () {
          // Delay 500 milliseconds
          if (mounted) {
            setState(() {
              _counter++; //Increment Counter
            });
          }
          // print(_counter);
        });
        print(i);
        if (i ==
            _search_screen_controller.getDiscoverModel!.advertisers!.length -
                1) {
          print("sie");
          if (mounted) {
            setState(() {
              i = 0;
              _counter = 0;
            });
          }
        }
      }
    }
  }

  @override
  void dispose() {
    _search_screen_controller.searchquery.clear();
    super.dispose();
  }

  bool textfeild_tap = false;

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.transparent,
        //   title: const Row(),
        // ),
        key: _globalKey,
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        // resizeToAvoidBottomInset: false,'

        body: RefreshIndicator(
          color: HexColor(CommonColor.pinkFont),
          onRefresh: () async {},
          child: Container(
            margin: const EdgeInsets.only(top: 0, left: 13, right: 13),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 30,
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20, top: 20),
                  child: Row(
                    children: [
                      Expanded(
                          child: CommonTextFormField_search(
                        icon_color: Colors.black,
                        Font_color: Colors.black,
                        iconData: Icons.clear_rounded,
                        color: Colors.white,
                        controller: _search_screen_controller.searchquery,
                        labelText: "Search",
                        tap: () {
                          _search_screen_controller
                              .getSearchHistoryList(context);
                          setState(() {
                            textfeild_tap = true;
                            _search_screen_controller.taxfeildTapped(true);
                          });
                        },
                        onpress: () {
                          setState(() {
                            if (!textfeild_tap) {
                              Get.back();
                            }
                            textfeild_tap = false;
                            FocusScope.of(context).requestFocus(FocusNode());
                            _search_screen_controller.searchquery.clear();
                          });
                        },
                        onChanged: (dynamic) {
                          print(dynamic[0]);
                          if (dynamic[0] == '#') {
                            setState(() {
                              _search_screen_controller.getHashtagList(
                                  hashtag: dynamic);
                            });
                          } else {
                            setState(() {
                              _search_screen_controller.getUserList(
                                  search: dynamic);
                            });
                          }
                        },
                      )),
                    ],
                  ),
                ),
                (_search_screen_controller.searchquery.text.isNotEmpty
                    ? (_search_screen_controller.searchquery.text[0] == '#'
                        ? (_search_screen_controller.hashTagSearchModel == null
                            ? const SizedBox.shrink()
                            : 
                            Expanded(
                                child: ListView.builder(
                                padding: const EdgeInsets.only(bottom: 50),
                                shrinkWrap: true,
                                itemCount: _search_screen_controller
                                    .hashTagSearchModel!.data!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return ListTile(
                                    visualDensity: const VisualDensity(
                                        vertical: 2, horizontal: 0),
                                    onTap: () async {
                                      print(_search_screen_controller
                                          .hashTagSearchModel!
                                          .data![index]
                                          .tagName!);
                                      await _search_screen_controller
                                          .postSearchHistory(
                                              search_username:
                                                  _search_screen_controller
                                                      .hashTagSearchModel!
                                                      .data![index]
                                                      .tagName!);
                                      // Get.to(TaggedAddUserPage(
                                      //     Hashtag: _search_screen_controller
                                      //         .hashTagSearchModel!
                                      //         .data![index]
                                      //         .tagName!));
                                    },
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: const Alignment(-1.0, 0.0),
                                              end: const Alignment(1.0, 0.0),
                                              transform: const GradientRotation(
                                                  0.7853982),
                                              // stops: [0.1, 0.5, 0.7, 0.9],
                                              colors: [
                                                HexColor("#000000"),
                                                Colors.pink,
                                                // HexColor("#FFFFFF").withOpacity(0.67),
                                              ],
                                            ),
                                            color: Colors.white,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(26.0))),
                                        child: const Center(
                                          child: Text(
                                            '#',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      _search_screen_controller
                                          .hashTagSearchModel!
                                          .data![index]
                                          .tagName!,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'PR'),
                                    ),
                                  );
                                },
                              )))
                      
                        : Obx(() => _search_screen_controller
                                    .isSearchLoading.value ==
                                true
                            ? const LoaderPage()
                            : (_search_screen_controller.searchlistModel == null
                                ? const SizedBox.shrink()
                                :
                                 Expanded(
                                    child: ListView.builder(
                                    padding: const EdgeInsets.only(bottom: 50),
                                    shrinkWrap: true,
                                    itemCount: _search_screen_controller
                                        .searchlistModel!.data!.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return ListTile(
                                        onTap: () async {
                                          String id = _search_screen_controller
                                              .searchlistModel!
                                              .data![index]
                                              .id!;

                                          Data_searchApi lastOut =
                                              _search_screen_controller
                                                  .searchlistModel!.data!
                                                  .firstWhere((element) =>
                                                      element.id == id);
                                          Data_searchApi blahh = lastOut;

                                          await _search_screen_controller
                                              .postSearchHistory(
                                                  search_username:
                                                      _search_screen_controller
                                                          .searchlistModel!
                                                          .data![index]
                                                          .userName!);

                                          Get.to(() => FirebaseChatScreen(
                                              receiverId: id));
                                        },
                                        leading: SizedBox(
                                          height: 50,
                                          width: 50,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: (_search_screen_controller
                                                    .searchlistModel!
                                                    .data![index]
                                                    .profileUrl!
                                                    .isNotEmpty
                                                ? Image.asset(
                                                    'assets/images/Funky_App_Icon.png')
                                                : (_search_screen_controller
                                                        .searchlistModel!
                                                        .data![index]
                                                        .image!
                                                        .isNotEmpty
                                                    ? FadeInImage.assetNetwork(
                                                        height: 80,
                                                        width: 80,
                                                        fit: BoxFit.cover,
                                                        image:
                                                            "${URLConstants.base_data_url}images/${_search_screen_controller.searchlistModel!.data![index].image!}",
                                                        placeholder:
                                                            'assets/images/Funky_App_Icon.png',
                                                      )
                                                    : SizedBox(
                                                        height: 50,
                                                        width: 50,
                                                        child: IconButton(
                                                          icon: Image.asset(
                                                            AssetUtils
                                                                .user_icon3,
                                                            fit: BoxFit.fill,
                                                          ),
                                                          onPressed: () {},
                                                        )))),
                                          ),
                                        ),
                                        title: Text(
                                          _search_screen_controller
                                              .searchlistModel!
                                              .data![index]
                                              .fullName!,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'PR'),
                                        ),
                                        subtitle: Text(
                                          _search_screen_controller
                                              .searchlistModel!
                                              .data![index]
                                              .userName!,
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontFamily: 'PR'),
                                        ),
                                      );
                                    },
                                  )))))
                    : (textfeild_tap
                        ? Obx(() => _search_screen_controller
                                    .isSearchHistoryLoading.value ==
                                true
                            ? const LoaderPage()
                            : (_search_screen_controller
                                        .searchhistoryModel!.error ==
                                    false
                                ? Expanded(
                                    child: ListView.builder(
                                      padding: const EdgeInsets.all(0),
                                      itemCount: _search_screen_controller
                                          .searchhistoryModel!.data!.length,
                                      shrinkWrap: true,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return ListTile(
                                          onTap: () async {
                                            setState(() {
                                              _search_screen_controller
                                                      .searchquery.text =
                                                  _search_screen_controller
                                                      .searchhistoryModel!
                                                      .data![index]
                                                      .searchUserName!;
                                            });
                                            setState(() {
                                              _search_screen_controller.getUserList(
                                                  search:
                                                      _search_screen_controller
                                                          .searchhistoryModel!
                                                          .data![index]
                                                          .searchUserName!);
                                            });
                                            setState(() {});
                                          },
                                          title: Text(
                                            _search_screen_controller
                                                .searchhistoryModel!
                                                .data![index]
                                                .searchUserName!,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'PR'),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : Container(
                                    child: Text(
                                      _search_screen_controller
                                          .searchhistoryModel!.message!,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontFamily: 'PB'),
                                    ),
                                  )))
                        : Obx(() => _search_screen_controller
                                    .isDiscoverLoading.value ==
                                true
                            ? const Expanded(child: Center(child: LoaderPage()))
                            : Expanded(
                                child: Container(),
                              )))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
