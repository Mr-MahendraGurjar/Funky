import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../chat_screen/models/group_model.dart';
import '../select_user.dart';

class EnterChatNameScreen extends StatefulWidget {
  const EnterChatNameScreen({super.key});

  @override
  State<EnterChatNameScreen> createState() => _EnterChatNameScreenState();
}

class _EnterChatNameScreenState extends State<EnterChatNameScreen> {
  final _fromKye = GlobalKey<FormState>();
  final groupNameController = TextEditingController();
  final groupInfoController = TextEditingController();
  String selectedImage = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: SingleChildScrollView(
          child: Form(
            key: _fromKye,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                    padding: EdgeInsets.only(top: 28),
                    child: Text('Group Name',
                        style: TextStyle(
                            fontFamily: 'PR',
                            fontSize: 16,
                            color: Colors.white60))),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  child: TextFormField(
                    controller: groupNameController,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Please enter group name';
                      }
                      return null;
                    },
                    onChanged: (chatName) {
                      //bloc?.events?.add(ChangedChatNameEvent(chatName));
                    },
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'PM',
                      color: Colors.black,
                    ),
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      suffixIcon: Icon(Icons.group),
                      contentPadding:
                          EdgeInsets.only(left: 20, top: 14, bottom: 14),
                      filled: true,
                      hintText: 'Enter group name',
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.transparent, width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      hintStyle: TextStyle(
                        fontSize: 16,
                        fontFamily: 'PR',
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                const Padding(
                    padding: EdgeInsets.only(top: 28),
                    child: Text('Short info about group',
                        style: TextStyle(
                            fontFamily: 'PR',
                            fontSize: 16,
                            color: Colors.white60))),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: groupInfoController,
                  onChanged: (chatName) {
                    //bloc?.events?.add(ChangedChatNameEvent(chatName));
                  },
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'PM',
                    color: Colors.black,
                  ),
                  maxLines: 5,
                  decoration: const InputDecoration(
                    fillColor: Colors.white,
                    contentPadding:
                        EdgeInsets.only(left: 20, top: 14, bottom: 14),
                    filled: true,
                    hintText: 'Short info about group',
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    hintStyle: TextStyle(
                      fontSize: 16,
                      fontFamily: 'PR',
                      color: Colors.grey,
                    ),
                  ),
                ),
                const Padding(
                    padding: EdgeInsets.only(top: 28),
                    child: Text('Add group photo',
                        style: TextStyle(
                            fontFamily: 'PR',
                            fontSize: 16,
                            color: Colors.white60))),
                const SizedBox(height: 20),
                Center(
                  child: GestureDetector(
                    onTap: onAddImage,
                    child: Container(
                      height: 120,
                      width: 120,
                      padding: EdgeInsets.all(selectedImage.isEmpty ? 40 : 0),
                      decoration: BoxDecoration(
                          image: selectedImage.isEmpty
                              ? null
                              : DecorationImage(
                                  image: FileImage(File(selectedImage))),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white)),
                      child: selectedImage.isEmpty
                          ? const Icon(
                              Icons.add_a_photo_rounded,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(40),
                        backgroundColor: Colors.pink),
                    onPressed: () {
                      if (!_fromKye.currentState!.validate()) {
                        return;
                      } else {
                        Get.to(() => SelectUsersScreen(
                              group: Group(
                                name: groupNameController.text,
                                aboutGroup: groupInfoController.text,
                                image: selectedImage,
                              ),
                            ));
                      }
                    },
                    child: const Text(
                      'Add Member',
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: const Color(0xff000000),
      title: const Text("Create Group",
          style:
              TextStyle(fontFamily: 'PM', fontSize: 18, color: Colors.white)),
      leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          }),
      actions: const <Widget>[
        // TextButton(
        //   onPressed: () {},
        //   child: const Text(
        //     'Finish',
        //     style: TextStyle(color: Colors.white, fontSize: 17),
        //   ),
        // )
      ],
    );
  }

  void _navigateToChatScreen(String dialogId) {}
  onAddImage() async {
    ImagePicker picker = ImagePicker();

    XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = pickedFile.path;
      });
    }
  }
}
