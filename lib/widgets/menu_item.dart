import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:huops/constants/app_images.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/widgets/cards/custom.visibility.dart';
import 'package:velocity_x/velocity_x.dart';

class MenuItem extends StatelessWidget {
  const MenuItem({
    this.title,
    this.child,
    this.divider = true,
    this.topDivider = false,
    this.suffix,
    this.onPressed,
    this.ic,
    this.showDivider = false,
    this.colorIcon,
    this.heightIcon,
    this.widthIcon,
    Key? key,
  }) : super(key: key);

  //
  final String? title;
  final Widget? child;
  final bool divider;
  final bool topDivider;
  final Widget? suffix;
  final Function? onPressed;
  final String? ic;
  final bool showDivider;
  final Color? colorIcon;
  final double? widthIcon;
  final double? heightIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff5f4b69),
      child: Column(
        children: [
          TextButton(
            onPressed: onPressed != null ? () => onPressed!() : null,
            // elevation: 0.0,
            // color: Color(0xff5f4b69),//context.theme.colorScheme.background,
            // padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: HStack(
              [
                //
                CustomVisibilty(
                  visible: ic != null,
                  child: HStack(
                    [
                      //
                      Image.asset(
                        ic ?? AppImages.appLogo,
                        width: widthIcon ?? 24 ,
                        height: heightIcon ?? 24,
                        color: colorIcon ?? null ,
                      ),
                      //
                      UiSpacer.horizontalSpace(),
                    ],
                  ),
                ),
                //
                (child ?? "$title".text.lg.color(Colors.white).make()).expand(),
                //
                suffix ??
                    Icon(
                      FlutterIcons.right_ant,
                      size: 16,
                      color: Colors.white,
                    ),
              ],
            ),
          ),
          showDivider ? Divider(color: Colors.white,) : SizedBox(),
        ],
      ),
    );
  }
}
