import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:winfung_gate/order.dart';
import 'package:winfung_gate/user.dart';

class PayScreen extends StatefulWidget {
  final User user;
  final Order order;

  const PayScreen({Key key,  this.user, this.order}) : super(key: key);

  @override
  _PayScreenState createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: WebView(
                  initialUrl:
                      'https://crimsonwebs.com/s272033/winfunggate/php/generate_bill.php?email=' +
                          widget.user.email +
                          '&mobile=' +
                          widget.order.phone +
                          '&name=' +
                          widget.user.username +
                          '&amount=' +
                          widget.order.payAmount,
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);
                  },
                ),
              )
                
              
            ],
          ),
        ),
      ),
    );
  }
}