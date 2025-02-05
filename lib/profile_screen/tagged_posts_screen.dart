import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:funky_new/profile_screen/tagged_list_screen.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

import '../Utils/App_utils.dart';
import '../Utils/colorUtils.dart';
import '../search_screen/search__screen_controller.dart';
import '../sharePreference.dart';
import 'model/TaggedPostsModel.dart';

class TaggedPostScreen extends StatefulWidget {
  final String? tagged_id;
  final String? user_id;
  final String? tagged_username;

  const TaggedPostScreen(
      {super.key, this.tagged_id, this.tagged_username, required this.user_id});

  @override
  State<TaggedPostScreen> createState() => _TaggedPostScreenState();
}

class _TaggedPostScreenState extends State<TaggedPostScreen> {
  final Search_screen_controller _search_screen_controller = Get.put(
      Search_screen_controller(),
      tag: Search_screen_controller().toString());

  bool isTaggedLoading = true;
  TaggedPostModel? _taggedPostModel;

  Future<dynamic> get_tagged_post() async {
    setState(() {
      isTaggedLoading = true;
    });
    // showLoader(context);

    String idUser = await PreferenceManager().getPref(URLConstants.id);
    // String body = json.encode(data);

    var url =
        ('${URLConstants.base_url}tagPost.php?tag_user_id=${widget.tagged_id}&login_user_id=${widget.user_id}');
    // var url = ('${URLConstants.base_url}tagPost.php?tag_user_id=52&login_user_id=10000020');

    http.Response response = await http.get(Uri.parse(url));

    print(response.body);
    print(response.request);
    print(response.statusCode);
    // var final_data = jsonDecode(response.body);
    // print('final data $final_data');
    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = convert.jsonDecode(response.body);
      _taggedPostModel = TaggedPostModel.fromJson(data);
      if (_taggedPostModel!.error == false) {
        debugPrint(
            '2-2-2-2-2-2 Inside the product Controller Details ${_taggedPostModel!.data!.length}');
        setState(() {
          isTaggedLoading = false;
        }); // CommonWidget().showToaster(msg: data["success"].toString());
        return _taggedPostModel;
      } else {
        setState(() {
          isTaggedLoading = false;
        });
        // CommonWidget().showToaster(msg: msg.toString());
        return null;
      }
    } else if (response.statusCode == 422) {
      setState(() {
        isTaggedLoading = false;
      });
      // CommonWidget().showToaster(msg: msg.toString());
    } else if (response.statusCode == 401) {
      setState(() {
        isTaggedLoading = false;
      });
      // CommonService().unAuthorizedUser();
    } else {
      // CommonWidget().showToaster(msg: msg.toString());
    }
  }

  @override
  void initState() {
    get_tagged_post();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "${widget.tagged_username}",
            style: const TextStyle(
                fontSize: 16, color: Colors.white, fontFamily: 'PB'),
          ),
          centerTitle: false,
          // leadingWidth: 100,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 23.0, vertical: 10),
        child: Column(
          children: [
            isTaggedLoading == true
                ? Expanded(
                    child: Center(
                      child: Container(
                          height: 80,
                          width: 100,
                          color: Colors.transparent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: HexColor(CommonColor.pinkFont),
                              ),
                            ],
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
                          ),
                    ),
                  )
                : (_taggedPostModel!.error == true
                    ? const Expanded(
                        child: Center(
                            child: Text(
                          'No post available',
                          style: TextStyle(
                              color: Colors.white60, fontFamily: 'PM'),
                        )),
                      )
                    : Expanded(
                        child: StaggeredGridView.countBuilder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 20),
                          crossAxisCount: 4,
                          staggeredTileBuilder: (int index) =>
                              StaggeredTile.count(2, index.isEven ? 3 : 2),
                          mainAxisSpacing: 4.0,
                          crossAxisSpacing: 4.0,
                          itemCount: _taggedPostModel!.data!.length,
                          itemBuilder: (context, index) => ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Container(
                                height: 120.0,
                                // width: 120.0,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.rectangle,
                                ),
                                // child: Image.file(_search_screen_controller.test_thumb[index]),
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(TaggedListScreen(
                                      index_: index,
                                      taggedPostModel: _taggedPostModel,
                                    ));
                                  },
                                  child: (_taggedPostModel!
                                              .data![index].isVideo ==
                                          'false'
                                      ? FadeInImage.assetNetwork(
                                          fit: BoxFit.cover,
                                          image:
                                              "${URLConstants.base_data_url}images/${_taggedPostModel!.data![index].postImage}",
                                          placeholder:
                                              'assets/images/Funky_App_Icon.png',
                                        )
                                      : Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Positioned.fill(
                                              child: Image.network(
                                                "http://foxyserver.com/funky/images/Funky_App_Icon.png",
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.black54,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100)),
                                              child: const Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: Icon(
                                                  Icons.play_arrow,
                                                  color: Colors.pink,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                )),
                          ),
                        ),
                      )),
          ],
        ),
      ),
    );
  }
}
