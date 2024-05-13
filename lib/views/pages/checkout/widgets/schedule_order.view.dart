import 'package:flutter/material.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/view_models/checkout_base.vm.dart';
import 'package:huops/widgets/custom_grid_view.dart';
import 'package:huops/widgets/custom_list_view.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class ScheduleOrderView extends StatelessWidget {
  const ScheduleOrderView(this.vm, {Key? key}) : super(key: key);
  final CheckoutBaseViewModel vm;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: vm.vendor!.allowScheduleOrder,
      child: VStack(
        [
          HStack(
            [
              //
              Checkbox(
                value: vm.isScheduled,
                onChanged: vm.toggleScheduledOrder,
                checkColor: Colors.white,
                activeColor: AppColor.primaryColor,
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
                  "Schedule Order".tr().text.xl.color(Colors.white).semiBold.make(),
                  "If you want your order to be delivered/prepared at scheduled date/time"
                      .tr()
                      .text.color(Colors.white)
                      .make(),
                ],
              ).expand(),
            ],
            crossAlignment: CrossAxisAlignment.start,
          ).wFull(context).onInkTap(
                () => vm.toggleScheduledOrder(!vm.isScheduled),
              ),

          //delivery time slots
          Visibility(
            visible: vm.isScheduled,
            child: VStack(
              [
                //date slot
                UiSpacer.verticalSpace(),
                "Date slot".tr().text.color(Colors.white).lg.make(),
                CustomListView(
                  scrollDirection: Axis.horizontal,
                  dataSet: vm.vendor!.deliverySlots,
                  itemBuilder: (context, index) {
                    final dateDeliverySlot = vm.vendor!.deliverySlots[index];

                    final formmatedDeliverySlot =
                        DateFormat("yyyy-MM-dd", "en").format(
                      dateDeliverySlot.date,
                    );
                    bool selected = (formmatedDeliverySlot ==
                        vm.checkout?.deliverySlotDate);
                    //

                    return Jiffy(dateDeliverySlot.date)
                        .format("EEEE dd MMM yyyy")
                        .text
                        .color(Colors.white)
                        .makeCentered()
                        .px8()
                        .py4()
                        .box
                        .roundedSM
                        .border(color: AppColor.primaryColor)
                        .color(
                          selected ? AppColor.primaryColor : Colors.transparent,
                        )
                        .make()
                        .onInkTap(
                          () => vm.changeSelectedDeliveryDate(
                            formmatedDeliverySlot,
                            index,
                          ),
                        );
                  },
                ).h(Vx.dp32).py8(),
                //
                UiSpacer.verticalSpace(space: 10),
                "Time slot".tr().text.lg.color(Colors.white).make(),
                UiSpacer.verticalSpace(space: 10),
                CustomGridView(
                  // scrollDirection: Axis.horizontal,
                  noScrollPhysics: true,
                  // padding: EdgeInsets.symmetric(horizontal: 10),
                  dataSet: vm.availableTimeSlots,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 3,
                  crossAxisCount: 3,
                  itemBuilder: (context, index) {
                    //
                    final today = DateFormat("yyyy-MM-dd", "en").format(
                      DateTime.now(),
                    );
                    final availableTimeSlot = vm.availableTimeSlots[index];
                    final formmatedDeliveryTimeSlot =
                        DateFormat("HH:mm:ss", "en").format(
                      DateTime.parse("$today $availableTimeSlot"),
                    );

                    //check if selected
                    bool selected = formmatedDeliveryTimeSlot ==
                        vm.checkout?.deliverySlotTime;
                    //
                    return Jiffy("$today $availableTimeSlot")
                        .format("hh:mm a")
                        .text
                        .color(Colors.white)
                        .makeCentered()
                        .box
                        .roundedSM
                        .border(color: AppColor.primaryColor)
                        .color(
                          selected ? AppColor.primaryColor : Colors.transparent,
                        )
                        .make()
                        .onInkTap(
                          () => vm.changeSelectedDeliveryTime(
                            formmatedDeliveryTimeSlot,
                          ),
                        );
                  },
                ),
                // CustomGridView(dataSet: dataSet, itemBuilder: itemBuilder),

              ],
            ),
          ),
        ],
      ).p12().box.withRounded(value: 20).make().glassMorphic(),
    );
  }
}
