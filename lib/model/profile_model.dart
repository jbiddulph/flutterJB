import 'package:flutter/material.dart';

class Profile {
  final String id;
  final String name;
  final String email;
  final String created_at;

  Profile({
    @required this.id,
    @required this.name,
    @required this.email,
    @required this.created_at,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'].toString() as String,
      name: json['name'] as String,
      email: json['email'] as String,
      created_at: json['created_at'] as String,
    );
  }
}

class ProfileRequestModel {
  String id;
  String name;
  String email;
  String created_at;

  ProfileRequestModel({
    this.id,
    this.name,
    this.email,
    this.created_at,
  });

  Map<String, String> toJson() {
    Map<String, String> map = {
      'id': id.toString(),
      'name': name.trim(),
      'email': email.trim(),
      'created_at': created_at
    };

    return map;
  }
}
