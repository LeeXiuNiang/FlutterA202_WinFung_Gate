import 'package:flutter/material.dart';
import 'package:winfung_gate/mybooking.dart';
import 'package:winfung_gate/newbooking.dart';

import 'mydrawer.dart';
import 'user.dart';
 

 
class BookingScreen extends StatefulWidget {
  final User user;

  const BookingScreen({Key key, this.user}) : super(key: key);
  
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int _currentIndex = 0;
  List<Widget> tabchildren;
  String maintitle = "Bookings";

  @override
  void initState() {
    super.initState();
    tabchildren = [NewBooking(user: widget.user), MyBooking(user: widget.user)];
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.grey[300],
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.indigo[900],
          unselectedItemColor: Colors.indigo[900].withOpacity(.60),
          selectedFontSize: 14,
          unselectedFontSize: 14,
          currentIndex: _currentIndex, 
          onTap: onTabTapped,
                    items: [
                      BottomNavigationBarItem(
                        label: 'New Booking',
                        icon: Icon(Icons.add_circle),
                      ),
                      BottomNavigationBarItem(
                        label: 'My Bookings',
                        icon: Icon(Icons.event_note),
                      ),
                    ]),
                appBar: AppBar(
                  title: Text('Reparation Bookings'),
                ),
                drawer: MyDrawer(user: widget.user),
                body:tabchildren[_currentIndex],
              );
            }
          
              void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (_currentIndex == 0) {
        maintitle = "New Booking";
      }
      if (_currentIndex == 1) {
        maintitle = "My Booking";
      }
    });
  }
}