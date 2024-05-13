import 'package:flutter/material.dart';
import 'package:huops/constants/app_strings.dart';
import 'package:huops/models/vendor_type.dart';
import 'package:huops/utils/utils.dart';
import 'package:huops/view_models/vendor/banners.vm.dart';
import 'package:huops/widgets/cards/custom.visibility.dart';
import 'package:huops/widgets/list_items/banner.list_item.dart';
import 'package:huops/widgets/states/loading.shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Banners extends StatelessWidget {
  const Banners(
    this.vendorType, {
    this.viewportFraction = 1,
    this.showIndicators = false,
    this.featured = false,
    this.disableCenter = false,
    this.padding = 0,
    this.itemRadius,
    Key? key,
  }) : super(key: key);

  final VendorType? vendorType;
  final double viewportFraction;
  final bool showIndicators;
  final bool featured;
  final bool disableCenter;
  final double padding;
  final double? itemRadius;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BannersViewModel>.reactive(
      viewModelBuilder: () => BannersViewModel(
        context,
        vendorType,
        featured: featured,
      ),
      onViewModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return model.isBusy
            ? Padding(padding: EdgeInsets.only(top: 100) ,child: LoadingShimmer()).py20()
            : Visibility(
                visible: model.banners.isNotEmpty,
                child: Padding(
                  padding: EdgeInsets.all(0),
                  child: VStack(
                    [
                      CarouselSlider(
                        options: CarouselOptions(
                          autoPlayCurve: Curves.easeInOut,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          viewportFraction: viewportFraction,
                          autoPlay: true,
                          initialPage: 1,
                          height: (!model.isBusy && model.banners.length > 0)
                              ? (AppStrings.bannerHeight)
                              : 0.00,
                          disableCenter: disableCenter,
                          onPageChanged: (index, reason) {
                            model.currentIndex = index;
                            model.notifyListeners();
                          },
                        ),
                        items: model.banners.map(
                          (banner) {
                            return BannerListItem(
                              radius: itemRadius ?? 0.0,
                              imageUrl: banner.imageUrl ?? "",
                              onPressed: () => model.bannerSelected(banner),
                            );
                          },
                        ).toList(),
                      ),
                      //indicators
                      CustomVisibilty(
                        visible: model.banners.length <= 10 || showIndicators,
                        child: AnimatedSmoothIndicator(
                          activeIndex: model.currentIndex,
                          count: model.banners.length,
                          textDirection: Utils.isArabic
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          effect: ExpandingDotsEffect(
                            dotHeight: 6,
                            dotWidth: 10,
                            activeDotColor: context.primaryColor,
                          ),
                        ).centered().py8(),
                      ),
                    ],
                  ),
                ),
              );
      },
    );
  }
}
