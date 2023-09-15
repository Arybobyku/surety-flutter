import 'package:flutter/material.dart';
import 'package:surety/model/user_model.dart';
import 'package:surety/service/expert_service.dart';

class ExpertProvider extends ChangeNotifier{
  ExpertService _expertService = ExpertService();
  List<UserModel> experts = [];

  Future<void> getAllExperts()async{
    final result = await _expertService.getAllExperts();
    if(result.isNotEmpty){
      experts = result;
      experts.removeWhere((element) => element.allow == false);
    }
    notifyListeners();
  }
}