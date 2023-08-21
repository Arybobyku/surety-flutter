import 'package:surety/model/user_model.dart';

class ProductModel {
  String? id;
  String? creator;
  String? title;
  String? description;
  String? createdAt;
  String? picture;
  double? price;
  UserModel? userModel;

  ProductModel({
    this.id,
    this.creator,
    this.title,
    this.description,
    this.userModel,
    this.picture,
    this.createdAt,
    this.price,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json, id) => ProductModel(
        id: id,
        creator: json['creator'],
        title: json['title'],
        description: json['description'],
        createdAt: json['createdAt'],
        picture: json['picture'],
        price: json['price'],
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
        'price': price,
        'userModel': userModel!.toJson(),
      };
}
