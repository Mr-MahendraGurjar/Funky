import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../Utils/App_utils.dart';
import '../custom_widget/page_loader.dart';
import '../homepage/model/UserInfoModel.dart';
import '../shared/network/cache_helper.dart';
import 'chat_screen/controller/chat_controller.dart';
import 'chat_screen/firebase_chat_screen.dart';
import 'chat_screen/firebase_services.dart';
import 'chat_screen/models/chat_model.dart';

class ArchivedUserChatPage extends StatelessWidget {
  ArchivedUserChatPage({super.key});
  final controller = Get.put(FirebaseChatController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
              leadingWidth: 30,
              actions: [
                Obx(() => controller.selectedChatList.isNotEmpty
                    ? Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: const Text(
                                              'Are you sure want to delete chat ?'),
                                          actions: [
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.pink),
                                                onPressed: () {
                                                  controller.selectedChatList
                                                      .clear();
                                                  Get.back();
                                                },
                                                child: const Text('Cancel',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.white,
                                                        fontFamily: 'PM'))),
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.pink),
                                                onPressed: () async {
                                                  showLoader(context);
                                                  for (var id in controller
                                                      .selectedChatList) {
                                                    await FirebaseServices
                                                        .deleteChats(id);
                                                  }
                                                  controller.selectedChatList
                                                      .clear();
                                                  hideLoader(context);
                                                  Get.back();
                                                },
                                                child: const Text('Ok',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.white,
                                                        fontFamily: 'PM')))
                                          ],
                                        ));
                              },
                              icon: const Icon(Icons.delete)),
                          IconButton(
                              onPressed: () async {
                                await FirebaseServices.removeFromArchived(
                                    controller.selectedChatList);
                                controller.selectedChatList.clear();
                              },
                              icon: const Icon(Icons.unarchive)),
                        ],
                      )
                    : const SizedBox.shrink()),
              ],
              backgroundColor: HexColor('#641637'),
              title: const Text(
                'Chat',
                style: TextStyle(
                    fontSize: 16, color: Colors.white, fontFamily: 'PM'),
              ))),
      body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                HexColor("#330417"),
                HexColor("#000000"),
                HexColor("#000000"),
                HexColor("#000000"),
              ],
            ),
          ),
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseServices.getChatCollection(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: SizedBox.shrink(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(kDebugMode
                            ? snapshot.error.toString()
                            : 'Something went wrong'),
                      );
                    }

                    List<String> userIds = <String>[];
                    Set<String> userIdsSet = <String>{};

                    userIds.clear();
                    var dataList = snapshot.data?.docs ?? [];
                    // dataList.sort(
                    //     (a, b) => b.!.compareTo(a.chatTimeStamp!));
                    for (var data in dataList) {
                      List<String> ids = data.id.split("_");
                      ids.remove(CacheHelper.getString(key: 'uId'));
                      userIdsSet.addAll(ids);
                    }
                    userIds.addAll(userIdsSet.toList());
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: userIds.length,
                      itemBuilder: (context, index) =>
                          FutureBuilder<UserInfoModel?>(
                        future: controller.CreatorgetUserInfo_Email(
                            UserId: userIds[index]),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(child: SizedBox.shrink());
                          } else if (snapshot.hasError) {
                            return Text(snapshot.error.toString());
                          }
                          UserInfoModel user = snapshot.data ?? UserInfoModel();
                          return StreamBuilder<QuerySnapshot>(
                              stream: FirebaseServices.getLastChats(
                                user.data?[0].id ?? "",
                              ),
                              builder: (context, chatSnapshot) {
                                if (chatSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const SizedBox.shrink();
                                }
                                var data = chatSnapshot.data?.docs ?? [];
                                List<ChatModel> chats = <ChatModel>[];
                                chats.clear();
                                chats = data
                                    .map((e) => ChatModel.fromJson(
                                        e.data() as Map<String, dynamic>, e.id))
                                    .toList();
                                return StreamBuilder<DocumentSnapshot>(
                                    stream: FirebaseServices.getArchivedChats(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const SizedBox.shrink();
                                      }
                                      List archivedUsers =
                                          snapshot.data?.get('user_ids') ?? [];
                                      return Visibility(
                                        visible: (user.data != null &&
                                            archivedUsers
                                                .contains(user.data?[0].id)),
                                        child: Obx(
                                          () => Container(
                                            color: controller.selectedChatList
                                                    .contains(
                                                        user.data?[0].id ?? "")
                                                ? Colors.pink
                                                : null,
                                            child: ListTile(
                                              onLongPress: () {
                                                controller.selectedChatList.add(
                                                    user.data?[0].id ?? "");
                                              },
                                              onTap: () {
                                                Get.to(() => FirebaseChatScreen(
                                                      receiverId:
                                                          user.data?[0].id ??
                                                              "",
                                                    ));
                                              },
                                              leading: CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    '${URLConstants.base_data_url}images/${user.data?[0].image ?? ''}'),
                                              ),
                                              title: Text(
                                                user.data?[0].fullName ?? '',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontFamily: 'PM',
                                                ),
                                              ),
                                              subtitle: Text(
                                                chats.isEmpty
                                                    ? ''
                                                    : lastMessages(chats),
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                              trailing: Text(
                                                messageCount(chats) == 0
                                                    ? ''
                                                    : messageCount(chats)
                                                        .toString(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontFamily: 'PM',
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              });
                        },
                      ),
                    );
                  }),
            ],
          )),
    );
  }

  int messageCount(List<ChatModel> chats) {
    int count = 0;
    if (chats.isNotEmpty) {
      for (var chat in chats) {
        if (!chat.isSeen! &&
            chat.receiverId == CacheHelper.getString(key: 'uId')) {
          count++;
        }
      }
    }
    return count;
  }

  String lastMessages(List<ChatModel> chats) {
    if (chats.isEmpty) {
      return '';
    } else if (chats[0].type == MessageType.Voice.name) {
      return '🎵 ${chats[0].type}';
    } else if (chats[0].type == MessageType.Media.name) {
      return '📂 ${chats[0].type}';
    } else if (chats[0].type == MessageType.Video.name) {
      return '🎥 ${chats[0].type}';
    } else if (chats[0].type == MessageType.Text.name) {
      return '${chats[0].message}';
    } else if (chats[0].type == MessageType.Travel.name) {
      return '🛫 Travel Plan';
    } else {
      return '';
    }
  }
}
