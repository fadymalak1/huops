import 'package:flutter/material.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/extensions/string.dart';
import 'package:huops/models/product.dart';
import 'package:huops/constants/app_strings.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/widgets/currency_hstack.dart';
import 'package:huops/widgets/custom_image.view.dart';
import 'package:huops/widgets/states/product_stock.dart';
import 'package:velocity_x/velocity_x.dart';

class HorizontalProductListItem extends StatelessWidget {
  //
  const HorizontalProductListItem(
      this.product, {
        this.onPressed,
        required this.qtyUpdated,
        this.height,
        Key? key,
      }) : super(key: key);

  //
  final Product product;
  final Function(Product)? onPressed;
  final Function(Product, int)? qtyUpdated;
  final double? height;
  @override
  Widget build(BuildContext context) {
    //
    final currencySymbol = AppStrings.currencySymbol;

    //
    Widget widget = HStack(
      [
        //
        Hero(
          tag: product.heroTag ?? product.id,
          child: CustomImage(imageUrl: product.photo)
              .wh(Vx.dp56, Vx.dp56)
              .box
              .clip(Clip.antiAlias)
              .roundedSM
              .make(),
        ),

        //Details
        VStack(
          [
            //name
            product.name.text.lg.medium.semiBold
                .maxLines(2)
                .overflow(TextOverflow.ellipsis)
                .make(),
            // "${product.vendor.name}".text.sm.semiBold.maxLines(2).overflow(TextOverflow.ellipsis).make(),
            5.heightBox,
            HStack(
              [

                //price
                CurrencyHStack(
                  [
                    currencySymbol.text.medium.color(AppColor.primaryColor).make(),
                    (product.showDiscount
                        ? product.discountPrice.currencyValueFormat()
                        : product.price.currencyValueFormat())
                        .text
                        .lg
                        .semiBold.color(AppColor.primaryColor)
                        .make(),
                  ],
                  crossAlignment: CrossAxisAlignment.end,
                ),

                //discount
                product.showDiscount
                    ? CurrencyHStack(
                  [
                    currencySymbol.text.lineThrough.sm.color(Colors.grey).make(),
                    product.price.currencyValueFormat().text.lineThrough.sm.color(Colors.grey).make(),
                  ],
                )
                    : UiSpacer.emptySpace(),

              ],
              crossAlignment: CrossAxisAlignment.end,
            ),
          ],
        ).px12().expand(),

        //
        VStack(
          [
            // plus/min icon here
            ProductStockState(
              product,
              qtyUpdated: qtyUpdated,
            ),
          ],
          crossAlignment: CrossAxisAlignment.end,
        ),
      ],
    ).onInkTap(
      onPressed == null ? null : () => onPressed!(product),
    );

    //height set
    if (height != null) {
      widget = widget.h(height!);
    }

    //
    return widget.box.p4.roundedSM
        .p8
        .makeCentered().glassMorphic()
        .p8();
  }
}
