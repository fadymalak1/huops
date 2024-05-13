import 'package:flutter/material.dart';
import 'package:huops/models/delivery_address.dart';
import 'package:huops/services/validator.service.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/view_models/delivery_address/edit_delivery_addresses.vm.dart';
import 'package:huops/views/pages/delivery_address/widgets/what3words.view.dart';
import 'package:huops/widgets/base.page.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:huops/widgets/custom_text_form_field.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class EditDeliveryAddressesPage extends StatelessWidget {
  const EditDeliveryAddressesPage({
    this.deliveryAddress,
    Key? key,
  }) : super(key: key);

  final DeliveryAddress? deliveryAddress;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EditDeliveryAddressesViewModel>.reactive(
      viewModelBuilder: () =>
          EditDeliveryAddressesViewModel(context, deliveryAddress),
      onViewModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        return BasePage(
          showAppBar: true,
          showLeadingAction: true,
          title: "Update Delivery Address".tr(),
          body: Form(
            key: vm.formKey,
            child: VStack(
              [
                //
                "Name".tr().text.semiBold.xl.color(Colors.white).make(),
                CustomTextFormField(
                  hintText: "Name".tr(),
                  textEditingController: vm.nameTEC,
                  validator: FormValidator.validateName,
                ).glassMorphic(),
                //what3words
                What3wordsView(vm),
                "Address".tr().text.semiBold.xl.color(Colors.white).make(),
                CustomTextFormField(
                  hintText: "Address".tr(),
                  isReadOnly: true,
                  textEditingController: vm.addressTEC,
                  validator: (value) => FormValidator.validateEmpty(
                    value,
                    errorTitle: "Address".tr(),
                  ),
                  onTap: vm.openLocationPicker,
                ).glassMorphic().py2(),
                // description
                UiSpacer.verticalSpace(),
                "Description".tr().text.semiBold.xl.color(Colors.white).make(),
                CustomTextFormField(
                  hintText: "Description".tr(),
                  textEditingController: vm.descriptionTEC,
                  keyboardType: TextInputType.multiline,
                  minLines: 3,
                  textInputAction: TextInputAction.newline,
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
                    "Default".tr().text.make(),
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
                  shapeRadius: 15,
                  padding: EdgeInsets.all(5),
                  title: "Save".tr(),
                  onPressed: vm.updateDeliveryAddress,
                  loading: vm.isBusy,
                ).centered(),
              ],
            ).p20().scrollVertical(),
          ),
        );
      },
    );
  }
}
