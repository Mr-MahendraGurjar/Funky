import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

import '../Utils/App_utils.dart';
import '../Utils/asset_utils.dart';
import '../Utils/colorUtils.dart';
import '../Utils/custom_textfeild.dart';
import '../profile_screen/model/followersModel.dart';
import '../search_screen/model/searchModel.dart';
import '../search_screen/search__screen_controller.dart';
import '../sharePreference.dart';

class TagPeopleSearch extends StatefulWidget {
  const TagPeopleSearch({super.key});

  @override
  State<TagPeopleSearch> createState() => _TagPeopleSearchState();
}

class _TagPeopleSearchState extends State<TagPeopleSearch> {
  bool textfeilf_tap = false;
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  final Search_screen_controller _search_screen_controller = Get.put(
      Search_screen_controller(),
      tag: Search_screen_controller().toString());

  init() async {
    // await _search_screen_controller.friendSuggestionList(context: context);
    await getUserList();
  }

  List<ChartData2> tagged_users = [];

  String? imageData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        key: _globalKey,
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text(
            'Tag People',
            style:
                TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'PB'),
          ),
          centerTitle: true,
          actions: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(100)),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context, tagged_users);
                    },
                    child: const Icon(
                      Icons.check_circle,
                      color: Colors.pink,
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
                  // Get.to(Profile_Screen());
                  Navigator.pop(context);
                  setState(() {});
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: HexColor(CommonColor.pinkFont),
                )),
          ),
        ),
        body: Container(
          margin: const EdgeInsets.only(top: 100, left: 10, right: 10),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: CommonTextFormField_search(
                        Font_color: Colors.white,
                        icon_color: HexColor(CommonColor.pinkFont),
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
                          // setState(() {
                          getUserList();
                          tapped = false;

                          // });
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
              (_search_screen_controller.searchquery.text.isNotEmpty
                  ? (isSearchLoading == false
                      ? (searchlistModel!.data!.isNotEmpty
                          ? (tapped == true
                              ? Tagged_people()
                              : Expanded(
                                  child: ListView.builder(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    shrinkWrap: true,
                                    itemCount: searchlistModel!.data!.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Column(
                                        children: [
                                          ListTile(
                                            onTap: () {
                                              if (searchlistModel!.data![index]
                                                  .image!.isNotEmpty) {
                                                setState(() {
                                                  imageData = searchlistModel!
                                                      .data![index].image!;
                                                });
                                              } else if (searchlistModel!
                                                  .data![index]
                                                  .profileUrl!
                                                  .isNotEmpty) {
                                                setState(() {
                                                  imageData = searchlistModel!
                                                      .data![index].profileUrl!;
                                                });
                                              }

                                              setState(() {
                                                tagged_users.add(ChartData2(
                                                    imageData!,
                                                    searchlistModel!
                                                        .data![index]
                                                        .userName!));
                                                tapped = true;
                                              });
                                              for (var i = 0;
                                                  i < tagged_users.length;
                                                  i++) {
                                                print(tagged_users[i].username);
                                              }
                                            },
                                            visualDensity: const VisualDensity(
                                                vertical: 0, horizontal: 0),
                                            leading: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              child: SizedBox(
                                                  height: 50,
                                                  width: 50,
                                                  child: (searchlistModel!
                                                          .data![index]
                                                          .image!
                                                          .isNotEmpty
                                                      ? Image.network(
                                                          "${URLConstants.base_data_url}images/${searchlistModel!.data![index].image!}",
                                                          height: 80,
                                                          width: 80,
                                                          fit: BoxFit.cover,
                                                        )
                                                      : (searchlistModel!
                                                              .data![index]
                                                              .profileUrl!
                                                              .isNotEmpty
                                                          ? Image.asset(
                                                              AssetUtils.image1,
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
                                              '${searchlistModel!.data![index].fullName}',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'PR'),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            color: HexColor(
                                                CommonColor.borderColor),
                                            height: 0.5,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ))
                          : Container(
                              margin: const EdgeInsets.symmetric(vertical: 40),
                              child: const Text(
                                'No Data Found',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'PR',
                                    fontSize: 16),
                              )))
                      : Container(
                          margin: const EdgeInsets.symmetric(vertical: 40),
                          child: const Text(
                            'No Data Found',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'PR',
                                fontSize: 16),
                          )))
                  : const SizedBox.shrink())
            ],
          ),
        ),
      ),
    );
  }

  Widget Tagged_people() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: const Text(
              'Tagged Users',
              style:
                  TextStyle(color: Colors.pink, fontFamily: 'PM', fontSize: 16),
            )),
        Container(
          alignment: Alignment.centerLeft,
          height: MediaQuery.of(context).size.height / 5,
          child: ListView.builder(
            itemCount: tagged_users.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  margin: const EdgeInsets.all(5),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: SizedBox(
                                height: 60,
                                width: 60,
                                child: (Image.network(
                                  "${URLConstants.base_data_url}images/${tagged_users[index].image}",
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                ))),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(100)),
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    tagged_users.removeAt(index);
                                  });
                                },
                                child: const Icon(
                                  Icons.cancel_sharp,
                                  color: Colors.pink,
                                  size: 20,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        tagged_users[index].username,
                        style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontFamily: 'PM'),
                      )
                    ],
                  ));
            },
          ),
        ),
      ],
    );
  }

  bool tapped = false;
  bool isFollowingLoading = true;
  String query_following = '';
  List<Data_followers> FollowingData = [];
  SearchApiModel? searchlistModel;
  bool isSearchLoading = false;
  RxBool taxfeildTapped = false.obs;

  Future<dynamic> getUserList() async {
    setState(() {
      isSearchLoading = true;
    });
    String url = (URLConstants.base_url + URLConstants.searchListApi);

    // debugPrint('Get Sales Token ${tokens.toString()}');
    // try {
    // } catch (e) {
    //   print('1-1-1-1 Get Purchase ${e.toString()}');
    // }
    String idUser = await PreferenceManager().getPref(URLConstants.id);

    Map data = {
      'search': _search_screen_controller.searchquery.text,
      'blocID': idUser,
      'tag': 'true',
      'userId': idUser
    };
    print(data);
    // String body = json.encode(data);

    var response = await http.post(
      Uri.parse(url),
      body: data,
    );

    print('Response request: ${response.request}');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = convert.jsonDecode(response.body);
      searchlistModel = SearchApiModel.fromJson(data);
      if (searchlistModel!.error == false) {
        debugPrint(
            '2-2-2-2-2-2 Inside the product Controller Details ${searchlistModel!.data!.length}');
        setState(() {
          isSearchLoading = false;
        }); // CommonWidget().showToaster(msg: data["success"].toString());
        return searchlistModel;
      } else {
        setState(() {
          isSearchLoading = false;
        });
        // CommonWidget().showToaster(msg: msg.toString());
        return null;
      }
    } else if (response.statusCode == 422) {
      setState(() {
        isSearchLoading = false;
      });
      // CommonWidget().showToaster(msg: msg.toString());
    } else if (response.statusCode == 401) {
      setState(() {
        isSearchLoading = false;
      });
      // CommonService().unAuthorizedUser();
    } else {
      // CommonWidget().showToaster(msg: msg.toString());
    }
  }
}

class ChartData2 {
  final String image;
  final String username;

  ChartData2(this.image, this.username);
}
