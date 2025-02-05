import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:funky_new/agora/presentaion/cubit/home/home_state.dart';
import 'package:funky_new/chat_with_firebase/chat_screen/controller/chat_controller.dart';
import 'package:funky_new/chat_with_firebase/chat_screen/firebase_services.dart';
import 'package:funky_new/chat_with_firebase/chat_screen/models/chat_model.dart';
import 'package:funky_new/chat_with_firebase/chat_screen/models/group_model.dart';
import 'package:funky_new/shared/network/cache_helper.dart';
import 'package:funky_new/shared/shared_widgets.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../../Utils/App_utils.dart';
import '../../Utils/colorUtils.dart';
import '../../Utils/toaster_widget.dart';
import '../../agora/presentaion/cubit/call/call_cubit.dart';
import '../../agora/presentaion/cubit/home/home_cubit.dart';
import '../../agora/presentaion/screens/call_screen.dart';
import '../../chat/constants/constants.dart';
import '../../chat/pages/full_video_page.dart';
import '../../chat/pages/pages.dart';
import '../../data/models/call_model.dart';
import '../../homepage/model/UserInfoModel.dart';
import '../../services/fcm/firebase_messaging_service.dart';
import '../../sharePreference.dart';
import '../../shared/constats.dart';
import '../chat_screen/firebase_chat_screen.dart';

class GroupChat extends StatelessWidget {
  final String groupId;
  GroupChat({super.key, required this.groupId});
  final TextEditingController _inputController = TextEditingController();
  // final controller = Get.put(FirebaseChatController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
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
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: BlocConsumer<HomeCubit, HomeState>(
                listener: (context, state) {
                  //GetUserData States
                  if (state is ErrorGetUsersState) {
                    showToast(msg: state.message);
                  }
                  if (state is ErrorGetCallHistoryState) {
                    showToast(msg: state.message);
                  }
                  //FireCall States
                  if (state is ErrorFireVideoCallState) {
                    showToast(msg: state.message);
                  }
                  if (state is ErrorPostCallToFirestoreState) {
                    showToast(msg: state.message);
                  }
                  if (state is ErrorUpdateUserBusyStatus) {
                    showToast(msg: state.message);
                  }
                  if (state is SuccessFireVideoCallState) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => CallCubit(),
                        child: CallScreen(
                            isReceiver: false, callModel: state.callModel),
                      ),
                    ));
                  }

                  //Receiver Call States
                  if (state is SuccessInComingCallState) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => CallCubit(),
                        child: CallScreen(
                            isReceiver: true, callModel: state.callModel),
                      ),
                    ));
                  }
                },
                builder: (context, state) {
                  return StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseServices.getGroupById(groupId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox.shrink();
                        }
                        Group group = Group.fromMap(
                            snapshot.data?.data() as Map<String, dynamic>,
                            snapshot.data?.id ?? '');
                        return AppBar(
                          leadingWidth: 30,
                          backgroundColor: HexColor('#641637'),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(width: 10),
                              CircleAvatar(
                                backgroundImage:
                                    NetworkImage(group.image ?? ''),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    group.name ?? '',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontFamily: 'PM'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          actions: [
                            InkWell(
                                onTap: () {
                                  makeCall(isVideoCall: false);
                                },
                                child: const Icon(Icons.call)),
                            const SizedBox(width: 20),
                            InkWell(
                                onTap: () async {
                                  makeCall(isVideoCall: true);
                                },
                                child: const Icon(Icons.video_call)),
                            const SizedBox(width: 20)
                          ],
                        );
                      });
                },
              )),
          bottomSheet: _buildEnterMessageRow(context),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                // stops: [0.1, 0.5, 0.7, 0.9],
                colors: [
                  HexColor("##330417"),
                  HexColor("#000000"),
                ],
              ),
            ),
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseServices.getGroupChats(groupId),
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

                  List<ChatModel> chats = <ChatModel>[];
                  chats.clear();
                  var data = snapshot.data?.docs ?? [];
                  chats = data
                      .map((e) => ChatModel.fromJson(
                          e.data() as Map<String, dynamic>, e.id))
                      .toList();

                  if (chats.isEmpty) {
                    return const Center(
                        child: Text(
                      "No message here yet...",
                      style: TextStyle(
                          color: Colors.white, fontFamily: 'PM', fontSize: 16),
                    ));
                  } else {
                    return ListView.builder(
                        padding: const EdgeInsets.only(
                            bottom: 50, right: 10, top: 10),
                        shrinkWrap: true,
                        itemCount: chats.length,
                        itemBuilder: (context, index) =>
                            buildItem(chats[index]));
                  }
                }),
          ),
        ),
      ],
    );
  }

  bool isOnline(String savedTimestamp) {
    DateTime savedDateTime = DateTime.parse(savedTimestamp);
    DateTime currentDateTime = DateTime.now();
    int differenceInSeconds =
        currentDateTime.difference(savedDateTime).inSeconds;
    bool isWithinOneMinute = differenceInSeconds < 120;
    return isWithinOneMinute;
  }

  void makeCall({required bool isVideoCall}) async {
    final String userName =
        await PreferenceManager().getPref(URLConstants.userName);
    HomeCubit.get(Get.context!).fireVideoCall(
        callModel: CallModel(
      id: 'call_${UniqueKey().hashCode.toString()}',
      channelName: agoraTestChannelName,
      callerId: CacheHelper.getString(key: 'uId'),
      callerAvatar: '',
      callerName: userName,
      receiverId: groupId,
      receiverAvatar: '',
      receiverName: '',
      // controller.userInfoModel_email.value.data?[0].fullName ?? '',
      status: CallStatus.ringing.name,
      createAt: DateTime.now().millisecondsSinceEpoch,
      current: true,
      isVideoCall: isVideoCall,
    ));
  }

  Widget _buildEnterMessageRow(context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //! _buildTypingIndicator(),
          Container(
            decoration: BoxDecoration(
                color: Colors.black,
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  // stops: [0.1, 0.5, 0.7, 0.9],
                  colors: [
                    HexColor("#000000"),
                    HexColor("#000000"),
                    HexColor("#E84F90"),
                    HexColor("#FFFFFF"),
                  ],
                ),
                border: Border.all(color: Colors.white, width: 1),
                borderRadius: BorderRadius.circular(33)),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 50,
                  height: 50,
                  child: IconButton(
                      icon: SvgPicture.asset(
                        'assets/icons/attachment.svg',
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        await FirebaseServices.sendMediaChatToGroup(groupId);
                      }),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(top: 2, bottom: 2),
                    child: TextField(
                      controller: _inputController,
                      onChanged: (text) {
                        // TypingStatusManager.typing((TypingStates state) {
                        //   switch (state) {
                        //     case TypingStates.start:
                        //       bloc?.events?.add(StartTypingEvent());
                        //       break;
                        //     case TypingStates.stop:
                        //       bloc?.events?.add(StopTypingEvent());
                        //       break;
                        //   }
                        // });
                      },
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 4,
                      style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.white,
                          fontFamily: 'PR'),
                      decoration: const InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                          hintStyle: TextStyle(
                              color: Colors.white60, fontFamily: 'POPR'),
                          hintText: "Send message..."),
                    ),
                  ),
                ),
                SizedBox(
                  width: 50,
                  height: 50,
                  child: IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: Colors.black,
                    ),
                    onPressed: () async {
                      if (_inputController.text.isEmpty) {
                        showToast(msg: "Empty message can't send");
                      } else {
                        // Send Message
                        ChatModel chat = ChatModel(
                          message: _inputController.text.trim(),
                          timestamp: DateTime.now().toUtc().toString(),
                          type: MessageType.Text.name,
                          isSeen: false,
                          roomId: groupId,
                          senderId: CacheHelper.getString(key: 'uId'),
                          receiverId: groupId,
                        );
                        await FirebaseServices.sendMessage(chat: chat);
                        String message = _inputController.text;
                        await sendNotification(message);
                        _inputController.clear();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> sendNotification(String message) async {
    FirebaseFirestore.instance
        .collection(tokensCollection)
        .doc(groupId)
        .get()
        .then((value) async {
      await FirebaseMessagingService.sendNotification(
          token: value.data()!['token'],
          title: '',
          //'You received a message from ${controller.userInfoModel_email.value.data?[0].fullName ?? ''}',
          body: message,
          type: NotificationType.Chat.name);
    });
  }

  Widget buildItem(ChatModel chat) {
    if (chat.senderId == CacheHelper.getString(key: 'uId')) {
      // Right (my message)
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          chat.type == MessageType.Text.name

              /// Text
              ? Container(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                  constraints: BoxConstraints(
                    maxWidth: Get.width / 1.5,
                  ),
                  decoration: BoxDecoration(
                      color: HexColor('#E8E7E7'),
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                          topLeft: Radius.circular(20))),
                  margin: const EdgeInsets.only(
                    bottom: 10,
                    //isLastMessageRight(index) ? 20 : 10, right: 10
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        chat.message ?? '',
                        style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'PB',
                            fontSize: 14),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        margin:
                            const EdgeInsets.only(left: 0, top: 5, bottom: 0),
                        child: Text(
                          DateFormat('dd MMM kk:mm')
                              .format(DateTime.parse(chat.timestamp ?? "")),
                          style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 10,
                              fontFamily: 'PM',
                              fontStyle: FontStyle.italic),
                        ),
                      )
                    ],
                  ),
                )
              : (chat.type == MessageType.Media.name &&
                      isImage(chat.fileExtension ?? ''))

                  /// Image
                  ? Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: GestureDetector(
                          onTap: () {
                            print('url: ${chat.url}');
                            Navigator.push(
                              Get.context!,
                              MaterialPageRoute(
                                builder: (context) => FullPhotoPage(
                                  url: chat.url ?? '',
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                  bottomLeft: Radius.circular(8),
                                )),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                    child: Image.network(
                                      chat.url ?? "",
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return Container(
                                          decoration: const BoxDecoration(
                                            color: ColorConstants.greyColor2,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(0),
                                            ),
                                          ),
                                          width: 200,
                                          height: 200,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              color: ColorConstants.themeColor,
                                              value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                  : null,
                                            ),
                                          ),
                                        );
                                      },
                                      errorBuilder:
                                          (context, object, stackTrace) {
                                        return const SizedBox(
                                            width: 200,
                                            height: 200,
                                            child: Center(
                                                child:
                                                    CircularProgressIndicator()));
                                        // Material(
                                        //   borderRadius: const BorderRadius.all(
                                        //     Radius.circular(8),
                                        //   ),
                                        //   clipBehavior: Clip.hardEdge,
                                        //   child: Image.asset(
                                        //     'images/img_not_available.jpeg',
                                        //     width: 200,
                                        //     height: 200,
                                        //     fit: BoxFit.cover,
                                        //   ),
                                        // );
                                      },
                                      width: 200,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 0, top: 5, bottom: 0),
                                    child: Text(
                                      DateFormat('dd MMM kk:mm').format(
                                          DateTime.parse(chat.timestamp ?? "")),
                                      style: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 10,
                                          fontFamily: 'PM',
                                          fontStyle: FontStyle.italic),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )),
                    )

                  /// Sticker
                  : (chat.type == MessageType.Media.name &&
                          chat.fileExtension == '.mp4')

                      /// Video
                      ? Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                Get.context!,
                                MaterialPageRoute(
                                  builder: (context) => FullVideoPage(
                                    url: chat.url ?? '',
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                    bottomLeft: Radius.circular(8),
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8)),
                                      clipBehavior: Clip.hardEdge,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Image.network(
                                            chat.thumbnailUrl ?? "",
                                            //'assets/images/Funky_App_Icon.png',
                                            errorBuilder:
                                                (context, object, stackTrace) {
                                              return const SizedBox(
                                                  width: 200,
                                                  height: 200,
                                                  child: Center(
                                                      child:
                                                          CircularProgressIndicator()));
                                            },
                                            width: 200,
                                            height: 200,
                                            fit: BoxFit.cover,
                                          ),
                                          const Icon(
                                            Icons.play_circle_fill,
                                            color: Colors.white,
                                            size: 35,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 0, top: 5, bottom: 0),
                                      child: Text(
                                        DateFormat('dd MMM kk:mm').format(
                                            DateTime.parse(
                                                chat.timestamp ?? "")),
                                        // textAlign: TextAlign.right,
                                        style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 10,
                                            fontFamily: 'PM',
                                            fontStyle: FontStyle.italic),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : chat.type == MessageType.Media.name

                          /// file
                          ? Container(
                              width: 230,
                              margin: const EdgeInsets.only(bottom: 10),
                              child: GestureDetector(
                                onTap: () async {
                                  if (chat.url!.isNotEmpty) {
                                    downloadFileAndOpen(Get.context!,
                                        chat.url ?? '', chat.fileName ?? '');
                                  }
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        topRight: Radius.circular(8),
                                        bottomLeft: Radius.circular(8),
                                      )),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.pink.withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                chat.url!.isEmpty
                                                    ? const SizedBox(
                                                        height: 20,
                                                        width: 20,
                                                        child:
                                                            CircularProgressIndicator())
                                                    : const Icon(
                                                        Icons.insert_drive_file,
                                                        color: Colors.pink,
                                                      ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                SizedBox(
                                                  width: 130,
                                                  child: Text(
                                                    chat.fileName ?? "",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: HexColor(
                                                            CommonColor
                                                                .pinkFont),
                                                        fontSize: 14,
                                                        fontFamily: 'PR'),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 0, top: 5, bottom: 0),
                                          child: Text(
                                            DateFormat('dd MMM kk:mm').format(
                                                DateTime.parse(
                                                    chat.timestamp ?? "")),
                                            style: const TextStyle(
                                                color: Colors.black54,
                                                fontSize: 10,
                                                fontFamily: 'PM',
                                                fontStyle: FontStyle.italic),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )

                          /// Sticker
                          : Container(
                              margin: const EdgeInsets.only(
                                  bottom: 10,
                                  //isLastMessageRight(index) ? 20 : 10,
                                  right: 10),
                              child: Image.asset(
                                'assets/images/${chat.url}.gif',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
        ],
      );
    } else {
      //Left (peer message)
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // isLastMessageLeft(index)
                //     ?
                //     Container(
                //         child: ClipRRect(
                //           borderRadius: BorderRadius.circular(50),
                //           child: Image.network(
                //             widget.arguments.peerAvatar,
                //             loadingBuilder: (BuildContext context,
                //                 Widget child,
                //                 ImageChunkEvent? loadingProgress) {
                //               if (loadingProgress == null) return child;
                //               return Center(
                //                 child: CircularProgressIndicator(
                //                   color: ColorConstants.themeColor,
                //                   value: loadingProgress.expectedTotalBytes !=
                //                           null
                //                       ? loadingProgress
                //                               .cumulativeBytesLoaded /
                //                           loadingProgress.expectedTotalBytes!
                //                       : null,
                //                 ),
                //               );
                //             },
                //             errorBuilder: (context, object, stackTrace) {
                //               return const Icon(
                //                 Icons.account_circle,
                //                 size: 35,
                //                 color: ColorConstants.greyColor,
                //               );
                //             },
                //             width: 35,
                //             height: 35,
                //             fit: BoxFit.cover,
                //           ),
                //         ),
                //       )
                //     : Container(width: 35),
                const SizedBox(
                  width: 10,
                ),
                chat.type == MessageType.Text.name

                    ///text
                    ? Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              profileWidget(chat.senderId ?? ''),
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 10, 15, 10),
                                constraints: BoxConstraints(
                                  maxWidth: Get.width / 1.5,
                                ),
                                decoration: BoxDecoration(
                                    color: HexColor('#641637'),
                                    borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                        topLeft: Radius.circular(20))),
                                margin: const EdgeInsets.only(left: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      chat.message ?? "",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'PR',
                                          fontSize: 14),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    // isLastMessageLeft(index)
                                    //     ? Container(
                                    //         margin: const EdgeInsets.only(
                                    //             left: 0, top: 5, bottom: 0),
                                    //         child: Text(
                                    //           DateFormat('dd MMM kk:mm').format(
                                    //               DateTime
                                    //                   .fromMillisecondsSinceEpoch(
                                    //                       int.parse(messageChat
                                    //                           .timestamp))),
                                    //           style: const TextStyle(
                                    //               color: ColorConstants.greyColor,
                                    //               fontSize: 10,
                                    //               fontStyle: FontStyle.italic),
                                    //         ),
                                    //       )
                                    //     : const SizedBox.shrink()
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : (chat.type == MessageType.Media.name &&
                            isImage(chat.fileExtension ?? ""))

                        ///images
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  profileWidget(chat.senderId ?? ''),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        Get.context!,
                                        MaterialPageRoute(
                                          builder: (context) => FullPhotoPage(
                                              url: chat.url ?? ''),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(8),
                                            topRight: Radius.circular(8),
                                            bottomRight: Radius.circular(8),
                                          )),
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(8)),
                                              clipBehavior: Clip.hardEdge,
                                              child: Image.network(
                                                chat.url ?? "",
                                                loadingBuilder:
                                                    (BuildContext context,
                                                        Widget child,
                                                        ImageChunkEvent?
                                                            loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  }
                                                  return Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: ColorConstants
                                                          .greyColor2,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(38),
                                                      ),
                                                    ),
                                                    width: 200,
                                                    height: 200,
                                                    child: Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: ColorConstants
                                                            .themeColor,
                                                        value: loadingProgress
                                                                    .expectedTotalBytes !=
                                                                null
                                                            ? loadingProgress
                                                                    .cumulativeBytesLoaded /
                                                                loadingProgress
                                                                    .expectedTotalBytes!
                                                            : null,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                errorBuilder: (context, object,
                                                        stackTrace) =>
                                                    const SizedBox(
                                                  width: 200,
                                                  height: 200,
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                                width: 200,
                                                height: 200,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 0, top: 5, bottom: 0),
                                              child: Text(
                                                DateFormat('dd MMM kk:mm')
                                                    .format(DateTime.parse(
                                                        chat.timestamp ?? "")),
                                                style: const TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 10,
                                                    fontFamily: 'PM',
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : (chat.type == MessageType.Media.name &&
                                chat.fileExtension == '.mp4')

                            ///video
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  profileWidget(chat.senderId ?? ''),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          Get.context!,
                                          MaterialPageRoute(
                                            builder: (context) => FullVideoPage(
                                              url: chat.url ?? "",
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(8),
                                              topRight: Radius.circular(8),
                                              bottomRight: Radius.circular(8),
                                            )),
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(8)),
                                                clipBehavior: Clip.hardEdge,
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    Image.network(
                                                      chat.thumbnailUrl ?? "",
                                                      errorBuilder: (context,
                                                          object, stackTrace) {
                                                        return const SizedBox(
                                                          width: 200,
                                                          height: 200,
                                                          child: Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          ),
                                                        );
                                                      },
                                                      width: 200,
                                                      height: 200,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    const Icon(
                                                      Icons.play_circle_fill,
                                                      color: Colors.white,
                                                      size: 35,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 0, top: 5, bottom: 0),
                                                child: Text(
                                                  DateFormat('dd MMM kk:mm')
                                                      .format(DateTime.parse(
                                                          chat.timestamp ??
                                                              "")),
                                                  style: const TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 10,
                                                      fontFamily: 'PM',
                                                      fontStyle:
                                                          FontStyle.italic),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : chat.type == MessageType.Media.name

                                ///file
                                ? Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      profileWidget(chat.senderId ?? ''),
                                      Container(
                                        width: 230,
                                        margin: const EdgeInsets.only(
                                            bottom: 0, left: 10),
                                        child: GestureDetector(
                                          onTap: () async {
                                            downloadFileAndOpen(
                                                Get.context!,
                                                chat.url ?? '',
                                                chat.fileName ?? "");
                                          },
                                          child: Container(
                                            decoration: const BoxDecoration(
                                                color: Colors.pink,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(8),
                                                  topRight: Radius.circular(8),
                                                  bottomRight:
                                                      Radius.circular(8),
                                                )),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.white30,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8)),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        children: [
                                                          const Icon(
                                                            Icons
                                                                .insert_drive_file,
                                                            color: Colors.white,
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          SizedBox(
                                                            width: 130,
                                                            child: Text(
                                                              chat.fileName ??
                                                                  '',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  color: HexColor(
                                                                      '#ffffff'),
                                                                  fontSize: 14,
                                                                  fontFamily:
                                                                      'PR'),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 0,
                                                            top: 5,
                                                            bottom: 0),
                                                    child: Text(
                                                      DateFormat('dd MMM kk:mm')
                                                          .format(DateTime.parse(
                                                              chat.timestamp ??
                                                                  '')),
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10,
                                                          fontFamily: 'PM',
                                                          fontStyle:
                                                              FontStyle.italic),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                // Sticker
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                            bottom: 10,
                                            // isLastMessageRight(index)
                                            //     ? 20
                                            //: 10,
                                            right: 10),
                                        child: Image.asset(
                                          'assets/images/${chat.url}.gif',
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      // isLastMessageLeft(index)
                                      //     ? Container(
                                      //         margin: const EdgeInsets.only(
                                      //             left: 0, top: 5, bottom: 0),
                                      //         child: Text(
                                      //           DateFormat('dd MMM kk:mm')
                                      //               .format(DateTime
                                      //                   .fromMillisecondsSinceEpoch(
                                      //                       int.parse(messageChat
                                      //                           .timestamp))),
                                      //           style: const TextStyle(
                                      //               color: ColorConstants
                                      //                   .greyColor,
                                      //               fontSize: 10,
                                      //               fontStyle:
                                      //                   FontStyle.italic),
                                      //         ),
                                      //       )
                                      //     : const SizedBox.shrink()
                                    ],
                                  ),
              ],
            ),
          ],
        ),
      );
    }
  }

  Widget profileWidget(String userId) {
    final controller = Get.put(FirebaseChatController());
    return FutureBuilder(
        future: controller.CreatorgetUserInfo_Email(UserId: userId),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: SizedBox.shrink());
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          UserInfoModel user = snapshot.data ?? UserInfoModel();

          return CircleAvatar(
              backgroundImage: NetworkImage(
                  '${URLConstants.base_data_url}images/${user.data?[0].image ?? ''}'));
        });
  }

  isImage(String fileExtension) {
    List imageExtensions = ['.image', '.jpg', '.png', '.jpeg', '.gif'];
    return imageExtensions.contains(fileExtension.toLowerCase());
  }

  void downloadFileAndOpen(
      BuildContext context, String url, String fileName) async {
    var directory = await getApplicationSupportDirectory();

    String dir = directory.path;

    File file = File('$dir/$fileName');

    if (await file.exists()) {
      OpenFile.open(file.path);
    } else {
      CommonWidget().showToaster(msg: "Downloading...");

      HttpClient httpClient = HttpClient();

      try {
        var request = await httpClient.getUrl(Uri.parse(url));
        var response = await request.close();
        print(response.statusCode);
        if (response.statusCode == 200) {
          var bytes = await consolidateHttpClientResponseBytes(response);
          print(file.path);
          await file.writeAsBytes(bytes);
        }
        // Navigator.pop(context);
      } catch (ex) {
        //Navigator.pop(context);
        print(ex.toString());
        CommonWidget().showToaster(msg: ex.toString());
      } finally {
        OpenFile.open(file.path);
      }
    }
  }
}
