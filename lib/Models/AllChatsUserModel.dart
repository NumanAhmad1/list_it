// To parse this JSON data, do
//
//     final allChatsUserModel = allChatsUserModelFromJson(jsonString);

import 'dart:convert';

AllChatsUserModel allChatsUserModelFromJson(String str) =>
    AllChatsUserModel.fromJson(json.decode(str));

String allChatsUserModelToJson(AllChatsUserModel data) =>
    json.encode(data.toJson());

class AllChatsUserModel {
  List<Ad> ad;
  List<Lastchat> lastchat;
  String refid;
  String to;
  List<User> user;

  AllChatsUserModel({
    required this.ad,
    required this.lastchat,
    required this.refid,
    required this.to,
    required this.user,
  });

  factory AllChatsUserModel.fromJson(Map<String, dynamic> json) =>
      AllChatsUserModel(
        ad: List<Ad>.from(json["ad"].map((x) => Ad.fromJson(x))),
        lastchat: List<Lastchat>.from(
            json["lastchat"].map((x) => Lastchat.fromJson(x))),
        refid: json["refid"],
        to: json["to"],
        user: List<User>.from(json["user"].map((x) => User.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ad": List<dynamic>.from(ad.map((x) => x.toJson())),
        "lastchat": List<dynamic>.from(lastchat.map((x) => x.toJson())),
        "refid": refid,
        "to": to,
        "user": List<dynamic>.from(user.map((x) => x.toJson())),
      };
}

class Ad {
  String? adname;
  String? adnameAr;
  String? value;
  String? value_ar;

  Ad({
    this.adname,
    this.adnameAr,
    this.value,
    this.value_ar,
  });

  factory Ad.fromJson(Map<String, dynamic> json) => Ad(
        adname: json["name"],
        adnameAr: json["name_ar"],
        value: json["value"].toString(),
        value_ar: json["value_ar"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "name": adname,
        "name_ar": adnameAr,
        "value": value,
        "value_ar": value_ar,
      };
}

class Lastchat {
  String message;
  DateTime messagetime;

  Lastchat({
    required this.message,
    required this.messagetime,
  });

  factory Lastchat.fromJson(Map<String, dynamic> json) => Lastchat(
        message: json["message"],
        messagetime: DateTime.parse(json["messagetime"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "messagetime": messagetime.toIso8601String(),
      };
}

class User {
  String id;
  String email;
  String name;
  String profilePicture;

  User(
      {required this.id,
      required this.email,
      required this.name,
      required this.profilePicture});

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        email: json["email"],
        name: json["name"],
        profilePicture: json['profilePicture'],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "email": email,
        "name": name,
        "profilePicture": profilePicture,
      };
}
