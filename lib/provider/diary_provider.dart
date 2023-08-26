import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:fpdart/fpdart.dart';
import 'package:surety/model/comment_model.dart';
import 'package:surety/model/diary_model.dart';
import 'package:surety/model/user_model.dart';
import 'package:surety/service/diary_service.dart';

class DiaryProvider extends ChangeNotifier {
  DiaryService _diaryService = DiaryService();
  DiaryModel formDiary = DiaryModel();
  List<DiaryModel> diaries = [];
  List<DiaryModel> diariesByCreator = [];
  bool loading = true;
  late DiaryModel detail;

  Future<Either<String, bool>> createDiary(
      DiaryModel diary, File? image) async {
    try {
      diary.createdAt = DateTime.now();
      diary.creator = diary.userModel!.id;
      diary.isExpert = diary.userModel?.expertise == null ? false : true;
      final result = await _diaryService.createDiary(diary, image);
      diary.likes = [];
      diaries.add(result);
      diariesByCreator.add(result);
      notifyListeners();
      return right(true);
    } catch (e) {
      return left(e.toString());
    }
  }

  void likeDiary(
      DiaryModel diary, UserModel userModel, bool isCreatorPage) async {
    try {
      diary.likes?.add(userModel);

      await _diaryService.updateDiary(diary);

      if (isCreatorPage) {
        diariesByCreator[diariesByCreator
            .indexWhere((element) => element.id == diary.id)] = diary;
      } else {
        diaries[diaries.indexWhere((element) => element.id == diary.id)] =
            diary;
      }
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }

  void addComment(DiaryModel diary, CommentModel commentModel) async {
    try {
      diary.comments!.add(commentModel);
      await _diaryService.updateDiary(diary);

      if (diariesByCreator
          .where((element) => element.id == diary.id)
          .isNotEmpty) {
        diariesByCreator[diariesByCreator
            .indexWhere((element) => element.id == diary.id)] = diary;
      }
      if (diaries.where((element) => element.id == diary.id).isNotEmpty) {
        diaries[diaries.indexWhere((element) => element.id == diary.id)] =
            diary;
      }
      notifyListeners();
    } catch (e) {
      print("ERROR COMMENTS" + e.toString());
    }
  }

  void unLikeDiary(
      DiaryModel diary, UserModel userModel, bool isCreatorPage) async {
    try {
      diary.likes?.removeWhere((element) => element.email == userModel.email);

      await _diaryService.updateDiary(diary);
      if (isCreatorPage) {
        diariesByCreator[diariesByCreator
            .indexWhere((element) => element.id == diary.id)] = diary;
      } else {
        diaries[diaries.indexWhere((element) => element.id == diary.id)] =
            diary;
      }
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }

  void getAllDiaryByCreator(String id) async {
    try {
      loading = true;
      final result = await _diaryService.getDiaryByCreator(id);
      diariesByCreator = result;
      loading = false;

      notifyListeners();
    } catch (e) {

      print("DIARY BY CREATOR $e");
      print(e.toString());
    }
  }

  void getAllDiaries() async {
    try {
      loading = true;
      final result = await _diaryService.getAllDiaries();
      diaries = result;
      loading = false;
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }

  void remove(String id) async {
    try {
      loading = true;
      await _diaryService.remove(id);
      diariesByCreator.removeWhere((element) => element.id == id);
      notifyListeners();
      loading = false;
    } catch (e) {
      print(e.toString());
    }
  }

  void viewDetail(DiaryModel diary) {
    detail = diary;
    notifyListeners();
  }
}
