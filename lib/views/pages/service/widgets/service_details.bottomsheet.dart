import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/constants/app_text_styles.dart';
import 'package:huops/view_models/service_details.vm.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:huops/widgets/buttons/qty_stepper.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class ServiceDetailsBottomSheet extends StatelessWidget {
  const ServiceDetailsBottomSheet(this.vm, {Key? key}) : super(key: key);
  final ServiceDetailsViewModel vm;
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //hour selection
        Visibility(
          visible: !vm.service.isFixed,
          child: HStack(
            [
              //
              "${vm.service.duration.capitalize()}"
                  .tr()
                  .text
                  .medium
                  .xl
                  .make()
                  .expand(),
              QtyStepper(
                defaultValue: 1,
                min: 1,
                max: 24,
                actionButtonColor: AppColor.primaryColor,
                disableInput: true,
                onChange: (value) {
                  vm.service.selectedQty = value;
                  vm.notifyListeners();
                },
              ),
            ],
          ),
        ),

        Visibility(
          visible: !vm.service.isFixed,
          child: 2.heightBox,
        ),

        //
        CustomButton(
          title: "Continue".tr(),
          titleStyle: AppTextStyle.h4TitleTextStyle(
            color: Colors.white,
          ),
          onPressed: vm.bookService,
        ).h(50),
      ],
    )
        .px(20)
        .py(8).cornerRadius(15)
        .box
        // .shadowSm
        // .color(context.theme.colorScheme.background)
        .make();
  }
}
