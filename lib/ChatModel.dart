// this chat model use for share data between server and app.

import 'dart:convert';

Chat chatFromJson(String str) => Chat.fromJson(json.decode(str));

String chatToJson(Chat data) => json.encode(data.toJson());

class Chat {
  Chat({
    this.senderId,
    this.message,
    this.createdAt,
  });

  String senderId;
  String message;
  String createdAt;

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        senderId: json["sender_id"],
        message: json["message"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "sender_id": senderId,
        "message": message,
        "created_at": createdAt,
      };
}
