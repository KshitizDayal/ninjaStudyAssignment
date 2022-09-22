import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageDisplay extends StatelessWidget {
  final Map<String, dynamic> chatMap;

  const MessageDisplay({required this.chatMap, super.key});

  @override
  Widget build(BuildContext context) {
    bool isMe = chatMap['sendby'] == FirebaseAuth.instance.currentUser!.uid;
    const circleRadius = Radius.circular(12);
    const zerocircleRadius = Radius.circular(0);

    return Container(
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              // color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: circleRadius,
                topRight: circleRadius,
                bottomLeft: !isMe ? zerocircleRadius : circleRadius,
                bottomRight: isMe ? zerocircleRadius : circleRadius,
              ),
            ),
            width: 250,
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 16,
            ),
            margin: const EdgeInsets.symmetric(
              vertical: 7,
              horizontal: 8,
            ),
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  chatMap['message'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isMe ? Colors.black : Colors.purpleAccent,
                  ),
                  textAlign: isMe ? TextAlign.end : TextAlign.start,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
