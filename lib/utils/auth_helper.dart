import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class AuthHelper {
  final FirebaseAuth auth = FirebaseAuth.instance;

  User? get user => auth.currentUser;

  Stream<User?> get userStream => auth.authStateChanges();

  //SIGN OUT METHOD
  Future signOut() async {
    await auth.signOut();
    log('sign-out');
  }
}
