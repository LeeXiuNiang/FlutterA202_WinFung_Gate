import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'mainscreen.dart';
import 'user.dart';

class CartPage extends StatefulWidget {
  final User user;

  const CartPage({Key key, this.user}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String _titlecenter = "Loading your cart";
  List _cartList;
  double _totalprice = 0.0;

  @override
  void initState() {
    super.initState();
    _loadMyCart();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (content) => MainScreen(user: widget.user)));
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Your Cart'),
        ),
        body: Center(
          child: Column(
            children: [
              if (_cartList == null)
                Flexible(child: Center(child: Text(_titlecenter)))
              else
                Flexible(
                    child: OrientationBuilder(builder: (context, orientation) {
                  return GridView.count(
                      crossAxisCount: 1,
                      childAspectRatio: 3 / 1,
                      children: List.generate(_cartList.length, (index) {
                        return Padding(
                            padding: const EdgeInsets.fromLTRB(10, 3, 10, 0),
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
                                                        5, 0, 5, 0),
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
                                                      "https://crimsonwebs.com/s272033/winfunggate/images/products/${_cartList[index]['productId']}.png",
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
                                                        _cartList[index]
                                                            ['productName'],
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        IconButton(
                                                          icon: Icon(
                                                              Icons.remove),
                                                          onPressed: () {
                                                            _modQty(index,
                                                                "removecart");
                                                          },
                                                        ),
                                                        Text(_cartList[index]
                                                            ['cartqty']),
                                                        IconButton(
                                                          icon: Icon(Icons.add),
                                                          onPressed: () {
                                                            _modQty(index,
                                                                "addcart");
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      "RM " +
                                                          (int.parse(_cartList[
                                                                          index]
                                                                      [
                                                                      'cartqty']) *
                                                                  double.parse(
                                                                      _cartList[
                                                                              index]
                                                                          [
                                                                          'price']))
                                                              .toStringAsFixed(
                                                                  2),
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Column(
                                                children: [
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.delete,
                                                      color: Colors.indigo[900],
                                                    ),
                                                    onPressed: () {
                                                      _deleteCartDialog(index);
                                                    },
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        )))));
                      }));
                })),
              Container(
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(height: 5),
                      Divider(
                        color: Colors.red,
                        height: 1,
                        thickness: 10.0,
                      ),
                      Text(
                        "TOTAL : RM " + _totalprice.toStringAsFixed(2),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            minWidth: 100,
                            height: 40,
                            onPressed: () {
                              _payDialog();
                            },
                            child: Text(
                              "CHECKOUT",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Hind',
                                  color: Colors.white),
                            ),
                            color: Theme.of(context).accentColor),
                      )
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  _loadMyCart() {
    http.post(
        Uri.parse(
            "https://crimsonwebs.com/s272033/winfunggate/php/loadusercart.php"),
        body: {"email": widget.user.email}).then((response) {
      print(response.body);
      if (response.body == "nodata") {
        _titlecenter = "No item";
        _cartList = [];
        return;
      } else {
        var jsondata = json.decode(response.body);
        print(jsondata);
        _cartList = jsondata["cart"];

        _titlecenter = "";
        _totalprice = 0.0;
        for (int i = 0; i < _cartList.length; i++) {
          _totalprice = _totalprice +
              double.parse(_cartList[i]['price']) *
                  int.parse(_cartList[i]['cartqty']);
        }
      }
      setState(() {});
    });
  }

  void _modQty(int index, String s) {
    http.post(
        Uri.parse(
            "https://crimsonwebs.com/s272033/winfunggate/php/updatecart.php"),
        body: {
          "email": widget.user.email,
          "op": s,
          "prid": _cartList[index]['productId'],
          "qty": _cartList[index]['cartqty']
        }).then((response) {
      print(response.body);
      if (response.body == "success") {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Theme.of(context).accentColor,
            textColor: Colors.white,
            fontSize: 16.0);
        _loadMyCart();
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.redAccent[700],
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  void _deleteCart(int index) {
    http.post(
        Uri.parse(
            "https://crimsonwebs.com/s272033/winfunggate/php/deletecart.php"),
        body: {
          "email": widget.user.email,
          "prid": _cartList[index]['productId']
        }).then((response) {
      print(response.body);
      if (response.body == "success") {
        Fluttertoast.showToast(
            msg: "Deleted from cart",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Theme.of(context).accentColor,
            textColor: Colors.white,
            fontSize: 16.0);
        _loadMyCart();
        return;
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  void _deleteCartDialog(int index) {
    showDialog(
        builder: (context) => new AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                title: new Text(
                  'Delete from your cart?',
                  style: TextStyle(),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text("Yes",style: TextStyle(color: Theme.of(context).accentColor)),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _deleteCart(index);
                    },
                  ),
                  TextButton(
                      child: Text("No",style: TextStyle(color: Theme.of(context).accentColor)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ]),
        context: context);
  }

  void _payDialog() {
    if (_totalprice == 0.0) {
      Fluttertoast.showToast(
          msg: "Amount not payable",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    } else {
      showDialog(
          builder: (context) => new AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  title: new Text(
                    'Proceed with checkout?',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text("Yes",style: TextStyle(color: Theme.of(context).accentColor)),
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                        child: Text("No",style: TextStyle(color: Theme.of(context).accentColor)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                  ]),
          context: context);
    }
  }
}
