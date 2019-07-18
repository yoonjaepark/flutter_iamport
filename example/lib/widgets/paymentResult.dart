import 'package:flutter/material.dart';

class PaymentResult extends StatelessWidget {
  const PaymentResult({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ResultArguments args =
        new ResultArguments.fromJson(ModalRoute.of(context).settings.arguments);

    return Scaffold(
        body: Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(bottom: 30),
                        child: Text(
                          '결제에 ${args.success ? "성공" : "실패"}하였습니다',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        )),
                  ],
                ),
                Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                            flex: 4,
                            child: Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                '아임포트 번호',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            )),
                        Expanded(
                          flex: 6,
                          child: Text(
                            args.impUid,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        )
                      ],
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                        flex: 4,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            '에러메세지',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        )),
                    Expanded(
                      flex: 6,
                      child: Text(
                        args.errorMsg,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                            color: Colors.blueAccent,
                            child: Text(
                              '홈',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, '/home');
                            },
                          )
                        ]))
              ],
            ))));
  }
}

class ResultArguments {
  // 아규먼트의 타이틀과 메시지. 생성자에 의해서만 초기화되고 변경할 수 없음
  bool success;
  String impUid;
  String errorMsg;

  ResultArguments.fromJson(Map json) {
    this.success = json["success"] == "true";
    this.impUid = json["impUid"] ?? "";
    this.errorMsg = json["errorMsg"] ?? "";
  }
}
