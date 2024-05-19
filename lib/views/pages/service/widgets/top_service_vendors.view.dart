
import 'package:double_back_to_close/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huops/models/vendor_type.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/view_models/vendor/top_vendors.vm.dart';
import 'package:huops/widgets/busy_indicator.dart';
import 'package:huops/widgets/custom_grid_view.dart';
import 'package:huops/widgets/list_items/top_service_vendor.list_item.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../constants/app_colors.dart';
import '../../../../widgets/buttons/route.button.dart';
import '../../../../widgets/custom_image.view.dart';

class TopServiceVendors extends StatelessWidget {
  const TopServiceVendors(
    this.vendorType, {
    Key? key, required this.isStorageBagType,this.isSortedByPopular = false,
  }) : super(key: key);

  final VendorType vendorType;
  final bool isStorageBagType;
  final bool isSortedByPopular;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TopVendorsViewModel>.reactive(
      viewModelBuilder: () => TopVendorsViewModel(
        context,
        vendorType,
        params: {"type": "rated"},
        enableFilter: false,
      ),
      onViewModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return isStorageBagType ? VStack(
          [
            Visibility(
              visible: model.isBusy,
              child: BusyIndicator().centered(),
            ),
            //
            Visibility(
              visible: model.vendorsStorageBags.isNotEmpty,
              child: VStack(
                [
                  //
                  // UiSpacer.vSpace(),
                  UiSpacer.vSpace(10),
                  //vendorsStorageBags list
                  CustomGridView(
                    noScrollPhysics: true,
                    dataSet: isSortedByPopular == true ? model.vendors : model.vendorsStorageBags,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 0,
                    crossAxisCount: 1,
                    childAspectRatio:MediaQuery.of(context).size.width < 390 ? 9/4 : 9/3,//2.7
                    itemBuilder: (context, index) {
                      //
                      final vendor = isSortedByPopular == true ? model.vendors[index]  : model.vendorsStorageBags[index];
                      // model.getFavStatus(vendor);
                      return Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomImage(
                              imageUrl: vendor.logo,
                              height: 100,
                              width: 100,
                            ).box.roundedSM.clip(Clip.antiAlias).make(),
                            10.widthBox,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //name
                                vendor.name.text.xl.bold.maxLines(1).color(AppColor.primaryColor).ellipsis.make(),

                                Text(vendor.description.toString(),style: TextStyle(fontSize: 12,color: Colors.grey),maxLines: 2,overflow: TextOverflow.ellipsis).text.make().wOneThird(context),
                                SizedBox(height: 5,),
                                // Expanded(child: Text(vendor.address,style: TextStyle(fontSize: 12),maxLines: 2,overflow: TextOverflow.ellipsis).text.make().wOneThird(context)),
                                15.heightBox,
                                VxRating(
                                  maxRating: 5.0,
                                  value: double.parse(vendor.rating.toString()),
                                  isSelectable: false,
                                  onRatingUpdate: (value) {},
                                  selectionColor: AppColor.ratingColor,
                                  size: 15,
                                ).p4().glassMorphic(),
                              ],
                            ),
                            Spacer(),
                            IconButton(
                              onPressed: () async {
                                if (await MapLauncher.isMapAvailable(MapType.google) ?? false) {
                                  await MapLauncher.showDirections(
                                    mapType: MapType.google,
                                    destination: Coords(
                                      double.parse(vendor.latitude),
                                      double.parse(vendor.longitude),
                                    ),
                                    destinationTitle: vendor.name,
                                  );
                                }
                              },
                              icon: CircleAvatar(backgroundColor: AppColor.primaryColor,child: Icon(Icons.location_on,color: Colors.white, size: 20,)),
                            )
                          ],
                        ),
                      ).p12().glassMorphic(opacity: .1).onTap(() => model.vendorSelected(vendor));
                    },
                  ).px20(),
                ],
              ).py12(),
            ),
          ],
        ) : VStack(
          [
            Visibility(
              visible: model.isBusy,
              child: BusyIndicator().centered(),
            ),
            //
            Visibility(
              visible: model.vendors.isNotEmpty,
              child: VStack(
                [
                  //
                  // UiSpacer.vSpace(),
                  "Top Rated".tr().text.lg.medium.make().px20(),
                  UiSpacer.vSpace(10),
                  //vendors list
                  CustomGridView(
                    noScrollPhysics: true,
                    dataSet: model.vendors,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    crossAxisCount: 3,
                    itemBuilder: (context, index) {
                      //
                      final vendor = model.vendors[index];
                      return TopServiceVendorListItem(
                        vendor: vendor,
                        onPressed: model.vendorSelected,
                      );
                    },
                  ).px20(),
                ],
              ).py12(),
            ),
          ],
        );
      },
    );
  }
}

