import 'package:flutter/material.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/extensions/string.dart';
import 'package:huops/models/product.dart';
import 'package:huops/constants/app_strings.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/utils/utils.dart';
import 'package:huops/widgets/currency_hstack.dart';
import 'package:huops/widgets/custom_image.view.dart';
import 'package:huops/widgets/states/product_stock.dart';
import 'package:velocity_x/velocity_x.dart';

class GridViewProductListItem extends StatelessWidget {
  const GridViewProductListItem({
    required this.product,
    required this.onPressed,
    required this.qtyUpdated,
    this.showStepper = false,
    Key? key,
  }) : super(key: key);

  final Function(Product) onPressed;
  final Function(Product, int) qtyUpdated;
  final Product product;
  final bool showStepper;
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //
        //product image
        Stack(
          fit: StackFit.expand,
          children: [
            //
            Hero(
              tag: product.heroTag ?? product.id,
              child: CustomImage(
                imageUrl: product.photo,
                boxFit: BoxFit.cover,
                width: double.infinity,
                height: Vx.dp64,
              ),
            ),
            //
            //price tag
            Positioned(
              left: !Utils.isArabic ? 10 : null,
              right: !Utils.isArabic ? null : 10,
              child: Visibility(
                visible: product.showDiscount,
                child: VxBox(
                  child: "-${product.discountPercentage}%"
                      .text
                      .xs
                      .semiBold
                      .white
                      .make(),
                )
                    .p4
                    .bottomRounded(value: 5)
                    .make(),
              ),
            ),
          ],
        ).expand(),

        //
        VStack(
          [
            product.name.text.semiBold
                .size(11)
                .minFontSize(10)
                .maxLines(1)
                .overflow(TextOverflow.ellipsis)
                .make(),
            product.vendor.name.text.xs
                .maxLines(1)
                .overflow(TextOverflow.ellipsis)
                .make(),

            //
            HStack(
              [
                //price
                CurrencyHStack(
                  [
                    AppStrings.currencySymbol.text.xs.make(),
                    " ".text.make(),
                    product.sellPrice
                        .currencyValueFormat()
                        .text
                        .sm
                        .semiBold
                        .make(),
                  ],
                ).expand(),
                //plus/min icon here
                showStepper
                    ? ProductStockState(product, qtyUpdated: qtyUpdated)
                    : UiSpacer.emptySpace(),
              ],
            ),
          ],
        ).p8(),
      ],
    )
        .box
        .withRounded(value: 1)
        .makeCentered()
        .onTap(
          () => this.onPressed(this.product),
        ).glassMorphic();
  }
}
