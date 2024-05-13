import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:huops/models/delivery_address.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/widgets/cards/custom.visibility.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../constants/app_colors.dart';

class DeliveryAddressListItem extends StatelessWidget {
  const DeliveryAddressListItem({
    required this.deliveryAddress,
    this.onEditPressed,
    this.onDeletePressed,
    this.action = true,
    this.border = true,
    this.borderColor,
    this.showDefault = true,
    Key? key,
  }) : super(key: key);

  final DeliveryAddress deliveryAddress;
  final Function? onEditPressed;
  final Function? onDeletePressed;
  final bool action;
  final bool border;
  final bool showDefault;
  final Color? borderColor;
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //
        HStack(
          [
            //
            VStack(
              [
                "${deliveryAddress.name}".text.semiBold.lg.make().pOnly(bottom: 5),
                "${deliveryAddress.address}"
                    .text
                    .sm
                    .maxLines(3)
                    .overflow(TextOverflow.ellipsis)
                    .make(),
                "${deliveryAddress.description}".text.sm.make(),
                (deliveryAddress.defaultDeliveryAddress && showDefault)
                    ? "Default"
                        .tr()
                        .text
                        .xs
                        .italic
                        .maxLines(3)
                        .overflow(TextOverflow.ellipsis)
                        .make()
                    : UiSpacer.emptySpace(),
              ],
            ).p12().expand(),
            //
            this.action
                ? VStack(
                    [
                      //delete icon
                      InkWell(
                        onTap: this.onDeletePressed != null
                              ? () => this.onDeletePressed!()
                              : () {},
                        child: Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            FlutterIcons.delete_ant,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      //edit icon
                      InkWell(
                        onTap: this.onEditPressed != null ? () => this.onEditPressed!() : () {},
                        child: Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColor.primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              FlutterIcons.edit_ent,
                              size: 20,
                              color: Colors.white,
                            )
                        ),
                      ),
                    ],
                    axisSize: MainAxisSize.max,
                    // crossAlignment: CrossAxisAlignment.center,
                  ).w(context.percentWidth * 15)
                : UiSpacer.emptySpace(),
          ],
        )
            .box
            .roundedSM
            .make().glassMorphic(),

        //
        //can deliver
        CustomVisibilty(
          visible: deliveryAddress.can_deliver != null &&
              !(deliveryAddress.can_deliver ?? true),
          child: "Vendor does not service this location"
              .tr()
              .text
              .red500
              .xs
              .thin
              .make()
              .px12()
              .py2(),
        ),
      ],
    );
  }
}
