// ignore_for_file: sdk_version_since

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../sharePreference.dart';
import '../firebase_services.dart';
import '../models/chat_model.dart';
import '../models/translation_model.dart';

class ChatController extends GetxController {
  TextEditingController messageOneController = TextEditingController();

  TextEditingController messageController = TextEditingController();

  ScrollController listScrollController = ScrollController();

  Rx<ChatModel> chatModelObj = ChatModel().obs;

  RxInt timerCount = 0.obs;

  var isStop = false.obs;

  var isVoiceCancel = false.obs;

  var isRecording = RxBool(false);

  var isRecordingOn = RxBool(false);

  var userName = ''.obs;

  var emojiShowing = false.obs;

  List<TranslationModel> translationList = <TranslationModel>[].obs;

// implement scroll
  scrollDown() {
    if (listScrollController.hasClients) {
      final position = listScrollController.position.minScrollExtent;
      listScrollController.jumpTo(position);
    }
  }

  void senMessage(String receiverId) async {
    if (messageController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Cant't send empty message");
    } else {
      ChatModel chat = ChatModel(
        roomId: FirebaseServices.createChatRoomId(receiverId),
        message: messageController.text.trim(),
        senderId: PreferenceManager().getId(),
        receiverId: receiverId,
        timestamp: DateTime.now().toString(),
        type: MessageType.Text.name,
        linkCount: 0,
        isSeen: false,
      );
      await FirebaseServices.sendMessage(chat: chat);
      scrollDown();
      // FirebaseServices.sendChatNotification(
      //     type: NotificationType.Chat.name,
      //     id: receiverId,
      //     message: messageController.text.trim());
      messageController.clear();
    }
  }

  sendVoiceMessage(
      {required String receiverId,
      required String path,
      required timerValue}) async {
    ChatModel chat = ChatModel(
      roomId: FirebaseServices.createChatRoomId(receiverId),
      senderId: PreferenceManager().getId(),
      receiverId: receiverId,
      timestamp: DateTime.now().toString(),
      type: MessageType.Voice.name,
      url: '',
      voiceDuration: timerValue,
      isSeen: false,
    );
    await FirebaseServices.sendVoiceChat(chat: chat, path: path);
    scrollDown();
  }

  // Function to stop the timer
  void stopTimer() {
    isStop.value = true;
    timerCount.value = 0;
  }

  // Function to start the timer
  void startTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isStop.value) {
        timer.cancel();
        isStop.value = false;
      } else {
        timerCount.value++;
      }
    });
  }

  // Function to format the timer count as "mm:ss"
  String formatTime() {
    int minutes = timerCount.value ~/ 60;
    int seconds = timerCount.value % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  var textTries = 0.obs;
  var isRequested = false.obs;

  @override
  void onClose() {
    super.onClose();
    messageOneController.dispose();
    messageController.dispose();
  }

  
}

enum MessageType { Text, Voice, Media, Video, Travel }
