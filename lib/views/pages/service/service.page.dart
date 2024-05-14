import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/constants/app_strings.dart';
import 'package:huops/models/vendor_type.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/view_models/service.vm.dart';
import 'package:huops/views/pages/service/widgets/popular_services.view.dart';
import 'package:huops/views/pages/vendor/widgets/complex_header.view.dart';
import 'package:huops/views/pages/vendor/widgets/simple_styled_banners.view.dart';
import 'package:huops/widgets/base.page.dart';
import 'package:huops/widgets/states/alternative.view.dart';
import 'package:huops/widgets/vendor_type_categories.view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../models/search.dart';
import '../../../widgets/inputs/search_bar.input.dart';
import '../vendor/widgets/header.view.dart';
import 'widgets/top_service_vendors.view.dart';

class ServicePage extends StatefulWidget {
  const ServicePage(this.vendorType, {Key? key}) : super(key: key);

  final VendorType vendorType;
  @override
  _ServicePageState createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage>
    with AutomaticKeepAliveClientMixin<ServicePage> {
  GlobalKey pageKey = GlobalKey<State>();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    //
    final mBannerHeight =
        (AppStrings.bannerHeight < (context.percentHeight * 35)
            ? context.percentHeight * 25
            : AppStrings.bannerHeight);

    return ViewModelBuilder<ServiceViewModel>.reactive(
      viewModelBuilder: () => ServiceViewModel(context, widget.vendorType),
      onViewModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return BasePage(
          showAppBar: true,
          showLeadingAction: !AppStrings.isSingleVendorMode,
          elevation: 0,
          title: "${widget.vendorType.name}",
          appBarColor: AppColor.primaryColor,
          appBarItemColor: Colors.white,
          showCart: false,
          key: model.pageKey,
          body: SmartRefresher(
            controller: model.refreshController,
            onRefresh: model.reloadPage,
            child: VStack(
              [
                //location setion
                VendorHeader(
                  model: model,
                  showSearch: false,
                  onrefresh: model.reloadPage,
                ).pOnly(bottom: Vx.dp20),

                //
                AlternativeView(
                  // ismain: widget.vendorType.hasBanners,
                  main: Stack(
                    children: [
                      //banners
                      SimpleStyledBanners(
                        widget.vendorType,
                        height: mBannerHeight,
                        withPadding: false,
                        radius: 0,
                      ).h(mBannerHeight).pOnly(bottom: 30),
                      HStack(
                        [
                          Icon(
                            FlutterIcons.search_fea,
                            size: 24,
                          )
                              .p8()
                              .onInkTap(() {
                            model.openSearch(showType: 5);
                          })
                              .box
                              .roundedSM
                          // .clip(Clip.antiAlias)
                          // .color(AppColor.primaryColor)
                          // .shadowXs
                              .make(),
                          VStack(
                            [
                              "Search beauty center".tr().text.lg.semiBold.make(),
                            ],
                          ).px12().expand(),
                        ],
                      ).px16().py4()
                          .box
                          .color(Colors.white38)
                          .rounded
                          .outerShadowSm
                          .make()
                          .onInkTap(() {model.openSearch(showType: 5);})
                          .px20().positioned(
                        left: 10,
                        right: 10,
                        bottom: 0,
                      ),
                      //
                      // ComplexVendorHeader(
                      //   model: model,
                      //   searchShowType: 5,
                      //   onrefresh: model.reloadPage,
                      // )
                      //     .box
                      //     .color(context.theme.colorScheme.background)
                      //     .roundedSM
                      // // .shadowXs
                      //     .outerShadow
                      //     .make()
                      //     .positioned(
                      //   left: 20,
                      //   right: 20,
                      //   bottom: 0,
                      // ),
                    ],
                  ),
                  // alt: VStack(
                  //   [
                  //     //
                  //     ComplexVendorHeader(
                  //       model: model,
                  //       searchShowType: 5,
                  //       onrefresh: model.reloadPage,
                  //     )
                  //         .box
                  //         .color(context.theme.colorScheme.background)
                  //         .roundedSM
                  //         .outerShadowSm
                  //         .make()
                  //         .px20(),
                  //     //
                  //     SimpleStyledBanners(
                  //       widget.vendorType,
                  //       height: AppStrings.bannerHeight,
                  //     ).py12(),
                  //   ],
                  // ),
                ),

                20.heightBox,
                // categories
                VendorTypeCategories(
                  widget.vendorType,
                  showTitle: false,
                  description: "Categories",
                  childAspectRatio: 1.4,
                  crossAxisCount: 4,
                ),

                //all vendor
                PopularServicesView(widget.vendorType),
                //
                UiSpacer.verticalSpace(),
                //top vendors
                TopServiceVendors(widget.vendorType,isStorageBagType: false,),

                //
                UiSpacer.verticalSpace(
                  space: context.percentHeight * 20,
                ),
              ],
            ).scrollVertical(),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
