import 'package:cheat_ninja/providers/biling_provider.dart';
import 'package:cheat_ninja/screens/home_page.dart';
import 'package:cheat_ninja/utils/recharge_message_stream.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Recharge_chat_List.dart';

class RechargeChatPage extends StatefulWidget {
  String sender,user,text,userEmail,opponentEmail,guestId;

  RechargeChatPage({this.sender,this.user,this.text,this.userEmail,this.opponentEmail,this.guestId});

  @override
  _RechargeChatPageState createState() => _RechargeChatPageState();
}

class _RechargeChatPageState extends State<RechargeChatPage> {
  final messageTextController = TextEditingController();
  String messageText;
  bool _isLoading=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.user);
    print(widget.text);
    messageTextController.text=widget.text??'';
    messageText=messageTextController.text;
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.blueGrey,
          leading: IconButton( icon: Icon(Icons.arrow_back_ios_sharp), onPressed: ()async {
            setState(() {
              _isLoading=true;
            });
            BillingProvider billAuth =
            Provider.of<BillingProvider>(context, listen: false);
            widget.userEmail=='admin@cheatninja.io'?await billAuth.getAllChatUser().then((value) {
              setState(() {
                _isLoading=false;
              });
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                    return RechargeChatList();
                  }));
            }): Navigator.push(context,
            MaterialPageRoute(builder: (context) {
            return HomePage();
            }));
            },),
          toolbarHeight: size.height*.08,
          title: Text(widget.sender,style: TextStyle(color: Colors.white70),),
        ),
        body: Stack(
          children: [
            _bodyUi(),
            _isLoading?Center(child: CircularProgressIndicator()):Container()
          ],
        ),
      ),
    );
  }
  Widget _bodyUi(){
    final size = MediaQuery.of(context).size;
    BillingProvider billAuth = Provider.of<BillingProvider>(context,listen: false);
    return Container(
      color: Theme.of(context).primaryColor,
      child:Stack(
        children: [
          RechargeMessageStream(email: widget.userEmail,opponentEmail: widget.opponentEmail,),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10,bottom: 10,top: 10),
              height: size.width*.20,
              width: double.infinity,
              color: Theme.of(context).primaryColor,
              child: Row(
                children: <Widget>[
                  SizedBox(width: size.width*.04,),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      expands: true,
                      controller: messageTextController,
                      style: TextStyle(color: Colors.grey[400]),
                      //textCapitalization: TextCapitalization.sentences,
                      autocorrect: true,
                      enableSuggestions: true,
                      decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(5),
                          hintStyle: TextStyle(color: Colors.blueGrey),
                        hintText: 'Write your message..',
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide: const BorderSide(
                          color: Color(0xFF4A8789), width: 0.5,),),
                      ),
                      onChanged: (value) {
                        messageText = value;
                      },
                    ),
                  ),
                  SizedBox(width: size.width*.04,),
                  FloatingActionButton(
                    onPressed: (){
                      messageTextController.clear();
                      messageText!=null?billAuth.uploadMessage(messageText, widget.userEmail,widget.user,widget.opponentEmail,widget.sender,widget.guestId):null;
                      print(widget.guestId);
                    },
                    child: Icon(Icons.send,color: Colors.white,size: size.width*.06,),
                    backgroundColor: Colors.blueGrey,
                    elevation: 0,
                  ),
                ],

              ),
            ),
          ),
        ],
      ),
    );
  }
  Future<bool> _onBackPressed() async {
    setState(() {
      _isLoading=true;
    });
    BillingProvider billAuth =
    Provider.of<BillingProvider>(context, listen: false);
    widget.userEmail=='admin@cheatninja.io'?await billAuth.getAllChatUser().then((value) {
      setState(() {
        _isLoading=false;
      });
    Navigator.push(context,
        MaterialPageRoute(builder: (context) {
          return RechargeChatList();
        }));
    }): Navigator.push(context,
          MaterialPageRoute(builder: (context) {
            return HomePage();
          }));

  }
}
