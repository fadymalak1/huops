import 'package:flutter/cupertino.dart';
import 'package:huops/constants/app_routes.dart';
import 'package:huops/constants/app_strings.dart';
import 'package:huops/models/vendor.dart';
import 'package:huops/models/vendor_type.dart';
import 'package:huops/requests/vendor.request.dart';
import 'package:huops/view_models/base.view_model.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../requests/favourite.request.dart';

class TopVendorsViewModel extends MyBaseViewModel {
  TopVendorsViewModel(
    BuildContext context,
    this.vendorType, {
    this.params,
    this.enableFilter = true,
  }) {
    this.viewContext = context;
  }

  //
  List<Vendor> vendors = [];
  List<Vendor> vendorsStorageBags = [];
  final VendorType vendorType;
  final Map<String, dynamic>? params;

  int selectedType = 1;
  final bool enableFilter;

  //fav
  FavouriteRequest favouriteRequest = FavouriteRequest();
  bool isFav=false;
  getFavStatus(Vendor? vendor)async{
    isFav=await _vendorRequest.getFavStatus(vendor!.id);
    notifyListeners();
  }

  Future<bool> addToFav(Vendor? vendor)async{
    bool result= await _vendorRequest.addToFav(vendor!.id);
    notifyListeners();
    return result;
  }
  processRemoveVendor(Vendor? vendor, context) async {
    setBusy(true);
    //
    final apiResponse = await favouriteRequest.removeFavouriteVendor(
      vendor!.id,
    );
    setBusy(false);
  }

  //
  VendorRequest _vendorRequest = VendorRequest();

  //
  initialise() {
    //
    fetchVendorsStorageBags();
    fetchTopVendors();
  }

  //
  fetchVendorsStorageBags() async {
    setBusy(true);
    try {
      //filter by location if user selects delivery address
      vendorsStorageBags = await _vendorRequest.topVendorsRequest(
        // byLocation: AppStrings.enableFatchByLocation,
        params: {
          "vendor_type_id": vendorType.id,
          ...?(params != null ? {} : {})
        },
      );

      //
      // if (enableFilter) {
      //   if (selectedType == 2) {
      //     vendorsStorageBags = vendors.filter((e) => e.pickup == 1).toList();
      //   } else if (selectedType == 1) {
      //     vendorsStorageBags = vendors.filter((e) => e.delivery == 1).toList();
      //   }
      // }
      clearErrors();
    } catch (error) {
      print("error ==> $error");
      setError(error);
      toastError("$error");
    }
    setBusy(false);
  }

  //
  fetchTopVendors() async {
    setBusy(true);
    try {
      //filter by location if user selects delivery address
      vendors = await _vendorRequest.topVendorsRequest(
        byLocation: AppStrings.enableFatchByLocation,
        params: {
          "vendor_type_id": vendorType.id,
          ...?(params != null ? params : {})
        },
      );

      //
      if (enableFilter) {
        if (selectedType == 2) {
          vendors = vendors.filter((e) => e.pickup == 1).toList();
        } else if (selectedType == 1) {
          vendors = vendors.filter((e) => e.delivery == 1).toList();
        }
      }
      clearErrors();
    } catch (error) {
      print("error ==> $error");
      setError(error);
      toastError("$error");
    }
    setBusy(false);
  }

  //
  changeType(int type) {
    selectedType = type;
    fetchTopVendors();
  }

  vendorSelected(Vendor vendor) async {
    //navigate to vendor details
    Navigator.of(viewContext).pushNamed(
      AppRoutes.vendorDetails,
      arguments: vendor,
    );
  }
}
