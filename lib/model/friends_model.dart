import 'package:surety/model/user_model.dart';

class FriendsModel {
  List<UserModel> friends;

  FriendsModel({required this.friends});

  factory FriendsModel.fromJson(Map<String, dynamic> json) => FriendsModel(
        friends: json['friends'] != null
            ? List<UserModel>.from(json['friends'].map((e) {
                return UserModel.fromJsonWithId(e as Map<String, dynamic>);
              }).toList())
            : [],
      );

  toJson() => {
        'friends': friends.map((e) => e.toJson()).toList(),
      };
}
