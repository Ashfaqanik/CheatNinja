import 'package:cheat_ninja/providers/biling_provider.dart';
import 'package:cheat_ninja/screens/serial_code_page.dart';
import 'package:cheat_ninja/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class BuyPage extends StatefulWidget {
  String imageUrl, name,email,guestId;
      double price;

  BuyPage({this.imageUrl, this.name,this.email,this.guestId, this.price});

  @override
  _BuyPageState createState() => _BuyPageState();
}

class _BuyPageState extends State<BuyPage> {
  bool _isLoading=false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
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
          'Buy',
          style: TextStyle(color: Colors.white70),
        ),
      ),
      body: Stack(
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
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Center(
              child: Container(
                  height: size.height * .25,
                  width: size.width,
                  child: Image.network(widget.imageUrl)),
            ),
            SizedBox(
              height: 4,
            ),
            Text('${widget.name ?? ''}',
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
                Text('${'\$' + '${widget.price}' ?? 0}',
                    style: TextStyle(
                        fontSize: size.width * .033,
                        fontWeight: FontWeight.bold,
                        color: ColorsUi.selectedDarkColor)),
              ],
            ),
            SizedBox(height: 20),
            widget.email!='admin@cheatninja.io'?Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: (){
                    double balance=billAuth.billDetailList[0].balance-widget.price;
                   if(balance<0){
                     _showToast("Not enough balance to buy this product!", Colors.redAccent);
                   }else{
                     setState(() {
                       billAuth.purchaseModel.price=widget.price;
                       billAuth.purchaseModel.name=widget.name;
                       billAuth.purchaseModel.url= widget.imageUrl;
                       billAuth.purchaseModel.serialCode='';
                       billAuth.purchaseModel.email= widget.email==''?null:widget.email;
                       billAuth.purchaseModel.guestId=widget.guestId;
                       _isLoading=true;
                     });
                     billAuth.purchaseHistory(billAuth.purchaseModel).then((value){
                       //billAuth.deductBalance(widget.guestId, balance);
                       setState(() {
                         _isLoading=false;
                       });
                       Navigator.push(context,
                           MaterialPageRoute(builder: (context) {
                             return SerialCodePage(name: widget.name,);
                           }));
                     });
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
                          child: Text('Buy from balance',
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontSize: size.width * .035,
                                  fontWeight: FontWeight.bold,
                                  color: ColorsUi.darkCardColor)),
                        )),
                  ),
                ),
                // Container(
                //   height: size.height * .07,
                //   width: size.width * .32,
                //   decoration: BoxDecoration(
                //       color: Colors.blueGrey,
                //       borderRadius: BorderRadius.circular(5),
                //       border: Border.all(color: ColorsUi.selectedDarkColor)),
                //   child: Padding(
                //       padding: const EdgeInsets.all(5.0),
                //       child: Center(
                //         child: Text('Buy Via bitcoin',
                //             style: TextStyle(
                //                 decoration: TextDecoration.none,
                //                 fontSize: size.width * .035,
                //                 fontWeight: FontWeight.bold,
                //                 color: ColorsUi.darkCardColor)),
                //       )),
                // ),
              ],
            ):Container()
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
}
