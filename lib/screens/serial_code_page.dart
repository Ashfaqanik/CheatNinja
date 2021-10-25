import 'package:cheat_ninja/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class SerialCodePage extends StatefulWidget {
  String name;


  SerialCodePage({this.name});

  @override
  _SerialCodePageState createState() => _SerialCodePageState();
}

class _SerialCodePageState extends State<SerialCodePage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: ColorsUi.darkCardColor,
          leading: IconButton( icon: Icon(Icons.arrow_back_ios_sharp), onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => HomePage()),
                    (Route<dynamic> route) => false);
            }),
          toolbarHeight: size.height*.08,
          title: Text(widget.name,style: TextStyle(color: Colors.white70),),
        ),
        body: _bodyUi(),
      ),
    );
  }
  Widget _bodyUi(){
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      color: Theme.of(context).primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Your buy request has been sent...',style: TextStyle(color: ColorsUi.selectedDarkColor,fontSize: size.width*.052),),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('You will find your license key in \nyour purchase history after being approved..',style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }
  Future<bool> _onBackPressed(){
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage()),
            (Route<dynamic> route) => false);
  }
}
