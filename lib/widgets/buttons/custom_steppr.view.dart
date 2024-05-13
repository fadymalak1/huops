import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../constants/app_colors.dart';

class CustomStepper extends StatefulWidget {
  CustomStepper({
    Key? key,
    this.defaultValue,
    this.max,
    required this.onChange,
  }) : super(key: key);

  final int? defaultValue;
  final int? max;
  final Function(int) onChange;
  @override
  _CustomStepperState createState() => _CustomStepperState();
}

class _CustomStepperState extends State<CustomStepper> {
  int qty = 0;

  @override
  void initState() {
    super.initState();

    //
    setState(() {
      qty = widget.defaultValue ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return HStack(
      [
        Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: Colors.white,
              )
          ),
          child: Center(
            child: InkWell(
              onTap: (){
                if (qty > 0) {
                  setState(() {
                    qty -= 1;
                  });
                  //
                  widget.onChange(qty);
                }
              },
              child:  Icon(
                Icons.remove,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),

        //
        "$qty".text.make().p4().px8().box.roundedSM.make(),

          //
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
              onTap: (){
                if (widget.max != null && widget.max! > qty) {
                  setState(() {
                    qty += 1;
                  });
                  //
                  widget.onChange(qty);
                }
              },
              child:  Icon(
                Icons.add,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    ).box
        // .border(color: Vx.gray300)
        .rounded.make();
  }
}
