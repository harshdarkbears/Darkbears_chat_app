import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:darkbears_chat/ChatModel.dart';
import 'package:darkbears_chat/RoomManager.dart';

class ChatScreen extends StatelessWidget {
  final msgController = TextEditingController();

  ScrollController _scrollController = new ScrollController();
  ChatManager _chatManager = ChatManager.getInstance();
  final List<Chat> chatData = [];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    Locale myLocale = Localizations.localeOf(context);
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: _chatManager.getSocketChannelStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              chatData.add(Chat.fromJson(json.decode(snapshot.data)));
              if (chatData.length > 1) {
                Future.delayed(Duration(milliseconds: 50), () {
                  _scrollToBottom();
                });
              }
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 15.0),
                Expanded(
                  child: (chatData.length == 0)
                      ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text("No Message Found",
                            style: TextStyle(color: Colors.grey)),
                        SizedBox(height: 20.0),
                      ],
                    ),
                  )
                      : ListView.builder(
                    controller: _scrollController,
                    itemCount: chatData.length,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final item = chatData[index];
                      return Container(
                        width: width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment:
                          (item.senderId == _chatManager.getUserId())
                              ? CrossAxisAlignment.start
                              : CrossAxisAlignment.end,
                          children: <Widget>[
                            Wrap(
                              children: <Widget>[
                                Padding(
                                  padding: (item.senderId ==
                                      _chatManager.getUserId())
                                      ? EdgeInsets.only(left: 20.0)
                                      : EdgeInsets.only(right: 20.0),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    crossAxisAlignment: (item.senderId ==
                                        _chatManager.getUserId())
                                        ? CrossAxisAlignment.start
                                        : CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(10.0),
                                        margin: EdgeInsets.only(
                                            left: 10.0, right: 10.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(5.0),
                                          color: (item.senderId ==
                                              _chatManager.getUserId())
                                              ? Colors.black
                                              : Colors.white,
                                        ),
                                        child: Text(
                                          item.message,
                                          style: TextStyle(
                                            color: (item.senderId ==
                                                _chatManager
                                                    .getUserId())
                                                ? Colors.white
                                                : Colors.white,
                                            fontSize: 15.0,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Row(
                                          mainAxisAlignment: (item
                                              .senderId ==
                                              _chatManager.getUserId())
                                              ? MainAxisAlignment.start
                                              : MainAxisAlignment.end,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: <Widget>[
                                            (item.senderId ==
                                                _chatManager
                                                    .getUserId())
                                                ? Container()
                                                : Icon(
                                              Icons.check,
                                              color:
                                              Colors.blueAccent,
                                              size: 14.0,
                                            ),
                                            SizedBox(
                                              width: 7.0,
                                            ),
                                            Text(
                                              item.createdAt.toString(),
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  width: width,
                  height: 70.0,
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: width - 70.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey,
                        ),
                        child: TextField(
                          controller: msgController,
                          style: TextStyle(
                            fontSize: 13.0,
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            hintText: "Type Message here",
                            hintStyle: TextStyle(
                              fontSize: 13.0,
                              color: Colors.white60,
                            ),
                            contentPadding: (myLocale.languageCode == 'ar')
                                ? EdgeInsets.only(right: 10.0)
                                : EdgeInsets.only(left: 10.0),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      SizedBox(
                        width: 40.0,
                        height: 40.0,
                        child: RaisedButton(
                          padding: EdgeInsets.all(0.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          onPressed: () {
                            if (msgController.text.trim().length > 0) {
                              Chat chatMessage = Chat.fromJson(
                                {
                                  "sender_id": _chatManager.getUserId(),
                                  "message": msgController.text.trim(),
                                  "created_at": DateFormat("dd/MM/yyyy hh:mm")
                                      .format(DateTime.now()),
                                },
                              );
                              _chatManager.sendData(chatMessage);
                              msgController.text = '';
                            }
                          },
                          color: Colors.grey,
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 18.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );

  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 200),
    );
  }
}
