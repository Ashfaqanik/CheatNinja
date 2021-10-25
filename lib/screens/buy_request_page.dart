import 'package:cheat_ninja/providers/biling_provider.dart';
import 'package:cheat_ninja/screens/buy_request_details.dart';
import 'package:cheat_ninja/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';

class BuyRequestPage extends StatefulWidget {
  @override
  _BuyRequestPageState createState() => _BuyRequestPageState();
}

class _BuyRequestPageState extends State<BuyRequestPage> {
  bool _isLoading=false;
  @override
  Widget build(BuildContext context) {
    BillingProvider billAuth = Provider.of<BillingProvider>(context,listen: false);
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: ColorsUi.darkCardColor,
          leading: IconButton( icon: Icon(Icons.arrow_back_ios_sharp), onPressed: () {
            billAuth.getCounter().then((value){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                    return HomePage();
                  }));
            });
          }),
          toolbarHeight: size.height*.08,
          title: Text('Buy Requests',style: TextStyle(color: Colors.white70),),
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
    Size size = MediaQuery.of(context).size;
    BillingProvider operation =
    Provider.of<BillingProvider>(context);
    return Container(
      color: Theme.of(context).primaryColor,
      child: Align(
        alignment: Alignment.topCenter,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: operation.buyRequestList.length,
            itemBuilder: (_, index) {
              return InkWell(
                onTap: ()async{
                  setState(() {
                    _isLoading=true;
                  });
                  await operation.getRegisterdUser(operation.buyRequestList[index].guestId).then((value){
                    setState(() {
                      _isLoading=false;
                    });
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return BuyRequestDetails(
                          id: operation.buyRequestList[index].id,
                          url: operation.buyRequestList[index].url,
                          email: operation.buyRequestList[index].email,
                          guestId: operation.buyRequestList[index].guestId,
                          productName: operation.buyRequestList[index].name,
                          productPrice: operation.buyRequestList[index].price,);
                        }));
                  });
                },
                child: Card(
                  color: ColorsUi.darkCardColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Container(
                        width: size.width * 0.50,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                operation.buyRequestList[index].email!=null?'${operation.buyRequestList[index].email}':'Guest: ${operation.buyRequestList[index].guestId}',
                                maxLines: 2,
                                style: TextStyle(
                                    fontSize: size.width * .045,fontWeight: FontWeight.bold,
                                    color: ColorsUi.selectedDarkColor
                                )),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                                'Product: ${operation.buyRequestList[index].name}',
                                maxLines: 2,
                                style: TextStyle(
                                    fontSize: size.width * .040,
                                    color: Colors.white
                                )),
                            SizedBox(height: 4,),
                          ],
                        ),
                      ),
                      subtitle: Container(
                        child: Text(
                          'Price: ${operation.buyRequestList[index].price}',
                          style: TextStyle(fontSize: size.width * .030, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    BillingProvider billAuth = Provider.of<BillingProvider>(context,listen: false);
    billAuth.getCounter().then((value){
      Navigator.push(context,
          MaterialPageRoute(builder: (context) {
            return HomePage();
          }));
    });

  }
}
