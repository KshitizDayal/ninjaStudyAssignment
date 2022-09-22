import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ninja_study/api/speech_api.dart';
import 'package:ninja_study/resources/firebase_methods.dart';
import 'package:ninja_study/utility/utils.dart';
import 'package:ninja_study/widgets/message_display.dart';

import 'package:avatar_glow/avatar_glow.dart';

class ChatScreen extends StatefulWidget {
  final String chatid;
  final String randomid;
  final String userid;
  const ChatScreen({
    required this.randomid,
    required this.userid,
    required this.chatid,
    super.key,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String text = "Send your VoiceChat";
  bool isListening = false;
  String randomUsername = "";
  String username = "";
  bool isMe = false;

  TextEditingController controller = TextEditingController();

  bool isLoading = true;
  bool sameuser = false;

  @override
  void initState() {
    super.initState();
    getName();
    getsendid();
  }

  void getName() async {
    randomUsername = await FireBaseMethods().getName(widget.randomid);
    username = await FireBaseMethods().getName(widget.userid);
    setState(() {
      isLoading = false;
    });
  }

  void sendChat() async {
    bool istrue = (FirebaseAuth.instance.currentUser!.uid == widget.randomid);

    await FireBaseMethods().sendMessage(
      userid: istrue ? widget.randomid : widget.userid,
      randomid: istrue ? widget.userid : widget.randomid,
      text: text,
      name: username,
      randomUsername: randomUsername,
      chatid: widget.chatid,
    );
    setState(() {
      text = "other person's turn";
      sameuser = true;
    });
  }

  void cantmsg() {
    showSnackBar("The other person needs to send the message", context);
  }

  void getsendid() async {
    String qwerty = await FireBaseMethods()
        .getSendId(userid: widget.userid, chatid: widget.chatid);

    if (qwerty == FirebaseAuth.instance.currentUser!.uid) {
      setState(() {
        sameuser = true;
      });
    }
    print(qwerty);
  }

  Future toggleRecording() => SpeechApi.toggleRecording(
        onResult: (text) => setState(() => this.text = text),
        onListening: (isListening) {
          setState(() => this.isListening = isListening);
        },
      );
  String lastuid = "";

  @override
  Widget build(BuildContext context) {
    print(isMe);
    return Scaffold(
      appBar: AppBar(
        title: Text('$username started chat with $randomUsername'),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.62,
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(widget.userid)
                    .collection("chats")
                    .doc(widget.chatid)
                    .collection("chatting")
                    .orderBy("time", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        reverse: true,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> chatMap =
                              snapshot.data!.docs[index].data()
                                  as Map<String, dynamic>;

                          return MessageDisplay(chatMap: chatMap);
                        });
                  }
                  return SizedBox();
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * .08,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        text,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: sendChat,
                    icon: Icon(Icons.send),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: AvatarGlow(
        animate: isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75.0,
        repeat: true,
        child: sameuser
            ? FloatingActionButton(
                onPressed: cantmsg,
                child: const Icon(
                  Icons.mic_off,
                ),
              )
            : FloatingActionButton(
                onPressed: toggleRecording,
                child: Icon(
                  isListening ? Icons.mic : Icons.mic_none,
                ),
              ),
      ),
    );
  }
}
