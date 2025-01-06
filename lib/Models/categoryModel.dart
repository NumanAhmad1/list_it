// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';

CategoryModel categoryModelFromJson(String str) =>
    CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  int id;
  String name;
  String nameAr;
  bool isActive;
  bool isParent;
  int parentId;
  String parentName;
  int level;
  DateTime createdAt;
  int createdBy;
  DateTime updatedAt;
  int updatedBy;

  CategoryModel({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.isActive,
    required this.isParent,
    required this.parentId,
    required this.parentName,
    required this.level,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json["id"] ?? 0,
        name: json["name"] ?? 'N/A',
        nameAr: json["name_ar"] ?? 'N/A',
        isActive: json["is_active"] ?? false,
        isParent: json["is_parent"] ?? false,
        parentId: json["parent_id"] ?? 0,
        parentName: json["parent_name"] ?? 'N/A',
        level: json["level"] ?? 0,
        createdAt: DateTime.parse(json["created_at"]),
        createdBy: json["created_by"] ?? 0,
        updatedAt: DateTime.parse(json["updated_at"]),
        updatedBy: json["updated_by"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "name_ar": nameAr,
        "is_active": isActive,
        "is_parent": isParent,
        "parent_id": parentId,
        "parent_name": parentName,
        "level": level,
        "created_at": createdAt.toIso8601String(),
        "created_by": createdBy,
        "updated_at": updatedAt.toIso8601String(),
        "updated_by": updatedBy,
      };
}
