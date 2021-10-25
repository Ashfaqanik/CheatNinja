import 'package:cheat_ninja/providers/biling_provider.dart';
import 'package:cheat_ninja/providers/notification_provider.dart';
import 'package:cheat_ninja/providers/product_provider.dart';
import 'package:cheat_ninja/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'buy_page.dart';

class ProductPage extends StatefulWidget {
  String email,id,categoryName;
    int categoryId;

  ProductPage({this.email,this.id,this.categoryId,this.categoryName});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  bool _isLoading=true;
  @override
  void initState() {
    // TODO: implement initState
    var productList = Provider.of<ProductProvider>(context, listen: false);
    var operation = Provider.of<NotificationProvider>(context, listen: false);
    productList.resetStreams();
    productList.fetchProducts(widget.categoryId).then((value) {
      setState(() {
        _isLoading=false;
      });
    });
    operation.getNotifications();
    //billAuth.getRegisterdUser(widget.email);
    //print(operation.notificationList.length);
    super.initState();
    //print(auth.isLogged);
  }

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
        title: Text(widget.categoryName,style: TextStyle(color: Colors.white70),),
      ),
      body: Container(
        color: Theme.of(context).primaryColor,
        width: size.width * 1,
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: _isLoading?Center(child: CircularProgressIndicator()):_productList(billAuth),
        ),
      ),
    );
  }

  Widget _productList(BillingProvider billAuth) {
    final size = MediaQuery.of(context).size;
    return new Consumer<ProductProvider>(
        builder: (context, productModel, child) {
      if (productModel.allProducts != null &&
          productModel.allProducts.length > 0) {
        return RefreshIndicator(
          onRefresh: () async {
            productModel.fetchProducts(widget.categoryId);
          },
          child: ListView.builder(
              padding: EdgeInsets.only(top: 8),
              //shrinkWrap: true,
              itemCount: productModel.productLength,
              itemBuilder: (context, index) {
                var dta = productModel.allProducts[index];
                return dta.images.isNotEmpty
                    ? Card(
                        margin: EdgeInsets.only(
                            left: 10.0, right: 10.0, bottom: 10.0),
                        elevation: 2,
                        color: ColorsUi.darkCardColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                  height: size.height * .25,
                                  width: size.width,
                                  child: Image.network(
                                    dta.images[0].src,
                                  ) //:Text('')
                                  ),
                            ),
                            SizedBox(
                              height: size.height * .01,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.network(dta.images[0].src,
                                          height: size.height * .05),
                                      SizedBox(width: 5),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              '${dta.name ?? ''}',
                                              style: TextStyle(
                                                  fontSize: size.width * .035,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.grey[300])),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                            'Published on ' + dta.dateCreated ??
                                                '',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: size.width * .029),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    //mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.monetization_on_outlined,
                                        color: Colors.grey[300],
                                        size: size.width * .060,
                                      ),
                                      SizedBox(width: 6),
                                      Text('${'\$' + dta.price ?? ''}',
                                          style: TextStyle(
                                              fontSize: size.width * .033,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[300])),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: size.height * .01,
                            ),
                            Center(
                              child: InkWell(
                                onTap: () async{
                                  _showToast('Please wait..', ColorsUi.selectedDarkColor);
                                  await billAuth.getRegisterdUser(widget.id).then((value){
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                          return BuyPage(imageUrl: dta.images[0].src,name: dta.name,email:widget.email,guestId: widget.id,price: double.parse(dta.price));
                                        }));
                                  });
                                },
                                child: Container(
                                  height: size.height * .06,
                                  width: size.width * .9,
                                  decoration: BoxDecoration(
                                      color: Color(0xFF5FB6B9),
                                      borderRadius: BorderRadius.circular(2)),
                                  child: Center(
                                      child: Text('Buy Now',
                                          style: TextStyle(
                                              fontSize: size.width * .045,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.white70))),
                                ),
                              ),
                            ),
                            SizedBox(height: size.height * .013),
                          ],
                        ),
                      )
                    : null;
              }),
        );
      }
      return Center(child: Text('No Products!',style: TextStyle(decoration: TextDecoration.none,color: ColorsUi.selectedDarkColor,fontSize: size.width*.08),));
    });
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
