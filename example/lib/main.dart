import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_iamport/flutter_iamport.dart';
import 'package:flutter_iamport_example/widgets/home.dart';
import 'package:flutter_iamport_example/widgets/payment.dart';
import 'package:flutter_iamport_example/widgets/paymentResult.dart';
import 'package:flutter_iamport_example/widgets/paymentTest.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // try {
    //   platformVersion = await FlutterIamport.platformVersion;
    // } on PlatformException {
    //   platformVersion = 'Failed to get platform version.';
    // }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'My Flutter App',
        home: Home(),
        routes: <String, WidgetBuilder>{
          '/home': (_) => Home(),
          '/payment': (_) => Payment(),
          '/paymentTest': (_) => PaymentTest(),
          '/PaymentResult': (_) => PaymentResult(),
          // '/Certification': (_) => Certification(),
          // '/CertificationTest': (_) => CertificationTest(),
          // '/CertificationResult': (_) => CertificationResult(),
        },
        onUnknownRoute: (RouteSettings setting) {
          return new MaterialPageRoute(builder: (context) => null);
        });
  }
}
