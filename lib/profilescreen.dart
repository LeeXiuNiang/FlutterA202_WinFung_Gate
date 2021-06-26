import 'package:flutter/material.dart';
import 'package:winfung_gate/mydrawer.dart';
import 'package:winfung_gate/user.dart';
 
 
class ProfileScreen extends StatefulWidget {
  final User user;

  const ProfileScreen({Key key, this.user}) : super(key: key);
  
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: Text('My Profile'),
        ),
        drawer: MyDrawer(user: widget.user), 
        body: Center(
          child: Container(
            child: Text('my profile'),
          ),
        ),
      
    );
  }
}