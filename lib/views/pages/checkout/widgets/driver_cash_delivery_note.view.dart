import 'package:flutter/material.dart';
import 'package:huops/constants/app_finance_settings.dart';
import 'package:huops/models/delivery_address.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class CheckoutDriverCashDeliveryNoticeView extends StatelessWidget {
  const CheckoutDriverCashDeliveryNoticeView(this.dAddress, {Key? key})
      : super(key: key);

  final DeliveryAddress dAddress;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: AppFinanceSettings.collectDeliveryFeeInCash,
      child: VxBox(
        child: "".richText.withTextSpanChildren(
          [
            "Note:".tr().textSpan.bold.color(Color(0xffD53C25)).size(14).make(),
            "\n".textSpan.make(),
            "Irrespective of your selected payment method, it is required that you pay delivery fee in CASH to the delivery personal. Thank you"
                .tr()
                .textSpan.color(Colors.white)
                .size(14)
                .make(),
          ],
        ).make(),
      ).p12.make().glassMorphic().py12(),
    );
  }
}
