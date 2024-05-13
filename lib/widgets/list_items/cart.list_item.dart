import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:huops/extensions/string.dart';
import 'package:huops/models/cart.dart';
import 'package:huops/constants/app_strings.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/widgets/buttons/qty_stepper.dart';
import 'package:huops/widgets/custom_image.view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../constants/app_colors.dart';
import '../cards/custom.visibility.dart';
import '../currency_hstack.dart';

class CartListItem extends StatelessWidget {
  const CartListItem(
    this.cart, {
    required this.onQuantityChange,
    this.deleteCartItem,
    Key? key,
  }) : super(key: key);

  final Cart cart;
  final Function(int) onQuantityChange;
  final Function? deleteCartItem;

  @override
  Widget build(BuildContext context) {
    //
    final currencySymbol = AppStrings.currencySymbol;

    return Slidable(
      startActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          // A SlidableAction can have an icon and/or a label.
          Container(
            child: SlidableAction(
              backgroundColor: Colors.transparent,
              onPressed: (_) {
                if (this.deleteCartItem != null) this.deleteCartItem!();
              },
              foregroundColor: Colors.red,
              icon: Icons.delete,

              label: 'delete'.tr(),
            ),
          ),
        ],
      ),
      child: Stack(
        children: [
          HStack(
            [
              //
              //PRODUCT IMAGE
              CustomImage(
                imageUrl: cart.product!.photo,
                width: context.percentWidth * 18,
                height: context.percentWidth * 18,
              ).box.clip(Clip.antiAlias).withRounded(value: 15.0).make(),

              //
              UiSpacer.hSpace(10),
              VStack(
                [
                  //product name
                  "${cart.product?.name}"
                      .text
                      .lg.bold.color(Color(0xffcad4d9))
                      .maxLines(2)
                      .ellipsis
                      .make(),
                  //product options
                  if (cart.optionsSentence.isNotEmpty)
                    cart.optionsSentence.text.sm.gray600.make(),
                  if (cart.optionsSentence.isNotEmpty) UiSpacer.vSpace(5),

                  //
                  //price and qty
                  HStack(
                    [
                      //cart item price
                      VStack(
                        [
                          ("$currencySymbol" +
                              "${cart.price! * int.parse(cart.selectedQty.toString())  ?? cart.product!.sellPrice }")
                              .currencyFormat()
                              .text
                              .color(Colors.red)
                              .semiBold
                              .lg
                              .make(),
                          CustomVisibilty(
                            visible: cart.product?.showDiscount,
                            child: CurrencyHStack(
                              [
                                ("$currencySymbol" +
                                    "${cart.product!.price * int.parse(cart.selectedQty.toString())}")
                                    .currencyFormat()
                                    .text
                                    .lineThrough.color(Color(0xffcad4d9))
                                    .sm
                                    .make(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      10.widthBox.expand(),

                      //qty stepper
                      SizedBox(
                        height: 35,
                        child: QtyStepper(
                          defaultValue: cart.selectedQty ?? 1,
                          actionIconColor: Colors.white,
                          min: 1,
                          max: cart.product?.availableQty ?? 20,
                          disableInput: true,
                          onChange: onQuantityChange,
                        )
                            .box
                            .roundedSM
                            .clip(Clip.antiAlias)
                        // .outerShadow
                            .make(),
                      ),
                    ],
                    crossAlignment: CrossAxisAlignment.center,
                  ),
                ],
              ).expand(),
            ],
            alignment: MainAxisAlignment.start,
            crossAlignment: CrossAxisAlignment.start,
          ).p12().box.roundedSM.outerShadowSm.make(),
        ],
      ).glassMorphic(),
    );
  }
}


