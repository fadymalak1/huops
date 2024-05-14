import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/models/vendor.dart';
import 'package:huops/view_models/service_vendor_details.vm.dart';
import 'package:huops/view_models/vendor_details.vm.dart';
import 'package:huops/views/pages/vendor_details/panorama_viewer.dart';
import 'package:huops/views/pages/vendor_details/widgets/vendor_details_header.view.dart';
import 'package:huops/widgets/custom_masonry_grid_view.dart';
import 'package:huops/widgets/list_items/grid_view_service.list_item.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:swipe_image_gallery/swipe_image_gallery.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../models/vendor_images.dart';
import '../../../utils/ui_spacer.dart';
import '../../../widgets/busy_indicator.dart';
import '../../../widgets/cards/custom.visibility.dart';
import '../../../widgets/custom_list_view.dart';
import '../../../widgets/list_items/horizontal_product.list_item.dart';

class ServiceVendorDetailsPage extends StatelessWidget {
  ServiceVendorDetailsPage(
    this.vendorDetailsViewModel, {
    required this.vendor,
    Key? key,
  }) : super(key: key);

  final Vendor vendor;
  final VendorDetailsViewModel vendorDetailsViewModel;


  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ServiceVendorDetailsViewModel>.reactive(
      viewModelBuilder: () => ServiceVendorDetailsViewModel(context, vendor),
      onViewModelReady: (model) => model.getVendorServices(),
      builder: (context, model, child) {
        return VStack(
          [
            //
            VendorDetailsHeader(vendorDetailsViewModel,isDelivery: false),

            Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomVisibilty(
                    visible: model.vendor!.name.isNotEmptyAndNotNull,
                    child: Text(
                      "${model.vendor!.name}",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  ).wTwoThird(context),
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
                ],
              ),
            ),

            // images & image 360
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




            model.vendor?.vendorTypeId != 13 ? SizedBox() :
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10)
              ),
              child: "Beauty Center Services".tr().text.white.extraBold.make(),
            ).glassMorphic(opacity: .1).pOnly(right: 20,left: 20,top: 10),

            model.vendor?.vendorTypeId == 15 ? 30.heightBox:SizedBox(),
            model.vendor?.vendorTypeId != 15 ? SizedBox() :
            Container(
              padding: EdgeInsets.symmetric(vertical: 15,horizontal: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColor.primaryColor,
              ),
              child: "Storage Bags Services".tr().text.white.extraBold.make(),
            ).centered().onTap(() {
              model.StorageBags(vendor.id);
            }),

            //services of the vendor
            model.vendor?.vendorTypeId == 15 ? SizedBox() : CustomMasonryGridView(
              isLoading: model.isBusy,
              crossAxisSpacing: 10,
              mainAxisSpacing: 20,
              childAspectRatio: 1.1,
              crossAxisCount: 2,
              items: model.services
                  .map(
                    (service) => GridViewServiceListItem(
                      service: service,
                      onPressed: model.servicePressed,
                    ),
                  )
                  .toList(),
            ).p20(),
          ],
        ).scrollVertical().expand();
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