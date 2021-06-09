import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'mainscreen.dart';
import 'registrationscreen.dart';
import 'user.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  SharedPreferences prefs;
  double screenHeight, screenWidth;
  ProgressDialog pr;

  @override
  void initState() {
    loadPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context);
    pr.style(
      message: 'Login...',
      borderRadius: 5.0,
      backgroundColor: Colors.white,
      progressWidget: Container(
          height: 20,
          width: 20,
          margin: EdgeInsets.all(10),
          child: CircularProgressIndicator()),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
    );

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: WillPopScope(
        onWillPop: _onBackPressed,
        child: Center(
            child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  margin: EdgeInsets.fromLTRB(60, 30, 60, 10),
                  child: Image.asset('assets/images/logo.png')),
              SizedBox(
                height: 5,
              ),
              Card(
                margin: EdgeInsets.fromLTRB(30, 5, 30, 15),
                elevation: 10,
                //color: Colors.indigo[50],
                shadowColor: Colors.indigo[900],
                shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Text('Login',
                          style: Theme.of(context).textTheme.headline1),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 50,
                        child: TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            labelText: "Email",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            prefixIcon: Icon(Icons.email),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: 50,
                        child: TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: "Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            prefixIcon: Icon(Icons.lock),
                          ),
                          obscureText: true,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Checkbox(
                              value: _rememberMe,
                              checkColor: Colors.white,
                              activeColor: Theme.of(context).accentColor,
                              onChanged: (bool value) {
                                _onChanged(value);
                              }),
                          Text("Remember Me",
                              style: Theme.of(context).textTheme.headline2)
                        ],
                      ),
                      MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          minWidth: 170,
                          height: 50,
                          child: Text(
                            'Login',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: _onLogin,
                          color: Theme.of(context).accentColor),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                child: Text("Register New Account",
                    style: TextStyle(fontSize: 16)),
                onTap: _registerNewUser,
              ),
              SizedBox(
                height: 5,
              ),
              GestureDetector(
                child: Text("Forgot Password", style: TextStyle(fontSize: 16)),
                onTap: _forgotPassword,
              )
            ],
          ),
        )),
      ),
    );
  }

  _onLogin() async {
    String _email = _emailController.text.toString();
    String _password = _passwordController.text.toString();

    if (_email.isEmpty || _password.isEmpty) {
      Fluttertoast.showToast(
          msg: "Email/password is empty",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent[700],
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }

    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    await pr.show();

    http.post(
        Uri.parse(
            "https://www.crimsonwebs.com/s272033/winfunggate/php/login_user.php"),
        body: {"email": _email, "password": _password}).then((response) {
      print(response.body);
      if (response.body == "failed") {
        Fluttertoast.showToast(
            msg: "Login Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Theme.of(context).accentColor,
            textColor: Colors.white,
            fontSize: 16.0);
        pr.hide().then((isHidden) {
          print(isHidden);
        });
        
      } else {

        Fluttertoast.showToast(
            msg: "Login Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Theme.of(context).accentColor,
            textColor: Colors.white,
            fontSize: 16.0);
        List userdata = response.body.split(",");
        User user = User(
            email: _email,
            password: _password,
            username: userdata[1],
            datereg: userdata[2],
            );
        pr.hide().then((isHidden) {
          print(isHidden);
        });
        Navigator.push(
            context, MaterialPageRoute(builder: (content) => MainScreen(user: user)));

        
      }
    });
  }

  void _registerNewUser() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => RegistrationScreen()));
  }

  void _forgotPassword() {
    TextEditingController _useremailcontroller = new TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Forgot Your Password?"),
            content: new Container(
              height: 100,
              width: 300,
              child: Column(
                children: [
                  Text("Enter your recovery email"),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: 50,
                    child: TextField(
                      controller: _useremailcontroller,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text("Submit",
                    style: TextStyle(color: Theme.of(context).accentColor)),
                onPressed: () {
                  _resetPassword(_useremailcontroller.text);
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text("Cancel",
                    style: TextStyle(color: Theme.of(context).accentColor)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _onChanged(bool value) {
    String _email = _emailController.text.toString();
    String _password = _passwordController.text.toString();

    if (_email.isEmpty || _password.isEmpty) {
      Fluttertoast.showToast(
          msg: "Email/password is empty",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent[700],
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }

    setState(() {
      _rememberMe = value;
      storePref(value, _email, _password);
    });
  }

  Future<void> storePref(bool value, String email, String password) async {
    prefs = await SharedPreferences.getInstance();
    if (value) {
      await prefs.setString("email", email);
      await prefs.setString("password", password);
      await prefs.setBool("rememberme", value);
      Fluttertoast.showToast(
          msg: "Preferences stored",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Theme.of(context).accentColor,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    } else {
      await prefs.setString("email", "");
      await prefs.setString("password", "");
      await prefs.setBool("rememberme", value);
      Fluttertoast.showToast(
          msg: "Preferences removed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Theme.of(context).accentColor,
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {
        _emailController.text = "";
        _passwordController.text = "";
        _rememberMe = false;
      });
      return;
    }
  }

  Future<void> loadPref() async {
    prefs = await SharedPreferences.getInstance();
    String _email = prefs.getString("email") ?? '';
    String _password = prefs.getString("password") ?? '';
    _rememberMe = prefs.getBool("rememberme") ?? false;

    setState(() {
      _emailController.text = _email;
      _passwordController.text = _password;
    });
  }

  void _resetPassword(String emailreset) {
    if (emailreset.isEmpty) {
      Fluttertoast.showToast(
          msg: "Email is empty",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent[700],
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }

    http.post(
        Uri.parse(
            "https://www.crimsonwebs.com/s272033/winfunggate/php/forgot_password.php"),
        body: {"email": emailreset}).then((response) {
      print(response.body);
      if (response.body == "success") {
        Fluttertoast.showToast(
            msg:
                "Password reset completed. Please check your email for further instruction",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Theme.of(context).accentColor,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Reset Password Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Theme.of(context).accentColor,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: new Text(
              'Do you want to exit this app?',
              style: TextStyle(),
            ),
            content: new Text(
              'Are your sure?',
              style: TextStyle(),
            ),
            actions: <Widget>[
              MaterialButton(
                  onPressed: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  child: Text(
                    "Yes",
                    style: TextStyle(color: Theme.of(context).accentColor),
                  )),
              MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "No",
                    style: TextStyle(color: Theme.of(context).accentColor),
                  )),
            ],
          ),
        ) ??
        false;
  }
}
