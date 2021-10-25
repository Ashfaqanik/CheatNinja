import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FbWebview extends StatefulWidget {
  @override
  _FbWebviewState createState() => _FbWebviewState();
}

class _FbWebviewState extends State<FbWebview> {
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
            initialUrl: 'https://wa.me/message/QTTGVHIP3MQCC1',//'https://Facebook.com/mdsamadofficial',
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
