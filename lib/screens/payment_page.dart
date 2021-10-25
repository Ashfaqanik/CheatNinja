import 'package:cheat_ninja/providers/biling_provider.dart';
import 'package:cheat_ninja/screens/balance_page.dart';
import 'package:cheat_ninja/screens/recharge_chat_page.dart';
import 'package:cheat_ninja/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class PaymentPage extends StatefulWidget {
  String email;
  bool needBalance;
  String id;


  PaymentPage({this.email,this.needBalance,this.id});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _initializedPatientData(BillingProvider billAuth){
    billAuth.billingDetails.firstName='';
    billAuth.billingDetails.lastName='';
    //billAuth.billingDetails.email='';
    //billAuth.billingDetails.country='';
  }
  @override

  @override
  Widget build(BuildContext context) {
    final BillingProvider billAuth=Provider.of<BillingProvider>(context);
    final size = MediaQuery.of(context).size;
    if(billAuth.billingDetails.firstName==null){
      _initializedPatientData(billAuth);}
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: ColorsUi.darkCardColor,
          leading: IconButton( icon: Icon(Icons.arrow_back_ios_sharp), onPressed: () { Navigator.of(context).pop(); },),
          toolbarHeight: size.height*.08,
          title: Text('Submit your Details',style: TextStyle(color: Colors.white70),),
        ),
      body: Stack(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            height: size.height,width: size.width,
            child: SingleChildScrollView(
              child: SizedBox(
              height: size.height*1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildText('First Name', 'Enter your FirstName',billAuth),
                            SizedBox(width: 10,),
                            _buildText('Last Name', 'Enter your LastName',billAuth),
                          ],
                        ),
                        //_buildText('Country/Region', 'Enter your Country/Region',billAuth),

                        Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                margin: EdgeInsets.only(top: 10),
                                decoration: BoxDecoration(border: Border.all(
                                    color: ColorsUi.selectedDarkColor)),
                                child: TextFormField(
                                  validator: (val) {
                                    if (val.isEmpty) {
                                      return 'Enter Email Address';
                                    } else {
                                      return null;
                                    }
                                  },
                                  //controller: TextEditingController()..text = widget.email,
                                  //initialValue: widget.email,
                                  style: TextStyle(color: Colors.grey,fontSize: size.height*.02),
                                  decoration: InputDecoration(
                                      labelText: 'Email Address..',
                                      labelStyle: TextStyle(color: ColorsUi.selectedDarkColor),
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (val){
                                    setState(() {
                                      billAuth.billingDetails.email=val;
                                    });
                                  },
                                ),
                              ),
                            )),
                        SizedBox(height: 10),
                        Container(
                            height: size.height*.07,
                            width: size.width*.94,
                            child: RaisedButton(
                              textColor: Colors.black,
                              color: ColorsUi.selectedDarkColor,
                              child: Text('Proceed',style: TextStyle(color: Colors.grey[400]),),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  _checkValidity(billAuth);
                                }
                              },
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          _isLoading?Center(child: CircularProgressIndicator()):Container()
        ],
      ),
    );
  }
  _buildText(String labelText,String errorText,BillingProvider billAuth){
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          margin: EdgeInsets.only(top: 10),
          child: TextFormField(
            validator: (val) {
              if (val.isEmpty) {
                return errorText;
              } else {
                return null;
              }
            },
            onChanged: (value) {
              setState(() {
                labelText=='First Name'?billAuth.billingDetails.firstName=value:
                billAuth.billingDetails.lastName=value;
                //labelText=='Country/Region'?billAuth.billingDetails.country=value:
              });
            },
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(4.0),
                border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid)),
                enabledBorder: const OutlineInputBorder(borderSide: const BorderSide(
                    color: Color(0xFF4A8789), width: 0.5,),),
                labelText: labelText,
                labelStyle: TextStyle(color: ColorsUi.selectedDarkColor)),
          ),
        ),
      ),
    );
  }

  Future<void>_checkValidity(BillingProvider billAuth)async{
    if(billAuth.billingDetails.firstName!=null && billAuth.billingDetails.lastName!=null //&& billAuth.billingDetails.country!=null &&
       && billAuth.billingDetails.email !=null){
      setState(() {
        _isLoading=true;
      });
      if(billAuth.billingDetails.balance==null){
        billAuth.billingDetails.balance=0.0;
      }
      setState(() {
        billAuth.billingDetails.guestId = widget.id;
      });
      print('abc');
      //billAuth.billingDetails.email=widget.email;
      bool result = await billAuth.registerUser(billAuth.billingDetails);
      print('abc');
      if(result) {
        setState(() {
          _isLoading = false;
        });
        _showToast('Your Details are saved', ColorsUi.selectedDarkColor);
        widget.needBalance ? await billAuth.getRegisterdUser(widget.id)
            .then((value) async{
          await billAuth.getRechargeList(widget.id).then((value){
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => BalancePage(widget.id)),
                    (Route<dynamic> route) => false);
          });
        }) :await billAuth.getRegisterdUser(widget.id)
            .then((value) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => RechargeChatPage(
                    sender: 'Admin',
                    user: billAuth.billDetailList[0].firstName + ' ' +
                        billAuth.billDetailList[0].lastName,
                    text: '', userEmail: billAuth.billDetailList[0].email,guestId: widget.id,)),
                  (Route<dynamic> route) => false);
        });
       }else{
        setState(() {
          _isLoading = false;
        });
        _showToast("Something went wrong", Colors.redAccent);
      }


    }else _showToast('Complete all the required fields', Colors.redAccent);
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

}
