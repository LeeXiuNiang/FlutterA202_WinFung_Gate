import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'cartpage.dart';
import 'mydrawer.dart';
import 'user.dart';

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key key, this.user}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List _productList;
  String titleCenter = "Loading...";
  double screenHeight, screenWidth;
  final df = new DateFormat('dd-MM-yyyy');
  TextEditingController _srcController = new TextEditingController();
  int cartitem = 0;

  @override
  void initState() {
    super.initState();
    _testasync();
    _loadCart();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Discover our Products"),
        actions: [
          TextButton.icon(
              onPressed: () => {_goToCart()},
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
              label: Text(
                cartitem.toString(),
                style: TextStyle(color: Colors.white),
              )),
        ],
      ),
      drawer: MyDrawer(user: widget.user),
      body: Center(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextFormField(
              controller: _srcController,
              onChanged: (_srcController) {
                _loadProducts(_srcController);
              },
              decoration: InputDecoration(
                hintText: "Search product",
                suffixIcon: IconButton(
                  onPressed: () => _searchProducts(_srcController.text),
                  icon: Icon(Icons.search),
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.white24)),
              ),
            ),
          ),
          _productList == null
              ? Flexible(
                  child: Center(child: Text("No data")),
                )
              : Flexible(
                  child: Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: ListView.builder(
                      itemCount: _productList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: InkWell(
                            onTap: () {},
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
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                      //mainAxisAlignment:
                                      //    MainAxisAlignment.spaceAround,
                                      children: [
                                        Expanded(
                                          flex: 4,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 0, 10, 0),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.only(),
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      "https://crimsonwebs.com/s272033/winfunggate/images/products/${_productList[index]['id']}.png",
                                                  height: 150,
                                                  width: 150,
                                                )),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Container(
                                                width: screenWidth / 2.5,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(0, 5, 0, 0),
                                                      child: Text(
                                                          _productList[index]
                                                              ['name'],
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            decoration:
                                                                TextDecoration
                                                                    .underline,
                                                            decorationThickness:
                                                                2,
                                                          )),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          0, 10, 5, 0),
                                                      child: Text(
                                                        _productList[index]
                                                            ['type'],
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontStyle: FontStyle
                                                                .italic,
                                                            color: Colors
                                                                .blueGrey),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(0, 5, 5, 0),
                                                      child: Text(
                                                        "Size: " +
                                                            _productList[index]
                                                                ['size'],
                                                        style: TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(0, 5, 5, 0),
                                                      child: Text(
                                                        "Price: RM " +
                                                            double.parse(
                                                                    _productList[
                                                                            index]
                                                                        [
                                                                        'price'])
                                                                .toStringAsFixed(
                                                                    2),
                                                        style: TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(0, 5, 5, 5),
                                                      child: Text(
                                                        "Quantity Available: " +
                                                            _productList[index]
                                                                ['qty'],
                                                        style: TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: GestureDetector(
                                            child: Icon(
                                              Icons.add_shopping_cart,
                                              color: Colors.indigo[900],
                                            ),
                                            onTap: () => {_addToCart(index)},
                                          ),
                                        ),
                                      ]),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )),
        ]),
      ),
    );
  }

  void _loadProducts(String prname) {
    http.post(
        Uri.parse(
            "https://crimsonwebs.com/s272033/winfunggate/php/loadproducts.php"),
        body: {"prname": prname}).then((response) {
      if (response.body == "nodata") {
        titleCenter = "No data";
        //Fluttertoast.showToast(
        //    msg: "We couldn't find anything for " + _srcController.text,
        //    toastLength: Toast.LENGTH_SHORT,
        //    gravity: ToastGravity.BOTTOM,
        //    timeInSecForIosWeb: 1,
        //    backgroundColor: Colors.redAccent[700],
        //    textColor: Colors.white,
        //   fontSize: 16.0);
        return;
      } else {
        var jsondata = json.decode(response.body);
        _productList = jsondata["products"];
        titleCenter = "Contain Data";
        setState(() {});
        print(_productList);
      }
    });
  }

  Future<void> _testasync() async {
    _loadProducts("");
    _loadCart();
  }

  void _addToCart(int index) {
    String prid = _productList[index]['id'];
    http.post(
        Uri.parse(
            "https://crimsonwebs.com/s272033/winfunggate/php/insertcart.php"),
        body: {"email": widget.user.email, "prid": prid}).then((response) {
      //print(response.body);
      if (response.body == "failed") {
        titleCenter = "No data";
        Fluttertoast.showToast(
            msg: "Failed to add",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.redAccent[700],
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Added to cart",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Theme.of(context).accentColor,
            textColor: Colors.white,
            fontSize: 16.0);
        _loadCart();
      }
    });
  }

  _goToCart() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => CartPage(user: widget.user)));
    _loadProducts("");
  }

  _searchProducts(String prname) {
    _loadProducts(prname);
    if (titleCenter == "No data") {
      Fluttertoast.showToast(
          msg: "We couldn't find anything for " + _srcController.text,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent[700],
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void _loadCart() {
    
    http.post(
        Uri.parse(
            "https://crimsonwebs.com/s272033/winfunggate/php/loadcartitem.php"),
        body: {"email": widget.user.email}).then((response) {
      setState(() {
        cartitem = int.parse(response.body);
        print(cartitem);
      });
    });
  }
}
