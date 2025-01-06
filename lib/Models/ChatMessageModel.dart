// To parse this JSON data, do
//
//     final chatMessageModel = chatMessageModelFromJson(jsonString);

import 'dart:convert';

ChatMessageModel chatMessageModelFromJson(String str) => ChatMessageModel.fromJson(json.decode(str));

String chatMessageModelToJson(ChatMessageModel data) => json.encode(data.toJson());

class ChatMessageModel {
  String id;
  String to;
  String from;
  String refid;
  String message;
  String attachment;
  DateTime messagetime;

  ChatMessageModel({
    required this.id,
    required this.to,
    required this.from,
    required this.refid,
    required this.message,
    required this.attachment,
    required this.messagetime,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) => ChatMessageModel(
    id: json["ID"],
    to: json["To"],
    from: json["From"],
    refid: json["Refid"],
    message: json["Message"],
    attachment: json['Attachment'],
    messagetime: DateTime.parse(json["Messagetime"]),
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "To": to,
    "From": from,
    "Refid": refid,
    "Message": message,
    "Attachment": attachment,
    "Messagetime": messagetime.toIso8601String(),
  };
}
