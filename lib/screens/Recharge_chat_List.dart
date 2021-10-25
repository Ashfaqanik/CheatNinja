import 'package:cheat_ninja/providers/biling_provider.dart';
import 'package:cheat_ninja/screens/home_page.dart';
import 'package:cheat_ninja/screens/recharge_chat_page.dart';
import 'package:cheat_ninja/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cheat_ninja/model/chat_user_model.dart';

class RechargeChatList extends StatefulWidget {

  @override
  _RechargeChatListState createState() => _RechargeChatListState();
}

class _RechargeChatListState extends State<RechargeChatList> {
  List<ChatUserModel> _chatUserList= [];
  @override
  Widget build(BuildContext context) {
    BillingProvider billAuth = Provider.of<BillingProvider>(
        context, listen: false);
    setState(() {
      _chatUserList=billAuth.chatUserList;
    });
    final size = MediaQuery
        .of(context)
        .size;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: ColorsUi.darkCardColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_sharp), onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) {
                  return HomePage();
                }));
          },),
          toolbarHeight: size.height * .08,
          title: Text(
            'Recharge Requests', style: TextStyle(color: Colors.white70),),
        ),
        body: _bodyUi(),
      ),
    );
  }
  Future<bool> _onBackPressed() async {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) {
          return HomePage();
        }));
  }

  Widget _bodyUi() {
    BillingProvider billAuth = Provider.of<BillingProvider>(
        context, listen: false);
    final size = MediaQuery
        .of(context)
        .size;
    return Container(
      color: Theme.of(context).primaryColor,
      height: size.height*.9,
      child: ListView.builder(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        itemCount: _chatUserList.length,
        itemBuilder: (context, index) {
            final user = _chatUserList[index];
            DateTime t = _chatUserList[index].lastMessageTime.toDate();
          return ListTile(
            onTap: () async{
              //billAuth.isSeen=true;
              await billAuth.updateSeen('admin@cheatninja.io', user.id).then((value){
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => RechargeChatPage(userEmail: 'admin@cheatninja.io',user: 'Admin',sender: user.userName,opponentEmail: user.id,),
                ));
              });
            },
            leading: Icon(Icons.account_circle,
                size: size.height * .075,
                color: Colors.grey[500]),
            title: user.isSeen==false?Text(user.userName,style: TextStyle(fontSize: size.width * .035, fontWeight: FontWeight.bold, color: ColorsUi.selectedDarkColor)):
            Text(user.userName,style: TextStyle(fontSize: size.width * .035, fontWeight: FontWeight.bold, color: Colors.white70)),
            subtitle: user.isSeen==false?Text(user.lastMessage,maxLines: 1,style:TextStyle(fontSize: size.width * .030, fontWeight: FontWeight.normal, color: ColorsUi.selectedDarkColor)):
            Text(user.lastMessage,maxLines: 1,style:TextStyle(fontSize: size.width * .030, fontWeight: FontWeight.normal, color: Colors.white70)),
            trailing: Text(
              DateFormat.yMMMd().add_jm().format(t),
              style: TextStyle(color: Colors.grey, fontSize: size.width * .025),
            ),
          );
        },
      ),
    );
  }
}

