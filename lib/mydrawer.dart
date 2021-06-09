import 'package:flutter/material.dart';
import 'package:winfung_gate/loginscreen.dart';

import 'user.dart';
 
 
class MyDrawer extends StatefulWidget {
  final User user;

  const MyDrawer({Key key, this.user}) : super(key: key);
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer > {
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
            title: Text("Bookings"),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.pop(context);
            }),
        ListTile(
            title: Text("Messaging"),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.pop(context);
            }),
        ListTile(
            title: Text("My Profile"),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.pop(context);
            }),
        Divider(color: Colors.black87,),
        ListTile(
            title: Text("Logout"),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.pop(context);

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => LoginScreen(
                            
                          )));
            })
      ],
    ));
  }
}