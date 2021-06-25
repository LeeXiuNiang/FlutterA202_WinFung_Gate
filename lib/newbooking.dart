import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:ndialog/ndialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:winfung_gate/delivery.dart';
import 'package:winfung_gate/mappage.dart';
import 'package:winfung_gate/user.dart';
import 'package:http/http.dart' as http;

class NewBooking extends StatefulWidget {
  final User user;

  const NewBooking({Key key, this.user}) : super(key: key);

  @override
  _NewBookingState createState() => _NewBookingState();
}

class _NewBookingState extends State<NewBooking> with WidgetsBindingObserver {
  String _phone = "Click to set";
  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController _userlocctrl = new TextEditingController();
  String address = "";
  double screenHeight, screenWidth;
  SharedPreferences prefs;
  var df = new DateFormat("dd-MM-yyyy hh:mm a");
  DateTime _date = DateTime.now();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  String _setTime, _setDate;
  String _hour, _minute, _time;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    print("Init tab 0");
    _dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    _timeController.text = formatDate(
        DateTime(2021, 05, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
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
    final now = new DateTime.now();
    String today = DateFormat('hh:mm a').format(now);
    String todaybanner = DateFormat('dd/MM/yyyy').format(now);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 7,
            child: ListView(
              padding: EdgeInsets.only(top: 0),
              children: [
                Container(
                  margin: EdgeInsets.all(2),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Text(
                          "CUSTOMER DETAILS",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Expanded(flex: 3, child: Text("Email:")),
                            Container(
                                height: 20,
                                child: VerticalDivider(color: Colors.grey)),
                            Expanded(
                              flex: 7,
                              child: Text(widget.user.email),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(flex: 3, child: Text("Name:")),
                            Container(
                                height: 20,
                                child: VerticalDivider(color: Colors.grey)),
                            Expanded(
                              flex: 7,
                              child: Text(widget.user.username),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(flex: 3, child: Text("Phone:")),
                            Container(
                                height: 20,
                                child: VerticalDivider(color: Colors.grey)),
                            Expanded(
                              flex: 7,
                              child: GestureDetector(
                                  onTap: () => {phoneDialog()},
                                  child: Text(_phone)),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  height: 2,
                ),
                Container(
                  margin: EdgeInsets.all(2),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: Column(
                      children: [
                        Text(
                          "REPARATION DATE & TIME",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          margin: EdgeInsets.all(15),
                          width: 300,
                          child: RichText(
                              softWrap: true,
                              textAlign: TextAlign.justify,
                              text: TextSpan(
                                  style: Theme.of(context).textTheme.bodyText2,
                                  text:
                                      "Time offered for the reparation service is from 9.00 A.M to 7.00 P.M every weekday which are from Monday to Friday. Please allow 1 day for preparation after making a booking.\nPlease note that we may contact you for any adjustment of date and time.")),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                          child: Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Row(
                              children: [
                                Expanded(flex: 3, child: Text("Set Date: ")),
                                Container(
                                    height: 40,
                                    child: VerticalDivider(color: Colors.grey)),
                                Expanded(
                                  flex: 7,
                                  child: InkWell(
                                    onTap: () {
                                      _selectDate(context);
                                    },
                                    child: Container(
                                      width: 30,
                                      height: 40,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(color: Colors.grey)
                                          //color: Colors.grey[200]
                                          ),
                                      child: TextFormField(
                                        style: TextStyle(fontSize: 14),
                                        //textAlign: TextAlign.center,
                                        enabled: false,
                                        keyboardType: TextInputType.text,
                                        controller: _dateController,
                                        onSaved: (String val) {
                                          _setDate = val;
                                        },
                                        decoration: InputDecoration(
                                            icon: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 0, 30, 0),
                                              child: Icon(Icons
                                                  .calendar_today_outlined),
                                            ),
                                            disabledBorder:
                                                UnderlineInputBorder(
                                                    borderSide:
                                                        BorderSide.none),
                                            contentPadding: EdgeInsets.all(2)),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(flex: 3, child: Text("Set Time: ")),
                              Container(
                                  height: 40,
                                  child: VerticalDivider(color: Colors.grey)),
                              Expanded(
                                flex: 7,
                                child: InkWell(
                                  onTap: () {
                                    _selectTimes(context);
                                  },
                                  child: Container(
                                    //margin: EdgeInsets.only(top: 30),
                                    width: 30,
                                    height: 40,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(color: Colors.grey)
                                        //color: Colors.grey[200]
                                        ),
                                    child: TextFormField(
                                      style: TextStyle(fontSize: 14),
                                      //textAlign: TextAlign.center,
                                      onSaved: (String val) {
                                        _setTime = val;
                                      },
                                      enabled: false,
                                      keyboardType: TextInputType.text,
                                      controller: _timeController,
                                      decoration: InputDecoration(
                                          icon: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 0, 30, 0),
                                            child: Icon(Icons.timer),
                                          ),
                                          disabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide.none),
                                          // labelText: 'Time',
                                          contentPadding: EdgeInsets.all(2)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  height: 2,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      children: [
                        Text(
                          "REPARATION ADDRESS",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                                flex: 6,
                                child: Column(
                                  children: [
                                    TextField(
                                      controller: _userlocctrl,
                                      style: TextStyle(fontSize: 14),
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: 'Search/Enter address'),
                                      keyboardType: TextInputType.multiline,
                                      minLines:
                                          4, //Normal textInputField will be displayed
                                      maxLines:
                                          4, // when user presses enter it will adapt to it
                                    ),
                                  ],
                                )),
                            Container(
                                height: 120,
                                child: VerticalDivider(color: Colors.grey)),
                            Expanded(
                                flex: 4,
                                child: Column(
                                  children: [
                                    Container(
                                      width: 150,
                                      child: MaterialButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        color: Theme.of(context).accentColor,
                                        elevation: 3,
                                        onPressed: () => {_getUserCurrentLoc()},
                                        child: Text("Location",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white)),
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.grey,
                                      height: 2,
                                    ),
                                    Container(
                                      width: 150,
                                      child: MaterialButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        color: Theme.of(context).accentColor,
                                        elevation: 3,
                                        onPressed: () async {
                                          Delivery _del =
                                              await Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => MapPage(),
                                            ),
                                          );
                                          print(address);
                                          setState(() {
                                            _userlocctrl.text = _del.address;
                                          });
                                        },
                                        child: Text("Map",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white)),
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  height: 2,
                ),
                SizedBox(height: 10),
                Container(
                    child: Column(
                  children: [
                    Container(
                      width: screenWidth / 2.5,
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        color: Theme.of(context).accentColor,
                        elevation: 3,
                        onPressed: () {
                          makeBooking();
                        },
                        child: Text("Book Now",
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: "Hind",
                                color: Colors.white)),
                      ),
                    )
                  ],
                )),
                SizedBox(height: 10),
              ],
            ),
          )
        ],
      ),
    );
  }

  void phoneDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Your Phone?"),
            content: new Container(
              height: 50,
              width: 300,
              child: Column(
                children: [
                  Container(
                    height: 50,
                    child: TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Phone",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text("Ok",
                    style: TextStyle(color: Theme.of(context).accentColor)),
                onPressed: () async {
                  Navigator.of(context).pop();
                  _phone = phoneController.text;

                  prefs = await SharedPreferences.getInstance();
                  await prefs.setString("phone", _phone);

                  setState(() {});
                },
              ),
            ],
          );
        });
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now().add(Duration(days: 1)),
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime.now().add(Duration(days: 1)),
        lastDate: DateTime(2025));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
      });
  }

  Future<Null> _selectTimes(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 9, minute: 0),
    );

    if (picked != null) {
      if (picked.hour > 19 ||
          picked.hour == 19 && picked.minute > 0 ||
          picked.hour < 9) {
        Fluttertoast.showToast(
            msg: "Invalid time selection",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.redAccent[700],
            textColor: Colors.white,
            fontSize: 16.0);
        return;
      }
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
    }
  }

  _getUserCurrentLoc() async {
    ProgressDialog progressDialog = ProgressDialog(context,
        message: Text("Searching address"), title: Text("Locating..."));
    progressDialog.show();
    await _determinePosition().then((value) => {_getPlace(value)});
    setState(
      () {},
    );
    progressDialog.dismiss();
  }

  void _getPlace(Position pos) async {
    List<Placemark> newPlace =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);

    // this is all you need
    Placemark placeMark = newPlace[0];
    String name = placeMark.name.toString();
    String subLocality = placeMark.subLocality.toString();
    String locality = placeMark.locality.toString();
    String administrativeArea = placeMark.administrativeArea.toString();
    String postalCode = placeMark.postalCode.toString();
    String country = placeMark.country.toString();
    address = name +
        "," +
        subLocality +
        ",\n" +
        locality +
        "," +
        postalCode +
        ",\n" +
        administrativeArea +
        "," +
        country;
    _userlocctrl.text = address;
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  void makeBooking() {
    if (_phone == "Click to set" ||
        _userlocctrl.text == "" ||
        _dateController.text ==
            DateFormat('dd/MM/yyyy').format(DateTime.now())) {
      Fluttertoast.showToast(
          msg: "Information not complete!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent[700],
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Text("Make New Reparation Booking?"),
            content: Text("Are your sure?"),
            actions: [
              TextButton(
                child: Text("Ok",
                 style: TextStyle(color: Theme.of(context).accentColor),),
                onPressed: () {
                  Navigator.of(context).pop();
                  bookReparation();
                },
              ),
              TextButton(
                  child: Text("Cancel",
                   style: TextStyle(color: Theme.of(context).accentColor),),
                  
                  onPressed: () {
                    Navigator.of(context).pop();
                    
                  }),
            ],
          );
        });
  }

    Future<void> bookReparation() async {
   
    String email = widget.user.email;
    String name = widget.user.username;
    String phone = phoneController.text;
    String date = _dateController.text;
    String time = _timeController.text;
    String address = _userlocctrl.text.replaceAll("\n", "");
    
    
    http.post(
        Uri.parse("https://crimsonwebs.com/s272033/winfunggate/php/addrepairbookings.php"),
        body: {
          "email": email,
          "name": name,
          "phone": phone,
          "date": date,
          "time": time,
          "address": address
        }).then((response) {
 
      if (response.body == "success") {
        Fluttertoast.showToast(
            msg: "Booking Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Theme.of(context).accentColor,
            textColor: Colors.white,
            fontSize: 16.0);
        setState(() {
         
        });
        
      } else {
        Fluttertoast.showToast(
            msg: "Booking Failed",
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
