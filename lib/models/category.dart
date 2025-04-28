import 'package:uuid/uuid.dart';//package used to generate unique ids
import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final Color color;

  Category({   //constructor
    String? id, 
    required this.name,
    required this.color,
  }) : id = id ?? const Uuid().v4();// if no id is passed it genrates a new unique id using uuid.v4

  Map<String, dynamic> toJson() { //converts to category object to json method
    return {
      'id': id,
      'name': name,
      'color': color.value, //in flutter color is stored as int value
    };
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      color: Color(json['color']),
    );
  }
}
