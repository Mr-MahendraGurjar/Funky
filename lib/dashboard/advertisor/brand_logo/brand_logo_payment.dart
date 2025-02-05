import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:funky_new/Utils/asset_utils.dart';
import 'package:funky_new/Utils/colorUtils.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

import '../../../Utils/App_utils.dart';
import '../../../custom_widget/page_loader.dart';
import '../../../sharePreference.dart';
import '../../dashboard_screen.dart';
import 'BrandLogoModel.dart';

class Brand_payment extends StatefulWidget {
  final File brand_logo;
  final String price;
  final String currency;
  final String place;

  const Brand_payment(
      {Key? key, required this.brand_logo, required this.price, required this.currency, required this.place})
      : super(key: key);

  @override
  State<Brand_payment> createState() => _Brand_paymentState();
}

class _Brand_paymentState extends State<Brand_payment> {
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
                      child: GestureDetector(
                        onTap: () {
                          post_brand_logo(context);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
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
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  BrandLogoPost? brandLogoPost;

  Future<dynamic> post_brand_logo(BuildContext context) async {
    showLoader(context);
    var url = URLConstants.base_url + URLConstants.brand_logo_post;
    var request = http.MultipartRequest('POST', Uri.parse(url));
    // List<int> imageBytes = imgFile!.readAsBytesSync();
    // String baseimage = base64Encode(imageBytes);
    String id_user = await PreferenceManager().getPref(URLConstants.id);

    request.fields['userId'] = id_user;
    var files = await http.MultipartFile(
        'logo', File(widget.brand_logo.path).readAsBytes().asStream(), File(widget.brand_logo.path).lengthSync(),
        filename: widget.brand_logo.path.split("/").last);
    request.files.add(files);
    request.fields['price'] = widget.price;
    request.fields['currency'] = widget.currency;
    request.fields['place_location'] = widget.place;

    //userId,tagLine,description,address,postImage,uploadVideo,isVideo
    // request.files.add(await http.MultipartFile.fromPath(
    //     "image", widget.ImageFile.path));

    var response = await request.send();
    var responsed = await http.Response.fromStream(response);
    print(response.statusCode);
    print("response - ${response.statusCode}");

    if (response.statusCode == 200) {
      // isLoading(false);
      var data = jsonDecode(responsed.body);
      brandLogoPost = BrandLogoPost.fromJson(data);
      print(brandLogoPost);
      if (brandLogoPost!.error == false) {
        hideLoader(context);
        await Get.to(Dashboard(
          page: 0,
        ));
        // Get.to(Dashboard());
      } else {
        hideLoader(context);

        print('Please try again');
      }
    } else {
      hideLoader(context);

      print('Please try again');
    }
  }
}
