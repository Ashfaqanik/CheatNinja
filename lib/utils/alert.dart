import 'package:flutter/material.dart';

  void showSnackBar(GlobalKey<ScaffoldState> scaffoldKey,message) {
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message,
            style: TextStyle(color: Colors.white), textAlign: TextAlign.center),
        backgroundColor: Colors.deepOrange,
        elevation: 0,
      ),
    );
  }