import 'package:flutter/material.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/models/payment_method.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/widgets/custom_image.view.dart';
import 'package:velocity_x/velocity_x.dart';

class PaymentOptionListItem extends StatelessWidget {
  const PaymentOptionListItem(
    this.paymentMethod, {
    this.selected = false,
    Key? key,
    required this.onSelected,
  }) : super(key: key);

  final bool selected;
  final PaymentMethod paymentMethod;
  final Function(PaymentMethod) onSelected;

  @override
  Widget build(BuildContext context) {
    return HStack(
      [
        //
        CustomImage(
          imageUrl: paymentMethod.photo,
          width: 35,
          height: Vx.dp40,
          boxFit: BoxFit.cover,
        ),//.px4().py2(),
        //
        paymentMethod.name.text.medium.center.color(Colors.white).make().expand(),
      ],
    )
        .box

        .make().glassMorphic(opacity: selected?0.2:0.0,circularRadius: 5)
        .onTap(
          () => onSelected(paymentMethod),
        );
  }
}
