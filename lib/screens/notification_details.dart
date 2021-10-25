import 'package:cheat_ninja/providers/notification_provider.dart';
import 'package:cheat_ninja/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificatonDetails extends StatefulWidget {
  String title;


  NotificatonDetails({this.title});

  @override
  _NotificatonDetailsState createState() => _NotificatonDetailsState();
}

class _NotificatonDetailsState extends State<NotificatonDetails> {
  bool _isLoading=true;
  void _initializeNotification(NotificationProvider auth) {
    auth.notificationModel.title = '';
    auth.notificationModel.message = '';
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     var operation =Provider.of<NotificationProvider>(context,listen: false);
      operation.getSliderNotification(widget.title).then((value){
        setState(() {
          _isLoading=false;
        });
      });
    }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    NotificationProvider auth = Provider.of<NotificationProvider>(context);
    if (auth.notificationModel.title == null ||
        auth.notificationModel.message == null) {
      _initializeNotification(auth);
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: ColorsUi.darkCardColor,
        leading: IconButton( icon: Icon(Icons.arrow_back_ios_sharp), onPressed: () { Navigator.of(context).pop(); },),
        toolbarHeight: size.height*.08,
        title: Text('Notification Details',style: TextStyle(color: Colors.white70)),
      ),
      body: Container(
        color: Theme.of(context).primaryColor,
        width: size.width * 1,
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: _isLoading?Center(child: CircularProgressIndicator()):_bodyUI(),
        ),
      ),
    );
  }
  Widget _bodyUI(){
    NotificationProvider operation =
    Provider.of<NotificationProvider>(context);
    final size = MediaQuery.of(context).size;
    return Container(
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 6),
            Text('Title: ${widget.title}',style: TextStyle(
                color: ColorsUi.selectedDarkColor,fontWeight: FontWeight.bold,fontSize: size.width * .050)),
            SizedBox(height: 10,),
            Text('Date: ${operation.sliderNotificationList[0].date}',style: TextStyle(
                color: ColorsUi.selectedDarkColor,fontSize: size.width * .030)),
            Divider(color: Colors.grey[500]),
            Text(operation.sliderNotificationList[0].message,style: TextStyle(
                color: Colors.white,fontSize: size.width * .040)),
          ],
        ),
      ),
    );
  }
}
