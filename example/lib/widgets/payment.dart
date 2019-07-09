import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iamport/flutter_iamport.dart';
import 'package:flutter_iamport/iamport_view.dart';

class Payment extends StatefulWidget {
  Payment({Key key}) : super(key: key);

  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  var state;
  var userCode;
  didChangeDependencies() async {
    print("didChangeDependencies");
    print(ModalRoute.of(context).settings.arguments);
    setState(() {
      state = ModalRoute.of(context).settings.arguments;
    });
  }

  callback() {
    print("callback");
  }

  @override
  Widget build(BuildContext context) {
    print("#######build");
    print(this.state);

    return IamportView(
        appBar: new AppBar(
          title: const Text('Widget webview'),
        ),
        param: this.state,
        userCode: "iamport",
        callback: this.callback);
  }
}
