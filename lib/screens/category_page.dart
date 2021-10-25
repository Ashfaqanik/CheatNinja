import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cheat_ninja/providers/biling_provider.dart';
import 'package:cheat_ninja/providers/category_provider.dart';
import 'package:cheat_ninja/providers/login_provider.dart';
import 'package:cheat_ninja/providers/notification_provider.dart';
import 'package:cheat_ninja/screens/payment_page.dart';
import 'package:cheat_ninja/screens/product_page.dart';
import 'package:cheat_ninja/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'balance_page.dart';
import 'buy_request_page.dart';
import 'notification_details.dart';

class CategoryPage extends StatefulWidget {

  String email,id;

  CategoryPage({this.email,this.id});
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  static List<Widget> noticeSliders;
  int notice = 0;
  static String niceName;

  void initState() {
    // TODO: implement initState
    var categoryList = Provider.of<CategoryProvider>(context, listen: false);
    var operation = Provider.of<NotificationProvider>(context, listen: false);
    BillingProvider billAuth = Provider.of<BillingProvider>(context,listen: false);
    // categoryList.resetStreams();
    // categoryList.fetchCategories();
    operation.getNotifications();
    billAuth.getCounter();
    billAuth.getRegisterdUser(widget.email);
    super.initState();
    _checkPreferences();
  }

  void _checkPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      notice = preferences.getInt('notice');
      niceName = preferences.get('name');
    });
    var operation = Provider.of<LoginProvider>(context,listen: false);
    if(niceName?.isNotEmpty == true){
      operation.isLogged=true;
    }else{

      operation.isLogged=false;
    }
  }
  @override
  Widget build(BuildContext context) {
    LoginProvider auth = Provider.of<LoginProvider>(context, listen: false);
    BillingProvider billAuth =
    Provider.of<BillingProvider>(context, listen: false);
    final size = MediaQuery.of(context).size;
    return Container(
      color: Theme.of(context).primaryColor,
      width: size.width * 1,
      child: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: Column(
          children: [
            widget.email!='admin@cheatninja.io'?Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: size.height * .045,
                    width: size.width * .24,
                    decoration: BoxDecoration(
                        color: ColorsUi.darkCardColor,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: ColorsUi.selectedDarkColor)),
                    child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Material(
                            color: ColorsUi.darkCardColor,
                            child: InkWell(
                              splashColor: Colors.grey,
                              onTap: () async {
                                _showToast("Please wait...", ColorsUi.selectedDarkColor);
                                auth.isLogged
                                    ? await billAuth
                                    .checkRegistered(widget.id)
                                    .then((value) async {
                                  billAuth.isRegistered
                                      ? await billAuth
                                      .getRegisterdUser(widget.id)
                                      .then((value) async{
                                    await billAuth.getRechargeList(widget.id).then((value){
                                      Navigator.push(context,
                                          MaterialPageRoute(
                                              builder: (context) {
                                                return BalancePage(widget.id);
                                              }));
                                    });

                                  })
                                      :Navigator.push(context,
                                      MaterialPageRoute(
                                          builder: (context) {
                                            return PaymentPage(
                                              email: widget.email,
                                              needBalance: true,
                                              id: widget.id,
                                            );
                                          }));
                                })
                                    : await billAuth
                                    .checkRegistered(widget.id)
                                    .then((value) async {
                                  billAuth.isRegistered
                                      ? await billAuth
                                      .getRegisterdUser(widget.id)
                                      .then((value) async{
                                    await billAuth.getRechargeList(widget.id).then((value){
                                      Navigator.push(context,
                                          MaterialPageRoute(
                                              builder: (context) {
                                                return BalancePage(widget.id);
                                              }));
                                    });

                                  })
                                      :Navigator.push(context,
                                      MaterialPageRoute(
                                          builder: (context) {
                                            return PaymentPage(
                                              email: '',
                                              needBalance: true,
                                              id: widget.id,
                                            );
                                          }));
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset('assets/dollar.png'),
                                  SizedBox(width: 5),
                                  Text('Balance',
                                      style: TextStyle(
                                          fontSize: size.width * .033,
                                          fontWeight: FontWeight.bold,
                                          color: ColorsUi.selectedDarkColor)),
                                ],
                              ),
                            ),
                          ),
                        )),
                  ),
                ],
              ),
            ):Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: ()async{
                      _showToast("Please wait...", ColorsUi.selectedDarkColor);
                      await billAuth.updateCounterToZero().then((value)async{
                        await billAuth.getBuyRequest().then((value){
                          Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (context) {
                                    return BuyRequestPage();
                                  }));
                        });

                      });

                    },
                    child: Container(
                      color: Theme.of(context).primaryColor,
                      height: 30,width: 30,
                      child: Stack(
                        children: [
                          Icon(Icons.notifications_active,size: 30,color: Colors.white70,),
                          billAuth.counterList[0].count!=0?Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              height: 16,width: 16,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,color: Colors.red
                              ),
                              child: Center(child: Text('${billAuth.counterList[0].count}',style: TextStyle(fontSize: 10,color: Colors.white),)),
                            ),
                          ):Container()
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            CarouselSlider(
              options: CarouselOptions(
                height: size.height * .055,
                aspectRatio: 16 / 9,
                viewportFraction: 0.9,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
              ),
              items: noticeSlider(context),
            ),
            Expanded(
              child: _categoryList(),
            ),
          ],
        ),
      ),
    );
  }
  Widget _categoryList() {
    return new Consumer<CategoryProvider>(
        builder: (context, categoryModel, child) {
          if (categoryModel.allCategories != null &&
              categoryModel.allCategories.length > 0) {
            return RefreshIndicator(
              onRefresh: ()async{
                categoryModel.resetStreams();
                categoryModel.fetchCategories();
              },
              child: GridView.builder(
                scrollDirection: Axis.vertical,
                physics: ClampingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 2.0,
                  mainAxisSpacing: 2.0,
                ),
                itemCount: categoryModel.categoryLength,
                itemBuilder: (BuildContext context, int index) {
                  var dta = categoryModel.allCategories[index];
                  return dta.image==null?Center(
                      child: InkWell(
                        onTap: ()async{
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return ProductPage(email: widget.email,id: widget.id,categoryId: dta.categoryId,categoryName: dta.categoryName,);
                              }));

                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                          child: Container(
                            //padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                              child: Image.network('https://i.stack.imgur.com/y9DpT.jpg')
                          ),
                        ),
                      )
                  ):Center(
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return ProductPage(email: widget.email,id: widget.id,categoryId: dta.categoryId,categoryName: dta.categoryName,);
                              }));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                          child: Container(
                            //padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                              child: Image.network(dta.image.src)
                          ),
                        ),
                      )
                  );
                },


              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        }
        );
  }



  noticeSlider(BuildContext context) {
    NotificationProvider operation = Provider.of<NotificationProvider>(context);
    return noticeSliders = operation.slidersList
        .map<Widget>((item) => Container(
      child: Container(
        margin: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
        height: MediaQuery.of(context).size.height * .055,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          child: InkWell(
            onTap: () async {
              await operation.getSliderNotification(item).then((value) {
                if (item == 'Join on WhatsApp') {
                  const url = 'https://wa.me/message/QTTGVHIP3MQCC1';
                  _launchURL(url);
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) {
                  //       return FbWebview();
                  //     }));
                } else if (item == 'Join now on our telegram channel') {
                  const url = 'https://t.me/g2bulk';
                  _launchURL(url);
                } else {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                        return NotificatonDetails(title: item);
                      }));
                }
              });
            },
            child: Container(
                decoration: BoxDecoration(
                    color: ColorsUi.darkCardColor,
                    borderRadius: BorderRadius.circular(6)),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .02,
                    ),
                    Icon(
                      Icons.notifications,
                      color: ColorsUi.selectedDarkColor,
                      size: MediaQuery.of(context).size.height * .03,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .02,
                    ),
                    item != 'Join on WhatsApp'
                        ? item != 'Join now on our telegram channel'
                        ? Text(item,
                        style: TextStyle(
                          color: ColorsUi.selectedDarkColor,
                          fontSize: MediaQuery.of(context)
                              .size
                              .height *
                              .02,
                        ))
                        : Text(item,
                        style: TextStyle(
                            decoration:
                            TextDecoration.underline,
                            color: ColorsUi.selectedDarkColor,
                            fontSize: MediaQuery.of(context)
                                .size
                                .height *
                                .02))
                        : Text(item,
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: ColorsUi.selectedDarkColor,
                            fontSize:
                            MediaQuery.of(context).size.height *
                                .02))
                  ],
                )),
          ),
        ),
      ),
    ))
        .toList();
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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
