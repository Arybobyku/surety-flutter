import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:surety/model/user_model.dart';

import 'user_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserModel> signUp(UserModel user) async {
    try {
      //NOTE: Create User to Firebase
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );
      user.id = userCredential.user!.uid;

      //NOTE: Insert to User Model
      //NOTE: Register To FireStore
      var userService = await UserService().setUser(user);

      await _auth.currentUser?.sendEmailVerification();
      _auth.signOut();

      user = userService;
      return user;
    } catch (e) {
      throw e.toString().split(RegExp(r'\[|\]')).last;
    }
  }

  //NOTE: Function to Sign Out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> changePassword(String password) async {
    try {
      await _auth.currentUser?.updatePassword(password);
    } catch (e) {
      rethrow;
    }
  }

  //NOTE: Function to Sign in
  Future<UserModel> signIn(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      UserModel user =
          await UserService().getUserById(userCredential.user!.uid);

      print("USER ALLOW ${user.email} => ${user.allow}");

      if(user.expertise != null && user.allow == false){
        return throw ("Please ask admin for verification account");
      }
      else if (user.expertise == null &&(user.role == 0 && _auth.currentUser != null && !_auth.currentUser!.emailVerified)) {
        return throw ("Please Verified Your Email");
      }
      return user;
    } catch (e) {
      debugPrint("=====ERROR SignIN ====> $e");
      throw e.toString().split(RegExp(r'\[|\]')).last;
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();

    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);
    return await FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential);
  }
}
