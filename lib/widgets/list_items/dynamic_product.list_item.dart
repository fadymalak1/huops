import 'package:flutter/material.dart';
import 'package:huops/models/product.dart';
import 'package:huops/widgets/list_items/food_horizontal_product.list_item.dart';

class DynamicProductListItem extends StatelessWidget {
  const DynamicProductListItem(
    this.product, {
    this.onPressed,
    this.h,
    Key? key,
  }) : super(key: key);

  final Product product;
  final Function(Product)? onPressed;
  final double? h;
  @override
  Widget build(BuildContext context) {
    return FoodHorizontalProductListItem(
      product,
      height: h ?? 100,
      qtyUpdated: null,
      onPressed: onPressed,
    );
    // return product.vendor.vendorType.isFood
    //     ? FoodHorizontalProductListItem(
    //         product,
    //         height: 90,
    //         qtyUpdated: null,
    //         onPressed: onPressed,
    //       )
    //     : product.vendor.vendorType.isCommerce
    //         ? CommerceProductListItem(product, height: 100)
    //         : ProductListItem(product: product, qtyUpdated: null);
  }
}
