import 'package:cloud_firestore/cloud_firestore.dart';

class PurchaseHistoryModel{
  String id;
  String name;
  String url;
  double price;
  String serialCode;
  String email;
  String state;
  String guestId;
  Timestamp timeStamp;

  PurchaseHistoryModel({this.id,this.price,this.name,this.url,this.serialCode, this.email,this.state,this.guestId, this.timeStamp});
}