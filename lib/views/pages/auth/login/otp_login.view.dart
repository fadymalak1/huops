import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/services/validator.service.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/view_models/login.view_model.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:huops/widgets/custom_text_form_field.dart';
import 'package:huops/widgets/states/loading.shimmer.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class OTPLoginView extends StatelessWidget {
  const OTPLoginView(this.model, {Key? key}) : super(key: key);

  final LoginViewModel model;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: model.formKey,
      child: VStack(
        [
          //
          HStack(
            [
              CustomTextFormField(
                prefixIcon: HStack(
                  [
                    //icon/flag
                    Flag.fromString(
                      model.selectedCountry?.countryCode ?? "us",
                      width: 20,
                      height: 20,
                    ),
                    UiSpacer.horizontalSpace(space: 5),
                    //text
                    ("+" + (model.selectedCountry?.phoneCode ?? "1"))
                        .text
                        .make(),
                  ],
                ).px8().onInkTap(model.showCountryDialPicker),
                hintText: "Phone".tr(),
                keyboardType: TextInputType.phone,
                textEditingController: model.phoneTEC,
                validator: FormValidator.validatePhone,
              ).expand(),
            ],
          ).glassMorphic().py12(),
          //

          SizedBox(
            height: 70,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                textStyle: TextStyle(fontSize: 20),
              ),
                    onPressed: model.processOTPLogin,
                    child: model.busy(model.otpLogin)
                        ? CircularProgressIndicator(color: Colors.white,strokeWidth: 1,)
                        : Text("Login".tr()))
                .wFull(context)
                .py12(),
          ),
        ],
        crossAlignment: CrossAxisAlignment.end,
      ),
    ).py20();
  }
}
