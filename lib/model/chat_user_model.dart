import 'package:cloud_firestore/cloud_firestore.dart';

class ChatUserModel{
  String id;
  String userName;
  String guestId;
  String lastMessage;
  Timestamp lastMessageTime;
  bool isSeen;

  ChatUserModel({this.id,this.userName, this.guestId,this.lastMessage, this.lastMessageTime,this.isSeen});
}