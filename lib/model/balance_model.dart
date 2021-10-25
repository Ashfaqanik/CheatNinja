import 'package:cloud_firestore/cloud_firestore.dart';

class BalanceModel{
  double amount;
  String email;
  String guestId;
  Timestamp time;

  BalanceModel({this.amount, this.email,this.guestId, this.time});
}