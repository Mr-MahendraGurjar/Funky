import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:funky_new/chat_with_firebase/chat_screen/firebase_services.dart';
import 'package:funky_new/chat_with_firebase/chat_screen/models/group_model.dart';
import 'package:funky_new/chat_with_firebase/group_chat/group_chat.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../enter_chat_name/enter_chat_name.dart';

class GroupPage extends StatelessWidget {
  const GroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor('#641637'),
        title: const Text(
          'Group',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(
              onPressed: () {
                Get.to(() => const EnterChatNameScreen());
              },
              icon: const Icon(Icons.add)),
        ],
      ),
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
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseServices.getGroup(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(kDebugMode
                      ? snapshot.error.toString()
                      : 'Something went wrong'),
                );
              }
              var dataList = snapshot.data?.docs ?? [];
              List<Group> groupList = <Group>[];
              groupList = dataList
                  .map((e) =>
                      Group.fromMap(e.data() as Map<String, dynamic>, e.id))
                  .toList();
              return ListView.builder(
                itemCount: groupList.length,
                itemBuilder: (context, index) => ListTile(
                  onTap: () {
                    Get.to(() => GroupChat(
                          groupId: groupList[index].id ?? '',
                        ));
                  },
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      groupList[index].image ?? '',
                    ),
                  ),
                  title: Text(
                    groupList[index].name ?? '',
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    groupList[index].aboutGroup ?? '',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
