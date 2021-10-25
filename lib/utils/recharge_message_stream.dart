import 'package:cheat_ninja/utils/recharge_message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RechargeMessageStream extends StatefulWidget {
  String email,opponentEmail;

  RechargeMessageStream({this.email,this.opponentEmail});

  @override
  _RechargeMessageStreamState createState() => _RechargeMessageStreamState();
}

class _RechargeMessageStreamState extends State<RechargeMessageStream> {
  final _firestore = FirebaseFirestore.instance;
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: widget.email!='admin@cheatninja.io'?_firestore.collection('rechargeChats/${widget.email} admin@cheatninja.io/messages')
          .orderBy('timestamp',descending: true).snapshots():_firestore.collection('rechargeChats/${widget.opponentEmail} admin@cheatninja.io/messages')
          .orderBy('timestamp',descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data.docs;
        List<RechargeMessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message.get('text');
          final messageSender = message.get('sender');
          final messageSenderEmail = message.get('senderEmail');
          final time = message.get('timestamp');

          final messageBubble = RechargeMessageBubble(
            sender: messageSender,
            senderEmail: messageSenderEmail,
            text: messageText,
            isMe: widget.email == messageSenderEmail ?true:false,
            time: time,
          );

          messageBubbles.add(messageBubble);
        }
        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(top: 10,bottom: 90),
                reverse: true,
                children: messageBubbles,
              ),
            ),
          ],
        );
      },
    );
  }
}