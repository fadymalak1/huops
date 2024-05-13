import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/constants/app_strings.dart';
import 'package:huops/models/vendor_type.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/view_models/vendor/categories.vm.dart';
import 'package:huops/views/pages/category/categories.page.dart';
import 'package:huops/widgets/custom_dynamic_grid_view.dart';
import 'package:huops/widgets/custom_grid_view.dart';
import 'package:huops/widgets/list_items/category.list_item.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class VendorTypeCategories extends StatefulWidget {
  const VendorTypeCategories(
    this.vendorType, {
    this.title,
    this.description,
    this.showTitle = true,
    this.crossAxisCount,
    this.childAspectRatio,
    Key? key,
  }) : super(key: key);

  //
  final VendorType vendorType;
  final String? title;
  final String? description;
  final bool showTitle;
  final int? crossAxisCount;
  final double? childAspectRatio;
  @override
  _VendorTypeCategoriesState createState() => _VendorTypeCategoriesState();
}

class _VendorTypeCategoriesState extends State<VendorTypeCategories> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CategoriesViewModel>.reactive(
      viewModelBuilder: () =>
          CategoriesViewModel(context, vendorType: widget.vendorType),
      onViewModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return VStack(
          [
            //
            Visibility(
              visible: model.categories.length > 0,
              child: HStack(
                [
                  VStack(
                    [
                      widget.showTitle
                          ? ((widget.title != null
                                  ? widget.title
                                  : "We are here for you")!
                              .tr()
                              .text
                              .lg
                              .medium
                              .make())
                          : UiSpacer.emptySpace(),
                      (widget.description != null
                              ? widget.description
                              : "How can we help?")!
                          .tr()
                          .text
                          .xl
                          .semiBold
                          .make(),
                    ],
                  ).expand(),
                  //
                  (!isOpen ? "See all" : "Show less")
                      .tr()
                      .text
                      .color(AppColor.primaryColor)
                      .make()
                      .onInkTap(
                    () {
                      context.nextPage(
                        CategoriesPage(vendorType: widget.vendorType),
                      );
                    },
                  ),
                ],
              ).px20(),
            ),
            model.categories.length > 0?SizedBox(height: 10,):SizedBox(),


            //categories list
            CustomDynamicHeightGridView(
              crossAxisCount: 2,
              itemCount: model.categories.length,
              mainAxisSpacing: 0,
              crossAxisSpacing: 0,
              isLoading: model.isBusy,
              noScrollPhysics: true,
              itemBuilder: (ctx, index) {
                return CategoryListItem(
                  category: model.categories[index],
                  onPressed: model.categorySelected,
                  maxLine: false,
                );
              },
            ).px20(),
          ],
        );
      },
    );
  }
}
