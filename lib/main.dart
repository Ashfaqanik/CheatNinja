import 'package:cheat_ninja/providers/biling_provider.dart';
import 'package:cheat_ninja/providers/category_provider.dart';
import 'package:cheat_ninja/providers/login_provider.dart';
import 'package:cheat_ninja/providers/notification_provider.dart';
import 'package:cheat_ninja/providers/product_provider.dart';
import 'package:cheat_ninja/screens/notification_details.dart';
import 'package:cheat_ninja/screens/splashScreen.dart';
import 'package:cheat_ninja/utils/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>(debugLabel:"navigator");
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialize();
  }

  void initialize(){
    _fcm.getInitialMessage();
    _fcm.subscribeToTopic('Notifications');
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        navigatorKey.currentState.push(MaterialPageRoute(builder: (context) => MyApp()));
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp was published!');

      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
     });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // final routeMessage= message.data['screen'];
      // print(routeMessage);
      if(message.data['screen']=='OPEN_PAGE1') {
        print('A new onMessageOpenedApp event was published!');
        navigatorKey.currentState.push(
            MaterialPageRoute(builder: (context) => NotificatonDetails(title: message.data['title'],)));
      }

    });

  }
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductProvider(),),
        ChangeNotifierProvider(create: (context) => LoginProvider(),),
        ChangeNotifierProvider(create: (context) => NotificationProvider(),),
        ChangeNotifierProvider(create: (context) => BillingProvider()),
        ChangeNotifierProvider(create: (context) => CategoryProvider()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Cheat Ninja',
        theme: ThemeData(
          primaryColor: ColorsUi.darkPrimaryColor,
        ),
        home: SplashScreen(),
      ),
    );
  }

}
