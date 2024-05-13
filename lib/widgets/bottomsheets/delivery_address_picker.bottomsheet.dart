import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/models/delivery_address.dart';
import 'package:huops/services/auth.service.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/view_models/delivery_address/delivery_addresses_picker.vm.dart';
import 'package:huops/widgets/base.page.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:huops/widgets/cards/custom.visibility.dart';
import 'package:huops/widgets/custom_list_view.dart';
import 'package:huops/widgets/custom_text_form_field.dart';
import 'package:huops/widgets/list_items/delivery_address.list_item.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class DeliveryAddressPicker extends StatelessWidget {
  const DeliveryAddressPicker({
    required this.onSelectDeliveryAddress,
    this.allowOnMap = false,
    this.vendorCheckRequired = true,
    Key? key,
  }) : super(key: key);

  final Function(DeliveryAddress) onSelectDeliveryAddress;
  final bool allowOnMap;
  final bool vendorCheckRequired;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DeliveryAddressPickerViewModel>.reactive(
      viewModelBuilder: () => DeliveryAddressPickerViewModel(
        context,
        onSelectDeliveryAddress,
        vendorCheckRequired,
      ),
      onViewModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        return BasePage(
            body: VStack(
              [
                //
                // UiSpacer.swipeIndicator().py12(),
                //
                60.heightBox,
                HStack(
                  [
                    //
                    VStack(
                      [
                        "Delivery address".tr().text.color(Colors.white).make(),
                        "Select order delivery address".tr().text.color(Colors.white).make(),
                      ],
                    ).expand(),

                    //
                    AuthServices.authenticated()
                        ? CustomButton(
                      title: "New".tr(),
                      icon: FlutterIcons.plus_ant,
                      onPressed: vm.newDeliveryAddressPressed,
                      color: AppColor.primaryColor,
                      shapeRadius: 15,
                    )
                        : UiSpacer.emptySpace(),
                  ],
                ).p16().box.make().glassMorphic(borderRadius: BorderRadius.circular(0)),
                //filter result
                CustomTextFormField(
                  hintText: "Search".tr(),
                  prefixIcon: Icon(
                    FlutterIcons.search_fea,
                    size: 20,
                    color: AppColor.primaryColor,
                  ),
                  onChanged: vm.filterResult,
                ).glassMorphic().p20(),
                //result list
                CustomVisibilty(
                  visible: vm.isBusy || (vm.deliveryAddresses.isNotEmpty),
                  child: SafeArea(
                    top: false,
                    child: CustomListView(
                      dataSet: vm.deliveryAddresses,
                      isLoading: vm.isBusy,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      itemBuilder: (context, index) {
                        //
                        final deliveryAddress = vm.deliveryAddresses[index];
                        return DeliveryAddressListItem(
                          deliveryAddress: deliveryAddress,
                          action: false,
                          borderColor: Colors.grey.shade300,
                        ).glassMorphic().onInkTap(
                          (deliveryAddress.can_deliver == null ||
                              deliveryAddress.can_deliver!)
                              ? () => this.onSelectDeliveryAddress(deliveryAddress)
                              : null,
                        );
                      },
                      separatorBuilder: (context, index) =>
                          UiSpacer.verticalSpace(),
                    ),
                  ),
                ).expand(),

                //
                allowOnMap
                    ? SafeArea(
                  child: TextButton.icon(
                    style: TextButton.styleFrom(alignment: Alignment.center),
                    label: "Choose on map".tr().text.color(Colors.white).make(),
                    icon: Icon(FlutterIcons.location_pin_ent,color: Colors.white,),
                    onPressed: vm.pickFromMap,
                  ).wFull(context).px20(),
                )
                    : UiSpacer.emptySpace(),
              ],
            )
                .box
                .color(Colors.transparent)
                .topRounded()
                .make()
                .h(context.percentHeight)
        );
      },
    );
  }
}
