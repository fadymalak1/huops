import 'package:flutter/material.dart';
import 'package:huops/constants/app_colors.dart';

class QtyStepper extends StatefulWidget {
  final int defaultValue;
  final int min;
  final int max;
  final bool disableInput;
  final Function(int) onChange;
  final Color? actionIconColor;
  final Color? actionButtonColor;

  QtyStepper({
    required this.defaultValue,
    required this.min,
    required this.max,
    this.disableInput = false,
    required this.onChange,
    this.actionIconColor,
    this.actionButtonColor,
  });

  @override
  _QtyStepperState createState() => _QtyStepperState();
}

class _QtyStepperState extends State<QtyStepper> {
  late int _value;

  @override
  void initState() {
    super.initState();
    _value = widget.defaultValue;
  }

  void _decrement() {
    if (_value > widget.min) {
      setState(() {
        _value--;
        widget.onChange(_value);
      });
    }
  }

  void _increment() {
    if (_value < widget.max) {
      setState(() {
        _value++;
        widget.onChange(_value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = widget.actionIconColor ?? Theme.of(context).primaryColor;
    final buttonColor =
        widget.actionButtonColor ?? Theme.of(context).primaryColor;

    return Row(
      children: [

        Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: Color(0xffec4513),
            )
          ),
          child: Center(
            child: InkWell(
              onTap: _decrement,
              child:  Icon(
                Icons.remove,
                color: Color(0xffec4513),
              ),
            ),
          ),
        ),
        SizedBox(width: 8),
        widget.disableInput
            ? Text(
                '$_value',
                style: TextStyle(fontSize: 16,color: Colors.white),
              )
            : TextFormField(
                initialValue: '$_value',
                onChanged: (value) {
                  setState(() {
                    _value = int.parse(value);
                    widget.onChange(_value);
                  });
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
        SizedBox(width: 8),
        Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: AppColor.primaryColor
              ),
            color: AppColor.primaryColor,
          ),
          child: Center(
            child: InkWell(
              onTap: _increment,
              child:  Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
