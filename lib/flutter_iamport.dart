import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/services.dart';

class FlutterIamport {
  factory FlutterIamport() => _instance ??= FlutterIamport._();

  FlutterIamport._() {
    _channel.setMethodCallHandler(_handleMessages);
  }
  static FlutterIamport _instance;

  static const MethodChannel _channel = const MethodChannel('flutter_iamport');

  final _onUrlChanged = StreamController<String>.broadcast();
  // final _onHttpError = StreamController<WebViewHttpError>.broadcast();
  // final _onStateChanged = StreamController<WebViewStateChanged>.broadcast();
  final _onDestroy = StreamController<Null>.broadcast();
  final _onBack = StreamController<Null>.broadcast();

  Future<Null> _handleMessages(MethodCall call) async {
    print('_handleMessages');

    switch (call.method) {
      case 'onState':
        print('onState');
        _onUrlChanged.add(null);
        break;
    }
  }

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<Null> showNativeView(Object arg) async {
    _channel.invokeMethod('showNativeView', arg);
  }

  /// Listening the OnDestroy LifeCycle Event for Android
  Stream<Null> get onDestroy => _onDestroy.stream;

  /// Listening the back key press Event for Android
  Stream<Null> get onBack => _onBack.stream;

  /// Listening url changed
  Stream<String> get onUrlChanged => _onUrlChanged.stream;

  Future<String> loadHTML(
      Object data, String userCode, Rect rect, Function callback) async {
    launch(data, userCode, rect, callback);
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
    _onBack.close();
    _instance = null;
  }

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

  Future<Null> launch(data, userCode, rect, callback) async {
    print('launch');
    print(userCode);
    print(data);
    await _channel.invokeMethod('showNativeView', <String, dynamic>{
      'rect': {
        'left': rect.left,
        'top': rect.top,
        'width': rect.width,
        'height': rect.height,
      },
      'data': data,
      'userCode': userCode,
      'callback': callback.toString()
    });
  }

  Future<Null> close() async => await _channel.invokeMethod('close');
  Future<Null> goBack() async => await _channel.invokeMethod('back');
}
