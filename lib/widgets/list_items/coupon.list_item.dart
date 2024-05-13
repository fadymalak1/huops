import 'package:flutter/material.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/extensions/string.dart';
import 'package:huops/models/coupon.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/utils/utils.dart';
import 'package:huops/widgets/custom_image.view.dart';
import 'package:velocity_x/velocity_x.dart';

class CouponListItem extends StatelessWidget {
  const CouponListItem(
    this.coupon, {
    this.onPressed,
    this.radius = 4,
    Key? key,
  }) : super(key: key);

  final Coupon coupon;
  final double radius;
  final Function? onPressed;
  @override
  Widget build(BuildContext context) {
    Color fromColor = coupon.color != null
        ? Vx.hexToColor(coupon.color!)
        : AppColor.primaryColor;
    if (fromColor == Colors.black) {
      fromColor = AppColor.primaryColor;
    }
    Color toColor = fromColor.withAlpha(150);
    return HStack(
      [
        //
        Visibility(
          visible: coupon.photo.isNotDefaultImage,
          child: HStack(
            [
              CustomImage(imageUrl: coupon.photo).wh(60, 60),
              UiSpacer.hSpace(),
            ],
          ),
        ),

        //
        VStack(
          [
            coupon.code.text.xl2.extraBold
                .make(),
            "${coupon.description}"
                .text
                .sm
                .medium
                .maxLines(2)
                .ellipsis
                .make(),
          ],
        ).expand(),
      ],
    )
        .px(20)
        .py(12)
        .box
        .roundedSM
        .make().glassMorphic()
        .onTap(onPressed != null ? () => onPressed!(coupon) : null);
  }
}
