import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../Utils/asset_utils.dart';
import '../Utils/colorUtils.dart';
import 'controller.dart';

class BlockListScreen extends StatefulWidget {
  const BlockListScreen({super.key});

  @override
  State<BlockListScreen> createState() => _BlockListScreenState();
}

class _BlockListScreenState extends State<BlockListScreen> {
  final Settings_screen_controller _settings_screen_controller = Get.put(
      Settings_screen_controller(),
      tag: Settings_screen_controller().toString());

  @override
  void initState() {
    print('block lIst init');
    init();
    super.initState();
  }

  init() async {
    await _settings_screen_controller.getBlockList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Block List',
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
      body: Obx(() => (_settings_screen_controller.isSearchLoading.value ==
              true)
          ? Center(
              child: Container(
                  height: 80,
                  width: 100,
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
            )
          : (_settings_screen_controller.blockListModel != null &&
                  _settings_screen_controller.blockListModel?.data != null &&
                  _settings_screen_controller.blockListModel!.data!.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 50),
                      child: Text(
                          "${_settings_screen_controller.blockListModel?.message}",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'PR')),
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount:
                      _settings_screen_controller.blockListModel!.data!.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                        leading: SizedBox(
                            height: 70,
                            width: 70,
                            // color: Colors.white,
                            child: IconButton(
                              icon: Image.asset(
                                AssetUtils.user_icon3,
                                fit: BoxFit.cover,
                              ),
                              onPressed: () {},
                            )),
                        title: Text(
                          _settings_screen_controller
                              .blockListModel!.data![index].fullName!,
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontFamily: 'PR'),
                        ),
                        subtitle: Text(
                          _settings_screen_controller
                              .blockListModel!.data![index].userName!,
                          style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontFamily: 'PR'),
                        ),
                        trailing: GestureDetector(
                          onTap: () {
                            print(_settings_screen_controller
                                .blockListModel!.data![index].id);
                            _settings_screen_controller.Block_unblock_api(
                                context: context,
                                user_id: _settings_screen_controller
                                    .blockListModel!.data![index].id!,
                                user_name: _settings_screen_controller
                                    .blockListModel!.data![index].userName!,
                                social_bloc_type: _settings_screen_controller
                                    .blockListModel!.data![index].socialType!,
                                block_unblock: "Unblock");
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(20)),
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 12),
                              child: const Text(
                                'Unblock',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontFamily: 'PR'),
                              ),
                            ),
                          ),
                        ));
                  },
                ))),
    );
  }
}
