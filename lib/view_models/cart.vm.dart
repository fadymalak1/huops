import 'dart:developer';

import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/constants/app_routes.dart';
import 'package:huops/constants/app_strings.dart';
import 'package:huops/models/cart.dart';
import 'package:huops/models/checkout.dart';
import 'package:huops/models/coupon.dart';
import 'package:huops/requests/cart.request.dart';
import 'package:huops/services/alert.service.dart';
import 'package:huops/services/auth.service.dart';
import 'package:huops/services/cart.service.dart';
import 'package:huops/services/cart_ui.service.dart';
import 'package:huops/view_models/base.view_model.dart';
import 'package:huops/views/pages/checkout/multiple_order_checkout.page.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class CartViewModel extends MyBaseViewModel {
  //
  CartRequest cartRequest = CartRequest();
  List<Cart> cartItems = [];
  int totalCartItems = 0;
  double subTotalPrice = 0.0;
  double discountCartPrice = 0.0;
  double totalCartPrice = 0.0;

  //
  bool canApplyCoupon = false;
  Coupon? coupon;
  TextEditingController couponTEC = TextEditingController();

  //
  CartViewModel(BuildContext context) {
    this.viewContext = context;
  }

  void initialise() async {
    //
    cartItems = CartServices.productsInCart;
    //
    calculateSubTotal();
  }

  //
  calculateSubTotal() {
    //
    totalCartItems = 0;
    subTotalPrice = 0;
    discountCartPrice = 0;

    //
    cartItems.forEach(
      (cartItem) {
        totalCartItems += cartItem.selectedQty!;
        final totalProductPrice = cartItem.price! * cartItem.selectedQty!;
        subTotalPrice += totalProductPrice;

        //discount/coupon
        final foundProduct = coupon?.products.firstOrNullWhere(
          (product) => cartItem.product?.id == product.id,
        );
        final foundVendor = coupon?.vendors.firstOrNullWhere(
          (vendor) => cartItem.product?.vendorId == vendor.id,
        );

        //
        bool skipCalculation = false;

        //
        if (foundProduct?.vendor.vendorType.id == coupon?.vendorTypeId) {
          skipCalculation = false;
        }
        //if vendor type match vendor type
        else if (foundVendor?.vendorType.id == coupon?.vendorTypeId) {
          skipCalculation = false;
        } else if (cartItem.product?.vendor.vendorTypeId ==
            coupon?.vendorTypeId) {
          skipCalculation = false;
        } else {
          skipCalculation = true;
          setErrorForObject(
            "coupon",
            "Coupon can't be used with vendor type".tr(),
          );
        }
        //free delivery coupon
        if (coupon?.for_delivery ?? false) {
          skipCalculation = true;
        }

        //
        if (!skipCalculation && coupon != null) {
          if (foundProduct != null ||
              foundVendor != null ||
              (coupon!.products.isEmpty && coupon!.vendors.isEmpty)) {
            if (coupon?.percentage == 1) {
              discountCartPrice += (coupon!.discount / 100) * totalProductPrice;
            } else {
              discountCartPrice += coupon!.discount;
            }
          }
        }

        //
      },
    );

    //check if coupon is allow with the discount price
    if (coupon != null) {
      try {
        discountCartPrice = coupon!.validateDiscount(
          subTotalPrice,
          discountCartPrice,
        );
        clearErrors();
      } catch (error) {
        discountCartPrice = 0;
        setErrorForObject("coupon", error);
      }
    }
    //
    totalCartPrice = subTotalPrice - discountCartPrice;
    notifyListeners();
  }

  //
  deleteCartItem(int index,context) {
    showDialog(context: context, builder: (context){
      return Center(
        child: Container(
          height: MediaQuery.of(context).size.height * .42,
          width: MediaQuery.of(context).size.width * .7,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color(0xff56516f).withOpacity(.9),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 70,
                height: 70,
                child: Image.asset("assets/images/warning.png",),
              ),
              10.heightBox,
              Text(
                "Remove from cart".tr(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22,color: Colors.white),
              ),
              10.heightBox,
              Text(
                "Do you want to remove this product".tr(),
                style: TextStyle(fontSize: 15,color: Colors.white),
              ),
              10.heightBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            // side: BorderSide(color: Colors.red),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    child: Container(
                      width: 50,
                      // padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 15),
                      child: Center(child: Text("Cancel".tr(),style: TextStyle(color: Colors.black),)),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      //
                      //remove item/product from cart
                      cartItems.removeAt(index);
                      await CartServices.saveCartItems(cartItems);
                      initialise();

                      //close dialog
                      viewContext.pop();
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(AppColor.primaryColor),
                    ),
                    child: Container(
                      width: 50,
                      // padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 15),
                      child: Center(child: Text("yes".tr(),style: TextStyle(color: Colors.white),)),
                    ),
                  ),
                ],
              )
            ],
          ),
        )
            // .glassMorphic(opacity: 0.3,borderRadius: BorderRadius.circular(20)),
      );
    });

  }

  //
  updateCartItemQuantity(int qty, int index) async {
    final cart = cartItems[index];
    bool addedQty = qty > cart.selectedQty!;
    //
    if (addedQty) {
      int qtyDiff = qty - cart.selectedQty!;
      final canAdd = await CartUIServices.cartItemQtyUpdated(
        viewContext,
        qtyDiff,
        cart,
      );
      //
      if (!canAdd) {
        qty = cart.selectedQty ?? 1;
        pageKey = GlobalKey<State>();
        notifyListeners();
        return;
      }
    }

    cartItems[index].selectedQty = qty;
    await CartServices.saveCartItems(cartItems);
    initialise();
  }

  //
  couponCodeChange(String code) {
    canApplyCoupon = code.isNotEmpty;
    notifyListeners();
  }

  //
  applyCoupon() async {
    //
    setBusyForObject("coupon", true);
    try {
      coupon = await cartRequest.fetchCoupon(couponTEC.text);
      //
      log(coupon!.toJson().toString());
      if (coupon!.useLeft <= 0) {
        throw "Coupon use limit exceeded".tr();
      } else if (coupon!.expired) {
        throw "Coupon has expired".tr();
      }
      clearErrors();
      //re-calculate the cart price with coupon
      calculateSubTotal();
    } catch (error) {
      print("errorrr ==> $error");
      setErrorForObject("coupon", error);
      coupon = null;
      calculateSubTotal();
    }
    setBusyForObject("coupon", false);
  }

  //
  checkoutPressed() async {
    //
    bool canOpenCheckout = true;
    if (!AuthServices.authenticated()) {
      //
      final result =
          await Navigator.of(viewContext).pushNamed(AppRoutes.loginRoute);
      if (result == null || result == false) {
        canOpenCheckout = false;
      }
    }

    //
    CheckOut checkOut = CheckOut();
    checkOut.coupon = coupon;
    checkOut.subTotal = subTotalPrice;
    checkOut.discount = discountCartPrice;
    checkOut.total = totalCartPrice;
    checkOut.totalWithTip = totalCartPrice;
    checkOut.cartItems = cartItems;

    //
    if (canOpenCheckout) {
      dynamic result;
      //check if multiple vendor order was added to cart
      if (AppStrings.enableMultipleVendorOrder &&
          CartServices.isMultipleOrder()) {
        result = await viewContext.push(
          (ctx) => MultipleOrderCheckoutPage(checkout: checkOut),
        );
      } else {
        result = await Navigator.of(viewContext).pushNamed(
          AppRoutes.checkoutRoute,
          arguments: checkOut,
        );
      }

      if (result != null && result) {
        //
        await CartServices.saveCartItems([]);
        viewContext.pop();
      }
    }
  }
}
