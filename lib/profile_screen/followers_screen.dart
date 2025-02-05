import 'dart:convert' as convert;

import 'package:flutter/material.dart';
// import 'package:funky_project/Utils/colorUtils.dart';
// import 'package:funky_project/search_screen/search__screen_controller.dart';
// import 'package:funky_project/search_screen/search_screen_user_profile.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

import '../Utils/App_utils.dart';
import '../Utils/asset_utils.dart';
import '../Utils/colorUtils.dart';
import '../Utils/custom_textfeild.dart';
import '../search_screen/search__screen_controller.dart';
import '../sharePreference.dart';
import 'model/followersModel.dart';

class FollowersList extends StatefulWidget {
  final String user_id;

  const FollowersList({super.key, required this.user_id});

  @override
  State<FollowersList> createState() => _FollowersListState();
}

class _FollowersListState extends State<FollowersList> {
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
    super.initState();
  }

  init() async {
    await getAllFollowersList();
    // await getAllFollowingList();
    // await compare_data();
  }

  @override
  void dispose() {
    _search_screen_controller.searchquery.clear();
    super.dispose();
  }

  bool textfeilf_tap = false;
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: HexColor(CommonColor.pinkFont),
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
        await getAllFollowersList();
      },
      child: Scaffold(
        key: _globalKey,
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text(
            'Followers',
            style:
                TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'PB'),
          ),
          centerTitle: true,
          actions: [
            Row(
              children: [
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 20.0, top: 0.0, bottom: 5.0),
                    child: ClipRRect(
                      child: Image.asset(
                        AssetUtils.noti_icon,
                        height: 20.0,
                        width: 20.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 20.0, top: 0.0, bottom: 5.0),
                    child: ClipRRect(
                      child: Image.asset(
                        AssetUtils.chat_icon,
                        height: 20.0,
                        width: 20.0,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
          // leadingWidth: 100,
          leading: Container(
            margin: const EdgeInsets.only(left: 15, top: 0, bottom: 0),
            child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: HexColor(CommonColor.pinkFont),
                )),
          ),
        ),
        body: Container(
          margin: const EdgeInsets.only(top: 100, left: 23, right: 23),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: CommonTextFormField_search(
                        icon_color: HexColor(CommonColor.pinkFont),
                        Font_color: Colors.white,
                        iconData: Icons.search,
                        color: Colors.transparent,
                        controller: _search_screen_controller.searchquery,
                        labelText: "Search",
                        onpress: () {
                          setState(() {
                            _search_screen_controller.searchquery.clear();
                          });
                        },
                        onChanged: (value) {
                          Followers_list_search_API(value);
                        },
                      )),
                ],
              ),
              // (_search_screen_controller.searchlistModel != null ?  Expanded(
              //     child: ListView.builder(
              //       shrinkWrap: true,
              //       itemCount: _search_screen_controller
              //           .searchlistModel!.data!.length,
              //       itemBuilder: (BuildContext context, int index) {
              //         return Row(
              //           children: [
              //             (_search_screen_controller.searchlistModel!
              //                 .data![index].profileUrl!.isNotEmpty
              //                 ? Container(
              //               height: 50,
              //               width: 50,
              //               child: Image.network(
              //                   _search_screen_controller
              //                       .searchlistModel!
              //                       .data![index]
              //                       .profileUrl!),
              //             )
              //                 : SizedBox.shrink()),
              //             Column(
              //               children: [
              //                 Text(
              //                   _search_screen_controller
              //                       .searchlistModel!.data![index].fullName!,
              //                   style: TextStyle(color: Colors.white),
              //                 ),
              //                 Text(
              //                   _search_screen_controller
              //                       .searchlistModel!.data![index].userName!,
              //                   style: TextStyle(color: Colors.white),
              //                 ),
              //               ],
              //             ),
              //           ],
              //         );
              //       },
              //     )): Expanded(
              //   child: GridView.builder(
              //       shrinkWrap: true,
              //       padding: EdgeInsets.zero,
              //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //           crossAxisCount: 2, childAspectRatio: 2 / 3),
              //       itemCount: image_list.length,
              //       itemBuilder: (BuildContext ctx, index) {
              //         return Container(
              //           margin: EdgeInsets.all(8),
              //           child: Image.asset(
              //             image_list[index],
              //             fit: BoxFit.contain,
              //           ),
              //         );
              //       }),
              // )),

              // (isfollowersLoading == true
              //     ? Material(
              //         color: Color(0x66DD4D4),
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.center,
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: <Widget>[
              //             Container(
              //                 color: Colors.transparent,
              //                 height: 80,
              //                 width: 200,
              //                 child: Container(
              //                   color: Colors.black,
              //                   child: Row(
              //                     mainAxisAlignment:
              //                         MainAxisAlignment.spaceAround,
              //                     children: [
              //                       CircularProgressIndicator(
              //                         color: HexColor(CommonColor.pinkFont),
              //                       ),
              //                       Text(
              //                         'Loading...',
              //                         style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 18,
              //                             fontFamily: 'PR'),
              //                       )
              //                     ],
              //                   ),
              //                 )
              //                 // Material(
              //                 //   color: Colors.transparent,
              //                 //   child: LoadingIndicator(
              //                 //     backgroundColor: Colors.transparent,
              //                 //     indicatorType: Indicator.ballScale,
              //                 //     colors: _kDefaultRainbowColors,
              //                 //     strokeWidth: 4.0,
              //                 //     pathBackgroundColor: Colors.yellow,
              //                 //     // showPathBackground ? Colors.black45 : null,
              //                 //   ),
              //                 // ),
              //                 ),
              //           ],
              //         ),
              //       )
              //     : (FollowersData.isNotEmpty
              //         ?
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shrinkWrap: true,
                  itemCount: FollowersData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        ListTile(
                          onTap: () {},
                          visualDensity:
                              const VisualDensity(vertical: 0, horizontal: 0),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: SizedBox(
                                height: 50,
                                width: 50,
                                child: (FollowersData[index].image!.isNotEmpty
                                    ? Image.network(
                                        "${URLConstants.base_data_url}images/${FollowersData[index].image!}",
                                        height: 80,
                                        width: 80,
                                        fit: BoxFit.cover,
                                      )
                                    : (FollowersData[index]
                                            .profileUrl!
                                            .isNotEmpty
                                        ? Image.network(
                                            FollowersData[index].profileUrl!,
                                            height: 80,
                                            width: 80,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.asset(
                                            AssetUtils.image1,
                                            height: 80,
                                            width: 80,
                                            fit: BoxFit.cover,
                                          )))),
                          ),
                          title: Text(
                            '${FollowersData[index].fullName}',
                            style: const TextStyle(
                                color: Colors.white, fontFamily: 'PR'),
                          ),
                          trailing: GestureDetector(
                            onTap: () async {
                              print('${FollowersData[index].id}');
                              await _search_screen_controller
                                  .Follow_unfollow_api(
                                      follow_unfollow: (FollowersData[index]
                                                  .userFollowUnfollow ==
                                              'follow'
                                          ? 'unfollow'
                                          : (FollowersData[index]
                                                      .userFollowUnfollow ==
                                                  'unfollow'
                                              ? 'follow'
                                              : (FollowersData[index]
                                                          .userFollowUnfollow ==
                                                      'followback'
                                                  ? 'follow'
                                                  : 'follow'))),
                                      user_id: FollowersData[index].id,
                                      user_social:
                                          FollowersData[index].socialType,
                                      context: context);
                              setState(() {
                                getAllFollowersList();
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 0),
                              height: 34,
                              width: 90,
                              decoration: BoxDecoration(
                                  color: (FollowersData[index]
                                              .userFollowUnfollow ==
                                          'follow'
                                      ? Colors.white
                                      : (FollowersData[index]
                                                  .userFollowUnfollow ==
                                              'unfollow'
                                          ? HexColor(CommonColor.pinkFont)
                                          : (FollowersData[index]
                                                      .userFollowUnfollow ==
                                                  'followback'
                                              ? HexColor(CommonColor.pinkFont)
                                              : Colors.white))),
                                  borderRadius: BorderRadius.circular(17)),
                              child: Container(
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 0),
                                  child: Text(
                                    (FollowersData[index].userFollowUnfollow ==
                                            'follow'
                                        ? 'Following'
                                        : (FollowersData[index]
                                                    .userFollowUnfollow ==
                                                'unfollow'
                                            ? 'Follow'
                                            : (FollowersData[index]
                                                        .userFollowUnfollow ==
                                                    'followback'
                                                ? 'Follow back'
                                                : 'Follow'))),
                                    style: TextStyle(
                                        color: (FollowersData[index]
                                                    .userFollowUnfollow ==
                                                'follow'
                                            ? HexColor(CommonColor.pinkFont)
                                            : (FollowersData[index]
                                                        .userFollowUnfollow ==
                                                    'unfollow'
                                                ? Colors.white
                                                : (FollowersData[index]
                                                            .userFollowUnfollow ==
                                                        'followback'
                                                    ? Colors.white
                                                    : Colors.white))),
                                        fontFamily: 'PR',
                                        fontSize: 14),
                                  )),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          color: HexColor(CommonColor.borderColor),
                          height: 0.5,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ],
                    );
                  },
                ),
              )
              // : Container(
              //     margin: EdgeInsets.symmetric(vertical: 40),
              //     child: Text(
              //       'No Data Found',
              //       style: TextStyle(
              //           color: Colors.white,
              //           fontFamily: 'PR',
              //           fontSize: 16),
              //     ))))
            ],
          ),
        ),
      ),
    );
  }

  bool isfollowersLoading = true;
  String query_followers = '';
  List<Data_followers> FollowersData = [];

  Future<dynamic> getAllFollowersList() async {
    setState(() {
      isfollowersLoading = true;
    });
    final books = await getFollowersList(query_followers);

    setState(() => FollowersData = books);
    print(FollowersData.length);
    setState(() {
      isfollowersLoading = false;
    });
  }

  Future Followers_list_search_API(String query) async {
    final books = await getFollowersList(query);

    if (!mounted) return;

    setState(() {
      query_followers = query;
      FollowersData = books;
    });
  }

  Future<List<Data_followers>> getFollowersList(String query) async {
    String idUser = await PreferenceManager().getPref(URLConstants.id);

    String url =
        ('${URLConstants.base_url}${URLConstants.FollowersListApi}?id=${widget.user_id}&login_user_id=$idUser');
    http.Response response = await http.get(Uri.parse(url));
    print(response);
    List books = [];
    if (response.statusCode == 200) {
      var data = convert.jsonDecode(response.body);
      books = data["data"];
      print('Books =$books');
    }
    return books.map((json) => Data_followers.fromJson(json)).where((book) {
      final titleLower = book.userName!.toLowerCase();
      final authorLower = book.fullName!.toLowerCase();
      final searchLower = query.toLowerCase();

      return titleLower.contains(searchLower) ||
          authorLower.contains(searchLower);
    }).toList();
  }

// compare_data() {
//   List<Data_followers> output = FollowersData.where((
//       element) => !FollowingData.contains(element)).toList();
//   print("output $output");
// }
//
// bool isFollowingLoading = false.obs;
// String query_following = '';
// List<Data_followers> FollowingData = [];
//
// Future<dynamic> getAllFollowingList() async {
//   final books = await getFollowingList(query_following);
//
//   setState(() => this.FollowingData = books);
//   print(FollowingData.length);
// }
//
// static Future<List<Data_followers>> getFollowingList(String query) async {
//   String id_user = await PreferenceManager().getPref(URLConstants.id);
//
//   String url = (URLConstants.base_url +
//       URLConstants.followingListApi +
//       '?id=$id_user');
//   http.Response response = await http.get(Uri.parse(url));
//   print(response);
//   List books = [];
//   if (response.statusCode == 200) {
//     var data = convert.jsonDecode(response.body);
//     books = data["data"];
//     print('Books =${books}');
//   }
//   return books.map((json) => Data_followers.fromJson(json)).where((book) {
//     final titleLower = book.userName!.toLowerCase();
//     final authorLower = book.fullName!.toLowerCase();
//     final searchLower = query.toLowerCase();
//
//     return titleLower.contains(searchLower) ||
//         authorLower.contains(searchLower);
//   }).toList();
// }
}
