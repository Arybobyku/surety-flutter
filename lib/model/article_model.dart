import 'package:surety/model/user_model.dart';

class ArticleModel {
  String? id;
  String? creator;
  String? title;
  String? description;
  String? createdAt;
  String? picture;
  UserModel? userModel;

  ArticleModel({
    this.id,
    this.creator,
    this.title,
    this.description,
    this.createdAt,
    this.picture,
    this.userModel,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json, id) => ArticleModel(
        id: id,
        creator: json['creator'],
        title: json['title'],
        description: json['description'],
        createdAt: json['createdAt'],
        picture: json['picture'],
        userModel: json['userModel'] != null
            ? UserModel.fromJsonWithId(json['userModel'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'creator': creator,
        'title': title,
        'description': description,
        'createdAt': createdAt,
        'picture': picture,
        'userModel': userModel!.toJson(),
      };
}
