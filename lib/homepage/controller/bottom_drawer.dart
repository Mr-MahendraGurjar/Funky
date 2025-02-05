import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../Utils/App_utils.dart';
import '../../Utils/asset_utils.dart';
import '../../Utils/colorUtils.dart';
import '../../sharePreference.dart';
import '../model/GetPostLikeCount.dart';

class Bottom_Drawer extends StatefulWidget {
  final GetPostLikeCount data_like_post;
  final String number_like;

  const Bottom_Drawer({Key? key, required this.data_like_post, required this.number_like}) : super(key: key);

  @override
  State<Bottom_Drawer> createState() => _Bottom_DrawerState();
}

class _Bottom_DrawerState extends State<Bottom_Drawer> {
  String? idUser;

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    idUser = await PreferenceManager().getPref(URLConstants.id);
    setState(() {});
    print("USer ID $idUser");
  }

  @override
  Widget build(BuildContext context) {
    final screenheight = MediaQuery.of(context).size.height;
    final screenwidth = MediaQuery.of(context).size.width;
    return StatefulBuilder(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {},
          child: Container(
            height: screenheight * 0.8,
            width: screenwidth,
            decoration: BoxDecoration(
              // color: Colors.black.withOpacity(0.65),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                // stops: [0.1, 0.5, 0.7, 0.9],
                colors: [
                  HexColor("#C12265").withOpacity(0.67),
                  HexColor("#000000").withOpacity(0.67),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: HexColor('#04060F'),
                  offset: Offset(10, 10),
                  blurRadius: 20,
                ),
              ],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.9),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              AssetUtils.like_icon_filled,
                              color: Colors.white,
                              scale: 2.5,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              '${widget.number_like}',
                              style: TextStyle(color: Colors.white, fontFamily: 'PM', fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  (widget.data_like_post.error == false
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: widget.data_like_post.data!.length,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2.0),
                                child: ListTile(
                                  visualDensity: VisualDensity(vertical: -2, horizontal: 2),
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Container(
                                        height: 50,
                                        width: 50,
                                        child: (widget.data_like_post.data![index].user!.image!.isNotEmpty
                                            ? Image.network(
                                                "${URLConstants.base_data_url}images/${widget.data_like_post.data![index].user!.image!}",
                                                height: 80,
                                                width: 80,
                                                fit: BoxFit.cover,
                                              )
                                            : (widget.data_like_post.data![index].user!.profileUrl!.isNotEmpty
                                                ? Image.network(
                                                    widget.data_like_post.data![index].user!.profileUrl!,
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
                                  title: Container(
                                    child: Text(widget.data_like_post.data![index].user!.fullName!,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'PR')),
                                  ),
                                  subtitle: Text(widget.data_like_post.data![index].user!.userName!,
                                      style: TextStyle(fontSize: 13, color: Colors.white, fontFamily: 'PR')),
                                  trailing: (idUser == widget.data_like_post.data![index].user!.id!
                                      ? SizedBox.shrink()
                                      : GestureDetector(
                                          onTap: () async {
                                            // print('${FollowersData[index].id}');
                                            // await _search_screen_controller
                                            //     .Follow_unfollow_api(
                                            //     follow_unfollow: (FollowersData[
                                            //     index]
                                            //         .userFollowUnfollow ==
                                            //         'unfollow'
                                            //         ? 'follow'
                                            //         : 'unfollow'),
                                            //     user_id:
                                            //     FollowersData[index].id,
                                            //     user_social:
                                            //     FollowersData[index]
                                            //         .socialType,
                                            //     context: context);
                                            // setState(() {
                                            //   getAllFollowersList();
                                            // });
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 0),
                                            height: 34,
                                            width: 90,
                                            decoration: BoxDecoration(
                                                color: HexColor(CommonColor.pinkFont),
                                                borderRadius: BorderRadius.circular(17)),
                                            child: Container(
                                                alignment: Alignment.center,
                                                margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                                                child: Text(
                                                  widget.data_like_post.data![index].status!.replaceFirst(
                                                      widget.data_like_post.data![index].status![0],
                                                      widget.data_like_post.data![index].status![0].toUpperCase()),
                                                  style: TextStyle(color: Colors.white, fontFamily: 'PR', fontSize: 14),
                                                )),
                                          ),
                                        )),
                                ),
                              );
                              //   Container(
                              //   child: Text(storyCountModel!.data![index].fullName!,
                              //       style: TextStyle(
                              //           fontSize: 16,
                              //           color: Colors.pink,
                              //           fontFamily: 'PR')),
                              // );
                            },
                          ),
                        )
                      : Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                // "No likes",
                                '${widget.data_like_post.message}',
                                textAlign: TextAlign.center,
                                style:
                                    TextStyle(fontSize: 16, color: HexColor(CommonColor.grey_light), fontFamily: 'PB'),
                              ),
                            ],
                          ),
                        )),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
//
// selectTowerBottomSheet(BuildContext context) {
//
//   showModalBottomSheet(
//     backgroundColor: Colors.black,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.only(
//         topLeft: Radius.circular(30.0),
//         topRight: Radius.circular(30.0),
//       ),
//     ),
//     isScrollControlled: true,
//     context: context,
//     builder: (BuildContext context) {
//       return StatefulBuilder(
//         builder: (context, state) {
//           return GestureDetector(
//             onTap: () {
//             },
//             child: Container(
//               height: screenheight * 0.8,
//               width: screenwidth,
//               decoration: BoxDecoration(
//                 // color: Colors.black.withOpacity(0.65),
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   // stops: [0.1, 0.5, 0.7, 0.9],
//                   colors: [
//                     HexColor("#C12265").withOpacity(0.67),
//                     HexColor("#000000").withOpacity(0.67),
//                   ],
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: HexColor('#04060F'),
//                     offset: Offset(10, 10),
//                     blurRadius: 20,
//                   ),
//                 ],
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(30.0),
//                   topRight: Radius.circular(30.0),
//                 ),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(20.9),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Expanded(
//                           flex: 2,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Image.asset(AssetUtils.like_icon_filled,color: Colors.white,scale: 2.5,),
//                               SizedBox(width: 10,),
//                               Text(
//                                 '10',
//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     fontFamily: 'PM',
//                                     fontSize: 16),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Container(
//                           alignment: Alignment.centerRight,
//                           child: Icon(
//                             Icons.close,
//                             color: Colors.white,
//                           ),
//                         )
//                       ],
//                     ),
//                     Expanded(
//                       child: ListView.builder(
//                         itemCount: 10,
//                         shrinkWrap: true,
//                         physics: ClampingScrollPhysics(),
//                         itemBuilder: (BuildContext context, int index) {
//                           return Column(
//                             children: [
//                               ListTile(
//                                 visualDensity:
//                                 VisualDensity(vertical: 0, horizontal: -4),
//                                 leading:
//                                 ClipRRect(
//                                   borderRadius: BorderRadius.circular(100),
//                                   child: Container(
//                                       height: 50,
//                                       width: 50,
//                                       child: Image.asset(
//                                         AssetUtils.image1,
//                                         height: 80,
//                                         width: 80,
//                                         fit: BoxFit.cover,
//                                       )
//                                     // (FollowersData[index]
//                                     //     .image!
//                                     //     .isNotEmpty
//                                     //     ? Image.network(
//                                     //   "${URLConstants.base_data_url}images/${FollowersData[index].image!}",
//                                     //   height: 80,
//                                     //   width: 80,
//                                     //   fit: BoxFit.cover,
//                                     // )
//                                     //     : (FollowersData[index]
//                                     //     .profileUrl!
//                                     //     .isNotEmpty
//                                     //     ? Image.network(
//                                     //   FollowersData[index]
//                                     //       .profileUrl!,
//                                     //   height: 80,
//                                     //   width: 80,
//                                     //   fit: BoxFit.cover,
//                                     // )
//                                     //     : Image.asset(
//                                     //   AssetUtils.image1,
//                                     //   height: 80,
//                                     //   width: 80,
//                                     //   fit: BoxFit.cover,
//                                     // )))
//                                   ),
//                                 ),
//                                 title: Text("Test",
//                                     style: TextStyle(
//                                         fontSize: 16,
//                                         color: Colors.white,
//                                         fontFamily: 'PR')),
//                                 trailing: GestureDetector(
//                                   onTap: () async {
//                                     // print('${FollowersData[index].id}');
//                                     // await _search_screen_controller
//                                     //     .Follow_unfollow_api(
//                                     //     follow_unfollow: (FollowersData[
//                                     //     index]
//                                     //         .userFollowUnfollow ==
//                                     //         'unfollow'
//                                     //         ? 'follow'
//                                     //         : 'unfollow'),
//                                     //     user_id:
//                                     //     FollowersData[index].id,
//                                     //     user_social:
//                                     //     FollowersData[index]
//                                     //         .socialType,
//                                     //     context: context);
//                                     // setState(() {
//                                     //   getAllFollowersList();
//                                     // });
//                                   },
//                                   child: Container(
//                                     margin: const EdgeInsets.symmetric(
//                                         horizontal: 0),
//                                     height: 34,
//                                     width: 90,
//                                     decoration: BoxDecoration(
//                                         color:
//                                         HexColor(CommonColor.pinkFont),
//                                         borderRadius:
//                                         BorderRadius.circular(17)),
//                                     child: Container(
//                                         alignment: Alignment.center,
//                                         margin: const EdgeInsets.symmetric(
//                                             vertical: 0, horizontal: 8),
//                                         child: Text(
//                                           "Follow",
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontFamily: 'PR',
//                                               fontSize: 14),
//                                         )),
//                                   ),
//                                 ),
//
//                               ),
//                               Container(
//                                 margin:
//                                 EdgeInsets.symmetric(vertical: 3),
//                                 color: HexColor(CommonColor.pinkFont)
//                                     .withOpacity(0.5),
//                                 height: 0.5,
//                                 width:
//                                 MediaQuery.of(context).size.width,
//                               ),
//                             ],
//                           );
//                           //   Container(
//                           //   child: Text(storyCountModel!.data![index].fullName!,
//                           //       style: TextStyle(
//                           //           fontSize: 16,
//                           //           color: Colors.pink,
//                           //           fontFamily: 'PR')),
//                           // );
//                         },
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       );
//     },
//   );
// }
}
