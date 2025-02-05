import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:funky_new/custom_widget/loader_page.dart';
import 'package:funky_new/settings/report_video/post_report_image-screen.dart';
import 'package:funky_new/settings/report_video/report_problem_controller.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../Utils/App_utils.dart';
import '../../Utils/colorUtils.dart';
import '../../custom_widget/common_buttons.dart';
import '../../sharePreference.dart';

class ReportProblem extends StatefulWidget {
  //
  // receiver_user_id == action performing in  which user's post,story or comment etc....
  // type == comment , post , story etc....
  // type_id == post id , comment id , story id etc....

  final String receiver_id, type, type_id;

  const ReportProblem(
      {super.key,
      required this.receiver_id,
      required this.type,
      required this.type_id});

  @override
  State<ReportProblem> createState() => _ReportProblemState();
}

class _ReportProblemState extends State<ReportProblem> {
  bool new_report = true;
  bool previous_report = false;

  final Report_problem_Controller _report_problem_controller = Get.put(
      Report_problem_Controller(),
      tag: Report_problem_Controller().toString());

  @override
  void initState() {
    init();
    super.initState();
  }

  String? idUser;

  init() async {
    print(widget.type);
    print(widget.receiver_id);
    print(widget.type_id);
    String id = await PreferenceManager().getPref(URLConstants.id);
    setState(() {
      idUser = id;
    });
    _report_problem_controller.get_report_list(
        context: context, user_id: idUser!, type: 'all');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text(
            'Report a Problem',
            style:
                TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'PB'),
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
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        new_report = true;
                        previous_report = false;
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: (new_report ? Colors.white : Colors.black),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 5),
                        child: Text('New Report',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                color: HexColor(CommonColor.pinkFont),
                                fontFamily: 'PR')),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        new_report = false;
                        previous_report = true;
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: (previous_report ? Colors.white : Colors.black),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 5),
                        child: Text('Previous Report',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16,
                                color: HexColor(CommonColor.pinkFont),
                                fontFamily: 'PR')),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                color: HexColor(CommonColor.pinkFont).withOpacity(0.7),
                height: 0.5,
                width: MediaQuery.of(context).size.width,
              ),
              (new_report ? NewReportWidget() : PreviousReportWidget()),
            ],
          ),
        ),
      ),
    );
  }

  Widget NewReportWidget() {
    return Expanded(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            Container(
              child: Text(
                "Briefly explain what happened or what's not working.",
                style: TextStyle(
                    fontSize: 16,
                    color: HexColor(CommonColor.pinkFont),
                    fontFamily: 'PR'),
              ),
            ),
            const SizedBox(
              height: 23,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 0),
                  child: const Text(
                    'Title',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'PR',
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 11,
                ),
                Container(
                  // height: 45,
                  // width: 300,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 5,
                        offset: Offset(0, 0),
                        spreadRadius: -5,
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: TextFormField(
                    // maxLines: 5,
                    // onTap: tap,
                    obscureText: false,
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.only(left: 20, top: 14, bottom: 14),
                      alignLabelWithHint: false,
                      isDense: true,
                      hintText: 'Write the problem you faced',
                      filled: true,
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.transparent, width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      // focusedBorder: OutlineInputBorder(
                      //   borderSide:
                      //   BorderSide(color: ColorUtils.blueColor, width: 1),
                      //   borderRadius: BorderRadius.all(Radius.circular(10)),
                      // ),
                      hintStyle: TextStyle(
                        fontSize: 14,
                        fontFamily: 'PR',
                        color: Colors.grey,
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'PR',
                      color: Colors.black,
                    ),
                    controller: _report_problem_controller.title_controller,
                    keyboardType: TextInputType.multiline,
                  ),
                ),
                const SizedBox(
                  height: 11,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 0),
                  child: const Text(
                    'Write report description',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'PR',
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 11,
                ),
                Container(
                  // height: 45,
                  // width: 300,

                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 5,
                        offset: Offset(0, 0),
                        spreadRadius: -5,
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: TextFormField(
                    maxLines: 5,
                    // onTap: tap,
                    obscureText: false,
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.only(left: 20, top: 14, bottom: 14),
                      alignLabelWithHint: false,
                      isDense: true,
                      hintText: 'Write the problem you faced',
                      filled: true,
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.transparent, width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      // focusedBorder: OutlineInputBorder(
                      //   borderSide:
                      //   BorderSide(color: ColorUtils.blueColor, width: 1),
                      //   borderRadius: BorderRadius.all(Radius.circular(10)),
                      // ),
                      hintStyle: TextStyle(
                        fontSize: 14,
                        fontFamily: 'PR',
                        color: Colors.grey,
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'PR',
                      color: Colors.black,
                    ),
                    controller:
                        _report_problem_controller.description_controller,
                    keyboardType: TextInputType.multiline,
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 25),
              child: Text(
                "Please only leave feedback about Funky and our features",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16, color: HexColor('#BCBCBC'), fontFamily: 'PR'),
              ),
            ),
            (_report_problem_controller.selected_files.isNotEmpty
                ? SizedBox(
                    height: 100,
                    child: ListView.builder(
                        itemCount:
                            _report_problem_controller.selected_files.length,
                        physics: const ClampingScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int indx) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    color: HexColor(CommonColor.pinkFont)),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: SizedBox(
                                  height: 50,
                                  width: 80,
                                  child: Image.file(_report_problem_controller
                                      .selected_files[indx]),
                                ),
                              ),
                            ),
                          );
                        }),
                  )
                : const SizedBox()),
            const SizedBox(
              height: 23,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () async {
                    List<XFile> editedFile = await Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const PostReportScreen()));
                    print('editedFile: ${editedFile[0].path}');
                    for (var i = 0; i < editedFile.length; i++) {
                      print('editedFile: ${editedFile[i].path}');
                      setState(() {
                        _report_problem_controller.selected_files
                            .add(File(editedFile[i].path));
                      });
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 0),
                    // height: 45,
                    width: MediaQuery.of(context).size.width / 3,
                    decoration: BoxDecoration(
                        color: HexColor(CommonColor.pinkFont),
                        borderRadius: BorderRadius.circular(25)),
                    child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 25),
                        child: const Text(
                          "Attach",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'PR',
                              fontSize: 16),
                        )),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "Only 5 Attachments (screenshot or image)",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      color: HexColor(CommonColor.pinkFont),
                      fontFamily: 'PR'),
                ),
              ],
            ),
            const SizedBox(
              height: 23,
            ),
            Container(
              alignment: FractionalOffset.bottomCenter,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: common_button(
                lable_text: 'Submit',
                backgroud_color: Colors.white,
                lable_text_color: Colors.black,
                onTap: () async {
                  await _report_problem_controller.uploadReport(
                      context: context,
                      receiver_id: widget.receiver_id,
                      type: widget.type,
                      type_id: widget.type_id);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  String dropdownvalue = 'all';

  Widget PreviousReportWidget() {
    return Column(
      children: [
        Stack(
          children: [
            Obx(() =>
                (_report_problem_controller.isGetReportLoading.value == true
                    ? LoaderPage()
                    : const SizedBox.shrink())),
            Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  margin: const EdgeInsets.only(right: 0),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      customButton: Container(
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              HexColor("#C12265"),
                              HexColor("#000000"),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: HexColor(CommonColor.pinkFont),
                            width: 0.5
                          ),
                        ),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(child: Text(dropdownvalue.capitalize!)),
                              const Icon(
                                Icons.arrow_drop_down_outlined,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: "all",
                          onTap: () async {
                            setState(() {
                              dropdownvalue = "all";
                            });
                            _report_problem_controller.get_report_list(
                              context: context,
                              user_id: idUser!,
                              type: 'all'
                            );
                          },
                          child: const Text("All",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'PR'
                            )
                          )
                        ),
                        DropdownMenuItem(
                          value: "post",
                          onTap: () {
                            setState(() {
                              dropdownvalue = "post";
                            });
                            _report_problem_controller.get_report_list(
                              context: context,
                              user_id: idUser!,
                              type: 'post'
                            );
                          },
                          child: const Text("Post",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'PR'
                            )
                          )
                        ),
                        DropdownMenuItem(
                          value: "comment",
                          onTap: () {
                            setState(() {
                              dropdownvalue = "comment";
                            });
                            _report_problem_controller.get_report_list(
                              context: context,
                              user_id: idUser!,
                              type: 'comment'
                            );
                          },
                          child: const Text("Comment",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'PR'
                            )
                          )
                        ),
                        DropdownMenuItem(
                          value: "story",
                          onTap: () {
                            setState(() {
                              dropdownvalue = "story";
                            });
                            _report_problem_controller.get_report_list(
                              context: context,
                              user_id: idUser!,
                              type: 'story'
                            );
                          },
                          child: const Text("Story",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'PR'
                            )
                          )
                        ),
                        DropdownMenuItem(
                          value: "user",
                          onTap: () {
                            setState(() {
                              dropdownvalue = "user";
                            });
                            _report_problem_controller.get_report_list(
                              context: context,
                              user_id: idUser!,
                              type: 'user'
                            );
                          },
                          child: const Text("User",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'PR'
                            )
                          )
                        ),
                      ],
                      value: dropdownvalue,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'PR',
                        color: Colors.white,
                      ),
                      alignment: Alignment.centerLeft,
                      onChanged: (value) {
                        setState(() {});
                      },
                      iconStyleData: const IconStyleData(
                        iconSize: 25,
                        iconEnabledColor: Color(0xff007DEF),
                        iconDisabledColor: Color(0xff007DEF),
                      ),
                      buttonStyleData: ButtonStyleData(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.transparent
                        ),
                        height: 50,
                        width: 100,
                        elevation: 0,
                        padding: const EdgeInsets.only(left: 14, right: 14),
                      ),
                      enableFeedback: true,
                      dropdownStyleData: DropdownStyleData(
                        padding: EdgeInsets.zero,
                        width: 150,
                        maxHeight: 200,
                        elevation: 8,
                        scrollbarTheme: const ScrollbarThemeData(
                          radius: Radius.circular(40),
                          thickness: WidgetStatePropertyAll(8),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(width: 1, color: Colors.white),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              HexColor("#000000"),
                              HexColor("#C12265"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Obx(
                  () => (_report_problem_controller.isGetReportLoading.value ==
                          true
                      ? const SizedBox()
                      : (_report_problem_controller.getReportProblem!.error ==
                              true
                          ? Center(
                              child: Text(
                                "${_report_problem_controller.getReportProblem!.message}",
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'PM',
                                    color: Colors.white),
                              ),
                            )
                          : SizedBox(
                              height: MediaQuery.of(context).size.height - 250,
                              child: ListView.builder(
                                //physics: const ClampingScrollPhysics(),
                                itemCount: _report_problem_controller
                                    .getReportProblem!.data!.length,
                                shrinkWrap: true,
                                // padding: const EdgeInsets.only(bottom: 50),
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            color:
                                                HexColor(CommonColor.pinkFont),
                                            width: 0.5)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20.0, horizontal: 15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  "${_report_problem_controller.getReportProblem!.data![index].title}",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontFamily: 'PM',
                                                      color: Colors.white),
                                                ),
                                              ),
                                              Text(
                                                "${_report_problem_controller.getReportProblem!.data![index].createdDate}",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'PR',
                                                  color: HexColor(
                                                      CommonColor.grey_light),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Text(
                                              "${_report_problem_controller.getReportProblem!.data![index].description}",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'PR',
                                                color: HexColor(
                                                    CommonColor.grey_light),
                                              ),
                                            ),
                                          ),
                                          (_report_problem_controller
                                                  .getReportProblem!
                                                  .data![index]
                                                  .image!
                                                  .isNotEmpty
                                              ? SizedBox(
                                                  height: 100,
                                                  child: ListView.builder(
                                                      itemCount:
                                                          _report_problem_controller
                                                              .getReportProblem!
                                                              .data![index]
                                                              .image!
                                                              .length,
                                                      physics:
                                                          const ClampingScrollPhysics(),
                                                      shrinkWrap: true,
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int indx) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            child: SizedBox(
                                                              height: 50,
                                                              width: 80,
                                                              child: FadeInImage
                                                                  .assetNetwork(
                                                                fit: BoxFit
                                                                    .cover,
                                                                image:
                                                                    "${URLConstants.base_data_url}images/${_report_problem_controller.getReportProblem!.data![index].image![indx].image}",
                                                                placeholder:
                                                                    'assets/images/Funky_App_Icon.png',
                                                                // color: HexColor(CommonColor.pinkFont),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                )
                                              : const SizedBox.shrink())
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ))),
                )
              ],
            )
          ],
        ),
      ],
    );
  }
}
