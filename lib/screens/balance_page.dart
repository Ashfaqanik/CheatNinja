import 'package:aamarpay/aamarpay.dart';
import 'package:cheat_ninja/providers/biling_provider.dart';
import 'package:cheat_ninja/screens/recharge_chat_page.dart';
import 'package:cheat_ninja/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';

class BalancePage extends StatefulWidget {
  String id;

  BalancePage(this.id);

  @override
  _BalancePageState createState() => _BalancePageState();
}

class _BalancePageState extends State<BalancePage> {
  String rechargeCategory;
  bool isLoading=true;
  double rechargeAmount;
  final GlobalKey<PopupMenuButtonState<int>> _key = GlobalKey();
  final _addKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BillingProvider billAuth =
    Provider.of<BillingProvider>(context, listen: false);
    billAuth.getRegisterdUser(widget.id);
  }
  @override
  Widget build(BuildContext context) {
    setState(() {
      isLoading=false;
    });
    BillingProvider billAuth =
        Provider.of<BillingProvider>(context, listen: false);
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: ColorsUi.darkCardColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_sharp),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          toolbarHeight: size.height * .08,
          title: Text(
            'Your Balance',
            style: TextStyle(color: Colors.white70),
          ),
        ),
        body: Container(
          color: Theme.of(context).primaryColor,
          child: Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 2,
                  clipBehavior: Clip.antiAlias,
                  color: ColorsUi.darkCardColor,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.monetization_on_rounded,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 5),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                              'Balance: \$${billAuth.billDetailList[0].balance}',
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  color: ColorsUi.selectedDarkColor,
                                  fontSize: size.width * .051,
                                  fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Container(
                          width: size.width*.3,
                          child: PopupMenuButton<int>(
                            key: _key,
                            icon: Row(
                              children: [
                                Text('Recharge',
                                    style: TextStyle(
                                        color: ColorsUi.selectedDarkColor,
                                        fontSize: 16)),
                                Icon(Icons.arrow_drop_down,color: ColorsUi.selectedDarkColor,)
                              ],
                            ),
                            onSelected: (int val)async{
                              if(val==1){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RechargeChatPage(
                                              sender: 'Admin',
                                              user: billAuth
                                                  .billDetailList[0]
                                                  .firstName +
                                                  ' ' +
                                                  billAuth
                                                      .billDetailList[0]
                                                      .lastName,
                                              text:
                                              'Hello Admin,I am ${billAuth.billDetailList[0].firstName}, email address: ${billAuth.billDetailList[0].email}.'
                                                  'I want to recharge my balance.',
                                              userEmail: billAuth
                                                  .billDetailList[0]
                                                  .email,
                                              opponentEmail:
                                              'admin@cheatninja.io',
                                              guestId: billAuth
                                                  .billDetailList[0]
                                                  .guestId,
                                            )));
                              }else if(val==2){
                                _showDialog(billAuth);
                              }
                            },
                            itemBuilder: (context) {
                              return <PopupMenuEntry<int>>[
                                PopupMenuItem(child: Text('Request For Recharge',style: TextStyle(fontWeight: FontWeight.bold,color: ColorsUi.selectedDarkColor),), value: 1),
                                PopupMenuItem(child: Text('Recharge via aamarPay',style: TextStyle(fontWeight: FontWeight.bold,color: ColorsUi.selectedDarkColor)),value: 2),

                              ];
                            },
                            tooltip: 'Recharge',
                            color: ColorsUi.darkCardColor,
                            offset: Offset(0,size.width*.075),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    'Recharge Record:',
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        color: ColorsUi.selectedDarkColor,
                        fontSize: size.width * .050,
                        fontWeight: FontWeight.w900),
                  ),
                ),
                SizedBox(height: 4.5),
                Card(
                  elevation: 2,
                  clipBehavior: Clip.antiAlias,
                  color: ColorsUi.darkCardColor,
                  child: Container(
                    height: size.height * .66,
                    width: size.width * 1,
                    child: ListView.builder(
                        itemCount: billAuth.balanceList.length,
                        itemBuilder: (context, index) {
                          DateTime t =
                              billAuth.balanceList[index].time.toDate();
                          return ListTile(
                              title: Text(
                                  'Recharged: ${billAuth.balanceList[index].amount}',
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: size.width * .040)),
                              trailing: Text(
                                  DateFormat.yMMMd().add_jm().format(t),
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: size.width * .025)));
                        }),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showDialog(BillingProvider operation) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            contentPadding: EdgeInsets.all(20),
            title: Text(
              'Enter Recharge Amount',style: TextStyle(fontSize: MediaQuery.of(context).size.width*.05),
              textAlign: TextAlign.center,
            ),
            content: Container(
              child: Form(
                key: _addKey,
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Enter balance'),
                      onSaved: (val) {
                        rechargeAmount = double.parse(val);
                      },
                      validator: (val) =>
                      val.isEmpty ? 'Enter balance' : null,
                      onChanged: (val){
                        setState(() {
                          rechargeAmount=double.parse(val);
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    AamarpayData(
                        returnUrl: (url) {
                          if(url=='https://sandbox.aamarpay.com/confirm'){
                            setState(() {
                              operation.balanceModel.amount=rechargeAmount;
                              operation.balanceModel.email=operation.billDetailList[0].email;
                              operation.balanceModel.guestId=widget.id;
                              operation.balanceModel.time=Timestamp.now();
                            });
                            operation.updateBalance(widget.id, rechargeAmount).then((value)async{
                              await operation.rechargeList(operation.balanceModel).then((value){
                                _showToast('Balance Recharged', ColorsUi.selectedDarkColor);
                              });
                            });
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                                  return HomePage();
                                }));
                          }
                        },
                        isLoading: (v) {
                          setState(() {
                            isLoading = true;
                          });
                        },
                        paymentStatus: (status) {
                          print(status);
                        },
                        cancelUrl: "/cancel",
                        successUrl: "/confirm",
                        failUrl: "/fail",
                        customerEmail: "haxbtx@gmail.com",
                        customerMobile: "01879419658",
                        customerName: "Samad",
                        signature: "e8a1bae1388b9f27ea1d62f9df3f4e37",
                        storeID: "Sharpshooter",
                        transactionAmount: "$rechargeAmount",
                        transactionID: widget.id+DateTime.now().millisecondsSinceEpoch.toString(),
                        url: "https://www.dropbox.com/s/h8uyfzmlppu4xbr/aamarPay-v4.1.0.zip?dl=0",
                        child: isLoading
                            ? Center(
                          child: CircularProgressIndicator(),
                        )
                            : Container(
                          color: ColorsUi.selectedDarkColor,
                          height: 50,
                          child: Center(
                              child: Text(
                                "Recharge",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, color: ColorsUi.darkCardColor),
                              )),
                        ))
                  ],
                ),
              ),
            ),
          );
        });
  }

  _showToast(String message, Color color) {
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

  Future<bool> _onBackPressed() async {
    Navigator.pop(context);
  }
}
