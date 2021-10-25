import 'dart:async';
import 'dart:io';
import 'package:cheat_ninja/providers/biling_provider.dart';
import 'package:cheat_ninja/providers/category_provider.dart';
import 'package:cheat_ninja/providers/login_provider.dart';
import 'package:cheat_ninja/utils/alert.dart';
import 'package:cheat_ninja/utils/colors.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'account.dart';
import 'package:device_id/device_id.dart';
import 'category_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isConnected = true;
  String _deviceid = 'Unknown';
  int _selectedIndex = 0;
  //static String id;
  static String niceName;
  static String userEmail;
  String search = '';
  //int notice;
  //static String Gid='';
  void _onItemTap(int index) {
    _checkPreferences();
    setState(() {
      _selectedIndex = index;
    });
    // if(id==null){
    //  // _Pref();
    //   _checkPreferences();
    // }

  }
  void _checkPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
      setState(() {
        //id = preferences.getString('id');
        niceName = preferences.get('name');
        userEmail = preferences.get('email');
        //notice = preferences.getInt('notice');
      });
    var operation = Provider.of<LoginProvider>(context,listen: false);
    if(niceName?.isNotEmpty == true){
      operation.isLogged=true;
    }else{

      operation.isLogged=false;

    }
    //print(operation.isLogged);
  }
  void _checkConnectivity() async {
    var result = await (Connectivity().checkConnectivity());
    if (result == ConnectivityResult.none) {
      setState(() => _isConnected = false);
      showSnackBar(_scaffoldKey, "No internet connection !");
    } else if (result == ConnectivityResult.mobile) {
      setState(() => _isConnected = true);
    } else if (result == ConnectivityResult.wifi) {
      setState(() => _isConnected = true);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CategoryProvider categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    categoryProvider.fetchData();
    initDeviceId();
    _checkPreferences();
    _checkConnectivity();
    //print(search);
  }

  Future<void> initDeviceId() async {
    BillingProvider billAuth = Provider.of<BillingProvider>(context, listen: false);
    String deviceid;

    deviceid = await DeviceId.getID;

    if (!mounted) return;

    setState(() {
      _deviceid = '$deviceid';
    });
    String mystring = _deviceid;


    for (int i=0;i<=5;i++){
      search += mystring[i];
    }
    setState(() {
      billAuth.userModel.id=search;
      billAuth.userModel.name='Guest';
    });
    billAuth.LoggedUsers(billAuth.userModel);
  }

  @override
  Widget build(BuildContext context) {
    Widget widget = Container(); // default
    switch (_selectedIndex) {
      case 0:
        widget = CategoryPage(email: userEmail,id: search,);
        break;

      // case 1:
      //   print(niceName);
      //
      //   widget = ChatPage(id: search,name: niceName,email: userEmail,);
      //   break;

      case 1:

        widget = Account(search);
        break;
    }
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: _isConnected?widget:_noInternetUI(),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_bag_outlined),
                  label: 'Product',
              ),
              // BottomNavigationBarItem(
              //     icon: Icon(Icons.chat_outlined),
              //     label: 'Chat',
              // ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: 'Account',
              ),
            ],
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            selectedItemColor: ColorsUi.selectedDarkColor,
            unselectedItemColor: ColorsUi.unselectedDarkColor,
            iconSize: MediaQuery.of(context).size.width*.07,
            onTap: _onItemTap,
            elevation: 5
        ),
      ),
    );
  }
  Future<bool> _onBackPressed() async {
    exit(0);
  }

  Widget _noInternetUI() {
    return Container(
      color: Theme.of(context).primaryColor,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/logo.png",
            height: 50,
            //width: 100,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 40),
          Icon(
            CupertinoIcons.wifi_exclamationmark,
            color: ColorsUi.selectedDarkColor,
            size: 150,
          ),
          Text(
            'No Internet Connection !',
            style: TextStyle(fontSize: 16, color: ColorsUi.selectedDarkColor),
          ),
          Text(
            'Connect your device with wifi or cellular data',
            style: TextStyle(fontSize: 15, color: Colors.grey[600]),
          ),
          SizedBox(height: 20),
          Text(
            "For emergency call 16263",
            style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          InkWell(
            onTap: () => _checkConnectivity(),
            splashColor: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: Container(
                width: MediaQuery.of(context).size.width * .25,
                child: miniOutlineIconButton(
                    context, 'Refresh', Icons.refresh, Colors.grey)),
          )
        ],
      ),
    );
  }
  Widget miniOutlineIconButton(
      BuildContext context, String buttonName,  IconData iconData, Color color) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: color),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(iconData,color: color,size: size.width*.04),
          SizedBox(width: 5),
          Text(
            buttonName,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: size.width*.03, color: color),
          ),
        ],
      ),
    );
  }
}
