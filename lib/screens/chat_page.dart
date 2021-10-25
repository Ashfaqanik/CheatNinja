import 'package:cheat_ninja/providers/login_provider.dart';
import 'package:cheat_ninja/utils/colors.dart';
import 'package:cheat_ninja/utils/message_stream.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  String id,name,email;

  ChatPage({this.id,this.name,this.email});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String currentUser;
  @override
  void initState() {
    // TODO: implement initState
    var operation = Provider.of<LoginProvider>(context,listen: false);

    print(operation.isLogged);
    setState(() {
      operation.isLogged?currentUser = widget.name:currentUser = 'Guest id: ${widget.id}';
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var operation = Provider.of<LoginProvider>(context,listen: false);
    final size = MediaQuery.of(context).size;
    final messageTextController = TextEditingController();
    final _firestore = FirebaseFirestore.instance;
    String messageText;
    return SafeArea(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Stack(
          children: <Widget>[
            MessageStream(id: currentUser,email: widget.email),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: EdgeInsets.only(left: 10,bottom: 10,top: 10),
                height: size.width*.20,
                width: double.infinity,
                color: Theme.of(context).primaryColor,
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){
                      },
                      child: Container(
                        height: size.width*.10,
                        width: size.width*.10,
                        decoration: BoxDecoration(
                          color: ColorsUi.selectedDarkColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Icon(Icons.add, color: Colors.white, size: 20, ),
                      ),
                    ),
                    SizedBox(width: size.width*.04,),
                    Expanded(
                      child: TextField(
                        controller: messageTextController,
                        style: TextStyle(color: Colors.grey[300]),
                        decoration: InputDecoration(
                            hintText: "Write message...",
                            hintStyle: TextStyle(color: ColorsUi.selectedDarkColor),
                            border: InputBorder.none
                        ),
                        onChanged: (value) {
                          messageText = value;
                        },
                      ),
                    ),
                    SizedBox(width: size.width*.04,),
                    FloatingActionButton(
                      onPressed: (){
                        print(operation.isLogged);
                        messageTextController.clear();
                        messageText!=null?_firestore.collection('messages').add({
                          'text': messageText,
                          'sender': operation.isLogged==true && widget.email!='admin@cheatninja.io'?widget.name:operation.isLogged==true && widget.email=='admin@cheatninja.io'?'Admin':'Guest id: ${widget.id}',
                          "timestamp": Timestamp.now(),
                        }):null;
                      },
                      child: Icon(Icons.send,color: Colors.white,size: size.width*.06,),
                      backgroundColor: ColorsUi.selectedDarkColor,
                      elevation: 0,
                    ),
                  ],

                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}