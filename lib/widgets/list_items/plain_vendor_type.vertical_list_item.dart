import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:huops/constants/app_strings.dart';
import 'package:huops/constants/app_ui_styles.dart';
import 'package:huops/models/vendor_type.dart';
import 'package:huops/utils/utils.dart';
import 'package:huops/widgets/custom_image.view.dart';
import 'package:velocity_x/velocity_x.dart';

class PlainVendorTypeVerticalListItem extends StatelessWidget {
  const PlainVendorTypeVerticalListItem(
    this.vendorType, {
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final VendorType vendorType;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    //
    final textColor = Utils.textColorByColor(Vx.hexToColor(vendorType.color));
    // final textColor = Utils.textColorByBrightness(context);
    //
    return AnimationConfiguration.staggeredList(
      position: vendorType.id,
      duration: const Duration(milliseconds: 375),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: InkWell(
            onTap: () => onPressed(),
            child: VStack(
              [
                //image + details
                Visibility(
                  visible: !AppStrings.showVendorTypeImageOnly,
                  child: VStack(
                    [
                      //
                      CustomImage(
                        imageUrl: vendorType.logo,
                        boxFit: AppUIStyles.vendorTypeImageStyle,
                        height: AppUIStyles.vendorTypeHeight,
                        width: AppUIStyles.vendorTypeWidth,
                      ).p8().centered(),
                      //
                      VStack(
                        [
                          vendorType.name.text
                              .color(textColor)
                              .medium
                              .size(12)
                              .makeCentered(),
                        ],
                      ).py4(),
                    ],
                  ).p12().centered(),
                ),

                //image only
                Visibility(
                  visible: AppStrings.showVendorTypeImageOnly,
                  child: CustomImage(
                    imageUrl: vendorType.logo,
                    boxFit: AppUIStyles.vendorTypeImageStyle,
                    height: AppUIStyles.vendorTypeHeight,
                    width: AppUIStyles.vendorTypeWidth,
                  ).centered(),
                ),
              ],
            ),
          )
              .box
              .clip(Clip.antiAlias)
              .withRounded(value: 5)
              .outerShadowXl
              // .color(Utils.textColorByBrightness(context, true))
              .color(Vx.hexToColor(vendorType.color))
              .make(),
        ),
      ),
    );
  }
}
