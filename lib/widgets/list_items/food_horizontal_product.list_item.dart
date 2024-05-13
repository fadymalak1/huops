import 'package:flutter/material.dart';
import 'package:huops/extensions/string.dart';
import 'package:huops/models/cart.dart';
import 'package:huops/models/product.dart';
import 'package:huops/constants/app_strings.dart';
import 'package:huops/views/pages/cart/cart.page.dart';
import 'package:huops/widgets/cards/custom.visibility.dart';
import 'package:huops/widgets/currency_hstack.dart';
import 'package:huops/widgets/custom_image.view.dart';
import 'package:huops/widgets/tags/product_tags.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../view_models/product_details.vm.dart';

class FoodHorizontalProductListItem extends StatelessWidget {
  //
  const FoodHorizontalProductListItem(
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
        Hero(
          tag: product.heroTag ?? product.id,
          child: CustomImage(imageUrl: product.photo)
              .wh(Vx.dp64, Vx.dp64)
              .box
              .clip(Clip.antiAlias)
              .roundedSM
              .make(),
        ),

        //Details
        VStack(
          [
            //name
            product.name.text.lg.medium
                .maxLines(1)
                .overflow(TextOverflow.ellipsis)
                .make(),
            //description
            //hide this if there is an overflow

            "${product.vendor.name}"
                .text
                .xl
                .light
                .color(Colors.white)
                .maxLines(1)
                .ellipsis
                .make(),
            //price
            Wrap(
              children: [
                //price
                CurrencyHStack(
                  [
                    currencySymbol.text.sm.make(),
                    (product.showDiscount
                            ? product.discountPrice.currencyValueFormat()
                            : product.price.currencyValueFormat())
                        .text
                        .lg
                        .semiBold
                        .make(),
                  ],
                  crossAlignment: CrossAxisAlignment.end,
                ),
                5.widthBox,
                //discount price
                // CustomVisibilty(
                //   visible: product.showDiscount,
                //   child: CurrencyHStack(
                //     [
                //       currencySymbol.text.lineThrough.xs.make(),
                //       product.price
                //           .currencyValueFormat()
                //           .text
                //           .lineThrough
                //           .lg
                //           .medium
                //           .make(),
                //     ],
                //   ),
                // ),
              ],
            ),

            //
            // ProductTags(product),
          ],
        ).px12().expand(),
        // InkWell(
        //   onTap: (){
        //     //
        //     // Navigator.push(context, MaterialPageRoute(builder: (context)=> ));
        //     Navigator.push(context, MaterialPageRoute(builder: (context)=>CartPage()));
        //   },
        //   child: Container(
        //     padding: EdgeInsets.all(8),
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(50),
        //       color: Color(0xffea4622),
        //     ),
        //     child: Icon(Icons.card_travel,color: Colors.white,),
        //   ),
        // ),
      ],
    ).px12().onInkTap(
      onPressed == null ? null : () => onPressed!(product),
    );

    //height set
    if (height != null) {
      widget = widget.h(height!);
    }

    //
    return widget.box.p4.roundedSM
        .makeCentered()
        .glassMorphic(opacity: 0.1).p8();
  }
}
