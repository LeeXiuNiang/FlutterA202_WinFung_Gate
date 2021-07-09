import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:winfung_gate/mydrawer.dart';
import 'package:winfung_gate/user.dart';
import 'package:http/http.dart' as http;

class MyBooking extends StatefulWidget {
  final User user;

  const MyBooking({Key key, this.user}) : super(key: key);

  @override
  _MyBookingState createState() => _MyBookingState();
}

class _MyBookingState extends State<MyBooking> with WidgetsBindingObserver {
  List _bookingList;
  String titleCenter = "Loading...";
  double screenHeight, screenWidth;
  bool _statusPending = true;
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _testasync();
    print("Init tab 1");
  }

  @override
  void dispose() {
    print("in dispose");
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: _isAdmin
          ? AppBar(
              title: Text("All Reparation Bookings"),
            )
          : null,
      drawer: Visibility(visible: _isAdmin, child: MyDrawer(user: widget.user)),
      body: Center(
        child: Column(
          children: [
            if (_bookingList == null)
              Flexible(child: Center(child: Text(titleCenter)))
            else
              Flexible(
                  child: OrientationBuilder(builder: (context, orientation) {
                return GridView.count(
                    crossAxisCount: 1,
                    childAspectRatio: _isAdmin ? 2.2 : 2.5 / 1,
                    children: List.generate(_bookingList.length, (index) {
                      return Padding(
                          padding: const EdgeInsets.fromLTRB(10, 6, 10, 0),
                          child: Container(
                              child: Card(
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.indigo[900],
                                              spreadRadius: 1,
                                              blurRadius: 1,
                                              offset: Offset(1, 1),
                                            ),
                                          ]),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 9,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      5, 0, 0, 0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Visibility(
                                                    visible: _isAdmin,
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(5, 5, 5, 5),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Expanded(
                                                              flex: 3,
                                                              child: Text(
                                                                  "Email",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                  ))),
                                                          Expanded(
                                                              flex: 1,
                                                              child: Text(":",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                  ))),
                                                          Expanded(
                                                            flex: 7,
                                                            child: Text(
                                                                _bookingList[
                                                                        index]
                                                                    ['email'],
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                )),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(5, 5, 5, 5),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Expanded(
                                                            flex: 3,
                                                            child: Text("Date",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                ))),
                                                        Expanded(
                                                            flex: 1,
                                                            child: Text(":",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                ))),
                                                        Expanded(
                                                          flex: 7,
                                                          child: Text(
                                                              _bookingList[
                                                                      index]
                                                                  ['date'],
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                              )),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(5, 5, 5, 5),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Expanded(
                                                            flex: 3,
                                                            child: Text("Time",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                ))),
                                                        Expanded(
                                                            flex: 1,
                                                            child: Text(":",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                ))),
                                                        Expanded(
                                                          flex: 7,
                                                          child: Text(
                                                              _bookingList[
                                                                      index]
                                                                  ['time'],
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                              )),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(5, 5, 5, 5),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Expanded(
                                                            flex: 3,
                                                            child: Text(
                                                                "Address",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                ))),
                                                        Expanded(
                                                            flex: 1,
                                                            child: Text(":",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                ))),
                                                        Expanded(
                                                          flex: 7,
                                                          child: Text(
                                                              _bookingList[
                                                                          index]
                                                                      [
                                                                      'address']
                                                                  .replaceAll(
                                                                      ",",
                                                                      ", "),
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                              )),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(5, 5, 5, 5),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Expanded(
                                                            flex: 3,
                                                            child: Text(
                                                                "Status",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                ))),
                                                        Expanded(
                                                            flex: 1,
                                                            child: Text(":",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                ))),
                                                        Expanded(
                                                          flex: 7,
                                                          child: Text(
                                                              _bookingList[
                                                                      index]
                                                                  ['status'],
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                              )),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible: _isAdmin,
                                            child: Expanded(
                                              flex: 1,
                                              child: Column(
                                                children: [
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons
                                                          .event_available_sharp,
                                                      color: Colors.indigo[900],
                                                    ),
                                                    onPressed: () {
                                                      _updateSatutusDialog(
                                                          index);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible: !_isAdmin,
                                            child: Expanded(
                                              flex: 1,
                                              child: Column(
                                                children: [
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.delete,
                                                      color: Colors.indigo[900],
                                                    ),
                                                    onPressed: () {
                                                      _deleteBookingsDialog(
                                                          index);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )))));
                    }));
              })),
          ],
        ),
      ),
    );
  }

  Future<void> _testasync() async {
    _loadBookings();
    checkAdmin();
  }

  void _loadBookings() {
    http.post(
        Uri.parse(
            "https://crimsonwebs.com/s272033/winfunggate/php/loadbookings.php"),
        body: {"email": widget.user.email}).then((response) {
      if (response.body == "nodata") {
        titleCenter = "No Bookings";
        return;
      } else {
        var jsondata = json.decode(response.body);
        _bookingList = jsondata["bookings"];
        titleCenter = "Loading Bookings";
        setState(() {});
        print(_bookingList);
      }
    });
  }

  void _updateSatutusDialog(int index) {
    if (_bookingList[index]['status'] == "completed") {
      Fluttertoast.showToast(
          msg: "Status Updated Failed due to completion of bookings",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent[700],
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    } else {
      showDialog(
          builder: (context) => new AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  title: new Text(
                    'Update status of booking service to completed?',
                    style: TextStyle(),
                  ),
                  content: new Text(
                    'Are your sure?',
                    style: TextStyle(),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text("Yes",
                          style:
                              TextStyle(color: Theme.of(context).accentColor)),
                      onPressed: () {
                        Navigator.of(context).pop();
                        _updateBookings(index);
                      },
                    ),
                    TextButton(
                        child: Text("No",
                            style: TextStyle(
                                color: Theme.of(context).accentColor)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                  ]),
          context: context);
    }
  }

  void _updateBookings(int index) {
    http.post(
        Uri.parse(
            "https://crimsonwebs.com/s272033/winfunggate/php/updatebookings.php"),
        body: {
          "email": widget.user.email,
          "rbid": _bookingList[index]['id'],
          "status": _bookingList[index]['status']
        }).then((response) {
      print(response.body);
      if (response.body == "success") {
        Fluttertoast.showToast(
            msg: "Status Updated Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Theme.of(context).accentColor,
            textColor: Colors.white,
            fontSize: 16.0);
        _loadBookings();
      } else {
        Fluttertoast.showToast(
            msg: "Status Updated Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.redAccent[700],
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  void checkAdmin() {
    setState(() {
      if (widget.user.email == 'xnlee1999@gmail.com') {
        _isAdmin = true;
      }
    });
  }

  _deleteBookingsDialog(int index) {
    if (_bookingList[index]['status'] != "completed") {
      Fluttertoast.showToast(
          msg: "You can only delete a booking which is completed!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent[700],
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    } else {
      showDialog(
          builder: (context) => new AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  title: new Text(
                    'Delete this booking?',
                    style: TextStyle(),
                  ),
                  content: new Text(
                    'Are your sure?',
                    style: TextStyle(),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text("Yes",
                          style:
                              TextStyle(color: Theme.of(context).accentColor)),
                      onPressed: () {
                        Navigator.of(context).pop();
                        _deleteBookings(index);
                      },
                    ),
                    TextButton(
                        child: Text("No",
                            style: TextStyle(
                                color: Theme.of(context).accentColor)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                  ]),
          context: context);
    }
  }

  void _deleteBookings(int index) {
    
    http.post(
        Uri.parse(
            "https://crimsonwebs.com/s272033/winfunggate/php/deletebookings.php"),
        body: {
          "email": widget.user.email,
          "rbid": _bookingList[index]['id'],
        }).then((response) {
      print(response.body);
      if (response.body == "success") {
        Fluttertoast.showToast(
            msg: "Delete Booking Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Theme.of(context).accentColor,
            textColor: Colors.white,
            fontSize: 16.0);
        _loadBookings();
      } else {
        Fluttertoast.showToast(
            msg: "Delete Booking Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.redAccent[700],
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }
}
