import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_iamport/flutter_iamport.dart';
import '../utils/constants.dart';
import '../utils/util.dart';

class PaymentTest extends StatefulWidget {
  static const String routeName = '/cupertino/picker';

  @override
  _PaymentTestState createState() => _PaymentTestState();
}

class _PaymentTestState extends State<PaymentTest> {
  int _pgIndex = 0;
  int _pgMethodIndex = 0;
  int _quotasIndex = 0;
  bool pgPicker = false, payMethodPicker = false;

  Map<String, dynamic> state = {
    'pg': 'html5_inicis',
    'payMethod': 'card',
    'name': '아임포트 결제데이터 분석',
    'merchantUid': 'mid_${DateTime.now().millisecondsSinceEpoch}',
    'app_scheme': 'example',
    'amount': '39000',
    'buyerName': '홍길동',
    'buyerTel': '01012345678',
    'buyerEmail': 'example@naver.com',
    'buyerAddr': '서울시 강남구 신사동 661-16',
    'buyerPostcode': '06018',
    'cardQuota': 0,
    'vbankDue': null,
    'bizNum': null,
    'digital': false,
    'escrow': false,
    'language': 'ko',
  };
  TextEditingController vbankDueCtr = TextEditingController();
  TextEditingController bizNumCtr = TextEditingController();
  TextEditingController nameCtr = TextEditingController();
  TextEditingController amountCtr = TextEditingController();
  TextEditingController merchantUidCtr = TextEditingController();
  TextEditingController buyerNameCtr = TextEditingController();
  TextEditingController buyerTelCtr = TextEditingController();
  TextEditingController buyerEmailCtr = TextEditingController();

  DateTime vbankDue = DateTime.now();

  @override
  void initState() {
    super.initState();
    this.nameCtr.text = this.state["name"];
    this.amountCtr.text = this.state["amount"];
    this.merchantUidCtr.text = this.state["merchantUid"];
    this.buyerNameCtr.text = this.state["buyerName"];
    this.buyerTelCtr.text = this.state["buyerTel"];
    this.buyerEmailCtr.text = this.state["buyerEmail"];
  }

  onPress() {
    Map<String, dynamic> params = {
      'pg': this.state['pg'],
      'pay_method': this.state['payMethod'],
      'name': this.nameCtr.text,
      'merchant_uid': this.merchantUidCtr.text,
      'app_scheme': this.state['app_scheme'],
      'amount': this.amountCtr.text,
      'buyer_name': this.buyerNameCtr.text,
      'buyer_tel': this.buyerTelCtr.text,
      'buyer_email': this.buyerEmailCtr.text,
      'buyerAddr': '서울시 강남구 신사동 661-16',
      // 'buyerPostcode': '06018',
      // 'cardQuota': 0,
      // 'vbankDue': null,
      // 'bizNum': null,
      // 'digital': false,
      'escrow': this.state['escrow'],
      'language': this.state['language'],
    };

    // 신용카드의 경우, 할부기한 추가
    if (this.state['payMethod'] == 'card' && this.state['cardQuota'] != 0) {
      params['display'] = {
        'card_auota':
            this.state['cardQuota'] == 1 ? [] : [this.state['cardQuota']]
      };
    }

    // 가상계좌의 경우, 입금기한 추가
    if (this.state['payMethod'] == 'vbank' && this.vbankDueCtr.text != null) {
      params['vbank_due'] = this.vbankDueCtr.text;
    }

    // 다날 && 가상계좌의 경우, 사업자 등록번호 10자리 추가
    if (this.state['payMethod'] == 'vbank' &&
        this.state['pg'] == 'danal_tpay') {
      params['biz_num'] = this.state['bizNum'];
    }

    // 휴대폰 소액결제의 경우, 실물 컨텐츠 여부 추가
    if (this.state['payMethod'] == 'phone') {
      params['digital'] = this.state['digital'];
    }

    // 정기결제의 경우, customer_uid 추가
    if (this.state['pg'] == 'kcp_billing') {
      params['customer_uid'] = 'cuid_${DateTime.now().millisecondsSinceEpoch}';
    }

    Navigator.pushNamed(
      context,
      "/payment",
      arguments: (params),
    );
  }

  @override
  Widget build(BuildContext context) {
    var payMethod = this.state["payMethod"];
    var pg = this.state["pg"];
    List<Row> child = [];

    child.add(Row(
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 20),
            width: 100,
            child: new Text(
              "PG사",
              style: TextStyle(color: Colors.black),
            )),
        Expanded(
            child: Padding(
                padding: EdgeInsets.only(right: 20),
                child: FlatButton(
                    shape: Border.all(width: 1.0, color: Colors.black54),
                    onPressed: () async {
                      final Map<String, dynamic> pg =
                          await _asyncSimpleDialog(context, "Pg사", PGS);
                      List<Map<String, String>> methods = getMethods(pg);
                      setState(() {
                        state["pg"] = pg["value"];
                        state["payMethod"] = methods[0]["value"];
                        _pgMethodIndex = 0;
                        _pgIndex = pg["index"];
                      });
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        PGS.elementAt(this._pgIndex)["label"],
                      ),
                    ))))
      ],
    ));

    child.add(Row(
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 20),
            width: 100,
            child: new Text(
              "수단",
              style: TextStyle(color: Colors.black),
            )),
        Expanded(
            child: Padding(
                padding: EdgeInsets.only(right: 20),
                child: FlatButton(
                    shape: Border.all(width: 1.0, color: Colors.black54),
                    onPressed: () async {
                      final Map<String, dynamic> methods =
                          await _asyncSimpleDialog(
                              context, "Pg사", getMethods(this.state["pg"]));
                      setState(() {
                        _pgMethodIndex = methods["index"];
                        state["payMethod"] = methods["value"];
                      });
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(getMethods(this.state["pg"])
                          .elementAt(this._pgMethodIndex)["label"]),
                    ))))
      ],
    ));

    if (payMethod == "card") {
      child.add(Row(
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(left: 20),
              width: 100,
              child: new Text(
                "할부개월수",
                style: TextStyle(color: Colors.black),
              )),
          Expanded(
              child: Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: FlatButton(
                      shape: Border.all(width: 1.0, color: Colors.black54),
                      onPressed: () async {
                        final Map<String, dynamic> methods =
                            await _asyncSimpleDialog(
                                context, "Pg사", getQuotas(this.state["pg"]));
                        setState(() {
                          this.state['cardQuota'] = methods['value'];
                          _quotasIndex = methods['index'];
                        });
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(getQuotas(this.state['pg'])
                            .elementAt(this._quotasIndex)['label']),
                      ))))
        ],
      ));
    }

    if (payMethod == 'vbank') {
      child.add(Row(
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(left: 20),
              width: 100,
              child: new Text(
                '입금기한',
                style: TextStyle(color: Colors.black),
              )),
          Expanded(
              child: Padding(
                  padding: EdgeInsets.only(right: 20, top: 5),
                  child: Container(
                      height: 40,
                      child: TextField(
                          controller: vbankDueCtr,
                          decoration:
                              InputDecoration(border: OutlineInputBorder())))))
        ],
      ));
    }

    if (payMethod == 'vbank' && pg == 'danal_tpay') {
      child.add(Row(
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(left: 20),
              width: 100,
              child: new Text(
                '사업자번호',
                style: TextStyle(color: Colors.black),
              )),
          Expanded(
              child: Padding(
                  padding: EdgeInsets.only(right: 20, top: 5),
                  child: Container(
                      height: 40,
                      child: TextField(
                          controller: bizNumCtr,
                          decoration:
                              InputDecoration(border: OutlineInputBorder())))))
        ],
      ));
    }

    if (payMethod == 'phone') {
      child.add(Row(
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(left: 20),
              width: 100,
              child: new Text(
                '실물컨텐츠',
                style: TextStyle(color: Colors.black),
              )),
          Switch(
            value: state["digital"],
            onChanged: (value) {
              setState(() {
                state["digital"] = value;
              });
            },
          )
        ],
      ));
    }

    child.add(Row(
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 20),
            width: 100,
            child: new Text(
              '에스크로',
              style: TextStyle(color: Colors.black),
            )),
        Switch(
          value: state["escrow"],
          onChanged: (value) {
            setState(() {
              state["escrow"] = value;
            });
          },
        )
      ],
    ));

    child.add(Row(
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 20),
            width: 100,
            child: new Text(
              '주문명',
              style: TextStyle(color: Colors.black),
            )),
        Expanded(
            child: Padding(
                padding: EdgeInsets.only(right: 20, top: 5),
                child: Container(
                    height: 40,
                    child: TextField(
                        controller: nameCtr,
                        decoration:
                            InputDecoration(border: OutlineInputBorder())))))
      ],
    ));

    child.add(Row(
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 20),
            width: 100,
            child: new Text(
              '결제금액',
              style: TextStyle(color: Colors.black),
            )),
        Expanded(
            child: Padding(
                padding: EdgeInsets.only(right: 20, top: 5),
                child: Container(
                    height: 40,
                    child: TextField(
                        controller: amountCtr,
                        decoration:
                            InputDecoration(border: OutlineInputBorder())))))
      ],
    ));

    child.add(Row(
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 20),
            width: 100,
            child: new Text(
              '주문번호',
              style: TextStyle(color: Colors.black),
            )),
        Expanded(
            child: Padding(
                padding: EdgeInsets.only(right: 20, top: 5),
                child: Container(
                    height: 40,
                    child: TextField(
                        controller: merchantUidCtr,
                        decoration:
                            InputDecoration(border: OutlineInputBorder())))))
      ],
    ));

    child.add(Row(
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 20),
            width: 100,
            child: new Text(
              '이름',
              style: TextStyle(color: Colors.black),
            )),
        Expanded(
            child: Padding(
                padding: EdgeInsets.only(right: 20, top: 5),
                child: Container(
                    height: 40,
                    child: TextField(
                        controller: buyerNameCtr,
                        decoration:
                            InputDecoration(border: OutlineInputBorder())))))
      ],
    ));

    child.add(Row(
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 20),
            width: 100,
            child: new Text(
              '전화번호',
              style: TextStyle(color: Colors.black),
            )),
        Expanded(
            child: Padding(
                padding: EdgeInsets.only(right: 20, top: 5),
                child: Container(
                    height: 40,
                    child: TextField(
                        controller: buyerTelCtr,
                        decoration:
                            InputDecoration(border: OutlineInputBorder())))))
      ],
    ));

    child.add(Row(
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 20),
            width: 100,
            child: new Text(
              '이메일',
              style: TextStyle(color: Colors.black),
            )),
        Expanded(
            child: Padding(
                padding: EdgeInsets.only(right: 20, top: 5),
                child: Container(
                    height: 40,
                    child: TextField(
                        controller: buyerEmailCtr,
                        decoration:
                            InputDecoration(border: OutlineInputBorder())))))
      ],
    ));

    child.add(Row(children: <Widget>[
      Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.only(left: 40, right: 40, top: 20),
            child: FlatButton(
                color: Colors.blueAccent,
                textColor: Colors.white,
                child: Text('결제하기'),
                onPressed: onPress),
          ))
    ]));
    return Scaffold(
        appBar: AppBar(title: Text('결제테스트')),
        body: Container(
          margin: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
          color: Colors.white,
          child: ListView(children: child),
        ));
  }
}

// enum Departments { Production, Research, Purchasing, Marketing, Accounting }

Future<Map<String, dynamic>> _asyncSimpleDialog(
    BuildContext context, String title, List<Map<String, dynamic>> data) async {
  _renderOptions() {
    List<Widget> list = new List<Widget>();
    for (var i = 0; i < data.length; i++) {
      list.add(
        SimpleDialogOption(
          onPressed: () {
            Map<String, dynamic> args = {
              'value': data[i]['value'].toString(),
              'index': i,
            };
            Navigator.pop(context, args);
          },
          child: Text(data[i]['label']),
        ),
      );
    }
    return list;
  }

  return await showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(title),
          children: _renderOptions(),
        );
      });
}
