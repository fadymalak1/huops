import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/extensions/string.dart';
import 'package:huops/view_models/product_details.vm.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:huops/widgets/buttons/qty_stepper.dart';
import 'package:huops/widgets/currency_hstack.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class ProductDetailsCartBottomSheet extends StatelessWidget {
  const ProductDetailsCartBottomSheet({
    required this.model,
    Key? key,
  }) : super(key: key);

  final ProductDetailsViewModel model;
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //
        Visibility(
          visible: model.product.hasStock,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            color: Colors.transparent,
            child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: (){},
                      style:ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Color(0xffec4513)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))),
                      child: "Restaurant Menu".tr().text.make(),
                    ),

                    QtyStepper(
                      defaultValue: model.product.selectedQty,
                      min: 1,
                      max: (model.product.availableQty != null &&
                          model.product.availableQty! > 0)
                          ? model.product.availableQty!
                          : 20,
                      disableInput: true,
                      onChange: model.updatedSelectedQty,
                    ),
                  ],
                ),
          ),
        ),

        //
        Visibility(
          visible: model.product.hasStock,
          child: Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColor.primaryColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xffec4513),
                  ),
                  child: model.product.selectedQty.toString().text.make(),
                ),
                InkWell(
                  onTap: (){
                    model.addToCart(context: context);
                  },
                  child: "Add to cart".tr().text.white.xl.make(),
                ),
                "|".text.xl2.color(Colors.white).make(),
                CurrencyHStack(
                  [
                    model.currencySymbol.text.white.lg.make(),
                    model.total
                        .currencyValueFormat()
                        .text
                        .white
                        .letterSpacing(1.5)
                        .xl
                        .semiBold
                        .make(),
                  ],
                ),
              ],
            ),
          )
        ).p20(),
        Visibility(
          visible: !model.product.hasStock,
          child: "No stock"
              .tr()
              .text
              .white
              .makeCentered()
              .p8()
              .box
              .red500
              .roundedSM
              .make()
              .p8()
              .wFull(context),
        ),
      ],
    )
        // .p20()
        .color(Colors.transparent)
        .box

        // .shadowSm
        .make()
        .wFull(context);
  }
}
