import 'package:flutter/material.dart';
import 'package:huops/view_models/checkout_base.vm.dart';
import 'package:huops/widgets/custom_grid_view.dart';
import 'package:huops/widgets/list_items/payment_method.list_item.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class PaymentMethodsView extends StatelessWidget {
  const PaymentMethodsView(this.vm, {Key? key}) : super(key: key);

  final CheckoutBaseViewModel vm;

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        "Payment Methods".tr().text.color(Colors.white).semiBold.xl.make(),
        CustomGridView(
          noScrollPhysics: true,
          dataSet: vm.paymentMethods,
          childAspectRatio: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 3,
          isLoading: vm.busy(vm.paymentMethods),
          itemBuilder: (context, index) {
            //
            final paymentMethod = vm.paymentMethods[index];
            return PaymentOptionListItem(
              paymentMethod,
              selected: vm.isSelected(paymentMethod),
              onSelected: vm.changeSelectedPaymentMethod,
            );
          },
        ).pOnly(top: Vx.dp16),
        //
        SizedBox(height: 10,),
        Divider(thickness: 0.5,color: Color(0xff575270),).py12(),
      ],
    );
  }
}
