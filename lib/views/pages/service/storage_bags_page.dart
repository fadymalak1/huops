import 'package:flutter/cupertino.dart';
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

import 'widgets/top_service_vendors.view.dart';

class StorageBagsPage extends StatefulWidget {
  const StorageBagsPage(this.vendorType, {Key? key}) : super(key: key);

  final VendorType vendorType;
  @override
  _StorageBagsPageState createState() => _StorageBagsPageState();
}

class _StorageBagsPageState extends State<StorageBagsPage>
    with AutomaticKeepAliveClientMixin<StorageBagsPage> {
  bool _isSortedByPopular = false;
  GlobalKey pageKey = GlobalKey<State>();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    //
    final mBannerHeight =
    (AppStrings.bannerHeight < (context.percentHeight * 35)
        ? context.percentHeight * 20
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
                // banner & search bar
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
                      ).h(mBannerHeight).pOnly(bottom: 20),
                      //
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
                              "Search Storage Bags".tr().text.lg.semiBold.make(),
                            ],
                          ).px12().expand(),
                        ],
                      ).px16().py4()
                          .box
                          .color(AppColor.primaryColor)
                          .roundedSM
                          .outerShadowSm
                          .make()
                          .onInkTap(() {model.openSearch(showType: 5);})
                          .px20().positioned(
                        left: 20,
                        right: 20,
                        bottom: 0,
                      ),
                    ],
                  ),
                  // alt: VStack(
                  //   [
                  //     //
                  //     HStack(
                  //       [
                  //         Icon(
                  //           FlutterIcons.search_fea,
                  //           size: 24,
                  //         )
                  //             .p8()
                  //             .onInkTap(() {
                  //           model.openSearch(showType: 5);
                  //         })
                  //             .box
                  //             .roundedSM
                  //         // .clip(Clip.antiAlias)
                  //         // .color(AppColor.primaryColor)
                  //         // .shadowXs
                  //             .make(),
                  //         VStack(
                  //           [
                  //             "Search Storage Bags".tr().text.lg.semiBold.make(),
                  //           ],
                  //         ).px12().expand(),
                  //
                  //
                  //       ],
                  //     ).px16().py4()
                  //         .box
                  //         .color(AppColor.primaryColor)
                  //         .roundedSM
                  //         .outerShadowSm
                  //         .make().onInkTap(() {
                  //       model.openSearch(showType: 5);
                  //     }).px20().positioned(left: 20, right: 20, bottom: 0,),
                  //     //
                  //     SimpleStyledBanners(
                  //       widget.vendorType,
                  //       height: AppStrings.bannerHeight,
                  //     ).py12(),
                  //   ],
                  // ),
                ),

                // //categories
                // VendorTypeCategories(
                //   widget.vendorType,
                //   showTitle: false,
                //   description: "Categories",
                //   childAspectRatio: 1.4,
                //   crossAxisCount: 4,
                // ),

                10.heightBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // sort
                    InkWell(
                      onTap: (){
                        showDialog(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(builder: (context, setState) {
                                return Dialog(
                                  backgroundColor: Colors.transparent,
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height * .3,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: SingleChildScrollView(
                                        physics: const BouncingScrollPhysics(),
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              10.heightBox,
                                              "Sorted by".tr().text.xl.white.make(),
                                              20.heightBox,
                                              InkWell(
                                                onTap: (){
                                                  setState((){
                                                    _isSortedByPopular = false;
                                                  });
                                                  model.getVendors();
                                                  Navigator.pop(context);
                                                  model.reloadPage();
                                                },
                                                child: Container(
                                                  width: MediaQuery.of(context).size.width *.5,
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: AppColor.primaryColor),
                                                  child: "Sorted by name ".tr().text.lg.white.make().centered(),
                                                ),
                                              ),
                                              10.heightBox,
                                              InkWell(
                                                onTap: (){
                                                  setState((){
                                                    _isSortedByPopular = true;
                                                  });
                                                  Navigator.pop(context);
                                                  model.reloadPage();
                                                },
                                                child: Container(
                                                  width: MediaQuery.of(context).size.width *.5,
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: AppColor.primaryColor),
                                                  child: "Sorted by popular ".tr().text.lg.white.make().centered(),
                                                ),
                                              ),
                                              10.heightBox,
                                              InkWell(
                                                onTap: (){
                                                  setState((){
                                                    _isSortedByPopular = false;
                                                  });
                                                  Navigator.pop(context);
                                                  model.pickDeliveryAddress(
                                                    vendorCheckRequired: false,
                                                    onselected:  model.reloadPage,
                                                  );
                                                },
                                                child: Container(
                                                  width: MediaQuery.of(context).size.width *.5,
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: AppColor.primaryColor),
                                                  child: "Sorted by location ".tr().text.lg.white.make().centered(),
                                                ),
                                              ),
                                              10.heightBox,
                                            ]),
                                      ),
                                    ),
                                  ).glassMorphic(circularRadius: 20,),
                                );
                              });
                            });
                      },
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            height: 35,width: 35,
                            child: Icon(CupertinoIcons.arrow_up_arrow_down,color: Colors.white,)
        ,
                          ),
                          "Sort".tr().text.xl.white.make(),
                        ],
                      ),
                    ),
                    // //filter
                    // InkWell(
                    //   onTap: (){},
                    //   child: Row(
                    //     children: [
                    //       Container(
                    //         padding: EdgeInsets.all(8),
                    //         height: 40,width: 35,
                    //         child: Icon(Icons.filter_list_outlined,color: Colors.white,),
                    //       ),
                    //       "Filter".tr().text.xl.white.make(),
                    //     ],
                    //   ),
                    // ),
                    // map
                    InkWell(
                      onTap: (){
                        model.pickDeliveryAddress(
                          vendorCheckRequired: false,
                          onselected:  model.reloadPage,
                        );
                      },
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            height: 35,width: 35,
                            child: Icon(CupertinoIcons.map,color: Colors.white,)
                          ),
                          "Map".tr().text.xl.white.make(),
                        ],
                      ),
                    ),
                  ],
                ),

                //vendors
                TopServiceVendors(widget.vendorType,isStorageBagType: true,isSortedByPopular: _isSortedByPopular),

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
