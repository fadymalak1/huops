import 'package:flutter/material.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class AmountTile extends StatelessWidget {
  const AmountTile(this.title, this.amount, {this.amountStyle, Key? key})
      : super(key: key);

  final String title;
  final String amount;
  final TextStyle? amountStyle;
  @override
  Widget build(BuildContext context) {
    return HStack(
      [
        //
        title.text.color(Colors.white).make().expand(),
        UiSpacer.horizontalSpace(),
        amount.text.textStyle(amountStyle).color(Colors.white).make(),
      ],
    );
  }
}
