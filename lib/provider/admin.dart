import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:surety/model/user_model.dart';
import 'package:surety/service/admin_service.dart';

class AdminProvider extends ChangeNotifier {
  AdminService _adminService = AdminService();
  List<UserModel> listUser = [];
  late UserModel selectedUser;

  Future<Either<String, List<UserModel>>> getAllUser() async {
    try {
      listUser = [];
      var result = await _adminService.getAllUsers();
      listUser = result;
      notifyListeners();
      return right(result);
    } catch (e) {
      return left(e.toString());
    }
  }

  selectDetailAnggota(UserModel userModel) {
    selectedUser = userModel;
    notifyListeners();
  }
}
