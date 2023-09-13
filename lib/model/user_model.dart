import 'dart:convert';

import 'dart:ffi';

class UserModel {
  late String password;
  late String email;
  late String fullName;
  late bool isValid;
  String? id;
  int? role;
  String? photoProfile;
  String? dateOfBirth;
  String? gender;
  String? expertise;
  List<String>? bio;
  bool allow;

  UserModel({
    this.id,
    this.role,
    this.photoProfile,
    required this.fullName,
    required this.password,
    required this.email,
    required this.isValid,
    this.dateOfBirth,
    this.gender,
    this.expertise,
    this.bio,
    this.allow = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, String id) {
    return UserModel(
      id: id,
      role: json['role'],
      photoProfile: json['photoProfile'],
      fullName: json['fullName'],
      password: '',
      email: json['email'],
      isValid: json['isValid'],
      dateOfBirth: json['dateOfBirth'],
      gender: json['gender'],
      expertise: json['expertise'],
      allow: json['allow'] ?? false,
    );
  }

  factory UserModel.fromJsonWithId(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      role: json['role'],
      photoProfile: json['photoProfile'],
      fullName: json['fullName'],
      password: '',
      email: json['email'],
      isValid: json['isValid'],
      dateOfBirth: json['dateOfBirth'],
      gender: json['gender'],
      expertise: json['expertise'],
      allow: json['allow'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'role': role,
    'photoProfile': photoProfile,
    'fullName': fullName,
    'email': email,
    'isValid': isValid,
    'dateOfBirth': dateOfBirth,
    'gender': gender,
    'expertise': expertise,
    'allow': allow,
  };

}
