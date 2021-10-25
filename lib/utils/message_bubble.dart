import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'colors.dart';
import 'package:intl/intl.dart';

bool tcVisibility = false;

class MessageBubble extends StatefulWidget {
  final String sender;
  final String text;
  final bool isMe;
  Timestamp time;

  MessageBubble({this.sender, this.text, this.isMe, this.time});

  @override
  _MessageBubbleState createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  @override
  Widget build(BuildContext context) {
    DateTime t = widget.time.toDate();
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment:
            widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: widget.sender == 'Admin'
                ? Container(
                    height: size.height * .02,
                    width: size.width * .12,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/tenor.gif"),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: Text('${widget.sender}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: size.width * .035,
                              color: Colors.white)),
                    ))
                : Text(
                    '${widget.sender}',
                    style: TextStyle(
                      fontSize: size.width * .035,
                      color: Colors.white54,
                    ),
                  ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                if (tcVisibility == false) {
                  tcVisibility = true;
                } else {
                  tcVisibility = false;
                }
              });
            },
            child: Material(
              borderRadius: widget.isMe
                  ? BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0))
                  : BorderRadius.only(
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topRight: Radius.circular(8.0),
                    ),
              elevation: 5.0,
              color:
                  widget.isMe ? ColorsUi.selectedDarkColor : Colors.grey[400],
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Text(
                  widget.text,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: size.width * .040,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Visibility(
                visible: tcVisibility,
                child: Text(
                  DateFormat.yMMMd().add_jm().format(t),
                  style: TextStyle(color: Colors.grey, fontSize: size.width * .025),
                )),
          )
        ],
      ),
    );
  }
}
