import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/constants/app_strings.dart';
import 'package:huops/models/checkout.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/view_models/checkout.vm.dart';
import 'package:huops/views/pages/checkout/widgets/driver_cash_delivery_note.view.dart';
import 'package:huops/views/pages/checkout/widgets/order_delivery_address.view.dart';
import 'package:huops/views/pages/checkout/widgets/payment_methods.view.dart';
import 'package:huops/views/pages/checkout/widgets/schedule_order.view.dart';
import 'package:huops/widgets/base.page.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:huops/widgets/cards/order_summary.dart';
import 'package:huops/widgets/custom_text_form_field.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/services.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({
    required this.checkout,
    Key? key,
  }) : super(key: key);

  final CheckOut checkout;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CheckoutViewModel>.reactive(
      viewModelBuilder: () => CheckoutViewModel(context, checkout),
      onViewModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        return BasePage(
          showAppBar: true,
          showLeadingAction: true,
          title: "Checkout".tr(),
          body: VStack(
            [
              //
              // UiSpacer.verticalSpace(),
              Visibility(
                visible: !vm.isPickup,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    "Driver Tip".tr().text.bold.color(Colors.white).lg.make(),
                    SizedBox(
                      height: 5,
                    ),
                    CustomTextFormField(
                      hintText:
                          "Driver Tip".tr() + " (${AppStrings.currencySymbol})",
                      textEditingController: vm.driverTipTEC,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onFieldSubmitted: (value) => vm.updateTotalOrderSummary(),
                    ).glassMorphic().pOnly(bottom: Vx.dp20),
                  ],
                ),
              ),
              //
              "Note".tr().text.bold.color(Colors.white).lg.make(),
              SizedBox(
                height: 5,
              ),
              CustomTextFormField(
                hintText: "Note".tr(),
                textEditingController: vm.noteTEC,
              ).glassMorphic(),

              //note
              Divider(
                thickness: 1,
                color: Color(0xff575270),
              ).py12(),

              //pickup time slot
              Visibility(
                visible:  vm.vendor!.allowScheduleOrder,
                child: ScheduleOrderView(vm),
              ),

              //its pickup
              OrderDeliveryAddressPickerView(vm),

              //payment options
              Visibility(
                visible: vm.canSelectPaymentOption,
                child: PaymentMethodsView(vm),
              ),

              //order final price preview
              OrderSummary(
                subTotal: vm.checkout!.subTotal,
                discount: (vm.checkout!.coupon?.for_delivery ?? false)
                    ? null
                    : vm.checkout!.discount,
                deliveryDiscount: (vm.checkout!.coupon?.for_delivery ?? false)
                    ? vm.checkout!.deliveryDiscount
                    : null,
                deliveryFee: vm.checkout!.deliveryFee,
                tax: vm.checkout!.tax,
                vendorTax: vm.vendor!.tax,
                driverTip: double.tryParse("${vm.driverTipTEC.text}") ?? 0.00,
                total: vm.checkout!.totalWithTip,
                fees: vm.vendor!.fees,
              ),

              //show notice it driver should be paid in cash
              if (vm.checkout!.deliveryAddress != null)
                CheckoutDriverCashDeliveryNoticeView(
                  vm.checkout!.deliveryAddress!,
                ),
              //
              SizedBox(
                height: 70,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle: TextStyle(fontSize: 20),
                    ),
                    onPressed: vm.placeOrder,
                    child: vm.isBusy
                        ? CircularProgressIndicator(color: Colors.white,strokeWidth: 1,)
                        : Text("PLACE ORDER".tr(),),)
                    .wFull(context)
                    .py12(),
              ),

            ],
          ).p20().scrollVertical().pOnly(bottom: context.mq.viewInsets.bottom),
        );
      },
    );
  }
}
