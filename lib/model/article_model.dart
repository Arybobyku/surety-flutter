import 'package:surety/model/user_model.dart';

class ArticleModel {
  String? id;
  String? creator;
  String? title;
  String? description;
  String? createdAt;
  String? picture;
  String? link;
  UserModel? userModel;

  ArticleModel({
    this.id,
    this.creator,
    this.title,
    this.description,
    this.createdAt,
    this.picture,
    this.userModel,
    this.link,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json, id) => ArticleModel(
        id: id,
        creator: json['creator'],
        title: json['title'],
        description: json['description'],
        createdAt: json['createdAt'],
        picture: json['picture'],
        link: json['link'],
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
        'link': link,
        'userModel': userModel!.toJson(),
      };
}
