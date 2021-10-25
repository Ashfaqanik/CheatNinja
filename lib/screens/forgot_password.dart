import 'package:cheat_ninja/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ForgotPassWebView extends StatefulWidget {

  @override
  _ForgotPassWebViewState createState() => _ForgotPassWebViewState();
}

class _ForgotPassWebViewState extends State<ForgotPassWebView> {
  final _key = UniqueKey();
  bool isLoading=true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Reset Password',style: TextStyle(color: ColorsUi.selectedDarkColor),),
      //   centerTitle: true,
      //   elevation: 0.0,
      // ),
      body: Stack(
        children: <Widget>[
          WebView(
            key: _key,
            initialUrl: 'https://g2bulk.com/my-account-2/lost-password/',
            javascriptMode: JavascriptMode.unrestricted,
            onPageStarted: (finish) {
              setState(() {
                isLoading = false;
              });
            },
          ),
          isLoading ? Center( child: CircularProgressIndicator(),)
              : Stack(),
        ],
      ),
    );
  }

}

