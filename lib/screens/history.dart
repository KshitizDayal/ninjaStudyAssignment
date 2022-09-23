import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:ninja_study/resources/firebase_methods.dart';

import 'chat_screen.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List chatData = [];
  var chat;

  @override
  void initState() {
    super.initState();
    chatList();
  }

  bool isLoading = true;

  void chatList() async {
    chatData = await FireBaseMethods()
        .showChats(userId: FirebaseAuth.instance.currentUser!.uid);
    setState(() {
      isLoading = false;
    });
  }

  void sendtochatscreen(String randomid, String userid, String chatid) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ChatScreen(
            randomid: randomid,
            userid: userid,
            chatid: chatid,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : chatData.isNotEmpty
              ? ListView.builder(
                  itemCount: chatData.length,
                  itemBuilder: (context, i) {
                    var name1 = chatData[i]['ChatStarted'];
                    var name2 = chatData[i]['ChatReceived'];

                    return InkWell(
                      onTap: (() {
                        sendtochatscreen(chatData[i]['randomid'],
                            chatData[i]['userid'], chatData[i]['chatid']);
                      }),
                      child: Card(
                        child: ListTile(
                          title: Text(
                            '$name1 started chat with $name2',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    );
                  })
              : const Center(
                  child: Text(
                    "no history to show",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                  ),
                ),
    );
  }
}
