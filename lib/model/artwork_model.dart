import 'package:flutter/material.dart';

class Artwork {
  final int id;
  final String title;
  final String description;
  final String status;
  final String primary_art;
  final int height;
  final int width;
  final int live;
  final int created_by;
  final String created_at;
  final String updated_at;

  Artwork({
    @required this.id, 
    @required this.title,
    @required this.description,
    @required this.status,
    @required this.primary_art,
    @required this.height,
    @required this.width,
    @required this.live,
    @required this.created_by,
    @required this.created_at,
    @required this.updated_at, 
    });

  factory Artwork.fromJson(Map<String, dynamic> json) {
    return Artwork(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      primary_art: json['primary_art'] as String,
      height: json['height'] as int,
      width: json['width'] as int,
      live: json['live'] as int,
      created_by: json['created_by'] as int,
      created_at: json['created_at'] as String,
      updated_at: json['updated_at'] as String,
    );
  }
}