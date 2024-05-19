import 'package:flutter/material.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/view_models/vendor_details.vm.dart';
import 'package:huops/view_models/vendor_menu_details.vm.dart';
import 'package:huops/widgets/base.page.withoutNavbar.dart';
import 'package:huops/widgets/busy_indicator.dart';
import 'package:huops/widgets/custom_grid_view.dart';
import 'package:huops/widgets/custom_list_view.dart';
import 'package:huops/widgets/list_items/food_horizontal_product.list_item.dart';
import 'package:huops/widgets/list_items/grid_view_product.list_item.dart';
import 'package:huops/widgets/list_items/horizontal_product.list_item.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key, required this.model});

  final VendorDetailsViewModel model;

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<VendorDetailsWithMenuViewModel>.reactive(
        viewModelBuilder: () => VendorDetailsWithMenuViewModel(
              context,
              widget.model.vendor,
              tickerProvider: this,
            ),
        onViewModelReady: (model) {
          model.tabBarController = TabController(
            length: model.vendor?.menus.length ?? 0,
            vsync: this,
          );
          model.getVendorDetails();
        },
        builder: (context, model, child) {
          return BasePageWithoutNavBar(
            showAppBar: true,
            title: "Menu",
            showLeadingAction: true,
            body: model.isBusy?BusyIndicator().centered():Column(children: [
              TabBar(
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColor.primaryColor,
                ),
                controller: model.tabBarController,
                tabs: model.vendor!.menus.map(
                  (menu) {
                    return Tab(
                      text: menu.name,
                    );
                  },
                ).toList(),
              ).glassMorphic(),
              Expanded(
                child:TabBarView(
                        controller: model.tabBarController,
                        children: model.vendor!.menus.map(
                          (menu) {
                            return CustomGridView(
                              noScrollPhysics: false,
                              canPullUp: true,

                              canRefresh: true,
                              onRefresh: () =>
                                  model.loadMoreProducts(menu.id),
                              refreshController:
                              model.getRefreshController(menu.id),
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              onLoading: () => model.loadMoreProducts(
                                menu.id,
                                initialLoad: false,
                              ),
                              dataSet: model.menuProducts[menu.id] ?? [],
                              isLoading: model.busy(menu.id),
                              itemBuilder: (context, index) {
                                final product =
                                    model.menuProducts[menu.id]?[index];
                                // return HorizontalProductListItem(
                                //   product,
                                //   onPressed: model.productSelected,
                                //   qtyUpdated: model.addToCartDirectly,
                                // ).px20();

                                return GridViewProductListItem(
                                  product: product,
                                  qtyUpdated: model.addToCartDirectly,
                                  onPressed: model.productSelected,
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  UiSpacer.verticalSpace(space: 0),
                            );
                          },
                        ).toList(),
                        physics: BouncingScrollPhysics(),
                      ).py12(),
              ),
            ]).p20(),
          );
        });
  }
}
