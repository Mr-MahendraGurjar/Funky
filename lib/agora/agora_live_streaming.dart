import 'package:agora_rtc_engine/agora_rtc_engine.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:funky_new/shared/constats.dart';
import 'package:funky_new/shared/shared_widgets.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../Utils/App_utils.dart';
import '../chat_with_firebase/chat_screen/firebase_chat_screen.dart';
import '../chat_with_firebase/chat_screen/firebase_services.dart';
import '../homepage/model/UserInfoModel.dart';
import '../shared/network/cache_helper.dart';

class AgoraService {
  static const String appId = agoraAppId;
  late final RtcEngine _engine;
  final Set<int> remoteUids = {};

  Future<void> initialize() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: agoraAppId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));
    await _engine.setChannelProfile(ChannelProfileType.channelProfileLiveBroadcasting);
    await _engine.enableVideo();
    await _engine.startPreview();

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {},
        onUserJoined: (connection, uid, elapsed) {
          debugPrint("remote user $uid joined");

          remoteUids.add(uid);
        },
        onUserOffline: (connection, int uid, reason) {
          debugPrint("remote user $uid left channel");
          remoteUids.remove(uid);
        },
      ),
    );
  }

  Future<void> joinChannel(String token, String channelName, int uid, ClientRoleType role) async {
    await _engine.setClientRole(role: role);
    await _engine.joinChannel(
        token: token, channelId: channelName, uid: uid, options: const ChannelMediaOptions());
  }

  Future<void> leaveChannel() async {
    await _engine.leaveChannel();
    remoteUids.clear();
  }

  Future<void> dispose() async {
    await _engine.release();
    await _engine.leaveChannel();
  }

  RtcEngine get engine => _engine;
}

class LiveStreamPage extends StatefulWidget {
  const LiveStreamPage({super.key});

  @override
  _LiveStreamPageState createState() => _LiveStreamPageState();
}

class _LiveStreamPageState extends State<LiveStreamPage> {
  final messageController = TextEditingController();
  final AgoraService _agoraService = AgoraService();
  Uuid uuid = const Uuid();
  bool _isInChannel = false;
  bool _isBroadcaster = false;
  String docId = '6288ad80-65c2-11ef-884e-2d231cf8678d';

  @override
  void initState() {
    super.initState();
    _initializeAgora();
  }

  Future<void> _initializeAgora() async {
    await _agoraService.initialize();
  }

  void _joinChannel(ClientRoleType role) async {
    const token = agoraTestToken;
    const channelName = agoraTestChannelName;
    const uid = 0; // Set to 0 for Agora to assign a UID
    await _agoraService.joinChannel(token, channelName, uid, role);
    _isBroadcaster = role == ClientRoleType.clientRoleBroadcaster;
    setState(() {
      _isInChannel = true;
    });
  }

  void _leaveChannel() async {
    await _agoraService.leaveChannel();
    setState(() {
      _isInChannel = false;
      _isBroadcaster = false;
    });
    if (_isBroadcaster) {
      AgoraService().remoteUids.clear();
    }
  }

  @override
  void dispose() {
    _agoraService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            _isInChannel
                ? Stack(
                    children: [
                      if (_isBroadcaster)
                        AgoraVideoView(
                            controller: VideoViewController(
                                rtcEngine: AgoraService().engine, canvas: const VideoCanvas(uid: 0))),
                      ..._agoraService.remoteUids.map((uid) => AgoraVideoView(
                          controller: VideoViewController.remote(
                              rtcEngine: AgoraService().engine,
                              canvas: VideoCanvas(uid: uid),
                              connection: const RtcConnection(channelId: agoraTestChannelName)))),

                      // RtcLocalView.SurfaceView(),
                      // ..._agoraService.remoteUids
                      //     .map((uid) => RtcRemoteView.SurfaceView(uid: uid, channelId: agoraTestChannelName)),
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          child: IconButton(
                            onPressed: _leaveChannel,
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (docId.isNotEmpty)
                                StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseServices.getLiveChats(docId),
                                    builder: (context, snapshot) {
                                      var dataList = snapshot.data?.docs ?? [];
                                      List<LiveChatModel> chats = <LiveChatModel>[];
                                      chats = dataList
                                          .map((e) => LiveChatModel.fromMap(e.data() as Map<String, dynamic>))
                                          .toList();
                                      return SizedBox(
                                        height: 200,
                                        child: ListView.builder(
                                            padding: const EdgeInsets.all(5),
                                            itemCount: chats.length,
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) => Row(
                                                  children: [
                                                    profileWidget(chats[index].id),
                                                    const SizedBox(width: 5),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          chats[index].name,
                                                          style: const TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 16,
                                                              fontFamily: 'PR'),
                                                        ),
                                                        Text(
                                                          chats[index].message,
                                                          style: const TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 16,
                                                              fontFamily: 'PR'),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                )),
                                      );
                                    }),
                              TextFormField(
                                style: const TextStyle(
                                  decoration: TextDecoration.none,
                                  fontFamily: 'PR',
                                  color: Colors.white,
                                ),
                                controller: messageController,
                                decoration: InputDecoration(
                                    hintText: 'Enter message',
                                    hintStyle: const TextStyle(
                                      color: Colors.white60,
                                      fontFamily: 'PR',
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: Colors.white),
                                        borderRadius: BorderRadius.circular(30)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: Colors.white),
                                        borderRadius: BorderRadius.circular(30)),
                                    border: OutlineInputBorder(
                                        borderSide: const BorderSide(color: Colors.white),
                                        borderRadius: BorderRadius.circular(30)),
                                    suffixIcon: InkWell(
                                        onTap: () async {
                                          if (messageController.text.isEmpty) {
                                            showToast(msg: "can't send empty message");
                                          } else {
                                            if (docId.isEmpty) {
                                              setState(() {
                                                docId = uuid.v1();
                                                print('docId:$docId');
                                              });
                                            }

                                            LiveChatModel model = LiveChatModel(
                                              docId: docId,
                                              timeStamp: DateTime.now().toUtc().toString(),
                                              id: CacheHelper.getString(key: 'uId'),
                                              name: CacheHelper.getString(key: 'userName'),
                                              message: messageController.text,
                                            );
                                            await FirebaseServices.sendChatOnLive(model);
                                            messageController.clear();
                                          }
                                        },
                                        child: const Icon(
                                          Icons.send,
                                          color: Colors.white,
                                        ))),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                : const Center(child: Text('Join a channel to start streaming')),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Visibility(
                      visible: !_isInChannel,
                      child: ElevatedButton(
                        onPressed: () => _joinChannel(ClientRoleType.clientRoleBroadcaster),
                        child: const Text('Start Broadcasting'),
                      ),
                    ),
                    if (!_isInChannel)
                      ElevatedButton(
                        onPressed: () {
                          _joinChannel(ClientRoleType.clientRoleAudience);
                          Future.delayed(const Duration(seconds: 1), () {
                            setState(() {});
                          });
                        },
                        child: const Text('Join as Audience'),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
              radius: 18,
              backgroundImage:
                  NetworkImage('${URLConstants.base_data_url}images/${user.data?[0].image ?? ''}'));
        });
  }
}

class LiveChatModel {
  final String docId;
  final String id;
  final String name;
  final String message;
  final String timeStamp;

  LiveChatModel({
    required this.id,
    required this.name,
    required this.message,
    required this.timeStamp,
    required this.docId,
  });

  factory LiveChatModel.fromMap(Map<String, dynamic> map) => LiveChatModel(
      id: map['id'],
      name: map['name'],
      message: map['message'],
      timeStamp: map['timeStamp'] ?? "",
      docId: map['docId']);

  Map<String, dynamic> toMap() =>
      {'id': id, 'name': name, 'message': message, 'timeStamp': timeStamp, 'docId': docId};
}
