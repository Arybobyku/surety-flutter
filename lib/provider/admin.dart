import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:surety/model/user_model.dart';
import 'package:surety/service/admin_service.dart';

class AdminProvider extends ChangeNotifier {
  AdminService _adminService = AdminService();
  List<UserModel> listExperts = [];
  late UserModel selectedUser;

  Future<Either<String, List<UserModel>>> getExperts() async {
    try {
      listExperts = [];
      var result = await _adminService.getAllExperts();
      listExperts = result;
      notifyListeners();
      return right(result);
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<void> allowExpert(UserModel user) async {
    user.allow = true;
    await _adminService.update(user);
    listExperts[listExperts.indexWhere((element) => element.id == user.id)] =
        user;
    notifyListeners();
  }

  Future<void> disAllowExpert(UserModel user) async {
    user.allow = true;
    await _adminService.update(user);
    listExperts[listExperts.indexWhere((element) => element.id == user.id)] =
        user;
    notifyListeners();
  }
}
