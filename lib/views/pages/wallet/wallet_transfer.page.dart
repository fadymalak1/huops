import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/extensions/string.dart';
import 'package:huops/models/user.dart';
import 'package:huops/models/wallet.dart';
import 'package:huops/services/validator.service.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/utils/utils.dart';
import 'package:huops/view_models/wallet_transfer.vm.dart';
import 'package:huops/widgets/base.page.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:huops/widgets/custom_text_form_field.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

import 'widgets/selected_wallet_user.dart';

class WalletTransferPage extends StatelessWidget {
  const WalletTransferPage(this.wallet, {Key? key}) : super(key: key);
  //
  final Wallet wallet;

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: "Wallet Transfer".tr(),
      showLeadingAction: true,
      showAppBar: true,
      body: ViewModelBuilder<WalletTransferViewModel>.reactive(
        viewModelBuilder: () => WalletTransferViewModel(context, wallet),
        onViewModelReady: (vm) => vm.initialise(),
        builder: (context, vm, child) {
          return Form(
            key: vm.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: VStack(
              [
                //amount
                "Amount".tr().text.bold.color(Colors.white).lg.make(),
                CustomTextFormField(
                  hintText: "Amount".tr(),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textEditingController: vm.amountTEC,
                  underline: true,
                  validator: (value) => FormValidator.validateCustom(
                    value,
                    name: "Amount".tr(),
                    rules: "required|lt:${vm.wallet?.balance}",
                  ),
                ).glassMorphic(),
                UiSpacer.formVerticalSpace(),
                //receiver email/phone
                "Receiver".tr().text.lg.semiBold.color(Colors.white).make(),
                UiSpacer.verticalSpace(space: 6),
                //Receiver row data
                Row(
                  children: [
                    //
                    TypeAheadField(
                      hideOnLoading: true,
                      hideSuggestionsOnKeyboardHide: false,
                      minCharsForSuggestions: 2,
                      debounceDuration: const Duration(seconds: 1),
                      textFieldConfiguration: TextFieldConfiguration(
                        autofocus: false,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Email/Phone".tr(),
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                      suggestionsCallback: vm.searchUsers,
                      itemBuilder: (context, User? suggestion) {
                        if (suggestion == null) {
                          return Divider();
                        }
                        //
                        return VStack(
                          [
                            VStack(
                              [
                                "${suggestion.name}".text.semiBold.lg.make(),
                                UiSpacer.vSpace(5),
                                "${suggestion.code ?? ''} - ${suggestion.phone.isNotBlank ? suggestion.phone.maskString(
                                        start: 3,
                                        end: 8,
                                      ) : ''}"
                                    .text
                                    .sm
                                    .make(),
                              ],
                            ).px12().py(3),
                            Divider(),
                          ],
                        );
                      },
                      onSuggestionSelected: vm.userSelected,
                    ).glassMorphic().expand(),
                    UiSpacer.horizontalSpace(space: 10),
                    //scan qrcode
                    Icon(
                      FlutterIcons.qrcode_ant,
                      size: 35,
                      color: Utils.textColorByTheme(),
                    )
                        .p8()
                        .box
                        .roundedSM
                        // .color(AppColor.primaryColor)
                        .make().glassMorphic()
                        .onInkTap(vm.scanWalletAddress),
                  ],
                ),
                //selected user view
                if (vm.selectedUser != null)
                  SelectedWalletUser(vm.selectedUser!),

                UiSpacer.formVerticalSpace(),
                //account password
                "Password".tr().text.bold.color(Colors.white).lg.make(),
                CustomTextFormField(
                  hintText: "Password".tr(),
                  textEditingController: vm.passwordTEC,
                  obscureText: true,
                  underline: true,
                  validator: FormValidator.validatePassword,
                ).glassMorphic(),
                UiSpacer.formVerticalSpace(),
                //send button
                CustomButton(
                  loading: vm.isBusy,
                  shapeRadius: 15,
                  padding: EdgeInsets.all(5),
                  title: "Transfer".tr(),
                  onPressed: vm.initiateWalletTransfer,
                ).wFull(context),
                UiSpacer.formVerticalSpace(),
              ],
            ).p20().scrollVertical(),
          );
        },
      ),
    );
  }
}
