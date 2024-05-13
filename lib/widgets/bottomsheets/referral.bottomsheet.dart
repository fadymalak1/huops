import 'package:flutter/material.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/constants/app_images.dart';
import 'package:huops/constants/app_strings.dart';
import 'package:huops/extensions/dynamic.dart';
import 'package:huops/extensions/string.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/utils/utils.dart';
import 'package:huops/view_models/profile.vm.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class ReferralBottomsheet extends StatelessWidget {
  const ReferralBottomsheet(
    this.profileViewModel, {
    Key? key,
  }) : super(key: key);

  //
  final ProfileViewModel profileViewModel;

  //
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //image
        Image.asset(
          AppImages.refer,
          width: context.percentWidth * 60,
          height: context.percentWidth * 60,
        ).centered(),
        //title
        // "Refer & Earn".tr().text.semiBold.xl.makeCentered().py4(),
        "Share this code with your family and friends and you could earn %s when they completed their first order"
            .tr()
            .fill([
              "${AppStrings.currencySymbol} ${AppStrings.referAmount}"
                  .currencyFormat(),
            ])
            .text.color(Vx.gray200)
            .center
            .makeCentered(),
        UiSpacer.verticalSpace(),
        //referral code
        HStack(
          [
            //code
            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Vx.gray200,),
              child: "${profileViewModel.currentUser?.code}"
                  .text
                  .bold
                  .color(Colors.black)
                  .make()
                  .px32()
                  .py12()
                  .box
                  .make(),
            ),
            20.widthBox,
            //share button
            Container(
              width: 100,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: AppColor.primaryColor,),
              child: "Share"
                  .tr()
                  .text
                  .color(Utils.isDark(AppColor.primaryColor)
                  ? Colors.white
                  : Colors.black).center
                  .make()
                  .box
                  .p12
                  .make().onInkTap(profileViewModel.shareReferralCode),
            ),
          ],
        ).box.roundedSM.clip(Clip.antiAlias).make().centered(),
      ],
    )
        .p20()
        .scrollVertical()
        .hHalf(context)
        .box
        .topRounded()
        .make().glassMorphic(borderRadius: BorderRadius.only(topRight: Radius.circular(40),topLeft: Radius.circular(40)),opacity: 0.2,blur: 8,);
  }
}
