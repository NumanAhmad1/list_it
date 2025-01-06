// To parse this JSON data, do
//
//     final adsInputFieldsModel = adsInputFieldsModelFromJson(jsonString);

import 'dart:convert';

List<AdsInputFieldsModel> adsInputFieldsModelFromJson(String str) =>
    List<AdsInputFieldsModel>.from(
        json.decode(str).map((x) => AdsInputFieldsModel.fromJson(x)));

String adsInputFieldsModelToJson(List<AdsInputFieldsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AdsInputFieldsModel {
  int categoryFieldId;
  String categoryFieldName;
  String categoryFieldNameArabic;
  String categoryDescription;
  int categoryId;
  int categoryPageId;
  CategoryPageName categoryPageName;
  String categoryPageNameAr;
  String categoryTypeId;
  String categoryTypeName;
  String categoryTypeNameAr;
  bool isActive;
  bool isRequired;
  String maxLength;
  String minLength;
  int unitId;
  String unitName;
  List<Attribute> attributes;

  AdsInputFieldsModel({
    required this.categoryFieldId,
    required this.categoryFieldName,
    required this.categoryFieldNameArabic,
    required this.categoryDescription,
    required this.categoryId,
    required this.categoryPageId,
    required this.categoryPageName,
    required this.categoryPageNameAr,
    required this.categoryTypeId,
    required this.categoryTypeName,
    required this.categoryTypeNameAr,
    required this.isActive,
    required this.isRequired,
    required this.maxLength,
    required this.minLength,
    required this.unitId,
    required this.unitName,
    required this.attributes,
  });

  factory AdsInputFieldsModel.fromJson(Map<String, dynamic> json) =>
      AdsInputFieldsModel(
        categoryFieldId: json["CategoryFieldID"] ?? 0,
        categoryFieldName: json["categoryFieldName"] ?? 'N/A',
        categoryFieldNameArabic: json["categoryFieldNameArabic"] ?? 'N/A',
        categoryDescription: json["categoryDescription"] ?? 'N/A',
        categoryId: json["category_id"] ?? 0,
        categoryPageId: json["categoryPageId"] ?? 0,
        categoryPageName: categoryPageNameValues.map[json["categoryPageName"]]!,
        categoryPageNameAr: json["categoryPageName_ar"],
        categoryTypeId: json["categoryTypeId"],
        categoryTypeName: json["categoryTypeName"],
        categoryTypeNameAr: json["categoryTypeName_ar"] ?? 'N/A',
        isActive: json["is_active"] ?? false,
        isRequired: json["is_required"] ?? false,
        maxLength: json["max_length"] ?? 0,
        minLength: json["min_length"] ?? 0,
        unitId: json["Unit_id"],
        unitName: json["unitName"] ?? '',
        attributes: List<Attribute>.from(
            json["Attributes"].map((x) => Attribute.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "CategoryFieldID": categoryFieldId,
        "categoryFieldName": categoryFieldName,
        "categoryFieldNameArabic": categoryFieldNameArabic,
        "categoryDescription": categoryDescription,
        "category_id": categoryId,
        "categoryPageId": categoryPageId,
        "categoryPageName": categoryPageNameValues.reverse[categoryPageName],
        "categoryPageName_ar": categoryPageNameAr,
        "categoryTypeId": categoryTypeId,
        "categoryTypeName": categoryTypeName,
        "categoryTypeName_ar": categoryTypeNameAr,
        "is_active": isActive,
        "is_required": isRequired,
        "max_length": maxLength,
        "min_length": minLength,
        "Unit_id": unitId,
        "unitName": unitNameValues.reverse[unitName],
        "Attributes": List<dynamic>.from(attributes.map((x) => x.toJson())),
      };
}

class Attribute {
  String attribuiteId;
  String attributeName;
  String attributeNameAr;
  String systemValue;
  String reloadCategoryfieldId;
  String reloadByFieldIds;

  Attribute({
    required this.attribuiteId,
    required this.attributeName,
    required this.attributeNameAr,
    required this.systemValue,
    required this.reloadCategoryfieldId,
    required this.reloadByFieldIds,
  });

  factory Attribute.fromJson(Map<String, dynamic> json) => Attribute(
        attribuiteId: json['attributeId'].toString(),
        attributeName: json["attributeName"] ?? 'N/A',
        attributeNameAr: json['attributeNameAr'] ?? 'N/A',
        systemValue: json["systemValue"] ?? 'N/A',
        reloadCategoryfieldId: json['reloadCategoryfieldId'].toString(),
        reloadByFieldIds: json['reloadByFieldIds'].toString(),
      );

  Map<String, dynamic> toJson() => {
        "attributeId": attribuiteId.toString(),
        "attributeName": attributeName,
        "attributeNameAr": attributeNameAr,
        "systemValue": systemValue,
        "reloadCategoryfieldId": reloadCategoryfieldId.toString(),
        "reloadByFieldIds": reloadByFieldIds.toString(),
      };
}

enum CategoryPageName { DETAILS, SUMMARY }

final categoryPageNameValues = EnumValues(
    {"Details": CategoryPageName.DETAILS, "Summary": CategoryPageName.SUMMARY});

enum UnitName { AREA, DISTANCE, LENGTH, MILEAGE, NULL }

final unitNameValues = EnumValues({
  "Area": UnitName.AREA,
  "Distance": UnitName.DISTANCE,
  "Length": UnitName.LENGTH,
  "Mileage": UnitName.MILEAGE,
  "Null": UnitName.NULL
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
