import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/constants/app_images.dart';
import 'package:huops/constants/app_strings.dart';
import 'package:huops/services/validator.service.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/view_models/register.view_model.dart';
import 'package:huops/widgets/base.page.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:huops/widgets/custom_text_form_field.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({
    this.email,
    this.name,
    this.phone,
    Key? key,
  }) : super(key: key);

  final String? email;
  final String? name;
  final String? phone;
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RegisterViewModel>.reactive(
      viewModelBuilder: () => RegisterViewModel(context),
      onViewModelReady: (model) {
        model.nameTEC.text = widget.name ?? "";
        model.emailTEC.text = widget.email ?? "";
        model.phoneTEC.text = widget.phone ?? "";
        model.initialise();
      },
      builder: (context, model, child) {
        return BasePage(
          body: SafeArea(
            top: true,
            bottom: false,
            child: Padding(
              padding: EdgeInsets.only(bottom: context.mq.viewInsets.bottom),
              child: VStack(
                [
                  Image.asset(
                    AppImages.appLogo,
                  )
                      .h(80)
                      .w(260)
                      .box.py20
                      .clip(Clip.antiAlias)
                      .make().centered(),

                  VStack(
                    [
                      //
                      "Join Us".tr().text.xl2.semiBold.make(),
                      "Create an account now".tr().text.light.make(),

                      //form
                      Form(
                        key: model.formKey,
                        child: VStack(
                          [
                            //
                            CustomTextFormField(
                              hintText: "Name".tr(),
                              textEditingController: model.nameTEC,
                              validator: FormValidator.validateName,
                            ).glassMorphic().py12(),
                            //
                            CustomTextFormField(
                              hintText: "Email".tr(),
                              keyboardType: TextInputType.emailAddress,
                              textEditingController: model.emailTEC,
                              validator: FormValidator.validateEmail,
                              //remove space
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(
                                  RegExp(' '),
                                ), // removes spaces
                              ],
                            ).glassMorphic().py12(),
                            //
                            HStack(
                              [
                                CustomTextFormField(
                                  prefixIcon: HStack(
                                    [
                                      //icon/flag
                                      Flag.fromString(
                                        model.selectedCountry!.countryCode,
                                        width: 20,
                                        height: 20,
                                      ),
                                      UiSpacer.horizontalSpace(space: 5),
                                      //text
                                      ("+" + model.selectedCountry!.phoneCode)
                                          .text
                                          .make(),
                                    ],
                                  ).px8().onInkTap(model.showCountryDialPicker),
                                  hintText: "Phone".tr(),
                                  keyboardType: TextInputType.phone,
                                  textEditingController: model.phoneTEC,
                                  validator: FormValidator.validatePhone,
                                  //remove space
                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(
                                      RegExp(' '),
                                    ), // removes spaces
                                  ],
                                ).expand(),
                              ],
                            ).glassMorphic().py12(),
                            //
                            CustomTextFormField(
                              hintText: "Password".tr(),
                              obscureText: true,
                              textEditingController: model.passwordTEC,
                              validator: FormValidator.validatePassword,
                              //remove space
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(
                                  RegExp(' '),
                                ), // removes spaces
                              ],
                            ).glassMorphic().py12(),
                            //
                            AppStrings.enableReferSystem
                                ? CustomTextFormField(
                                    hintText: "Referral Code(optional)".tr(),
                                    textEditingController:
                                        model.referralCodeTEC,
                                  ).glassMorphic().py12()
                                : UiSpacer.emptySpace(),

                            //terms
                            HStack(
                              [
                                Checkbox(
                                  value: model.agreed,
                                  onChanged: (value) {
                                    model.agreed = value ?? false;
                                    model.notifyListeners();
                                  },
                                ),
                                //
                                "I agree with".tr().text.make(),
                                UiSpacer.horizontalSpace(space: 2),
                                "Terms & Conditions"
                                    .tr()
                                    .text
                                    .color(AppColor.primaryColor)
                                    .bold
                                    .underline
                                    .make()
                                    .onInkTap(model.openTerms)
                                    .expand(),
                              ],
                            ),

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
                                  onPressed: model.processRegister,
                                  child: model.isBusy
                                      ? CircularProgressIndicator(color: Colors.white,strokeWidth: 1,)
                                      : Text("Create Account".tr(),))
                                  .wFull(context)
                                  .py12(),
                            ),

                            //register
                            "OR".tr().text.light.makeCentered(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                              "Have an Account?"
                                  .tr()
                                  .text
                                  .normal
                                  .makeCentered()
                                  .py12(),
                              "Login Now".tr().text.bold.color(AppColor.primaryColor).make().px12().onTap(model.openLogin),
                            ],).centered(),
                          ],
                          crossAlignment: CrossAxisAlignment.end,
                        ),
                      ).py20(),
                    ],
                  ).wFull(context).p20(),

                  //
                ],
              ).scrollVertical(),
            ),
          ),
        );
      },
    );
  }
}
