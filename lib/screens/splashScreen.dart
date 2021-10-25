import 'dart:async';

import 'package:cheat_ninja/providers/biling_provider.dart';
import 'package:cheat_ninja/providers/category_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BillingProvider billAuth = Provider.of<BillingProvider>(context,listen: false);
    billAuth.getCounter();
  }
  @override
  Widget build(BuildContext context) {
    Timer(
        Duration(seconds: 2),
            () =>
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => HomePage())));
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      color: Theme.of(context).primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              height: size.height * .2,
              width: size.width * .28,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/ninja.gif"),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(5)),
              ),
        ],
      )
    );
  }
}
