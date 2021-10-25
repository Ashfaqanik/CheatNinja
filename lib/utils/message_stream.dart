import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'message_bubble.dart';

class MessageStream extends StatefulWidget {
  String id,email;
  MessageStream({this.id,this.email});

  @override
  _MessageStreamState createState() => _MessageStreamState();
}

class _MessageStreamState extends State<MessageStream> {
  final _firestore = FirebaseFirestore.instance;
  String currentUser;
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      currentUser = widget.id;
    });
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').orderBy('timestamp',descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data.docs;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message.get('text');
          final messageSender = message.get('sender');
          final time = message.get('timestamp');

          final messageBubble = MessageBubble(
            sender: messageSender,
            text: messageText,
            isMe: currentUser == messageSender ?true:false,
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
