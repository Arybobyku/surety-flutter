import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:surety/model/friends_model.dart';
import 'package:surety/model/user_model.dart';
import 'package:surety/service/admin_service.dart';
import 'package:surety/service/friends_service.dart';

class FriendsProvider extends ChangeNotifier {
  AdminService _adminService = AdminService();
  FriendsService _friendsService = FriendsService();
  List<UserModel> listUser = [];
  List<UserModel> listExpert = [];
  FriendsModel myFriends = FriendsModel(
    friends: [],
  );

  Future<void> getAllUser(UserModel user) async {
    try {
      listUser = [];
      listExpert = [];

      var result = await _adminService.getAllUsers();
      var friendsResult = await _friendsService.getFormById(user.id!);

      if (friendsResult != null) {
        myFriends = friendsResult;
      }
      listUser = result;
      listExpert = result;

      listUser.removeWhere((element) => element.id == user.id ||  element.expertise != null);
      listUser.removeWhere((element) => myFriends.friends.firstWhereOrNull((friends)=> friends.id == element.id) != null);

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future addFriends(UserModel userModel, UserModel me) async {
    try {
      myFriends.friends.add(userModel);
      listUser.removeWhere((element) => element.id == userModel.id);
      notifyListeners();
      var result = await _friendsService.update(myFriends, me);
    } catch (e) {
      print("ERROR ADD FRIENDS $e");
    }
  }

  Future removeFriends(UserModel userModel, UserModel me) async {
    myFriends.friends.removeWhere((element) =>
        element.id == userModel.id && userModel.fullName == element.fullName);
    await _friendsService.update(myFriends, me);
    notifyListeners();
  }
}
