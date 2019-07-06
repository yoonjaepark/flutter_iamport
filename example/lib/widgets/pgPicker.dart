import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iamport_example/utils/constants.dart';
import 'package:flutter_iamport_example/utils/util.dart';

class PgPicker extends StatefulWidget {
  PgPicker(
      this.pgPicker, this.pg, this.pgIndex, this.onChangePg,
      {Key key})
      : super(key: key);
  bool pgPicker;
  String pg;
  int pgIndex;
  Function onChangePg;
  @override
  _PgPickerState createState() => _PgPickerState();
}

class _PgPickerState extends State<PgPicker> {
  double _kPickerSheetHeight = 216.0;
  int _pgIndex = 0;
  double _kPickerItemHeight = 32.0;
  Map state;
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
    this.state = {"visible": false, "payMethod": PAY_METHOD_BY_PG[widget.pg]};
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final FixedExtentScrollController scrollController =
        FixedExtentScrollController(initialItem: widget.pgIndex);
    String key = PG.keys.elementAt(widget.pgIndex);

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
                      widget.onChangePg(PG.keys.elementAt(index), index);
                    }
                  },
                  children: List<Widget>.generate(PG.length, (int index) {
                    String key = PG.keys.elementAt(index);

                    return Center(
                      child: Text(PG[key]),
                    );
                  }),
                ),
              );
            },
          );
        },
        child: _buildMenu(
          <Widget>[
            Text("PG사"),
            Text(PG[key]),
          ],
        ),
      ),
      Text(
        getPgWarningMsg(key),
        maxLines: 2,
        style: TextStyle(color: Colors.black),
      )
    ]);
  }
}
