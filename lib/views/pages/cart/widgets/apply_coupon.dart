import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/view_models/cart.vm.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:huops/widgets/custom_text_form_field.dart';
import 'package:huops/widgets/states/empty.state.dart';
import 'package:huops/widgets/states/loading.shimmer.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class ApplyCoupon extends StatelessWidget {
  const ApplyCoupon(this.vm, {Key? key}) : super(key: key);

  final CartViewModel vm;
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //
        "Add Coupon".tr().text.semiBold.xl.color(Colors.white).make(),
        UiSpacer.verticalSpace(space: 10),
        //
        vm.isAuthenticated()
            ? vm.busy(vm.coupon) || vm.busy("coupon")?Center(child: LoadingShimmer(),):CustomTextFormField(
                hintText: "Coupon Code".tr(),
                textEditingController: vm.couponTEC,
                onChanged: vm.couponCodeChange,
                suffixIcon: Container(
                  color: vm.canApplyCoupon ?Colors.green: Colors.grey,
                  child: IconButton(
                    icon: Icon(
                      FlutterIcons.check_ant,
                      color: Colors.white,
                      size: 20,
                    ),
                    // loading: vm.busy(vm.coupon) || vm.busy("coupon"),
                    onPressed: vm.canApplyCoupon ? vm.applyCoupon : null,
                  ).w(50).px8(),
                ),
              ).glassMorphic()
            : VStack(
                [
                  //
                  EmptyState(
                    auth: true,
                    showImage: false,
                    actionPressed: vm.openLogin,
                  ),
                ],
              ),
      ],
    );
  }
}
