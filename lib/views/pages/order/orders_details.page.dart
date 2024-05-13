import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/models/order.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/view_models/order_details.vm.dart';
import 'package:huops/views/pages/order/widgets/order.bottomsheet.dart';
import 'package:huops/views/pages/order/widgets/order_address.view.dart';
import 'package:huops/views/pages/order/widgets/order_attachment.view.dart';
import 'package:huops/views/pages/order/widgets/order_details_driver_info.view.dart';
import 'package:huops/views/pages/order/widgets/order_details_items.view.dart';
import 'package:huops/views/pages/order/widgets/order_details_vendor_info.view.dart';
import 'package:huops/views/pages/order/widgets/order_payment_info.view.dart';
import 'package:huops/views/pages/order/widgets/order_status.view.dart';
import 'package:huops/widgets/base.page.dart';
import 'package:huops/widgets/busy_indicator.dart';
import 'package:huops/widgets/cards/custom.visibility.dart';
import 'package:huops/widgets/cards/order_details_summary.dart';
import 'package:huops/widgets/custom_image.view.dart';
import 'package:jiffy/jiffy.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:glass_kit/glass_kit.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({
    required this.order,
    this.isOrderTracking = false,
    Key? key,
  }) : super(key: key);

  final Order order;
  final bool isOrderTracking;

  @override
  Widget build(BuildContext context) {
    //
    return Scaffold(
      body: ViewModelBuilder<OrderDetailsViewModel>.reactive(
        viewModelBuilder: () => OrderDetailsViewModel(context, order),
        onViewModelReady: (vm) => vm.initialise(),
        builder: (context, vm, child) {
          return BasePage(
            isLoading: vm.isBusy,
            onBackPressed: () {
              context.pop(vm.order);
            },
            //share button for parcel delivery order
            actions: vm.order.isPackageDelivery
                ? [
              Icon(
                FlutterIcons.share_2_fea,
                color: Colors.white,
              ).p8().onInkTap(vm.shareOrderDetails).p8(),
            ]
                : [],
            body: vm.isBusy
                ? BusyIndicator().centered()
                : SmartRefresher(
              controller: vm.refreshController,
              onRefresh: vm.fetchOrderDetails,
              child: Stack(
                children: [
                  //vendor details
                  Positioned(
                    child: Stack(
                      children: [
                        //vendor details
                        Positioned(
                          child: Stack(
                            children: [
                              //vendor feature image
                              CustomImage(
                                imageUrl: vm.order.vendor!.featureImage,
                                width: double.infinity,
                                height: 200,
                                boxFit: BoxFit.cover,
                              ),
                            ],
                          ),
                        ),

                        //
                        //vendor feature image
                        CustomImage(
                          imageUrl: vm.order.vendor!.featureImage,
                          width: double.infinity,
                          height: 200,
                          boxFit: BoxFit.cover,//contain
                        ),
                      ],
                    ),
                  ),

                  //
                  VStack(
                    [
                      UiSpacer.verticalSpace(space: 190),
                      VStack(
                        [
                          //free space
                          //header view
                          HStack(
                            [
                              VStack(
                                [
                                  "Order Details".tr().text.color(Colors.white).xl2.extraBold.make().py12(),
                                  //
                                  vm.order.vendor!.name.text.color(Colors.white).xl2.make().py12(),
                                  // "${vm.order.status.tr().capitalized}".text.semiBold.xl.color(AppColor.getStausColor(vm.order.status)).make(),
                                  // "${Jiffy(vm.order.updatedAt).format('MMM dd, yyyy \| HH:mm')}".text.light.lg.make(),
                                  "Order's ID:${vm.order.code}"
                                      .text.xs.gray400.light.make(),
                                ],
                              ).expand(),
                              //qr code icon
                              // Visibility(
                              //   visible: !vm.order.isTaxi &&
                              //       !vm.order.isSerice,
                              //   child: Icon(
                              //     FlutterIcons.qrcode_ant,
                              //     size: 28,
                              //   ).onInkTap(vm.showVerificationQRCode),
                              // ),
                            ],
                          ).p20().wFull(context),
                          //
                          // UiSpacer.cutDivider(),
                          //Payment status
                          OrderPaymentInfoView(vm),
                          //status
                          Visibility(
                            visible: vm.order.showStatusTracking,
                            child: VStack(
                              [
                                OrderStatusView(vm).p20(),
                                UiSpacer.divider(),
                              ],
                            ),
                          ),
                          // either products/package details
                          OrderDetailsItemsView(vm).px20().py8(),
                          //show package delivery addresses
                          Visibility(
                            visible: vm.order.deliveryAddress != null,
                            child: OrderAddressesView(vm).px20(),
                          ),
                          //
                          OrderAttachmentView(vm),
                          //
                          CustomVisibilty(
                            visible: (!vm.order.isPackageDelivery &&
                                vm.order.deliveryAddress == null),
                            child: "Customer Order Pickup"
                                .tr()
                                .text
                                .italic
                                .light
                                .xl
                                .medium
                                .make()
                                .px20(),
                          ),

                          //note
                          vm.order.note.isEmpty ? SizedBox():
                          "Note".tr().text.semiBold.xl.make().px20(),
                          "${vm.order.note}".text.light.sm.make().px20(),
                          UiSpacer.vSpace(5),
                          UiSpacer.divider(),
                          //vendor
                          UiSpacer.vSpace(),
                          OrderDetailsVendorInfoView(vm),

                          //driver
                          OrderDetailsDriverInfoView(vm),

                          UiSpacer.divider(),
                          //order summary
                          OrderDetailsSummary(vm.order)
                              .wFull(context)
                              .p20()
                              .pOnly(bottom: context.percentHeight * 10)
                              .box
                              .make()
                        ],
                      )
                          .box
                          .topRounded(value: 15)
                          .clip(Clip.antiAlias)
                          .color(Colors.transparent)
                          .make(),
                      //
                      // UiSpacer.vSpace(50),
                    ],
                  ).cornerRadius(20).scrollVertical(),
                ],
              ),
            ),
            bottomSheet: isOrderTracking ? null : OrderBottomSheet(vm),
          );
        },
      ),
    );
  }
}
