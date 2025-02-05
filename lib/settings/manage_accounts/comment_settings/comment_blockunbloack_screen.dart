import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:funky_new/custom_widget/loader_page.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../Utils/App_utils.dart';
import '../../../Utils/asset_utils.dart';
import '../../../Utils/colorUtils.dart';
import '../../../Utils/custom_textfeild.dart';
import '../controller/manage_account_controller.dart';

class CommentBlockUnblockScreen extends StatefulWidget {
  const CommentBlockUnblockScreen({Key? key}) : super(key: key);

  @override
  State<CommentBlockUnblockScreen> createState() => _CommentBlockUnblockScreenState();
}

class _CommentBlockUnblockScreenState extends State<CommentBlockUnblockScreen> {
  final Manage_account_controller _manage_account_controller =
      Get.put(Manage_account_controller(), tag: Manage_account_controller().toString());

  @override
  void initState() {
    _manage_account_controller.getList(context: context);
    super.initState();
  }

  bool tapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            'Blocked Comments',
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
              icon: Icon(Icons.arrow_back),
            )),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 20, top: 20),
                child: Row(
                  children: [
                    Expanded(
                        child: CommonTextFormField_search(
                      icon_color: Colors.black,
                      Font_color: Colors.black,
                      iconData: Icons.clear,
                      color: Colors.white,
                      controller: _manage_account_controller.blocksearchquery,
                      labelText: "Search",
                      tap: () {},
                      onpress: () {
                        setState(() {
                          _manage_account_controller.blocksearchquery.clear();
                        });
                      },
                      onChanged: (dynamic) {
                        setState(() {
                          _manage_account_controller.getUserListBlock(search: dynamic);
                          tapped = true;
                          // _search_screen_controller.getUserList(search: dynamic);
                        });
                      },
                    )),
                    Container(
                      // color: Colors.red,
                      margin: const EdgeInsets.only(left: 0, top: 0, bottom: 0),
                      child: IconButton(
                          visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                          padding: EdgeInsets.zero,
                          onPressed: () {},
                          icon: (Image.asset(
                            AssetUtils.filter_icon,
                            color: HexColor(CommonColor.pinkFont),
                            height: 19.0,
                            width: 19.0,
                            fit: BoxFit.contain,
                          ))),
                    ),
                  ],
                ),
              ),
              (_manage_account_controller.blocksearchquery.text.isNotEmpty
                  ? (_manage_account_controller.searchlistModel == null
                      ? SizedBox.shrink()
                      : Expanded(
                          child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 50),
                          shrinkWrap: true,
                          itemCount: _manage_account_controller.searchlistModel!.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                                onTap: () async {
                                  // String id = _manage_account_controller
                                  //     .searchlistModel!.data![index].id!;
                                  // String username = _manage_account_controller
                                  //     .searchlistModel!.data![index].userName!;
                                  //
                                  // print("id $id");
                                  // // _manage_account_controller.taxfeildTapped(false);
                                  //
                                  // await _manage_account_controller
                                  //     .commentBlockUnblock(
                                  //         context: context,
                                  //         block_id: id,
                                  //         action: 'search',
                                  //         block_unblock: 'block');
                                  //
                                  // await _manage_account_controller.getList(
                                  //     context: context);
                                  // setState(() {
                                  //   _manage_account_controller.blocksearchquery
                                  //       .clear();
                                  // });
                                },
                                leading: Container(
                                  height: 50,
                                  width: 50,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child:
                                        (_manage_account_controller.searchlistModel!.data![index].profileUrl!.isNotEmpty
                                            ? Image.asset('assets/images/Funky_App_Icon.png')
                                            // FadeInImage.assetNetwork(
                                            //         height: 80,
                                            //         width: 80,
                                            //         fit: BoxFit.cover,
                                            //         placeholder:
                                            //             'assets/images/Funky_App_Icon.png',
                                            //         image: _search_screen_controller
                                            //             .searchlistModel!
                                            //             .data![index]
                                            //             .profileUrl!,
                                            //       )
                                            :
                                            // Container(
                                            //   height: 50,
                                            //   width: 50,
                                            //   child: ClipRRect(
                                            //     borderRadius: BorderRadius.circular(50),
                                            //     child: Image.network(
                                            //       _search_screen_controller
                                            //           .searchlistModel!
                                            //           .data![index]
                                            //           .profileUrl!, fit: BoxFit.fill,),
                                            //   ),
                                            // )
                                            (_manage_account_controller.searchlistModel!.data![index].image!.isNotEmpty
                                                ? FadeInImage.assetNetwork(
                                                    height: 80,
                                                    width: 80,
                                                    fit: BoxFit.cover,
                                                    image:
                                                        "${URLConstants.base_data_url}images/${_manage_account_controller.searchlistModel!.data![index].image!}",
                                                    placeholder: 'assets/images/Funky_App_Icon.png',
                                                  )
                                                : Container(
                                                    height: 50,
                                                    width: 50,
                                                    child: IconButton(
                                                      icon: Image.asset(
                                                        AssetUtils.user_icon3,
                                                        fit: BoxFit.fill,
                                                      ),
                                                      onPressed: () {},
                                                    )))),
                                  ),
                                ),
                                title: Text(
                                  _manage_account_controller.searchlistModel!.data![index].fullName!,
                                  style: const TextStyle(color: Colors.white, fontFamily: 'PR'),
                                ),
                                subtitle: Text(
                                  _manage_account_controller.searchlistModel!.data![index].userName!,
                                  style: const TextStyle(color: Colors.grey, fontFamily: 'PR'),
                                ),
                                trailing: GestureDetector(
                                  onTap: () async {
                                    // print(_settings_screen_controller
                                    //     .blockListModel!.data![index].id);
                                    // _settings_screen_controller.Block_unblock_api(
                                    //     context: context,
                                    //     user_id: _settings_screen_controller
                                    //         .blockListModel!.data![index].id!,
                                    //     user_name: _settings_screen_controller
                                    //         .blockListModel!.data![index].userName!,
                                    //     social_bloc_type:
                                    //     _settings_screen_controller
                                    //         .blockListModel!
                                    //         .data![index]
                                    //         .socialType!,
                                    //     block_unblock: "Unblock");

                                    // String id = _manage_account_controller
                                    //     .getBlockListModel!
                                    //     .data![index]
                                    //     .id!;
                                    // String username =
                                    // _manage_account_controller
                                    //     .getBlockListModel!
                                    //     .data![index]
                                    //     .userName!;
                                    // _manage_account_controller.blocksearchquery.clear();

                                    // print("id $id");
                                    _manage_account_controller.taxfeildTapped(false);

                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        double width = MediaQuery.of(context).size.width;
                                        double height = MediaQuery.of(context).size.height;
                                        return BackdropFilter(
                                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                          child: AlertDialog(
                                            title: Text("Block User",
                                                style: const TextStyle(color: Colors.black, fontFamily: 'PB')),
                                            content: Text("Are you sure want to block this user?",
                                                style: const TextStyle(
                                                    color: Colors.black, fontSize: 16, fontFamily: 'PR')),
                                            actions: [
                                              TextButton(
                                                child: Text("No"),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              TextButton(
                                                child: Text("Yes"),
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                  String id =
                                                      _manage_account_controller.searchlistModel!.data![index].id!;
                                                  String username = _manage_account_controller
                                                      .searchlistModel!.data![index].userName!;

                                                  print("id $id");
                                                  // _manage_account_controller.taxfeildTapped(false);

                                                  await _manage_account_controller.commentBlockUnblock(
                                                      context: context,
                                                      block_id: id,
                                                      action: 'search',
                                                      block_unblock: 'block');

                                                  await _manage_account_controller.getList(context: context);
                                                  setState(() {
                                                    _manage_account_controller.blocksearchquery.clear();
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    decoration:
                                        BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(20)),
                                    child: Container(
                                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                      child: Text(
                                        'Block',
                                        style: const TextStyle(fontSize: 14, color: Colors.white, fontFamily: 'PR'),
                                      ),
                                    ),
                                  ),
                                ));
                          },
                        )
                          //   StreamProvider<DialogsScreenStates>(
                          //   create: (context) => bloc?.states?.stream
                          //       as Stream<DialogsScreenStates>,
                          //   initialData: ChatConnectingState(),
                          //   child: Selector<DialogsScreenStates,
                          //       DialogsScreenStates>(
                          //     selector: (_, state) => state,
                          //     shouldRebuild: (previous, next) {
                          //       return next is UpdateChatsSuccessState;
                          //     },
                          //     builder: (_, state, __) {
                          //       if (state is UpdateChatsSuccessState) {
                          //         List<QBDialog?> dialogs = state.dialogs;
                          //         return ListView.builder(
                          //           padding:
                          //               const EdgeInsets.only(bottom: 50),
                          //           shrinkWrap: true,
                          //           itemCount: _search_screen_controller
                          //               .searchlistModel!.data!.length,
                          //           itemBuilder:
                          //               (BuildContext context, int index) {
                          //             return ListTile(
                          //               onTap: () {
                          //                 String id =
                          //                     _search_screen_controller
                          //                         .searchlistModel!
                          //                         .data![index]
                          //                         .id!;
                          //                 String username =
                          //                     _search_screen_controller
                          //                         .searchlistModel!
                          //                         .data![index]
                          //                         .userName!;
                          //
                          //                 print("id $id");
                          //
                          //                 Data_searchApi last_out =
                          //                     _search_screen_controller
                          //                         .searchlistModel!.data!
                          //                         .firstWhere((element) =>
                          //                             element.id == id);
                          //                 Data_searchApi blahh = last_out;
                          //
                          //                 // QBDialog? qb_user =
                          //                 //     dialogs.firstWhere((element) =>
                          //                 //         element!.name == username);
                          //                 // if (qb_user == null) {
                          //                 //   print("no data found");
                          //                 // } else {
                          //                 //   print(
                          //                 //       "quickblox username ${qb_user.name}");
                          //                 //   print(
                          //                 //       "quickblox id ${qb_user.id}");
                          //                 // }
                          //                 // print("blahhh id ${blahh.id}");
                          //                 //
                          //                 // print(_search_screen_controller
                          //                 //     .searchlistModel!
                          //                 //     .data![index]
                          //                 //     .id);
                          //                 //
                          //                 // print(dialogs);
                          //                 Get.to(SearchUserProfile(
                          //                   // quickBlox_id: qb_user!.id!,
                          //                   quickBlox_id: "0",
                          //                   // UserId: _search_screen_controller
                          //                   //     .searchlistModel!.data![index].id!,
                          //                   search_user_data: blahh,
                          //
                          //                 ));
                          //               },
                          //               leading: Container(
                          //                 height: 50,
                          //                 width: 50,
                          //                 child: ClipRRect(
                          //                   borderRadius:
                          //                       BorderRadius.circular(50),
                          //                   child: (_search_screen_controller
                          //                           .searchlistModel!
                          //                           .data![index]
                          //                           .profileUrl!
                          //                           .isNotEmpty
                          //                       ? Image.asset(
                          //                           'assets/images/Funky_App_Icon.png')
                          //                       // FadeInImage.assetNetwork(
                          //                       //         height: 80,
                          //                       //         width: 80,
                          //                       //         fit: BoxFit.cover,
                          //                       //         placeholder:
                          //                       //             'assets/images/Funky_App_Icon.png',
                          //                       //         image: _search_screen_controller
                          //                       //             .searchlistModel!
                          //                       //             .data![index]
                          //                       //             .profileUrl!,
                          //                       //       )
                          //                       :
                          //                       // Container(
                          //                       //   height: 50,
                          //                       //   width: 50,
                          //                       //   child: ClipRRect(
                          //                       //     borderRadius: BorderRadius.circular(50),
                          //                       //     child: Image.network(
                          //                       //       _search_screen_controller
                          //                       //           .searchlistModel!
                          //                       //           .data![index]
                          //                       //           .profileUrl!, fit: BoxFit.fill,),
                          //                       //   ),
                          //                       // )
                          //                       (_search_screen_controller
                          //                               .searchlistModel!
                          //                               .data![index]
                          //                               .image!
                          //                               .isNotEmpty
                          //                           ? FadeInImage
                          //                               .assetNetwork(
                          //                               height: 80,
                          //                               width: 80,
                          //                               fit: BoxFit.cover,
                          //                               image:
                          //                                   "${URLConstants.base_data_url}images/${_search_screen_controller.searchlistModel!.data![index].image!}",
                          //                               placeholder:
                          //                                   'assets/images/Funky_App_Icon.png',
                          //                             )
                          //                           : Container(
                          //                               height: 50,
                          //                               width: 50,
                          //                               child: IconButton(
                          //                                 icon: Image.asset(
                          //                                   AssetUtils
                          //                                       .user_icon3,
                          //                                   fit:
                          //                                       BoxFit.fill,
                          //                                 ),
                          //                                 onPressed: () {},
                          //                               )))),
                          //                 ),
                          //               ),
                          //               title: Text(
                          //                 _search_screen_controller
                          //                     .searchlistModel!
                          //                     .data![index]
                          //                     .fullName!,
                          //                 style: const TextStyle(
                          //                     color: Colors.white,
                          //                     fontFamily: 'PR'),
                          //               ),
                          //               subtitle: Text(
                          //                 _search_screen_controller
                          //                     .searchlistModel!
                          //                     .data![index]
                          //                     .userName!,
                          //                 style: const TextStyle(
                          //                     color: Colors.grey,
                          //                     fontFamily: 'PR'),
                          //               ),
                          //             );
                          //           },
                          //         );
                          //       }
                          //
                          //       return Text('');
                          //     },
                          //   ),
                          // )
                          ))
                  : Obx(() => _manage_account_controller.isgetLoading.value == true
                      ? LoaderPage()
                      : (_manage_account_controller.getBlockListModel!.error!
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Container(
                                  margin: EdgeInsets.only(top: 0),
                                  child: Text("Users won't be notified when you block them",
                                      style: TextStyle(
                                          color: HexColor(CommonColor.grey_dark), fontSize: 14, fontFamily: 'PB')),
                                ),
                              ),
                            )
                          : Expanded(
                              child: ListView.builder(
                                itemCount: _manage_account_controller.getBlockListModel!.data!.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return ListTile(
                                      leading: Container(
                                        height: 50,
                                        width: 50,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(50),
                                          child: (_manage_account_controller
                                                  .getBlockListModel!.data![index].profileUrl!.isNotEmpty
                                              ? Image.asset('assets/images/Funky_App_Icon.png')
                                              // FadeInImage.assetNetwork(
                                              //         height: 80,
                                              //         width: 80,
                                              //         fit: BoxFit.cover,
                                              //         placeholder:
                                              //             'assets/images/Funky_App_Icon.png',
                                              //         image: _search_screen_controller
                                              //             .searchlistModel!
                                              //             .data![index]
                                              //             .profileUrl!,
                                              //       )
                                              :
                                              // Container(
                                              //   height: 50,
                                              //   width: 50,
                                              //   child: ClipRRect(
                                              //     borderRadius: BorderRadius.circular(50),
                                              //     child: Image.network(
                                              //       _search_screen_controller
                                              //           .searchlistModel!
                                              //           .data![index]
                                              //           .profileUrl!, fit: BoxFit.fill,),
                                              //   ),
                                              // )
                                              (_manage_account_controller
                                                      .getBlockListModel!.data![index].image!.isNotEmpty
                                                  ? FadeInImage.assetNetwork(
                                                      height: 80,
                                                      width: 80,
                                                      fit: BoxFit.cover,
                                                      image:
                                                          "${URLConstants.base_data_url}images/${_manage_account_controller.getBlockListModel!.data![index].image!}",
                                                      placeholder: 'assets/images/Funky_App_Icon.png',
                                                    )
                                                  : Container(
                                                      height: 50,
                                                      width: 50,
                                                      child: IconButton(
                                                        icon: Image.asset(
                                                          AssetUtils.user_icon3,
                                                          fit: BoxFit.cover,
                                                        ),
                                                        onPressed: () {},
                                                      )))),
                                        ),
                                      ),
                                      title: Text(
                                        _manage_account_controller.getBlockListModel!.data![index].fullName!,
                                        style: const TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'PR'),
                                      ),
                                      subtitle: Text(
                                        _manage_account_controller.getBlockListModel!.data![index].userName!,
                                        style: const TextStyle(fontSize: 14, color: Colors.grey, fontFamily: 'PR'),
                                      ),
                                      trailing: GestureDetector(
                                        onTap: () async {
                                          // print(_settings_screen_controller
                                          //     .blockListModel!.data![index].id);
                                          // _settings_screen_controller.Block_unblock_api(
                                          //     context: context,
                                          //     user_id: _settings_screen_controller
                                          //         .blockListModel!.data![index].id!,
                                          //     user_name: _settings_screen_controller
                                          //         .blockListModel!.data![index].userName!,
                                          //     social_bloc_type:
                                          //     _settings_screen_controller
                                          //         .blockListModel!
                                          //         .data![index]
                                          //         .socialType!,
                                          //     block_unblock: "Unblock");

                                          String id = _manage_account_controller.getBlockListModel!.data![index].id!;
                                          String username =
                                              _manage_account_controller.getBlockListModel!.data![index].userName!;
                                          // _manage_account_controller.blocksearchquery.clear();

                                          print("id $id");
                                          _manage_account_controller.taxfeildTapped(false);

                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              double width = MediaQuery.of(context).size.width;
                                              double height = MediaQuery.of(context).size.height;
                                              return BackdropFilter(
                                                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                                child: AlertDialog(
                                                  title: Text("Unblock User",
                                                      style: const TextStyle(color: Colors.black, fontFamily: 'PB')),
                                                  content: Text("Are you sure want to unblock this user?",
                                                      style: const TextStyle(
                                                          color: Colors.black, fontSize: 16, fontFamily: 'PR')),
                                                  actions: [
                                                    TextButton(
                                                      child: Text("No"),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Text("Yes"),
                                                      onPressed: () async {
                                                        Navigator.pop(context);
                                                        await _manage_account_controller.commentBlockUnblock(
                                                            context: context,
                                                            block_id: id,
                                                            action: 'list',
                                                            block_unblock: 'unblock');

                                                        await _manage_account_controller.getList(context: context);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                          decoration:
                                              BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(20)),
                                          child: Container(
                                            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                            child: Text(
                                              'Unblock',
                                              style:
                                                  const TextStyle(fontSize: 14, color: Colors.white, fontFamily: 'PR'),
                                            ),
                                          ),
                                        ),
                                      ));
                                },
                              ),
                            )))),
            ],
          ),
        ),
      ),
    );
  }
}
