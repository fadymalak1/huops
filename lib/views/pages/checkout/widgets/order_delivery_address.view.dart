import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:huops/extensions/dynamic.dart';
import 'package:huops/view_models/checkout_base.vm.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:huops/widgets/list_items/delivery_address.list_item.dart';
import 'package:huops/widgets/states/delivery_address.empty.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class OrderDeliveryAddressPickerView extends StatelessWidget {
  const OrderDeliveryAddressPickerView(
    this.vm, {
    Key? key,
    this.showPickView = true,
    this.isBooking = false,
  }) : super(key: key);
  final CheckoutBaseViewModel vm;
  final bool showPickView;
  final bool isBooking;

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        Visibility(
          visible: showPickView && !vm.vendor!.allowOnlyDelivery,
          child: HStack(
            [
              //
              Checkbox(
                value: vm.isPickup,
                onChanged: vm.togglePickupStatus,
                checkColor: Colors.white,
                activeColor: Color(0xffd53c25),
                // fillColor: MaterialStatePropertyAll(Colors.white),
                fillColor: MaterialStateProperty.resolveWith((states) {
                  if (!states.contains(MaterialState.selected)) {
                    return Colors.white;
                  }
                  return null;
                }),
                side: MaterialStateBorderSide.resolveWith(
                      (states) => BorderSide(width: 0.0),
                ),
              ),
              //
              VStack(
                [
                  "Pickup Order".tr().text.xl.color(Colors.white).semiBold.make(),
                  "Please indicate if you would come pickup order at the vendor"
                      .tr()
                      .text.color(Colors.white)
                      .make(),
                ],
              ).expand(),
            ],
            crossAlignment: CrossAxisAlignment.start,
          ).wFull(context).onInkTap(
                () => vm.togglePickupStatus(!vm.isPickup),
              ),
        ),

        //

        //delivery address pick preview
        Visibility(
          visible: !vm.isPickup && !vm.vendor!.allowOnlyPickup,
          child: VStack(
            [
              //divider
              Visibility(
                visible: showPickView && vm.vendor!.pickup == 1,
                child: Divider(thickness: 1).py4(),
              ),
              //
              HStack(
                [
                  //
                  VStack(
                    [
                      "${!isBooking ? 'Delivery' : 'Booking'} address"
                          .tr()
                          .text
                          .semiBold.color(Colors.white)
                          .xl
                          .make(),
                      "Please select %s address/location"
                          .tr()
                          .fill(["${!isBooking ? 'delivery' : 'booking'}".tr()])
                          .text.color(Colors.white)
                          .make(),
                    ],
                  ).expand(),
                  20.widthBox,
                  //
                  CustomButton(
                    shapeRadius: 15,
                    title: "Select".tr(),
                    onPressed: vm.showDeliveryAddressPicker,
                  ).h(40),
                ],
              ),
              //Selected delivery address box
              DottedBorder(
                borderType: BorderType.RRect,
                color: context.accentColor,
                strokeWidth: 1,
                strokeCap: StrokeCap.round,
                radius: Radius.circular(5),
                dashPattern: [3, 6],
                child: vm.deliveryAddress != null
                    ? DeliveryAddressListItem(
                        deliveryAddress: vm.deliveryAddress!,
                        action: false,
                        border: false,
                        showDefault: false,
                      )
                    : EmptyDeliveryAddress(
                        selection: true,
                        isBooking: isBooking,
                      ).py12().opacity(value: 0.60),
              ).wFull(context).py12().onInkTap(
                    vm.showDeliveryAddressPicker,
                  ),

              //within vendor range
              Visibility(
                visible: vm.delievryAddressOutOfRange,
                child: "Delivery address is out of vendor delivery range"
                    .tr()
                    .text
                    .sm
                    .red500
                    .make(),
              ),
            ],
          ),
        ),
      ],
    ).p20().box.withRounded(value: 20).make().glassMorphic().pOnly(
          bottom: Vx.dp20,
        );
  }
}
