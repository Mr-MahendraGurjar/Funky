import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:funky_new/custom_widget/page_loader.dart';
import 'package:funky_new/dashboard/dashboard_screen.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

import '../../../Utils/App_utils.dart';
import '../../../Utils/asset_utils.dart';
import '../../../Utils/colorUtils.dart';
import '../../../sharePreference.dart';

class CommercialVideoPayment extends StatefulWidget {
  final File videoFile;
  final String cover_image;
  final String price;
  final String currency;
  final String place;
  final String description_controller;
  final String tagged_users;
  final String enable_download;
  final String enable_comment;

  const CommercialVideoPayment(
      {Key? key,
      required this.videoFile,
      required this.price,
      required this.currency,
      required this.place,
      required this.description_controller,
      required this.tagged_users,
      required this.enable_download,
      required this.enable_comment,
      required this.cover_image})
      : super(key: key);

  @override
  State<CommercialVideoPayment> createState() => _CommercialVideoPaymentState();
}

class _CommercialVideoPaymentState extends State<CommercialVideoPayment> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              // stops: [0.1, 0.5, 0.7, 0.9],
              colors: [
                HexColor("#000000"),
                HexColor("#000000"),
                Color(0xFF7E1010),
              ],
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: AppBar(
              backgroundColor: Colors.transparent,
              title: const Text(
                "Make a Payment",
                style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'PB'),
              ),
              centerTitle: true,
              leadingWidth: 100,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 30),
                  child: Text(
                    'Start for the payment',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: HexColor(CommonColor.orange), fontSize: 20, fontFamily: 'PB'),
                  ),
                ),
                Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.asset(AssetUtils.advertisor_stripe),
                    )),
                Expanded(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                uploadCommercial(draft: 'true');
                                // post_brand_logo(context);
                              },
                              child: Container(
                                // width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
                                  child: Text(
                                    'Save draft',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.black, fontSize: 15, fontFamily: 'PB'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                uploadCommercial(draft: 'false');
                                // post_brand_logo(context);
                              },
                              child: Container(
                                // width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: HexColor(CommonColor.pinkFont), borderRadius: BorderRadius.circular(30)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
                                  child: Text(
                                    'Share',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white, fontSize: 15, fontFamily: 'PB'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<dynamic> uploadCommercial({required String draft}) async {
    showLoader(context);
    String id_user = await PreferenceManager().getPref(URLConstants.id);
    var url = (URLConstants.base_url + URLConstants.commercial_video_post);
    var request = http.MultipartRequest('POST', Uri.parse(url));

    var files = http.MultipartFile(
        'uploadVideo', File(widget.videoFile.path).readAsBytes().asStream(), File(widget.videoFile.path).lengthSync(),
        filename: widget.videoFile.path.split("/").last);

    request.files.add(files);
    request.fields['userId'] = id_user;
    request.fields['coverImage'] = widget.cover_image;
    request.fields['description'] = widget.description_controller;
    request.fields['tagLine'] = widget.tagged_users;
    request.fields['address'] = '';
    request.fields['draft'] = draft.toString();
    request.fields['postId'] = '';
    request.fields['price'] = widget.price;
    request.fields['currency'] = 'USD';
    request.fields['enableDownload'] = widget.enable_download.toString();
    request.fields['enableComment'] = widget.enable_download.toString();

    //userId,tagLine,description,address,postImage,uploadVideo,isVideo
    // request.files.add(await http.MultipartFile.fromPath(
    //     "image", widget.ImageFile.path));

    var response = await request.send();
    var responsed = await http.Response.fromStream(response);
    final responseData = json.decode(responsed.body);

    if (response.statusCode == 200) {
      print("SUCCESS");
      print(response.reasonPhrase);
      print(widget.videoFile.path);
      print(responseData);
      hideLoader(context);
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Dashboard(
                    page: 3,
                  )));
      // await Get.to(Profile_Screen());
    } else {
      print("ERROR");
    }
  }
}
