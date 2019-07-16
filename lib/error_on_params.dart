import 'package:flutter/material.dart';

class ErrorOnParams extends StatelessWidget {
  const ErrorOnParams({Key key, this.message}) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
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
                        message,
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
                              Navigator.pop(context);
                            },
                          )
                        ]))
              ],
            ))));
  }
}
