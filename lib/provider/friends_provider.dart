import 'package:flutter/cupertino.dart';
import 'package:surety/model/friends_model.dart';
import 'package:surety/model/user_model.dart';
import 'package:surety/service/admin_service.dart';
import 'package:surety/service/friends_service.dart';

class FriendsProvider extends ChangeNotifier {
  AdminService _adminService = AdminService();
  FriendsService _friendsService = FriendsService();
  List<UserModel> listUser = [];
  FriendsModel myFriends = FriendsModel(
    friends: [],
  );

  Future<void> getAllUser(UserModel user) async {
    try {
      listUser = [];
      var result = await _adminService.getAllUsers();
      var friendsResult = await _friendsService.getFormById(user.id!);

      print("Friends Length ${friendsResult?.friends.length}");
      if (friendsResult != null) {
        myFriends = friendsResult;
      }
      listUser = result;
      listUser.removeWhere((element) => element.id == user.id);
      notifyListeners();

    } catch (e) {
      print(e);
    }
  }

  Future addFriends(UserModel userModel, UserModel me) async {
    try{
      myFriends.friends.add(userModel);
      notifyListeners();
      var result = await _friendsService.update(myFriends, me);
    }catch(e){
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
