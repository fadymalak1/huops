import 'package:flutter/material.dart';
import 'package:huops/enums/product_fetch_data_type.enum.dart';
import 'package:huops/models/product.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/view_models/products.vm.dart';
import 'package:huops/widgets/custom_masonry_grid_view.dart';
import 'package:huops/widgets/list_items/commerce_product.list_item.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class SimilarCommerceProducts extends StatefulWidget {
  SimilarCommerceProducts(this.product, {Key? key}) : super(key: key);

  final Product product;
  @override
  State<SimilarCommerceProducts> createState() =>
      _SimilarCommerceProductsState();
}

class _SimilarCommerceProductsState extends State<SimilarCommerceProducts> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductsViewModel>.reactive(
      viewModelBuilder: () => ProductsViewModel(
        context,
        widget.product.vendor.vendorType,
        ProductFetchDataType.RANDOM,
        categoryId: widget.product.categoryId,
      ),
      onViewModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return VStack(
          [
            //
            UiSpacer.verticalSpace(),
            UiSpacer.cutDivider(),
            'Related Products'
                .tr()
                .text
                .make()
                .wFull(context)
                .px20()
                .py12()
                .box
                .color(context.theme.colorScheme.background)
                .make(),
            UiSpacer.verticalSpace(),
            //
            CustomMasonryGridView(
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              isLoading: model.isBusy,
              items: model.products.map(
                (product) {
                  return CommerceProductListItem(
                    product,
                    height: 90,
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
