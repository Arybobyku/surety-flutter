import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:surety/model/user_model.dart';

import '../helper/constants.dart';

class AdminService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final CollectionReference _userReference =
      FirebaseFirestore.instance.collection('Users');

  Future<List<UserModel>> getAllExperts() async {
    try {
      QuerySnapshot result =
          await _userReference.where("expertise", isNull: false).get();
      List<UserModel> users = result.docs.map((e) {
        return UserModel.fromJson(e.data() as Map<String, dynamic>, e.id);
      }).toList();
      return users;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    try {
      QuerySnapshot result =
      await _userReference.where("role", isEqualTo: 0).get();
      List<UserModel> users = result.docs.map((e) {
        return UserModel.fromJson(e.data() as Map<String, dynamic>, e.id);
      }).toList();
      return users;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<UserModel> update(UserModel user) async {
    try {
      var result = await _userReference.doc(user.id);
      await result.set(user.toJson());
      return user;
    } catch (e) {
      rethrow;
    }
  }
}
