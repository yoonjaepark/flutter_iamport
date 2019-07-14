import 'package:flutter/material.dart';
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

  callback(String url) {
    print("callback");
    print(url);

    print(Uri.decodeQueryComponent(url.toString()));

    print(Uri.splitQueryString(url.toString()));
    print(Uri.splitQueryString(url.toString())['success']);
    print(Uri.splitQueryString(url.toString())['https://service.iamport.kr/payments/success?success']);
    print(Uri.splitQueryString(url.toString())['error_msg']);

    print(Uri.splitQueryString(url.toString())['imp_uid']);
    Map<String, dynamic> args = {
      'success' :  Uri.splitQueryString(url.toString())['success'],
      'impUid' : Uri.splitQueryString(url.toString())['imp_uid'],
      'errorMsg' : Uri.splitQueryString(url.toString())['error_msg'],
    };
    // print(Uri.base.queryParameters['imp_uid']);
    Navigator.pushReplacementNamed(context, '/PaymentResult', arguments: args);
  }

  @override
  Widget build(BuildContext context) {
    return IamportView(
        appBar: new AppBar(
          title: const Text('Pament'),
        ),
        param: this.state,
        userCode: "iamport",
        callback: this.callback);
  }
}
