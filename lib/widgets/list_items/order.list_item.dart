import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/extensions/dynamic.dart';
import 'package:huops/extensions/string.dart';
import 'package:huops/models/order.dart';
import 'package:huops/constants/app_strings.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:jiffy/jiffy.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class OrderListItem extends StatelessWidget {
  const OrderListItem({
    required this.order,
    required this.onPayPressed,
    required this.orderPressed,
    Key? key,
  }) : super(key: key);

  final Order order;
  final Function onPayPressed;
  final Function orderPressed;
  @override
  Widget build(BuildContext context) {
    return
        HStack(
          [
            Expanded(
              flex: 1,
              child: Container(
                height: 110,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Image.network(
                  order.photo ?? "",
                ),
              ),
            ),
            10.widthBox,
            Expanded(
              flex: 3,
              child: VStack([
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * .34,
                      child: "${order.vendor?.name}".text.lg.bold.maxLines(2).make().py4(),
                    ),

                    "${order.status}"
                        .tr()
                        .capitalized
                        .text
                        .color(AppColor.getStausColor(order.status)
                      // order.status == "delivered" ? Colors.green : Colors.amber,
                    )
                        .bold.make(),

                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    "${AppStrings.currencySymbol} ${order.total}"
                        .currencyFormat().text.color(AppColor.primaryColor).lg.semiBold.make(),
                    "ID:${order.code}".text.sm.make(),
                  ],
                ),
              ]),
            ),
          ],
        ).px16()
        .box
        .make()
        .onInkTap(() => orderPressed()).glassMorphic().px12();
  }
}
