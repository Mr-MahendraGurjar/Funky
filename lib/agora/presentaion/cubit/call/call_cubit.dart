import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quiver/async.dart';

import '../../../../data/api/call_api.dart';
import '../../../../data/models/call_model.dart';
import '../../../../shared/constats.dart';
import '../home/home_cubit.dart';
import 'call_state.dart';

class CallCubit extends Cubit<CallState> {
  CallCubit() : super(CallInitial());

  static CallCubit get(context) => BlocProvider.of(context);

  //Agora video room

  int? remoteUid;
  RtcEngine? engine;

  Future<void> initAgoraAndJoinChannel(
      {required String channelToken,
      required String channelName,
      required bool isCaller,
      required bool isVideoCall}) async {
    //create the engine
    engine = createAgoraRtcEngine();
    await engine?.initialize(const RtcEngineContext(
      appId: agoraAppId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    //engine!.setLogFilter(LogFilter.Debug);
    isVideoCall ? await engine!.enableVideo() : await engine!.enableAudio();
    await engine!.startPreview();
    engine!.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess:(connection, elapsed) {
        } ,
        onUserJoined:(connection, uid, elapsed) {
          debugPrint("remote user $uid joined");
          remoteUid = uid;
          emit(AgoraRemoteUserJoinedEvent());
        },
        onUserOffline:(connection, int uid, reason) {
          debugPrint("remote user $uid left channel");
          remoteUid = null;
          emit(AgoraUserLeftEvent());
        },
      ),
    );
    //await setClientRole();
    //join channel
    await engine!.joinChannel(token: agoraTestToken, channelId: channelName, uid: 0,options: ChannelMediaOptions());
    if (isCaller) {
      emit(AgoraInitForSenderSuccessState());
      playContactingRing(isCaller: true);
    } else {
      emit(AgoraInitForReceiverSuccessState());
    }
    debugPrint('channelTokenIs $channelToken channelNameIs $channelName');
  }

  Future<void> setClientRole() async {
    await engine!.setClientRole( role: ClientRoleType.clientRoleBroadcaster,);
  }

  //Sender
  AudioPlayer assetsAudioPlayer = AudioPlayer();

  Future<void> playContactingRing({required bool isCaller}) async {
    String audioAsset = "assets/sounds/ringlong.mp3";
    ByteData bytes = await rootBundle.load(audioAsset);
    Uint8List soundBytes =
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
    await assetsAudioPlayer.play(BytesSource(soundBytes));
    if (isCaller) {
      startCountdownCallTimer();
    }
  }

  int current = 0;
  late CountdownTimer countDownTimer;
  void startCountdownCallTimer() {
    countDownTimer = CountdownTimer(
      const Duration(seconds: callDurationInSec),
      const Duration(seconds: 1),
    );
    var sub = countDownTimer.listen(null);
    sub.onData((duration) {
      current = callDurationInSec - duration.elapsed.inSeconds;
      debugPrint("DownCount: $current");
    });

    sub.onDone(() {
      debugPrint("CallTimeDone");
      sub.cancel();
      emit(DownCountCallTimerFinishState());
    });
  }

  bool muted = false;
  Widget muteIcon = const Icon(
    Icons.keyboard_voice_rounded,
    color: Colors.black,
  );

  Future<void> toggleMuted() async {
    muted = !muted;
    muteIcon = muted
        ? const Icon(
            Icons.mic_off_rounded,
            color: Colors.black,
          )
        : const Icon(
            Icons.keyboard_voice_rounded,
            color: Colors.black,
          );
    await engine!.muteLocalAudioStream(muted);
    emit(AgoraToggleMutedState());
  }

  Future<void> switchCamera() async {
    await engine!.switchCamera();
    emit(AgoraSwitchCameraState());
  }

  //Update Call Status
  final _callApi = CallApi();
  void updateCallStatusToUnAnswered({required String callId}) {
    emit(LoadingUnAnsweredVideoChatState());
    _callApi
        .updateCallStatus(callId: callId, status: CallStatus.unAnswer.name)
        .then((value) {
      emit(SuccessUnAnsweredVideoChatState());
    }).catchError((onError) {
      emit(ErrorUnAnsweredVideoChatState(onError.toString()));
    });
  }

  Future<void> updateCallStatusToCancel({required String callId}) async {
    await _callApi.updateCallStatus(
        callId: callId, status: CallStatus.cancel.name);
  }

  Future<void> updateCallStatusToReject({required String callId}) async {
    await _callApi.updateCallStatus(
        callId: callId, status: CallStatus.reject.name);
  }

  Future<void> updateCallStatusToAccept({required CallModel callModel}) async {
    await rePermission();
    print('Token${callModel.token}');
    print('Token${callModel.channelName}');

    await initAgoraAndJoinChannel(
      channelToken: agoraTestToken,
      // callModel.token ?? "",
      channelName: callModel.channelName ?? '',
      isCaller: false,
      isVideoCall: callModel.isVideoCall ?? false,
    );
    await _callApi.updateCallStatus(
        callId: callModel.id, status: CallStatus.accept.name);
    // emit(CallAcceptState());
  }

  Future<void> updateCallStatusToEnd({required String callId}) async {
    await _callApi.updateCallStatus(
        callId: callId, status: CallStatus.end.name);
  }

  Future<void> endCurrentCall({required String callId}) async {
    await _callApi.endCurrentCall(callId: callId);
  }

  Future<void> updateUserBusyStatusFirestore(
      {required CallModel callModel}) async {
    await _callApi.updateUserBusyStatusFirestore(
        callModel: callModel, busy: false);
  }

  Future<void> performEndCall({required CallModel callModel}) async {
    await endCurrentCall(callId: callModel.id);
    await updateUserBusyStatusFirestore(callModel: callModel);
  }

  StreamSubscription? callStatusStreamSubscription;
  void listenToCallStatus(
      {required CallModel callModel,
      required BuildContext context,
      required bool isReceiver}) {
    var homeCubit = HomeCubit.get(context);
    callStatusStreamSubscription =
        _callApi.listenToCallStatus(callId: callModel.id);
    callStatusStreamSubscription!.onData((data) {
      if (data.exists) {
        String status = data.data()!['status'];
        if (status == CallStatus.accept.name) {
          homeCubit.currentCallStatus = CallStatus.accept;
          debugPrint('acceptStatus');
          emit(CallAcceptState());
        }
        if (status == CallStatus.reject.name) {
          homeCubit.currentCallStatus = CallStatus.reject;
          debugPrint('rejectStatus');
          callStatusStreamSubscription!.cancel();
          emit(CallRejectState());
        }
        if (status == CallStatus.unAnswer.name) {
          homeCubit.currentCallStatus = CallStatus.unAnswer;
          debugPrint('unAnswerStatusHere');
          callStatusStreamSubscription!.cancel();
          emit(CallNoAnswerState());
        }
        if (status == CallStatus.cancel.name) {
          homeCubit.currentCallStatus = CallStatus.cancel;
          debugPrint('cancelStatus');
          callStatusStreamSubscription!.cancel();
          emit(CallCancelState());
        }
        if (status == CallStatus.end.name) {
          homeCubit.currentCallStatus = CallStatus.end;
          debugPrint('endStatus');
          callStatusStreamSubscription!.cancel();
          emit(CallEndState());
        }
      }
    });
  }

  Future<void> rePermission() async {
    // Ensure necessary permissions are granted
    await [Permission.microphone, Permission.camera].request();
  }
}
