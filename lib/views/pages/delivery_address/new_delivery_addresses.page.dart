import 'package:flutter/material.dart';
import 'package:huops/services/validator.service.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/view_models/delivery_address/new_delivery_addresses.vm.dart';
import 'package:huops/views/pages/delivery_address/widgets/what3words.view.dart';
import 'package:huops/widgets/base.page.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:huops/widgets/custom_text_form_field.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class NewDeliveryAddressesPage extends StatelessWidget {
  const NewDeliveryAddressesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewDeliveryAddressesViewModel>.reactive(
      viewModelBuilder: () => NewDeliveryAddressesViewModel(context),
      onViewModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        return BasePage(
          showAppBar: true,
          showLeadingAction: true,
          title: "New Delivery Address".tr(),
          body: Form(
              key: vm.formKey,
              child: VStack(
                [
                  //
                  CustomTextFormField(
                    hintText: "Name".tr(),
                    textEditingController: vm.nameTEC,
                    validator: FormValidator.validateName,
                  ).glassMorphic(),
                  //what3words
                  What3wordsView(vm),
                  //
                  CustomTextFormField(
                    hintText: "Address".tr(),
                    isReadOnly: true,
                    textEditingController: vm.addressTEC,
                    validator: (value) => FormValidator.validateEmpty(value,
                        errorTitle: "Address".tr()),
                    onTap: vm.openLocationPicker,
                  ).glassMorphic().py2(),
                  // description
                  UiSpacer.verticalSpace(),
                  CustomTextFormField(
                    hintText: "Description".tr(),
                    textEditingController: vm.descriptionTEC,
                    keyboardType: TextInputType.multiline,
                    minLines: 3,
                    textInputAction: TextInputAction.newline,
                    // fillColor: Colors.white,
                  ).glassMorphic().py2(),
                  //
                  HStack(
                    [
                      Checkbox(
                        value: vm.isDefault,
                        onChanged: vm.toggleDefault,
                        checkColor: Colors.white,
                        activeColor: Color(0xffd53c25),
                        // fillColor: MaterialStatePropertyAll(Colors.white),
                        fillColor: MaterialStateProperty.resolveWith((states) {
                          if (!states.contains(MaterialState.selected)) {
                            return Colors.white;
                          }
                          return null;
                        }),
                        side: MaterialStateBorderSide.resolveWith(
                              (states) => BorderSide(width: 0.0),
                        ),
                      ),
                      //
                      "Default".tr().text.color(Colors.white).make(),
                    ],
                  )
                      .onInkTap(
                        () => vm.toggleDefault(!vm.isDefault),
                      )
                      .wFull(context)
                      .py12(),

                  CustomButton(
                    isFixedHeight: true,
                    height: Vx.dp48,
                    title: "Save".tr(),
                    onPressed: (){
                      vm.saveNewDeliveryAddress(context);
                    },
                    loading: vm.isBusy,
                  ).centered(),
                ],
              )
                  .p20()
                  .scrollVertical()
                  .pOnly(bottom: context.mq.viewInsets.bottom)),
        );
      },
    );
  }
}
