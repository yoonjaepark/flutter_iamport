import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  _buildTitle() {
    return AppBar(title: Text("i'mport테스트"));
  }

  _buildExplanation() {
    return new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // new Row(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     mainAxisSize: MainAxisSize.max,
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: <Widget>[
          //       Flexible(child: Text("아임포트 플루터 네이티브 테스트를 위한 화면입니다.")),
          //       Flexible(
          //           child: Text("아래 버튼을 눌러 결제 및 본인인증을 테스트를 위한 화면으로 넘어갑니다."))
          //     ]),
          new Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(16.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text("아임포트 플루터 네이티브 테스트를 위한 화면입니다.",
                      textAlign: TextAlign.left),
                  new Text("아래 버튼을 눌러 결제 및 본인인증을 테스트를 위한 화면으로 넘어갑니다.",
                      textAlign: TextAlign.left),
                ],
              )),
          new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new FlatButton(
                    key: null,
                    onPressed: () => {
                          Navigator.pushNamed(
                            context,
                            "/paymentTest",
                          )
                        },
                    child: new Text(
                      "결제 테스트",
                      style: new TextStyle(
                          fontSize: 12.0,
                          color: const Color(0xFF000000),
                          fontWeight: FontWeight.w200,
                          fontFamily: "Roboto"),
                    )),
                FlatButton(
                    key: null,
                    // onPressed: buttonPressed,
                    child: new Text(
                      "본인인증 테스트",
                      style: new TextStyle(
                          fontSize: 12.0,
                          color: const Color(0xFF000000),
                          fontWeight: FontWeight.w200,
                          fontFamily: "Roboto"),
                    ))
              ]),
          new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[])
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: this._buildTitle(), body: this._buildExplanation());
  }
}
