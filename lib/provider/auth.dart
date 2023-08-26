import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:surety/helper/constants.dart';
import 'package:surety/local_storage_service.dart';
import 'package:surety/model/user_model.dart';
import 'package:surety/service/auth_service.dart';
import 'package:surety/service/user_service.dart';

import '../setup_locator.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  late UserModel user;
  var storageService = locator<LocalStorageService>();

  Future<Either<String, bool>> doSignIn(
      {required String email, required String password}) async {
    try {
      user = await _authService.signIn(email: email, password: password);
      storageService.saveToPref(Constants.role, user.role);
      storageService.saveToPref(Constants.userModel, jsonEncode(user.toJson()));
      return right(true);
    } catch (e) {
      return left(e.toString());
    }
  }

  Future doSignInWithGoogle() async {
    try {
      final userCredential = await _authService.signInWithGoogle();
      user = UserModel(
        fullName: userCredential.user?.displayName ?? "-",
        photoProfile: userCredential.user?.photoURL ?? null,
        email: userCredential.user!.email!,
        password: '',
        isValid: true,
      );
      storageService.saveToPref(Constants.role, 0);
      storageService.saveToPref(Constants.userModel, jsonEncode(user.toJson()));
      return right(true);
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, bool>> doSignUp({
    required UserModel user,
    // required File photoProfile,
  }) async {
    try {
      user = await _authService.signUp(user);
      this.user = user;
      //
      // storageService.saveToPref(Constants.role, user.role);
      // storageService.saveToPref(Constants.userModel, jsonEncode(user.toJson()));
      notifyListeners();
      return right(true);
    } catch (e) {
      return left(e.toString());
    }
  }

  setUserModelFromPref(UserModel user) {
    this.user = user;
    notifyListeners();
  }

  Future<Either<String, bool>> doUpdateProfile(UserModel userModel, File? photoProfile) async {
    try {
       user = await _userService.updateProfile(userModel, photoProfile);

      notifyListeners();
      return right(true);
    } catch (e) {
      return left(e.toString());
    }
  }

  Future doResetPassword(String email) async {
    try {
      await _authService.resetPassword(email);
      return right(true);
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, bool>> doSignOut() async {
    try {
      await _authService.signOut();
      storageService.clearPref();
      return right(true);
    } catch (e) {
      return left(e.toString());
    }
  }
}
