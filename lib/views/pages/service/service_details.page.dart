import 'package:banner_carousel/banner_carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/extensions/string.dart';
import 'package:huops/models/service.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/utils/utils.dart';
import 'package:huops/view_models/service_details.vm.dart';
import 'package:huops/views/pages/service/widgets/service_details.bottomsheet.dart';
import 'package:huops/views/pages/service/widgets/service_details_price.section.dart';
import 'package:huops/widgets/base.page.dart';
import 'package:huops/widgets/buttons/share.btn.dart';
import 'package:huops/widgets/custom_image.view.dart';
import 'package:huops/widgets/custom_masonry_grid_view.dart';
import 'package:huops/widgets/html_text_view.dart';
import 'package:huops/widgets/list_items/service_option.list_item.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../constants/app_strings.dart';
import '../../../widgets/busy_indicator.dart';
import '../../../widgets/buttons/custom_button.dart';
import '../../../widgets/buttons/qty_stepper.dart';
import '../../../widgets/cards/custom.visibility.dart';
import '../../../widgets/currency_hstack.dart';
import '../../../widgets/tags/product_tags.dart';
import '../product/widgets/product_details.header.dart';
import '../product/widgets/product_details_cart.bottom_sheet.dart';
import '../product/widgets/product_options.header.dart';

class ServiceDetailsPage extends StatelessWidget {
  const ServiceDetailsPage(
    this.service, {
    Key? key,
  }) : super(key: key);

  //
  final Service service;

  @override
  Widget build(BuildContext context) {
    final currencySymbol = AppStrings.currencySymbol;
    return ViewModelBuilder<ServiceDetailsViewModel>.reactive(
      viewModelBuilder: () => ServiceDetailsViewModel(context, service),
      onViewModelReady: (model) => model.getServiceDetails(),
      builder: (context, vm, child) {
        return BasePage(
          extendBodyBehindAppBar: true,
          isLoading: vm.busy(vm.service),
          showAppBar: true,
          showLeadingAction: true,
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
                  model: vm,
                ),
              ),
            ),
            UiSpacer.hSpace(10),
          ],
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  child: ZStack(
                    [
                      CustomImage(
                        imageUrl:
                            (vm.service.photos != null && vm.service.photos!.isNotEmpty)
                                ? vm.service.photos!.first
                                : '',
                        width: double.infinity,
                        height: context.percentHeight * 40,
                        //context.percentHeight * 50,
                        canZoom: true,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                          topRight: Radius.circular(25),
                          topLeft: Radius.circular(25),
                        )),
                        margin: EdgeInsets.only(top: 300),
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
                              VStack(
                                [
                                  30.heightBox,

                                  //product name, vendor name, and price
                                  HStack(
                                    [
                                      //name
                                      VStack(
                                        [
                                          //product name
                                          vm.service.name.text.xl2.semiBold.make(),
                                          //vendor
                                          vm.service.vendor.name.text.xl.make(),
                                        ],
                                      ).expand(),

                                      //price
                                      VStack(
                                        [
                                          //price
                                          CurrencyHStack(
                                            [
                                              currencySymbol.text.lg.bold
                                                  .color(Color(0xffec4513))
                                                  .make(),
                                              (vm.service.showDiscount
                                                      ? vm.service.discountPrice
                                                          ?.currencyValueFormat()
                                                      : vm.service.price
                                                          .currencyValueFormat())
                                                  ?.text
                                                  .xl2
                                                  .color(Color(0xffec4513))
                                                  .bold
                                                  .make(),
                                            ],
                                            crossAlignment: CrossAxisAlignment.end,
                                          ),
                                          //discount
                                          CustomVisibilty(
                                            visible: vm.service.showDiscount,
                                            child: CurrencyHStack(
                                              [
                                                currencySymbol
                                                    .text.lineThrough.gray300.xs
                                                    .make(),
                                                vm.service.price
                                                    .currencyValueFormat()
                                                    .text
                                                    .lineThrough
                                                    .gray300
                                                    .lg
                                                    .medium
                                                    .make(),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  //product size details and more
                                  HStack(
                                    crossAlignment: CrossAxisAlignment.start,
                                    [
                                      //deliverable or not
                                      VStack([
                                        Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      vm.service.vendor.featureImage),
                                                  fit: BoxFit.cover)),
                                        ),
                                      ]),
                                      //
                                      UiSpacer.expandedSpace(),
                                    ],
                                  ).pOnly(top: Vx.dp10),
                                ],
                              ).px20().py12(),
                              //product description
                              UiSpacer.verticalSpace(space: 2).py12(),
                              HtmlTextView(vm.service.description).px20(),
                              UiSpacer.verticalSpace(space: 2).py12(),

                              //options header
                              Visibility(
                                visible: vm.service.optionGroups!.isNotEmpty,
                                child: VStack(
                                  [
                                    ProductOptionsHeader(
                                      description:
                                          "Select options to add them to the product/service"
                                              .tr(),
                                    ),
                                  ],
                                ),
                              ),
                              20.heightBox,
                              VStack(
                                [
                                  //
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    color: Colors.transparent,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          style: ButtonStyle(
                                              backgroundColor:
                                              MaterialStateProperty.all<Color>(Color(0xffec4513)),
                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(15)))),
                                          child: "Beauty center page".tr().text.make(),
                                        ),
                                        QtyStepper(
                                          defaultValue:  1,
                                          min: 1,
                                          max: 10,
                                          disableInput: true,
                                          onChange: vm.updatedSelectedQty,
                                        ),
                                      ],
                                    ),
                                  ),

                                  //
                                  Container(
                                    padding: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColor.primaryColor,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(15),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Color(0xffec4513),
                                          ),
                                          child: vm.service.selectedQty.toString().text.make(),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            vm.bookService();
                                            // vm.addToCart(context: context);
                                          },
                                          child: "Add to cart".tr().text.white.xl.make(),
                                        ),
                                        "|".text.xl2.color(Colors.white).make(),
                                        CurrencyHStack(
                                          [
                                            vm.currencySymbol.text.white.lg.make(),
                                            vm.total
                                                .currencyValueFormat()
                                                .text
                                                .white
                                                .letterSpacing(1.5)
                                                .xl
                                                .semiBold
                                                .make(),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ).p20(),
                                ],
                              )
                                  .color(Colors.transparent)
                                  .box
                                  .make()
                                  .wFull(context)
                              // ServiceDetailsBottomSheet(vm),
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
                      //add to fav
                      // Positioned(
                      //   right: 20,
                      //   top: 180,
                      //   child: CustomButton(
                      //     elevation: 12,
                      //     color: Colors.deepOrange.withOpacity(.5),
                      //     // loading: model.isBusy,
                      //     child: Icon(
                      //       vm.service.isFavourite
                      //           ? FlutterIcons.heart_ant
                      //           : FlutterIcons.heart_fea,
                      //       color: Colors.white,
                      //     ),
                      //     onPressed: () {
                      //       !(vm.isAuthenticated() == true)
                      //           ? vm.openLogin()
                      //           : !(vm.service.isFavourite ?? false)
                      //               ? vm.addToFavourite()
                      //               : vm.removeFromFavourite();
                      //     },
                      //   ).cornerRadius(50).w(Vx.dp56).pOnly(right: Vx.dp24),
                      // ),
                    ],
                  ).scrollVertical(),
                ),
              ),
            ],
          ).box.color(Colors.transparent).make(),
          //
          // bottomNavigationBar: ServiceDetailsBottomSheet(vm),
        );
      },
    );
  }
}
