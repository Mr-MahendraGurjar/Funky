import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

import '../Utils/App_utils.dart';
import '../Utils/colorUtils.dart';
import '../Utils/toaster_widget.dart';
import '../custom_widget/loader_page.dart';
import '../dashboard/dashboard_screen.dart';
import '../sharePreference.dart';
import 'analytics_details.dart';
import 'model/analytics_model.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  @override
  void initState() {
    get_post_list(context);

    super.initState();
  }

  Route _createQrRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          Dashboard(page: 0),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
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
              Navigator.of(context).push(_createQrRoute());

              // Get.to(Dashboard(page: 0));
              // Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          )),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 10, right: 16, left: 16),
        child: SingleChildScrollView(
            child: (ispostLoading == true
                ? Center(
                    child: SizedBox(
                        height: MediaQuery.of(context).size.height - 100,
                        child: LoaderPage()),
                  )
                : (_analyticsModelList!.error == false
                    ? StaggeredGridView.countBuilder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 4,
                        staggeredTileBuilder: (int index) =>
                            StaggeredTile.count(2, index.isEven ? 3 : 2),
                        mainAxisSpacing: 4.0,
                        crossAxisSpacing: 4.0,
                        itemCount: _analyticsModelList!.data!.length,
                        itemBuilder: (context, index) => ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: SizedBox(
                                height: 120.0,
                                // width: 120.0,
                                child: (ispostLoading == true
                                    ? CircularProgressIndicator(
                                        color: HexColor(CommonColor.pinkFont),
                                      )
                                    : Container(
                                        color: Colors.black,
                                        child: (_analyticsModelList!
                                                .data![index].postImage!.isEmpty
                                            ? GestureDetector(
                                                onTap: () {
                                                  Get.to(AnalyticsDetails(
                                                    data: _analyticsModelList!
                                                        .data![index]
                                                        .uploadVideo!,
                                                    likes: _analyticsModelList!
                                                        .data![index].likes!,
                                                    shares: _analyticsModelList!
                                                        .data![index]
                                                        .shareCount!,
                                                    comments:
                                                        _analyticsModelList!
                                                            .data![index]
                                                            .commentCount!,
                                                    image: false,
                                                    view_count:
                                                        _analyticsModelList!
                                                            .data![index]
                                                            .viewsCount!,
                                                  ));
                                                },
                                                child: Stack(
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
                                                            color:
                                                                Colors.black54,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100)),
                                                        child: const Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  5.0),
                                                          child: Icon(
                                                            Icons.play_arrow,
                                                            color: Colors.pink,
                                                          ),
                                                        ),
                                                      )
                                                    ]),
                                              )
                                            : GestureDetector(
                                                onTap: () {
                                                  Get.to(AnalyticsDetails(
                                                    data: _analyticsModelList!
                                                        .data![index]
                                                        .postImage!,
                                                    likes: _analyticsModelList!
                                                        .data![index].likes!,
                                                    shares: _analyticsModelList!
                                                        .data![index]
                                                        .shareCount!,
                                                    comments:
                                                        _analyticsModelList!
                                                            .data![index]
                                                            .commentCount!,
                                                    image: true,
                                                    view_count:
                                                        _analyticsModelList!
                                                            .data![index]
                                                            .viewsCount!,
                                                  ));
                                                },
                                                child: Image.network(
                                                  '${URLConstants.base_data_url}images/${_analyticsModelList!.data![index].postImage}',
                                                  fit: BoxFit.cover,
                                                  loadingBuilder: (context,
                                                      child, loadingProgress) {
                                                    if (loadingProgress ==
                                                        null) {
                                                      return child;
                                                    }
                                                    return Center(
                                                        child: SizedBox(
                                                            height: 30,
                                                            width: 30,
                                                            child:
                                                                CircularProgressIndicator(
                                                              color: HexColor(
                                                                  CommonColor
                                                                      .pinkFont),
                                                            )));
                                                    // You can use LinearProgressIndicator, CircularProgressIndicator, or a GIF instead
                                                  },
                                                ),
                                              )),
                                      )),
                              ),
                            ))
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Container(
                            margin: const EdgeInsets.only(top: 50),
                            child: Text("${_analyticsModelList!.message}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'PR')),
                          ),
                        ),
                      )))),
      ),
    );
  }

  bool ispostLoading = true;
  AnalyticsModelList? _analyticsModelList;

  Future<dynamic> get_post_list(BuildContext context) async {
    setState(() {
      ispostLoading = true;
    });
    // showLoader(context);

    String idUser = await PreferenceManager().getPref(URLConstants.id);

    debugPrint('0-0-0-0-0-0-0 username');
    Map data = {
      'userId': idUser,
      'isVideo': 'false',
    };
    print(data);
    // String body = json.encode(data);

    var url = ('${URLConstants.base_url}analytics.php?userId=$idUser');
    print("url : $url");
    print("body : $data");
    var response = await http.post(
      Uri.parse(url),
      body: data,
    );
    print(response.body);
    print(response.request);
    print(response.statusCode);
    // var final_data = jsonDecode(response.body);
    // print('final data $final_data');
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      _analyticsModelList = AnalyticsModelList.fromJson(data);

      if (_analyticsModelList!.error == false) {
        CommonWidget().showToaster(msg: 'Succesful');
        // print(_galleryModelList);
        setState(() {
          ispostLoading = false;
        });
        // print(_galleryModelList!.data![0].postImage);
        // print(_galleryModelList!.data![1].postImage);

        // hideLoader(context);
        // Get.to(Dashboard());
      } else {
        setState(() {
          ispostLoading = false;
        });
        print('Please try again');
      }
    } else {
      print('Please try again');
    }
  }
}
