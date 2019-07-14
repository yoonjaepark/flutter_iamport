import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iamport/error_on_params.dart';
import 'package:flutter_iamport/flutter_iamport.dart';
import 'package:flutter_iamport/util/index.dart';

// typedef void IamportViewCreatedCallback(IamportViewController controller);

class IamportView extends StatefulWidget {
  const IamportView(
      {Key key,
      this.appBar,
      this.param,
      this.userCode,
      this.callback,
      this.initialChild})
      : super(key: key);

  // final IamportViewCreatedCallback onIamportViewCreated;
  final PreferredSizeWidget appBar;
  final param;
  final userCode;
  final callback;
  final Widget initialChild;

  @override
  State<StatefulWidget> createState() => _IamportViewState();
}

class _IamportViewState extends State<IamportView> {
  final webviewReference = FlutterIamport();
  var _onBack;
  // var param;
  // var userCode;
  Rect _rect;
  Timer _resizeTimer;
  StreamSubscription<String> _onUrlChanged;

  @override
  void initState() {
    super.initState();
    webviewReference.close();

    _onUrlChanged = FlutterIamport().onUrlChanged.listen((String url) async {
      print(url);
      await webviewReference.close();
      widget.callback(url);
    });
  }

  /// Equivalent to [Navigator.of(context)._history.last].
  Route<dynamic> get _topMostRoute {
    var topMost;
    Navigator.popUntil(context, (route) {
      topMost = route;
      return true;
    });
    return topMost;
  }

  @override
  Widget build(BuildContext context) {
    print("##this.param##");
    print(widget.param);

    var validateResult = validateProps(widget.userCode, widget.param);
    if (validateResult['validate'] == true) {
      return Scaffold(
        appBar: widget.appBar,
        resizeToAvoidBottomInset: false,
        body: _WebviewPlaceholder(
          onRectChanged: (Rect value) {
            if (_rect == null) {
              _rect = value;
              // webviewReference.launch(widget.param, _rect);
              webviewReference.loadHTML(
                  widget.param, widget.userCode, _rect, widget.callback);
            } else {
              if (_rect != value) {
                _rect = value;
                _resizeTimer?.cancel();
                _resizeTimer = Timer(const Duration(milliseconds: 250), () {
                  webviewReference.resize(_rect);
                });
              }
            }
          },
          child: widget.initialChild ??
              const Center(child: const CircularProgressIndicator()),
        ),
      );
    }

    return ErrorOnParams(message: validateResult['message']);
  }

  @override
  void dispose() {
    super.dispose();
    _onBack?.cancel();
    webviewReference.close();
    _onUrlChanged.cancel();
  }
}

class _WebviewPlaceholder extends SingleChildRenderObjectWidget {
  const _WebviewPlaceholder({
    Key key,
    @required this.onRectChanged,
    Widget child,
  }) : super(key: key, child: child);

  final ValueChanged<Rect> onRectChanged;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _WebviewPlaceholderRender(
      onRectChanged: onRectChanged,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, _WebviewPlaceholderRender renderObject) {
    renderObject..onRectChanged = onRectChanged;
  }
}

class _WebviewPlaceholderRender extends RenderProxyBox {
  _WebviewPlaceholderRender({
    RenderBox child,
    ValueChanged<Rect> onRectChanged,
  })  : _callback = onRectChanged,
        super(child);

  ValueChanged<Rect> _callback;
  Rect _rect;

  Rect get rect => _rect;

  set onRectChanged(ValueChanged<Rect> callback) {
    if (callback != _callback) {
      _callback = callback;
      notifyRect();
    }
  }

  void notifyRect() {
    if (_callback != null && _rect != null) {
      _callback(_rect);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
    final rect = offset & size;
    if (_rect != rect) {
      _rect = rect;
      notifyRect();
    }
  }
}
