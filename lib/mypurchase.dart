import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:winfung_gate/mydrawer.dart';
import 'package:winfung_gate/user.dart';
import 'package:http/http.dart' as http;

class MyPurchase extends StatefulWidget {
  final User user;

  const MyPurchase({Key key, this.user}) : super(key: key);

  @override
  _MyPurchaseState createState() => _MyPurchaseState();
}

class _MyPurchaseState extends State<MyPurchase> {
  List _purchaseList;
  String titleCenter = "Loading...";
  double screenHeight, screenWidth;
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _testasync();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: _isAdmin
            ? Text("Customer Order History")
            : Text('Purchase History'),
      ),
      drawer: MyDrawer(user: widget.user),
      body: Center(
        child: Column(
          children: [
            if (_purchaseList == null)
              Flexible(child: Center(child: Text(titleCenter)))
            else
              Flexible(
                  child: OrientationBuilder(builder: (context, orientation) {
                return GridView.count(
                    crossAxisCount: 1,
                    childAspectRatio: _isAdmin ? 2.1 : 2.5 / 1,
                    children: List.generate(_purchaseList.length, (index) {
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
                                            flex: 4,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      7, 0, 0, 0),
                                              height: orientation ==
                                                      Orientation.portrait
                                                  ? 130
                                                  : 200,
                                              width: orientation ==
                                                      Orientation.portrait
                                                  ? 130
                                                  : 200,
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    "https://crimsonwebs.com/s272033/winfunggate/images/products/${_purchaseList[index]['prid']}.png",
                                              ),
                                            ),
                                          ),
                                          Container(
                                              height: 100,
                                              child: VerticalDivider(
                                                  color: Colors.indigo[500])),
                                          Expanded(
                                            flex: 6,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      _purchaseList[index]
                                                          ['prname'],
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 19,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      )),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 5, 0, 2),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Expanded(
                                                            flex: 7,
                                                            child: Text(
                                                                "Quantity",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                ))),
                                                        Expanded(
                                                          flex: 10,
                                                          child: Text(
                                                              " : " +
                                                                  _purchaseList[
                                                                          index]
                                                                      ['qty'],
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                              )),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 0, 0, 2),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Expanded(
                                                            flex: 7,
                                                            child: Text(
                                                                "OrderID",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                ))),
                                                        Expanded(
                                                          flex: 10,
                                                          child: Text(
                                                              " : " +
                                                                  _purchaseList[
                                                                          index]
                                                                      [
                                                                      'orderid'],
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                              )),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 0, 0, 2),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Expanded(
                                                            flex: 7,
                                                            child: Text(
                                                                "Instl. Time",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                ))),
                                                        Expanded(
                                                          flex: 10,
                                                          child: Text(
                                                              " : " +
                                                                  _purchaseList[
                                                                          index]
                                                                      [
                                                                      'instime'],
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                              )),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 0, 0, 2),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Expanded(
                                                            flex: 7,
                                                            child: Text(
                                                                "Instl. Date",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                ))),
                                                        Expanded(
                                                          flex: 10,
                                                          child: Text(
                                                              " : " +
                                                                  _purchaseList[
                                                                          index]
                                                                      [
                                                                      'insdate'],
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                              )),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 0, 0, 2),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Expanded(
                                                            flex: 7,
                                                            child: Text(
                                                                "Status",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                ))),
                                                        Expanded(
                                                          flex: 10,
                                                          child: Text(
                                                              " : " +
                                                                  _purchaseList[
                                                                          index]
                                                                      [
                                                                      'status'],
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                              )),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Visibility(
                                                    visible: _isAdmin,
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          0, 10, 0, 0),
                                                      child: Text(
                                                          _purchaseList[index]
                                                              ['email'],
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontStyle: FontStyle
                                                                .italic,
                                                            color:
                                                                Colors.blueGrey,
                                                          )),
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
    checkAdmin();
    _loadPurchaseHistory();
  }

  void _loadPurchaseHistory() {
    http.post(
        Uri.parse(
            "https://crimsonwebs.com/s272033/winfunggate/php/loadpurchased.php"),
        body: {"email": widget.user.email}).then((response) {
      if (response.body == "nodata") {
        titleCenter = "No Purchase History";
        return;
      } else {
        var jsondata = json.decode(response.body);
        _purchaseList = jsondata["purchased"];
        titleCenter = "Loading Pruchase History";
        setState(() {});
        print(_purchaseList);
      }
    });
  }

  void _updateSatutusDialog(int index) {
    if (_purchaseList[index]['status'] == "completed") {
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
                    'Update status of installation service to completed?',
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
                        _updatePurchased(index);
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

  void _updatePurchased(int index) {
    http.post(
        Uri.parse(
            "https://crimsonwebs.com/s272033/winfunggate/php/updatepurchased.php"),
        body: {
          "email": widget.user.email,
          "prid": _purchaseList[index]['prid'],
          "orderid": _purchaseList[index]['orderid'],
          "status": _purchaseList[index]['status']
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
        _loadPurchaseHistory();
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
}
