import 'package:flutter/material.dart';
import 'package:huops/models/vendor_type.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/view_models/vendor/categories.vm.dart';
import 'package:huops/views/pages/category/categories.page.dart';
import 'package:huops/widgets/custom_horizontal_list_view.dart';
import 'package:huops/widgets/list_items/category.list_item.dart';
import 'package:huops/widgets/section.title.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class Categories extends StatelessWidget {
  const Categories(this.vendorType, {Key? key}) : super(key: key);
  final VendorType vendorType;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CategoriesViewModel>.reactive(
      viewModelBuilder: () => CategoriesViewModel(
        context,
        vendorType: vendorType,
      ),
      onViewModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return VStack(
          [
            //
            HStack(
              [
                SectionTitle("Categories".tr()).expand(),
                UiSpacer.smHorizontalSpace(),
                "See all".tr().text.color(context.primaryColor).make().onInkTap(
                  () {
                    //
                    context.nextPage(
                      CategoriesPage(vendorType: vendorType),
                    );
                  },
                ),
              ],
            ).p12(),

            //categories list
            CustomHorizontalListView(
              isLoading: model.isBusy,
              itemsViews: model.categories.map(
                (category) {
                  return CategoryListItem(
                    category: category,
                    onPressed: model.categorySelected,
                    maxLine: false,
                  );
                },
              ).toList(),
            ),
          ],
        );
      },
    );
  }
}
