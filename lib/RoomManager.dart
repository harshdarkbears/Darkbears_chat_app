import 'dart:convert';

import 'package:web_socket_channel/io.dart';
import 'package:darkbears_chat/CommonFunctions.dart';
import 'package:darkbears_chat/PreferencesManager.dart'as PreferencesManager;
import 'package:darkbears_chat/Constants.dart' as Constants ;

import 'ChatModel.dart';

class ChatManager {
  // here we connect WebSocket on server by Address URL
  final channel = IOWebSocketChannel.connect(Constants.WEB_SOCKET_ADDRESS);
  static ChatManager _instance = ChatManager._internal();

  static getInstance() => _instance;
  String userID;

  ChatManager._internal() {
    setUserId();
  }

  // For send data to server
  sendData(Chat chat) {
    channel.sink.add(json.encode(chat.toJson()));
  }


  setUserId() async {
    String userId =
        PreferencesManager.getPref(PreferencesManager.USER_ID) ?? "";
    if (userId.length == 0) {
      // here we save user_id into local storage
      userId = await CommonMethods().getId();
      PreferencesManager.savePref(PreferencesManager.USER_ID, userId);
      this.userID = userId;
      return this.userID;
    } else {
      this.userID = userId;
      return userId;
    }
  }

  // getting user id form local
  getUserId() {
    String userId =
        PreferencesManager.getPref(PreferencesManager.USER_ID) ?? "";
    this.userID = userId;
    return userId;
  }

  getSocketChannelStream() {
    return channel.stream;
  }

  // close connection when we go outside the app
  closeConnection() {
    channel.sink.close();
  }
}
