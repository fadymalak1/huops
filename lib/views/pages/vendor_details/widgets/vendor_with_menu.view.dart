import 'dart:developer';

import 'package:double_back_to_close/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/constants/app_ui_settings.dart';
import 'package:huops/models/vendor.dart';
import 'package:huops/models/vendor_images.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/view_models/vendor_menu_details.vm.dart';
import 'package:huops/views/pages/search/main_search.page.dart';
import 'package:huops/views/pages/vendor/vendor_reviews.page.dart';
import 'package:huops/views/pages/vendor_details/panorama_viewer.dart';
import 'package:huops/views/pages/vendor_details/widgets/upload_prescription.btn.dart';
import 'package:huops/views/pages/vendor_details/widgets/vendor_details_header.view.dart';
import 'package:huops/widgets/base.page.withoutNavbar.dart';
import 'package:huops/widgets/busy_indicator.dart';
import 'package:huops/widgets/buttons/call.button.dart';
import 'package:huops/widgets/buttons/custom_leading.dart';
import 'package:huops/widgets/buttons/route.button.dart';
import 'package:huops/widgets/buttons/share.btn.dart';
import 'package:huops/widgets/buttons/time.button.dart';
import 'package:huops/widgets/cards/custom.visibility.dart';
import 'package:huops/widgets/cart_page_action.dart';
import 'package:huops/widgets/custom_image.view.dart';
import 'package:huops/widgets/custom_list_view.dart';
import 'package:huops/widgets/list_items/horizontal_product.list_item.dart';
import 'package:huops/widgets/states/loading.shimmer.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:swipe_image_gallery/swipe_image_gallery.dart';
import 'package:velocity_x/velocity_x.dart';

class VendorDetailsWithMenuPage extends StatefulWidget {
  VendorDetailsWithMenuPage({
    required this.vendor,
    Key? key,
  }) : super(key: key);

  final Vendor vendor;

  @override
  _VendorDetailsWithMenuPageState createState() =>
      _VendorDetailsWithMenuPageState();
}

class _VendorDetailsWithMenuPageState extends State<VendorDetailsWithMenuPage>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<VendorDetailsWithMenuViewModel>.reactive(
      viewModelBuilder: () =>
          VendorDetailsWithMenuViewModel(
            context,
            widget.vendor,
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
          body: Column(
            children: [
              VendorDetailsHeader(model),
              Expanded(
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      floating: true,
                      toolbarHeight: 0,
                      pinned: false,
                      primary: true,
                      snap: false,
                      elevation: 0,
                      automaticallyImplyLeading: false,
                      backgroundColor: Colors.transparent,
                      expandedHeight: model.vendorImages.panorama!=null?MediaQuery.of(context).size.height*0.36:MediaQuery.of(context).size.height*0.10,
                      flexibleSpace: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              height: 1,
                              color: Colors.grey.withOpacity(0.5),
                            ).wTwoThird(context).py12(),
                            CustomVisibilty(
                              visible: model.vendor!.description.isNotEmptyAndNotNull,
                              child: Text(
                                "${model.vendor!.description}",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                maxLines: 2,
                                textAlign: TextAlign.center,
                              ),
                            ).wTwoThird(context),

                            CustomVisibilty(
                              visible: model.vendor!.address.isNotEmptyAndNotNull,
                              child: Text(
                                "${model.vendor!.address}",
                                style: TextStyle(
                                  fontSize: 12,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                maxLines: 2,
                                textAlign: TextAlign.center,
                              ),
                            ).wTwoThird(context),
                            RatingBar(
                              itemSize: 14,
                              initialRating: model.vendor!.rating.toDouble(),
                              ignoreGestures: true,
                              ratingWidget: RatingWidget(
                                full: Icon(
                                  FlutterIcons.ios_star_ion,
                                  size: 12,
                                  color: Colors.yellow[800],
                                ),
                                half: Icon(
                                  FlutterIcons.ios_star_half_ion,
                                  size: 12,
                                  color: Colors.yellow[800],
                                ),
                                empty: Icon(
                                  FlutterIcons.ios_star_ion,
                                  size: 12,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              onRatingUpdate: (value) {},
                            ).pOnly(right: 2),
                            SizedBox(height: 15,),
                            model.vendorImages.panorama!=null?Column(
                                children: [
                                  GestureDetector(
                                    onTap:(){
                                      Navigator.push(
                                        context,MaterialPageRoute(builder: (context) => Panorama360( panorama: model.vendorImages.panorama??Panorama(),),)
                                      );
                                    },
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Stack(
                                          fit: StackFit.loose,
                                          alignment: Alignment.center,
                                          children: [
                                            Image.network("${model.vendorImages.panorama!.panorama}",fit: BoxFit.cover,).hFull(context),
                                            Image.asset("assets/images/360.png",width: 50,  opacity: const AlwaysStoppedAnimation(.5),),
                                          ],
                                        ),),
                                  ).expand(),
                                  SizedBox(height: 10,),
                                  SizedBox(
                                    height:100,
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder:(context, index) => GestureDetector(
                                        onTap: (){
                                          SwipeImageGallery(
                                            context: context,
                                            itemBuilder: (context, index) {
                                              return Image.network("${model.vendorImages.images![index].image}");
                                            },
                                            itemCount:model.vendorImages.images!.length,
                                          ).show();
                                        },
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: Image.network("${model.vendorImages.images![index].image}",width: 100,fit: BoxFit.cover,)),
                                      ),
                                      separatorBuilder: (context, index) => SizedBox(width: 10,),
                                      itemCount: model.vendorImages.images!.length,
                                    ),
                                  ),
                                ]
                            ).wh24(context).p12().wFourFifth(context).glassMorphic(opacity: 0.1):SizedBox(),
                            //menu
                          ],
                        ),
                      ),
                    ),
                
                    SliverPersistentHeader(
                      delegate: _SliverAppBarDelegate(
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
                        ),
                      ),
                      pinned: true, // Keep the tab bar pinned at the top
                    ),
                    SliverFillRemaining(
                      child:Container(
                        height: MediaQuery.of(context).size.height,
                        child: model.isBusy
                            ? BusyIndicator().p20().centered()
                            : TabBarView(
                          controller: model.tabBarController,
                          children: model.vendor!.menus.map(
                                (menu) {
                              return  CustomListView(
                                noScrollPhysics: false,
                                refreshController:
                                model.getRefreshController(menu.id),
                                canPullUp: true,
                                canRefresh: true,
                                dataSet: model.menuProducts[menu.id] ?? [],
                                isLoading: model.busy(menu.id),
                                onLoading: () => model.loadMoreProducts(
                                  menu.id,
                                  initialLoad: false,
                                ),
                                onRefresh: () =>
                                    model.loadMoreProducts(menu.id),
                                itemBuilder: (context, index) {
                                  final product =
                                  model.menuProducts[menu.id]?[index];
                                  return HorizontalProductListItem(
                                    product,
                                    onPressed: model.productSelected,
                                    qtyUpdated: model.addToCartDirectly,
                                  ).px20();
                                },
                                separatorBuilder: (context, index) =>
                                    UiSpacer.verticalSpace(space: 0),
                              );
                            },
                          ).toList(),
                          physics: BouncingScrollPhysics(),
                        ),
                      ),
                    ),
                
                
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      child: _tabBar,
    ).glassMorphic().px24();
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return true;
  }
}