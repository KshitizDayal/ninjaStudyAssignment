import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:uuid/uuid.dart';

class FireBaseMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> getRandomUid() async {
    List userList = [];
    var randomUser;

    try {
      await _firestore.collection('users').get().then((value) {
        userList = value.docs;
      });
      randomUser = (userList.toList()..shuffle()).first;
    } catch (e) {
      print(e.toString());
    }

    return randomUser['uid'];
  }

  Future<String> getName(String uid) async {
    String name = "";
    var userList = [];
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .get()
          .then((value) => name = value['name']);
    } catch (e) {
      print(e.toString());
    }

    return name;
  }

  Future<void> createdata({
    required String name,
    required String randomUsername,
    required String chatid,
    required String randomid,
    required String userid,
  }) async {
    await _firestore
        .collection("users")
        .doc(userid)
        .collection("chats")
        .doc(chatid)
        .set({
      "ChatStarted": name,
      "ChatReceived": randomUsername,
      "chatid": chatid,
      "userid": userid,
      "randomid": randomid,
    });

    await _firestore
        .collection("users")
        .doc(randomid)
        .collection("chats")
        .doc(chatid)
        .set({
      "ChatStarted": name,
      "ChatReceived": randomUsername,
      "chatid": chatid,
      "userid": userid,
      "randomid": randomid,
    });
  }

  Future<void> sendMessage({
    required String randomid,
    required String userid,
    required String text,
    required String name,
    required String randomUsername,
    required String chatid,
  }) async {
    var msgid = const Uuid().v1();
    var time = DateTime.now();

    Map<String, dynamic> chatData = {
      "sendby": userid,
      "receivedby": randomid,
      "message": text,
      "time": time,
      "msgid": msgid,
    };

    await _firestore
        .collection("users")
        .doc(userid)
        .collection("chats")
        .doc(chatid)
        .collection("chatting")
        .doc(msgid)
        .set(chatData);

    await _firestore
        .collection("users")
        .doc(randomid)
        .collection("chats")
        .doc(chatid)
        .collection("chatting")
        .doc(msgid)
        .set(chatData);
  }

  Future<List> showChats({required String userId}) async {
    var chatlist;
    var snapshots = await _firestore
        .collection("users")
        .doc(userId)
        .collection("chats")
        .get()
        .then((value) => chatlist = value.docs.toList());

    return chatlist;
  }

  Future<String> getSendId({
    required userid,
    required chatid,
  }) async {
    String sendid = "";
    await _firestore
        .collection("users")
        .doc(userid)
        .collection("chats")
        .doc(chatid)
        .collection("chatting")
        .orderBy("time")
        .get()
        .then((value) => sendid = value.docs.last['sendby']);

    return sendid;
  }
}
