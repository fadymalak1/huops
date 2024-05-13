import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:huops/models/vendor.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/widgets/buttons/route.button.dart';
import 'package:huops/widgets/custom_image.view.dart';
import 'package:velocity_x/velocity_x.dart';

class VendorListItemSearch extends StatelessWidget {
  const VendorListItemSearch({
    required this.vendor,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final Vendor vendor;
  final Function(Vendor) onPressed;
  @override
  Widget build(BuildContext context) {
    return VStack(
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
                      width: MediaQuery.of(context).size.width * .42,
                    ).cornerRadius(15),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      vendor.name.text.xl2.semiBold.maxLines(2).overflow(TextOverflow.ellipsis,).make().p12(),
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
                                  .color(Color(0xffec4513))
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
                right: MediaQuery.of(context).size.width *.35,
                child: CustomImage(
                  imageUrl: vendor.logo,
                  height: 50,
                  width: 50,
                ).cornerRadius(50),
              ),
            ],
          ),
        )
      ],
    )
        .onInkTap(
          () => this.onPressed(this.vendor),
    )
        .w(175)
        .box
        .outerShadow
        .color(Color(0xff5f4b69).withOpacity(.9))
        .clip(Clip.antiAlias)
        .withRounded(value: 15)
        .make()
        .pOnly(bottom: Vx.dp8);
  }
}
