import 'package:cheat_ninja/providers/biling_provider.dart';
import 'package:cheat_ninja/screens/buy_request_page.dart';
import 'package:cheat_ninja/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class BuyRequestDetails extends StatefulWidget {
  String id,url,email,guestId,productName;
  double productPrice;


  BuyRequestDetails(
      {this.id,this.url,
      this.email,
      this.guestId,
      this.productName,
      this.productPrice});

  @override
  _BuyRequestDetailsState createState() => _BuyRequestDetailsState();
}

class _BuyRequestDetailsState extends State<BuyRequestDetails> {
  final _addKey = GlobalKey<FormState>();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: ColorsUi.darkCardColor,
        leading: IconButton( icon: Icon(Icons.arrow_back_ios_sharp), onPressed: () { Navigator.of(context).pop(); },),
        toolbarHeight: size.height*.08,
        title: Text('Buy Request',style: TextStyle(color: Colors.white70),),
      ),
      body:  Stack(
        children: [
          _bodyUi(),
          _isLoading?Center(child: CircularProgressIndicator()):Container()
        ],
      ),
    );
  }
  Widget _bodyUi() {
    BillingProvider billAuth =
    Provider.of<BillingProvider>(context, listen: false);
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Center(
              child: Container(
                  height: size.height * .25,
                  width: size.width,
                  child: Image.network(widget.url)),
            ),
            SizedBox(
              height: 4,
            ),
            widget.email==null? Text('Guest: ${widget.guestId}',
                style: TextStyle(
                    fontSize: size.width * .040,
                    fontWeight: FontWeight.bold,
                    color: ColorsUi.selectedDarkColor)):Text('User: ${widget.email}',
                style: TextStyle(
                    fontSize: size.width * .040,
                    fontWeight: FontWeight.bold,
                    color: ColorsUi.selectedDarkColor)),
            SizedBox(
              height: 4,
            ),
            Text('${widget.productName ?? ''}',
                style: TextStyle(
                    fontSize: size.width * .035,
                    fontWeight: FontWeight.normal,
                    color: ColorsUi.selectedDarkColor)),
            SizedBox(
              height: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.monetization_on_outlined,
                  color: ColorsUi.selectedDarkColor,
                  size: size.width * .050,
                ),
                SizedBox(width: 6),
                Text('${'\$' + '${widget.productPrice}' ?? 0}',
                    style: TextStyle(
                        fontSize: size.width * .033,
                        fontWeight: FontWeight.bold,
                        color: ColorsUi.selectedDarkColor)),
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Text('Current Balance: ${billAuth.billDetailList[0].balance ?? ''}',
                style: TextStyle(
                    fontSize: size.width * .035,
                    fontWeight: FontWeight.bold,
                    color: ColorsUi.selectedDarkColor)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: (){
                    _showRejectDialog(billAuth,widget.id,widget.guestId);
                  },
                  child: Container(
                    height: size.height * .07,
                    width: size.width * .32,
                    decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: ColorsUi.selectedDarkColor)),
                    child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Center(
                          child: Text('Reject',
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontSize: size.width * .031,
                                  fontWeight: FontWeight.bold,
                                  color: ColorsUi.darkCardColor)),
                        )),
                  ),
                ),
                InkWell(
                  onTap: (){
                    double balance=billAuth.billDetailList[0].balance-widget.productPrice;
                    if(balance<0){
                      _showToast("Not enough balance to buy this product!", Colors.redAccent);
                    }else{
                      _showDialog(billAuth,widget.id,widget.guestId,balance);
                    }
                  },
                  child: Container(
                    height: size.height * .07,
                    width: size.width * .32,
                    decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: ColorsUi.selectedDarkColor)),
                    child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Center(
                          child: Text('Provide License Key',
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontSize: size.width * .031,
                                  fontWeight: FontWeight.bold,
                                  color: ColorsUi.darkCardColor)),
                        )),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
  void _showToast(String message, Color color) {
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

  _showDialog(BillingProvider billAuth,String id,String userId,double amount) {
    String code;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: ColorsUi.darkCardColor,
            scrollable: true,
            contentPadding: EdgeInsets.all(20),
            title: Text(
              "Enter License key",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            content: Container(
              child: Form(
                key: _addKey,
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      maxLines: 2,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          hintText: 'Enter License Key',hintStyle: TextStyle(color: Colors.grey)),
                      onChanged: (val){
                        setState(() {
                          code=val;
                        });
                      },
                      validator: (val) =>
                      val.isEmpty ? 'please Enter License Key' : null,
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
                          color: ColorsUi.selectedDarkColor,
                          onPressed: () async{
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                                  return BuyRequestPage();
                                }));
                            if (_addKey.currentState.validate()){
                             await billAuth.updatePurchaseHistory(id, 'Sold', code).then((value)async{
                                await billAuth.deductBalance(userId, amount).then((value){
                                  _showToast('License key sold', ColorsUi.selectedDarkColor);
                                });
                              });
                            }
                          },
                          child: Text(
                            "Confirm",
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

  void _showRejectDialog(BillingProvider billAuth,String id,String userId) {
    showDialog(
      context: context,
      builder: (context) {
        Widget okButton = FlatButton(
          child:
          Text("YES", style: TextStyle(color: ColorsUi.selectedDarkColor)),
          onPressed: () async{
            Navigator.push(context,
                MaterialPageRoute(builder: (context) {
                  return BuyRequestPage();
                }));
            await billAuth.updatePurchaseHistory(id, 'Rejected', '').then((value){
              _showToast('Request rejected', ColorsUi.selectedDarkColor);
            });
          },
        );
        Widget noButton = FlatButton(
          child:
          Text("No", style: TextStyle(color: ColorsUi.selectedDarkColor)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        );
        AlertDialog alert = AlertDialog(
          backgroundColor: ColorsUi.darkCardColor,
          title: Text(
            "Are you sure you want to reject this buy request?",
            style: TextStyle(color: ColorsUi.selectedDarkColor),
          ),
          actions: [noButton, okButton],
        );
        return alert;
      },
    );
  }
}
