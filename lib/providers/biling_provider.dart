import 'package:cheat_ninja/model/balance_model.dart';
import 'package:cheat_ninja/model/billing_details_model.dart';
import 'package:cheat_ninja/model/chat_user_model.dart';
import 'package:cheat_ninja/model/counter_model.dart';
import 'package:cheat_ninja/model/purchase_history_model.dart';
import 'package:cheat_ninja/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class BillingProvider extends ChangeNotifier{
  BillingDetailsModel _billingDetails =BillingDetailsModel();
  List<BillingDetailsModel> _billDetailList= <BillingDetailsModel>[];
  BalanceModel _balanceModel =BalanceModel();
  List<BalanceModel> _balanceList= <BalanceModel>[];
  PurchaseHistoryModel _purchaseModel =PurchaseHistoryModel();
  List<PurchaseHistoryModel> _purchaseList= <PurchaseHistoryModel>[];
  List<CounterModel> _counterList= <CounterModel>[];
  List<PurchaseHistoryModel> _buyRequestList= <PurchaseHistoryModel>[];
  UserModel _userModel =UserModel();
  List<UserModel> _userList= <UserModel>[];
  List<ChatUserModel> _chatUserList= <ChatUserModel>[];
  bool _isRegistered = false;
  String path;
  //final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  get billingDetails=>_billingDetails;
  get billDetailList=> _billDetailList;
  get balanceModel=>_balanceModel;
  get balanceList=> _balanceList;
  get purchaseModel=>_purchaseModel;
  get purchaseList=> _purchaseList;
  get buyRequestList=> _buyRequestList;
  get userModel=>_userModel;
  get counterList=>_counterList;
  get userList=> _userList;
  get chatUserList=> _chatUserList;
  get isRegistered => _isRegistered;

  set billingDetails(BillingDetailsModel model){
    model=BillingDetailsModel();
    _billingDetails=model;
    notifyListeners();
  }
  set balanceModel(BalanceModel model){
    model=BalanceModel();
    _balanceModel=model;
    notifyListeners();
  }
  set purchaseModel(PurchaseHistoryModel model){
    model=PurchaseHistoryModel();
    _purchaseModel=model;
    notifyListeners();
  }

  set isRegistered(bool val) {
    _isRegistered = val;
    notifyListeners();
  }
  set userModel(UserModel model){
    model=UserModel();
    _userModel=model;
    notifyListeners();
  }
  Future<void>getCounter()async{
    try{
      await FirebaseFirestore.instance.collection('Counter').get().then((snapShot){
        _counterList.clear();
        snapShot.docChanges.forEach((element) {
          CounterModel count=CounterModel(
           count: element.doc['count']
          );
          _counterList.add(count);
        });
      });
      notifyListeners();
    }catch(error){
      print(error.toString());
    }
  }
  Future<void> updateCounter()async{
    await getCounter().then((value) async{
      await FirebaseFirestore.instance.collection('Counter').doc('12345').update({
        'count': _counterList[0].count + 1
      });
    });

  }
  Future<void> updateCounterToZero()async{
    await FirebaseFirestore.instance.collection('Counter').doc('12345').update({
      'count': 0
    });
  }

  Future<void> checkRegistered(String id)async{
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Users')
        .where('guestId', isEqualTo: id).get();
    final List<QueryDocumentSnapshot> user = snapshot.docs;
    if(user.isEmpty){
      isRegistered=false;
    }else{
      isRegistered=true;
    }
    notifyListeners();
  }

  Future<bool>registerUser(BillingDetailsModel billingDetails) async{
    try {
      final String id=billingDetails.guestId.trim();
      await FirebaseFirestore.instance.collection('Users').doc(id).set({
        'id': id,
        'guestId': billingDetails.guestId,
        'firstName': billingDetails.firstName,
        'lastName': billingDetails.lastName,
        'email': billingDetails.email,
        'balance': billingDetails.balance,
        //'country': billingDetails.country,
      });
      return true;
    }
    catch(e){
      return false;
    }
  }

  Future<bool>LoggedUsers(UserModel userDetails) async{
    //String fcmToken = "eKA7Q0dDS1mJZosp7InmIK:APA91bG5BpiTxo00mfThsEPpgnjbjsrEWQr-4obSE_oREFeTB0L8xb-WuENlYnHkzN7bfgKowZOi2r6MczpcH5nw5u9sKSQNaNuLoHrhYcbSw6tsVHM4ptq8E6yBWHWN7GEpuY7a2qIf";//await _fcm.getToken();
    final String id=userDetails.id;
    // final tokenRef = FirebaseFirestore.instance.collection('LoggedUsers')
    //     .doc(userDetails.id)
    //     .collection('tokens')
    //     .doc(fcmToken);
    // await tokenRef.set(
    //   TokenModel(token: fcmToken, createdAt: FieldValue.serverTimestamp())
    //       .toJson(),
    // );
    try {
      await FirebaseFirestore.instance.collection('LoggedUsers').doc(id).set({
        'id': id,
        'name': userDetails.name,
      });
      return true;
    }
    catch(e){
      return false;
    }
  }

  Future<void> getRegisterdUser(String id)async{
    try{
      await FirebaseFirestore.instance.collection('Users').where('guestId',isEqualTo: id).get().then((snapShot){
        _billDetailList.clear();
        snapShot.docChanges.forEach((element) {
          BillingDetailsModel bills=BillingDetailsModel(
            id: element.doc['id'],
            guestId: element.doc['guestId'],
            firstName: element.doc['firstName'],
            lastName: element.doc['lastName'],
            email: element.doc['email'],
            balance: element.doc['balance'],
            //country: element.doc['country'],
          );
          _billDetailList.add(bills);
        });
      });
      notifyListeners();
    }catch(error){
      print(error.toString());
    }
  }

  Future<void>updateSeen(String senderEmail,String opponentEmail,)async{
    final refUsers3 = FirebaseFirestore.instance.collection('chatUsers');
    senderEmail!='admin@cheatninja.io'?await refUsers3.doc(senderEmail+'admin@cheatninja.io').update({
      'isSeen': true
    }):await refUsers3.doc(opponentEmail+'admin@cheatninja.io').update({

      'isSeen': true
    });


  }

  Future<void> uploadMessage( String message,String senderEmail,String sender,String opponentEmail,String user,String guestId) async {


    final refMessages1 = FirebaseFirestore.instance.collection('rechargeChats/$senderEmail admin@cheatninja.io/messages');
    final refMessages2 = FirebaseFirestore.instance.collection('rechargeChats/$opponentEmail admin@cheatninja.io/messages');
    final refUsers = FirebaseFirestore.instance.collection('chatUsers');


    senderEmail!='admin@cheatninja.io'?await refMessages1.add({
      'text': message,
      'senderEmail': senderEmail,
      'sender': senderEmail!='admin@cheatninja.io'?sender:'Admin',
      "timestamp": Timestamp.now(),
    }).then((value)async{
      await refUsers.doc(senderEmail+'admin@cheatninja.io').set({
        'id' : senderEmail,
        'userName' : sender,
        'guestId' : guestId,
        'lastMessage' : message,
        'lastMessageTime': Timestamp.now(),
        'isSeen': false
      });

    })
      :await refMessages2.add({
      'text': message,
      'senderEmail': senderEmail,
      'sender': senderEmail!='admin@cheatninja.io'?sender:'Admin',
      "timestamp": Timestamp.now(),
    }).then((value)async{
     await refUsers.doc(opponentEmail+'admin@cheatninja.io').set({
        'id' : opponentEmail,
        'userName' : user,
        'guestId' : guestId,
        'lastMessage' : 'You: '+ message,
        'lastMessageTime': Timestamp.now(),
       'isSeen': false});
    });
    notifyListeners();

  }

  Future<bool> getAllChatUser()async{
    try{
      await FirebaseFirestore.instance.collection('chatUsers').orderBy('lastMessageTime',descending: true).get().then((snapShot){
        _chatUserList.clear();
        snapShot.docChanges.forEach((element) {
          ChatUserModel chatUsers=ChatUserModel(
            id: element.doc['id'],
            userName: element.doc['userName'],
            guestId: element.doc['guestId'],
            lastMessage: element.doc['lastMessage'],
            lastMessageTime: element.doc['lastMessageTime'],
            isSeen:element.doc['isSeen']
          );
          _chatUserList.add(chatUsers);
        });
        return _chatUserList;
      });
      notifyListeners();
    }catch(error){
      print(error.toString());
    }
  }


  Future<void> updateBalance(String id,double amount)async{
    await getRegisterdUser(id).then((value) {
      FirebaseFirestore.instance.collection('Users').doc(id).update({
        'balance': _billDetailList[0].balance + amount
      });
    });
  }
  Future<void> deductBalance(String id,double amount)async{
    await getRegisterdUser(id).then((value) {
      FirebaseFirestore.instance.collection('Users').doc(id).update({
        'balance': amount
      });
    });
  }

  Future<void> rechargeList(BalanceModel balanceModel)async{
    try {

      final String id=DateTime.now().millisecondsSinceEpoch.toString();
      await FirebaseFirestore.instance.collection('RechargeList').doc(id).set({
        'amount': balanceModel.amount,
        'email': balanceModel.email,
        'guestId': balanceModel.guestId,
        'time': balanceModel.time
      });
      return true;
    }
    catch(e){
      return false;
    }
  }

  Future<void> getRechargeList(String id)async{
    try{

      await FirebaseFirestore.instance.collection('RechargeList').orderBy('time',descending: true).where('guestId',isEqualTo: id).get().then((snapShot){
        _balanceList.clear();
        snapShot.docChanges.forEach((element) {
          BalanceModel balances=BalanceModel(
            amount: element.doc['amount'],
            email: element.doc['email'],
            guestId: element.doc['guestId'],
            time: element.doc['time']

          );
          _balanceList.add(balances);
        });
      });
      notifyListeners();
    }catch(error){
      print(error.toString());
    }
  }

  Future<void> purchaseHistory(PurchaseHistoryModel model)async{
    final id = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();
    final timestamp = Timestamp.now();
    try {
      await FirebaseFirestore.instance.collection('PurchaseHistory').doc(id).set({
        'id': id,
        'name': model.name,
        'price': model.price,
        'url':model.url,
        'serialCode': model.serialCode,
        'email': model.email,
        'state':'Processing',
        'guestId':model.guestId,
        'timeStamp':timestamp
      }).then((value)async{
        updateCounter();
        await FirebaseFirestore.instance.collection('BuyRequest').doc(id).set({
          'id': id,
          'name': model.name,
          'price': model.price,
          'url': model.url,
          'serialCode': model.serialCode,
          'email': model.email,
          'guestId':model.guestId,
          'timeStamp':timestamp
        });
      });
      return true;
    }
    catch(e){
      return false;
    }
  }

  Future<bool> getAllPurchaseHistory()async{
    try{
      await FirebaseFirestore.instance.collection('PurchaseHistory').orderBy('timeStamp',descending: true).get().then((snapShot){
        _purchaseList.clear();
        snapShot.docChanges.forEach((element) {
          PurchaseHistoryModel purchases=PurchaseHistoryModel(
            id: element.doc['id'],
            price: element.doc['price'],
            url: element.doc['url'],
            name: element.doc['name'],
            serialCode: element.doc['serialCode'],
            email: element.doc['email'],
            state: element.doc['state'],
            guestId: element.doc['guestId'],
            timeStamp: element.doc['timeStamp']
          );
          _purchaseList.add(purchases);
        });
        return _purchaseList;
      });
      notifyListeners();
    }catch(error){
      print(error.toString());
    }
  }

  Future<bool> getPurchaseHistory(String id)async{
    try{
      await FirebaseFirestore.instance.collection('PurchaseHistory').where('guestId',isEqualTo: id).get().then((snapShot){
        _purchaseList.clear();
        snapShot.docChanges.forEach((element) {
          PurchaseHistoryModel purchases=PurchaseHistoryModel(
              id: element.doc['id'],
              price: element.doc['price'],
              url: element.doc['url'],
              name: element.doc['name'],
              serialCode: element.doc['serialCode'],
              email: element.doc['email'],
              state: element.doc['state'],
              guestId: element.doc['guestId'],
              timeStamp: element.doc['timeStamp']
          );
          _purchaseList.add(purchases);
        });
        return _purchaseList;
      });
      notifyListeners();
    }catch(error){
      print(error.toString());
    }
  }
  Future<bool> getBuyRequest()async{
    try{
      await FirebaseFirestore.instance.collection('BuyRequest').orderBy('timeStamp',descending: true).get().then((snapShot){
        _buyRequestList.clear();
        snapShot.docChanges.forEach((element) {
          PurchaseHistoryModel requests=PurchaseHistoryModel(
              id: element.doc['id'],
              price: element.doc['price'],
              url: element.doc['url'],
              name: element.doc['name'],
              serialCode: element.doc['serialCode'],
              email: element.doc['email'],
              guestId: element.doc['guestId'],
              timeStamp: element.doc['timeStamp']
          );
          _buyRequestList.add(requests);
          print(_buyRequestList.length);
        });
        return _purchaseList;
      });
      notifyListeners();
    }catch(error){
      print(error.toString());
    }
  }
  Future<void> updatePurchaseHistory(String id,String state,String code)async{
   await FirebaseFirestore.instance.collection('PurchaseHistory').doc(id).update({
        'state': state,
        'serialCode':code
      }).then((value)async{
     await FirebaseFirestore.instance.collection('BuyRequest').doc(id).delete().then((value) {
         getBuyRequest();
       });
   });
  }
}