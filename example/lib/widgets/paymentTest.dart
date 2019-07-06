import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_iamport/flutter_iamport.dart';
import 'package:flutter_iamport_example/utils/constants.dart';
import 'package:flutter_iamport_example/widgets/payMethodPicker.dart';
import 'package:flutter_iamport_example/widgets/pgPicker.dart';

class PaymentTest extends StatefulWidget {
  static const String routeName = '/cupertino/picker';

  @override
  _PaymentTestState createState() => _PaymentTestState();
}

class _PaymentTestState extends State<PaymentTest> {
  int _pgIndex = 0;
  int _pgMethodIndex = 0;
  bool pgPicker = false, payMethodPicker = false;
  // String pg = 'html5_inicis',
  //     pay_method = 'card',
  //     name = '아임포트 결제데이터 분석',
  //     merchant_uid = "mid_${DateTime.now().millisecondsSinceEpoch}",
  //     amount = '39000',
  //     buyer_name = '홍길동',
  //     buyer_tel = '01012345678',
  //     buyer_email = 'example@naver.com',
  //     buyer_addr = '서울시 강남구 신사동 661-16',
  //     buyer_postcode = '06018';

  Map<String, String> state = {
    "pg": 'html5_inicis',
    "pay_method": 'card',
    "name": '아임포트 결제데이터 분석',
    "merchant_uid": "mid_${DateTime.now().millisecondsSinceEpoch}",
    "amount": '39000',
    "buyer_name": '홍길동',
    "buyer_tel": '01012345678',
    "buyer_email": 'example@naver.com',
    "buyer_addr": '서울시 강남구 신사동 661-16',
    "buyer_postcode": '06018'
  };

  final inpuFieldsController = List<TextEditingController>();


  DateTime vbank_due = DateTime.now();

  _callbackPg(int index) {
    setState(() {
      _pgIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  textController(text) {
    return TextEditingController(text: this.state[text]);
  }

  onChangePg(String pg, int index) {
    if (pg == this.state["pg"]) return;

    // 결제수단 리스트가 다른 경우, 바뀐 리스트의 맨 처음 값으로 바꾼다
    var payMethodLists = PAY_METHOD_BY_PG[pg];
    if (payMethodLists != PAY_METHOD_BY_PG[this.state["pg"]]) {
      // this.setState({ pay_method: Object.keys(payMethodLists)[0] });
      setState(() {
        _pgIndex = index;
        this.state["pay_method"] = payMethodLists.keys.elementAt(0);
      });
    }
    setState(() {
      this.state["pg"] = pg;
      pgPicker = false;
      payMethodPicker = false;
    });
  }

  onChangePayMethod(String payMethod, int index) {
    if (payMethod == this.state["pay_method"]) return;
    setState(() {
      _pgMethodIndex = index;
      this.state["pay_method"] = payMethod;
    });
  }

  Widget renderPaymentInfo() {
    List<Widget> list = new List<Widget>();
    for (var i = 0; i < PAYMENT_INFO.length; i++) {
      this.inpuFieldsController.add(TextEditingController(text: this.state[PAYMENT_INFO.elementAt(i)["value"]]));
      list.add(Row(
        children: <Widget>[
          new Text(
            PAYMENT_INFO.elementAt(i)["name"],
            style: TextStyle(color: Colors.black),
          ),
          Expanded(
              flex: 3,
              child: TextField(
                controller: this.inpuFieldsController[i],
                decoration: InputDecoration(
                    // labelText: "Qty",
                    ),
              )),
        ],
      ));
    }
    return new Column(children: list);
  }

  Widget renderButton() {
    return FlatButton(child: Text("결제하기"), onPressed: onPressPayment);
  }

  onPressPayment() {
    // FlutterIamport.showNativeView(this.state);
    print(this.state);
    print(this.inpuFieldsController);
    for (var i = 0; i < PAYMENT_INFO.length; i++) {
      print(PAYMENT_INFO[i]["value"]);
      this.state[PAYMENT_INFO[i]["value"]] = this.inpuFieldsController[i].value.text;
      print(this.inpuFieldsController[i].value.text);
    }

    print(this.state);
    Navigator.pushNamed(
      context,
      "/payment",
       arguments: (this.state),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("결제테스트")),
        // height: MediaQuery.of(context).size.height,
        body: CupertinoPageScaffold(
          child: DefaultTextStyle(
            style: TextStyle(),
            child: DecoratedBox(
              decoration: BoxDecoration(color: CupertinoColors.white),
              child: ListView(
                children: <Widget>[
                  const Padding(padding: EdgeInsets.only(top: 32.0)),
                  PgPicker(this.pgPicker, this.state["pg"], _pgIndex, onChangePg),
                  PayMethodPicker(
                      this.state["pg"],
                      this._pgMethodIndex,
                      this.vbank_due,
                      this.payMethodPicker,
                      this.state["pay_method"],
                      this.onChangePayMethod),
                  renderPaymentInfo(),
                  renderButton(),
                ],
              ),
            ),
          ),
        ));
  }
}
