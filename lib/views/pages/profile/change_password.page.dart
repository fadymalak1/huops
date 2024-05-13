import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:huops/services/validator.service.dart';
import 'package:huops/view_models/change_password.vm.dart';
import 'package:huops/widgets/base.page.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:huops/widgets/custom_text_form_field.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../constants/app_images.dart';
import '../../../widgets/busy_indicator.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChangePasswordViewModel>.reactive(
      viewModelBuilder: () => ChangePasswordViewModel(context),
      onViewModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return BasePage(
          showLeadingAction: true,
          showAppBar: true,
          title: "Change Password".tr(),
          body: SafeArea(
              top: true,
              bottom: false,
              child:
                  //
                  VStack(
                [
                  //form
                  Form(
                    key: model.formKey,
                    child: VStack(
                      [
                        //
                        "Current Password".tr().text.bold.color(Colors.white).lg.make(),
                        CustomTextFormField(
                          hintText: "Current Password".tr(),
                          obscureText: true,
                          textEditingController: model.currentPasswordTEC,
                          validator: FormValidator.validatePassword,
                        ).glassMorphic().py12(),
                        //
                        "New Password".tr().text.bold.color(Colors.white).lg.make(),
                        CustomTextFormField(
                          hintText: "New Password".tr(),
                          obscureText: true,
                          textEditingController: model.newPasswordTEC,
                          validator: FormValidator.validatePassword,
                        ).glassMorphic().py12(),
                        //
                        "Confirm New Password".tr().text.bold.color(Colors.white).lg.make(),
                        CustomTextFormField(
                          hintText: "Confirm New Password".tr(),
                          obscureText: true,
                          textEditingController: model.confirmNewPasswordTEC,
                          validator: FormValidator.validatePassword,
                        ).glassMorphic().py12(),

                        //
                        CustomButton(
                          title: "Update Password".tr(),
                          shapeRadius: 15,
                          padding: EdgeInsets.all(5),
                          loading: model.isBusy,
                          onPressed: model.processUpdate,
                        ).centered().py12(),
                      ],
                    ),
                  ),
                ],
              ).p20().scrollVertical()),
        );
      },
    );
  }
}
