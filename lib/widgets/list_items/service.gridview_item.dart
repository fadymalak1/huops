import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/constants/app_strings.dart';
import 'package:huops/extensions/dynamic.dart';
import 'package:huops/extensions/string.dart';
import 'package:huops/models/service.dart';
import 'package:huops/models/vendor.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/utils/utils.dart';
import 'package:huops/widgets/cards/vendor_info.view.dart';
import 'package:huops/widgets/custom_image.view.dart';
import 'package:huops/widgets/states/alternative.view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class ServiceGridViewItem extends StatelessWidget {
  const ServiceGridViewItem({
    // required this.service,
    required this.vendor,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final Function(Vendor) onPressed;
  // final Service service;
  final Vendor vendor;

  //
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        Stack(
          children: [
            AlternativeView(
              // ismain: (service.photos != null && service.photos!.isNotEmpty),
              main: CustomImage(
                imageUrl: (vendor.featureImage != null && vendor.featureImage!.isNotEmpty)
                    ? vendor.featureImage
                    : "",
                width: double.infinity,
                height: 120,
              ),
              // alt: Container(
              //   color: Vx.randomOpaqueColor.withAlpha(50),
              //   width: double.infinity,
              //   height: 60,
              //   child: "${service.name}"
              //       .text
              //       .color(Vx.randomOpaqueColor.withOpacity(0.1))
              //       .center
              //       .make()
              //       .centered()
              //       .p12(),
              // ),
            ).pOnly(bottom: 10),

            //price
            // Positioned(
            //   bottom: 0,
            //   right: !Utils.isArabic ? 20 : null,
            //   left: Utils.isArabic ? 20 : null,
            //   child: ((service.hasOptions ? "From".tr() : "") +
            //           " " +
            //           "${AppStrings.currencySymbol} ${service.sellPrice}"
            //               .currencyFormat() +
            //           " ${service.durationText}")
            //       .text
            //       .sm
            //       .color(Utils.textColorByTheme())
            //       .make()
            //       .px8()
            //       .py2()
            //       .box
            //       .roundedLg
            //       .border(
            //         width: 1.6,
            //         color: Utils.textColorByTheme(),
            //       )
            //       .color(AppColor.primaryColor)
            //       .make(),
            // ),

            //discount
            // Visibility(
            //   visible: service.showDiscount,
            //   child: "%s Off"
            //       .tr()
            //       .fill(["${service.discountPercentage}%"])
            //       .text
            //       .sm
            //       .white
            //       .semiBold
            //       .make()
            //       .p2()
            //       .px4()
            //       .box
            //       .red500
            //       .withRounded(value: 7)
            //       .make(),
            // ),
          ],
        ),

        //
        VStack(
          [
            "${vendor.name}".text.sm.semiBold.maxLines(1).ellipsis.make(),
            "${vendor.description}".text.sm.maxLines(1).ellipsis.make(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RatingBar(
                  itemSize: 14,
                  initialRating: vendor!.rating.toDouble(),
                  ignoreGestures: true,
                  ratingWidget: RatingWidget(
                    full: Icon(
                      FlutterIcons.ios_star_ion,
                      size: 12,
                      color: Colors.yellow[800],
                    ),
                    half: Icon(
                      FlutterIcons.ios_star_half_ion,
                      size: 12,
                      color: Colors.yellow[800],
                    ),
                    empty: Icon(
                      FlutterIcons.ios_star_ion,
                      size: 12,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  onRatingUpdate: (value) {},
                ).pOnly(right: 2),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.green),
                  child: "Open now".tr().text.sm.white.make(),
                ).onInkTap(() => this.onPressed(this.vendor),),
              ],
            ),            // UiSpacer.divider(thickness: 0.50, height: 0.3).py8().px4(),
            //provider info
            // VendorInfoView(service.vendor),
            UiSpacer.vSpace(10),
          ],
        ).px12().py4(),
      ],
    )
        .wFull(context)
        .box
        .withRounded(value: 7)
        .color(context.cardColor)
        .outerShadowSm
        .clip(Clip.antiAlias)
        .makeCentered()
        .onInkTap(
          () => this.onPressed(this.vendor),
        );
  }
}


// VStack(
// [
// Stack(
// children: [
// AlternativeView(
// ismain: (service.photos != null && service.photos!.isNotEmpty),
// main: CustomImage(
// imageUrl: (service.photos != null && service.photos!.isNotEmpty)
// ? service.photos!.first
//     : "",
// width: double.infinity,
// height: 120,
// ),
// alt: Container(
// color: Vx.randomOpaqueColor.withAlpha(50),
// width: double.infinity,
// height: 60,
// child: "${service.name}"
//     .text
//     .color(Vx.randomOpaqueColor.withOpacity(0.1))
//     .center
//     .make()
//     .centered()
//     .p12(),
// ),
// ).pOnly(bottom: 10),
//
// //price
// Positioned(
// bottom: 0,
// right: !Utils.isArabic ? 20 : null,
// left: Utils.isArabic ? 20 : null,
// child: ((service.hasOptions ? "From".tr() : "") +
// " " +
// "${AppStrings.currencySymbol} ${service.sellPrice}"
//     .currencyFormat() +
// " ${service.durationText}")
//     .text
//     .sm
//     .color(Utils.textColorByTheme())
//     .make()
//     .px8()
//     .py2()
//     .box
//     .roundedLg
//     .border(
// width: 1.6,
// color: Utils.textColorByTheme(),
// )
//     .color(AppColor.primaryColor)
//     .make(),
// ),
//
// //discount
// Visibility(
// visible: service.showDiscount,
// child: "%s Off"
//     .tr()
//     .fill(["${service.discountPercentage}%"])
//     .text
//     .sm
//     .white
//     .semiBold
//     .make()
//     .p2()
//     .px4()
//     .box
//     .red500
//     .withRounded(value: 7)
//     .make(),
// ),
// ],
// ),
//
// //
// VStack(
// [
// "${service.name}".text.sm.semiBold.maxLines(2).ellipsis.make(),
// UiSpacer.divider(thickness: 0.50, height: 0.3).py8().px4(),
// //provider info
// VendorInfoView(service.vendor),
// UiSpacer.vSpace(10),
// ],
// ).px12().py4(),
// ],
// )
//     .wFull(context)
//     .box
//     .withRounded(value: 7)
//     .color(context.cardColor)
//     .outerShadowSm
//     .clip(Clip.antiAlias)
//     .makeCentered()
//     .onInkTap(
// () => this.onPressed(this.service),
// );