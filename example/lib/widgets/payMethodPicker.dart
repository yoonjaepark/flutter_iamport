import 'package:flutter/cupertino.dart';
import 'package:flutter_iamport_example/utils/constants.dart';

class PayMethodPicker extends StatefulWidget {
  PayMethodPicker(this.pg, this.pgMethodIndex, this.vbank_due, this.payMethodPicker,
      this.pay_method, this.onChangePayMethod,
      {Key key})
      : super(key: key);
  String pg;
  int pgMethodIndex;
  DateTime vbank_due;
  bool payMethodPicker;
  String pay_method;
  Function onChangePayMethod;
  @override
  _PayMethodPickerState createState() => _PayMethodPickerState();
}

class _PayMethodPickerState extends State<PayMethodPicker> {
  double _kPickerSheetHeight = 216.0;
  int _pgMethodIndex = 0;
  double _kPickerItemHeight = 32.0;
  Map state;

  Map<String, String> payMethod;

  bool visible;
  Widget _buildBottomPicker(Widget picker) {
    return Container(
      height: _kPickerSheetHeight,
      padding: const EdgeInsets.only(top: 6.0),
      color: CupertinoColors.white,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.black,
          fontSize: 22.0,
        ),
        child: GestureDetector(
          // Blocks taps from propagating to the modal sheet and popping.
          onTap: () {},
          child: SafeArea(
            top: false,
            child: picker,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    visible = false;
    payMethod = PAY_METHOD_BY_PG[widget.pg];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final FixedExtentScrollController scrollController =
        FixedExtentScrollController(initialItem: widget.pgMethodIndex);
    String key = PAY_METHOD_BY_PG.keys.elementAt(widget.pgMethodIndex);
    print(key);
    Widget _buildMenu(List<Widget> children) {
      return Container(
        decoration: BoxDecoration(
          color: CupertinoColors.inactiveGray,
          border: const Border(
            top: BorderSide(color: Color(0xFFBCBBC1), width: 0.0),
            bottom: BorderSide(color: Color(0xFFBCBBC1), width: 0.0),
          ),
        ),
        height: 44.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SafeArea(
            top: false,
            bottom: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: children,
            ),
          ),
        ),
      );
    }

    return Column(children: <Widget>[
      GestureDetector(
        onTap: () async {
          await showCupertinoModalPopup<void>(
            context: context,
            builder: (BuildContext context) {
              return _buildBottomPicker(
                CupertinoPicker(
                  magnification: 1.0,
                  //offAxisFraction:10.0,//
                  scrollController: scrollController, //
                  itemExtent: _kPickerItemHeight, //
                  backgroundColor: CupertinoColors.white, //
                  useMagnifier: true, //
                  onSelectedItemChanged: (int index) {
                    if (mounted) {
                      widget.onChangePayMethod(PAY_METHOD_BY_PG[widget.pg].keys.elementAt(index), index);
                    }
                  },
                  children: List<Widget>.generate(PAY_METHOD_BY_PG[widget.pg].length, (int index) {
                    String key = PAY_METHOD_BY_PG[widget.pg].keys.elementAt(index);

                    return Center(
                      child: Text(PAY_METHOD_BY_PG[widget.pg][key]),
                    );
                  }),
                ),
              );
            },
          );
        },
        child: _buildMenu(
          <Widget>[
            Text("결제수단"),
            Text(payMethod[widget.pay_method]),
          ],
        ),
      ),
    ]);
  }
}
