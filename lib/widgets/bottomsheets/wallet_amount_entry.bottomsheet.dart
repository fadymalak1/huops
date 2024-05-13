import 'package:flutter/material.dart';
import 'package:huops/services/validator.service.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:huops/widgets/custom_text_form_field.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class WalletAmountEntryBottomSheet extends StatefulWidget {
  WalletAmountEntryBottomSheet({
    required this.onSubmit,
    Key? key,
  }) : super(key: key);

  final Function(String) onSubmit;
  @override
  _WalletAmountEntryBottomSheetState createState() =>
      _WalletAmountEntryBottomSheetState();
}

class _WalletAmountEntryBottomSheetState
    extends State<WalletAmountEntryBottomSheet> {
  //
  final formKey = GlobalKey<FormState>();
  final amountTEC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.mq.viewInsets.bottom),
      child: VStack(
        [
          //
          20.heightBox,
          //
          "Top-Up Wallet".tr().text.xl2.color(Colors.white).semiBold.make(),
          "Enter amount to top-up wallet with".tr().text.color(Colors.white).make(),
          Form(
            key: formKey,
            child: CustomTextFormField(
              hintText: "Amount".tr(),
              textEditingController: amountTEC,
              underline: true,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              validator: (value) => FormValidator.validateEmpty(
                value,
                errorTitle: "Amount".tr(),
              ),
            ).glassMorphic(),
          ).py12(),
          //
          CustomButton(
            title: "TOP-UP".tr(),
            shapeRadius: 15,
            padding: EdgeInsets.all(5),
            onPressed: () {
              //
              if (formKey.currentState!.validate()) {
                widget.onSubmit(amountTEC.text);
              }
            },
          ),
          //
          20.heightBox,
        ],
      )
          .p20()
          .scrollVertical()
          .hOneThird(context)
          .box
          .topRounded(value: 15)
          .make().glassMorphic(borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15)),opacity: 0.1),
    );
  }
}
