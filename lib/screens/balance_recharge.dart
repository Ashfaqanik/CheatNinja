import 'package:cheat_ninja/model/chat_user_model.dart';
import 'package:cheat_ninja/providers/biling_provider.dart';
import 'package:cheat_ninja/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class BalanceRecharge extends StatefulWidget {
  @override
  _BalanceRechargeState createState() => _BalanceRechargeState();
}

class _BalanceRechargeState extends State<BalanceRecharge> {
  List<ChatUserModel> filteredUsers = [];
  List<ChatUserModel> userList = [];
  int _counter = 0;
  bool _isLoading = false;
  final _addKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    BillingProvider operation =
    Provider.of<BillingProvider>(context);
    if (_counter == 0) {
      operation.getAllChatUser().then((value){
        setState(() {
          userList=operation.chatUserList;
          filteredUsers=userList;
          _counter++;
        });
      });
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: ColorsUi.darkCardColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_sharp), onPressed: () {
          Navigator.of(context).pop();
        },),
        toolbarHeight: size.height * .08,
        title: Text(
          'Recharge Balance', style: TextStyle(color: Colors.white70),),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                color: Theme.of(context).primaryColor,
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Search by email address..',
                      labelStyle:
                      TextStyle(color: ColorsUi.selectedDarkColor)),
                  onChanged: (string) {
                    setState(() {
                      filteredUsers = userList
                          .where((u) => (u.id
                      //.toLowerCase()
                          .contains(string.toLowerCase())))
                          .toList();
                    });

                  },
                ),
              ),
              Expanded(child: _bodyUi()),
            ],
          ),
          _isLoading?Center(child: CircularProgressIndicator()):Container()
        ],
      ),
    );
  }
  Widget _bodyUi() {
    BillingProvider operation =
    Provider.of<BillingProvider>(context);
    final size = MediaQuery
        .of(context)
        .size;
    return Container(
      color: Theme.of(context).primaryColor,
      height: size.height*.9,
      child: ListView.builder(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        itemCount: filteredUsers.length,
        itemBuilder: (context, index) {
          return ListTile(
           title:Text(filteredUsers[index].id,style: TextStyle(fontSize: size.width * .035, fontWeight: FontWeight.bold, color: Colors.white70)),
            trailing: InkWell(
              onTap: ()async{
                //print(filteredUsers[index].guestId);
                setState(() {
                  _isLoading=true;
                });
                await operation.getRegisterdUser(filteredUsers[index].guestId).then((value){
                  setState(() {
                    _isLoading=false;
                  });
                  _showDialog(filteredUsers[index].guestId,filteredUsers[index].id);
                });
              },
              child: Container(
                height: size.height * .04,
                width: size.width * .20,
                decoration: BoxDecoration(
                    color: ColorsUi.darkCardColor,
                    borderRadius:
                    BorderRadius.circular(15),
                    border: Border.all(
                        color:
                        ColorsUi.selectedDarkColor)),
                child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text('Recharge',
                          style: TextStyle(
                              fontSize: size.width * .033,
                              fontWeight: FontWeight.bold,
                              color: ColorsUi
                                  .selectedDarkColor)),
                    )),
              ),
            ),

          );
        },
      ),
    );
  }

  _showDialog(String id,String email) {
    BillingProvider operation =
    Provider.of<BillingProvider>(context,listen: false);
    double rechargeAmount;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            contentPadding: EdgeInsets.all(20),
            title: Column(
              children: [
                Text(
                  '$email',style: TextStyle(fontSize: MediaQuery.of(context).size.width*.050,color: ColorsUi.selectedDarkColor),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 5),
                Text(
                  'Id: $id',style: TextStyle(fontSize: MediaQuery.of(context).size.width*.05),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 5),
                Text(
                 'Current Balance:'+ '\$${operation.billDetailList[0].balance}',
                  style:TextStyle(fontSize: MediaQuery.of(context).size.width*.04),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            content: Container(
              child: Form(
                key: _addKey,
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Add balance'),
                      onSaved: (val) {
                        rechargeAmount = double.parse(val);
                        },
                      validator: (val) =>
                      val.isEmpty ? 'Enter balance' : null,
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RaisedButton(
                          color: Colors.redAccent,
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        RaisedButton(
                          color: Theme
                              .of(context)
                              .primaryColor,
                          onPressed: () {
                            if (_addKey.currentState.validate()) {
                              _addKey.currentState.save();
                              Navigator.pop(context);
                              setState(() {
                                operation.balanceModel.amount=rechargeAmount;
                                operation.balanceModel.email=email;
                                operation.balanceModel.guestId=id;
                                operation.balanceModel.time=Timestamp.now();
                              });
                              setState(() {
                                _isLoading=true;
                              });
                              operation.updateBalance(id, rechargeAmount).then((value)async{
                                await operation.rechargeList(operation.balanceModel).then((value){
                                  setState(() {
                                    _isLoading=false;
                                  });
                                  _showToast('Balance Recharged', ColorsUi.selectedDarkColor);
                                  operation.getAllChatUser();
                                });
                              });

                            }
                          },
                          child: Text(
                            "Update",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
  void _showToast(String message, Color color) {
    setState(() {
      _isLoading = false;
    });
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        //ColorsUi.selectedDarkColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
