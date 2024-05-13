import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:huops/constants/app_strings.dart';
import 'package:huops/constants/app_ui_styles.dart';
import 'package:huops/models/vendor_type.dart';
import 'package:huops/utils/utils.dart';
import 'package:huops/widgets/custom_image.view.dart';
import 'package:velocity_x/velocity_x.dart';

class VendorTypeListItem extends StatelessWidget {
  const VendorTypeListItem(
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
    //
    return AnimationConfiguration.staggeredList(
      position: vendorType.id,
      duration: const Duration(milliseconds: 375),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: InkWell(
            onTap: () => this.onPressed(),
            child: VStack(
              [
                //image + details
                Visibility(
                  visible: true,
                  child: HStack(
                    [
                      //
                      CustomImage(
                        imageUrl: vendorType.logo,
                        boxFit: BoxFit.cover,
                        height: MediaQuery.of(context).size.height * .15,
                        width: MediaQuery.of(context).size.width * .4,
                      ),
                      //
                      SizedBox(width: 10,),

                      VStack(
                        [
                          vendorType.name.text.xl
                              .color(Colors.white)
                              .semiBold
                              .make(),
                          Visibility(
                            visible: vendorType.description.isNotEmpty,
                            child: "${vendorType.description}"
                                .text
                                .color(Colors.white)
                                .sm
                                .make()
                                .pOnly(top: 5),
                          ),
                        ],
                      ).centered().expand(),
                    ],
                  ),
                ),

                //image only
                // Visibility(
                //   visible: AppStrings.showVendorTypeImageOnly,
                //   child: CustomImage(
                //     imageUrl: vendorType.logo,
                //     boxFit: AppUIStyles.vendorTypeImageStyle,
                //     height: AppUIStyles.vendorTypeHeight,
                //     width: AppUIStyles.vendorTypeWidth,
                //   ),
                // ),
              ],
            ),
          )
              .box
              .clip(Clip.antiAlias)
              .withRounded(value: 10)
              .make().glassMorphic()
              .pOnly(bottom: Vx.dp20),
        ),
      ),
    );
  }
}
