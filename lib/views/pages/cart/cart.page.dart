import 'package:flutter/material.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/extensions/string.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/view_models/cart.vm.dart';
import 'package:huops/views/pages/cart/widgets/amount_tile.dart';
import 'package:huops/views/pages/cart/widgets/apply_coupon.dart';
import 'package:huops/widgets/base.page.dart';
import 'package:huops/widgets/base.page.withoutNavbar.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:huops/widgets/custom_list_view.dart';
import 'package:huops/widgets/list_items/cart.list_item.dart';
import 'package:huops/widgets/states/cart.empty.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:dotted_line/dotted_line.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key,this.showLeading=true}) : super(key: key);

  final bool showLeading;
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return BasePageWithoutNavBar(
      showAppBar: true,
      showLeadingAction: widget.showLeading,
      // backgroundColor: AppColor.primaryColor,
      title: "My Cart".tr(),
      body: SafeArea(
        child: ViewModelBuilder<CartViewModel>.reactive(
          viewModelBuilder: () => CartViewModel(context),
          onViewModelReady: (model) => model.initialise(),
          builder: (context, model, child) {
            return Container(
              key: model.pageKey,
              child: VStack(
                [
                  //
                  if (model.cartItems.isEmpty)
                    EmptyCart().centered().expand()
                  else
                    VStack(
                      [
                        //cart items list
                        CustomListView(
                          noScrollPhysics: true,
                          dataSet: model.cartItems,
                          itemBuilder: (context, index) {
                            //
                            final cart = model.cartItems[index];
                            final product = cart.product;
                            return InkWell(
                              child: CartListItem(
                                cart,
                                onQuantityChange: (qty) =>
                                    model.updateCartItemQuantity(qty, index),
                                deleteCartItem: () =>
                                    model.deleteCartItem(index,context),
                              ),
                              onTap: () => model.productSelected(product!),
                            );
                          },
                        ),

                        //
                        // UiSpacer.divider(height: 20),
                        Divider(thickness: 1,color: Color(0xff575270),).py8(),
                        ApplyCoupon(model),
                        UiSpacer.verticalSpace(),
                        AmountTile(
                            "Total Item".tr(), model.totalCartItems.toString(),
                        ),
                        AmountTile(
                            "Sub-Total".tr(),
                            "${model.currencySymbol} ${model.subTotalPrice}"
                                .currencyFormat()),
                        Visibility(
                          visible: model.coupon != null &&
                              !model.coupon!.for_delivery,
                          child: AmountTile(
                              "Discount".tr(),
                              "${model.currencySymbol} ${model.discountCartPrice}"
                                  .currencyFormat()),
                        ),
                        //
                        Visibility(
                          visible: model.coupon != null &&
                              model.coupon!.for_delivery,
                          child: VStack(
                            [
                              Divider(thickness: 1,color: Color(0xff575270),).py8(),
                              "Discount will be applied to delivery fee on checkout"
                                  .tr()
                                  .text.color(Colors.white)
                                  .medium
                                  .make(),
                            ],
                          ).py(4),
                        ),
                        Divider(thickness: 1,color: Color(0xff575270),).py8(),
                        AmountTile(
                            "Total".tr(),
                            "${model.currencySymbol} ${model.totalCartPrice}"
                                .currencyFormat()),
                        //
                        CustomButton(
                          shapeRadius: 15,
                          title: "CHECKOUT".tr(),
                          padding: EdgeInsets.all(5),
                          onPressed: model.checkoutPressed,
                        ).h(Vx.dp48).py32(),
                      ],
                    )
                        .pOnly(bottom: context.mq.viewPadding.bottom)
                        .scrollVertical(padding: EdgeInsets.all(20))
                        .expand(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
