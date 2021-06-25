import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:winfung_gate/user.dart';

import 'mydrawer.dart';

class MessagingScreen extends StatefulWidget {
  final User user;

  const MessagingScreen({Key key, this.user}) : super(key: key);

  @override
  _MessagingScreenState createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  void launchWhatsApp({
    @required int phone,
    @required String message,
  }) async {
    String url = "https://wa.me/$phone/?text=${Uri.parse(message)}";
    await canLaunch(url) ? launch(url) : print("Can't open whatsapp");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact Us"),
      ),
     drawer: MyDrawer(user: widget.user), 
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 30),
            Container(
                                  margin: EdgeInsets.all(15),
                                  width: 300,
                                  child: RichText(
                                      softWrap: true,
                                      textAlign: TextAlign.justify,
                                      text: TextSpan(
                                          style: TextStyle(fontSize: 16, color:Colors.black),
                                          text:
                                              "Please do not hesitate to contact us via WhatsApp if you have any further enquiry regarding the details of the products or our services.\n\nWe also accept orders for customized gates, you may contact us for further requirements on welding.\n\nWe will reply to your message as soon as possible.")),
                                ),
            SizedBox(height: 30),
            MaterialButton(
              color: Theme.of(context).accentColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              onPressed: () {
                launchWhatsApp(phone: 60125223989, message: "");
              },
              child: Text(
                'Contact via WhatsApp',
                style: TextStyle(
                    fontSize: 16, fontFamily: 'Hind', color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
