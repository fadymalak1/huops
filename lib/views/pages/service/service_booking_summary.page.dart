import 'package:dartx/dartx.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/constants/app_strings.dart';
import 'package:huops/extensions/string.dart';
import 'package:huops/models/service.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/view_models/service_booking_summary.vm.dart';
import 'package:huops/views/pages/checkout/widgets/payment_methods.view.dart';
import 'package:huops/views/pages/checkout/widgets/schedule_order.view.dart';
import 'package:huops/views/pages/service/widgets/service_delivery_address.view.dart';
import 'package:huops/views/pages/service/widgets/service_details_price.section.dart';
import 'package:huops/views/pages/service/widgets/service_discount_section.dart';
import 'package:huops/widgets/base.page.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:huops/widgets/cards/order_summary.dart';
import 'package:huops/widgets/custom_image.view.dart';
import 'package:huops/widgets/custom_text_form_field.dart';
import 'package:huops/widgets/states/loading.shimmer.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class ServiceBookingSummaryPage extends StatelessWidget {
  const ServiceBookingSummaryPage(
    this.service, {
    Key? key,
  }) : super(key: key);

  //
  final Service service;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ServiceBookingSummaryViewModel>.reactive(
      viewModelBuilder: () => ServiceBookingSummaryViewModel(context, service),
      onViewModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        return BasePage(
          showAppBar: true,
          title: "Booking Summary".tr(),
          showLeadingAction: true,
          body: VStack(
            [
              VStack(
                [
                  //service details in summary page
                  HStack(
                    [
                      //service logo
                      CustomImage(
                        imageUrl: (vm.service!.photos != null &&
                            vm.service!.photos!.isNotEmpty)
                            ? (vm.service!.photos?.first ?? "")
                            : '',
                        width: context.percentWidth * 18,
                        height: 80,
                      ).box.clip(Clip.antiAlias).withRounded(value: 15.0).make(),
                      //service details
                      VStack(
                        [
                          vm.service!.name.text.xl.maxLines(2).ellipsis.make(),
                          5.heightBox,
                          //price
                          ServiceDetailsPriceSectionView(
                            service,
                            onlyPrice: true,
                            showDiscount: true,
                          ),
                          //selected hours
                          HStack(
                            [
                              "${vm.service!.duration.capitalize().tr()}:"
                                  .text
                              // .sm
                                  .make(),
                              //
                              "${vm.service!.selectedQty}"
                                  .text
                              // .sm
                                  .bold
                                  .make(),
                            ],
                            spacing: 5,
                          ),
                        ],
                      ).px12().expand(),
                    ],
                  ).p8(),
                  //selected options if any
                  if (vm.service!.selectedOptions.isNotEmpty) ...[
                    20.heightBox,
                    "Selected Options".tr().text.semiBold.make().px(10),
                    2.heightBox,
                    ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      children: vm.service!.selectedOptions.map(
                        (option) {
                          return HStack(
                            [
                              "${option.name}".text.make().expand(),
                              10.widthBox,
                              //price
                              "${AppStrings.currencySymbol} ${option.price}"
                                  .currencyFormat()
                                  .text
                                  .bold
                                  .make(),
                            ],
                          );
                        },
                      ).toList(),
                    ).px(12),
                    20.heightBox,
                  ],
                ],
              )
                  .box
                  .roundedSM
                  .clip(Clip.antiAlias)
                  .make().glassMorphic(),

              //
              //
              Divider(thickness: 1).py12(),
              //note
              Visibility(
                visible: vm.noteTEC.text.isNotEmpty,
                child: Column(
                  children: [
                    CustomTextFormField(
                      labelText: "Note".tr(),
                      textEditingController: vm.noteTEC,
                    ),
                    UiSpacer.verticalSpace(),
                  ],
                ),
              ),

              //pickup time slot
              Visibility(
                visible:  vm.vendor!.allowScheduleOrder,
                child: Column(
                  children: [
                    ScheduleOrderView(vm),
                    Divider(thickness: 1).py12(),

                  ],
                ),
              ),

              //address
              Visibility(
                visible: vm.service!.location,
                child: ServiceDeliveryAddressPickerView(
                  vm,
                  service: service,
                ),
              ),
              ServiceDiscountSection(vm)
                  .p20()
                  .box
                  .make().glassMorphic().py12(),
              DottedLine(dashColor: Colors.white.withOpacity(0.5),).py12(),

              //order final price preview
              LoadingShimmer(
                loading: vm.isBusy,
                child: OrderSummary(
                  subTotal: vm.checkout?.subTotal,
                  discount: vm.checkout?.discount,
                  deliveryFee:
                      vm.service!.location ? vm.checkout?.deliveryFee : null,
                  tax: vm.checkout?.tax,
                  vendorTax: vm.vendor?.tax,
                  total: vm.checkout!.total,
                  fees: vm.vendor?.fees ?? [],
                ),
              ),

              //
              Divider(thickness: 1).py12(),
              //payment options
              PaymentMethodsView(vm),

              //checkout button
              CustomButton(
                title: "Book Now".tr().padRight(14),
                icon: FlutterIcons.credit_card_fea,
                loading: vm.isBusy,
                onPressed: vm.placeOrder,
              ).wFull(context),
            ],
          ).p20().scrollVertical(),
        );
      },
    );
  }
}
