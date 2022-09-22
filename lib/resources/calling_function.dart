import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_methods.dart';

class CallingFunction {
  Future<String> randomUserId() async {
    String random = "";
    String randomuid = "";

    random = await FireBaseMethods().getRandomUid();
    if (random == FirebaseAuth.instance.currentUser!.uid) {
      randomuid = await FireBaseMethods().getRandomUid();
    } else {
      randomuid = random;
    }

    return randomuid;
  }
}
