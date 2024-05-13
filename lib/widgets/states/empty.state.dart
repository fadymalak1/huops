import 'package:flutter/material.dart';
import 'package:huops/constants/app_images.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    Key? key,
    this.imageUrl,
    this.title = "",
    this.actionText = "Action",
    this.description = "",
    this.showAction = false,
    this.showImage = true,
    this.actionPressed,
    this.auth = false,
  }) : super(key: key);

  final String title;
  final String actionText;
  final String description;
  final String? imageUrl;
  final Function? actionPressed;
  final bool showAction;
  final bool showImage;
  final bool auth;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: VStack(
        [
          //
          (imageUrl != null && imageUrl.isNotEmptyAndNotNull)
              ? Image.asset(imageUrl!)
                  .wh(
                    context.percentWidth * 50,
                    context.percentWidth * 50,
                  )
                  .box
                  .makeCentered()
                  .wFull(context)
              : UiSpacer.emptySpace(),
          UiSpacer.vSpace(5),

          //
          (title.isNotEmpty)
              ? title.text.lg.semiBold.center.makeCentered()
              : SizedBox.shrink(),

          //
          (auth && showImage)
              ? Image.asset(AppImages.auth)
                  .wh(
                    Vx.dp64,
                    Vx.dp64,
                  )
                  .box
                  .makeCentered()
                  .py12()
                  .wFull(context)
              : SizedBox.shrink(),
          //
          auth
              ? "You have to login to access profile and history"
                  .tr()
                  .text
                  .center
                  .sm.color(Colors.white)
                  .light
                  .makeCentered()
                  .py12()
              : description.isNotEmpty
                  ? description.text.sm.light.center.makeCentered()
                  : SizedBox.shrink(),

          //
          auth
              ? CustomButton(
                  title: "Login".tr(),
                  shapeRadius: 15,
                  onPressed: actionPressed,
                ).centered().px20()
              : showAction
                  ? CustomButton(
                      title: actionText.tr(),
                      onPressed: actionPressed,
                    ).centered().py12()
                  : SizedBox.shrink(),
        ],
        crossAlignment: CrossAxisAlignment.center,
        alignment: MainAxisAlignment.center,
      ).wFull(context).centered().p12(),
    );
  }
}
