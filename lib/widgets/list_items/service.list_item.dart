import 'package:flutter/material.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/constants/app_strings.dart';
import 'package:huops/extensions/string.dart';
import 'package:huops/models/service.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/widgets/cards/custom.visibility.dart';
import 'package:huops/widgets/currency_hstack.dart';
import 'package:huops/widgets/custom_image.view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class ServiceListItem extends StatelessWidget {
  const ServiceListItem({
    required this.service,
    required this.onPressed,
    required this.imgW,
    required this.height,
    Key? key,
  }) : super(key: key);

  final Function(Service) onPressed;
  final Service service;
  final double? imgW;
  final double? height;
  @override
  Widget build(BuildContext context) {
    return HStack(
      [
        //service image
        CustomVisibilty(
          visible: service.photos != null && service.photos!.isNotEmpty,
          child: Hero(
            tag: service.heroTag ?? service.id,
            child: CustomImage(
              imageUrl: service.photos!.firstOrElse(() => ""),
              boxFit: BoxFit.cover,
              width: imgW ?? (height != null ? (height! * 2.2) : 75),
              height: height ?? 70,
            ).box.clip(Clip.antiAlias).make(),
          ),
        ).h(height ?? 70).wh(Vx.dp64, Vx.dp64).cornerRadius(15).p(15),
        // "${service.photos}".text.make(),

        VStack(
          [
            //name/title
            service.name.text.xl.make(),
            //description
            CustomVisibilty(
              visible: service.description.isNotEmpty,
              child: service.description.text.gray600.sm.thin
                  .maxLines(1)
                  .overflow(TextOverflow.ellipsis)
                  .make(),
            ),
            //price
            FittedBox(
              child: HStack(
                [
                  "${service.hasOptions ? "From".tr() : ""} ".text.sm.make(),
                  CurrencyHStack(
                    [
                      "${AppStrings.currencySymbol}"
                          .text
                          .base
                          .light
                          .red500
                          .make(),
                      UiSpacer.horizontalSpace(space: 5),
                      service.sellPrice
                          .currencyValueFormat()
                          .text
                          .semiBold
                          .red500
                          .xl
                          .make(),
                    ],
                  ),
                  
                  " ${service.durationText}".text.medium.xs.make(),
                  //
                  UiSpacer.horizontalSpace(),
                  //dsicount
                  Visibility(
                    visible: service.showDiscount,
                    child:
                        "- ${service.discountPercentage}%".text.gray300.make(),
                  ),
                ],
              ),
            ),
          ],
        ).py4().px12().expand(),
      ],
    )
        .box
        .withRounded(value: 10)
        .clip(Clip.antiAlias)
        .makeCentered()
        .onInkTap(
          () => this.onPressed(this.service),
        ).glassMorphic(opacity: 0.1);
  }
}
