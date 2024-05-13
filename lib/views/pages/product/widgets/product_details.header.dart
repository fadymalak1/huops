import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/extensions/dynamic.dart';
import 'package:huops/extensions/string.dart';
import 'package:huops/models/product.dart';
import 'package:huops/constants/app_strings.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/widgets/cards/custom.visibility.dart';
import 'package:huops/widgets/currency_hstack.dart';
import 'package:huops/widgets/tags/product_tags.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class ProductDetailsHeader extends StatelessWidget {
  const ProductDetailsHeader({
    required this.product,
    this.showVendor = true,
    Key? key,
  }) : super(key: key);

  final Product product;
  final bool showVendor;

  @override
  Widget build(BuildContext context) {
    //
    final currencySymbol = AppStrings.currencySymbol;

    return VStack(
      [
        30.heightBox,

        //product name, vendor name, and price
        HStack(
          [
            //name
            VStack(
              [

                //product name
                product.name.text.xl2.semiBold.make(),
                //vendor name
                CustomVisibilty(
                  visible: showVendor,
                  child: product.vendor.name.text.xl.make(),
                ),
              ],
            ).expand(),

            //price
            VStack(
              [
                //price
                CurrencyHStack(
                  [
                    currencySymbol.text.lg.bold.color(Color(0xffec4513)).make(),
                    (product.showDiscount
                            ? product.discountPrice.currencyValueFormat()
                            : product.price.currencyValueFormat())
                        .text
                        .xl2.color(Color(0xffec4513))
                        .bold
                        .make(),
                  ],
                  crossAlignment: CrossAxisAlignment.end,
                ),
                //discount
                CustomVisibilty(
                  visible: product.showDiscount,
                  child: CurrencyHStack(
                    [
                      currencySymbol.text.lineThrough.gray300.xs.make(),
                      product.price
                          .currencyValueFormat()
                          .text
                          .lineThrough.gray300
                          .lg
                          .medium
                          .make(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),

        //product size details and more
        HStack(
          crossAlignment: CrossAxisAlignment.start,
          [
            //deliverable or not
            VStack([
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(image: NetworkImage(product.vendor.featureImage),fit: BoxFit.cover)
                ),
              ),
              10.heightBox,
              (product.canBeDelivered
                  ? "Deliverable".tr()
                  : "Not Deliverable".tr())
                  .text
                  .white
                  .sm
                  .make()
                  .py4()
                  .px8()
                  .box
                  .roundedLg
                  .color(AppColor.primaryColor)
                  .make(),
            ]),

            //
            UiSpacer.expandedSpace(),

            //size
            CustomVisibilty(
              visible: !product.capacity.isEmptyOrNull &&
                  !product.unit.isEmptyOrNull,
              child: "${product.capacity} ${product.unit}"
                  .text
                  .sm
                  .color(Colors.white)
                  .make()
                  .py4()
                  .px8()
                  .box
                  .roundedLg
                  .color(Color(0xffec4513))
                  .make()
                  .pOnly(right: Vx.dp12),
            ),

            //package items
            CustomVisibilty(
              visible: product.packageCount != null,
              child: "%s Items"
                  .tr()
                  .fill(["${product.packageCount}"])
                  .text
                  .sm
                  .color(Colors.white)
                  .make()
                  .py4()
                  .px8()
                  .box
                  .roundedLg
                  .color(Color(0xffec4513))
                  .make(),
            ),
          ],
        ).pOnly(top: Vx.dp10),

        //
        10.heightBox,
        ProductTags(product),
      ],
    ).px20().py12();
  }
}
