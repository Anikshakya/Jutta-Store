import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jutta_ghar/main.dart';

class GoogleSignInProvieder extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  Future googleLogin(context) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;
      _user = googleUser;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      //sends name phone passoword and email to firestore
      await FirebaseFirestore.instance.collection("users").doc(user.email).set(
        {
          'email': user.email.toLowerCase(),
          'name': user.displayName,
          'contact': "",
          'role': 'user',
          'admin_role': 'user'
        },
      ).then((value) => Navigator.pop(context));
      Get.snackbar("Irasshaimase", "Successfully Logged In",
          duration: const Duration(seconds: 2));
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.toString(),
          duration: const Duration(seconds: 2),
          backgroundColor: const Color.fromARGB(176, 255, 82, 82));
    }

    notifyListeners();
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  Future googleLogout() async {
    await googleSignIn.disconnect();
  }
}
