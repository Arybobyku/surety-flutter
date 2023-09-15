import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:surety/model/user_model.dart';

class ExpertService {
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
}