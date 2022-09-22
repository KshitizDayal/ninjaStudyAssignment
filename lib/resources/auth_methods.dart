import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//sign up user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
  }) async {
    String res = "Some error occured";

    try {
      if (email.isNotEmpty || password.isNotEmpty || username.isNotEmpty) {
        //register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email.trim(), password: password.trim());

        await cred.user!.updateDisplayName(username);

        //saving user to database
        await _firestore.collection('users').doc(cred.user!.uid).set({
          "name": username.trim(),
          "email": email.trim(),
          "uid": _auth.currentUser!.uid,
        });
        res = "success";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'weak-password') {
        res = "the password should be 6 chararcters long";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //loging in user
  Future<String> logInUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occured";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "please enter all the fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
