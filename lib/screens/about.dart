import 'package:cheat_ninja/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: ColorsUi.darkCardColor,
        leading: IconButton( icon: Icon(Icons.arrow_back_ios_sharp), onPressed: () { Navigator.of(context).pop(); },),
        toolbarHeight: size.height*.08,
        title: Text('About G2Bulk',style: TextStyle(color: Colors.white70),),
      ),
      body: Container(
        height: size.height,
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text('G2Bulk is an online gift card, games and subscription purchase platform.'
    'Our target is to give everyone gift cards and e-games, apps at the lowest prices and fastest. Here you will find different types of gift cards, games, in-game purchase, subscription and many more gaming related items.'
    'G2Bulk can be your partner to easily buy your favorite games and gift cards or subscriptions easily from anywhere in the world connected to the Internet.\n\n'
    'G2Bulk - Believes to be affordable and fast..',style: TextStyle(color: ColorsUi.selectedDarkColor,fontWeight: FontWeight.w500,fontSize: 15),),
        ),
      ),
    );
  }
}
