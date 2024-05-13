import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/constants/app_strings.dart';
import 'package:huops/constants/home_screen.config.dart';
import 'package:huops/models/search.dart';
import 'package:huops/services/navigation.service.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/view_models/welcome.vm.dart';
import 'package:huops/views/pages/service/service.page.dart';
import 'package:huops/views/pages/services/services_screen.dart';
import 'package:huops/views/pages/vendor/widgets/banners.view.dart';
import 'package:huops/views/pages/vendor/widgets/section_vendors.view.dart';
import 'package:huops/views/shared/widgets/section_coupons.view.dart';
import 'package:huops/widgets/base.page.dart';
import 'package:huops/widgets/base.page.withoutNavbar.dart';
import 'package:huops/widgets/cards/custom.visibility.dart';
import 'package:huops/widgets/cards/welcome_intro.view.dart';
import 'package:huops/widgets/custom_list_view.dart';
import 'package:huops/widgets/finance/wallet_management.view.dart';
import 'package:huops/widgets/list_items/horizontal_vendor.list_item.dart';
import 'package:huops/widgets/list_items/service.list_item.dart';
import 'package:huops/widgets/list_items/vendor_type.list_item.dart';
import 'package:huops/widgets/list_items/vendor_type.vertical_list_item.dart';
import 'package:huops/widgets/states/loading.shimmer.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:masonry_grid/masonry_grid.dart';
import 'package:velocity_x/velocity_x.dart';

class EmptyWelcome extends StatelessWidget {
  const EmptyWelcome({
    required this.vm,
    Key? key,
  }) : super(key: key);

  final WelcomeViewModel vm;
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //
        // SafeArea(
        //   child: WelcomeIntroView(),
        // ),
        // SizedBox(height: 100,),

          //
          VStack(
            [
              //finance section
              CustomVisibilty(
                visible: HomeScreenConfig.showWalletOnHomeScreen,
                child: WalletManagementView().px20().py16(),
              ),
              //
              //top banner
              CustomVisibilty(
                visible: HomeScreenConfig.showBannerOnHomeScreen &&
                    HomeScreenConfig.isBannerPositionTop,
                child: VStack(
                  [
                    Banners(
                      null,
                      itemRadius: 25,
                      featured: true,
                    ),
                  ],
                ),
              ),
              //
              VStack(
                [
                  HStack(
                    [
                      "Services".tr().text.xl2.bold.color(Colors.white).make().expand(),
                      "View all".tr().text.lg.color(Colors.grey).make().onTap(() {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ServicesScreen(vm: vm)));
                      }),
                      // CustomVisibilty(
                      //   visible: HomeScreenConfig.isVendorTypeListingBoth,
                      //   child: Icon(
                      //     vm.showGrid
                      //         ? FlutterIcons.grid_fea
                      //         : FlutterIcons.list_fea,
                      //   ).p2().onInkTap(
                      //     () {
                      //       vm.showGrid = !vm.showGrid;
                      //       vm.notifyListeners();
                      //     },
                      //   ),
                      // ),
                    ],
                    crossAlignment: CrossAxisAlignment.center,
                  ),
                  UiSpacer.vSpace(12),
                  //list view
                  CustomVisibilty(
                    visible: (HomeScreenConfig.isVendorTypeListingBoth &&
                            !vm.showGrid) ||
                        (!HomeScreenConfig.isVendorTypeListingBoth &&
                            HomeScreenConfig.isVendorTypeListingListView),
                    child: CustomListView(
                      noScrollPhysics: true,
                      dataSet: vm.vendorTypes,
                      isLoading: vm.isBusy,
                      loadingWidget: LoadingShimmer().px20(),
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        final vendorType = vm.vendorTypes[index];
                        return VendorTypeListItem(
                          vendorType,
                          onPressed: () {
                            NavigationService.pageSelected(vendorType,
                                context: context);
                          },
                        );
                      },
                      separatorBuilder: (context, index) => UiSpacer.emptySpace(),
                    ),
                  ),
                  //gridview
                  CustomVisibilty(
                    visible: HomeScreenConfig.isVendorTypeListingGridView &&
                        vm.showGrid &&
                        vm.isBusy,
                    child: LoadingShimmer().px20().centered(),
                  ),
                  CustomVisibilty(
                    visible: HomeScreenConfig.isVendorTypeListingGridView &&
                        vm.showGrid &&
                        !vm.isBusy,
                    child: AnimationLimiter(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: StaggeredGrid.count(

                          crossAxisCount: 2,
                          crossAxisSpacing: 10,

                          mainAxisSpacing: 10,

                          children: List.generate(
                            vm.vendorTypes.length,
                            (index) {
                              final vendorType = vm.vendorTypes[index];
                              if(index==0){
                                return StaggeredGridTile.count(
                                  crossAxisCellCount: 1,
                                  mainAxisCellCount: 2,
                                  child: VendorTypeVerticalListItem(
                                    vendorType,
                                    onPressed: () {
                                      NavigationService.pageSelected(vendorType,
                                          context: context);
                                    }
                                  )
                                );
                              }else if(index>=3){
                                return SizedBox();
                              }else
                                return StaggeredGridTile.count(
                                crossAxisCellCount: 1,
                                mainAxisCellCount: 1,
                                child: VendorTypeVerticalListItem(
                                  vendorType,
                                  onPressed: () {
                                    NavigationService.pageSelected(vendorType,
                                        context: context);
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ).glassMorphic(opacity: 0.1,borderRadius: BorderRadius.circular(20)),
                  ),
                ],
              ).p20(),

              //botton banner
              CustomVisibilty(
                visible: HomeScreenConfig.showBannerOnHomeScreen &&
                    !HomeScreenConfig.isBannerPositionTop,
                child: Banners(
                  null,
                  featured: true,
                ).py12(),
              ),


              //featured vendors
              SectionVendorsView(
                null,
                title: "Nearby Vendors".tr(),
                titlePadding: EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                itemsPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                scrollDirection: Axis.horizontal,
                type: SearchFilterType.featured,
                itemWidth: context.percentWidth * 48,
                // byLocation: AppStrings.enableFatchByLocation,
                byLocation: false,
                hideEmpty: true,
              ).pOnly(left: 20,bottom: 20),

              //coupons

              SectionCouponsView(
                null,
                title: "Coupons".tr(),
                scrollDirection: Axis.horizontal,
                itemWidth: context.percentWidth * 70,
                height: 100,
                itemsPadding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                bPadding: 10,
              ).pOnly(left: 20),

              //spacing
              UiSpacer.vSpace(20),
            ],
          )
              .box
              .topRounded(value: 0)
              .make(),
        ],
      ).box.make().scrollVertical();
  }
}
