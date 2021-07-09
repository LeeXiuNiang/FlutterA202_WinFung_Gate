import 'package:flutter/material.dart';
import 'package:winfung_gate/loginscreen.dart';
import 'package:winfung_gate/mainscreen.dart';
import 'package:winfung_gate/mybooking.dart';
import 'package:winfung_gate/profilescreen.dart';

import 'bookingscreen.dart';
import 'messaging.dart';
import 'mypurchase.dart';
import 'user.dart';

class MyDrawer extends StatefulWidget {
  final User user;

  const MyDrawer({Key key, this.user}) : super(key: key);
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    checkAdmin();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountEmail: Text(widget.user.email),
          currentAccountPicture: CircleAvatar(
            backgroundColor:
                Theme.of(context).platform == TargetPlatform.android
                    ? Colors.white
                    : Colors.indigo,
            backgroundImage: AssetImage(
              "assets/images/profile.png",
            ),
          ),
          accountName: Text(widget.user.username),
        ),
        ListTile(
            title: Text("Products"),
            leading: Icon(Icons.shopping_bag_outlined,
                color: Theme.of(context).accentColor),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => MainScreen(user: widget.user)));
            }),
        ListTile(
            title: Text("Reparation Bookings"),
            leading: Icon(Icons.event_outlined,
                color: Theme.of(context).accentColor),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
              if (_isAdmin == true) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => MyBooking(user: widget.user)));
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) =>
                            BookingScreen(user: widget.user)));
              }
            }),
        ListTile(
            title: _isAdmin
                ? Text("Customer Order History")
                : Text("Purchase History"),
            leading: Icon(Icons.history, color: Theme.of(context).accentColor),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => MyPurchase(user: widget.user)));
            }),
        Visibility(
          visible: !_isAdmin,
          child: ListTile(
              title: Text("Contact Us"),
              leading: Icon(Icons.message_outlined,
                  color: Theme.of(context).accentColor),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) =>
                            MessagingScreen(user: widget.user)));
              }),
        ),
        Visibility(
          visible: !_isAdmin,
          child: ListTile(
              title: Text("My Profile"),
              leading: Icon(Icons.person_outline_outlined,
                  color: Theme.of(context).accentColor),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) =>
                            ProfileScreen(user: widget.user)));
              }),
        ),
        Divider(
          color: Colors.black87,
        ),
        ListTile(
            title: Text("Logout"),
            leading: Icon(
              Icons.logout,
              color: Theme.of(context).accentColor,
            ),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.pop(context);
              _logoutDialog();
            })
      ],
    ));
  }

  void _logoutDialog() {
    showDialog(
        builder: (context) => new AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                title: new Text(
                  'Do you want logout?',
                  style: TextStyle(),
                ),
                content: new Text(
                  'Are your sure?',
                  style: TextStyle(),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text("Yes",
                        style: TextStyle(color: Theme.of(context).accentColor)),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (content) => LoginScreen()));
                    },
                  ),
                  TextButton(
                      child: Text("No",
                          style:
                              TextStyle(color: Theme.of(context).accentColor)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ]),
        context: context);
  }

  void checkAdmin() {
    setState(() {
      if (widget.user.email == 'xnlee1999@gmail.com') {
        _isAdmin = true;
      }
    });
  }
}
