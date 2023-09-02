import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:surety/model/form_model.dart';

class FormService {
  final CollectionReference _formReference =
      FirebaseFirestore.instance.collection('Form');

  Future<FormModel?> getFormById(String id) async {
    try {
      DocumentSnapshot snapshot = await _formReference.doc(id).get();
      final form = snapshot.data() != null
          ? FormModel.fromJson(snapshot.data() as Map<String, dynamic>)
          : null;
      return form;
    } catch (e) {
      rethrow;
    }
  }

  Future<FormModel> update(FormModel user) async {
    try {
      var result = await _formReference.doc(user.userId);
      await result.set(user.toJson());

      return user;
    } catch (e) {
      print("ERROR UPDATE SERVICE $e");
      rethrow;
    }
  }
}
