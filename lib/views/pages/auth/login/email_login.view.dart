import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/services/validator.service.dart';
import 'package:huops/view_models/login.view_model.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:huops/widgets/custom_text_form_field.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class EmailLoginView extends StatelessWidget {
  const EmailLoginView(this.model, {Key? key}) : super(key: key);

  final LoginViewModel model;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: model.formKey,
      child: VStack(
        [
          //
          CustomTextFormField(
            hintText: "Email".tr(),
            keyboardType: TextInputType.emailAddress,
            textEditingController: model.emailTEC,

            validator: FormValidator.validateEmail,
            inputFormatters: [
              FilteringTextInputFormatter.deny(
                RegExp(' '),
              ),
            ],
          ).glassMorphic().py12(),
          CustomTextFormField(
            hintText: "Password".tr(),
            obscureText: true,
            textEditingController: model.passwordTEC,
            validator: FormValidator.validatePassword,
          ).glassMorphic().py12(),

          //
          "Forgot Password ?".tr().text.underline.make().onInkTap(
                model.openForgotPassword,
              ),
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
                onPressed: model.processLogin,
                child: model.isBusy
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
