import 'dart:developer';

import 'package:double_back_to_close/toast.dart';
import 'package:flutter/material.dart';
import 'package:huops/constants/app_routes.dart';
import 'package:huops/models/vendor.dart';
import 'package:huops/models/product.dart';
import 'package:huops/models/vendor_images.dart';
import 'package:huops/requests/favourite.request.dart';
import 'package:huops/requests/vendor.request.dart';
import 'package:huops/constants/app_strings.dart';
import 'package:huops/view_models/base.view_model.dart';
import 'package:huops/views/pages/pharmacy/pharmacy_upload_prescription.page.dart';
import 'package:huops/views/pages/vendor_search/vendor_search.page.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:velocity_x/velocity_x.dart';

class VendorDetailsViewModel extends MyBaseViewModel {
  //
  VendorDetailsViewModel(
    BuildContext context,
    this.vendor,
  ) {
    this.viewContext = context;
  }

  //
  VendorRequest _vendorRequest = VendorRequest();
  // VendorImages vendorImages=VendorImages();

  //
  FavouriteRequest favouriteRequest = FavouriteRequest();
  Vendor? vendor;
  TabController? tabBarController;
  final currencySymbol = AppStrings.currencySymbol;

  RefreshController refreshContoller = RefreshController();
  List<RefreshController> refreshContollers = [];
  List<int> refreshContollerKeys = [];
  bool isFav=false;

  //
  Map<int, List> menuProducts = {};
  Map<int, int> menuProductsQueryPages = {};

  //
  void getVendorDetails() async {
    //
    setBusy(true);
    getFavStatus();
    // await getVendorImages();


    try {
      vendor = await _vendorRequest.vendorDetails(
        vendor!.id,
        params: {
          "type": "small",
        },
      );

      clearErrors();
    } catch (error) {
      setError(error);
      print("error ==> ${error}");
    }
    setBusy(false);
  }

  void productSelected(Product product) async {
    await Navigator.of(viewContext).pushNamed(
      AppRoutes.product,
      arguments: product,
    );

    //
    notifyListeners();
  }
  //
  // getVendorImages() async {
  //   //
  //   vendorImages = await _vendorRequest.getVendorImages(vendor!.id);
  //   notifyListeners();
  // }

  makeBook(int? vendorId ,  String? date ,  String? time , int? cont,int? countTable)async {
    Navigator.of(viewContext).pop();


    setBusy(true);
    bool result = await _vendorRequest.makeBookTable(vendorId ,  date ,   time ,  cont,countTable);
    setBusy(false);
    result?Toast.show("Table Booked Successfully",viewContext, duration: 2, gravity: Toast.bottom):Toast.show("Something went wrong",viewContext, duration: 2, gravity: Toast.bottom);
  }
  //
  processRemoveVendor(Vendor? vendor, context) async {
    setBusy(true);
    //
    final apiResponse = await favouriteRequest.removeFavouriteVendor(
      vendor!.id,
    );

    // //remove from list
    // if (apiResponse.allGood) {
    //   isFav=false;
    //   notifyListeners();
    // }

    setBusy(false);

    // CoolAlert.show(
    //   context: viewContext,
    //   type: apiResponse.allGood ? CoolAlertType.success : CoolAlertType.error,
    //   title: "Remove Vendor From Favourite".tr(),
    //   text: apiResponse.message,
    //   confirmBtnTextStyle: TextStyle(color: Colors.black),
    // );
  }

  void uploadPrescription() {
    //
    viewContext.push(
      (context) => PharmacyUploadPrescription(vendor!),
    );
  }

  openVendorSearch() {
    viewContext.push(
      (context) => VendorSearchPage(vendor!),
    );
  }

  getFavStatus()async{
    isFav=await _vendorRequest.getFavStatus(vendor!.id);
    notifyListeners();
  }

  Future<bool> addToFav()async{
    bool result= await _vendorRequest.addToFav(vendor!.id);
    notifyListeners();
    return result;
  }

}
