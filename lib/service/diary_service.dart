import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:surety/model/diary_model.dart';

class DiaryService {
  final CollectionReference _diariesReference =
      FirebaseFirestore.instance.collection('Diary');

  Reference ref = FirebaseStorage.instance.ref("Diary");

  Future<String> saveImage(File image) async {
    try {
      final metadata = SettableMetadata(
        customMetadata: {'picked-file-path': image.path},
      );

      String fileName =
          "${DateTime.now().millisecond}-${DateTime.now().minute}-${DateTime.now().hour}-${DateTime.now().day}-${DateTime.now().month}-profile";
      fileName += image.path.split('/').last;
      var result = await ref.child(fileName).putFile(image, metadata);
      String path = await result.ref.getDownloadURL();
      String profilePath = path;
      return profilePath;
    } catch (e) {
      rethrow;
    }
  }

  Future<DiaryModel> createDiary(DiaryModel diary, File? image) async {
    String? path = image != null ? await saveImage(image) : null;
    diary.image = path;

    try {
      String docId = _diariesReference.doc().id;
      diary.id = docId;
      _diariesReference.doc(docId).set(diary.toJson());
      return diary;
    } catch (e) {
      rethrow;
    }
  }
  
  Future<void> updateDiary(DiaryModel diary)async{
    try{
      await _diariesReference.doc(diary.id).update(diary.toJson());
    }catch(e){
      rethrow;
    }
  }

  Future<List<DiaryModel>> getDiaryByCreator(String id) async {
    try {
      QuerySnapshot result =
          await _diariesReference.where("creator", isEqualTo: id).get();
      List<DiaryModel> diaries = result.docs.map((e) {
        return DiaryModel.fromJson(e.data() as Map<String, dynamic>, e.id);
      }).toList();
      return diaries;
    } catch (e) {
      rethrow;
    }
  }


  Future<List<DiaryModel>> getAllDiaries() async {
    try {
      QuerySnapshot result = await _diariesReference.where('isPublic',isEqualTo:true).get();
      List<DiaryModel> diaries = result.docs.map((e) {
        return DiaryModel.fromJson(e.data() as Map<String, dynamic>, e.id);
      }).toList();
      print(diaries.length);
      return diaries;
    } catch (e) {
      rethrow;
    }
  }

  Future<DiaryModel> update(File? image, DiaryModel diaryModel) async {
    try {
      final filePath =
      image != null ? await saveImage(image) : diaryModel.image;

      diaryModel.image = filePath;
      var result = await _diariesReference.doc(diaryModel.id);
      ;
      await result.set(diaryModel.toJson());

      return diaryModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> remove(String id) async {
    try {
      await _diariesReference.doc(id).delete();
    } catch (e) {
      rethrow;
    }
  }
}
