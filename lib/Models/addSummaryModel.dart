// To parse this JSON data, do
//
//     final addSummaryModel = addSummaryModelFromJson(jsonString);

import 'dart:convert';

AddSummaryModel addSummaryModelFromJson(String str) =>
    AddSummaryModel.fromJson(json.decode(str));

String addSummaryModelToJson(AddSummaryModel data) =>
    json.encode(data.toJson());

class AddSummaryModel {
  String name;
  String nameAr;
  dynamic value;
  dynamic valueAr;
  String field;

  AddSummaryModel({
    required this.name,
    required this.nameAr,
    required this.value,
    required this.valueAr,
    required this.field,
  });

  factory AddSummaryModel.fromJson(Map<String, dynamic> json) =>
      AddSummaryModel(
        name: json["name"],
        nameAr: json["name_ar"],
        value: json["value"],
        valueAr: json['value_ar'],
        field: json["field"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "name_ar": nameAr,
        "value": value,
        "value_ar": valueAr,
        "field": field,
      };
}
