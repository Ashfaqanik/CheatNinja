import 'package:cheat_ninja/providers/biling_provider.dart';
import 'package:cheat_ninja/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PurchaseHistory extends StatefulWidget {
  String email;

  PurchaseHistory({this.email});

  @override
  _PurchaseHistoryState createState() => _PurchaseHistoryState();
}

class _PurchaseHistoryState extends State<PurchaseHistory> {
  @override
  Widget build(BuildContext context) {
    BillingProvider billAuth =
    Provider.of<BillingProvider>(context, listen: false);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: ColorsUi.darkCardColor,
        leading: IconButton( icon: Icon(Icons.arrow_back_ios_sharp), onPressed: () { Navigator.of(context).pop(); },),
        toolbarHeight: size.height*.08,
        title: Text('Purchase History',style: TextStyle(color: Colors.white70),),
      ),
      body: Container(
        color: Theme.of(context).primaryColor,
        height: size.height ,
        width: size.width * 1,
        child: Align(
          alignment: Alignment.topCenter,
          child: ListView.builder(
            shrinkWrap: true,
            reverse: widget.email!='admin@cheatninja.io'?true:false,
              itemCount: billAuth.purchaseList.length,
              itemBuilder: (context, index) {
                DateTime t =
                billAuth.purchaseList[index].timeStamp.toDate();
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Card(
                    elevation: 2,
                    clipBehavior: Clip.antiAlias,
                    color: ColorsUi.darkCardColor,
                    child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            widget.email=='admin@cheatninja.io'?billAuth.purchaseList[index].email!=null?Text(
                                'Email: ${billAuth.purchaseList[index].email}',
                                style: TextStyle(
                                    color: ColorsUi.selectedDarkColor,
                                    fontSize: size.width * .040)):Text(
                                'Guest: ${billAuth.purchaseList[index].guestId}',
                                style: TextStyle(
                                    color: ColorsUi.selectedDarkColor,
                                    fontSize: size.width * .040)):SizedBox(height: 1),
                            SizedBox(height: 3,),
                            Text(
                                'Product: ${billAuth.purchaseList[index].name}',
                                style: TextStyle(
                                    color: ColorsUi.selectedDarkColor,
                                    fontSize: size.width * .040)),
                          ],
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 3,),
                                Text(
                                    'Price: ${billAuth.purchaseList[index].price}',
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: size.width * .030)),
                                SizedBox(height: 3,),
                                billAuth.purchaseList[index].state=='Sold'?Text(
                                    'Serial Code:  ${billAuth.purchaseList[index].serialCode}',
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: size.width * .030))
                                    :billAuth.purchaseList[index].state=='Processing'?Text(
                                    'Processing..',
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: size.width * .030)):Container(),
                                SizedBox(height: 3,),
                                billAuth.purchaseList[index].state=='Sold'?Text(
                                    'Sold',
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: size.width * .030)):billAuth.purchaseList[index].state=='Rejected'?Text(
                                    'Rejected',
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: size.width * .030)):Container()
                              ],
                            ),
                            billAuth.purchaseList[index].state=='Sold'?TextButton(onPressed: (){
                              Clipboard.setData(new ClipboardData(text: '${billAuth.purchaseList[index].serialCode}'));
                              _showToast('Code Copied', Colors.grey);
                            }, child: Text('Copy',style: TextStyle(fontSize: 10),)):Container()
                          ],
                        ),
                        trailing: Text(
                            DateFormat.yMMMd().add_jm().format(t),
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: size.width * .025))),
                  ),
                );
              }),
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
}
