import 'dart:async';
import 'package:cheat_ninja/api/api_service.dart';
import 'package:cheat_ninja/providers/biling_provider.dart';
import 'package:cheat_ninja/screens/about.dart';
import 'package:cheat_ninja/screens/payment_page.dart';
import 'package:cheat_ninja/screens/purchase_history.dart';
import 'package:cheat_ninja/screens/recharge_chat_page.dart';
import 'Recharge_chat_List.dart';
import 'package:cheat_ninja/model/customer.dart';
import 'package:cheat_ninja/model/login_model.dart';
import 'package:cheat_ninja/providers/login_provider.dart';
import 'package:cheat_ninja/utils/colors.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'balance_recharge.dart';
import 'forgot_password.dart';
import 'notifications.dart';

class Account extends StatefulWidget {
  String id;

  Account(this.id);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  ApiService apiService;
  CustomerModel model;
  LoginModel lgModel;
  String username;
  String email;
  static String id;
  static String niceName;
  static String userEmail;
  String password;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiService = new ApiService();
    model = new CustomerModel();
    _checkPreferences();
  }

  @override
  Widget build(BuildContext context) {
    LoginProvider operation =
        Provider.of<LoginProvider>(context, listen: false);
    BillingProvider billAuth =
        Provider.of<BillingProvider>(context, listen: false);
    final size = MediaQuery.of(context).size;
    return Container(
      color: Theme.of(context).primaryColor,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListView(
              children: [
                Card(
                  margin: EdgeInsets.only(top: 40),
                  elevation: 2,
                  clipBehavior: Clip.antiAlias,
                  color: ColorsUi.darkCardColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Icon(Icons.account_circle,
                                      size: size.height * .08,
                                      color: Colors.grey[500]),
                                  SizedBox(
                                    width: size.width * .03,
                                  ),
                                  operation.isLogged
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('$niceName',
                                                style: TextStyle(
                                                    fontSize: size.width * .035,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                            SizedBox(
                                              height: size.height * .01,
                                            ),
                                            Container(
                                                color: Colors.grey[500],
                                                child: Text('$userEmail',
                                                    style: TextStyle(
                                                        fontSize:
                                                            size.width * .030,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black)))
                                          ],
                                        )
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Guest',
                                                style: TextStyle(
                                                    fontSize: size.width * .035,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                            SizedBox(
                                              height: size.height * .01,
                                            ),
                                            Container(
                                                color: Colors.grey[500],
                                                child: Text(
                                                    ' User ID: ${widget.id}',
                                                    style: TextStyle(
                                                        fontSize:
                                                            size.width * .035,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black)))
                                          ],
                                        ),
                                ],
                              ),
                            ),
                            operation.isLogged
                                ? GestureDetector(
                                    onTap: () {
                                      _showDialog();
                                    },
                                    child: Container(
                                      height: size.height * .06,
                                      width: size.width * .28,
                                      decoration: BoxDecoration(
                                          color: ColorsUi.darkCardColor,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                              color:
                                                  ColorsUi.selectedDarkColor)),
                                      child: Center(
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text('LogOut',
                                                  style: TextStyle(
                                                      fontSize:
                                                          size.width * .033,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: ColorsUi
                                                          .selectedDarkColor)))),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      _signIn();
                                    },
                                    child: Container(
                                      height: size.height * .06,
                                      width: size.width * .28,
                                      decoration: BoxDecoration(
                                          color: ColorsUi.darkCardColor,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                              color:
                                                  ColorsUi.selectedDarkColor)),
                                      child: Center(
                                          child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text('Sign In/Sign Up',
                                            style: TextStyle(
                                                fontSize: size.width * .033,
                                                fontWeight: FontWeight.bold,
                                                color: ColorsUi
                                                    .selectedDarkColor)),
                                      )),
                                    ),
                                  )
                          ],
                        ),
                        Divider(color: Colors.grey[500]),
                        InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return Notifications(userEmail);
                            }));
                          },
                          child: Container(
                            width: size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.notifications,
                                  color: Colors.grey[500],
                                  size: size.width * .045,
                                ),
                                SizedBox(
                                  width: size.width * .02,
                                ),
                                Text('Notifications',
                                    style: TextStyle(
                                        fontSize: size.width * .038,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey[500]))
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * .009,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: size.height * .04),
                Divider(color: Colors.grey[500]),
                Material(
                  color: Theme.of(context).primaryColor,
                  child: userEmail == 'admin@cheatninja.io'
                      ? InkWell(
                          onTap: () async {
                            setState(() {
                              _isLoading=true;
                            });
                            await billAuth.getAllChatUser().then((value) {
                              setState(() {
                                _isLoading=false;
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          RechargeChatList()));
                            });
                          },
                          child: ListTile(
                            title: Text('Recharge Requests',
                                style: TextStyle(
                                    fontSize: size.width * .044,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white)),
                            trailing: Icon(Icons.arrow_forward_ios,
                                color: Colors.grey[600],
                                size: size.height * .025),
                          ),
                        )
                      : Material(
                          color: Theme.of(context).primaryColor,
                          child: InkWell(
                            splashColor: Colors.grey,
                            onTap: () {
                              setState(() {
                                _isLoading=true;
                              });
                              billAuth.getPurchaseHistory(widget.id).then((value){
                                setState(() {
                                  _isLoading=false;
                                });
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PurchaseHistory(email: userEmail,)));
                              });
                            },
                            child: ListTile(
                              title: Text('Purchase history',
                                  style: TextStyle(
                                      fontSize: size.width * .044,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white)),
                              trailing: Icon(Icons.arrow_forward_ios,
                                  color: Colors.grey[600],
                                  size: size.height * .025),
                            ),
                          ),
                        ),
                ),
                Divider(color: Colors.grey[500]),
                Material(
                  color: Theme.of(context).primaryColor,
                  child: userEmail != 'admin@cheatninja.io'
                      ? Material(
                          color: Theme.of(context).primaryColor,
                          child: InkWell(
                              splashColor: Colors.grey,
                              onTap: () async {
                                setState(() {
                                  _isLoading = true;
                                });
                                await billAuth
                                        .checkRegistered(widget.id)
                                        .then((value) async {
                                        billAuth.isRegistered
                                            ? await billAuth
                                                .getRegisterdUser(widget.id)
                                                .then((value) {
                                                setState(() {
                                                  _isLoading = false;
                                                });
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            RechargeChatPage(
                                                              sender: 'Admin',
                                                              user: billAuth
                                                                      .billDetailList[0].firstName +
                                                                  ' ' +
                                                                  billAuth
                                                                      .billDetailList[
                                                                          0]
                                                                      .lastName,
                                                              text: '',
                                                              userEmail: billAuth.billDetailList[0].email,
                                                              opponentEmail: 'admin@cheatninja.io',
                                                              guestId: widget.id,
                                                            )));
                                              })
                                            : _navigateToPaymentPage();
                                      });
                              },
                              child: ListTile(
                                title: Text('Chat with Admin',
                                    style: TextStyle(
                                        fontSize: size.width * .044,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white)),
                                trailing: Icon(Icons.arrow_forward_ios,
                                    color: Colors.grey[600],
                                    size: size.height * .025),
                              )),
                        )
                      : InkWell(
                          onTap: () {
                            setState(() {
                              _isLoading=true;
                            });
                            billAuth.getAllPurchaseHistory().then((value){
                              setState(() {
                                _isLoading=false;
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PurchaseHistory(email: userEmail,)));
                            });
                          },
                          child: ListTile(
                            title: Text('Purchase history',
                                style: TextStyle(
                                    fontSize: size.width * .044,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white)),
                            trailing: Icon(Icons.arrow_forward_ios,
                                color: Colors.grey[600],
                                size: size.height * .025),
                          ),
                        ),
                ),
                Divider(color: Colors.grey[500]),
                Material(
                  color: Theme.of(context).primaryColor,
                  child: ListTile(
                    title: Text('What\'s New',
                        style: TextStyle(
                            fontSize: size.width * .044,
                            fontWeight: FontWeight.normal,
                            color: Colors.white)),
                    trailing: Icon(Icons.arrow_forward_ios,
                        color: Colors.grey[600], size: size.height * .025),
                  ),
                ),
                Divider(color: Colors.grey[500]),
                Material(
                  color: Theme.of(context).primaryColor,
                  child: userEmail != 'admin@cheatninja.io'
                      ?null
                  //ListTile(
                    // title: Text('Language',
                    //     style: TextStyle(
                    //         fontSize: size.width * .044,
                    //         fontWeight: FontWeight.normal,
                    //         color: Colors.white)),
                    // trailing: Icon(Icons.arrow_forward_ios,
                    //     color: Colors.grey[600], size: size.height * .025),
                  //)
                  :InkWell(
                    onTap: () async {
                      setState(() {
                        _isLoading=true;
                      });
                      await billAuth.getAllChatUser().then((value){
                        setState(() {
                          _isLoading=false;
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    BalanceRecharge()));
                      });
                    },
                    child: ListTile(
                      title: Text('Recharge Users Balance',
                          style: TextStyle(
                              fontSize: size.width * .044,
                              fontWeight: FontWeight.normal,
                              color: Colors.white)),
                      trailing: Icon(Icons.arrow_forward_ios,
                          color: Colors.grey[600], size: size.height * .025),
                    ),
                  ),
                ),
                userEmail == 'admin@cheatninja.io'?Divider(color: Colors.grey[500]):Container(),
                Material(
                  color: Theme.of(context).primaryColor,
                  child: ListTile(
                    title: Text('Check For Updates',
                        style: TextStyle(
                            fontSize: size.width * .044,
                            fontWeight: FontWeight.normal,
                            color: Colors.white)),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey[600],
                      size: size.height * .025,
                    ),
                  ),
                ),
                Divider(color: Colors.grey[500]),
                Material(
                  color: Theme.of(context).primaryColor,
                  child: InkWell(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  About()));
                    },
                    child: ListTile(
                      title: Text('About G2Bulk',
                          style: TextStyle(
                              fontSize: size.width * .044,
                              fontWeight: FontWeight.normal,
                              color: Colors.white)),
                      trailing: Icon(Icons.arrow_forward_ios,
                          color: Colors.grey[600], size: size.height * .025),
                    ),
                  ),
                ),
                Divider(color: Colors.grey[500]),
              ],
            ),
          ),
          _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container()
        ],
      ),
    );
  }

  void _signIn() {
    LoginProvider operation = Provider.of<LoginProvider>(context, listen: false);
    BillingProvider billAuth = Provider.of<BillingProvider>(context, listen: false);
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: 0.9,
            child: Container(
                color: Theme.of(context).primaryColor,
                child: Form(
                  key: _formKey,
                  child: ListView(children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.highlight_remove,
                          color: ColorsUi.selectedDarkColor,
                        )),
                    SizedBox(
                      height: 60,
                    ),
                    Center(
                        child: Text(
                      'Welcome to G2Bulk!',
                      style: TextStyle(
                          color: ColorsUi.selectedDarkColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 25),
                    )),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'Enter your Username or Email address';
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {
                          username = value;
                        },
                        style: TextStyle(color: Colors.grey[400]),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'UserName/Email Address',
                            labelStyle:
                                TextStyle(color: ColorsUi.selectedDarkColor)),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextFormField(
                        obscureText: true,
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'Enter your Password';
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {
                          password = value;
                        },
                        style: TextStyle(color: Colors.grey[400]),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                            labelStyle:
                                TextStyle(color: ColorsUi.selectedDarkColor)),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FlatButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                                  return ForgotPassWebView();
                                }));
                          },
                          textColor: ColorsUi.selectedDarkColor,
                          child: Text(
                            'Forgot Password',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Container(
                        height: 50,
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: RaisedButton(
                          textColor: Colors.black,
                          color: ColorsUi.selectedDarkColor,
                          child: Text('Sign In'),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              Navigator.pop(context);
                              setState(() {
                                _isLoading = true;
                              });
                              if (username == 'Samad'  &&
                                  password == '01879419658S' ||
                                  username == 'samad' &&
                                      password == '01879419658S'||
                                  username == 'admin@cheatninja.io' &&
                                      password == '01879419658S') {
                                _Pref(
                                    widget.id, 'Admin', 'admin@cheatninja.io');
                                startTimer();
                              } else {
                                apiService
                                    .loginCustomer(username, password)
                                    .then((ret) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  if (ret.statusCode == 200) {
                                    operation.isLogged = true;
                                    _checkPreferences();
                                    _showToast("Login successful",
                                        ColorsUi.selectedDarkColor);
                                    print(ret.data.nicename);
                                    setState(() {
                                      billAuth.userModel.id=ret.data.email;
                                      billAuth.userModel.name=ret.data.nicename;
                                    });
                                    billAuth.LoggedUsers(billAuth.userModel);
                                    _Pref(widget.id, ret.data.nicename,
                                        ret.data.email);
                                    _checkPreferences();
                                  } else {
                                    _showToast(
                                        "Invalid login", Colors.redAccent);
                                  }
                                });
                              }
                            }
                          },
                        )),
                    Container(
                        child: Row(
                      children: <Widget>[
                        Text(
                          'Don\'t have account?',
                          style: TextStyle(color: ColorsUi.selectedDarkColor),
                        ),
                        FlatButton(
                          textColor: ColorsUi.selectedDarkColor,
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            _signUp();
                          },
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ))
                  ]),
                )),
          );
        });
  }

  void _signUp() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: 0.9,
            child: Container(
                color: Theme.of(context).primaryColor,
                child: Form(
                  key: _formKey2,
                  child: ListView(children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.highlight_remove,
                          color: ColorsUi.selectedDarkColor,
                        )),
                    SizedBox(
                      height: 60,
                    ),
                    Center(
                        child: Text(
                      'Welcome to G2Bulk!',
                      style: TextStyle(
                          color: ColorsUi.selectedDarkColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 25),
                    )),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextFormField(
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'Enter your Username';
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {
                          this.model.username = value;
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Username',
                            labelStyle:
                                TextStyle(color: ColorsUi.selectedDarkColor)),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        onChanged: (value) {
                          this.model.email = value;
                        },
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'Enter your Email address';
                          } else if (!EmailValidator.validate(val)) {
                            return 'Please enter a valid email address';
                          } else {
                            return null;
                          }
                        },
                        style: TextStyle(color: Colors.grey[400]),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                            labelStyle:
                                TextStyle(color: ColorsUi.selectedDarkColor)),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: TextFormField(
                        obscureText: true,
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'Enter your Password';
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {
                          this.model.password = value;
                        },
                        style: TextStyle(color: Colors.grey[400]),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                            labelStyle:
                                TextStyle(color: ColorsUi.selectedDarkColor)),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        height: 50,
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: RaisedButton(
                          textColor: Colors.black,
                          color: ColorsUi.selectedDarkColor,
                          child: Text('Sign Up'),
                          onPressed: () async {
                            if (_formKey2.currentState.validate()) {
                              Navigator.pop(context);
                              setState(() {
                                _isLoading = true;
                              });
                              apiService.createCustomer(model).then((ret) {
                                setState(() {
                                  _isLoading = false;
                                });
                                if (ret) {
                                  _showToast("Registration successful",
                                      ColorsUi.selectedDarkColor);
                                } else {
                                  _showToast("Email id already registered",
                                      Colors.redAccent);
                                }
                              });
                            }
                          },
                        )),
                    Container(
                        child: Row(
                      children: <Widget>[
                        Text(
                          'Already Registered?',
                          style: TextStyle(color: ColorsUi.selectedDarkColor),
                        ),
                        FlatButton(
                          textColor: ColorsUi.selectedDarkColor,
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                                fontSize: 15,
                                decoration: TextDecoration.underline),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            _signIn();
                          },
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ))
                  ]),
                )),
          );
        });
  }

  void _showToast(String message, Color color) {
    setState(() {
      _isLoading = false;
    });
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

  void _Pref(String id, String niceName, String email) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    //pref.setString('name', id);
    pref.setString('name', niceName);
    pref.setString('email', email);
  }

  void _checkPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      //id = preferences.getString('id');
      niceName = preferences.getString('name');
      userEmail = preferences.getString('email');
    });
  }

  void startTimer() {
    LoginProvider operation =
        Provider.of<LoginProvider>(context, listen: false);
    Timer.periodic(const Duration(seconds: 2), (t) {
      setState(() {
        _isLoading = false;
      });
      operation.isLogged = true;
      _checkPreferences();
      _showToast("Login successful", ColorsUi.selectedDarkColor);
      t.cancel(); //stops the timer
    });
  }

  void _showDialog() {
    LoginProvider operation =
        Provider.of<LoginProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) {
        Widget okButton = FlatButton(
          child:
              Text("YES", style: TextStyle(color: ColorsUi.selectedDarkColor)),
          onPressed: () {
            Navigator.pop(context);
            _Pref(widget.id, '', '');
            operation.isLogged = false;
            _checkPreferences();
          },
        );
        Widget noButton = FlatButton(
          child:
              Text("No", style: TextStyle(color: ColorsUi.selectedDarkColor)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        );
        AlertDialog alert = AlertDialog(
          backgroundColor: ColorsUi.darkCardColor,
          title: Text(
            "Are you sure you want to log out?",
            style: TextStyle(color: ColorsUi.selectedDarkColor),
          ),
          actions: [noButton, okButton],
        );
        return alert;
      },
    );
  }

  void _navigateToPaymentPage() {
    setState(() {
      _isLoading = false;
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PaymentPage(
                  email: '',
                  needBalance: false,
              id: widget.id,
                )));
  }

  // void _resetPassDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       Widget okButton = FlatButton(
  //         child:
  //         Text("Confirm", style: TextStyle(color: ColorsUi.selectedDarkColor)),
  //         onPressed: () {
  //           if (_formKey3.currentState.validate()) {
  //             Navigator.pop(context);
  //             setState(() {
  //               _isLoading = true;
  //             });
  //             apiService.resetPassword(resetEmail).then((ret) {
  //               setState(() {
  //                 _isLoading = false;
  //               });
  //               if (ret) {
  //                 _showToast(
  //                     "Reset Password link has been sent to your email..}",
  //                     ColorsUi.selectedDarkColor);
  //               } else {
  //                 _showToast("Something went wrong!",
  //                     Colors.redAccent);
  //               }
  //             });
  //           }
  //         },
  //       );
  //       Widget noButton = FlatButton(
  //         child:
  //         Text("Cancel", style: TextStyle(color: ColorsUi.selectedDarkColor)),
  //         onPressed: () {
  //           Navigator.of(context).pop();
  //         },
  //       );
  //       AlertDialog alert = AlertDialog(
  //         backgroundColor: ColorsUi.darkCardColor,
  //         title: Form(
  //           key: _formKey3,
  //           child: Column(
  //             children: [
  //               Text(
  //                 "Reset Password",
  //                 style: TextStyle(color: ColorsUi.selectedDarkColor),
  //               ),
  //               Container(
  //                 padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
  //                 child: TextFormField(
  //                   validator: (val) {
  //                     if (val.isEmpty) {
  //                       return 'Enter your Email Address';
  //                     } else {
  //                       return null;
  //                     }
  //                   },
  //                   onChanged: (value) {
  //                     setState(() {
  //                       resetEmail = value;
  //                     });
  //                   },
  //                   style: TextStyle(color: Colors.white),
  //                   decoration: InputDecoration(
  //                       border: OutlineInputBorder(),
  //                       labelText: 'Email Address',
  //                       labelStyle:
  //                       TextStyle(color: ColorsUi.selectedDarkColor)),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         actions: [noButton, okButton],
  //       );
  //       return alert;
  //     },
  //   );
  // }
}
