import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_html_css/simple_html_css.dart';

import '../homepage/controller/homepage_controller.dart';

class CopyRightPolicy extends StatefulWidget {
  const CopyRightPolicy({super.key});

  @override
  State<CopyRightPolicy> createState() => _CopyRightPolicyState();
}

class _CopyRightPolicyState extends State<CopyRightPolicy> {
  final HomepageController homepageController =
      Get.put(HomepageController(), tag: HomepageController().toString());

  @override
  void initState() {
    homepageController.getprivacyPolicy();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextSpan textSpan = HTML.toTextSpan(
      context,
      homepageController.termsServiceModel?.data?.content ?? "",
      linksCallback: (dynamic link) {
        debugPrint('You clicked on ${link.toString()}');
      },
      // as name suggests, optionally set the default text style
      defaultTextStyle: TextStyle(
        color: Colors.grey[700],
      ),

      overrideStyle: <String, TextStyle>{
        'p': const TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontFamily: 'PR',
            fontWeight: FontWeight.w200,
            decoration: TextDecoration.none),
        // FontStyleUtility.h16(
        //     fontColor: ColorUtils.primary_grey,
        //     family: 'PR'),
        'a': const TextStyle(wordSpacing: 2),
        // specify any tag not just the supported ones,
        // and apply TextStyles to them and/override them
      },
    );

    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Copyright policy',
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
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          )),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            children: [
              // Container(
              //   child: Text(
              //     "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. ",
              //     textAlign: TextAlign.justify,
              //     style: TextStyle(
              //         fontSize: 14, color: Colors.white, fontFamily: 'PM'),
              //   ),
              // ),
              Obx(() => homepageController.istermsServiceLoading.value == true
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 19.0),
                      child: RichText(
                          text: /*textSpan*/ HTML.toTextSpan(
                        context,
                        homepageController.termsServiceModel?.data?.content ??
                            "",
                        linksCallback: (dynamic link) {
                          debugPrint('You clicked on ${link.toString()}');
                        },
                        // as name suggests, optionally set the default text style
                        defaultTextStyle: TextStyle(
                          color: Colors.grey[700],
                        ),

                        overrideStyle: <String, TextStyle>{
                          'p': const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontFamily: 'PR',
                              fontWeight: FontWeight.w200,
                              decoration: TextDecoration.none),
                          // FontStyleUtility.h16(
                          //     fontColor: ColorUtils.primary_grey,
                          //     family: 'PR'),
                          'a': const TextStyle(wordSpacing: 2),
                          // specify any tag not just the supported ones,
                          // and apply TextStyles to them and/override them
                        },
                      )),
                    ))
              // Container(
              //   child: Text(
              //     "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. ",
              //     textAlign: TextAlign.justify,
              //     style: TextStyle(
              //         fontSize: 14, color: Colors.white, fontFamily: 'PM'),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
