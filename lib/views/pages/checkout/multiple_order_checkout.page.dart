import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:huops/models/checkout.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/view_models/multiple_checkout.vm.dart';
import 'package:huops/views/pages/checkout/widgets/driver_cash_delivery_note.view.dart';
import 'package:huops/views/pages/checkout/widgets/order_delivery_address.view.dart';
import 'package:huops/views/pages/checkout/widgets/payment_methods.view.dart';
import 'package:huops/views/pages/checkout/widgets/schedule_order.view.dart';
import 'package:huops/widgets/base.page.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:huops/widgets/cards/multiple_vendor_order_summary.dart';
import 'package:huops/widgets/custom_text_form_field.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class MultipleOrderCheckoutPage extends StatelessWidget {
  const MultipleOrderCheckoutPage({
    required this.checkout,
    Key? key,
  }) : super(key: key);

  final CheckOut checkout;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MultipleCheckoutViewModel>.reactive(
      viewModelBuilder: () => MultipleCheckoutViewModel(context, checkout),
      onViewModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        return BasePage(
          showAppBar: true,
          showLeadingAction: true,
          title: "Multiple Order Checkout".tr(),
          body: VStack(
            [
              //
              // UiSpacer.verticalSpace(),
              //
              "Note".tr().text.bold.color(Colors.white).lg.make(),
              CustomTextFormField(
                hintText: "Note".tr(),
                textEditingController: vm.noteTEC,
                fillColor: Colors.white,
              ),

              //note
              Divider(thickness: 2,color: Color(0xff575270),).py12(),

              //pickup time slot
              ScheduleOrderView(vm),

              //its pickup
              OrderDeliveryAddressPickerView(vm),

              //payment options
              Visibility(
                visible: vm.canSelectPaymentOption,
                child: PaymentMethodsView(vm),
              ),

              //order final price preview
              MultipleVendorOrderSummary(
                subTotal: vm.checkout!.subTotal,
                deliveryFee: vm.totalDeliveryFee,
                discount: (vm.checkout!.coupon?.for_delivery ?? false)
                    ? null
                    : vm.checkout!.discount,
                deliveryDiscount: (vm.checkout!.coupon?.for_delivery ?? false)
                    ? vm.checkout!.discount
                    : null,
                totalTax: vm.taxes.sum(),
                totalFee: vm.vendorFees.sum(),
                taxes: vm.taxes,
                vendors: vm.vendors,
                subtotals: vm.subtotals,
                driverTip: double.tryParse(vm.driverTipTEC.text) ?? 0.00,
                total: vm.checkout!.total,
              ),

              //show notice it driver should be paid in cash
              if (vm.checkout!.deliveryAddress != null)
                CheckoutDriverCashDeliveryNoticeView(
                  vm.checkout!.deliveryAddress!,
                ),
              //
              CustomButton(
                title: "PLACE ORDER".tr().padRight(14),
                // icon: FlutterIcons.credit_card_fea,
                shapeRadius: 15,
                padding: EdgeInsets.all(5),
                onPressed: vm.placeOrder,
                loading: vm.isBusy,
              ).centered().py16(),
            ],
          ).p20().scrollVertical().pOnly(bottom: context.mq.viewInsets.bottom),
        );
      },
    );
  }
}
