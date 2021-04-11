import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

class Finds {
  final int id;
  final String title;
  final String description;
  final String status;
  final String primary_art;
  final double latitude;
  final double longitude;
  final int height;
  final int width;
  final int cost;
  final int live;
  final int created_by;
  final String created_at;
  final String updated_at;

  Finds({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.status,
    @required this.primary_art,
    @required this.latitude,
    @required this.longitude,
    @required this.height,
    @required this.width,
    @required this.cost,
    @required this.live,
    @required this.created_by,
    @required this.created_at,
    @required this.updated_at,
  });

  factory Finds.fromJson(Map<String, dynamic> json) {
    return Finds(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      primary_art: json['primary_art'] as String,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      height: json['height'] as int,
      width: json['width'] as int,
      cost: json['cost'] as int,
      live: json['live'] as int,
      created_by: json['created_by'] as int,
      created_at: json['created_at'] as String,
      updated_at: json['updated_at'] as String,
    );
  }
}

class FindsRequestModel {
  String title;
  String description;
  String status;
  String primary_art;
  double latitude;
  double longitude;
  int height;
  int width;
  int cost;
  int live;
  int created_by;

  FindsRequestModel({
    this.title,
    this.description,
    this.status,
    this.primary_art,
    this.latitude,
    this.longitude,
    this.height,
    this.width,
    this.cost,
    this.live,
    this.created_by,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'title': title.trim(),
      'description': description.trim(),
      'status': status,
      'primary_art': primary_art.trim(),
      'latitude': latitude,
      'longitude': longitude,
      'height': height,
      'width': width,
      'cost': cost,
      'live': live,
      'created_by': created_by,
    };

    return map;
  }
}
