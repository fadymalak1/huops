import 'package:flutter/material.dart';
import 'package:huops/constants/app_strings.dart';
import 'package:huops/extensions/string.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/view_models/taxi.vm.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:huops/widgets/currency_hstack.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class OrderTaxiButton extends StatelessWidget {
  const OrderTaxiButton(this.vm, {Key? key}) : super(key: key);

  final TaxiViewModel vm;

  @override
  Widget build(BuildContext context) {
    //
    final currencySymbol = (vm.selectedVehicleType?.currency != null
        ? vm.selectedVehicleType?.currency?.symbol
        : AppStrings.currencySymbol);
    //
    return Visibility(
      visible: vm.selectedVehicleType != null,
      child: CustomButton(
        loading: vm.isBusy,
        child: HStack(
          [
            "Order Now".tr().text.medium.lg.make(),
            UiSpacer.hSpace(10),
            CurrencyHStack(
              [
                "${currencySymbol} ".text.semiBold.xl.make(),
                Visibility(
                  visible: (vm.subTotal > vm.total),
                  child: HStack(
                    [
                      "${vm.subTotal.currencyValueFormat()}"
                          .text
                          .medium
                          .lineThrough
                          .make(),
                      "${vm.total.currencyValueFormat()}"
                          .text
                          .semiBold
                          .xl
                          .make(),
                    ],
                  ),
                ),
                Visibility(
                  visible: !(vm.subTotal > vm.total),
                  child: "${vm.total.currencyValueFormat()}"
                      .text
                      .semiBold
                      .xl
                      .make(),
                ),
              ],
            ),
          ],
        ),
        onPressed: vm.selectedVehicleType != null ? vm.processNewOrder : null,
      ).wFull(context),
    );
  }
}
