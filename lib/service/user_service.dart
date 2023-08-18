import 'dart:io';

import 'package:surety/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class UserService {
  final CollectionReference _userReference =
      FirebaseFirestore.instance.collection('Users');

  Reference ref = FirebaseStorage.instance.ref("Profile");

  Future<String> saveImage(File photoProfile) async {
    try {
      final metadata = SettableMetadata(
        customMetadata: {'picked-file-path': photoProfile.path},
      );

      String fileName =
          "${DateTime.now().millisecond}-${DateTime.now().minute}-${DateTime.now().hour}-${DateTime.now().day}-${DateTime.now().month}-profile";
      fileName += photoProfile.path.split('/').last;
      var result = await ref.child(fileName).putFile(photoProfile, metadata);
      String path = await result.ref.getDownloadURL();
      String profilePath = path;
      return profilePath;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> setUser(UserModel user) async {
    // String path = await simpanGambar(photoProfile);
    // user.photoProfile = path;

    try {
      _userReference.doc(user.id).set({
        'email': user.email,
        'fullName': user.fullName,
        'role': 0,
        'isValid': false,
        'dateOfBirth': user.dateOfBirth,
        'gender': user.gender,
        'expertise': user.expertise,
        'photoProfile': null,
      });
      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> updateProfile(UserModel user, File? photoProfile) async {
    if(photoProfile != null){
     var path = await saveImage(photoProfile);
     user.photoProfile = path;
    }
    try {
      var userById = await _userReference.doc(user.id);
      await userById.update(user.toJson());

      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> getUserById(String id) async {
    try {
      DocumentSnapshot snapshot = await _userReference.doc(id).get();

      return UserModel(
        id: id,
        email: snapshot['email'],
        fullName: snapshot['fullName'],
        password: '',
        role: snapshot['role'],
        isValid: snapshot['isValid'],
        photoProfile: snapshot['photoProfile'],
        dateOfBirth: snapshot['dateOfBirth'],
        gender: snapshot['gender'],
        expertise: snapshot['expertise'],
      );
    } catch (e) {
      debugPrint("=====ERROR getUserById ====> $e");
      rethrow;
    }
  }
}
