import 'package:flutter/material.dart';
import 'package:huops/constants/app_strings.dart';
import 'package:huops/models/search.dart';
import 'package:huops/models/vendor_type.dart';
import 'package:huops/view_models/vendor/section_vendors.vm.dart';
import 'package:huops/widgets/cards/custom.visibility.dart';
import 'package:huops/widgets/custom_list_view.dart';
import 'package:huops/widgets/list_items/food_vendor.list_item.dart';
import 'package:huops/widgets/list_items/horizontal_vendor.list_item.dart';
import 'package:huops/widgets/list_items/vendor.list_item.dart';
import 'package:huops/widgets/section.title.dart';
import 'package:huops/widgets/states/vendor.empty.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class SectionVendorsView extends StatefulWidget {
  const SectionVendorsView(
    this.vendorType, {
    this.title = "",
    this.scrollDirection = Axis.vertical,
    this.type = SearchFilterType.sales,
    this.itemWidth,
    this.viewType,
    this.separator,
    this.byLocation = false,
    this.itemsPadding,
    this.titlePadding,
    this.hideEmpty = false,
    Key? key,
  }) : super(key: key);

  final VendorType? vendorType;
  final Axis scrollDirection;
  final SearchFilterType type;
  final String title;
  final double? itemWidth;
  final dynamic viewType;
  final Widget? separator;
  final bool byLocation;
  final EdgeInsets? itemsPadding;
  final EdgeInsets? titlePadding;
  final bool hideEmpty;

  @override
  State<SectionVendorsView> createState() => _SectionVendorsViewState();
}

class _SectionVendorsViewState extends State<SectionVendorsView> {
  @override
  Widget build(BuildContext context) {
    return CustomVisibilty(
      visible: !AppStrings.enableSingleVendor,
      child: ViewModelBuilder<SectionVendorsViewModel>.reactive(
        viewModelBuilder: () => SectionVendorsViewModel(
          context,
          widget.vendorType,
          type: widget.type,
          byLocation: widget.byLocation,
        ),
        onViewModelReady: (model) => model.initialise(),
        builder: (context, model, child) {
          //
          Widget listView = CustomListView(
            scrollDirection: widget.scrollDirection,
            padding:
                widget.itemsPadding ?? EdgeInsets.symmetric(horizontal: 10),
            dataSet: model.vendors,
            isLoading: model.isBusy,
            noScrollPhysics: widget.scrollDirection != Axis.horizontal,
            itemBuilder: (context, index) {
              //
              final vendor = model.vendors[index];
              //
              if (widget.viewType != null &&
                  widget.viewType == HorizontalVendorListItem) {
                return HorizontalVendorListItem(
                  vendor,
                  onPressed: model.vendorSelected,
                );
              } else {
                //
                return VendorListItem(
                  vendor: vendor,
                  onPressed: model.vendorSelected,
                ).w(widget.itemWidth ?? (context.percentWidth * 50));
              }
            },
            emptyWidget: EmptyVendor(),
            separatorBuilder: widget.separator != null
                ? (ctx, index) => widget.separator!
                : null,
          ).py8().glassMorphic(borderRadius: (widget.viewType != null &&
              widget.viewType == HorizontalVendorListItem)?BorderRadius.circular(12):BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),);

          //
          return Visibility(
            visible: !widget.hideEmpty || (model.vendors.isNotEmpty),
            child: VStack(
              [
                //
                Visibility(
                  visible: widget.title.isNotBlank,
                  child: Padding(
                    padding: widget.titlePadding ?? EdgeInsets.all(0),
                    child: SectionTitle("${widget.title}"),
                  ),
                ),

                //vendors list
                if (model.vendors.isEmpty)
                  listView.h(model.vendors.isEmpty ? 240 : 195).wFull(context)
                else if (widget.scrollDirection == Axis.horizontal)
                  listView.h(200).wFull(context)
                else
                  listView.wFull(context)
              ],
            ),
          );
        },
      ),
    );
  }
}
