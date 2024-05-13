import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/models/coupon.dart';
import 'package:huops/services/navigation.service.dart';
import 'package:huops/services/toast.service.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/utils/utils.dart';
import 'package:huops/view_models/coupons.vm.dart';
import 'package:huops/views/pages/vendor_details/vendor_details.page.dart';
import 'package:huops/widgets/base.page.dart';
import 'package:huops/widgets/base.page.withoutNavbar.dart';
import 'package:huops/widgets/custom_list_view.dart';
import 'package:huops/widgets/list_items/dynamic_product.list_item.dart';
import 'package:huops/widgets/list_items/vendor.list_item.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class CouponDetailsPage extends StatelessWidget {
  const CouponDetailsPage(this.coupon, {Key? key}) : super(key: key);

  final Coupon coupon;

  @override
  Widget build(BuildContext context) {
    Color bgColor = coupon.color != null
        ? Vx.hexToColor(coupon.color!)
        : AppColor.primaryColor;
    Color textColor = Utils.textColorByColor(bgColor);
    //
    return BasePageWithoutNavBar(
      showAppBar: true,
      showLeadingAction: true,
      extendBodyBehindAppBar: true,
      elevation: 0,
      appBarColor: Colors.transparent,
      actions: [
        IconButton(
          onPressed: () async {
            try {
              await Clipboard.setData(
                ClipboardData(
                  text: coupon.code,
                ),
              );
              //
              ToastService.toastSuccessful("Copied to clipboard".tr());
            } catch (error) {
              ToastService.toastError("$error");
            }
          },
          icon: Icon(FlutterIcons.copy_fea,color: Colors.white,),
        ),
      ],
      body: ViewModelBuilder<CouponsViewModel>.reactive(
        viewModelBuilder: () => CouponsViewModel(context, null, coupon: coupon),
        onViewModelReady: (vm) => vm.fetchCouponDetails(),
        builder: (context, vm, child) {
          //
          return VStack(
            [
              //header
              VStack(
                [
                  "${vm.coupon?.code}"
                      .text
                      .xl3
                      .extraBlack
                      .color(Colors.white)
                      .makeCentered(),
                  "${vm.coupon?.description}"
                      .text
                      .sm
                      .medium
                      .color(Colors.white)
                      .makeCentered(),
                  UiSpacer.vSpace(),
                ],
              ).wFull(context).px(10).safeArea().box.make(),

              VStack(
                [
                  Visibility(
                    visible: vm.coupon!.products.isNotEmpty,
                    child: "Products".tr().text.semiBold.xl.make().py(10),
                  ),
                  //vendor/products
                  CustomListView(
                    noScrollPhysics: true,
                    padding: EdgeInsets.zero,
                    isLoading: vm.busy(vm.coupon),
                    dataSet: vm.coupon!.products,
                    separatorBuilder: ((p0, p1) => UiSpacer.vSpace(0)),
                    itemBuilder: (context, index) {
                      final product = vm.coupon!.products[index];
                      return DynamicProductListItem(
                        product,
                        onPressed: (product) {
                          //
                          final page = NavigationService()
                              .productDetailsPageWidget(product);
                          context.nextPage(page);
                        },
                      );
                    },
                    emptyWidget:
                        ""
                            .tr()
                            .text
                            .lg
                            .thin
                            .center
                            .makeCentered(),
                  ),

                  UiSpacer.vSpace(),
                  Visibility(
                    visible: vm.coupon!.vendors.isNotEmpty,
                    child: "Vendors".tr().text.semiBold.xl.make().py(10),
                  ),
                  CustomListView(
                    noScrollPhysics: true,
                    padding: EdgeInsets.zero,
                    isLoading: vm.busy(vm.coupon),
                    dataSet: vm.coupon!.vendors,
                    separatorBuilder: ((p0, p1) => UiSpacer.vSpace(0)),
                    itemBuilder: (context, index) {
                      final vendor = vm.coupon!.vendors[index];
                      return VendorListItem(
                        vendor: vendor,
                        onPressed: (vendor) {
                          context.nextPage(VendorDetailsPage(vendor: vendor));
                        },
                      );
                    },
                    emptyWidget:
                        "Coupon can be use with most vendors without restrictions"
                            .tr()
                            .text
                            .lg
                            .thin
                            .center
                            .makeCentered(),
                  ),
                ],
                crossAlignment: CrossAxisAlignment.start,
                alignment: MainAxisAlignment.start,
              ).p16().scrollVertical().expand(),
            ],
          );
        },
      ),
    );
  }
}
