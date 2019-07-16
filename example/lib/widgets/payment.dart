import 'package:flutter/material.dart';
import 'package:flutter_iamport/iamport_view.dart';
import '../utils/util.dart';


class Payment extends StatefulWidget {
  Payment({Key key}) : super(key: key);

  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  var state;
  var userCode;
  didChangeDependencies() async {
    setState(() {
      state = ModalRoute.of(context).settings.arguments;
    });
  } 

  callback(String url) {
     Map<String, dynamic> args = {
      'success': Uri.splitQueryString(url.toString())['success'],
      'impUid': Uri.splitQueryString(url.toString())['imp_uid'],
      'errorMsg': Uri.splitQueryString(url.toString())['error_msg'],
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
        loading: {
          "message": '잠시만 기다려주세요...', // 로딩화면 메시지
          "image": 'https://raw.githubusercontent.com/iamport/iamport-react-native/master/src/img/iamport-logo.png' // 커스텀 로딩화면 이미지
        },
        param: this.state,
        userCode: getUserCode(this.state['pg']),
        callback: this.callback);
  }
}
