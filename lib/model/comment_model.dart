import 'package:surety/model/user_model.dart';

class CommentModel {
  UserModel? userModel;
  String? description;
  String? createAt;

  CommentModel({
    this.userModel,
    this.description,
    this.createAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        description: json['description'],
        createAt: json['createAt'],
        userModel: json['userModel'] != null
            ? UserModel.fromJsonWithId(json['userModel'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'description': description,
        'createAt': createAt,
        'userModel': userModel!.toJson(),
      };
}
