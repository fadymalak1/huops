import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/constants/app_strings.dart';
import 'package:huops/models/vendor.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/widgets/buttons/route.button.dart';
import 'package:huops/widgets/currency_hstack.dart';
import 'package:huops/widgets/custom_image.view.dart';
import 'package:huops/widgets/tags/delivery.tag.dart';
import 'package:huops/widgets/tags/time.tag.dart';
import 'package:huops/widgets/tags/pickup.tag.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class DynamicVendorListItem extends StatelessWidget {
  const DynamicVendorListItem(
    this.vendor, {
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final Vendor vendor;
  final Function(Vendor)? onPressed;
  @override
  Widget build(BuildContext context) {
    return VStack(
      crossAlignment: CrossAxisAlignment.center,
      [
        Container(
          padding: EdgeInsets.all(15),
          child: Stack(
            children: [
              Row(
                children: [
                  Hero(
                    tag: vendor.heroTag ?? vendor.id,
                    child: CustomImage(
                      imageUrl: vendor.featureImage,
                      height: 140,
                      width: MediaQuery.of(context).size.width * .40,
                    ).cornerRadius(15),
                  ),
                  SizedBox(width: 10,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      vendor.name.text.xl.semiBold.maxLines(2).align(TextAlign.center).overflow(TextOverflow.ellipsis,).make().p12(),
                      "${vendor.description}".text.color(Colors.white).minFontSize(9).size(12).maxLines(2).overflow(TextOverflow.ellipsis).make(),

                      20.heightBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          HStack(
                            [
                              "${vendor.rating.numCurrency} "
                                  .text
                                  .size(15)
                                  .color(Colors.white)
                                  .medium
                                  .make(),
                              Icon(
                                FlutterIcons.star_ent,
                                color: Colors.amber,
                                size: 15,
                              ),
                            ],
                          ),
                          20.widthBox,
                          //location routing
                          (!vendor.latitude.isEmptyOrNull &&
                              !vendor.longitude.isEmptyOrNull)
                              ? RouteButton(
                            vendor,
                            size: 20,
                          )
                              : UiSpacer.emptySpace(),
                        ],
                      )
                    ],
                  ).expand(),

                ],
              ),
              Positioned(
                bottom: 0,
                right: MediaQuery.of(context).size.width *.39,
                child: CustomImage(
                  imageUrl: vendor.logo,
                  height: 50,
                  width: 50,
                ).cornerRadius(50),
              ),
            ],
          ),
        )
        //
//         Stack(
//           children: [
//             //
//             Hero(
//               tag: vendor.heroTag ?? vendor.id,
//               child: CustomImage(
//                 imageUrl: vendor.featureImage,
//                 height: 80,
//                 width: context.screenWidth,
//               ),
//             ),
//             //location routing
//             (!vendor.latitude.isEmptyOrNull && !vendor.longitude.isEmptyOrNull)
//                 ? Positioned(
//                     child: RouteButton(
//                       vendor,
//                       size: 12,
//                     ),
//                     bottom: 5,
//                     right: 10,
//                   )
//                 : UiSpacer.emptySpace(),
//
//             //
//             Positioned(
//               child: VStack(
//                 [
//                   TimeTag(vendor.prepareTime,
//                       iconData: FlutterIcons.clock_outline_mco),
//                   UiSpacer.verticalSpace(space: 5),
//                   TimeTag(
//                     vendor.deliveryTime,
//                     iconData: FlutterIcons.ios_bicycle_ion,
//                   ),
//                 ],
//               ),
//               left: 10,
//               bottom: 5,
//             ),
//
//             //closed
//             Positioned(
//               child: Visibility(
//                 visible: !vendor.isOpen,
//                 child: VxBox(
//                   child: "Closed".tr().text.lg.white.bold.makeCentered(),
//                 )
//                     .color(
//                       AppColor.closeColor.withOpacity(0.6),
//                     )
//                     .make(),
//               ),
//               bottom: 0,
//               right: 0,
//               left: 0,
//               top: 0,
//             ),
//           ],
//         ),
//         //name
//         vendor.name.text.sm.medium
//             .maxLines(1)
//             .overflow(TextOverflow.ellipsis)
//             .make()
//             .px8()
//             .pOnly(top: Vx.dp8),
//         //
//         //description
//         "${vendor.description}"
//             .text
//             .gray400
//             .minFontSize(9)
//             .size(9)
//             .maxLines(1)
//             .overflow(TextOverflow.ellipsis)
//             .make()
//             .px8(),
//         //words
//         Wrap(
//           spacing: Vx.dp12,
//           children: [
//             //rating
//             HStack(
//               [
//                 "${vendor.rating.numCurrency} "
//                     .text
//                     .minFontSize(6)
//                     .size(10)
//                     .color(AppColor.ratingColor)
//                     .medium
//                     .make(),
//                 Icon(
//                   FlutterIcons.star_ent,
//                   color: AppColor.ratingColor,
//                   size: 10,
//                 ),
//               ],
//             ),
//
//             //
//             //
//             Visibility(
//               visible: vendor.distance != null,
//               child: HStack(
//                 [
//                   Icon(
//                     FlutterIcons.direction_ent,
//                     color: AppColor.primaryColor,
//                     size: 10,
//                   ),
//                   " ${vendor.distance?.numCurrency}km"
//                       .text
//                       .minFontSize(6)
//                       .size(10)
//                       .make(),
//                 ],
//               ),
//             ),
//           ],
//         ).px8(),
//
// //delivery fee && time
//         Wrap(
//           spacing: Vx.dp12,
//           children: [
//             //
//             Visibility(
//               visible: vendor.minOrder != null,
//               child: CurrencyHStack(
//                 [
//                   "${AppStrings.currencySymbol}"
//                       .text
//                       .minFontSize(6)
//                       .size(10)
//                       .gray600
//                       .medium
//                       .maxLines(1)
//                       .make(),
//                   //
//                   Visibility(
//                     visible: vendor.minOrder != null,
//                     child: "${vendor.minOrder}"
//                         .text
//                         .minFontSize(6)
//                         .size(10)
//                         .gray600
//                         .medium
//                         .maxLines(1)
//                         .make(),
//                   ),
//                   //
//                   Visibility(
//                     visible: vendor.minOrder != null && vendor.maxOrder != null,
//                     child: " - "
//                         .text
//                         .minFontSize(6)
//                         .size(10)
//                         .gray600
//                         .medium
//                         .maxLines(1)
//                         .make(),
//                   ),
//                   //
//                   Visibility(
//                     visible: vendor.maxOrder != null,
//                     child: "${vendor.maxOrder} "
//                         .text
//                         .minFontSize(6)
//                         .size(10)
//                         .gray600
//                         .medium
//                         .maxLines(1)
//                         .make(),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ).px8(),
//
//         //
//         HStack(
//           [
//             //can deliver
//             vendor.delivery == 1
//                 ? DeliveryTag().pOnly(right: 10)
//                 : UiSpacer.emptySpace(),
//
//             //can pickup
//             vendor.pickup == 1
//                 ? PickupTag().pOnly(right: 10)
//                 : UiSpacer.emptySpace(),
//           ],
//           crossAlignment: CrossAxisAlignment.end,
//         ).p8()
      ],
    )
        .onInkTap(
          () => this.onPressed!(this.vendor),
        )
        .w(175)
        .box
        .outerShadow
        .clip(Clip.antiAlias)
        .withRounded(value: 12)
        .make().glassMorphic(opacity: 0.1);
  }
}
