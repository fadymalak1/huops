import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/models/option_group.dart';
import 'package:huops/models/product.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/view_models/product_details.vm.dart';
import 'package:huops/views/pages/product/widgets/product_details.header.dart';
import 'package:huops/views/pages/product/widgets/product_details_cart.bottom_sheet.dart';
import 'package:huops/views/pages/product/widgets/product_option_group.dart';
import 'package:huops/views/pages/product/widgets/product_options.header.dart';
import 'package:huops/widgets/base.page.dart';
import 'package:huops/widgets/buttons/share.btn.dart';
import 'package:huops/widgets/cart_page_action.dart';
import 'package:huops/widgets/custom_image.view.dart';
import 'package:huops/widgets/html_text_view.dart';
import 'package:huops/widgets/states/loading_indicator.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:banner_carousel/banner_carousel.dart';

import '../../../widgets/busy_indicator.dart';
import '../../../widgets/buttons/custom_button.dart';


class ProductDetailsPage extends StatelessWidget {
  ProductDetailsPage({
    required this.product,
    Key? key,
  }) : super(key: key);

  final Product product;

  //
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductDetailsViewModel>.reactive(
      viewModelBuilder: () => ProductDetailsViewModel(context, product),
      onViewModelReady: (model) => model.getProductDetails(),
      builder: (context, model, child) {
        return BasePage(
          // title: model.product.name,
          showAppBar: true,
          showLeadingAction: true,
          extendBodyBehindAppBar: true,
          elevation: 0,
          appBarColor: Colors.transparent,
          appBarItemColor: Colors.white,
          showCart: true,
          actions: [
            SizedBox(
              width: 50,
              height: 50,
              child: FittedBox(
                child: ShareButton(
                  model: model,
                ),
              ),
            ),
            UiSpacer.hSpace(10),
            //   PageCartAction(),
          ],
          body: CustomScrollView(
            slivers: [
              //product image
              SliverToBoxAdapter(
                child: Container(
                  child: ZStack(
                    [
                      BannerCarousel(
                        customizedBanners:
                        model.product.photos.map((photoPath) {
                          return Container(
                            child: CustomImage(
                              imageUrl: photoPath,
                              boxFit: BoxFit.contain,
                              canZoom: true,
                            ),
                          );
                        }).toList(),
                        customizedIndicators: IndicatorModel.animation(
                          width: 10,
                          height: 6,
                          spaceBetween: 2,
                          widthAnimation: 50,
                        ),
                        margin: EdgeInsets.zero,
                        height: context.percentHeight * 30,
                        width: context.percentWidth * 100,
                        activeColor: AppColor.primaryColor,
                        disableColor: Colors.grey.shade300,
                        animation: true,
                        borderRadius: 25,
                        indicatorBottom: true,
                      ).box.make(),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(25),
                              topLeft: Radius.circular(25),
                            )),
                        margin: EdgeInsets.only(top: 200),
                        child: GlassContainer.clearGlass(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(25),
                            topLeft: Radius.circular(25),
                          ),
                          blur: 15,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: VStack(
                            [
                              //product header
                              ProductDetailsHeader(product: model.product),
                              //product description
                              UiSpacer.verticalSpace(space: 2).py12(),
                              HtmlTextView(model.product.description).px20(),
                              UiSpacer.verticalSpace(space: 2).py12(),

                              //options header
                              Visibility(
                                visible: model.product.optionGroups.isNotEmpty,
                                child: VStack(
                                  [
                                    ProductOptionsHeader(
                                      description:
                                      "Select options to add them to the product/service"
                                          .tr(),
                                    ),

                                    //options
                                    model.busy(model.product)
                                        ? BusyIndicator().centered().py20()
                                        : VStack(
                                      [
                                        ...buildProductOptions(model),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              //more from vendor
                              // OutlinedButton(
                              //   onPressed: model.openVendorPage,
                              //   child: "View more from "
                              //       .tr()
                              //       .richText
                              //       .sm
                              //       .withTextSpanChildren(
                              //         [
                              //           " ${model.product.vendor.name}"
                              //               .textSpan
                              //               .semiBold
                              //               .make(),
                              //         ],
                              //       )
                              //       .make()
                              //       .py12(),
                              // ).centered().py16(),
                              // UiSpacer.expandedSpace(),
                              20.heightBox,
                              ProductDetailsCartBottomSheet(model: model),
                            ],
                          )
                              .pOnly(bottom: context.percentHeight * 3)
                              .box
                              .outerShadow3Xl
                              .color(Colors.transparent)
                              .topRounded(value: 20)
                              .clip(Clip.antiAlias)
                              .make(),
                        ),
                      ),
                      Positioned(
                        right: 20,
                        top: 180,
                        child: CustomButton(
                          elevation: 12,
                          color: Colors.deepOrange.withOpacity(.5),
                          // loading: model.isBusy,
                          child: Icon(
                            model.product.isFavourite
                                ? FlutterIcons.heart_ant
                                : FlutterIcons.heart_fea,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            !(model.isAuthenticated() == true)
                                ? model.openLogin()
                                : !(model.product.isFavourite ?? false)
                                ? model.addToFavourite()
                                : model.removeFromFavourite();
                          },
                        ).cornerRadius(50).w(Vx.dp56).pOnly(right: Vx.dp24),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ).box.color(Colors.transparent).make(),
          // bottomSheet: ProductDetailsCartBottomSheet(model: model),
        );
      },
    );
  }

  //
  buildProductOptions(model) {
    return model.product.optionGroups.map((OptionGroup optionGroup) {
      return ProductOptionGroup(optionGroup: optionGroup, model: model)
          .pOnly(bottom: Vx.dp12);
    }).toList();
  }
}


// class ProductDetailsPage extends StatelessWidget {
//   ProductDetailsPage({
//     required this.product,
//     Key? key,
//   }) : super(key: key);
//
//   final Product product;
//
//   //
//   @override
//   Widget build(BuildContext context) {
//     return ViewModelBuilder<ProductDetailsViewModel>.reactive(
//       viewModelBuilder: () => ProductDetailsViewModel(context, product),
//       onViewModelReady: (model) => model.getProductDetails(),
//       builder: (context, model, child) {
//         return BasePage(
//           title: model.product.name,
//           showAppBar: true,
//           showLeadingAction: true,
//           elevation: 0,
//           appBarColor: AppColor.faintBgColor,
//           appBarItemColor: AppColor.primaryColor,
//           showCart: true,
//           actions: [
//             SizedBox(
//               width: 50,
//               height: 50,
//               child: FittedBox(
//                 child: ShareButton(
//                   model: model,
//                 ),
//               ),
//             ),
//             UiSpacer.hSpace(10),
//             // PageCartAction(),
//           ],
//           body: CustomScrollView(
//             slivers: [
//               //product image
//               SliverToBoxAdapter(
//                 child: BannerCarousel(
//                   customizedBanners: model.product.photos.map((photoPath) {
//                     return Container(
//                       child: CustomImage(
//                         imageUrl: photoPath,
//                         boxFit: BoxFit.contain,
//                         canZoom: true,
//                       ),
//                     );
//                   }).toList(),
//                   customizedIndicators: IndicatorModel.animation(
//                     width: 10,
//                     height: 6,
//                     spaceBetween: 2,
//                     widthAnimation: 50,
//                   ),
//                   margin: EdgeInsets.zero,
//                   height: context.percentHeight * 30,
//                   width: context.percentWidth * 100,
//                   activeColor: AppColor.primaryColor,
//                   disableColor: Colors.grey.shade300,
//                   animation: true,
//                   borderRadius: 0,
//                   indicatorBottom: true,
//                 ).box.color(AppColor.faintBgColor).make(),
//               ),
//
//               SliverToBoxAdapter(
//                 child: VStack(
//                   [
//                     //product header
//                     ProductDetailsHeader(product: model.product),
//                     //product description
//                     UiSpacer.divider(height: 1, thickness: 2).py12(),
//                     HtmlTextView(model.product.description).px20(),
//                     UiSpacer.divider(height: 1, thickness: 2).py12(),
//
//                     //options header
//                     Visibility(
//                       visible: model.product.optionGroups.isNotEmpty,
//                       child: LoadingIndicator(
//                         loading: model.busy(model.product),
//                         child: VStack(
//                           [
//                             ProductOptionsHeader(
//                               description:
//                                   "Select options to add them to the product/service"
//                                       .tr(),
//                             ),
//
//                             //options
//                             VStack(
//                               [
//                                 ...buildProductOptions(model),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//
//                     //more from vendor
//                     OutlinedButton(
//                       onPressed: model.openVendorPage,
//                       child: "View more from"
//                           .tr()
//                           .richText
//                           .sm
//                           .withTextSpanChildren(
//                             [
//                               " ${model.product.vendor.name}"
//                                   .textSpan
//                                   .semiBold
//                                   .make(),
//                             ],
//                           )
//                           .make()
//                           .py12(),
//                     ).centered().py16(),
//                   ],
//                 )
//                     .pOnly(bottom: context.percentHeight * 30)
//                     .box
//                     .outerShadow3Xl
//                     .color(context.theme.colorScheme.background)
//                     .topRounded(value: 20)
//                     .clip(Clip.antiAlias)
//                     .make(),
//               ),
//             ],
//           ).box.color(AppColor.faintBgColor).make(),
//           bottomSheet: ProductDetailsCartBottomSheet(model: model),
//         );
//       },
//     );
//   }
//
//   //
//   buildProductOptions(model) {
//     return model.product.optionGroups.map((OptionGroup optionGroup) {
//       return ProductOptionGroup(optionGroup: optionGroup, model: model)
//           .pOnly(bottom: Vx.dp12);
//     }).toList();
//   }
// }
