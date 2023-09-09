import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:surety/model/friends_model.dart';
import 'package:surety/model/user_model.dart';

class FriendsService {
  final CollectionReference _friendsReference =
      FirebaseFirestore.instance.collection('Friends');

  Future<FriendsModel> update(FriendsModel friends, UserModel user) async {
    try {
      var result = await _friendsReference.doc(user.id);
      await result.set(friends.toJson());
      return friends;
    } catch (e) {
      rethrow;
    }
  }

  Future<FriendsModel?> getFormById(String id) async {
    try {
      DocumentSnapshot snapshot = await _friendsReference.doc(id).get();
      final form = snapshot.data() != null
          ? FriendsModel.fromJson(snapshot.data() as Map<String, dynamic>)
          : null;

      return form;
    } catch (e) {
      rethrow;
    }
  }
}
