// To parse this JSON data, do
//
//     final googleSignModel = googleSignModelFromJson(jsonString);

import 'dart:convert';

GoogleSignModel googleSignModelFromJson(String str) =>
    GoogleSignModel.fromJson(json.decode(str));

String googleSignModelToJson(GoogleSignModel data) =>
    json.encode(data.toJson());

class GoogleSignModel {
  String displayName;
  String email;
  double id;
  String photoUrl;
  dynamic serverAuthCode;

  GoogleSignModel({
    required this.displayName,
    required this.email,
    required this.id,
    required this.photoUrl,
    required this.serverAuthCode,
  });

  factory GoogleSignModel.fromJson(Map<String, dynamic> json) =>
      GoogleSignModel(
        displayName: json["displayName"],
        email: json["email"],
        id: json["id"]?.toDouble(),
        photoUrl: json["photoUrl"],
        serverAuthCode: json["serverAuthCode"],
      );

  Map<String, dynamic> toJson() => {
        "displayName": displayName,
        "email": email,
        "id": id,
        "photoUrl": photoUrl,
        "serverAuthCode": serverAuthCode,
      };
}
