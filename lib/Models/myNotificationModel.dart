// To parse this JSON data, do
//
//     final myNotificationModel = myNotificationModelFromJson(jsonString);

import 'dart:convert';

MyNotificationModel myNotificationModelFromJson(String str) =>
    MyNotificationModel.fromJson(json.decode(str));

String myNotificationModelToJson(MyNotificationModel data) =>
    json.encode(data.toJson());

class MyNotificationModel {
  String id;
  String notifyTo;
  String subject;
  String body;
  String refType;
  String refId;
  String notifyPhoto;
  bool smsSent;
  bool emailSent;
  bool isRead;
  String createdBy;
  DateTime createdAt;

  MyNotificationModel({
    required this.id,
    required this.notifyTo,
    required this.subject,
    required this.body,
    required this.refType,
    required this.refId,
    required this.notifyPhoto,
    required this.smsSent,
    required this.emailSent,
    required this.isRead,
    required this.createdBy,
    required this.createdAt,
  });

  factory MyNotificationModel.fromJson(Map<String, dynamic> json) =>
      MyNotificationModel(
        id: json["ID"] ?? 'N/A',
        notifyTo: json["NotifyTo"] ?? 'N/A',
        subject: json["Subject"] ?? 'N/A',
        body: json["Body"] ?? 'N/A',
        refType: json["RefType"] ?? 'N/A',
        refId: json["RefId"] ?? 'N/A',
        notifyPhoto: json["NotifyPhoto"] ?? 'N/A',
        smsSent: json["SmsSent"] ?? false,
        emailSent: json["EmailSent"] ?? false,
        isRead: json["IsRead"] ?? false,
        createdBy: json["CreatedBy"] ?? 'N/A',
        createdAt: DateTime.parse(json["CreatedAt"]) ?? DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "NotifyTo": notifyTo,
        "Subject": subject,
        "Body": body,
        "RefType": refType,
        "RefId": refId,
        "NotifyPhoto": notifyPhoto,
        "SmsSent": smsSent,
        "EmailSent": emailSent,
        "IsRead": isRead,
        "CreatedBy": createdBy,
        "CreatedAt": createdAt.toIso8601String(),
      };
}
