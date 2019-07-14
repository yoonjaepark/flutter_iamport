import 'package:flutter/material.dart';

import 'widgets/home.dart';
import 'widgets/payment.dart';
import 'widgets/paymentTest.dart';
import 'widgets/paymentResult.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
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
