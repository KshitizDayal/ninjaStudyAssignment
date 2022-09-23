import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ninja_study/resources/calling_function.dart';
import 'package:ninja_study/resources/firebase_methods.dart';
import 'package:ninja_study/screens/chat_screen.dart';
import 'package:uuid/uuid.dart';

class RandomTalk extends StatefulWidget {
  const RandomTalk({super.key});

  @override
  State<RandomTalk> createState() => _RandomTalkState();
}

class _RandomTalkState extends State<RandomTalk> {
  bool isLoading = false;

  String randomid = "";

  // @override
  // void initState() {
  //   super.initState();
  //   randomUser();
  // }

  void randomUser() async {
    setState(() {
      isLoading = true;
    });
    randomid = await CallingFunction().randomUserId();
    var chatid = const Uuid().v4();

    String randomUsername = await FireBaseMethods().getName(randomid);
    String name =
        await FireBaseMethods().getName(FirebaseAuth.instance.currentUser!.uid);

    await FireBaseMethods().createdata(
      name: name,
      randomUsername: randomUsername,
      chatid: chatid,
      randomid: randomid,
      userid: FirebaseAuth.instance.currentUser!.uid,
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ChatScreen(
            randomid: randomid,
            userid: FirebaseAuth.instance.currentUser!.uid,
            chatid: chatid,
          );
        },
      ),
    );
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.mic, size: 50),
                    onPressed: randomUser,
                    label: const Text('connect me with a random person'),
                  ),
                ],
              ),
            ),
          );
  }
}
