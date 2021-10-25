import 'package:cheat_ninja/providers/notification_provider.dart';
import 'package:cheat_ninja/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class SendNotification extends StatefulWidget {
  @override
  _SendNotificationState createState() => _SendNotificationState();
}

class _SendNotificationState extends State<SendNotification> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int notifications = 5;
  bool _isLoading = false;
  void _initializeNotification(NotificationProvider auth) {
    auth.notificationModel.title = '';
    auth.notificationModel.message = '';
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<NotificationProvider>(builder: (context, auth, child)
    {
      if (auth.notificationModel.title == null ||
          auth.notificationModel.message == null) {
        _initializeNotification(auth);
      }
      return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
        centerTitle: true,
        backgroundColor: ColorsUi.darkCardColor,
        leading: IconButton( icon: Icon(Icons.arrow_back_ios_sharp), onPressed: () { Navigator.of(context).pop(); },),
        toolbarHeight: size.height*.08,
        title: Text('Send Notification',style: TextStyle(color: Colors.white70),),
      ),
        body: Stack(
          children: [
            _bodyUI(auth),
            _isLoading?Center(child: CircularProgressIndicator()):Container()
          ],
        ),
      );
    });
  }
  Widget _bodyUI(NotificationProvider auth) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Theme.of(context).primaryColor,
      height: size.height,
      child: SingleChildScrollView(
        child: Column(
          children: [
            ///Sent Notification Form...
            Form(
              child: Container(
                margin: EdgeInsets.only(left: 10, right: 10, top: 15),
                child: Column(
                  children: [
                    ///Sent Notification title
                    SizedBox(height: 15),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      maxLines: 2,
                      style: TextStyle(color: Colors.grey[400]),
                      decoration: InputDecoration(
                          labelText: "Title",
                          fillColor: Color(0xffF4F7F5),
                          labelStyle:
                          TextStyle(color: ColorsUi.selectedDarkColor)),
                      onChanged: (val){
                        setState(() {
                          auth.notificationModel.title = val;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    ///Notifications...
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: notifications,
                      style: TextStyle(color: Colors.grey[400]),
                      decoration: InputDecoration(
                          fillColor: Color(0xffF4F7F5),
                          labelText: "Notifications",
                          labelStyle:
                          TextStyle(color: ColorsUi.selectedDarkColor)),
                      onChanged: (String val) {
                        if (val.length >= 40) setState(() => notifications = 2);
                        if (val.length >= 80) setState(() => notifications = 4);
                        if (val.length >= 160) setState(() => notifications = 7);
                        if (val.length >= 300) setState(() => notifications = 11);
                        if (val.length >= 500) setState(() => notifications = 18);
                        setState(() {
                          auth.notificationModel.message = val;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    ///Submit Button...
                    GestureDetector(
                      onTap: (){
                        _checkValidity(auth);
                        //print(auth.notified);
                      },
                      child: Container(
                        height: size.height*.055,
                        width: size.width*.40,
                        decoration: BoxDecoration(
                          color: ColorsUi.selectedDarkColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                          child:Center(child: Text("Send Notification",style: TextStyle(color: Colors.grey[900],fontWeight: FontWeight.bold),)),
                      ),
                    ),
                    SizedBox(height: 20),

                  ],
                ),
              ),
            ),
            SizedBox(height: 10.0,),
          ],
        ),
      ),
    );
  }

  Future<void> _checkValidity(NotificationProvider auth) async {
    try {
      if (auth.notificationModel.title.toString().isNotEmpty &&
          auth.notificationModel.message.toString().isNotEmpty) {
        setState(() {
          _isLoading=true;
        });
        await auth.sendNotificaton(auth.notificationModel,context).then((value)async {
          auth.notificationModel = null;
        });
      } else
        _showToast('Complete all the required fields', ColorsUi.selectedDarkColor);
    } catch (error) {
      //showSnackBar(_scaffoldKey, error.toString());
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

