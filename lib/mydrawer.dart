import 'package:flutter/material.dart';
import 'package:winfung_gate/loginscreen.dart';
import 'package:winfung_gate/mainscreen.dart';
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => BookingScreen(user: widget.user)));
            }),
            ListTile(
            title: Text("Purchase History"),
            leading: Icon(Icons.history,
                color: Theme.of(context).accentColor),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => MyPurchase(user: widget.user)));
            }),
        ListTile(
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
        ListTile(
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
}
