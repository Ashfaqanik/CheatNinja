import 'package:cheat_ninja/providers/notification_provider.dart';
import 'package:cheat_ninja/screens/send_notification.dart';
import 'package:cheat_ninja/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'notification_details.dart';

class Notifications extends StatefulWidget {
  String email;

  Notifications(this.email);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
 int counter =0;
 bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    NotificationProvider operation =
    Provider.of<NotificationProvider>(context);
    if(counter==0){
      operation.getNotifications();
      _isLoading=false;
      counter++;
    }
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: ColorsUi.darkCardColor,
        leading: IconButton( icon: Icon(Icons.arrow_back_ios_sharp), onPressed: () { Navigator.of(context).pop(); },),
        toolbarHeight: size.height*.08,
        title: Text('Notifications',style: TextStyle(color: Colors.white70),),
      ),
      body: Stack(
        children: [
          _bodyUI(),
          _isLoading?Center(child: CircularProgressIndicator()):Container()
        ],
      ),
      floatingActionButton: widget.email=='admin@cheatninja.io'?FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF5FB6B9),
        tooltip: 'Send Notification',
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) {
                return SendNotification();
              }));
        },
      ):null,
    );
  }
  Widget _bodyUI() {
    Size size = MediaQuery.of(context).size;
    NotificationProvider operation =
    Provider.of<NotificationProvider>(context);

    return RefreshIndicator(
      backgroundColor: Colors.white,
      onRefresh: ()=>operation.getNotifications(),
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Align(
          alignment: Alignment.topCenter,
          child: ListView.builder(
            shrinkWrap: true,
              itemCount: operation.notificationList.length,
              itemBuilder: (_, index) {
                return InkWell(
                  onTap: ()async{
                    _showToast('Please wait..', ColorsUi.selectedDarkColor);
                    await operation.getSliderNotification(operation.notificationList[index].title).then((value){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return NotificatonDetails(title: operation.notificationList[index].title);
                          }));
                    });
                  },
                  child: Card(
                    color: ColorsUi.darkCardColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Container(
                          width: size.width * 0.50,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  operation.notificationList[index].title,
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontSize: size.width * .045,fontWeight: FontWeight.bold,
                                      color: Colors.white
                                  )),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                  operation.notificationList[index].message,
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontSize: size.width * .040,
                                      color: Colors.white
                                  )),
                              SizedBox(height: 4,),
                            ],
                          ),
                        ),
                        subtitle: Container(
                          child: Text(
                            operation.notificationList[index].date,
                            style: TextStyle(fontSize: size.width * .030, color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
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
