import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/services.dart';

class FlutterIamport {
  static const MethodChannel _channel = const MethodChannel('flutter_iamport');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<Null> showNativeView(Object arg) async {
    _channel.invokeMethod('showNativeView', arg);
  }

 
  Future<String> loadHTML(Object data, String userCode, Rect rect, Function callback) async {
    launch(data, userCode, rect);
  }

  Future<Null> reloadUrl(String url, Rect rect) async {
    // final args = <String, String>{'url': url};
    final args = {};
    args['url'] = url;
    print(url.toString());
    await _channel.invokeMethod('reloadUrl', args);
  }

  void dispose() {
    _onDestroy.close();
  }

  final _onDestroy = StreamController<Null>.broadcast();

  Future<Null> resize(Rect rect) async {
    final args = {};
    args['rect'] = {
      'left': rect.left,
      'top': rect.top,
      'width': rect.width,
      'height': rect.height,
    };
    await _channel.invokeMethod('resize', args);
  }

  Future<Null> launch(data, userCode, rect) async {
    await _channel.invokeMethod('showNativeView', <String, dynamic>{
      // 'uri': uri,
      'rect': {
        'left': rect.left,
        'top': rect.top,
        'width': rect.width,
        'height': rect.height,
      },
      'data': data,
      'userCode': userCode
    });
  }

  Future<Null> close() async => await _channel.invokeMethod('close');
  Future<Null> goBack() async => await _channel.invokeMethod('back');
}
