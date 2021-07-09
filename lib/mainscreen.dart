import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:winfung_gate/newproduct.dart';
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
  bool _isAdmin = false;
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _typeController = new TextEditingController();
  TextEditingController _sizeController = new TextEditingController();
  TextEditingController _priceController = new TextEditingController();
  TextEditingController _qtyController = new TextEditingController();

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
        title: _isAdmin ? Text("All Products") : Text('Discover our Products'),
        actions: [
          Visibility(
            visible: !_isAdmin,
            child: TextButton.icon(
                onPressed: () => {_goToCart()},
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),
                label: Text(
                  cartitem.toString(),
                  style: TextStyle(color: Colors.white),
                )),
          ),
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
                                        Visibility(
                                          visible: !_isAdmin,
                                          child: Expanded(
                                            flex: 1,
                                            child: GestureDetector(
                                              child: Icon(
                                                Icons.add_shopping_cart,
                                                color: Colors.indigo[900],
                                              ),
                                              onTap: () => {_addToCart(index)},
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: _isAdmin,
                                          child: Expanded(
                                            flex: 1,
                                            child: Column(
                                              children: [
                                                GestureDetector(
                                                  child: Icon(
                                                    Icons.edit,
                                                    color: Colors.indigo[900],
                                                  ),
                                                  onTap: () => {
                                                    _editProductDialog(index)
                                                  },
                                                ),
                                                SizedBox(height: 30),
                                                GestureDetector(
                                                  child: Icon(
                                                    Icons.delete,
                                                    color: Colors.indigo[900],
                                                  ),
                                                  onTap: () => {
                                                    _deleteProductDialog(index)
                                                  },
                                                ),
                                              ],
                                            ),
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
      floatingActionButton: Visibility(
        visible: _isAdmin,
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NewProductForm(user: widget.user)));
          },
          label: Text(
            "Add",
            style:
                TextStyle(fontFamily: 'Georgia', fontWeight: FontWeight.bold),
          ),
          icon: Icon(Icons.add),
        ),
      ),
    );
  }

  void _loadProducts(String prname) {
    checkAdmin();
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

  void checkAdmin() {
    setState(() {
      if (widget.user.email == 'xnlee1999@gmail.com') {
        _isAdmin = true;
      }
    });
  }

  void _editProductDialog(int index) {
    _nameController.text = _productList[index]['name'];
    _typeController.text = _productList[index]['type'];
    _sizeController.text = _productList[index]['size'];
    _priceController.text = _productList[index]['price'];
    _qtyController.text = _productList[index]['qty'];
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Edit This Product?"),
            content: SingleChildScrollView(
              child: new Container(
                height: 320,
                width: 300,
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      child: TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: "Name",
                          contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 50,
                      child: TextField(
                        controller: _typeController,
                        decoration: InputDecoration(
                          labelText: "Type",
                          contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 50,
                      child: TextField(
                        controller: _sizeController,
                        decoration: InputDecoration(
                          labelText: "Size",
                          contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 50,
                      child: TextField(
                        controller: _priceController,
                        decoration: InputDecoration(
                          labelText: "Price (RM)",
                          contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 50,
                      child: TextField(
                        controller: _qtyController,
                        decoration: InputDecoration(
                          labelText: "Quantity",
                          contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                child: Text("Confirm",
                    style: TextStyle(color: Theme.of(context).accentColor)),
                onPressed: () {
                  _editProduct(index);
                  //Navigator.of(context).pop();
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

  void _editProduct(int index) {
    String prid = _productList[index]['id'];
    String name = _nameController.text.toString();
    String type = _typeController.text.toString();
    String size = _sizeController.text.toString();
    String price = _priceController.text.toString();
    String qty = _qtyController.text.toString();

    http.post(
        Uri.parse(
            "https://www.crimsonwebs.com/s272033/winfunggate/php/editproducts.php"),
        body: {
          "prid": prid,
          "name": name,
          "type": type,
          "size": size,
          "price": price,
          "qty": qty,
        }).then((response) {
      print(response.body);
      if (response.body == "success") {
        Fluttertoast.showToast(
            msg: "Edit Product Success.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Theme.of(context).accentColor,
            textColor: Colors.white,
            fontSize: 16.0);
        _loadProducts("");
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(
            msg: "Edit Product Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Theme.of(context).accentColor,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  _deleteProductDialog(int index) {
    showDialog(
        builder: (context) => new AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                title: new Text(
                  'Delete this product?',
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
                      _deleteProduct(index);
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

  void _deleteProduct(int index) {
    String prid = _productList[index]['id'];
    print(prid);
    http.post(
        Uri.parse(
            "https://www.crimsonwebs.com/s272033/winfunggate/php/deleteproducts.php"),
        body: {
          "prid": prid,
        }).then((response) {
      print(response.body);
      if (response.body == "success") {
        Fluttertoast.showToast(
            msg: "Delete Product Success.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Theme.of(context).accentColor,
            textColor: Colors.white,
            fontSize: 16.0);
        _loadProducts("");
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(
            msg: "Delete Product Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Theme.of(context).accentColor,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }
}
