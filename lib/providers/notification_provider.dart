import 'package:cheat_ninja/model/notification_model.dart';
import 'package:cheat_ninja/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationProvider extends ChangeNotifier{
  NotificationModel _notificationModel = NotificationModel();
  List<NotificationModel> _notificationList = <NotificationModel>[];
  List<NotificationModel> _sliderNotificationList = <NotificationModel>[];
  List<String> _slidersList = [];
  List<String> _sliders = [];
  bool _notified = true;
  get notified => _notified;
  get notificationModel => _notificationModel;
  get notificationList => _notificationList;
  get slidersList => _slidersList;
  get sliders => _sliders;
  get sliderNotificationList => _sliderNotificationList;

  set notified(bool val) {
    _notified = val;
    notifyListeners();
  }

  set notificationModel(NotificationModel notifiModel) {
    notifiModel = NotificationModel();
    _notificationModel = notifiModel;
    notifyListeners();
  }

  Future<bool> sendNotificaton(NotificationModel notificationModel, BuildContext context) async {
    final id = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();
    String date = DateFormat("dd-MMM-yyyy/hh:mm:aa").format(DateTime.
    fromMicrosecondsSinceEpoch(DateTime
        .now()
        .microsecondsSinceEpoch));
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    try {
      FirebaseFirestore.instance.collection('Notifications').doc(id).set({
        'id': id,
        'title': notificationModel.title,
        'message': notificationModel.message,
        'date': date,
        'timestamp': timestamp
      }).then((value) async {
        notificationModel = null;
        await getNotifications().then((value) {
          Navigator.pop(context);
          _showToast('Notification Sent', ColorsUi.selectedDarkColor);
        });
      }, onError: (error) {
        Navigator.pop(context);
        _showToast('Error sending notification. Try again', ColorsUi.selectedDarkColor);
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> getNotifications()async{
    _slidersList.add('Join on WhatsApp');
    _slidersList.add('Join now on our telegram channel');
    try{
      await FirebaseFirestore.instance.collection('Notifications').orderBy('timestamp',descending: true).get().then((snapshot) {
        _notificationList.clear();
        snapshot.docChanges.forEach((element) {
          NotificationModel notifications = NotificationModel(
            id: element.doc['id'],
            title: element.doc['title'],
            message: element.doc['message'],
            date: element.doc['date'],
          );
          _notificationList.add(notifications);
          _sliders.add(notifications.title);
        });
        _slidersList.add(_sliders.first);
        _slidersList.add(_sliders.skip(1).first);
        _slidersList.add(_sliders.skip(2).first);
          //print(_slidersList.length);

      });
      notifyListeners();
    }catch(error){
      print(error.toString());
    }
  }

  Future<void> getSliderNotification(String title)async{
    try{
      await FirebaseFirestore.instance.collection('Notifications').where('title',isEqualTo: title).get().then((snapShot){
        _sliderNotificationList.clear();
        snapShot.docChanges.forEach((element) {
          NotificationModel notices=NotificationModel(
            id: element.doc['id'],
            title: element.doc['title'],
            message: element.doc['message'],
            date: element.doc['date']
          );
          _sliderNotificationList.add(notices);
          //print(element.doc['avgReviewStar']);
        });
      });
      notifyListeners();
    }catch(error){
      print(error.toString());
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