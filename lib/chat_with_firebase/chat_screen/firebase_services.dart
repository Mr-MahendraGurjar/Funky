// ignore_for_file: sdk_version_since

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:funky_new/shared/network/cache_helper.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uuid/uuid.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../agora/agora_live_streaming.dart';
import '../../shared/constats.dart';
import '../media_services.dart';
import 'controller/chat_controller.dart';
import 'models/chat_model.dart';
import 'models/group_model.dart';

class FirebaseServices {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final GoogleSignIn googleSignIn = GoogleSignIn();

/*-----------Create User With Email and Password-----------*/
  static Future<bool> signUpWithEmail(
      {required String email, required String password}) async {
    return _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((userCredential) {
      if (userCredential.user != null) {
        Fluttertoast.showToast(msg: 'Success');
        return true;
      }
      return false;
    }).onError((error, stackTrace) {
      if (error is FirebaseAuthException) {
        Fluttertoast.showToast(msg: error.code);
      } else {
        log('Error During SignUp with Email And Password', error: error);
      }
      return false;
    });
  }

  static Future<String> uploadFile(
      {required String filePath, required String contentType}) async {
    try {
      String base64Data = base64Encode(File(filePath).readAsBytesSync());
      String fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${filePath.split('/').last}';
      print('fileName:==>$fileName');
      // Create a reference to the location you want to upload to in Firebase Storage
      Reference ref = _storage.ref().child('uploads/$fileName');

      // Set metadata (content type)
      SettableMetadata metadata = SettableMetadata(contentType: contentType);
      // Upload file to Firebase Storage
      UploadTask uploadTask = ref.putData(base64.decode(base64Data), metadata);

      // Await the upload to get the task snapshot
      TaskSnapshot taskSnapshot = await uploadTask;

      // Get the download URL
      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      return downloadURL;
    } catch (e) {
      log('Error uploading file:', error: e);
      return '';
    }
  }
  /*-------Send Chat Message--------*/

  static Future<bool> sendMessage({
    required ChatModel chat,
  }) async {
    try {
      var chatRef = _firestore.collection('chats').doc(chat.roomId);
      chatRef.set({'timestamp': FieldValue.serverTimestamp()});
      chatRef.collection('messages').add(chat.toJson());
      return true;
    } catch (e) {
      log('Error during send message', error: e);
      return false;
    }
  }

/*---------Get Chat Collection--------------*/
  static getChatCollection() {
    try {
      return _firestore
          .collection('chats')
          .orderBy('timestamp', descending: false)
          .snapshots();
    } catch (e) {
      log('Error during get chats', error: e);
      rethrow;
    }
  }

/*-----Update Chat------*/
  static updateChat({required String senderId, required docId}) {
    _firestore
        .collection('chats')
        .doc(createChatRoomId(senderId))
        .collection('messages')
        .doc(docId)
        .update({"isSeen": true});
  }

/*---------Get Chats--------------*/
  static getChats(String receiverId) {
    try {
      return _firestore
          .collection('chats')
          .doc(createChatRoomId(receiverId))
          .collection('messages')
          .orderBy('timestamp', descending: false)
          .snapshots();
    } catch (e) {
      log('Error during get chats', error: e);
      rethrow;
    }
  }

/*-----Media Chat------*/
  static Future<bool> sendMediaChat(String receiverId) async {
    try {
      Media? media = await MediaServices.pickFilePathAndExtension();
      if (media != null) {
        String roomId = FirebaseServices.createChatRoomId(receiverId);
        String docId = const Uuid().v4();
        final chat = ChatModel(
          roomId: roomId,
          isSeen: false,
          receiverId: receiverId,
          senderId: CacheHelper.getString(key: 'uId'),
          message: '',
          timestamp: DateTime.now().toString(),
          type: MessageType.Media.name,
          url: '',
          fileName: media.name,
          fileExtension: media.fileExtension,
          linkCount: 0,
          userIdsOfUsersForStarredMessage: [],
          userIdsOfUsersForDeletedMessage: [],
        );
        var chatRef = _firestore.collection('chats').doc(roomId);
        chatRef.set({'timestamp': FieldValue.serverTimestamp()});
        chatRef.collection('messages').doc(docId).set(chat.toJson());
        if (media.fileExtension == ".mp4") {
          String url =
              await uploadFile(filePath: media.path, contentType: '.mp4');
          chatRef.collection('messages').doc(docId).update({'url': url});
          String? thumbnailUrl = await generateAndUploadThumbnail(url);
          chatRef
              .collection('messages')
              .doc(docId)
              .update({'thumbnailUrl': thumbnailUrl});
        }
        //send Push Notification
        // FirebaseServices.sendChatNotification(
        //     type: NotificationType.Chat.name,
        //     id: receiverId,
        //     message: '📂 Media');
        String url = await uploadFile(
            filePath: media.path, contentType: media.fileExtension);
        chatRef.collection('messages').doc(docId).update({'url': url});
        return true;
      }
      return false;
    } catch (e) {
      log('Error during sendMedia:', error: e);
      return false;
    }
  }

/*---------generate Thumbnail--------------*/
  static Future<String?> generateAndUploadThumbnail(String videoUrl) async {
    Uint8List? thumbnailData;
    try {
      thumbnailData = await VideoThumbnail.thumbnailData(
        video: videoUrl,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 200, // Adjust the thumbnail width as needed
        quality: 25, // Adjust the thumbnail quality as needed
      );
    } catch (e) {
      print('Error generating thumbnail: $e');
      return null; // Return null in case of an error
    }

    if (thumbnailData != null) {
      // Initialize Firebase Storage
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference storageRef =
          storage.ref().child('thumbnails').child('thumbnail.jpg');

      try {
        // Upload thumbnail to Firebase Storage
        TaskSnapshot uploadTask = await storageRef.putData(thumbnailData);

        // Get download URL for the uploaded thumbnail
        String downloadUrl = await uploadTask.ref.getDownloadURL();
        return downloadUrl;
      } catch (e) {
        print('Error uploading thumbnail to Firebase Storage: $e');
        return null; // Return null in case of an error
      }
    } else {
      return null; // Return null if thumbnail data is null
    }
  }

/*---------Delete Chats--------------*/
  static deleteChats(String receiverId) async {
    try {
      // Get a reference to the collection
      CollectionReference collectionReference = _firestore
          .collection('chats')
          .doc(createChatRoomId(receiverId))
          .collection('messages');
      // Get all documents from the collection
      QuerySnapshot querySnapshot = await collectionReference.get();
      // Delete each document in the collection
      querySnapshot.docs.forEach((document) async {
        await document.reference.delete();
      });
      await _firestore
          .collection('chats')
          .doc(createChatRoomId(receiverId))
          .delete();
    } catch (e) {
      log('Error during delete chats', error: e);
    }
  }

/*---------Get Last Chats--------------*/
  static getLastChats(String receiverId) {
    try {
      return _firestore
          .collection('chats')
          .doc(createChatRoomId(receiverId))
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots();
    } catch (e) {
      log('Error during get chats', error: e);
    }
  }

  /*-----Voice Message------*/
  static Future<bool> sendVoiceChat(
      {required ChatModel chat, required String path}) async {
    try {
      // Media? media = await MediaServices.pickFilePathAndExtension();
      //if (media != null) {
      String roomId = FirebaseServices.createChatRoomId(chat.receiverId ?? "");
      String docId = const Uuid().v4();

      var chatRef = _firestore.collection('chats').doc(roomId);
      chatRef.set({'timestamp': FieldValue.serverTimestamp()});
      chatRef.collection('messages').doc(docId).set(chat.toJson());
      //send Push Notification
      // FirebaseServices.sendChatNotification(
      //     type: NotificationType.Chat.name,
      //     id: chat.receiverId ?? '',
      //     message: '🎤 Voice Message');
      String url = await uploadFile(filePath: path, contentType: '.mp3');
      chatRef.collection('messages').doc(docId).update({'url': url});
      return true;
    } catch (e) {
      log('Error during voice chat:', error: e);
      return false;
    }
  }

  /*-------- generate unique chat id for one to one user -----*/
  static String createChatRoomId(String receiverId) {
    List<String> userIds = [CacheHelper.getString(key: 'uId'), receiverId];
    userIds.sort(); // Sort the user IDs to ensure consistency
    return userIds.join('_');
  }

  static getUserStatus(String uId) {
    return _firestore.collection(userCollection).doc(uId).snapshots();
  }

  static Future<void> sendChatOnLive(LiveChatModel model) async {
    await _firestore
        .collection('liveChat')
        .doc(model.docId)
        .collection('chats')
        .add(model.toMap());
  }

  static getLiveChats(String docId) {
    return _firestore
        .collection('liveChat')
        .doc(docId)
        .collection('chats')
        .orderBy('timeStamp')
        .snapshots();
  }

  static createGroup(Group group) async {
    try {
      await _firestore.collection('group').add(group.toMap());
    } catch (e) {
      log('Error During Create Group', error: e);
    }
  }

  static getGroup() {
    return _firestore
        .collection('group')
        .where('members', arrayContains: CacheHelper.getString(key: 'uId'))
        .snapshots();
  }

  static getGroupById(String groupId) {
    return _firestore.collection('group').doc(groupId).snapshots();
  }

  /*---------Get group Chats--------------*/
  static getGroupChats(String groupId) {
    try {
      return _firestore
          .collection('chats')
          .doc(groupId)
          .collection('messages')
          .orderBy('timestamp', descending: false)
          .snapshots();
    } catch (e) {
      log('Error during get chats', error: e);
      rethrow;
    }
  }

  /*-----Media Chat To group------*/
  static Future<bool> sendMediaChatToGroup(String groupId) async {
    try {
      Media? media = await MediaServices.pickFilePathAndExtension();
      if (media != null) {
        String docId = const Uuid().v4();
        final chat = ChatModel(
          roomId: groupId,
          isSeen: false,
          receiverId: groupId,
          senderId: CacheHelper.getString(key: 'uId'),
          message: '',
          timestamp: DateTime.now().toString(),
          type: MessageType.Media.name,
          url: '',
          fileName: media.name,
          fileExtension: media.fileExtension,
          linkCount: 0,
          userIdsOfUsersForStarredMessage: [],
          userIdsOfUsersForDeletedMessage: [],
        );
        var chatRef = _firestore.collection('chats').doc(groupId);
        chatRef.set({'timestamp': FieldValue.serverTimestamp()});
        chatRef.collection('messages').doc(docId).set(chat.toJson());
        if (media.fileExtension == ".mp4") {
          String url =
              await uploadFile(filePath: media.path, contentType: '.mp4');
          chatRef.collection('messages').doc(docId).update({'url': url});
          String? thumbnailUrl = await generateAndUploadThumbnail(url);
          chatRef
              .collection('messages')
              .doc(docId)
              .update({'thumbnailUrl': thumbnailUrl});
        }
        //send Push Notification
        // FirebaseServices.sendChatNotification(
        //     type: NotificationType.Chat.name,
        //     id: receiverId,
        //     message: '📂 Media');
        String url = await uploadFile(
            filePath: media.path, contentType: media.fileExtension);
        chatRef.collection('messages').doc(docId).update({'url': url});
        return true;
      }
      return false;
    } catch (e) {
      log('Error during sendMedia:', error: e);
      return false;
    }
  }

  static addToArchived(List otherUserIds) async {
    _firestore
        .collection('archived_chats')
        .doc(CacheHelper.getString(key: 'uId'))
        .set({'user_ids': FieldValue.arrayUnion(otherUserIds)});
  }

  static removeFromArchived(List otherUserIds) async {
    _firestore
        .collection('archived_chats')
        .doc(CacheHelper.getString(key: 'uId'))
        .set({'user_ids': FieldValue.arrayRemove(otherUserIds)});
  }

  static getArchivedChats() {
    return _firestore
        .collection('archived_chats')
        .doc(CacheHelper.getString(key: 'uId'))
        .snapshots();
  }
}
