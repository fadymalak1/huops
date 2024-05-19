import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/view_models/favourites.vm.dart';
import 'package:huops/views/pages/favourite/fav_vendor_data.dart';
import 'package:huops/widgets/base.page.dart';
import 'package:huops/widgets/buttons/route.button.dart';
import 'package:huops/widgets/custom_image.view.dart';
import 'package:huops/widgets/custom_list_view.dart';
import 'package:huops/widgets/list_items/dynamic_vendor.list_item.dart';
import 'package:huops/widgets/list_items/horizontal_product.list_item.dart';
import 'package:huops/widgets/list_items/service.list_item.dart';
import 'package:huops/widgets/states/error.state.dart';
import 'package:huops/widgets/states/product.empty.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:supercharged/supercharged.dart';
import 'package:velocity_x/velocity_x.dart';

class FavouritesPage extends StatelessWidget {
  const FavouritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FavouritesViewModel>.reactive(
      viewModelBuilder: () => FavouritesViewModel(context),
      onViewModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        return DefaultTabController(
          length: 3,
          child: BasePage(
            showAppBar: true,
            showLeadingAction: true,
            title: "Favourites".tr(),
            isLoading: vm.isBusy,
            bottomTabBar: TabBar(
              tabs: [
                Tab(text: 'Products'.tr()),
                Tab(text: 'Vendors'.tr()),
                Tab(text: 'Services'.tr()),
              ],
            ),
            body: TabBarView(
              children: [
                // product
                VStack(
                  [
                    //
                    "Note: Tap & Hold to remove favourite".tr().text.make().p20(),

                    //
                    CustomListView(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      dataSet: vm.products,
                      isLoading: vm.busy(vm.products),
                      emptyWidget: EmptyProduct(),
                      errorWidget: LoadingError(
                        onrefresh: vm.fetchProducts,
                      ),
                      itemBuilder: (context, index) {
                        //
                        final product = vm.products[index];
                        //
                        return HorizontalProductListItem(
                          product,
                          onPressed: vm.openProductDetails,
                          qtyUpdated: vm.addToCartDirectly,
                        ).onLongPress(
                          () => vm.removeFavouriteProduct(product,context),
                          GlobalKey(),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          UiSpacer.verticalSpace(space: 10),
                    ).expand(),
                  ],
                ),
                // Vendor
                VStack(
                  [
                    //
                    "Note: Tap & Hold to remove favourite".tr().text.make().p20(),

                    //
                    // Center(
                    //   child: Text("Favourites Vendors"),
                    // ).expand()
                    CustomListView(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      dataSet: vm.vendors,
                      isLoading: vm.busy(vm.vendors),
                      emptyWidget: EmptyProduct(),
                      errorWidget: LoadingError(
                        onrefresh: vm.fetchProducts,
                      ),
                      itemBuilder: (context, index) {
                        final vendor = vm.vendors[index];
                        return DynamicVendorListItem(
                          vendor.vendor,
                          onPressed: vm.vendorSelected,
                        ).onLongPress(
                              () => vm.removeFavouriteVendor(vendor.vendor,context),
                          GlobalKey(),
                        ).py4().px4();;
                      },
                      separatorBuilder: (context, index) =>
                          UiSpacer.verticalSpace(space: 10),
                    ).expand(),
                  ],
                ),

                // Service
                VStack(
                  [
                    //
                    "Note: Tap & Hold to remove favourite".tr().text.make().p20(),

                    //
                    // Center(
                    //   child: Text("Favourites Vendors"),
                    // ).expand()
                    CustomListView(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      dataSet: vm.services,
                      isLoading: vm.busy(vm.services),
                      emptyWidget: EmptyProduct(),
                      errorWidget: LoadingError(
                        onrefresh: vm.fetchProducts,
                      ),
                      itemBuilder: (context, index) {
                        //
                        final service = vm.services[index];
                        return ServiceListItem(
                          service: service.service,
                          onPressed: vm.servicePressed,
                          height: 80,
                          imgW: 60,
                        ).px12().onLongPress(() {
                          vm.removeFavouriteService(service.service,context);
                        }, GlobalKey());
                        // return Horizontal(
                        //   product,
                        //   onPressed: vm.openProductDetails,
                        //   qtyUpdated: vm.addToCartDirectly,
                        // ).onLongPress(
                        //       () => vm.removeFavourite(product,context),
                        //   GlobalKey(),
                        // );
                      },
                      separatorBuilder: (context, index) =>
                          UiSpacer.verticalSpace(space: 10),
                    ).expand(),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
