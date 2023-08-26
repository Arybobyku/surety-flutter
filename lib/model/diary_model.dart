import 'package:intl/intl.dart';
import 'package:surety/model/user_model.dart';

import 'comment_model.dart';

class DiaryModel {
  String? id;
  String? description;
  String? image;
  DateTime? createdAt;
  bool? isPublic;
  bool? isExpert;
  UserModel? userModel;
  String? creator;
  List<UserModel>? likes;
  List<CommentModel>? comments;

  DiaryModel({
    this.id,
    this.description,
    this.image,
    this.createdAt,
    this.isPublic,
    this.isExpert,
    this.userModel,
    this.likes,
    this.creator,
    this.comments,
  });

  factory DiaryModel.fromJson(Map<String, dynamic> json, id) => DiaryModel(
        id: id,
        description: json['description'],
        image: json['image'],
        createdAt: DateFormat("yyyy-MM-dd hh:mm:ss").parse(json['createdAt']),
        isPublic: json['isPublic'],
        creator: json['creator'],
        isExpert: json['isExpert'],
        userModel: json['userModel'] != null
            ? UserModel.fromJsonWithId(json['userModel'])
            : null,
        likes: json['likes'] != null
            ? List<UserModel>.from(json['likes'].map((e) {
                print(e);
                return UserModel.fromJson(e as Map<String, dynamic>, e['id']);
              }).toList())
            : null,
        comments: json['comments'] != null
            ? List<CommentModel>.from(json['comments'].map((e) {
                print(e);
                return CommentModel.fromJson(e as Map<String, dynamic>);
              }).toList())
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'description': description,
        'createdAt': createdAt.toString(),
        'image': image,
        'isPublic': isPublic,
        'likes': likes != null ? likes?.map((e) => e.toJson()).toList() : [],
        'comments':
            comments != null ? comments?.map((e) => e.toJson()).toList() : [],
        'userModel': userModel!.toJson(),
        'creator': creator,
        'isExpert': isExpert,
      };
}
